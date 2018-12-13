package com.company.assembleegameclient.ui.tooltip {
	import com.company.assembleegameclient.objects.Player;
	import com.company.assembleegameclient.ui.GameObjectListItem;

	import flash.filters.DropShadowFilter;

	import kabam.rotmg.text.model.TextKey;
	import kabam.rotmg.text.view.TextFieldDisplayConcrete;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;

	public class PlayerGroupToolTip extends ToolTip {


		public var players_:Vector.<Player> = null;

		private var playerPanels_:Vector.<GameObjectListItem>;

		private var clickMessage_:TextFieldDisplayConcrete;

		public function PlayerGroupToolTip(param1:Vector.<Player>, param2:Boolean = true) {
			this.playerPanels_ = new Vector.<GameObjectListItem>();
			super(3552822, 0.5, 16777215, 1, param2);
			this.clickMessage_ = new TextFieldDisplayConcrete().setSize(12).setColor(11776947);
			this.clickMessage_.setStringBuilder(new LineBuilder().setParams(TextKey.PLAYER_TOOL_TIP_CLICK_MESSAGE));
			this.clickMessage_.filters = [new DropShadowFilter(0, 0, 0)];
			addChild(this.clickMessage_);
			this.setPlayers(param1);
			if (!param2) {
				filters = [];
			}
			waiter.push(this.clickMessage_.textChanged);
		}

		public function setPlayers(param1:Vector.<Player>):void {
			var loc3:Player = null;
			var loc4:GameObjectListItem = null;
			this.clear();
			this.players_ = param1.slice();
			if (this.players_ == null || this.players_.length == 0) {
				return;
			}
			var loc2:int = 0;
			for each(loc3 in param1) {
				loc4 = new GameObjectListItem(11776947, true, loc3);
				loc4.x = 0;
				loc4.y = loc2;
				addChild(loc4);
				this.playerPanels_.push(loc4);
				loc4.textReady.addOnce(this.onTextChanged);
				loc2 = loc2 + 32;
			}
			this.clickMessage_.x = width / 2 - this.clickMessage_.width / 2;
			this.clickMessage_.y = loc2;
			draw();
		}

		private function onTextChanged():void {
			var loc1:GameObjectListItem = null;
			this.clickMessage_.x = width / 2 - this.clickMessage_.width / 2;
			draw();
			for each(loc1 in this.playerPanels_) {
				loc1.textReady.remove(this.onTextChanged);
			}
		}

		private function clear():void {
			var loc1:GameObjectListItem = null;
			graphics.clear();
			for each(loc1 in this.playerPanels_) {
				removeChild(loc1);
			}
			this.playerPanels_.length = 0;
		}
	}
}
