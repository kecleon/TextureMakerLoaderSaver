package io.decagames.rotmg.shop.packages.contentPopup {
	import flash.utils.Dictionary;

	import io.decagames.rotmg.shop.mysteryBox.contentPopup.ItemBox;
	import io.decagames.rotmg.shop.mysteryBox.contentPopup.SlotBox;
	import io.decagames.rotmg.ui.buttons.BaseButton;
	import io.decagames.rotmg.ui.buttons.SliceScalingButton;
	import io.decagames.rotmg.ui.gird.UIGrid;
	import io.decagames.rotmg.ui.popups.header.PopupHeader;
	import io.decagames.rotmg.ui.popups.signals.ClosePopupSignal;
	import io.decagames.rotmg.ui.texture.TextureParser;

	import robotlegs.bender.bundles.mvcs.Mediator;

	public class PackageBoxContentPopupMediator extends Mediator {


		[Inject]
		public var view:PackageBoxContentPopup;

		[Inject]
		public var closePopupSignal:ClosePopupSignal;

		private var closeButton:SliceScalingButton;

		private var contentGrids:UIGrid;

		public function PackageBoxContentPopupMediator() {
			super();
		}

		override public function initialize():void {
			this.closeButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI", "close_button"));
			this.closeButton.clickSignal.addOnce(this.onClose);
			this.view.header.addButton(this.closeButton, PopupHeader.RIGHT_BUTTON);
			this.addContentList(this.view.info.contents, this.view.info.charSlot, this.view.info.vaultSlot, this.view.info.gold);
		}

		private function addContentList(param1:String, param2:int, param3:int, param4:int):void {
			var loc7:Array = null;
			var loc8:Dictionary = null;
			var loc9:String = null;
			var loc10:* = null;
			var loc11:ItemBox = null;
			var loc12:SlotBox = null;
			var loc13:SlotBox = null;
			var loc14:SlotBox = null;
			var loc5:int = 5;
			var loc6:Number = 260 - loc5;
			this.contentGrids = new UIGrid(loc6, 1, 2);
			if (param1 != "") {
				loc7 = param1.split(",");
				loc8 = new Dictionary();
				for each(loc9 in loc7) {
					if (loc8[loc9]) {
						loc8[loc9]++;
					} else {
						loc8[loc9] = 1;
					}
				}
				for (loc10 in loc8) {
					loc11 = new ItemBox(loc10, loc8[loc10], true, "", false);
					this.contentGrids.addGridElement(loc11);
				}
			}
			if (param2 > 0) {
				loc12 = new SlotBox(SlotBox.CHAR_SLOT, param2, true, "", false);
				this.contentGrids.addGridElement(loc12);
			}
			if (param3 > 0) {
				loc13 = new SlotBox(SlotBox.VAULT_SLOT, param3, true, "", false);
				this.contentGrids.addGridElement(loc13);
			}
			if (param4 > 0) {
				loc14 = new SlotBox(SlotBox.GOLD_SLOT, param4, true, "", false);
				this.contentGrids.addGridElement(loc14);
			}
			this.contentGrids.y = this.view.infoLabel.textHeight + 8;
			this.contentGrids.x = 10;
			this.view.addChild(this.contentGrids);
		}

		override public function destroy():void {
			this.closeButton.clickSignal.remove(this.onClose);
			this.closeButton.dispose();
			this.contentGrids.dispose();
			this.contentGrids = null;
		}

		private function onClose(param1:BaseButton):void {
			this.closePopupSignal.dispatch(this.view);
		}
	}
}
