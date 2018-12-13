package kabam.rotmg.editor.commands {
	import kabam.lib.tasks.Task;
	import kabam.rotmg.account.core.Account;
	import kabam.rotmg.account.core.services.LoadAccountTask;
	import kabam.rotmg.account.web.view.WebAccountInfoView;
	import kabam.rotmg.core.signals.SetScreenSignal;
	import kabam.rotmg.core.view.Layers;
	import kabam.rotmg.editor.view.TextureView;

	public class SetupEditorCommand {


		[Inject]
		public var account:Account;

		[Inject]
		public var loadAccount:LoadAccountTask;

		[Inject]
		public var setScreen:SetScreenSignal;

		[Inject]
		public var layers:Layers;

		public function SetupEditorCommand() {
			super();
		}

		public function execute():void {
			this.loadAccount.finished.addOnce(this.onAccountLoaded);
			this.loadAccount.start();
			this.setScreen.dispatch(new TextureView());
		}

		private function onAccountLoaded(param1:Task, param2:Boolean, param3:String):void {
			var loc4:WebAccountInfoView = new WebAccountInfoView();
			loc4.setInfo(this.account.getUserId(), this.account.isRegistered());
			this.layers.overlay.addChild(loc4);
		}
	}
}
