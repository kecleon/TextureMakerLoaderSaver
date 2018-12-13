 
package kabam.rotmg.account.web.view {
	import com.company.assembleegameclient.screens.TitleMenuOption;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextFieldAutoSize;
	import kabam.rotmg.account.core.view.AccountInfoView;
	import kabam.rotmg.build.api.BuildData;
	import kabam.rotmg.build.api.BuildEnvironment;
	import kabam.rotmg.core.StaticInjectorContext;
	import kabam.rotmg.text.model.TextKey;
	import kabam.rotmg.text.view.TextFieldDisplayConcrete;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;
	import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeMappedSignal;
	
	public class WebAccountInfoView extends Sprite implements AccountInfoView {
		
		private static const FONT_SIZE:int = 18;
		 
		
		private var _login:Signal;
		
		private var _register:Signal;
		
		private var _reset:Signal;
		
		private var userName:String = "";
		
		private var isRegistered:Boolean;
		
		private var accountText:TextFieldDisplayConcrete;
		
		private var registerButton:TitleMenuOption;
		
		private var loginButton:TitleMenuOption;
		
		private var resetButton:TitleMenuOption;
		
		public function WebAccountInfoView() {
			super();
			this.makeUIElements();
			this.makeSignals();
		}
		
		public function get login() : Signal {
			return this._login;
		}
		
		public function get register() : Signal {
			return this._register;
		}
		
		public function get reset() : Signal {
			return this._reset;
		}
		
		private function makeUIElements() : void {
			this.makeAccountText();
			this.makeLoginButton();
			this.makeRegisterButton();
			this.makeResetButton();
		}
		
		private function makeSignals() : void {
			this._login = new NativeMappedSignal(this.loginButton,MouseEvent.CLICK);
			this._register = new NativeMappedSignal(this.registerButton,MouseEvent.CLICK);
			this._reset = new NativeMappedSignal(this.resetButton,MouseEvent.CLICK);
		}
		
		private function makeAccountText() : void {
			this.accountText = this.makeTextFieldConcrete();
		}
		
		private function makeTextFieldConcrete() : TextFieldDisplayConcrete {
			var loc1:TextFieldDisplayConcrete = null;
			loc1 = new TextFieldDisplayConcrete();
			loc1.setAutoSize(TextFieldAutoSize.RIGHT);
			loc1.setSize(FONT_SIZE).setColor(11776947);
			loc1.filters = [new DropShadowFilter(0,0,0,1,4,4)];
			return loc1;
		}
		
		private function makeLoginButton() : void {
			this.loginButton = new TitleMenuOption(TextKey.LOG_IN,FONT_SIZE,false);
			this.loginButton.setAutoSize(TextFieldAutoSize.RIGHT);
		}
		
		private function makeResetButton() : void {
			this.resetButton = new TitleMenuOption("reset",FONT_SIZE,false);
			this.resetButton.setAutoSize(TextFieldAutoSize.RIGHT);
		}
		
		private function makeRegisterButton() : void {
			this.registerButton = new TitleMenuOption(TextKey.REGISTER,FONT_SIZE,false);
			this.registerButton.setAutoSize(TextFieldAutoSize.RIGHT);
		}
		
		private function makeDividerText() : DisplayObject {
			var loc1:TextFieldDisplayConcrete = new TextFieldDisplayConcrete();
			loc1.setColor(11776947).setAutoSize(TextFieldAutoSize.RIGHT).setSize(FONT_SIZE);
			loc1.filters = [new DropShadowFilter(0,0,0,1,4,4)];
			loc1.setStringBuilder(new StaticStringBuilder(" - "));
			return loc1;
		}
		
		public function setInfo(param1:String, param2:Boolean) : void {
			this.userName = param1;
			this.isRegistered = param2;
			this.updateUI();
		}
		
		private function updateUI() : void {
			this.removeUIElements();
			if(this.isRegistered) {
				this.showUIForRegisteredAccount();
			} else {
				this.showUIForGuestAccount();
			}
		}
		
		private function removeUIElements() : void {
			while(numChildren) {
				removeChildAt(0);
			}
		}
		
		private function showUIForRegisteredAccount() : void {
			this.accountText.setStringBuilder(new LineBuilder().setParams(TextKey.LOGGED_IN_TEXT,{"userName":this.userName}));
			var loc1:BuildData = StaticInjectorContext.getInjector().getInstance(BuildData);
			this.loginButton.setTextKey(TextKey.LOG_OUT);
			if(loc1.getEnvironment() == BuildEnvironment.TESTING || loc1.getEnvironment() == BuildEnvironment.LOCALHOST) {
				this.addAndAlignHorizontally(this.accountText,this.makeDividerText(),this.loginButton);
			} else {
				this.addAndAlignHorizontally(this.accountText,this.loginButton);
			}
		}
		
		private function showUIForGuestAccount() : void {
			this.loginButton.setTextKey(TextKey.LOG_IN);
			this.addAndAlignHorizontally(this.registerButton,this.makeDividerText(),this.loginButton);
		}
		
		private function addAndAlignHorizontally(... rest) : void {
			var loc2:DisplayObject = null;
			var loc3:int = 0;
			var loc4:int = 0;
			var loc5:DisplayObject = null;
			for each(loc2 in rest) {
				addChild(loc2);
			}
			loc3 = 0;
			loc4 = rest.length;
			while(loc4--) {
				loc5 = rest[loc4];
				loc5.x = loc3;
				loc3 = loc3 - loc5.width;
			}
		}
	}
}
