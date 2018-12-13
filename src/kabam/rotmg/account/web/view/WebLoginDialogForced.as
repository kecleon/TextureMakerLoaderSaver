 
package kabam.rotmg.account.web.view {
	import com.company.assembleegameclient.account.ui.Frame;
	import com.company.assembleegameclient.account.ui.TextInputField;
	import com.company.assembleegameclient.ui.DeprecatedClickableText;
	import com.company.util.KeyCodes;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	import kabam.rotmg.account.web.model.AccountData;
	import kabam.rotmg.text.model.TextKey;
	import kabam.rotmg.text.view.TextFieldDisplayConcrete;
	import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeMappedSignal;
	
	public class WebLoginDialogForced extends Frame {
		 
		
		public var signInForced:Signal;
		
		public var forgot:Signal;
		
		public var register:Signal;
		
		public var email:TextInputField;
		
		private var password:TextInputField;
		
		private var forgotText:DeprecatedClickableText;
		
		private var registerText:DeprecatedClickableText;
		
		public function WebLoginDialogForced(param1:Boolean = false) {
			super(TextKey.WEB_LOGIN_DIALOG_TITLE,"",TextKey.WEB_LOGIN_DIALOG_RIGHT,"/signIn");
			this.makeUI();
			if(param1) {
				addChild(this.getText("Attention!",-165,-85).setColor(16711680));
				addChild(this.getText("A new password was sent to your Sign In Email Address.",-165,-65));
				addChild(this.getText("Please use the new password to Sign In.",-165,-45));
			}
			this.forgot = new NativeMappedSignal(this.forgotText,MouseEvent.CLICK);
			this.register = new NativeMappedSignal(this.registerText,MouseEvent.CLICK);
			this.signInForced = new Signal(AccountData);
		}
		
		private function makeUI() : void {
			this.email = new TextInputField(TextKey.WEB_LOGIN_DIALOG_EMAIL,false);
			addTextInputField(this.email);
			this.password = new TextInputField(TextKey.WEB_LOGIN_DIALOG_PASSWORD,true);
			addTextInputField(this.password);
			this.forgotText = new DeprecatedClickableText(12,false,TextKey.WEB_LOGIN_DIALOG_FORGOT);
			addNavigationText(this.forgotText);
			this.registerText = new DeprecatedClickableText(12,false,TextKey.WEB_LOGIN_DIALOG_REGISTER);
			addNavigationText(this.registerText);
			rightButton_.addEventListener(MouseEvent.CLICK,this.onSignIn);
			addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
			addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
		}
		
		private function onRemovedFromStage(param1:Event) : void {
			removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
			removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
		}
		
		private function onKeyDown(param1:KeyboardEvent) : void {
			if(param1.keyCode == KeyCodes.ENTER) {
				this.onSignInSub();
			}
		}
		
		private function onSignIn(param1:MouseEvent) : void {
			this.onSignInSub();
		}
		
		private function onSignInSub() : void {
			var loc1:AccountData = null;
			if(this.isEmailValid() && this.isPasswordValid()) {
				loc1 = new AccountData();
				loc1.username = this.email.text();
				loc1.password = this.password.text();
				this.signInForced.dispatch(loc1);
			}
		}
		
		private function isPasswordValid() : Boolean {
			var loc1:* = this.password.text() != "";
			if(!loc1) {
				this.password.setError(TextKey.WEB_LOGIN_DIALOG_PASSWORD_ERROR);
			}
			return loc1;
		}
		
		private function isEmailValid() : Boolean {
			var loc1:* = this.email.text() != "";
			if(!loc1) {
				this.email.setError(TextKey.WEBLOGINDIALOG_EMAIL_ERROR);
			}
			return loc1;
		}
		
		public function setError(param1:String) : void {
			this.password.setError(param1);
		}
		
		public function getText(param1:String, param2:int, param3:int) : TextFieldDisplayConcrete {
			var loc4:TextFieldDisplayConcrete = new TextFieldDisplayConcrete().setSize(16).setColor(16777215).setTextWidth(600);
			loc4.setBold(true);
			loc4.setStringBuilder(new StaticStringBuilder(param1));
			loc4.setSize(16).setColor(16777215);
			loc4.setWordWrap(true);
			loc4.setMultiLine(true);
			loc4.setAutoSize(TextFieldAutoSize.CENTER);
			loc4.setHorizontalAlign(TextFormatAlign.CENTER);
			loc4.filters = [new DropShadowFilter(0,0,0)];
			loc4.x = param2;
			loc4.y = param3;
			return loc4;
		}
	}
}
