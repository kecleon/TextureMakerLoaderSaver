 
package kabam.rotmg.editor.view {
	import kabam.rotmg.core.model.PlayerModel;
	import kabam.rotmg.core.signals.TrackPageViewSignal;
	import kabam.rotmg.dialogs.control.OpenDialogSignal;
	import kabam.rotmg.editor.model.SearchModel;
	import kabam.rotmg.editor.model.TextureData;
	import kabam.rotmg.editor.signals.SetTextureSignal;
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	public class TextureMediator extends Mediator {
		 
		
		[Inject]
		public var view:TextureView;
		
		[Inject]
		public var model:PlayerModel;
		
		[Inject]
		public var track:TrackPageViewSignal;
		
		[Inject]
		public var openDialog:OpenDialogSignal;
		
		[Inject]
		public var setTexture:SetTextureSignal;
		
		[Inject]
		public var searchModel:SearchModel;
		
		public function TextureMediator() {
			super();
		}
		
		override public function initialize() : void {
			this.view.saveDialog.add(this.onSave);
			this.view.loadDialog.add(this.onLoad);
			this.setTexture.add(this.onSetTexture);
			this.track.dispatch("/textureScreen");
		}
		
		override public function destroy() : void {
			this.view.loadDialog.remove(this.onLoad);
			this.view.saveDialog.remove(this.onSave);
			this.setTexture.remove(this.onSetTexture);
		}
		
		private function onSetTexture(param1:TextureData) : void {
			this.view.setTexture(param1);
		}
		
		private function onLoad() : void {
			this.openDialog.dispatch(new LoadTextureDialog(this.searchModel));
		}
		
		private function onSave(param1:TextureData) : void {
			this.openDialog.dispatch(new SaveTextureDialog(param1));
		}
	}
}
