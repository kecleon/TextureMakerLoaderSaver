 
package kabam.rotmg.account.web.view {
	import com.company.assembleegameclient.account.ui.CheckBoxField;
	import com.company.assembleegameclient.account.ui.Frame;
	import com.company.assembleegameclient.account.ui.TextInputField;
	import com.company.assembleegameclient.ui.DeprecatedClickableText;
	import com.company.util.KeyCodes;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import kabam.rotmg.account.web.model.AccountData;
	import kabam.rotmg.text.model.TextKey;
	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeMappedSignal;
	
	public class WebLoginDialog extends Frame {
		 
		
		public var cancel:Signal;
		
		public var signIn:Signal;
		
		public var forgot:Signal;
		
		public var register:Signal;
		
		private var email:TextInputField;
		
		private var password:TextInputField;
		
		private var forgotText:DeprecatedClickableText;
		
		private var registerText:DeprecatedClickableText;
		
		private var rememberMeCheckbox:CheckBoxField;
		
		public function WebLoginDialog() {
			super(TextKey.WEB_LOGIN_DIALOG_TITLE,TextKey.WEB_LOGIN_DIALOG_LEFT,TextKey.WEB_LOGIN_DIALOG_RIGHT,"/signIn");
			this.makeUI();
			this.forgot = new NativeMappedSignal(this.forgotText,MouseEvent.CLICK);
			this.register = new NativeMappedSignal(this.registerText,MouseEvent.CLICK);
			this.cancel = new NativeMappedSignal(leftButton_,MouseEvent.CLICK);
			this.signIn = new Signal(AccountData);
		}
		
		private function makeUI() : void {
			this.email = new TextInputField(TextKey.WEB_LOGIN_DIALOG_EMAIL,false);
			addTextInputField(this.email);
			this.password = new TextInputField(TextKey.WEB_LOGIN_DIALOG_PASSWORD,true);
			addTextInputField(this.password);
			this.rememberMeCheckbox = new CheckBoxField("Remember me",false);
			this.rememberMeCheckbox.text_.y = 4;
			this.forgotText = new DeprecatedClickableText(12,false,TextKey.WEB_LOGIN_DIALOG_FORGOT);
			h_ = h_ + 12;
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
				this.signIn.dispatch(loc1);
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
		
		public function isRememberMeSelected() : Boolean {
			return true;
		}
		
		public function setError(param1:String) : void {
			this.password.setError(param1);
		}
		
		public function setEmail(param1:String) : void {
			this.email.inputText_.text = param1;
		}
	}
}
