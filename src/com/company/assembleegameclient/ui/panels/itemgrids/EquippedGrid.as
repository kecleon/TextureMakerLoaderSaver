package com.company.assembleegameclient.ui.panels.itemgrids {
	import com.company.assembleegameclient.objects.GameObject;
	import com.company.assembleegameclient.objects.Player;
	import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.EquipmentTile;
	import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.ItemTile;
	import com.company.assembleegameclient.util.EquipmentUtil;
	import com.company.util.ArrayIterator;
	import com.company.util.IIterator;

	import kabam.lib.util.VectorAS3Util;

	public class EquippedGrid extends ItemGrid {


		private var tiles:Vector.<EquipmentTile>;

		private var _invTypes:Vector.<int>;

		public function EquippedGrid(param1:GameObject, param2:Vector.<int>, param3:Player, param4:int = 0) {
			super(param1, param3, param4);
			this._invTypes = param2;
			this.init();
		}

		private function init():void {
			var loc3:EquipmentTile = null;
			var loc1:int = EquipmentUtil.NUM_SLOTS;
			this.tiles = new Vector.<EquipmentTile>(loc1);
			var loc2:int = 0;
			while (loc2 < loc1) {
				loc3 = new EquipmentTile(loc2, this, interactive);
				addToGrid(loc3, 1, loc2);
				loc3.setType(this._invTypes[loc2]);
				this.tiles[loc2] = loc3;
				loc2++;
			}
		}

		public function createInteractiveItemTileIterator():IIterator {
			return new ArrayIterator(VectorAS3Util.toArray(this.tiles));
		}

		override public function setItems(param1:Vector.<int>, param2:int = 0):void {
			if (!param1) {
				return;
			}
			var loc3:int = param1.length;
			var loc4:int = 0;
			while (loc4 < this.tiles.length) {
				if (loc4 + param2 < loc3) {
					this.tiles[loc4].setItem(param1[loc4 + param2]);
				} else {
					this.tiles[loc4].setItem(-1);
				}
				this.tiles[loc4].updateDim(curPlayer);
				loc4++;
			}
		}

		public function toggleTierTags(param1:Boolean):void {
			var loc2:ItemTile = null;
			for each(loc2 in this.tiles) {
				loc2.toggleTierTag(param1);
			}
		}
	}
}
