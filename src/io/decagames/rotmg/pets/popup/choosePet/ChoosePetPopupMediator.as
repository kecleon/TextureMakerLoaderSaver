package io.decagames.rotmg.pets.popup.choosePet {
	import flash.events.MouseEvent;

	import io.decagames.rotmg.pets.components.petItem.PetItem;
	import io.decagames.rotmg.pets.data.PetsModel;
	import io.decagames.rotmg.pets.data.vo.PetVO;
	import io.decagames.rotmg.pets.signals.ActivatePet;
	import io.decagames.rotmg.pets.signals.SelectPetSignal;
	import io.decagames.rotmg.pets.utils.PetItemFactory;
	import io.decagames.rotmg.ui.buttons.BaseButton;
	import io.decagames.rotmg.ui.buttons.SliceScalingButton;
	import io.decagames.rotmg.ui.popups.header.PopupHeader;
	import io.decagames.rotmg.ui.popups.signals.ClosePopupSignal;
	import io.decagames.rotmg.ui.texture.TextureParser;

	import robotlegs.bender.bundles.mvcs.Mediator;

	public class ChoosePetPopupMediator extends Mediator {


		[Inject]
		public var view:ChoosePetPopup;

		[Inject]
		public var closePopupSignal:ClosePopupSignal;

		[Inject]
		public var petIconFactory:PetItemFactory;

		[Inject]
		public var model:PetsModel;

		[Inject]
		public var selectPetSignal:SelectPetSignal;

		[Inject]
		public var activatePet:ActivatePet;

		private var petsList:Vector.<PetItem>;

		private var closeButton:SliceScalingButton;

		public function ChoosePetPopupMediator() {
			super();
		}

		override public function initialize():void {
			var loc1:PetVO = null;
			var loc2:PetItem = null;
			this.closeButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI", "close_button"));
			this.closeButton.clickSignal.addOnce(this.onClose);
			this.view.header.addButton(this.closeButton, PopupHeader.RIGHT_BUTTON);
			this.petsList = new Vector.<PetItem>();
			for each(loc1 in this.model.getAllPets()) {
				loc2 = this.petIconFactory.create(loc1, 40, 5526612, 1);
				loc2.addEventListener(MouseEvent.CLICK, this.onPetSelected);
				this.petsList.push(loc2);
				this.view.addPet(loc2);
			}
		}

		private function onPetSelected(param1:MouseEvent):void {
			var loc2:PetItem = PetItem(param1.currentTarget);
			this.activatePet.dispatch(loc2.getPetVO().getID());
			this.selectPetSignal.dispatch(loc2.getPetVO());
			this.closePopupSignal.dispatch(this.view);
		}

		override public function destroy():void {
			var loc1:PetItem = null;
			this.closeButton.dispose();
			for each(loc1 in this.petsList) {
				loc1.removeEventListener(MouseEvent.CLICK, this.onPetSelected);
			}
			this.petsList = new Vector.<PetItem>();
		}

		private function onClose(param1:BaseButton):void {
			this.closePopupSignal.dispatch(this.view);
		}
	}
}
