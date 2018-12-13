 
package kabam.rotmg.account.securityQuestions.view {
	import com.company.assembleegameclient.account.ui.Frame;
	import flash.filters.DropShadowFilter;
	import kabam.rotmg.text.model.TextKey;
	import kabam.rotmg.text.view.TextFieldDisplayConcrete;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;
	
	public class SecurityQuestionsConfirmDialog extends Frame {
		 
		
		private var infoText:TextFieldDisplayConcrete;
		
		private var questionsList:Array;
		
		private var answerList:Array;
		
		public function SecurityQuestionsConfirmDialog(param1:Array, param2:Array) {
			this.questionsList = param1;
			this.answerList = param2;
			super(TextKey.SECURITY_QUESTIONS_CONFIRM_TITLE,TextKey.SECURITY_QUESTIONS_CONFIRM_LEFT_BUTTON,TextKey.SECURITY_QUESTIONS_CONFIRM_RIGHT_BUTTON);
			this.createAssets();
		}
		
		private function createAssets() : void {
			var loc3:String = null;
			var loc1:String = "";
			var loc2:int = 0;
			for each(loc3 in this.questionsList) {
				loc1 = loc1 + ("<font color=\"#7777EE\">" + LineBuilder.getLocalizedStringFromKey(loc3) + "</font>\n");
				loc1 = loc1 + (this.answerList[loc2] + "\n\n");
				loc2++;
			}
			loc1 = loc1 + LineBuilder.getLocalizedStringFromKey(TextKey.SECURITY_QUESTIONS_CONFIRM_TEXT);
			this.infoText = new TextFieldDisplayConcrete();
			this.infoText.setStringBuilder(new LineBuilder().setParams(loc1));
			this.infoText.setSize(12).setColor(11776947).setBold(true);
			this.infoText.setTextWidth(250);
			this.infoText.setMultiLine(true).setWordWrap(true).setHTML(true);
			this.infoText.filters = [new DropShadowFilter(0,0,0)];
			addChild(this.infoText);
			this.infoText.y = 40;
			this.infoText.x = 17;
			h_ = 280;
		}
		
		public function dispose() : void {
		}
		
		public function setInProgressMessage() : void {
			titleText_.setStringBuilder(new LineBuilder().setParams(TextKey.SECURITY_QUESTIONS_SAVING_IN_PROGRESS));
			titleText_.setColor(11776947);
		}
		
		public function setError(param1:String) : void {
			titleText_.setStringBuilder(new LineBuilder().setParams(param1));
			titleText_.setColor(16549442);
		}
	}
}
