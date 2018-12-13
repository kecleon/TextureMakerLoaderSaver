 
package kabam.rotmg.classes.view {
	import com.company.assembleegameclient.constants.ScreenTypes;
	import com.company.assembleegameclient.screens.AccountScreen;
	import com.company.assembleegameclient.screens.TitleMenuOption;
	import com.company.rotmg.graphics.ScreenGraphic;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	import kabam.rotmg.core.StaticInjectorContext;
	import kabam.rotmg.core.model.PlayerModel;
	import kabam.rotmg.game.view.CreditDisplay;
	import kabam.rotmg.text.view.TextFieldDisplayConcrete;
	import kabam.rotmg.ui.view.SignalWaiter;
	import kabam.rotmg.ui.view.components.ScreenBase;
	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeMappedSignal;
	
	public class CharacterSkinView extends Sprite {
		 
		
		private const base:ScreenBase = this.makeScreenBase();
		
		private const account:AccountScreen = this.makeAccountScreen();
		
		private const lines:Shape = this.makeLines();
		
		private const creditsDisplay:CreditDisplay = this.makeCreditDisplay();
		
		private const graphic:ScreenGraphic = this.makeScreenGraphic();
		
		private const playBtn:TitleMenuOption = this.makePlayButton();
		
		private const backBtn:TitleMenuOption = this.makeBackButton();
		
		private const list:CharacterSkinListView = this.makeListView();
		
		private const detail:ClassDetailView = this.makeClassDetailView();
		
		public const play:Signal = new NativeMappedSignal(this.playBtn,MouseEvent.CLICK);
		
		public const back:Signal = new NativeMappedSignal(this.backBtn,MouseEvent.CLICK);
		
		public const waiter:SignalWaiter = this.makeSignalWaiter();
		
		public function CharacterSkinView() {
			super();
		}
		
		private function makeScreenBase() : ScreenBase {
			var loc1:ScreenBase = new ScreenBase();
			addChild(loc1);
			return loc1;
		}
		
		private function makeAccountScreen() : AccountScreen {
			var loc1:AccountScreen = new AccountScreen();
			addChild(loc1);
			return loc1;
		}
		
		private function makeCreditDisplay() : CreditDisplay {
			var loc1:CreditDisplay = null;
			loc1 = new CreditDisplay(null,true,true);
			var loc2:PlayerModel = StaticInjectorContext.getInjector().getInstance(PlayerModel);
			if(loc2 != null) {
				loc1.draw(loc2.getCredits(),loc2.getFame(),loc2.getTokens());
			}
			loc1.x = 800;
			loc1.y = 20;
			addChild(loc1);
			return loc1;
		}
		
		private function makeLines() : Shape {
			var loc1:Shape = new Shape();
			loc1.graphics.clear();
			loc1.graphics.lineStyle(2,5526612);
			loc1.graphics.moveTo(0,105);
			loc1.graphics.lineTo(800,105);
			loc1.graphics.moveTo(346,105);
			loc1.graphics.lineTo(346,526);
			addChild(loc1);
			return loc1;
		}
		
		private function makeScreenGraphic() : ScreenGraphic {
			var loc1:ScreenGraphic = new ScreenGraphic();
			addChild(loc1);
			return loc1;
		}
		
		private function makePlayButton() : TitleMenuOption {
			var loc1:TitleMenuOption = null;
			loc1 = new TitleMenuOption(ScreenTypes.PLAY,36,false);
			loc1.setAutoSize(TextFieldAutoSize.CENTER);
			loc1.setVerticalAlign(TextFieldDisplayConcrete.MIDDLE);
			loc1.x = 400 - loc1.width / 2;
			loc1.y = 550;
			addChild(loc1);
			return loc1;
		}
		
		private function makeBackButton() : TitleMenuOption {
			var loc1:TitleMenuOption = null;
			loc1 = new TitleMenuOption(ScreenTypes.BACK,22,false);
			loc1.setVerticalAlign(TextFieldDisplayConcrete.MIDDLE);
			loc1.x = 30;
			loc1.y = 550;
			addChild(loc1);
			return loc1;
		}
		
		private function makeListView() : CharacterSkinListView {
			var loc1:CharacterSkinListView = null;
			loc1 = new CharacterSkinListView();
			loc1.x = 351;
			loc1.y = 110;
			addChild(loc1);
			return loc1;
		}
		
		private function makeClassDetailView() : ClassDetailView {
			var loc1:ClassDetailView = null;
			loc1 = new ClassDetailView();
			loc1.x = 5;
			loc1.y = 110;
			addChild(loc1);
			return loc1;
		}
		
		public function setPlayButtonEnabled(param1:Boolean) : void {
			if(!param1) {
				this.playBtn.deactivate();
			}
		}
		
		private function makeSignalWaiter() : SignalWaiter {
			var loc1:SignalWaiter = new SignalWaiter();
			loc1.push(this.playBtn.changed);
			loc1.complete.add(this.positionOptions);
			return loc1;
		}
		
		private function positionOptions() : void {
			this.playBtn.x = stage.stageWidth / 2;
		}
	}
}
