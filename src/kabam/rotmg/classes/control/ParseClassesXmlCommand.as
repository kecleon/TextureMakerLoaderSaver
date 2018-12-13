 
package kabam.rotmg.classes.control {
	import kabam.rotmg.assets.model.CharacterTemplate;
	import kabam.rotmg.classes.model.CharacterClass;
	import kabam.rotmg.classes.model.CharacterClassStat;
	import kabam.rotmg.classes.model.CharacterClassUnlock;
	import kabam.rotmg.classes.model.CharacterSkin;
	import kabam.rotmg.classes.model.CharacterSkinState;
	import kabam.rotmg.classes.model.ClassesModel;
	import kabam.rotmg.text.model.TextKey;
	
	public class ParseClassesXmlCommand {
		 
		
		[Inject]
		public var data:XML;
		
		[Inject]
		public var classes:ClassesModel;
		
		public function ParseClassesXmlCommand() {
			super();
		}
		
		public function execute() : void {
			var loc2:XML = null;
			var loc1:XMLList = this.data.Object;
			for each(loc2 in loc1) {
				this.parseCharacterClass(loc2);
			}
		}
		
		private function parseCharacterClass(param1:XML) : void {
			var loc2:int = param1.@type;
			var loc3:CharacterClass = this.classes.getCharacterClass(loc2);
			this.populateCharacter(loc3,param1);
		}
		
		private function populateCharacter(param1:CharacterClass, param2:XML) : void {
			var loc3:XML = null;
			param1.id = param2.@type;
			param1.name = param2.DisplayId == undefined?param2.@id:param2.DisplayId;
			param1.description = param2.Description;
			param1.hitSound = param2.HitSound;
			param1.deathSound = param2.DeathSound;
			param1.bloodProb = param2.BloodProb;
			param1.slotTypes = this.parseIntList(param2.SlotTypes);
			param1.defaultEquipment = this.parseIntList(param2.Equipment);
			param1.hp = this.parseCharacterStat(param2,"MaxHitPoints");
			param1.mp = this.parseCharacterStat(param2,"MaxMagicPoints");
			param1.attack = this.parseCharacterStat(param2,"Attack");
			param1.defense = this.parseCharacterStat(param2,"Defense");
			param1.speed = this.parseCharacterStat(param2,"Speed");
			param1.dexterity = this.parseCharacterStat(param2,"Dexterity");
			param1.hpRegeneration = this.parseCharacterStat(param2,"HpRegen");
			param1.mpRegeneration = this.parseCharacterStat(param2,"MpRegen");
			param1.unlockCost = param2.UnlockCost;
			for each(loc3 in param2.UnlockLevel) {
				param1.unlocks.push(this.parseUnlock(loc3));
			}
			param1.skins.addSkin(this.makeDefaultSkin(param2),true);
		}
		
		private function makeDefaultSkin(param1:XML) : CharacterSkin {
			var loc2:String = param1.AnimatedTexture.File;
			var loc3:int = param1.AnimatedTexture.Index;
			var loc4:CharacterSkin = new CharacterSkin();
			loc4.id = 0;
			loc4.name = TextKey.CLASSIC_SKIN;
			loc4.template = new CharacterTemplate(loc2,loc3);
			loc4.setState(CharacterSkinState.OWNED);
			loc4.setIsSelected(true);
			return loc4;
		}
		
		private function parseUnlock(param1:XML) : CharacterClassUnlock {
			var loc2:CharacterClassUnlock = new CharacterClassUnlock();
			loc2.level = param1.@level;
			loc2.character = this.classes.getCharacterClass(param1.@type);
			return loc2;
		}
		
		private function parseCharacterStat(param1:XML, param2:String) : CharacterClassStat {
			var loc4:XML = null;
			var loc5:XML = null;
			var loc6:CharacterClassStat = null;
			var loc3:XML = param1[param2][0];
			for each(loc5 in param1.LevelIncrease) {
				if(loc5.text() == param2) {
					loc4 = loc5;
				}
			}
			loc6 = new CharacterClassStat();
			loc6.initial = int(loc3.toString());
			loc6.max = loc3.@max;
			loc6.rampMin = !!loc4?int(loc4.@min):0;
			loc6.rampMax = !!loc4?int(loc4.@max):0;
			return loc6;
		}
		
		private function parseIntList(param1:String) : Vector.<int> {
			var loc2:Array = param1.split(",");
			var loc3:int = loc2.length;
			var loc4:Vector.<int> = new Vector.<int>(loc3,true);
			var loc5:int = 0;
			while(loc5 < loc3) {
				loc4[loc5] = int(loc2[loc5]);
				loc5++;
			}
			return loc4;
		}
	}
}
