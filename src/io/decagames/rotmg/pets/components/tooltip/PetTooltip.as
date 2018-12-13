package io.decagames.rotmg.pets.components.tooltip {
	import com.company.assembleegameclient.objects.ObjectLibrary;
	import com.company.assembleegameclient.ui.LineBreakDesign;
	import com.company.assembleegameclient.ui.tooltip.ToolTip;
	import com.company.assembleegameclient.ui.tooltip.TooltipHelper;

	import flash.display.Bitmap;
	import flash.display.Sprite;

	import io.decagames.rotmg.pets.components.petStatsGrid.PetStatsGrid;
	import io.decagames.rotmg.pets.data.family.PetFamilyColors;
	import io.decagames.rotmg.pets.data.family.PetFamilyKeys;
	import io.decagames.rotmg.pets.data.rarity.PetRarityEnum;
	import io.decagames.rotmg.pets.data.vo.AbilityVO;
	import io.decagames.rotmg.pets.data.vo.IPetVO;
	import io.decagames.rotmg.pets.utils.PetsConstants;
	import io.decagames.rotmg.pets.utils.PetsViewAssetFactory;
	import io.decagames.rotmg.ui.gird.UIGrid;

	import kabam.rotmg.text.view.TextFieldDisplayConcrete;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;
	import kabam.rotmg.ui.model.TabStripModel;

	public class PetTooltip extends ToolTip {


		private const petsContent:Sprite = new Sprite();

		private const titleTextField:TextFieldDisplayConcrete = PetsViewAssetFactory.returnTextfield(16777215, 16, true);

		private const petRarityTextField:TextFieldDisplayConcrete = PetsViewAssetFactory.returnTextfield(11776947, 12, false);

		private const petFamilyTextField:TextFieldDisplayConcrete = PetsViewAssetFactory.returnTextfield(11776947, 12, false);

		private const petProbabilityInfoField:TextFieldDisplayConcrete = PetsViewAssetFactory.returnTextfield(11776947, 12, false);

		private const lineBreak:LineBreakDesign = PetsViewAssetFactory.returnTooltipLineBreak();

		private var petBitmap:Bitmap;

		private var petVO:IPetVO;

		public function PetTooltip(param1:IPetVO) {
			this.petVO = param1;
			super(3552822, 1, 16777215, 1, true);
			this.petsContent.name = TabStripModel.PETS;
		}

		public function init():void {
			this.petBitmap = this.petVO.getSkinBitmap();
			this.addChildren();
			if (this.hasAbilities) {
				this.addAbilities();
			}
			this.positionChildren();
			this.updateTextFields();
		}

		private function updateTextFields():void {
			this.titleTextField.setColor(this.petVO.rarity.color);
			this.titleTextField.setStringBuilder(new LineBuilder().setParams(this.petVO.name));
			this.petRarityTextField.setStringBuilder(new LineBuilder().setParams(this.petVO.rarity.rarityKey));
			this.petFamilyTextField.setStringBuilder(new LineBuilder().setParams(PetFamilyKeys.getTranslationKey(this.petVO.family))).setColor(PetFamilyColors.getColorByFamilyKey(this.petVO.family));
			this.petProbabilityInfoField.setHTML(true).setText(this.getProbabilityTip());
		}

		private function getProbabilityTip():String {
			var loc1:XML = ObjectLibrary.xmlLibrary_[this.petVO.getType()];
			if (loc1 == null) {
				return "";
			}
			if (loc1.hasOwnProperty("NoHatchOrFuse")) {
				return this.makeProbabilityTipLine("not", TooltipHelper.WORSE_COLOR);
			}
			if (loc1.hasOwnProperty("BasicPet")) {
				return this.makeProbabilityTipLine("commonly", TooltipHelper.BETTER_COLOR);
			}
			return this.makeProbabilityTipLine("rarely", TooltipHelper.NO_DIFF_COLOR);
		}

		private function makeProbabilityTipLine(param1:String, param2:uint):String {
			return "Can " + TooltipHelper.wrapInFontTag(param1, "#" + param2.toString(16)) + " be obtained\nthrough hatching or fusion.";
		}

		private function addChildren():void {
			this.clearChildren();
			this.petsContent.graphics.beginFill(0, 0);
			this.petsContent.graphics.drawRect(0, 0, PetsConstants.TOOLTIP_WIDTH, !!this.hasAbilities ? Number(PetsConstants.TOOLTIP_HEIGHT) : Number(PetsConstants.TOOLTIP_HEIGHT_NO_ABILITIES));
			this.petsContent.addChild(this.petBitmap);
			this.petsContent.addChild(this.titleTextField);
			this.petsContent.addChild(this.petRarityTextField);
			this.petsContent.addChild(this.petFamilyTextField);
			this.petsContent.addChild(this.petProbabilityInfoField);
			if (this.hasAbilities) {
				this.petsContent.addChild(this.lineBreak);
			}
			if (!contains(this.petsContent)) {
				addChild(this.petsContent);
			}
		}

		private function clearChildren():void {
			this.petsContent.graphics.clear();
			while (this.petsContent.numChildren > 0) {
				this.petsContent.removeChildAt(0);
			}
		}

		private function get hasAbilities():Boolean {
			var loc1:AbilityVO = null;
			for each(loc1 in this.petVO.abilityList) {
				if (loc1.getUnlocked() && loc1.level > 0) {
					return true;
				}
			}
			return false;
		}

		private function addAbilities():void {
			var loc1:UIGrid = new PetStatsGrid(178, this.petVO);
			this.petsContent.addChild(loc1);
			loc1.y = 104;
			loc1.x = 2;
		}

		private function getNumAbilities():uint {
			var loc1:Boolean = this.petVO.rarity.rarityKey == PetRarityEnum.DIVINE.rarityKey || this.petVO.rarity.rarityKey == PetRarityEnum.LEGENDARY.rarityKey;
			if (loc1) {
				return 2;
			}
			return 3;
		}

		private function positionChildren():void {
			this.titleTextField.x = 55;
			this.titleTextField.y = 21;
			this.petRarityTextField.x = 55;
			this.petRarityTextField.y = 35;
			this.petFamilyTextField.x = 55;
			this.petFamilyTextField.y = 48;
			this.petProbabilityInfoField.x = 0;
			this.petProbabilityInfoField.y = 54;
		}
	}
}
