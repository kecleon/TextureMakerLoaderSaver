 
package io.decagames.rotmg.pets.data.rarity {
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;
	
	public class PetRarityEnum {
		
		public static const COMMON:PetRarityEnum = new PetRarityEnum("Pets.common",0,12960964,4539717);
		
		public static const UNCOMMON:PetRarityEnum = new PetRarityEnum("Pets.uncommon",1,12960964,4539717);
		
		public static const RARE:PetRarityEnum = new PetRarityEnum("Pets.rare",2,222407,672896);
		
		public static const LEGENDARY:PetRarityEnum = new PetRarityEnum("Pets.legendary",3,222407,672896);
		
		public static const DIVINE:PetRarityEnum = new PetRarityEnum("Pets.divine",4,12951808,8349960);
		 
		
		public var rarityKey:String;
		
		public var ordinal:int;
		
		public var rarityName:String;
		
		public var color:uint;
		
		public var backgroundColor:uint;
		
		public function PetRarityEnum(param1:String, param2:int, param3:uint, param4:uint) {
			super();
			this.rarityKey = param1;
			this.ordinal = param2;
			this.color = param3;
			this.backgroundColor = param4;
		}
		
		public static function parseNames() : void {
			var loc1:PetRarityEnum = null;
			for each(loc1 in PetRarityEnum.list) {
				loc1.rarityName = LineBuilder.getLocalizedStringFromKey(loc1.rarityKey);
			}
		}
		
		public static function get list() : Array {
			return [COMMON,UNCOMMON,RARE,LEGENDARY,DIVINE];
		}
		
		public static function selectByRarityKey(param1:String) : PetRarityEnum {
			var loc2:PetRarityEnum = null;
			var loc3:PetRarityEnum = null;
			for each(loc3 in PetRarityEnum.list) {
				if(param1 == loc3.rarityKey) {
					loc2 = loc3;
				}
			}
			return loc2;
		}
		
		public static function selectByRarityName(param1:String) : PetRarityEnum {
			var loc2:PetRarityEnum = null;
			var loc3:PetRarityEnum = null;
			for each(loc3 in PetRarityEnum.list) {
				if(param1 == loc3.rarityName) {
					loc2 = loc3;
				}
			}
			return loc2;
		}
		
		public static function selectByOrdinal(param1:int) : PetRarityEnum {
			var loc2:PetRarityEnum = null;
			var loc3:PetRarityEnum = null;
			for each(loc3 in PetRarityEnum.list) {
				if(param1 == loc3.ordinal) {
					loc2 = loc3;
				}
			}
			return loc2;
		}
	}
}
