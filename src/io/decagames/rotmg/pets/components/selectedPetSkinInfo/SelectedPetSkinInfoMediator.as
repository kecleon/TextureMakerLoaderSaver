 
package io.decagames.rotmg.pets.components.selectedPetSkinInfo {
	import com.company.assembleegameclient.objects.Player;
	import com.company.assembleegameclient.util.Currency;
	import io.decagames.rotmg.pets.data.PetsModel;
	import io.decagames.rotmg.pets.data.skin.SelectedPetButtonType;
	import io.decagames.rotmg.pets.data.vo.IPetVO;
	import io.decagames.rotmg.pets.data.vo.PetVO;
	import io.decagames.rotmg.pets.signals.ChangePetSkinSignal;
	import io.decagames.rotmg.pets.signals.SelectPetSignal;
	import io.decagames.rotmg.pets.signals.SelectPetSkinSignal;
	import io.decagames.rotmg.shop.NotEnoughResources;
	import io.decagames.rotmg.shop.ShopBuyButton;
	import io.decagames.rotmg.ui.buttons.BaseButton;
	import io.decagames.rotmg.ui.popups.signals.ShowPopupSignal;
	import kabam.rotmg.core.model.PlayerModel;
	import kabam.rotmg.game.model.GameModel;
	import kabam.rotmg.ui.model.HUDModel;
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	public class SelectedPetSkinInfoMediator extends Mediator {
		 
		
		[Inject]
		public var view:SelectedPetSkinInfo;
		
		[Inject]
		public var selectPetSkinSignal:SelectPetSkinSignal;
		
		[Inject]
		public var model:PetsModel;
		
		[Inject]
		public var hudModel:HUDModel;
		
		[Inject]
		public var selectPetSignal:SelectPetSignal;
		
		[Inject]
		public var showPopupSignal:ShowPopupSignal;
		
		[Inject]
		public var gameModel:GameModel;
		
		[Inject]
		public var playerModel:PlayerModel;
		
		[Inject]
		public var changePetSkinSignal:ChangePetSkinSignal;
		
		private var selectedSkin:IPetVO;
		
		private var selectedPet:PetVO;
		
		public function SelectedPetSkinInfoMediator() {
			super();
		}
		
		override public function initialize() : void {
			this.selectPetSkinSignal.add(this.onSkinSelected);
			this.selectPetSignal.add(this.onPetSelected);
			if(this.currentPet) {
				this.currentPet.updated.add(this.currentPetUpdate);
			}
		}
		
		private function currentPetUpdate() : void {
			this.onSkinSelected(this.selectedSkin);
		}
		
		private function onSkinSelected(param1:IPetVO) : void {
			this.selectedSkin = param1;
			this.view.showPetInfo(param1);
			if(this.currentPet == null || param1 == null) {
				this.setAction(SelectedPetButtonType.NONE,param1);
			} else if(param1.family != this.currentPet.skinVO.family) {
				this.setAction(SelectedPetButtonType.FAMILY,param1);
			} else if(param1.skinType != this.currentPet.skinVO.skinType) {
				this.setAction(SelectedPetButtonType.SKIN,param1);
			} else {
				this.setAction(SelectedPetButtonType.NONE,param1);
			}
		}
		
		private function onPetSelected(param1:PetVO) : void {
			this.selectedPet = param1;
			this.onSkinSelected(this.selectedSkin);
		}
		
		private function setAction(param1:int, param2:IPetVO) : void {
			if(this.view.goldActionButton) {
				this.view.goldActionButton.clickSignal.remove(this.onActionButtonClickHandler);
			}
			if(this.view.fameActionButton) {
				this.view.fameActionButton.clickSignal.remove(this.onActionButtonClickHandler);
			}
			this.view.actionButtonType = param1;
			if(this.view.goldActionButton) {
				this.view.goldActionButton.clickSignal.add(this.onActionButtonClickHandler);
			}
			if(this.view.fameActionButton) {
				this.view.fameActionButton.clickSignal.add(this.onActionButtonClickHandler);
			}
		}
		
		private function get currentPet() : PetVO {
			return !this.selectedPet?this.model.getActivePet():this.selectedPet;
		}
		
		private function get currentGold() : int {
			var loc1:Player = this.gameModel.player;
			if(loc1 != null) {
				return loc1.credits_;
			}
			if(this.playerModel != null) {
				return this.playerModel.getCredits();
			}
			return 0;
		}
		
		private function get currentFame() : int {
			var loc1:Player = this.gameModel.player;
			if(loc1 != null) {
				return loc1.fame_;
			}
			if(this.playerModel != null) {
				return this.playerModel.getFame();
			}
			return 0;
		}
		
		private function onActionButtonClickHandler(param1:BaseButton) : void {
			var loc2:ShopBuyButton = ShopBuyButton(param1);
			switch(this.view.actionButtonType) {
				case SelectedPetButtonType.SKIN:
				case SelectedPetButtonType.FAMILY:
					if(loc2.currency == Currency.GOLD && this.currentGold < loc2.price || loc2.currency == Currency.FAME && this.currentFame < loc2.price) {
						this.showPopupSignal.dispatch(new NotEnoughResources(300,loc2.currency));
						return;
					}
					break;
			}
			this.hudModel.gameSprite.gsc_.changePetSkin(this.currentPet.getID(),this.selectedSkin.skinType,loc2.currency);
			this.onSkinSelected(null);
		}
		
		override public function destroy() : void {
			this.selectPetSkinSignal.remove(this.onSkinSelected);
			if(this.currentPet) {
				this.currentPet.updated.remove(this.currentPetUpdate);
			}
			this.selectPetSignal.remove(this.onPetSelected);
		}
	}
}
