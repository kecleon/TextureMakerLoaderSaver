package kabam.rotmg.ui.commands {
	import com.company.assembleegameclient.account.ui.NewChooseNameFrame;

	import flash.display.Sprite;

	import kabam.rotmg.account.core.Account;
	import kabam.rotmg.dialogs.control.OpenDialogSignal;
	import kabam.rotmg.ui.view.ChooseNameRegisterDialog;

	public class ChooseNameCommand {


		[Inject]
		public var account:Account;

		[Inject]
		public var openDialog:OpenDialogSignal;

		public function ChooseNameCommand() {
			super();
		}

		public function execute():void {
			var loc1:Sprite = null;
			if (this.account.isRegistered()) {
				loc1 = new NewChooseNameFrame();
			} else {
				loc1 = new ChooseNameRegisterDialog();
			}
			this.openDialog.dispatch(loc1);
		}
	}
}
