package kabam.rotmg.account.securityQuestions.data {
	public class SecurityQuestionsModel {


		private var _showSecurityQuestionsOnStartup:Boolean;

		private var _securityQuestionsList:Array;

		public var securityQuestionsAnswers:Array;

		public function SecurityQuestionsModel() {
			this._securityQuestionsList = [];
			this.securityQuestionsAnswers = [];
			super();
		}

		public function get showSecurityQuestionsOnStartup():Boolean {
			return this._showSecurityQuestionsOnStartup;
		}

		public function set showSecurityQuestionsOnStartup(param1:Boolean):void {
			this._showSecurityQuestionsOnStartup = param1;
		}

		public function get securityQuestionsList():Array {
			return this._securityQuestionsList;
		}

		public function clearQuestionsList():void {
			this._securityQuestionsList = [];
		}

		public function addSecurityQuestion(param1:String):void {
			this._securityQuestionsList.push(param1);
		}
	}
}
