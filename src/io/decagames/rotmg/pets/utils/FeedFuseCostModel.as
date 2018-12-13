package io.decagames.rotmg.pets.utils {
	import flash.utils.Dictionary;

	import io.decagames.rotmg.pets.data.rarity.PetRarityEnum;

	public class FeedFuseCostModel {

		private static const feedCosts:Dictionary = makeFeedDictionary();

		private static const fuseCosts:Dictionary = makeFuseDictionary();


		public function FeedFuseCostModel() {
			super();
		}

		private static function makeFuseDictionary():Dictionary {
			var loc1:Dictionary = new Dictionary();
			loc1[PetRarityEnum.COMMON] = {
				"gold": 100,
				"fame": 300
			};
			loc1[PetRarityEnum.UNCOMMON] = {
				"gold": 240,
				"fame": 1000
			};
			loc1[PetRarityEnum.RARE] = {
				"gold": 600,
				"fame": 4000
			};
			loc1[PetRarityEnum.LEGENDARY] = {
				"gold": 1800,
				"fame": 15000
			};
			return loc1;
		}

		private static function makeFeedDictionary():Dictionary {
			var loc1:Dictionary = new Dictionary();
			loc1[PetRarityEnum.COMMON] = {
				"gold": 5,
				"fame": 10
			};
			loc1[PetRarityEnum.UNCOMMON] = {
				"gold": 12,
				"fame": 30
			};
			loc1[PetRarityEnum.RARE] = {
				"gold": 30,
				"fame": 100
			};
			loc1[PetRarityEnum.LEGENDARY] = {
				"gold": 60,
				"fame": 350
			};
			loc1[PetRarityEnum.DIVINE] = {
				"gold": 150,
				"fame": 1000
			};
			return loc1;
		}

		public static function getFuseGoldCost(param1:PetRarityEnum):int {
			return !!fuseCosts[param1] ? int(fuseCosts[param1].gold) : 0;
		}

		public static function getFuseFameCost(param1:PetRarityEnum):int {
			return !!fuseCosts[param1] ? int(fuseCosts[param1].fame) : 0;
		}

		public static function getFeedGoldCost(param1:PetRarityEnum):int {
			return feedCosts[param1].gold;
		}

		public static function getFeedFameCost(param1:PetRarityEnum):int {
			return feedCosts[param1].fame;
		}
	}
}
