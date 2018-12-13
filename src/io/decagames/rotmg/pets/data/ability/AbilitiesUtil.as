package io.decagames.rotmg.pets.data.ability {
	import io.decagames.rotmg.pets.data.rarity.PetRarityEnum;
	import io.decagames.rotmg.pets.data.vo.AbilityVO;
	import io.decagames.rotmg.pets.data.vo.IPetVO;

	public class AbilitiesUtil {


		public function AbilitiesUtil() {
			super();
		}

		public static function isActiveAbility(param1:PetRarityEnum, param2:int):Boolean {
			if (param1.ordinal >= PetRarityEnum.LEGENDARY.ordinal) {
				return true;
			}
			if (param1.ordinal >= PetRarityEnum.UNCOMMON.ordinal) {
				return param2 <= 1;
			}
			return param2 == 0;
		}

		public static function abilityPowerToMinPoints(param1:int):int {
			return Math.ceil(AbilityConfig.ABILITY_LEVEL1_POINTS * (1 - Math.pow(AbilityConfig.ABILITY_GEOMETRIC_RATIO, param1 - 1)) / (1 - AbilityConfig.ABILITY_GEOMETRIC_RATIO));
		}

		public static function abilityPointsToLevel(param1:int):int {
			var loc2:Number = param1 * (AbilityConfig.ABILITY_GEOMETRIC_RATIO - 1) / AbilityConfig.ABILITY_LEVEL1_POINTS + 1;
			return int(Math.log(loc2) / Math.log(AbilityConfig.ABILITY_GEOMETRIC_RATIO)) + 1;
		}

		public static function simulateAbilityUpgrade(param1:IPetVO, param2:int):Array {
			var loc5:AbilityVO = null;
			var loc6:int = 0;
			var loc3:Array = [];
			var loc4:int = 0;
			while (loc4 < 3) {
				loc5 = param1.abilityList[loc4].clone();
				if (AbilitiesUtil.isActiveAbility(param1.rarity, loc4) && loc5.level < param1.maxAbilityPower) {
					loc5.points = loc5.points + param2 * AbilityConfig.ABILITY_INDEX_TO_POINT_MODIFIER[loc4];
					loc6 = abilityPointsToLevel(loc5.points);
					if (loc6 > param1.maxAbilityPower) {
						loc6 = param1.maxAbilityPower;
						loc5.points = abilityPowerToMinPoints(loc6);
					}
					loc5.level = loc6;
				}
				loc3.push(loc5);
				loc4++;
			}
			return loc3;
		}
	}
}
