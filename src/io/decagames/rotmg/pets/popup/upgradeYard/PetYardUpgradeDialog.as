 
package io.decagames.rotmg.pets.popup.upgradeYard {
	import com.company.assembleegameclient.util.Currency;
	import io.decagames.rotmg.pets.data.rarity.PetRarityEnum;
	import io.decagames.rotmg.shop.ShopBuyButton;
	import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
	import io.decagames.rotmg.ui.labels.UILabel;
	import io.decagames.rotmg.ui.popups.modal.ModalPopup;
	import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
	import io.decagames.rotmg.ui.texture.TextureParser;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;
	
	public class PetYardUpgradeDialog extends ModalPopup {
		 
		
		private var _upgradeGoldButton:ShopBuyButton;
		
		private var _upgradeFameButton:ShopBuyButton;
		
		private var upgradeButtonsMargin:int = 20;
		
		public function PetYardUpgradeDialog(param1:PetRarityEnum, param2:int, param3:int) {
			var loc4:SliceScalingBitmap = null;
			var loc5:UILabel = null;
			var loc6:UILabel = null;
			super(270,0,"Upgrade Pet Yard");
			loc4 = TextureParser.instance.getSliceScalingBitmap("UI","petYard_" + LineBuilder.getLocalizedStringFromKey("{" + param1.rarityKey + "}"));
			loc4.x = Math.round((contentWidth - loc4.width) / 2);
			addChild(loc4);
			loc5 = new UILabel();
			DefaultLabelFormat.petYardUpgradeInfo(loc5);
			loc5.x = 50;
			loc5.y = loc4.height + 10;
			loc5.width = 170;
			loc5.wordWrap = true;
			loc5.text = LineBuilder.getLocalizedStringFromKey("YardUpgraderView.info");
			addChild(loc5);
			loc6 = new UILabel();
			DefaultLabelFormat.petYardUpgradeRarityInfo(loc6);
			loc6.y = loc5.y + loc5.textHeight + 8;
			loc6.width = contentWidth;
			loc6.wordWrap = true;
			loc6.text = LineBuilder.getLocalizedStringFromKey("{" + param1.rarityKey + "}");
			addChild(loc6);
			this._upgradeGoldButton = new ShopBuyButton(param2,Currency.GOLD);
			this._upgradeFameButton = new ShopBuyButton(param3,Currency.FAME);
			this._upgradeGoldButton.width = this._upgradeFameButton.width = 120;
			this._upgradeGoldButton.y = this._upgradeFameButton.y = loc6.y + loc6.height + 15;
			var loc7:int = (contentWidth - (this._upgradeGoldButton.width + this._upgradeFameButton.width + this.upgradeButtonsMargin)) / 2;
			this._upgradeGoldButton.x = loc7;
			this._upgradeFameButton.x = this._upgradeGoldButton.x + this._upgradeGoldButton.width + this.upgradeButtonsMargin;
			addChild(this._upgradeGoldButton);
			addChild(this._upgradeFameButton);
		}
		
		public function get upgradeGoldButton() : ShopBuyButton {
			return this._upgradeGoldButton;
		}
		
		public function get upgradeFameButton() : ShopBuyButton {
			return this._upgradeFameButton;
		}
	}
}
