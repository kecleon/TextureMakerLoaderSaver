package kabam.rotmg.ui.view.components {
	import com.company.assembleegameclient.map.Map;
	import com.company.assembleegameclient.objects.Player;
	import com.company.assembleegameclient.parameters.Parameters;
	import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.InteractiveItemTile;
	import com.company.assembleegameclient.util.DisplayHierarchy;

	import flash.display.DisplayObject;

	import kabam.rotmg.constants.ItemConstants;
	import kabam.rotmg.game.model.PotionInventoryModel;
	import kabam.rotmg.game.model.UseBuyPotionVO;
	import kabam.rotmg.game.signals.UseBuyPotionSignal;
	import kabam.rotmg.messaging.impl.GameServerConnection;
	import kabam.rotmg.ui.model.HUDModel;
	import kabam.rotmg.ui.model.PotionModel;
	import kabam.rotmg.ui.signals.UpdateHUDSignal;

	import robotlegs.bender.bundles.mvcs.Mediator;

	public class PotionSlotMediator extends Mediator {


		[Inject]
		public var view:PotionSlotView;

		[Inject]
		public var hudModel:HUDModel;

		[Inject]
		public var updateHUD:UpdateHUDSignal;

		[Inject]
		public var potionInventoryModel:PotionInventoryModel;

		[Inject]
		public var useBuyPotionSignal:UseBuyPotionSignal;

		private var blockingUpdate:Boolean = false;

		public function PotionSlotMediator() {
			super();
		}

		override public function initialize():void {
			this.updateHUD.addOnce(this.initializeData);
			this.view.drop.add(this.onDrop);
			this.view.buyUse.add(this.onBuyUse);
			this.updateHUD.add(this.update);
		}

		override public function destroy():void {
			this.view.drop.remove(this.onDrop);
			this.view.buyUse.remove(this.onBuyUse);
			this.updateHUD.remove(this.update);
		}

		private function initializeData(param1:Player):void {
			var loc2:PotionModel = this.potionInventoryModel.potionModels[this.view.position];
			var loc3:int = param1.getPotionCount(loc2.objectId);
			this.view.setData(loc3, loc2.currentCost(loc3), loc2.available, loc2.objectId);
		}

		private function update(param1:Player):void {
			var loc2:PotionModel = null;
			var loc3:int = 0;
			if ((this.view.objectType == PotionInventoryModel.HEALTH_POTION_ID || this.view.objectType == PotionInventoryModel.MAGIC_POTION_ID) && !this.blockingUpdate) {
				loc2 = this.potionInventoryModel.getPotionModel(this.view.objectType);
				loc3 = param1.getPotionCount(loc2.objectId);
				this.view.setData(loc3, loc2.currentCost(loc3), loc2.available);
			}
		}

		private function onDrop(param1:DisplayObject):void {
			var loc4:InteractiveItemTile = null;
			var loc2:Player = this.hudModel.gameSprite.map.player_;
			var loc3:* = DisplayHierarchy.getParentWithTypeArray(param1, InteractiveItemTile, Map);
			if (loc3 is Map || Parameters.isGpuRender() && loc3 == null) {
				GameServerConnection.instance.invDrop(loc2, PotionInventoryModel.getPotionSlot(this.view.objectType), this.view.objectType);
			} else if (loc3 is InteractiveItemTile) {
				loc4 = loc3 as InteractiveItemTile;
				if (loc4.getItemId() == ItemConstants.NO_ITEM && loc4.ownerGrid.owner != loc2) {
					GameServerConnection.instance.invSwapPotion(loc2, loc2, PotionInventoryModel.getPotionSlot(this.view.objectType), this.view.objectType, loc4.ownerGrid.owner, loc4.tileId, ItemConstants.NO_ITEM);
				}
			}
		}

		private function onBuyUse():void {
			var loc2:UseBuyPotionVO = null;
			var loc1:PotionModel = this.potionInventoryModel.potionModels[this.view.position];
			if (loc1.available) {
				loc2 = new UseBuyPotionVO(loc1.objectId, UseBuyPotionVO.SHIFTCLICK);
				this.useBuyPotionSignal.dispatch(loc2);
			}
		}
	}
}
