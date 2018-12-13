 
package kabam.rotmg.account.core.view {
	import kabam.rotmg.account.core.Account;
	import kabam.rotmg.account.core.signals.UpdateAccountInfoSignal;
	import kabam.rotmg.account.web.WebAccount;
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	public class AccountInfoMediator extends Mediator {
		 
		
		[Inject]
		public var account:Account;
		
		[Inject]
		public var view:AccountInfoView;
		
		[Inject]
		public var update:UpdateAccountInfoSignal;
		
		public function AccountInfoMediator() {
			super();
		}
		
		override public function initialize() : void {
			this.view.setInfo(this.account.getUserName(),this.account.isRegistered());
			this.updateDisplayName();
			this.update.add(this.updateLogin);
		}
		
		private function updateDisplayName() : void {
			var loc1:WebAccount = null;
			if(this.account is WebAccount) {
				loc1 = this.account as WebAccount;
				if(loc1 != null && loc1.userDisplayName != null && loc1.userDisplayName.length > 0) {
					this.view.setInfo(loc1.userDisplayName,this.account.isRegistered());
				}
			}
		}
		
		override public function destroy() : void {
			this.update.remove(this.updateLogin);
		}
		
		private function updateLogin() : void {
			this.view.setInfo(this.account.getUserName(),this.account.isRegistered());
			this.updateDisplayName();
		}
	}
}
