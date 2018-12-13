 
package io.decagames.rotmg.pets.data.vo {
	import com.company.assembleegameclient.objects.ObjectLibrary;
	import io.decagames.rotmg.pets.data.PetsModel;
	import io.decagames.rotmg.pets.data.rarity.PetRarityEnum;
	import io.decagames.rotmg.pets.data.skin.PetSkinRenderer;
	import kabam.rotmg.core.StaticInjectorContext;
	import org.osflash.signals.Signal;
	
	public class PetVO extends PetSkinRenderer implements IPetVO {
		 
		
		private var staticData:XML;
		
		private var id:int;
		
		private var type:int;
		
		private var _rarity:PetRarityEnum;
		
		private var _name:String;
		
		private var _maxAbilityPower:int;
		
		private var _abilityList:Array;
		
		private var _updated:Signal;
		
		private var _abilityUpdated:Signal;
		
		private var _ownedSkin:Boolean;
		
		private var _family:String = "";
		
		public function PetVO(param1:int = undefined) {
			this._abilityList = [new AbilityVO(),new AbilityVO(),new AbilityVO()];
			this._updated = new Signal();
			this._abilityUpdated = new Signal();
			super();
			this.id = param1;
			this.staticData = <data/>;
			this.listenToAbilities();
		}
		
		private static function getPetDataDescription(param1:int) : String {
			return ObjectLibrary.getPetDataXMLByType(param1).Description;
		}
		
		private static function getPetDataDisplayId(param1:int) : String {
			return ObjectLibrary.getPetDataXMLByType(param1).@id;
		}
		
		public static function clone(param1:PetVO) : PetVO {
			var loc2:PetVO = new PetVO(param1.id);
			return loc2;
		}
		
		public function get updated() : Signal {
			return this._updated;
		}
		
		private function listenToAbilities() : void {
			var loc1:AbilityVO = null;
			for each(loc1 in this._abilityList) {
				loc1.updated.add(this.onAbilityUpdate);
			}
		}
		
		public function maxedAvailableAbilities() : Boolean {
			var loc1:AbilityVO = null;
			for each(loc1 in this._abilityList) {
				if(loc1.getUnlocked() && loc1.level < this.maxAbilityPower) {
					return false;
				}
			}
			return true;
		}
		
		public function totalAbilitiesLevel() : int {
			var loc2:AbilityVO = null;
			var loc1:int = 0;
			for each(loc2 in this._abilityList) {
				if(loc2.getUnlocked() && loc2.level) {
					loc1 = loc1 + loc2.level;
				}
			}
			return loc1;
		}
		
		public function get totalMaxAbilitiesLevel() : int {
			var loc2:AbilityVO = null;
			var loc1:int = 0;
			for each(loc2 in this._abilityList) {
				if(loc2.getUnlocked()) {
					loc1 = loc1 + this._maxAbilityPower;
				}
			}
			return loc1;
		}
		
		public function maxedAllAbilities() : Boolean {
			var loc2:AbilityVO = null;
			var loc1:int = 0;
			for each(loc2 in this._abilityList) {
				if(loc2.getUnlocked() && loc2.level == this.maxAbilityPower) {
					loc1++;
				}
			}
			return loc1 == this._abilityList.length;
		}
		
		private function onAbilityUpdate(param1:AbilityVO) : void {
			this._updated.dispatch();
			this._abilityUpdated.dispatch();
		}
		
		public function apply(param1:XML) : void {
			this.extractBasicData(param1);
			this.extractAbilityData(param1);
		}
		
		private function extractBasicData(param1:XML) : void {
			param1.@instanceId && this.setID(param1.@instanceId);
			param1.@type && this.setType(param1.@type);
			param1.@skin && this.setSkin(param1.@skin);
			param1.@name && this.setName(param1.@name);
			param1.@rarity && this.setRarity(param1.@rarity);
			param1.@maxAbilityPower && this.setMaxAbilityPower(param1.@maxAbilityPower);
		}
		
		public function extractAbilityData(param1:XML) : void {
			var loc2:uint = 0;
			var loc4:AbilityVO = null;
			var loc5:int = 0;
			var loc3:uint = this._abilityList.length;
			loc2 = 0;
			while(loc2 < loc3) {
				loc4 = this._abilityList[loc2];
				loc5 = param1.Abilities.Ability[loc2].@type;
				loc4.name = getPetDataDisplayId(loc5);
				loc4.description = getPetDataDescription(loc5);
				loc4.level = param1.Abilities.Ability[loc2].@power;
				loc4.points = param1.Abilities.Ability[loc2].@points;
				loc2++;
			}
		}
		
		public function get family() : String {
			var loc1:SkinVO = this.skinVO;
			if(loc1) {
				return loc1.family;
			}
			return this.staticData.Family;
		}
		
		public function setID(param1:int) : void {
			this.id = param1;
		}
		
		public function getID() : int {
			return this.id;
		}
		
		public function setType(param1:int) : void {
			this.type = param1;
			this.staticData = ObjectLibrary.xmlLibrary_[this.type];
		}
		
		public function getType() : int {
			return this.type;
		}
		
		public function setRarity(param1:uint) : void {
			this._rarity = PetRarityEnum.selectByOrdinal(param1);
			this.unlockAbilitiesBasedOnPetRarity(param1);
			this._updated.dispatch();
		}
		
		private function unlockAbilitiesBasedOnPetRarity(param1:uint) : void {
			this._abilityList[0].setUnlocked(true);
			this._abilityList[1].setUnlocked(param1 >= PetRarityEnum.UNCOMMON.ordinal);
			this._abilityList[2].setUnlocked(param1 >= PetRarityEnum.LEGENDARY.ordinal);
		}
		
		public function get rarity() : PetRarityEnum {
			return this._rarity;
		}
		
		public function get skinVO() : SkinVO {
			return StaticInjectorContext.getInjector().getInstance(PetsModel).getSkinVOById(_skinType);
		}
		
		public function setName(param1:String) : void {
			this._name = ObjectLibrary.typeToDisplayId_[_skinType];
			if(this._name == null || this._name == "") {
				this._name = ObjectLibrary.typeToDisplayId_[this.getType()];
			}
			this._updated.dispatch();
		}
		
		public function get name() : String {
			return this._name;
		}
		
		public function setMaxAbilityPower(param1:int) : void {
			this._maxAbilityPower = param1;
			this._updated.dispatch();
		}
		
		public function get maxAbilityPower() : int {
			return this._maxAbilityPower;
		}
		
		public function setSkin(param1:int) : void {
			_skinType = param1;
			this._updated.dispatch();
		}
		
		public function get skinType() : int {
			return _skinType;
		}
		
		public function get ownedSkin() : Boolean {
			return this._ownedSkin;
		}
		
		public function set ownedSkin(param1:Boolean) : void {
			this._ownedSkin = param1;
		}
		
		public function setFamily(param1:String) : void {
			this._family = param1;
		}
		
		public function get abilityList() : Array {
			return this._abilityList;
		}
		
		public function set abilityList(param1:Array) : void {
			this._abilityList = param1;
		}
		
		public function get isOwned() : Boolean {
			return false;
		}
		
		public function get abilityUpdated() : Signal {
			return this._abilityUpdated;
		}
		
		public function get isNew() : Boolean {
			return false;
		}
		
		public function set isNew(param1:Boolean) : void {
		}
	}
}
