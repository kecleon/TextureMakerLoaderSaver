package kabam.rotmg.account.web.commands {
	import kabam.rotmg.account.core.Account;
	import kabam.rotmg.account.web.WebAccount;

	public class WebSetPaymentDataCommand {


		[Inject]
		public var characterListData:XML;

		[Inject]
		public var account:Account;

		public function WebSetPaymentDataCommand() {
			super();
		}

		public function execute():void {
			var loc2:XML = null;
			var loc1:WebAccount = this.account as WebAccount;
			if (this.characterListData.hasOwnProperty("KabamPaymentInfo")) {
				loc2 = XML(this.characterListData.KabamPaymentInfo);
				loc1.signedRequest = loc2.signedRequest;
				loc1.kabamId = loc2.naid;
			}
		}
	}
}
