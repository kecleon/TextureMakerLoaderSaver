package kabam.rotmg.ui.view {
	import com.company.assembleegameclient.parameters.Parameters;
	import com.company.assembleegameclient.ui.dialogs.Dialog;

	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	import flash.text.TextFieldAutoSize;

	import kabam.rotmg.account.ui.components.DateField;
	import kabam.rotmg.text.model.TextKey;
	import kabam.rotmg.text.view.TextFieldDisplayConcrete;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;

	import org.osflash.signals.Signal;

	public class AgeVerificationDialog extends Dialog {

		private static const WIDTH:int = 300;


		private const BIRTH_DATE_BELOW_MINIMUM_ERROR:String = "AgeVerificationDialog.tooYoung";

		private const BIRTH_DATE_INVALID_ERROR:String = "AgeVerificationDialog.invalidBirthDate";

		private var ageVerificationField:DateField;

		private var errorLabel:TextFieldDisplayConcrete;

		private const MINIMUM_AGE:uint = 16;

		public const response:Signal = new Signal(Boolean);

		public function AgeVerificationDialog() {
			super(TextKey.AGE_VERIFICATION_DIALOG_TITLE, "", TextKey.AGE_VERIFICATION_DIALOG_LEFT, TextKey.AGE_VERIFICATION_DIALOG_RIGHT, "/ageVerificationDialog");
			addEventListener(Dialog.LEFT_BUTTON, this.onCancel);
			addEventListener(Dialog.RIGHT_BUTTON, this.onVerify);
		}

		override protected function makeUIAndAdd():void {
			this.makeAgeVerificationAndErrorLabel();
			this.addChildren();
		}

		private function makeAgeVerificationAndErrorLabel():void {
			this.makeAgeVerificationField();
			this.makeErrorLabel();
		}

		private function addChildren():void {
			uiWaiter.pushArgs(this.ageVerificationField.getTextChanged());
			box_.addChild(this.ageVerificationField);
			box_.addChild(this.errorLabel);
		}

		override protected function initText(param1:String):void {
			textText_ = new TextFieldDisplayConcrete().setSize(14).setColor(11776947);
			textText_.setTextWidth(WIDTH - 40);
			textText_.x = 20;
			textText_.setMultiLine(true).setWordWrap(true).setHTML(true);
			textText_.setAutoSize(TextFieldAutoSize.LEFT);
			textText_.mouseEnabled = true;
			textText_.filters = [new DropShadowFilter(0, 0, 0, 1, 6, 6, 1)];
			this.setText();
		}

		private function setText():void {
			var loc1:* = "<font color=\"#7777EE\"><a href=\"" + Parameters.TERMS_OF_USE_URL + "\" target=\"_blank\">";
			var loc2:* = "<font color=\"#7777EE\"><a href=\"" + Parameters.PRIVACY_POLICY_URL + "\" target=\"_blank\">";
			var loc3:String = "</a></font>";
			textText_.setStringBuilder(new LineBuilder().setParams("AgeVerificationDialog.text", {
				"tou": loc1,
				"_tou": loc3,
				"policy": loc2,
				"_policy": loc3
			}));
		}

		override protected function drawAdditionalUI():void {
			this.ageVerificationField.y = textText_.getBounds(box_).bottom + 8;
			this.ageVerificationField.x = 20;
			this.errorLabel.y = this.ageVerificationField.y + this.ageVerificationField.height + 8;
			this.errorLabel.x = 20;
		}

		private function makeAgeVerificationField():void {
			this.ageVerificationField = new DateField();
			this.ageVerificationField.setTitle(TextKey.BIRTHDAY);
		}

		private function makeErrorLabel():void {
			this.errorLabel = new TextFieldDisplayConcrete().setSize(12).setColor(16549442);
			this.errorLabel.setMultiLine(true);
			this.errorLabel.filters = [new DropShadowFilter(0, 0, 0, 0.5, 12, 12)];
		}

		private function onCancel(param1:Event):void {
			this.response.dispatch(false);
		}

		private function onVerify(param1:Event):void {
			var loc3:Boolean = false;
			var loc2:uint = this.getPlayerAge();
			var loc4:String = "";
			if (!this.ageVerificationField.isValidDate()) {
				loc4 = this.BIRTH_DATE_INVALID_ERROR;
				loc3 = true;
			} else if (loc2 < this.MINIMUM_AGE && !loc3) {
				loc4 = this.BIRTH_DATE_BELOW_MINIMUM_ERROR;
				loc3 = true;
			} else {
				loc4 = "";
				loc3 = false;
				this.response.dispatch(true);
			}
			this.errorLabel.setStringBuilder(new LineBuilder().setParams(loc4));
			this.ageVerificationField.setErrorHighlight(loc3);
			drawButtonsAndBackground();
		}

		private function getPlayerAge():uint {
			var loc1:Date = new Date(this.getBirthDate());
			var loc2:Date = new Date();
			var loc3:uint = Number(loc2.fullYear) - Number(loc1.fullYear);
			if (loc1.month > loc2.month || loc1.month == loc2.month && loc1.date > loc2.date) {
				loc3--;
			}
			return loc3;
		}

		private function getBirthDate():Number {
			return Date.parse(this.ageVerificationField.getDate());
		}
	}
}
