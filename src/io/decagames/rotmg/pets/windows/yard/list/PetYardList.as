package io.decagames.rotmg.pets.windows.yard.list {
	import flash.display.Sprite;

	import io.decagames.rotmg.pets.components.petItem.PetItem;
	import io.decagames.rotmg.ui.buttons.BaseButton;
	import io.decagames.rotmg.ui.buttons.SliceScalingButton;
	import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
	import io.decagames.rotmg.ui.gird.UIGrid;
	import io.decagames.rotmg.ui.gird.UIGridElement;
	import io.decagames.rotmg.ui.labels.UILabel;
	import io.decagames.rotmg.ui.scroll.UIScrollbar;
	import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
	import io.decagames.rotmg.ui.texture.TextureParser;
	import io.decagames.rotmg.utils.colors.Tint;

	public class PetYardList extends Sprite {

		public static var YARD_WIDTH:int = 275;

		public static const YARD_HEIGHT:int = 425;


		private var yardContainer:Sprite;

		private var contentInset:SliceScalingBitmap;

		private var contentTitle:SliceScalingBitmap;

		private var title:UILabel;

		private var contentGrid:UIGrid;

		private var contentElement:UIGridElement;

		private var petGrid:UIGrid;

		private var _upgradeButton:SliceScalingButton;

		public function PetYardList() {
			super();
			this.contentGrid = new UIGrid(YARD_WIDTH - 55, 1, 15);
			this.contentInset = TextureParser.instance.getSliceScalingBitmap("UI", "popup_content_inset", YARD_WIDTH);
			addChild(this.contentInset);
			this.contentInset.height = YARD_HEIGHT;
			this.contentInset.x = 0;
			this.contentInset.y = 0;
			this.contentTitle = TextureParser.instance.getSliceScalingBitmap("UI", "content_title_decoration", YARD_WIDTH);
			addChild(this.contentTitle);
			this.contentTitle.x = 0;
			this.contentTitle.y = 0;
			this.title = new UILabel();
			this.title.text = "Pet Yard";
			DefaultLabelFormat.petNameLabel(this.title, 16777215);
			this.title.width = YARD_WIDTH;
			this.title.wordWrap = true;
			this.title.y = 3;
			this.title.x = 0;
			addChild(this.title);
			this.createScrollview();
			this.createPetsGrid();
		}

		public function showPetYardRarity(param1:String, param2:Boolean):void {
			var loc3:SliceScalingBitmap = null;
			var loc4:UILabel = null;
			loc3 = TextureParser.instance.getSliceScalingBitmap("UI", "content_divider_smalltitle_white", 180);
			Tint.add(loc3, 3355443, 1);
			addChild(loc3);
			loc3.x = Math.round((YARD_WIDTH - loc3.width) / 2);
			loc3.y = 23;
			loc4 = new UILabel();
			DefaultLabelFormat.petYardRarity(loc4);
			loc4.text = param1;
			loc4.width = loc3.width;
			loc4.wordWrap = true;
			loc4.y = loc3.y + 2;
			loc4.x = loc3.x;
			addChild(loc4);
			if (param2) {
				this._upgradeButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI", "upgrade_button"));
				this._upgradeButton.x = loc3.x + loc3.width - this._upgradeButton.width + 8;
				this._upgradeButton.y = loc3.y - this._upgradeButton.height / 2 + 8;
				addChild(this._upgradeButton);
			}
		}

		private function createScrollview():void {
			var loc1:Sprite = null;
			loc1 = new Sprite();
			this.yardContainer = new Sprite();
			this.yardContainer.x = this.contentInset.x;
			this.yardContainer.y = 2;
			this.yardContainer.addChild(this.contentGrid);
			loc1.addChild(this.yardContainer);
			var loc2:UIScrollbar = new UIScrollbar(YARD_HEIGHT - 60);
			loc2.mouseRollSpeedFactor = 1;
			loc2.scrollObject = this;
			loc2.content = this.yardContainer;
			loc1.addChild(loc2);
			loc2.x = this.contentInset.x + this.contentInset.width - 25;
			loc2.y = 7;
			var loc3:Sprite = new Sprite();
			loc3.graphics.beginFill(0);
			loc3.graphics.drawRect(0, 0, YARD_WIDTH, 380);
			loc3.x = this.yardContainer.x;
			loc3.y = this.yardContainer.y;
			this.yardContainer.mask = loc3;
			loc1.addChild(loc3);
			addChild(loc1);
			loc1.y = 45;
		}

		public function addPet(param1:PetItem):void {
			var loc2:UIGridElement = new UIGridElement();
			loc2.addChild(param1);
			this.petGrid.addGridElement(loc2);
		}

		public function clearPetsList():void {
			this.petGrid.clearGrid();
		}

		private function createPetsGrid():void {
			this.contentElement = new UIGridElement();
			this.petGrid = new UIGrid(YARD_WIDTH - 55, 5, 5);
			this.petGrid.x = 18;
			this.petGrid.y = 8;
			this.contentElement.addChild(this.petGrid);
			this.contentGrid.addGridElement(this.contentElement);
		}

		public function get upgradeButton():BaseButton {
			return this._upgradeButton;
		}
	}
}
