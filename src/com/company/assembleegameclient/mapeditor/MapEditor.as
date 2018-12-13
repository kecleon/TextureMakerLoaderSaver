package com.company.assembleegameclient.mapeditor {
	import com.company.assembleegameclient.game.GameSprite;
	import com.company.assembleegameclient.game.events.DeathEvent;
	import com.company.assembleegameclient.game.events.ReconnectEvent;
	import com.company.assembleegameclient.parameters.Parameters;
	import com.company.assembleegameclient.screens.TitleMenuOption;

	import flash.display.Sprite;
	import flash.events.Event;

	import kabam.rotmg.core.model.PlayerModel;
	import kabam.rotmg.servers.api.Server;

	public class MapEditor extends Sprite {


		private var model:PlayerModel;

		private var server:Server;

		public var editingScreen_:EditingScreen;

		private var gameSprite_:GameSprite;

		public var returnButton_:TitleMenuOption;

		private var blackBackground:Sprite;

		public function MapEditor() {
			super();
			this.editingScreen_ = new EditingScreen();
			this.editingScreen_.addEventListener(MapTestEvent.MAP_TEST, this.onMapTest);
			this.editingScreen_.addEventListener(SubmitJMEvent.SUBMIT_JM_EVENT, this.onSubmitMapPopup);
			addChild(this.editingScreen_);
		}

		public function initialize(param1:PlayerModel, param2:Server):void {
			this.model = param1;
			this.server = param2;
		}

		private function onMapTest(param1:MapTestEvent):void {
			removeChild(this.editingScreen_);
			this.gameSprite_ = new GameSprite(this.server, Parameters.MAPTEST_GAMEID, false, this.model.getSavedCharacters()[0].charId(), -1, null, this.model, param1.mapJSON_, false);
			this.gameSprite_.isEditor = true;
			this.gameSprite_.addEventListener(Event.COMPLETE, this.onMapTestDone);
			this.gameSprite_.addEventListener(ReconnectEvent.RECONNECT, this.onMapTestDone);
			this.gameSprite_.addEventListener(DeathEvent.DEATH, this.onMapTestDone);
			this.gameSprite_.closed.add(this.onMapTestDoneSub);
			addChild(this.gameSprite_);
		}

		private function onMapTestDoneSub():void {
			this.onMapTestDone(null);
		}

		private function onMapTestDone(param1:Event):void {
			this.cleanupGameSprite();
			addChild(this.editingScreen_);
		}

		private function onSubmitMapPopup(param1:SubmitJMEvent):void {
			var loc2:SubmitMapForm = null;
			if (!SubmitMapForm.isInitialized()) {
				loc2 = new SubmitMapForm(param1.mapJSON_, param1.mapInfo_, this.model.account);
				this.showCurtain();
				addChild(loc2);
				loc2.x = (800 - loc2.width) / 2;
				loc2.y = (600 - loc2.height) / 2;
				SubmitMapForm.cancel.add(this.onSubmitClose);
				this.editingScreen_.disableInput();
			}
		}

		private function onSubmitClose():void {
			this.hideCurtain();
			this.editingScreen_.enableInput();
		}

		private function onClientUpdate(param1:Event):void {
			this.cleanupGameSprite();
			addChild(this.editingScreen_);
		}

		private function showCurtain():void {
			if (this.blackBackground == null) {
				this.blackBackground = new Sprite();
				this.blackBackground.graphics.beginFill(0, 0.4);
				this.blackBackground.graphics.drawRect(0, 0, width, height);
				this.blackBackground.graphics.endFill();
			}
			addChild(this.blackBackground);
		}

		private function hideCurtain():void {
			if (this.blackBackground != null && this.blackBackground.parent) {
				removeChild(this.blackBackground);
			}
		}

		private function cleanupGameSprite():void {
			this.gameSprite_.removeEventListener(Event.COMPLETE, this.onMapTestDone);
			this.gameSprite_.removeEventListener(ReconnectEvent.RECONNECT, this.onMapTestDone);
			this.gameSprite_.removeEventListener(DeathEvent.DEATH, this.onMapTestDone);
			this.gameSprite_.closed.remove(this.onMapTestDoneSub);
			removeChild(this.gameSprite_);
			this.gameSprite_ = null;
		}
	}
}
