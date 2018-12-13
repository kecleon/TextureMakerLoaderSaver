 
package kabam.rotmg.account.core.control {
	import kabam.rotmg.account.core.Account;
	import kabam.rotmg.account.core.view.RegisterPromptDialog;
	import kabam.rotmg.dialogs.control.OpenDialogSignal;
	import robotlegs.bender.framework.api.IGuard;
	
	public class IsAccountRegisteredGuard implements IGuard {
		 
		
		[Inject]
		public var account:Account;
		
		[Inject]
		public var openDialog:OpenDialogSignal;
		
		public function IsAccountRegisteredGuard() {
			super();
		}
		
		public function approve() : Boolean {
			var loc1:Boolean = this.account.isRegistered();
			loc1 || this.enterRegisterFlow();
			return loc1;
		}
		
		protected function getString() : String {
			return "";
		}
		
		private function enterRegisterFlow() : void {
			this.openDialog.dispatch(new RegisterPromptDialog(this.getString()));
		}
	}
}
