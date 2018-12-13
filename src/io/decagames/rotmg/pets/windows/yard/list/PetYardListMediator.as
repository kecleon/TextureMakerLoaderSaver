 
package io.decagames.rotmg.pets.windows.yard.list {
	import com.company.assembleegameclient.ui.tooltip.TextToolTip;
	import flash.events.MouseEvent;
	import io.decagames.rotmg.pets.components.petItem.PetItem;
	import io.decagames.rotmg.pets.data.PetsModel;
	import io.decagames.rotmg.pets.data.rarity.PetRarityEnum;
	import io.decagames.rotmg.pets.data.vo.PetVO;
	import io.decagames.rotmg.pets.popup.upgradeYard.PetYardUpgradeDialog;
	import io.decagames.rotmg.pets.signals.ActivatePet;
	import io.decagames.rotmg.pets.signals.EvolvePetSignal;
	import io.decagames.rotmg.pets.signals.NewAbilitySignal;
	import io.decagames.rotmg.pets.signals.ReleasePetSignal;
	import io.decagames.rotmg.pets.signals.SelectPetSignal;
	import io.decagames.rotmg.pets.utils.PetItemFactory;
	import io.decagames.rotmg.ui.buttons.BaseButton;
	import io.decagames.rotmg.ui.popups.signals.ShowPopupSignal;
	import kabam.rotmg.account.core.Account;
	import kabam.rotmg.core.signals.HideTooltipsSignal;
	import kabam.rotmg.core.signals.ShowTooltipSignal;
	import kabam.rotmg.messaging.impl.EvolvePetInfo;
	import kabam.rotmg.tooltips.HoverTooltipDelegate;
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	public class PetYardListMediator extends Mediator {
		 
		
		[Inject]
		public var view:PetYardList;
		
		[Inject]
		public var selectPetSignal:SelectPetSignal;
		
		[Inject]
		public var activatePet:ActivatePet;
		
		[Inject]
		public var petIconFactory:PetItemFactory;
		
		[Inject]
		public var model:PetsModel;
		
		[Inject]
		public var newAbilityUnlocked:NewAbilitySignal;
		
		[Inject]
		public var evolvePetSignal:EvolvePetSignal;
		
		[Inject]
		public var showTooltipSignal:ShowTooltipSignal;
		
		[Inject]
		public var hideTooltipSignal:HideTooltipsSignal;
		
		[Inject]
		public var showDialog:ShowPopupSignal;
		
		[Inject]
		public var account:Account;
		
		[Inject]
		public var release:ReleasePetSignal;
		
		private var toolTip:TextToolTip = null;
		
		private var hoverTooltipDelegate:HoverTooltipDelegate;
		
		private var petsList:Vector.<PetItem>;
		
		public function PetYardListMediator() {
			super();
		}
		
		override public function initialize() : void {
			this.model.activeUIVO = null;
			this.refreshPetsList();
			this.selectPetVO(this.model.getActivePet());
			this.newAbilityUnlocked.add(this.abilityUnlocked);
			this.evolvePetSignal.add(this.evolvePetHandler);
			var loc1:PetRarityEnum = PetRarityEnum.selectByOrdinal(this.model.getPetYardType() - 1);
			var loc2:PetRarityEnum = PetRarityEnum.selectByOrdinal(this.model.getPetYardType());
			this.view.showPetYardRarity(loc1.rarityName,loc1.ordinal < PetRarityEnum.DIVINE.ordinal && this.account.isRegistered());
			if(this.view.upgradeButton) {
				this.view.upgradeButton.clickSignal.add(this.upgradeYard);
				this.toolTip = new TextToolTip(3552822,10197915,"Upgrade Pet Yard","Upgrading your yard allows you to fuse pets up to " + loc2.rarityName,180);
				this.hoverTooltipDelegate = new HoverTooltipDelegate();
				this.hoverTooltipDelegate.setShowToolTipSignal(this.showTooltipSignal);
				this.hoverTooltipDelegate.setHideToolTipsSignal(this.hideTooltipSignal);
				this.hoverTooltipDelegate.setDisplayObject(this.view.upgradeButton);
				this.hoverTooltipDelegate.tooltip = this.toolTip;
			}
			this.release.add(this.onRelease);
		}
		
		override public function destroy() : void {
			this.clearList();
			this.newAbilityUnlocked.remove(this.abilityUnlocked);
			this.evolvePetSignal.remove(this.evolvePetHandler);
			if(this.view.upgradeButton) {
				this.view.upgradeButton.clickSignal.add(this.upgradeYard);
			}
			this.release.remove(this.onRelease);
		}
		
		private function upgradeYard(param1:BaseButton) : void {
			this.showDialog.dispatch(new PetYardUpgradeDialog(PetRarityEnum.selectByOrdinal(this.model.getPetYardType()),this.model.getPetYardUpgradeGoldPrice(),this.model.getPetYardUpgradeFamePrice()));
		}
		
		private function selectPetVO(param1:PetVO) : void {
			var loc2:PetItem = null;
			this.model.activeUIVO = param1;
			for each(loc2 in this.petsList) {
				loc2.selected = loc2.getPetVO() == param1;
			}
		}
		
		private function onPetSelected(param1:MouseEvent) : void {
			var loc2:PetItem = PetItem(param1.currentTarget);
			this.selectPetSignal.dispatch(loc2.getPetVO());
			this.selectPetVO(loc2.getPetVO());
		}
		
		private function clearList() : void {
			var loc1:PetItem = null;
			for each(loc1 in this.petsList) {
				loc1.removeEventListener(MouseEvent.CLICK,this.onPetSelected);
			}
			this.petsList = new Vector.<PetItem>();
		}
		
		private function refreshPetsList() : void {
			var loc2:PetVO = null;
			var loc3:PetItem = null;
			this.clearList();
			this.view.clearPetsList();
			this.petsList = new Vector.<PetItem>();
			var loc1:Vector.<PetVO> = this.model.getAllPets();
			loc1 = loc1.sort(this.sortByFamily);
			for each(loc2 in loc1) {
				loc3 = this.petIconFactory.create(loc2,40,5526612,1);
				loc3.addEventListener(MouseEvent.CLICK,this.onPetSelected);
				this.petsList.push(loc3);
				this.view.addPet(loc3);
			}
		}
		
		private function sortByPower(param1:PetVO, param2:PetVO) : int {
			if(param1.totalAbilitiesLevel() < param2.totalAbilitiesLevel()) {
				return 1;
			}
			return -1;
		}
		
		private function sortByFamily(param1:PetVO, param2:PetVO) : int {
			if(param1.family == param2.family) {
				return this.sortByPower(param1,param2);
			}
			if(param1.family > param2.family) {
				return 1;
			}
			return -1;
		}
		
		private function abilityUnlocked(param1:int) : void {
			this.refreshPetsList();
			this.selectPetVO(!!this.model.activeUIVO?this.model.activeUIVO:this.model.getActivePet());
		}
		
		private function evolvePetHandler(param1:EvolvePetInfo) : void {
			this.refreshPetsList();
			this.selectPetVO(!!this.model.activeUIVO?this.model.activeUIVO:this.model.getActivePet());
		}
		
		private function onRelease(param1:int) : void {
			this.model.deletePet(param1);
			this.refreshPetsList();
		}
	}
}
