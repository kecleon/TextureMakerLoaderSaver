package com.company.assembleegameclient.map.partyoverlay {
	import com.company.assembleegameclient.objects.GameObject;
	import com.company.assembleegameclient.objects.Player;
	import com.company.assembleegameclient.ui.menu.Menu;
	import com.company.assembleegameclient.ui.menu.PlayerGroupMenu;
	import com.company.assembleegameclient.ui.tooltip.PlayerGroupToolTip;

	import flash.events.MouseEvent;

	public class PlayerArrow extends GameObjectArrow {


		public function PlayerArrow() {
			super(16777215, 4179794, false);
		}

		override protected function onMouseOver(param1:MouseEvent):void {
			super.onMouseOver(param1);
			setToolTip(new PlayerGroupToolTip(this.getFullPlayerVec(), false));
		}

		override protected function onMouseOut(param1:MouseEvent):void {
			super.onMouseOut(param1);
			setToolTip(null);
		}

		override protected function onMouseDown(param1:MouseEvent):void {
			super.onMouseDown(param1);
			removeMenu();
			setMenu(this.getMenu());
		}

		protected function getMenu():Menu {
			var loc1:Player = go_ as Player;
			if (loc1 == null || loc1.map_ == null) {
				return null;
			}
			var loc2:Player = loc1.map_.player_;
			if (loc2 == null) {
				return null;
			}
			return new PlayerGroupMenu(loc1.map_, this.getFullPlayerVec());
		}

		private function getFullPlayerVec():Vector.<Player> {
			var loc2:GameObject = null;
			var loc1:Vector.<Player> = new <Player>[go_ as Player];
			for each(loc2 in extraGOs_) {
				loc1.push(loc2 as Player);
			}
			return loc1;
		}
	}
}
