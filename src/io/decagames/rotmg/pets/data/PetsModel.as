 
package io.decagames.rotmg.pets.data {
	import com.company.assembleegameclient.appengine.SavedCharacter;
	import com.company.assembleegameclient.map.AbstractMap;
	import com.company.assembleegameclient.objects.ObjectLibrary;
	import flash.utils.Dictionary;
	import io.decagames.rotmg.pets.data.rarity.PetRarityEnum;
	import io.decagames.rotmg.pets.data.vo.PetVO;
	import io.decagames.rotmg.pets.data.vo.SkinVO;
	import io.decagames.rotmg.pets.data.yard.PetYardEnum;
	import io.decagames.rotmg.pets.signals.NotifyActivePetUpdated;
	import kabam.rotmg.core.model.PlayerModel;
	
	public class PetsModel {
		
		private static var petsDataXML:Class = PetsModel_petsDataXML;
		 
		
		private var petsData:XMLList;
		
		[Inject]
		public var notifyActivePetUpdated:NotifyActivePetUpdated;
		
		[Inject]
		public var playerModel:PlayerModel;
		
		private var hash:Object;
		
		private var pets:Vector.<PetVO>;
		
		private var skins:Dictionary;
		
		private var familySkins:Dictionary;
		
		private var yardXmlData:XML;
		
		private var type:int;
		
		private var activePet:PetVO;
		
		private var _wardrobePet:PetVO;
		
		private var _totalPetsSkins:int = 0;
		
		private var ownedSkinsIDs:Vector.<int>;
		
		private var _activeUIVO:PetVO;
		
		public function PetsModel() {
			this.hash = {};
			this.pets = new Vector.<PetVO>();
			this.skins = new Dictionary();
			this.familySkins = new Dictionary();
			this.ownedSkinsIDs = new Vector.<int>();
			super();
		}
		
		public function destroy() : void {
		}
		
		public function setPetYardType(param1:int) : void {
			this.type = param1;
			this.yardXmlData = ObjectLibrary.getXMLfromId(ObjectLibrary.getIdFromType(param1));
		}
		
		public function getPetYardRarity() : uint {
			return PetYardEnum.selectByValue(this.yardXmlData.@id).rarity.ordinal;
		}
		
		public function getPetYardType() : int {
			return !!this.yardXmlData?int(PetYardEnum.selectByValue(this.yardXmlData.@id).ordinal):1;
		}
		
		public function isMapNameYardName(param1:AbstractMap) : Boolean {
			return param1.name_ && param1.name_.substr(0,8) == "Pet Yard";
		}
		
		public function getPetYardUpgradeFamePrice() : int {
			return int(this.yardXmlData.Fame);
		}
		
		public function getPetYardUpgradeGoldPrice() : int {
			return int(this.yardXmlData.Price);
		}
		
		public function getPetYardObjectID() : int {
			return this.type;
		}
		
		public function deletePet(param1:int) : void {
			var loc2:int = this.getPetIndex(param1);
			if(loc2 >= 0) {
				this.pets.splice(this.getPetIndex(param1),1);
				if(this._activeUIVO && this._activeUIVO.getID() == param1) {
					this._activeUIVO = null;
				}
				if(this.activePet && this.activePet.getID() == param1) {
					this.removeActivePet();
				}
			}
		}
		
		public function clearPets() : void {
			this.hash = {};
			this.pets = new Vector.<PetVO>();
			this.petsData = null;
			this.skins = new Dictionary();
			this.familySkins = new Dictionary();
			this._totalPetsSkins = 0;
			this.ownedSkinsIDs = new Vector.<int>();
			this.removeActivePet();
		}
		
		public function parsePetsData() : void {
			var loc1:uint = 0;
			var loc2:int = 0;
			var loc3:XML = null;
			var loc4:SkinVO = null;
			if(this.petsData == null) {
				this.petsData = XML(new petsDataXML()).Object;
				loc1 = this.petsData.length();
				loc2 = 0;
				while(loc2 < loc1) {
					loc3 = this.petsData[loc2];
					if(loc3.hasOwnProperty("PetSkin")) {
						if(loc3.@type != "0x8090") {
							loc4 = SkinVO.parseFromXML(loc3);
							loc4.isOwned = this.ownedSkinsIDs.indexOf(loc4.skinType) >= 0;
							this.skins[loc4.skinType] = loc4;
							this._totalPetsSkins++;
							if(!this.familySkins[loc4.family]) {
								this.familySkins[loc4.family] = new Vector.<SkinVO>();
							}
							this.familySkins[loc4.family].push(loc4);
						}
					}
					loc2++;
				}
			}
		}
		
		public function unlockSkin(param1:int) : void {
			this.skins[param1].isNew = true;
			this.skins[param1].isOwned = true;
			if(this.ownedSkinsIDs.indexOf(param1) == -1) {
				this.ownedSkinsIDs.push(param1);
			}
		}
		
		public function getSkinVOById(param1:int) : SkinVO {
			return this.skins[param1];
		}
		
		public function hasSkin(param1:int) : Boolean {
			return this.ownedSkinsIDs.indexOf(param1) != -1;
		}
		
		public function parseOwnedSkins(param1:XML) : void {
			if(param1.toString() != "") {
				this.ownedSkinsIDs = Vector.<int>(param1.toString().split(","));
			}
		}
		
		public function getPetVO(param1:int) : PetVO {
			var loc2:PetVO = null;
			if(this.hash[param1] != null) {
				return this.hash[param1];
			}
			loc2 = new PetVO(param1);
			this.pets.push(loc2);
			this.hash[param1] = loc2;
			return loc2;
		}
		
		public function get totalPetsSkins() : int {
			return this._totalPetsSkins;
		}
		
		public function get totalOwnedPetsSkins() : int {
			return this.ownedSkinsIDs.length;
		}
		
		public function getPetsSkinsFromFamily(param1:String) : Vector.<SkinVO> {
			return this.familySkins[param1];
		}
		
		private function petNodeIsSkin(param1:XML) : Boolean {
			return param1.hasOwnProperty("PetSkin");
		}
		
		public function getCachedVOOnly(param1:int) : PetVO {
			return this.hash[param1];
		}
		
		public function getAllPets(param1:String = "", param2:PetRarityEnum = null) : Vector.<PetVO> {
			var family:String = param1;
			var rarity:PetRarityEnum = param2;
			var petsList:Vector.<PetVO> = this.pets;
			if(family != "") {
				petsList = petsList.filter(function(param1:PetVO, param2:int, param3:Vector.<PetVO>):Boolean {
					return param1.family == family;
				});
			}
			if(rarity != null) {
				petsList = petsList.filter(function(param1:PetVO, param2:int, param3:Vector.<PetVO>):Boolean {
					return param1.rarity == rarity;
				});
			}
			return petsList;
		}
		
		public function addPet(param1:PetVO) : void {
			this.pets.push(param1);
		}
		
		public function setActivePet(param1:PetVO) : void {
			this.activePet = param1;
			var loc2:SavedCharacter = this.playerModel.getCharacterById(this.playerModel.currentCharId);
			if(loc2) {
				loc2.setPetVO(this.activePet);
			}
			this.notifyActivePetUpdated.dispatch();
		}
		
		public function getActivePet() : PetVO {
			return this.activePet;
		}
		
		public function removeActivePet() : void {
			if(this.activePet == null) {
				return;
			}
			var loc1:SavedCharacter = this.playerModel.getCharacterById(this.playerModel.currentCharId);
			if(loc1) {
				loc1.setPetVO(null);
			}
			this.activePet = null;
			this.notifyActivePetUpdated.dispatch();
		}
		
		public function getPet(param1:int) : PetVO {
			var loc2:int = this.getPetIndex(param1);
			if(loc2 == -1) {
				return null;
			}
			return this.pets[loc2];
		}
		
		private function getPetIndex(param1:int) : int {
			var loc2:PetVO = null;
			var loc3:uint = 0;
			while(loc3 < this.pets.length) {
				loc2 = this.pets[loc3];
				if(loc2.getID() == param1) {
					return loc3;
				}
				loc3++;
			}
			return -1;
		}
		
		private function selectPetInWardrobe(param1:PetVO) : void {
			this._wardrobePet = param1;
		}
		
		public function get activeUIVO() : PetVO {
			return this._activeUIVO;
		}
		
		public function set activeUIVO(param1:PetVO) : void {
			this._activeUIVO = param1;
		}
	}
}
