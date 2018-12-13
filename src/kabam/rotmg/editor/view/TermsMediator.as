package kabam.rotmg.editor.view {
	import kabam.rotmg.core.signals.SetScreenSignal;

	import robotlegs.bender.bundles.mvcs.Mediator;

	public class TermsMediator extends Mediator {


		[Inject]
		public var view:TermsView;

		[Inject]
		public var setScreen:SetScreenSignal;

		public function TermsMediator() {
			super();
		}

		override public function initialize():void {
			this.view.response.addOnce(this.onResponse);
		}

		private function onResponse(param1:Boolean):void {
			if (param1) {
				this.setScreen.dispatch(new TextureView());
			}
		}
	}
}
