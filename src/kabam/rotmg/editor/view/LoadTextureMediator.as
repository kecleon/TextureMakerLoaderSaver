package kabam.rotmg.editor.view {
	import kabam.rotmg.account.core.Account;
	import kabam.rotmg.appengine.api.AppEngineClient;
	import kabam.rotmg.core.service.GoogleAnalytics;
	import kabam.rotmg.dialogs.control.CloseDialogsSignal;
	import kabam.rotmg.editor.model.SearchData;
	import kabam.rotmg.editor.model.SearchModel;
	import kabam.rotmg.editor.model.TextureData;
	import kabam.rotmg.editor.signals.SetTextureSignal;

	import robotlegs.bender.bundles.mvcs.Mediator;

	public class LoadTextureMediator extends Mediator {


		[Inject]
		public var account:Account;

		[Inject]
		public var client:AppEngineClient;

		[Inject]
		public var view:LoadTextureDialog;

		[Inject]
		public var analytics:GoogleAnalytics;

		[Inject]
		public var setTexture:SetTextureSignal;

		[Inject]
		public var closeDialogs:CloseDialogsSignal;

		[Inject]
		public var searchModel:SearchModel;

		public function LoadTextureMediator() {
			super();
		}

		override public function initialize():void {
			this.view.cancel.add(this.onCancel);
			this.view.textureSelected.add(this.onTextureSelected);
			this.view.search.add(this.onSearch);
			this.view.showSearchResults(true, this.searchModel.data);
		}

		override public function destroy():void {
			this.view.cancel.remove(this.onCancel);
			this.view.textureSelected.remove(this.onTextureSelected);
			this.view.search.remove(this.onSearch);
		}

		private function onCancel():void {
			this.closeDialogs.dispatch();
		}

		private function onTextureSelected(param1:TextureData):void {
			this.analytics.trackEvent("texture", "load", param1.name, 0);
			this.setTexture.dispatch(param1);
			this.closeDialogs.dispatch();
		}

		private function onSearch(param1:SearchData):void {
			this.searchModel.searchData = param1;
			this.client.complete.addOnce(this.onSearchComplete);
			this.client.sendRequest("/picture/list", this.makeRequest(param1));
		}

		private function makeRequest(param1:SearchData):Object {
			var loc2:Object = {};
			loc2["myGUID"] = this.account.getUserId();
			if (param1.scope == "Mine") {
				loc2["guid"] = this.account.getUserId();
			} else if (param1.scope == "Wild Shadow") {
				loc2["guid"] = "administrator@wildshadow.com";
			}
			if (param1.type != 0) {
				loc2["dataType"] = param1.type.toString();
			}
			if (param1.tags != "") {
				loc2["tags"] = param1.tags;
			}
			if (param1.offset != 0) {
				loc2["offset"] = param1.offset;
			}
			loc2["num"] = LoadTextureDialog.NUM_ROWS * LoadTextureDialog.NUM_COLS;
			return loc2;
		}

		private function onSearchComplete(param1:Boolean, param2:*):void {
			this.searchModel.data = param2;
			this.view.showSearchResults(param1, param2);
		}
	}
}
