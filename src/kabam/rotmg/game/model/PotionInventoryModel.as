 
package kabam.rotmg.game.model {
	import flash.utils.Dictionary;
	import kabam.rotmg.ui.model.PotionModel;
	import org.osflash.signals.Signal;
	
	public class PotionInventoryModel {
		
		public static const HEALTH_POTION_ID:int = 2594;
		
		public static const HEALTH_POTION_SLOT:int = 254;
		
		public static const MAGIC_POTION_ID:int = 2595;
		
		public static const MAGIC_POTION_SLOT:int = 255;
		 
		
		public var potionModels:Dictionary;
		
		public var updatePosition:Signal;
		
		public function PotionInventoryModel() {
			super();
			this.potionModels = new Dictionary();
			this.updatePosition = new Signal(int);
		}
		
		public static function getPotionSlot(param1:int) : int {
			switch(param1) {
				case HEALTH_POTION_ID:
					return HEALTH_POTION_SLOT;
				case MAGIC_POTION_ID:
					return MAGIC_POTION_SLOT;
				default:
					return -1;
			}
		}
		
		public function initializePotionModels(param1:XML) : void {
			var loc6:int = 0;
			var loc7:PotionModel = null;
			var loc2:int = param1.PotionPurchaseCooldown;
			var loc3:int = param1.PotionPurchaseCostCooldown;
			var loc4:int = param1.MaxStackablePotions;
			var loc5:Array = new Array();
			for each(loc6 in param1.PotionPurchaseCosts.cost) {
				loc5.push(loc6);
			}
			loc7 = new PotionModel();
			loc7.purchaseCooldownMillis = loc2;
			loc7.priceCooldownMillis = loc3;
			loc7.maxPotionCount = loc4;
			loc7.objectId = HEALTH_POTION_ID;
			loc7.position = 0;
			loc7.costs = loc5;
			this.potionModels[loc7.position] = loc7;
			loc7.update.add(this.update);
			loc7 = new PotionModel();
			loc7.purchaseCooldownMillis = loc2;
			loc7.priceCooldownMillis = loc3;
			loc7.maxPotionCount = loc4;
			loc7.objectId = MAGIC_POTION_ID;
			loc7.position = 1;
			loc7.costs = loc5;
			this.potionModels[loc7.position] = loc7;
			loc7.update.add(this.update);
		}
		
		public function getPotionModel(param1:uint) : PotionModel {
			var loc2:* = null;
			for(loc2 in this.potionModels) {
				if(this.potionModels[loc2].objectId == param1) {
					return this.potionModels[loc2];
				}
			}
			return null;
		}
		
		private function update(param1:int) : void {
			this.updatePosition.dispatch(param1);
		}
	}
}
