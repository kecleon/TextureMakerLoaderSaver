 
package kabam.rotmg.messaging.impl {
	import com.company.assembleegameclient.game.AGameSprite;
	import com.company.assembleegameclient.objects.Pet;
	import com.company.assembleegameclient.util.ConditionEffect;
	import io.decagames.rotmg.pets.data.PetsModel;
	import io.decagames.rotmg.pets.data.vo.AbilityVO;
	import io.decagames.rotmg.pets.data.vo.PetVO;
	import kabam.rotmg.messaging.impl.data.StatData;
	
	public class PetUpdater {
		 
		
		[Inject]
		public var petsModel:PetsModel;
		
		[Inject]
		public var gameSprite:AGameSprite;
		
		public function PetUpdater() {
			super();
		}
		
		public function updatePetVOs(param1:Pet, param2:Vector.<StatData>) : void {
			var loc4:StatData = null;
			var loc5:AbilityVO = null;
			var loc6:* = undefined;
			var loc3:PetVO = param1.vo || this.createPetVO(param1,param2);
			if(loc3 == null) {
				return;
			}
			for each(loc4 in param2) {
				loc6 = loc4.statValue_;
				if(loc4.statType_ == StatData.TEXTURE_STAT) {
					loc3.setSkin(loc6);
				}
				switch(loc4.statType_) {
					case StatData.PET_INSTANCEID_STAT:
						loc3.setID(loc6);
						break;
					case StatData.PET_NAME_STAT:
						loc3.setName(loc4.strStatValue_);
						break;
					case StatData.PET_TYPE_STAT:
						loc3.setType(loc6);
						break;
					case StatData.PET_RARITY_STAT:
						loc3.setRarity(loc6);
						break;
					case StatData.PET_MAXABILITYPOWER_STAT:
						loc3.setMaxAbilityPower(loc6);
						break;
					case StatData.PET_FAMILY_STAT:
						break;
					case StatData.PET_FIRSTABILITY_POINT_STAT:
						loc5 = loc3.abilityList[0];
						loc5.points = loc6;
						break;
					case StatData.PET_SECONDABILITY_POINT_STAT:
						loc5 = loc3.abilityList[1];
						loc5.points = loc6;
						break;
					case StatData.PET_THIRDABILITY_POINT_STAT:
						loc5 = loc3.abilityList[2];
						loc5.points = loc6;
						break;
					case StatData.PET_FIRSTABILITY_POWER_STAT:
						loc5 = loc3.abilityList[0];
						loc5.level = loc6;
						break;
					case StatData.PET_SECONDABILITY_POWER_STAT:
						loc5 = loc3.abilityList[1];
						loc5.level = loc6;
						break;
					case StatData.PET_THIRDABILITY_POWER_STAT:
						loc5 = loc3.abilityList[2];
						loc5.level = loc6;
						break;
					case StatData.PET_FIRSTABILITY_TYPE_STAT:
						loc5 = loc3.abilityList[0];
						loc5.type = loc6;
						break;
					case StatData.PET_SECONDABILITY_TYPE_STAT:
						loc5 = loc3.abilityList[1];
						loc5.type = loc6;
						break;
					case StatData.PET_THIRDABILITY_TYPE_STAT:
						loc5 = loc3.abilityList[2];
						loc5.type = loc6;
				}
				if(loc5) {
					loc5.updated.dispatch(loc5);
				}
			}
		}
		
		private function createPetVO(param1:Pet, param2:Vector.<StatData>) : PetVO {
			var loc3:StatData = null;
			var loc4:PetVO = null;
			for each(loc3 in param2) {
				if(loc3.statType_ == StatData.PET_INSTANCEID_STAT) {
					loc4 = this.petsModel.getCachedVOOnly(loc3.statValue_);
					param1.vo = !!loc4?loc4:!!this.gameSprite.map.isPetYard?this.petsModel.getPetVO(loc3.statValue_):new PetVO(loc3.statValue_);
					return param1.vo;
				}
			}
			return null;
		}
		
		public function updatePet(param1:Pet, param2:Vector.<StatData>) : void {
			var loc3:StatData = null;
			var loc4:* = undefined;
			for each(loc3 in param2) {
				loc4 = loc3.statValue_;
				if(loc3.statType_ == StatData.TEXTURE_STAT) {
					param1.setSkin(loc4);
				}
				if(loc3.statType_ == StatData.SIZE_STAT) {
					param1.size_ = loc4;
				}
				if(loc3.statType_ == StatData.CONDITION_STAT) {
					param1.condition_[ConditionEffect.CE_FIRST_BATCH] = loc4;
				}
			}
		}
	}
}
