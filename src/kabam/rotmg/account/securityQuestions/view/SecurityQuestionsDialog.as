package kabam.rotmg.account.securityQuestions.view {
	import com.company.assembleegameclient.account.ui.Frame;
	import com.company.assembleegameclient.account.ui.TextInputField;

	import kabam.rotmg.text.model.TextKey;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;

	public class SecurityQuestionsDialog extends Frame {


		private const minQuestionLength:int = 3;

		private const maxQuestionLength:int = 50;

		private const inputPattern:RegExp = /^[a-zA-Z0-9 ]+$/;

		private var errors:Array;

		private var fields:Array;

		private var questionsList:Array;

		public function SecurityQuestionsDialog(param1:Array, param2:Array) {
			this.errors = [];
			this.questionsList = param1;
			super(TextKey.SECURITY_QUESTIONS_DIALOG_TITLE, "", TextKey.SECURITY_QUESTIONS_DIALOG_SAVE);
			this.createAssets();
			if (param1.length == param2.length) {
				this.updateAnswers(param2);
			}
		}

		public function updateAnswers(param1:Array):void {
			var loc3:TextInputField = null;
			var loc2:int = 1;
			for each(loc3 in this.fields) {
				loc3.inputText_.text = param1[loc2 - 1];
				loc2++;
			}
		}

		private function createAssets():void {
			var loc2:String = null;
			var loc3:TextInputField = null;
			var loc1:int = 1;
			this.fields = [];
			for each(loc2 in this.questionsList) {
				loc3 = new TextInputField(loc2, false, 240);
				loc3.nameText_.setTextWidth(240);
				loc3.nameText_.setSize(12);
				loc3.nameText_.setWordWrap(true);
				loc3.nameText_.setMultiLine(true);
				addTextInputField(loc3);
				loc3.inputText_.tabEnabled = true;
				loc3.inputText_.tabIndex = loc1;
				loc3.inputText_.maxChars = this.maxQuestionLength;
				loc1++;
				this.fields.push(loc3);
			}
			rightButton_.tabIndex = loc1 + 1;
			rightButton_.tabEnabled = true;
		}

		public function clearErrors():void {
			var loc1:TextInputField = null;
			titleText_.setStringBuilder(new LineBuilder().setParams(TextKey.SECURITY_QUESTIONS_DIALOG_TITLE));
			titleText_.setColor(11776947);
			this.errors = [];
			for each(loc1 in this.fields) {
				loc1.setErrorHighlight(false);
			}
		}

		public function areQuestionsValid():Boolean {
			var loc1:TextInputField = null;
			for each(loc1 in this.fields) {
				if (loc1.inputText_.length < this.minQuestionLength) {
					this.errors.push(TextKey.SECURITY_QUESTIONS_TOO_SHORT);
					loc1.setErrorHighlight(true);
					return false;
				}
				if (loc1.inputText_.length > this.maxQuestionLength) {
					this.errors.push(TextKey.SECURITY_QUESTIONS_TOO_LONG);
					loc1.setErrorHighlight(true);
					return false;
				}
			}
			return true;
		}

		public function displayErrorText():void {
			var loc1:String = this.errors.length == 1 ? this.errors[0] : TextKey.MULTIPLE_ERRORS_MESSAGE;
			this.setError(loc1);
		}

		public function dispose():void {
			this.errors = null;
			this.fields = null;
			this.questionsList = null;
		}

		public function getAnswers():Array {
			var loc2:TextInputField = null;
			var loc1:Array = [];
			for each(loc2 in this.fields) {
				loc1.push(loc2.inputText_.text);
			}
			return loc1;
		}

		override public function disable():void {
			super.disable();
			titleText_.setStringBuilder(new LineBuilder().setParams(TextKey.SECURITY_QUESTIONS_SAVING_IN_PROGRESS));
		}

		public function setError(param1:String):void {
			titleText_.setStringBuilder(new LineBuilder().setParams(param1, {"min": this.minQuestionLength}));
			titleText_.setColor(16549442);
		}
	}
}
