 
package kabam.rotmg.editor.view.components.loaddialog {
	import flash.net.URLLoaderDataFormat;
	import flash.utils.ByteArray;
	import kabam.rotmg.appengine.api.AppEngineClient;
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	public class ResultsBoxMediator extends Mediator {
		 
		
		[Inject]
		public var view:ResultsBox;
		
		[Inject]
		public var client:AppEngineClient;
		
		public function ResultsBoxMediator() {
			super();
		}
		
		override public function initialize() : void {
			this.client.setSendEncrypted(false);
			this.client.setDataFormat(URLLoaderDataFormat.BINARY);
			this.client.complete.addOnce(this.onURLLoadComplete);
			this.client.sendRequest("/picture/get",{"id":this.view.id_});
		}
		
		private function onURLLoadComplete(param1:Boolean, param2:*) : void {
			param1 && this.view.makeBitmapData(param2 as ByteArray);
		}
	}
}
