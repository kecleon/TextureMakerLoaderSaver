 
package io.decagames.rotmg.pets.data.yard {
	import io.decagames.rotmg.pets.data.rarity.PetRarityEnum;
	
	public class PetYardEnum {
		
		public static const PET_YARD_ONE:PetYardEnum = new PetYardEnum("Yard Upgrader 1",1,PetRarityEnum.COMMON);
		
		public static const PET_YARD_TWO:PetYardEnum = new PetYardEnum("Yard Upgrader 2",2,PetRarityEnum.UNCOMMON);
		
		public static const PET_YARD_THREE:PetYardEnum = new PetYardEnum("Yard Upgrader 3",3,PetRarityEnum.RARE);
		
		public static const PET_YARD_FOUR:PetYardEnum = new PetYardEnum("Yard Upgrader 4",4,PetRarityEnum.LEGENDARY);
		
		public static const PET_YARD_FIVE:PetYardEnum = new PetYardEnum("Yard Upgrader 5",5,PetRarityEnum.DIVINE);
		
		public static const MAX_ORDINAL:int = 5;
		 
		
		public var value:String;
		
		public var ordinal:int;
		
		public var rarity:PetRarityEnum;
		
		public function PetYardEnum(param1:*, param2:int, param3:PetRarityEnum) {
			super();
			this.value = param1;
			this.ordinal = param2;
			this.rarity = param3;
		}
		
		public static function get list() : Array {
			return [PET_YARD_ONE,PET_YARD_TWO,PET_YARD_THREE,PET_YARD_FOUR,PET_YARD_FIVE];
		}
		
		public static function selectByValue(param1:String) : PetYardEnum {
			var loc2:PetYardEnum = null;
			var loc3:PetYardEnum = null;
			for each(loc3 in PetYardEnum.list) {
				if(param1 == loc3.value) {
					loc2 = loc3;
				}
			}
			return loc2;
		}
		
		public static function selectByOrdinal(param1:int) : PetYardEnum {
			var loc2:PetYardEnum = null;
			var loc3:PetYardEnum = null;
			for each(loc3 in PetYardEnum.list) {
				if(param1 == loc3.ordinal) {
					loc2 = loc3;
				}
			}
			return loc2;
		}
	}
}
