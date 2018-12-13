 
package kabam.rotmg.account.steam.view {
	import com.company.util.EmailValidator;
	import kabam.rotmg.account.core.Account;
	import kabam.rotmg.account.core.view.RegisterWebAccountDialog;
	import kabam.rotmg.account.steam.SteamApi;
	import kabam.rotmg.dialogs.control.CloseDialogsSignal;
	import kabam.rotmg.dialogs.control.OpenDialogSignal;
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	public class SteamAccountDetailMediator extends Mediator {
		 
		
		[Inject]
		public var view:SteamAccountDetailDialog;
		
		[Inject]
		public var account:Account;
		
		[Inject]
		public var steam:SteamApi;
		
		[Inject]
		public var closeDialog:CloseDialogsSignal;
		
		[Inject]
		public var openDialog:OpenDialogSignal;
		
		public function SteamAccountDetailMediator() {
			super();
		}
		
		override public function initialize() : void {
			this.populateDialog();
			this.view.done.add(this.onDone);
			this.view.register.add(this.onRegister);
			this.view.link.add(this.onLink);
		}
		
		private function populateDialog() : void {
			var loc1:String = this.steam.getSteamId();
			var loc2:String = this.account.getUserName();
			var loc3:Boolean = EmailValidator.isValidEmail(loc2);
			this.view.setInfo(loc1,loc2,loc3);
		}
		
		override public function destroy() : void {
			this.view.done.remove(this.onDone);
			this.view.register.remove(this.onRegister);
			this.view.link.remove(this.onLink);
		}
		
		private function onDone() : void {
			this.closeDialog.dispatch();
		}
		
		private function onRegister() : void {
			this.openDialog.dispatch(new RegisterWebAccountDialog());
		}
		
		private function onLink() : void {
		}
	}
}
