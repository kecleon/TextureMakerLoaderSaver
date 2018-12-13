package kabam.rotmg.account.transfer.view {
	import com.company.assembleegameclient.account.ui.CheckBoxField;
	import com.company.assembleegameclient.account.ui.Frame;
	import com.company.assembleegameclient.parameters.Parameters;
	import com.company.util.EmailValidator;

	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;

	import kabam.rotmg.account.transfer.model.TransferAccountData;
	import kabam.rotmg.account.ui.components.DateField;
	import kabam.rotmg.account.web.view.LabeledField;
	import kabam.rotmg.text.model.TextKey;
	import kabam.rotmg.text.view.TextFieldDisplayConcrete;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;
	import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;

	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeMappedSignal;

	public class TransferAccountView extends Frame {


		public var transfer:Signal;

		public var cancel:Signal;

		private const errors:Array = [];

		private var kbmEmail:String = "";

		private var kbmPassword:String = "";

		private var newEmailInput:LabeledField;

		private var newPasswordInput:LabeledField;

		private var retypePasswordInput:LabeledField;

		private var checkbox:CheckBoxField;

		private var ageVerificationInput:DateField;

		private var signInText:TextFieldDisplayConcrete;

		private var tosText:TextFieldDisplayConcrete;

		private var headerText:TextFieldDisplayConcrete;

		private var headerText2:TextFieldDisplayConcrete;

		private var endLink:String = "</a></font>";

		public function TransferAccountView(param1:String, param2:String) {
			super("Register your account on realmofthemadgod.com", "RegisterWebAccountDialog.leftButton", "RegisterWebAccountDialog.rightButton", "", 326);
			this.kbmEmail = param1;
			this.kbmPassword = param2;
			this.makeUIElements();
			this.makeSignals();
		}

		private function makeUIElements():void {
			this.headerText = new TextFieldDisplayConcrete().setSize(13).setColor(11776947);
			this.headerText.setStringBuilder(new StaticStringBuilder("This will be used for future logins."));
			this.headerText.filters = [new DropShadowFilter(0, 0, 0)];
			this.headerText.x = 5;
			this.headerText.y = 3;
			this.headerText.filters = [new DropShadowFilter(0, 0, 0, 0.5, 12, 12)];
			addChild(this.headerText);
			positionText(this.headerText);
			this.headerText2 = new TextFieldDisplayConcrete().setSize(13).setColor(11776947);
			this.headerText2.setStringBuilder(new StaticStringBuilder("Your account data is safe and will remain the same."));
			this.headerText2.filters = [new DropShadowFilter(0, 0, 0)];
			this.headerText2.x = 5;
			this.headerText2.y = 3;
			this.headerText2.filters = [new DropShadowFilter(0, 0, 0, 0.5, 12, 12)];
			addChild(this.headerText2);
			positionText(this.headerText2);
			this.newEmailInput = new LabeledField("New Email (must be valid)", false, 275);
			this.newPasswordInput = new LabeledField(TextKey.TRANSFER_ACCOUNT_NEW_PWD, true, 275);
			this.retypePasswordInput = new LabeledField(TextKey.WEB_CHANGE_PASSWORD_RETYPE_PASSWORD, true, 275);
			addLabeledField(this.newEmailInput);
			addLabeledField(this.newPasswordInput);
			addLabeledField(this.retypePasswordInput);
			addSpace(15);
			this.makeTosText();
			addSpace(15);
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

		private function makeSignals():void {
			this.cancel = new NativeMappedSignal(leftButton_, MouseEvent.CLICK);
			this.transfer = new Signal(TransferAccountData);
			rightButton_.addEventListener(MouseEvent.CLICK, this.onTransfer);
		}

		private function onTransfer(param1:MouseEvent):void {
			var loc2:Boolean = this.areInputsValid();
			this.displayErrors();
			if (loc2) {
				this.sendData();
			}
		}

		private function areInputsValid():Boolean {
			this.errors.length = 0;
			var loc1:Boolean = true;
			loc1 = this.isEmailValid(this.newEmailInput) && loc1;
			loc1 = this.isPasswordValid(this.newPasswordInput) && loc1;
			loc1 = this.isPasswordVerified() && loc1;
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

		private function isEmailValid(param1:LabeledField):Boolean {
			var loc2:Boolean = EmailValidator.isValidEmail(param1.text());
			param1.setErrorHighlight(!loc2);
			if (!loc2) {
				this.errors.push(TextKey.INVALID_EMAIL_ADDRESS);
			}
			return loc2;
		}

		private function isPasswordValid(param1:LabeledField):Boolean {
			var loc2:* = param1.text().length >= 5;
			param1.setErrorHighlight(!loc2);
			if (!loc2) {
				this.errors.push(TextKey.PASSWORD_TOO_SHORT);
			}
			return loc2;
		}

		private function isPasswordVerified():Boolean {
			var loc1:* = this.newPasswordInput.text() == this.retypePasswordInput.text();
			this.retypePasswordInput.setErrorHighlight(!loc1);
			if (!loc1) {
				this.errors.push(TextKey.PASSWORDS_DONT_MATCH);
			}
			return loc1;
		}

		private function sendData():void {
			var loc1:TransferAccountData = new TransferAccountData();
			loc1.currentEmail = this.kbmEmail;
			loc1.currentPassword = this.kbmPassword;
			loc1.newEmail = this.newEmailInput.text();
			loc1.newPassword = this.newPasswordInput.text();
			this.transfer.dispatch(loc1);
		}
	}
}
