package com.company.assembleegameclient.ui.panels.itemgrids.itemtiles {
	import com.company.assembleegameclient.objects.ObjectLibrary;
	import com.company.assembleegameclient.objects.Player;
	import com.company.assembleegameclient.ui.panels.itemgrids.ItemGrid;
	import com.company.assembleegameclient.util.EquipmentUtil;
	import com.company.assembleegameclient.util.FilterUtil;

	import flash.display.Bitmap;

	public class EquipmentTile extends InteractiveItemTile {


		public var backgroundDetail:Bitmap;

		public var itemType:int;

		private var minManaUsage:int;

		public function EquipmentTile(param1:int, param2:ItemGrid, param3:Boolean) {
			super(param1, param2, param3);
		}

		override public function canHoldItem(param1:int):Boolean {
			return param1 <= 0 || this.itemType == ObjectLibrary.getSlotTypeFromType(param1);
		}

		public function setType(param1:int):void {
			this.backgroundDetail = EquipmentUtil.getEquipmentBackground(param1, 4);
			if (this.backgroundDetail) {
				this.backgroundDetail.x = BORDER;
				this.backgroundDetail.y = BORDER;
				this.backgroundDetail.filters = FilterUtil.getGreyColorFilter();
				addChildAt(this.backgroundDetail, 0);
			}
			this.itemType = param1;
		}

		override public function setItem(param1:int):Boolean {
			var loc2:Boolean = super.setItem(param1);
			if (loc2) {
				this.backgroundDetail.visible = itemSprite.itemId <= 0;
				this.updateMinMana();
			}
			return loc2;
		}

		private function updateMinMana():void {
			var loc1:XML = null;
			this.minManaUsage = 0;
			if (itemSprite.itemId > 0) {
				loc1 = ObjectLibrary.xmlLibrary_[itemSprite.itemId];
				if (loc1 && loc1.hasOwnProperty("Usable")) {
					if (loc1.hasOwnProperty("MultiPhase")) {
						this.minManaUsage = loc1.MpEndCost;
					} else {
						this.minManaUsage = loc1.MpCost;
					}
				}
			}
		}

		public function updateDim(param1:Player):void {
			itemSprite.setDim(param1 && (param1.mp_ < this.minManaUsage || this.minManaUsage && param1.isSilenced()));
		}

		override protected function beginDragCallback():void {
			this.backgroundDetail.visible = true;
		}

		override protected function endDragCallback():void {
			this.backgroundDetail.visible = itemSprite.itemId <= 0;
		}

		override protected function getBackgroundColor():int {
			return 4539717;
		}
	}
}
