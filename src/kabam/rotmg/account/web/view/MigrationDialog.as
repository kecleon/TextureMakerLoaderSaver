 
package kabam.rotmg.account.web.view {
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import kabam.rotmg.account.core.Account;
	import kabam.rotmg.account.core.view.EmptyFrame;
	import kabam.rotmg.appengine.api.AppEngineClient;
	import kabam.rotmg.appengine.impl.SimpleAppEngineClient;
	import kabam.rotmg.core.StaticInjectorContext;
	import kabam.rotmg.dialogs.control.CloseDialogsSignal;
	import kabam.rotmg.util.components.SimpleButton;
	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeMappedSignal;
	
	public class MigrationDialog extends EmptyFrame {
		 
		
		public var done:Signal;
		
		private var okButton:Signal;
		
		private var account:Account;
		
		private var client:AppEngineClient;
		
		private var progressCheckClient:AppEngineClient;
		
		private var lastPercent:Number = 0;
		
		private var total:Number = 100;
		
		private var progBar:ProgressBar;
		
		protected var leftButton_:SimpleButton;
		
		protected var rightButton_:SimpleButton;
		
		private var timerProgressCheck:Timer;
		
		private var status:Number = 0;
		
		private var isClosed:Boolean;
		
		public function MigrationDialog(param1:Account, param2:Number) {
			this.timerProgressCheck = new Timer(2000,0);
			super(500,220,"Maintenance Needed");
			this.isClosed = false;
			setDesc("Press OK to begin maintenance on \n\n" + param1.getUserName() + "\n\nor cancel to login with a different account",true);
			this.makeAndAddLeftButton("Cancel");
			this.makeAndAddRightButton("OK");
			this.account = param1;
			this.status = param2;
			this.client = StaticInjectorContext.getInjector().getInstance(AppEngineClient);
			this.okButton = new NativeMappedSignal(this.rightButton_,MouseEvent.CLICK);
			cancel = new NativeMappedSignal(this.leftButton_,MouseEvent.CLICK);
			this.done = new Signal();
			this.okButton.addOnce(this.okButton_doMigrate);
			this.done.addOnce(this.closeMyself);
			cancel.addOnce(this.removeMigrateCallback);
			cancel.addOnce(this.closeMyself);
		}
		
		private function okButton_doMigrate() : void {
			var loc1:Object = null;
			this.rightButton_.setEnabled(false);
			if(this.status == 1) {
				loc1 = this.account.getCredentials();
				this.client.complete.addOnce(this.onMigrateStartComplete);
				this.client.sendRequest("/migrate/doMigration",loc1);
			}
		}
		
		private function startPercentLoop() : void {
			this.timerProgressCheck.addEventListener(TimerEvent.TIMER,this.percentLoop);
			if(this.progressCheckClient == null) {
				this.progressCheckClient = StaticInjectorContext.getInjector().getInstance(SimpleAppEngineClient);
			}
			this.timerProgressCheck.start();
			this.updatePercent(0);
		}
		
		private function stopPercentLoop() : void {
			this.updatePercent(100);
			this.timerProgressCheck.stop();
			this.timerProgressCheck.removeEventListener(TimerEvent.TIMER,this.percentLoop);
		}
		
		private function percentLoop(param1:TimerEvent) : void {
			var loc2:Object = this.account.getCredentials();
			this.progressCheckClient.complete.addOnce(this.onUpdateStatusComplete);
			this.progressCheckClient.sendRequest("/migrate/progress",loc2);
		}
		
		private function onUpdateStatusComplete(param1:Boolean, param2:*) : void {
			var loc3:XML = null;
			var loc4:String = null;
			var loc5:Number = NaN;
			var loc6:Number = NaN;
			if(param1) {
				if(this.isClosed == true) {
					return;
				}
				loc3 = new XML(param2);
				if(loc3.hasOwnProperty("Percent")) {
					loc4 = loc3.Percent;
					loc5 = Number(loc4);
					if(loc5 == 100) {
						if(this.isClosed == false) {
							this.stopPercentLoop();
							this.updatePercent(loc5);
							this.done.dispatch();
						}
					} else if(loc5 != this.lastPercent) {
						this.updatePercent(loc5);
					}
				} else if(loc3.hasOwnProperty("MigrateStatus")) {
					loc6 = loc3.MigrateStatus;
					if(loc6 == 44) {
						this.stopPercentLoop();
						this.reset();
					}
				}
			}
		}
		
		private function updatePercent(param1:Number) : void {
			this.progBar.update(param1);
			this.lastPercent = param1;
			setDesc("" + param1 + "%",true);
		}
		
		private function onMigrateStartComplete(param1:Boolean, param2:*) : void {
			var loc3:XML = null;
			var loc4:Number = NaN;
			if(this.isClosed) {
				return;
			}
			if(param1) {
				loc3 = new XML(param2);
				if(loc3.hasOwnProperty("MigrateStatus")) {
					loc4 = loc3.MigrateStatus;
					if(loc4 == 44) {
						this.stopPercentLoop();
						this.reset();
					} else if(loc4 == 4) {
						this.addProgressBar();
						setTitle("Migration In Progress",true);
						this.startPercentLoop();
					} else {
						this.stopPercentLoop();
						this.reset();
					}
				}
			} else {
				this.stopPercentLoop();
				this.reset();
			}
		}
		
		private function reset() : void {
			setTitle("Error, please try again. Maintenance needed",true);
			setDesc("Press OK to begin maintenance on \n\n" + this.account.getUserName() + "\n\nor cancel to login with a different account",true);
			this.removeProgressBar();
			this.okButton.addOnce(this.okButton_doMigrate);
			this.rightButton_.setEnabled(true);
		}
		
		private function addProgressBar() : void {
			var loc2:Number = NaN;
			this.removeProgressBar();
			var loc1:Number = TEXT_MARGIN;
			loc2 = modalHeight / 3;
			var loc3:Number = modalWidth - loc1 * 2;
			var loc4:Number = 40;
			this.progBar = new ProgressBar(loc3,loc4);
			addChild(this.progBar);
			this.progBar.x = loc1;
			this.progBar.y = loc2;
		}
		
		private function removeProgressBar() : void {
			if(this.progBar != null && this.progBar.parent != null) {
				removeChild(this.progBar);
			}
		}
		
		private function removeMigrateCallback() : void {
			this.done.removeAll();
		}
		
		private function closeMyself() : void {
			this.isClosed = true;
			var loc1:CloseDialogsSignal = StaticInjectorContext.getInjector().getInstance(CloseDialogsSignal);
			loc1.dispatch();
		}
		
		private function makeAndAddLeftButton(param1:String) : void {
			this.leftButton_ = new SimpleButton(param1);
			if(param1 != "") {
				this.leftButton_.buttonMode = true;
				addChild(this.leftButton_);
				this.leftButton_.x = modalWidth / 2 - 100 - this.leftButton_.width;
				this.leftButton_.y = modalHeight - 50;
			}
		}
		
		private function makeAndAddRightButton(param1:String) : void {
			this.rightButton_ = new SimpleButton(this.leftButton_.text.text);
			this.rightButton_.freezeSize();
			this.rightButton_.setText(param1);
			if(param1 != "") {
				this.rightButton_.buttonMode = true;
				addChild(this.rightButton_);
				this.rightButton_.x = modalWidth / 2 + 100;
				this.rightButton_.y = modalHeight - 50;
			}
		}
	}
}
