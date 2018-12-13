package com.company.assembleegameclient.ui.menu {
	import com.company.assembleegameclient.map.AbstractMap;
	import com.company.assembleegameclient.objects.Player;
	import com.company.assembleegameclient.ui.GameObjectListItem;
	import com.company.assembleegameclient.ui.LineBreakDesign;

	import flash.events.Event;
	import flash.events.MouseEvent;

	import org.osflash.signals.Signal;

	public class PlayerGroupMenu extends Menu {


		private var playerPanels_:Vector.<GameObjectListItem>;

		private var posY:uint = 4;

		public var map_:AbstractMap;

		public var players_:Vector.<Player>;

		public var teleportOption_:MenuOption;

		public var lineBreakDesign_:LineBreakDesign;

		public var unableToTeleport:Signal;

		public function PlayerGroupMenu(param1:AbstractMap, param2:Vector.<Player>) {
			this.playerPanels_ = new Vector.<GameObjectListItem>();
			this.unableToTeleport = new Signal();
			super(3552822, 16777215);
			this.map_ = param1;
			this.players_ = param2.concat();
			this.createHeader();
			this.createPlayerList();
		}

		private function createPlayerList():void {
			var loc1:Player = null;
			var loc2:GameObjectListItem = null;
			for each(loc1 in this.players_) {
				loc2 = new GameObjectListItem(11776947, true, loc1);
				loc2.x = 0;
				loc2.y = this.posY;
				addChild(loc2);
				this.playerPanels_.push(loc2);
				loc2.textReady.addOnce(this.onTextChanged);
				this.posY = this.posY + 32;
			}
		}

		private function onTextChanged():void {
			var loc1:GameObjectListItem = null;
			draw();
			for each(loc1 in this.playerPanels_) {
				loc1.textReady.remove(this.onTextChanged);
			}
		}

		private function createHeader():void {
			if (this.map_.allowPlayerTeleport()) {
				this.teleportOption_ = new TeleportMenuOption(this.map_.player_);
				this.teleportOption_.x = 8;
				this.teleportOption_.y = 8;
				this.teleportOption_.addEventListener(MouseEvent.CLICK, this.onTeleport);
				addChild(this.teleportOption_);
				this.lineBreakDesign_ = new LineBreakDesign(150, 1842204);
				this.lineBreakDesign_.x = 6;
				this.lineBreakDesign_.y = 40;
				addChild(this.lineBreakDesign_);
				this.posY = 52;
			}
		}

		private function onTeleport(param1:Event):void {
			var loc4:Player = null;
			var loc2:Player = this.map_.player_;
			var loc3:Player = null;
			for each(loc4 in this.players_) {
				if (loc2.isTeleportEligible(loc4)) {
					loc3 = loc4;
					if (loc2.msUtilTeleport() > Player.MS_BETWEEN_TELEPORT) {
						if (loc4.isFellowGuild_) {
							break;
						}
						continue;
					}
					break;
				}
			}
			if (loc3 != null) {
				loc2.teleportTo(loc3);
			} else {
				this.unableToTeleport.dispatch();
			}
			remove();
		}
	}
}
