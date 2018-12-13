 
package com.company.assembleegameclient.ui.panels.itemgrids {
	import com.company.assembleegameclient.objects.GameObject;
	import com.company.assembleegameclient.objects.Player;
	import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.InventoryTile;
	import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.ItemTile;
	
	public class InventoryGrid extends ItemGrid {
		 
		
		private const NUM_SLOTS:uint = 8;
		
		private var _tiles:Vector.<InventoryTile>;
		
		private var isBackpack:Boolean;
		
		public function InventoryGrid(param1:GameObject, param2:Player, param3:int = 0, param4:Boolean = false) {
			var loc6:InventoryTile = null;
			super(param1,param2,param3);
			this._tiles = new Vector.<InventoryTile>(this.NUM_SLOTS);
			this.isBackpack = param4;
			var loc5:int = 0;
			while(loc5 < this.NUM_SLOTS) {
				loc6 = new InventoryTile(loc5 + indexOffset,this,interactive);
				loc6.addTileNumber(loc5 + 1);
				addToGrid(loc6,2,loc5);
				this._tiles[loc5] = loc6;
				loc5++;
			}
		}
		
		public function getItemById(param1:int) : InventoryTile {
			var loc2:InventoryTile = null;
			for each(loc2 in this._tiles) {
				if(loc2.getItemId() == param1) {
					return loc2;
				}
			}
			return null;
		}
		
		override public function setItems(param1:Vector.<int>, param2:int = 0) : void {
			var loc3:Boolean = false;
			var loc4:int = 0;
			var loc5:int = 0;
			if(param1) {
				loc3 = false;
				loc4 = param1.length;
				loc5 = 0;
				while(loc5 < this.NUM_SLOTS) {
					if(loc5 + indexOffset < loc4) {
						if(this._tiles[loc5].setItem(param1[loc5 + indexOffset])) {
							loc3 = true;
						}
					} else if(this._tiles[loc5].setItem(-1)) {
						loc3 = true;
					}
					loc5++;
				}
				if(loc3) {
					refreshTooltip();
				}
			}
		}
		
		public function get tiles() : Vector.<InventoryTile> {
			return this._tiles.concat();
		}
		
		public function toggleTierTags(param1:Boolean) : void {
			var loc2:ItemTile = null;
			for each(loc2 in this._tiles) {
				loc2.toggleTierTag(param1);
			}
		}
	}
}
