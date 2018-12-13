package io.decagames.rotmg.pets.popup.info {
	import com.company.assembleegameclient.ui.tooltip.ToolTip;

	import flash.display.Sprite;

	import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
	import io.decagames.rotmg.ui.labels.UILabel;
	import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
	import io.decagames.rotmg.ui.texture.TextureParser;

	public class PetsTooltip extends ToolTip {


		private var title:UILabel;

		private var topDesc:UILabel;

		private var hatchIconContainer:Sprite;

		private var hatchIcon:SliceScalingBitmap;

		private var midDesc:UILabel;

		private var tableLeft:UILabel;

		private var tableCenter:UILabel;

		private var tableRight:UILabel;

		private var tableContainer:Sprite;

		private var botDesc:UILabel;

		public function PetsTooltip() {
			super(3552822, 1, 10197915, 1);
			this.init();
		}

		private function init():void {
			this.createTitle();
			this.createHatchIcons();
			this.createMiddle();
			this.createTable();
			this.createBottom();
		}

		private function createTitle():void {
			this.title = new UILabel();
			DefaultLabelFormat.petNameLabel(this.title, 16777215);
			addChild(this.title);
			this.title.text = "Pets";
			this.title.y = 5;
			this.title.x = 0;
			this.topDesc = new UILabel();
			DefaultLabelFormat.infoTooltipText(this.topDesc, 11184810);
			addChild(this.topDesc);
			this.topDesc.text = "Hatching a pet egg will provide you with a loyal pet that will follow you into battle.";
			this.topDesc.width = 220;
			this.topDesc.wordWrap = true;
			this.topDesc.y = this.title.y + this.title.height;
			this.topDesc.x = 0;
		}

		private function createHatchIcons():void {
			this.hatchIconContainer = new Sprite();
			addChild(this.hatchIconContainer);
			this.hatchIcon = TextureParser.instance.getSliceScalingBitmap("UI", "PetsTooltip", 280);
			this.hatchIconContainer.addChild(this.hatchIcon);
			this.hatchIcon.width = 196;
			this.hatchIcon.height = 62;
			this.hatchIcon.x = 0;
			this.hatchIcon.y = 0;
			this.hatchIconContainer.y = this.topDesc.y + this.topDesc.height + 5;
			this.hatchIconContainer.x = 10;
		}

		private function createMiddle():void {
			this.midDesc = new UILabel();
			DefaultLabelFormat.infoTooltipText(this.midDesc, 11184810);
			addChild(this.midDesc);
			this.midDesc.text = "Level up your pets’ abilities by feeding them items and then fuse them to take them to the next stage of evolution!\n\nEach of your pets can have up to three abilities. A pet’s first ability is determined by its pet family and type, but the second and third abilities are determined at random.\n\nFusing pets will increase the max levels for each of their abilities:";
			this.midDesc.width = 220;
			this.midDesc.wordWrap = true;
			this.midDesc.y = this.hatchIconContainer.y + this.hatchIconContainer.height + 5;
			this.midDesc.x = 0;
		}

		private function createTable():void {
			var loc1:UILabel = null;
			this.tableContainer = new Sprite();
			addChild(this.tableContainer);
			this.tableLeft = new UILabel();
			DefaultLabelFormat.infoTooltipText(this.tableLeft, 11184810);
			this.tableContainer.addChild(this.tableLeft);
			this.tableLeft.text = "Common\nUncommon\nRare\nLegendary\nDivine";
			this.tableLeft.x = 0;
			loc1 = new UILabel();
			DefaultLabelFormat.infoTooltipText(loc1, 6539085);
			this.tableContainer.addChild(loc1);
			loc1.text = "1st Ability";
			loc1.x = 80;
			loc1.y = 0;
			var loc2:UILabel = new UILabel();
			DefaultLabelFormat.infoTooltipText(loc2, 6539085);
			this.tableContainer.addChild(loc2);
			loc2.text = "2nd Ability";
			loc2.x = 80;
			loc2.y = loc1.y + loc1.height - 4;
			var loc3:UILabel = new UILabel();
			DefaultLabelFormat.infoTooltipText(loc3, 5082311);
			this.tableContainer.addChild(loc3);
			loc3.text = "Evolution";
			loc3.x = 80;
			loc3.y = loc2.y + loc2.height - 4;
			var loc4:UILabel = new UILabel();
			DefaultLabelFormat.infoTooltipText(loc4, 6539085);
			this.tableContainer.addChild(loc4);
			loc4.text = "3rd Ability";
			loc4.x = 80;
			loc4.y = loc3.y + loc3.height - 4;
			var loc5:UILabel = new UILabel();
			DefaultLabelFormat.infoTooltipText(loc5, 5082311);
			this.tableContainer.addChild(loc5);
			loc5.text = "Evolution";
			loc5.x = 80;
			loc5.y = loc4.y + loc4.height - 4;
			this.tableRight = new UILabel();
			DefaultLabelFormat.infoTooltipText(this.tableRight, 11184810);
			this.tableContainer.addChild(this.tableRight);
			this.tableRight.text = "Lvl. 30\nLvl. 50\nLvl. 70\nLvl. 90\nLvl. 100";
			this.tableRight.x = 160;
			this.tableContainer.height = 80;
			this.tableContainer.y = this.midDesc.y + this.midDesc.height + 5;
			this.tableContainer.x = 0;
		}

		private function createBottom():void {
			this.botDesc = new UILabel();
			DefaultLabelFormat.infoTooltipText(this.botDesc, 11184810);
			addChild(this.botDesc);
			this.botDesc.text = "As you fuse your pets from Uncommon to Rare and Legendary to Divine, they will evolve to get a new name and look!";
			this.botDesc.width = 220;
			this.botDesc.wordWrap = true;
			this.botDesc.y = this.tableContainer.y + this.tableContainer.height + 5;
			this.botDesc.x = 0;
		}
	}
}
