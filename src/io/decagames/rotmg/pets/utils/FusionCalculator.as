 
package io.decagames.rotmg.pets.utils {
	import io.decagames.rotmg.pets.data.rarity.PetRarityEnum;
	import io.decagames.rotmg.pets.data.vo.PetVO;
	
	public class FusionCalculator {
		
		private static var ranges:Object = makeRanges();
		 
		
		public function FusionCalculator() {
			super();
		}
		
		private static function makeRanges() : Object {
			ranges = {};
			ranges[PetRarityEnum.COMMON.rarityKey] = 30;
			ranges[PetRarityEnum.UNCOMMON.rarityKey] = 20;
			ranges[PetRarityEnum.RARE.rarityKey] = 20;
			ranges[PetRarityEnum.LEGENDARY.rarityKey] = 20;
			return ranges;
		}
		
		public static function getStrengthPercentage(param1:PetVO, param2:PetVO) : Number {
			var loc3:Number = getRarityPointsPercentage(param1);
			var loc4:Number = getRarityPointsPercentage(param2);
			return average(loc3,loc4);
		}
		
		private static function average(param1:Number, param2:Number) : Number {
			return (param1 + param2) / 2;
		}
		
		private static function getRarityPointsPercentage(param1:PetVO) : Number {
			var loc2:int = ranges[param1.rarity.rarityKey];
			var loc3:int = param1.maxAbilityPower - loc2;
			var loc4:int = param1.abilityList[0].level - loc3;
			return loc4 / loc2;
		}
	}
}
