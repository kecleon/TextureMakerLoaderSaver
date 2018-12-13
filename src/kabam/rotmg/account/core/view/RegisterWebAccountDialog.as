 
package kabam.rotmg.account.core.view {
	import com.company.assembleegameclient.account.ui.CheckBoxField;
	import com.company.assembleegameclient.account.ui.Frame;
	import com.company.assembleegameclient.account.ui.TextInputField;
	import com.company.assembleegameclient.parameters.Parameters;
	import com.company.util.EmailValidator;
	import flash.events.MouseEvent;
	import kabam.rotmg.account.web.model.AccountData;
	import kabam.rotmg.text.model.TextKey;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;
	import org.osflash.signals.Signal;
	
	public class RegisterWebAccountDialog extends Frame {
		 
		
		public var register:Signal;
		
		public var cancel:Signal;
		
		private var emailInput:TextInputField;
		
		private var passwordInput:TextInputField;
		
		private var retypePasswordInput:TextInputField;
		
		private var checkbox:CheckBoxField;
		
		public function RegisterWebAccountDialog() {
			this.register = new Signal(AccountData);
			this.cancel = new Signal();
			super(TextKey.REGISTER_WEB_ACCOUNT_DIALOG_TITLE,TextKey.REGISTER_WEB_ACCOUNT_DIALOG_LEFTBUTTON,TextKey.REGISTER_WEB_ACCOUNT_DIALOG_RIGHTBUTTON,"/kongregateRegisterAccount");
			this.createAssets();
			this.enableForTabBehavior();
			this.addEventListeners();
		}
		
		private function addEventListeners() : void {
			leftButton_.addEventListener(MouseEvent.CLICK,this.onCancel);
			rightButton_.addEventListener(MouseEvent.CLICK,this.onRegister);
		}
		
		private function createAssets() : void {
			this.emailInput = new TextInputField(TextKey.REGISTER_WEB_ACCOUNT_EMAIL,false);
			addTextInputField(this.emailInput);
			this.passwordInput = new TextInputField(TextKey.REGISTER_WEB_ACCOUNT_PASSWORD,true);
			addTextInputField(this.passwordInput);
			this.retypePasswordInput = new TextInputField(TextKey.RETYPE_PASSWORD,true);
			addTextInputField(this.retypePasswordInput);
			this.checkbox = new CheckBoxField("",false);
			var loc1:* = "<font color=\"#7777EE\"><a href=\"" + Parameters.TERMS_OF_USE_URL + "\" target=\"_blank\">";
			var loc2:String = "</a></font>.";
			this.checkbox.setTextStringBuilder(new LineBuilder().setParams(TextKey.REGISTER_WEB_CHECKBOX,{
				"link":loc1,
				"_link":loc2
			}));
			addCheckBox(this.checkbox);
		}
		
		private function enableForTabBehavior() : void {
			this.emailInput.inputText_.tabIndex = 1;
			this.passwordInput.inputText_.tabIndex = 2;
			this.retypePasswordInput.inputText_.tabIndex = 3;
			this.checkbox.checkBox_.tabIndex = 4;
			leftButton_.tabIndex = 6;
			rightButton_.tabIndex = 5;
			this.emailInput.inputText_.tabEnabled = true;
			this.passwordInput.inputText_.tabEnabled = true;
			this.retypePasswordInput.inputText_.tabEnabled = true;
			this.checkbox.checkBox_.tabEnabled = true;
			leftButton_.tabEnabled = true;
			rightButton_.tabEnabled = true;
		}
		
		private function onCancel(param1:MouseEvent) : void {
			this.cancel.dispatch();
		}
		
		private function onRegister(param1:MouseEvent) : void {
			var loc2:AccountData = null;
			if(this.isEmailValid() && this.isPasswordValid() && this.isPasswordVerified() && this.isCheckboxChecked()) {
				loc2 = new AccountData();
				loc2.username = this.emailInput.text();
				loc2.password = this.passwordInput.text();
				this.register.dispatch(loc2);
			}
		}
		
		private function isCheckboxChecked() : Boolean {
			var loc1:Boolean = this.checkbox.isChecked();
			if(!loc1) {
				this.checkbox.setError(TextKey.REGISTER_WEB_ACCOUNT_CHECK_ERROR);
			}
			return loc1;
		}
		
		private function isEmailValid() : Boolean {
			var loc1:Boolean = EmailValidator.isValidEmail(this.emailInput.text());
			if(!loc1) {
				this.emailInput.setError(TextKey.INVALID_EMAIL_ADDRESS);
			}
			return loc1;
		}
		
		private function isPasswordValid() : Boolean {
			var loc1:* = this.passwordInput.text().length >= 5;
			if(!loc1) {
				this.passwordInput.setError(TextKey.REGISTER_WEB_SHORT_ERROR);
			}
			return loc1;
		}
		
		private function isPasswordVerified() : Boolean {
			var loc1:* = this.passwordInput.text() == this.retypePasswordInput.text();
			if(!loc1) {
				this.retypePasswordInput.setError(TextKey.REGISTER_WEB_MATCH_ERROR);
			}
			return loc1;
		}
		
		public function showError(param1:String) : void {
			this.emailInput.setError(param1);
		}
	}
}
