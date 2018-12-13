package io.decagames.rotmg.shop.mysteryBox.contentPopup {
	import com.company.assembleegameclient.constants.InventoryOwnerTypes;
	import com.company.assembleegameclient.objects.ObjectLibrary;
	import com.company.assembleegameclient.objects.Player;
	import com.company.assembleegameclient.ui.tooltip.EquipmentToolTip;

	import flash.events.MouseEvent;

	import kabam.rotmg.core.signals.ShowTooltipSignal;
	import kabam.rotmg.ui.model.HUDModel;

	import robotlegs.bender.bundles.mvcs.Mediator;

	public class UIItemContainerMediator extends Mediator {


		[Inject]
		public var view:UIItemContainer;

		[Inject]
		public var hud:HUDModel;

		[Inject]
		public var showTooltipSignal:ShowTooltipSignal;

		private var tooltip:EquipmentToolTip;

		public function UIItemContainerMediator() {
			super();
		}

		override public function initialize():void {
			var loc1:Player = this.hud.gameSprite && this.hud.gameSprite.map ? this.hud.gameSprite.map.player_ : null;
			var loc2:int = ObjectLibrary.idToType_[int(this.view.itemId)];
			this.tooltip = new EquipmentToolTip(int(this.view.itemId), loc1, loc2, InventoryOwnerTypes.CURRENT_PLAYER);
			this.view.addEventListener(MouseEvent.ROLL_OVER, this.onRollOverHandler);
		}

		private function onRollOverHandler(param1:MouseEvent):void {
			if (this.view.showTooltip) {
				this.tooltip.attachToTarget(this.view);
				this.showTooltipSignal.dispatch(this.tooltip);
			}
		}

		override public function destroy():void {
			this.view.removeEventListener(MouseEvent.ROLL_OVER, this.onRollOverHandler);
			this.tooltip.detachFromTarget();
		}
	}
}
