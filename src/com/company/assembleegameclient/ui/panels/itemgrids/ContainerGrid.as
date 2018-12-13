 
package com.company.assembleegameclient.ui.panels.itemgrids {
	import com.company.assembleegameclient.objects.GameObject;
	import com.company.assembleegameclient.objects.Player;
	import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.InteractiveItemTile;
	
	public class ContainerGrid extends ItemGrid {
		 
		
		private const NUM_SLOTS:uint = 8;
		
		private var tiles:Vector.<InteractiveItemTile>;
		
		public function ContainerGrid(param1:GameObject, param2:Player) {
			var loc4:InteractiveItemTile = null;
			super(param1,param2,0);
			this.tiles = new Vector.<InteractiveItemTile>(this.NUM_SLOTS);
			var loc3:int = 0;
			while(loc3 < this.NUM_SLOTS) {
				loc4 = new InteractiveItemTile(loc3 + indexOffset,this,interactive);
				addToGrid(loc4,2,loc3);
				this.tiles[loc3] = loc4;
				loc3++;
			}
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
						if(this.tiles[loc5].setItem(param1[loc5 + indexOffset])) {
							loc3 = true;
						}
					} else if(this.tiles[loc5].setItem(-1)) {
						loc3 = true;
					}
					loc5++;
				}
				if(loc3) {
					refreshTooltip();
				}
			}
		}
	}
}
