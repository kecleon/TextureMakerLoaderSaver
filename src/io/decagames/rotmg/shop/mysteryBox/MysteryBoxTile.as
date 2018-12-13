 
package io.decagames.rotmg.shop.mysteryBox {
	import flash.geom.Point;
	import io.decagames.rotmg.shop.genericBox.GenericBoxTile;
	import io.decagames.rotmg.shop.mysteryBox.contentPopup.UIItemContainer;
	import io.decagames.rotmg.ui.gird.UIGrid;
	import kabam.rotmg.mysterybox.model.MysteryBoxInfo;
	
	public class MysteryBoxTile extends GenericBoxTile {
		 
		
		private var displayedItemsGrid:UIGrid;
		
		private var maxResultHeight:int = 75;
		
		private var maxResultWidth:int;
		
		private var resultElementWidth:int;
		
		private var gridConfig:Point;
		
		public function MysteryBoxTile(param1:MysteryBoxInfo) {
			buyButtonBitmapBackground = "shop_box_button_background";
			super(param1);
		}
		
		private function prepareResultGrid(param1:int) : void {
			this.maxResultWidth = 160;
			this.gridConfig = this.calculateGrid(param1);
			this.resultElementWidth = this.calculateElementSize(this.gridConfig);
			this.displayedItemsGrid = new UIGrid(this.resultElementWidth * this.gridConfig.x,this.gridConfig.x,0);
			this.displayedItemsGrid.x = 20 + Math.round((this.maxResultWidth - this.resultElementWidth * this.gridConfig.x) / 2);
			this.displayedItemsGrid.y = Math.round(42 + (this.maxResultHeight - this.resultElementWidth * this.gridConfig.y) / 2);
			this.displayedItemsGrid.centerLastRow = true;
			addChild(this.displayedItemsGrid);
		}
		
		private function calculateGrid(param1:int) : Point {
			var loc5:int = 0;
			var loc6:int = 0;
			var loc2:Point = new Point(11,4);
			var loc3:int = int.MIN_VALUE;
			if(param1 >= loc2.x * loc2.y) {
				return loc2;
			}
			var loc4:int = 11;
			while(loc4 >= 1) {
				loc5 = 4;
				while(loc5 >= 1) {
					if(loc4 * loc5 >= param1 && (loc4 - 1) * (loc5 - 1) < param1) {
						loc6 = this.calculateElementSize(new Point(loc4,loc5));
						if(loc6 != -1) {
							if(loc6 > loc3) {
								loc3 = loc6;
								loc2 = new Point(loc4,loc5);
							} else if(loc6 == loc3) {
								if(loc2.x * loc2.y - param1 > loc4 * loc5 - param1) {
									loc3 = loc6;
									loc2 = new Point(loc4,loc5);
								}
							}
						}
					}
					loc5--;
				}
				loc4--;
			}
			return loc2;
		}
		
		private function calculateElementSize(param1:Point) : int {
			var loc2:int = Math.floor(this.maxResultHeight / param1.y);
			if(loc2 * param1.x > this.maxResultWidth) {
				loc2 = Math.floor(this.maxResultWidth / param1.x);
			}
			if(loc2 * param1.y > this.maxResultHeight) {
				return -1;
			}
			return loc2;
		}
		
		override protected function createBoxBackground() : void {
			var loc2:int = 0;
			var loc4:UIItemContainer = null;
			var loc1:Array = MysteryBoxInfo(_boxInfo).displayedItems.split(",");
			if(loc1.length == 0 || MysteryBoxInfo(_boxInfo).displayedItems == "") {
				return;
			}
			if(_infoButton) {
				_infoButton.alpha = 0;
			}
			switch(loc1.length) {
				case 1:
					break;
				case 2:
					loc2 = 50;
					break;
				case 3:
			}
			this.prepareResultGrid(loc1.length);
			var loc3:int = 0;
			while(loc3 < loc1.length) {
				loc4 = new UIItemContainer(loc1[loc3],0,0,this.resultElementWidth);
				this.displayedItemsGrid.addGridElement(loc4);
				loc3++;
			}
		}
		
		override public function resize(param1:int, param2:int = -1) : void {
			background.width = param1;
			backgroundTitle.width = param1;
			backgroundButton.width = param1;
			background.height = 184;
			backgroundTitle.y = 2;
			titleLabel.x = Math.round((param1 - titleLabel.textWidth) / 2);
			titleLabel.y = 6;
			backgroundButton.y = 133;
			_buyButton.y = backgroundButton.y + 4;
			_buyButton.x = param1 - 110;
			_infoButton.x = 130;
			_infoButton.y = 45;
			if(this.displayedItemsGrid) {
				this.displayedItemsGrid.x = 10 + Math.round((this.maxResultWidth - this.resultElementWidth * this.gridConfig.x) / 2);
			}
			updateSaleLabel();
			updateClickMask(param1);
			updateTimeEndString(param1);
			updateStartTimeString(param1);
		}
		
		override public function dispose() : void {
			if(this.displayedItemsGrid) {
				this.displayedItemsGrid.dispose();
			}
			super.dispose();
		}
	}
}
