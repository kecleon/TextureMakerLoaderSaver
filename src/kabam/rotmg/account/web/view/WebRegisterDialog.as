package kabam.rotmg.account.web.view {
	import com.company.assembleegameclient.account.ui.CheckBoxField;
	import com.company.assembleegameclient.account.ui.Frame;
	import com.company.assembleegameclient.parameters.Parameters;
	import com.company.util.EmailValidator;

	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.filters.DropShadowFilter;

	import kabam.rotmg.account.ui.components.DateField;
	import kabam.rotmg.account.web.model.AccountData;
	import kabam.rotmg.text.model.TextKey;
	import kabam.rotmg.text.view.TextFieldDisplayConcrete;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;

	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeMappedSignal;

	public class WebRegisterDialog extends Frame {


		public var register:Signal;

		public var signIn:Signal;

		public var cancel:Signal;

		private const errors:Array = [];

		private var emailInput:LabeledField;

		private var passwordInput:LabeledField;

		private var retypePasswordInput:LabeledField;

		private var checkbox:CheckBoxField;

		private var ageVerificationInput:DateField;

		private var signInText:TextFieldDisplayConcrete;

		private var tosText:TextFieldDisplayConcrete;

		private var endLink:String = "</a></font>";

		public function WebRegisterDialog() {
			super(TextKey.REGISTER_IMPERATIVE, "RegisterWebAccountDialog.leftButton", "RegisterWebAccountDialog.rightButton", "/registerAccount", 326);
			this.makeUIElements();
			this.makeSignals();
		}

		private function makeUIElements():void {
			this.emailInput = new LabeledField(TextKey.REGISTER_WEB_ACCOUNT_EMAIL, false, 275);
			this.passwordInput = new LabeledField(TextKey.REGISTER_WEB_ACCOUNT_PASSWORD, true, 275);
			this.retypePasswordInput = new LabeledField(TextKey.RETYPE_PASSWORD, true, 275);
			this.ageVerificationInput = new DateField();
			this.ageVerificationInput.setTitle(TextKey.BIRTHDAY);
			addLabeledField(this.emailInput);
			addLabeledField(this.passwordInput);
			addLabeledField(this.retypePasswordInput);
			addComponent(this.ageVerificationInput, 17);
			addSpace(35);
			this.checkbox = new CheckBoxField(TextKey.CHECK_BOX_TEXT, false, 12);
			addCheckBox(this.checkbox);
			addSpace(17);
			this.makeTosText();
			addSpace(17 * 2);
			this.makeSignInText();
		}

		public function makeSignInText():void {
			this.signInText = new TextFieldDisplayConcrete();
			var loc1:String = "<font color=\"#7777EE\"><a href=\"event:flash.events.TextEvent\">";
			this.signInText.setStringBuilder(new LineBuilder().setParams(TextKey.SIGN_IN_TEXT, {
				"signIn": loc1,
				"_signIn": this.endLink
			}));
			this.signInText.addEventListener(TextEvent.LINK, this.linkEvent);
			this.configureTextAndAdd(this.signInText);
		}

		public function makeTosText():void {
			this.tosText = new TextFieldDisplayConcrete();
			var loc1:* = "<font color=\"#7777EE\"><a href=\"" + Parameters.TERMS_OF_USE_URL + "\" target=\"_blank\">";
			var loc2:* = "<font color=\"#7777EE\"><a href=\"" + Parameters.PRIVACY_POLICY_URL + "\" target=\"_blank\">";
			this.tosText.setStringBuilder(new LineBuilder().setParams(TextKey.TOS_TEXT, {
				"tou": loc1,
				"_tou": this.endLink,
				"policy": loc2,
				"_policy": this.endLink
			}));
			this.configureTextAndAdd(this.tosText);
		}

		public function configureTextAndAdd(param1:TextFieldDisplayConcrete):void {
			param1.setSize(12).setColor(11776947).setBold(true);
			param1.setTextWidth(275);
			param1.setMultiLine(true).setWordWrap(true).setHTML(true);
			param1.filters = [new DropShadowFilter(0, 0, 0)];
			addChild(param1);
			positionText(param1);
		}

		private function linkEvent(param1:TextEvent):void {
			this.signIn.dispatch();
		}

		private function makeSignals():void {
			this.cancel = new NativeMappedSignal(leftButton_, MouseEvent.CLICK);
			rightButton_.addEventListener(MouseEvent.CLICK, this.onRegister);
			this.register = new Signal(AccountData);
			this.signIn = new Signal();
		}

		private function onRegister(param1:MouseEvent):void {
			var loc2:Boolean = this.areInputsValid();
			this.displayErrors();
			if (loc2) {
				this.sendData();
			}
		}

		private function areInputsValid():Boolean {
			this.errors.length = 0;
			var loc1:Boolean = true;
			loc1 = this.isEmailValid() && loc1;
			loc1 = this.isPasswordValid() && loc1;
			loc1 = this.isPasswordVerified() && loc1;
			loc1 = this.isAgeVerified() && loc1;
			loc1 = this.isAgeValid() && loc1;
			return loc1;
		}

		private function isAgeVerified():Boolean {
			var loc1:uint = DateFieldValidator.getPlayerAge(this.ageVerificationInput);
			var loc2:* = loc1 >= 16;
			this.ageVerificationInput.setErrorHighlight(!loc2);
			if (!loc2) {
				this.errors.push(TextKey.INELIGIBLE_AGE);
			}
			return loc2;
		}

		private function isAgeValid():Boolean {
			var loc1:Boolean = this.ageVerificationInput.isValidDate();
			this.ageVerificationInput.setErrorHighlight(!loc1);
			if (!loc1) {
				this.errors.push(TextKey.INVALID_BIRTHDATE);
			}
			return loc1;
		}

		private function isEmailValid():Boolean {
			var loc1:Boolean = EmailValidator.isValidEmail(this.emailInput.text());
			this.emailInput.setErrorHighlight(!loc1);
			if (!loc1) {
				this.errors.push(TextKey.INVALID_EMAIL_ADDRESS);
			}
			return loc1;
		}

		private function isPasswordValid():Boolean {
			var loc1:* = this.passwordInput.text().length >= 5;
			this.passwordInput.setErrorHighlight(!loc1);
			if (!loc1) {
				this.errors.push(TextKey.PASSWORD_TOO_SHORT);
			}
			return loc1;
		}

		private function isPasswordVerified():Boolean {
			var loc1:* = this.passwordInput.text() == this.retypePasswordInput.text();
			this.retypePasswordInput.setErrorHighlight(!loc1);
			if (!loc1) {
				this.errors.push(TextKey.PASSWORDS_DONT_MATCH);
			}
			return loc1;
		}

		public function displayErrors():void {
			if (this.errors.length == 0) {
				this.clearErrors();
			} else {
				this.displayErrorText(this.errors.length == 1 ? this.errors[0] : TextKey.MULTIPLE_ERRORS_MESSAGE);
			}
		}

		public function displayServerError(param1:String):void {
			this.displayErrorText(param1);
		}

		private function clearErrors():void {
			titleText_.setStringBuilder(new LineBuilder().setParams(TextKey.REGISTER_IMPERATIVE));
			titleText_.setColor(11776947);
		}

		private function displayErrorText(param1:String):void {
			titleText_.setStringBuilder(new LineBuilder().setParams(param1));
			titleText_.setColor(16549442);
		}

		private function sendData():void {
			var loc1:AccountData = new AccountData();
			loc1.username = this.emailInput.text();
			loc1.password = this.passwordInput.text();
			loc1.signedUpKabamEmail = !!this.checkbox.isChecked() ? 1 : 0;
			this.register.dispatch(loc1);
		}
	}
}
