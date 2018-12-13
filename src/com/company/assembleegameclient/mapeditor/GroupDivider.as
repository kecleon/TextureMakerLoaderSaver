package com.company.assembleegameclient.mapeditor {
	import com.company.assembleegameclient.map.GroundLibrary;
	import com.company.assembleegameclient.map.RegionLibrary;
	import com.company.assembleegameclient.objects.ObjectLibrary;
	import com.company.util.MoreStringUtil;

	import flash.utils.Dictionary;

	import kabam.rotmg.core.StaticInjectorContext;
	import kabam.rotmg.core.model.PlayerModel;

	public class GroupDivider {

		public static const GROUP_LABELS:Vector.<String> = new <String>["Ground", "Basic Objects", "Enemies", "Walls", "3D Objects", "All Map Objects", "Regions", "Dungeons", "All Game Objects"];

		public static var GROUPS:Dictionary = new Dictionary(true);

		public static var DEFAULT_DUNGEON:String = "AbyssOfDemons";

		public static var HIDE_OBJECTS_IDS:Vector.<String> = new <String>["Gothic Wiondow Light", "Statue of Oryx Base", "AbyssExitGuarder", "AbyssIdolDead", "AbyssTreasureLavaBomb", "Area 1 Controller", "Area 2 Controller", "Area 3 Controller", "Area 4 Controller", "Area 5 Controller", "Arena Horseman Anchor", "FireMakerUp", "FireMakerLf", "FireMakerRt", "FireMakerDn", "Group Wall Observer", "LavaTrigger", "Mad Gas Controller", "Mad Lab Open Wall", "Maggot Sack", "NM Black Open Wall", "NM Blue Open Wall", "NM Green Open Wall", "NM Red Open Wall", "NM Green Dragon Shield Counter", "NM Green Dragon Shield Counter Deux", "NM Red Dragon Lava Bomb", "NM Red Dragon Lava Trigger", "Pirate King Healer", "Puppet Theatre Boss Spawn", "Puppet Treasure Chest", "Skuld Apparition", "Sorc Bomb Thrower", "Tempest Cloud", "Treasure Dropper", "Treasure Flame Trap 1.7 Sec", "Treasure Flame Trap 1.2 Sec", "Zombie Rise", "destnex Observer 1", "destnex Observer 2", "destnex Observer 3", "destnex Observer 4", "drac floor black", "drac floor blue", "drac floor green", "drac floor red", "drac wall black", "drac wall blue", "drac wall red", "drac wall green", "ic boss manager", "ic boss purifier generator", "ic boss spawner live", "md1 Governor", "md1 Lava Makers", "md1 Left Burst", "md1 Right Burst", "md1 Mid Burst", "md1 Left Hand spawner", "md1 Right Hand spawner", "md1 RightHandSmash", "md1 LeftHandSmash", "shtrs Add Lava", "shtrs Bird Check", "shtrs BirdSpawn 1", "shtrs BirdSpawn 2", "shtrs Bridge Closer", "shtrs Mage Closer 1", "shtrs Monster Cluster", "shtrs Mage Bridge Check", "shtrs Bridge Review Board", "shtrs Crystal Check", "shtrs Final Fight Check", "shtrs Final Mediator Lava", "shtrs KillWall 1", "shtrs KillWall 2", "shtrs KillWall 3", "shtrs KillWall 4", "shtrs KillWall 5", "shtrs KillWall 6", "shtrs KillWall 7", "shtrs Laser1", "shtrs Laser2", "shtrs Laser3", "shtrs Laser4", "shtrs Laser5", "shtrs Laser6", "shtrs Pause Watcher", "shtrs Player Check", "shtrs Player Check Archmage", "shtrs Spawn Bridge", "shtrs The Cursed Crown", "shtrs blobomb maker", "shtrs portal maker", "vlntns Governor", "vlntns Planter"];


		public function GroupDivider() {
			super();
		}

		public static function divideObjects():void {
			var loc10:int = 0;
			var loc11:String = null;
			var loc12:Boolean = false;
			var loc14:XML = null;
			var loc15:XML = null;
			var loc16:String = null;
			var loc17:XML = null;
			var loc1:Dictionary = new Dictionary(true);
			var loc2:Dictionary = new Dictionary(true);
			var loc3:Dictionary = new Dictionary(true);
			var loc4:Dictionary = new Dictionary(true);
			var loc5:Dictionary = new Dictionary(true);
			var loc6:Dictionary = new Dictionary(true);
			var loc7:Dictionary = new Dictionary(true);
			var loc8:Dictionary = new Dictionary(true);
			var loc9:Dictionary = new Dictionary(true);
			var loc13:PlayerModel = StaticInjectorContext.getInjector().getInstance(PlayerModel);
			for each(loc14 in ObjectLibrary.xmlLibrary_) {
				loc11 = loc14.@id;
				loc10 = int(loc14.@type);
				loc8[loc10] = loc14;
				if (!(loc14.hasOwnProperty("Item") || loc14.hasOwnProperty("Player") || loc14.Class == "Projectile" || loc14.Class == "PetSkin" || loc14.Class == "Pet" || loc11.search("Spawner") >= 0 && !loc13.isAdmin())) {
					if (!(!loc13.isAdmin() && HIDE_OBJECTS_IDS.indexOf(loc11) >= 0)) {
						loc12 = false;
						if (loc14.hasOwnProperty("Class") && String(loc14.Class).match(/wall$/i)) {
							loc6[loc10] = loc14;
							loc7[loc10] = loc14;
							loc12 = true;
						} else if (loc14.hasOwnProperty("Model")) {
							loc5[loc10] = loc14;
							loc7[loc10] = loc14;
							loc12 = true;
						} else if (loc14.hasOwnProperty("Enemy")) {
							loc4[loc10] = loc14;
							loc7[loc10] = loc14;
							loc12 = true;
						} else if (loc14.hasOwnProperty("Static") && !loc14.hasOwnProperty("Price")) {
							loc3[loc10] = loc14;
							loc7[loc10] = loc14;
							loc12 = true;
						} else if (loc13.isAdmin()) {
							loc7[loc10] = loc14;
						}
						loc16 = ObjectLibrary.propsLibrary_[loc10].belonedDungeon;
						if (loc12 && loc16 != "") {
							if (loc9[loc16] == null) {
								loc9[loc16] = new Dictionary(true);
							}
							loc9[loc16][loc10] = loc14;
						}
					}
				}
			}
			for each(loc15 in GroundLibrary.xmlLibrary_) {
				loc1[int(loc15.@type)] = loc15;
			}
			if (loc13.isAdmin()) {
				for each(loc17 in RegionLibrary.xmlLibrary_) {
					loc2[int(loc17.@type)] = loc17;
				}
			} else {
				loc2[RegionLibrary.idToType_["Spawn"]] = RegionLibrary.xmlLibrary_[RegionLibrary.idToType_["Spawn"]];
				loc2[RegionLibrary.idToType_["Hallway"]] = RegionLibrary.xmlLibrary_[RegionLibrary.idToType_["Hallway"]];
				loc2[RegionLibrary.idToType_["Enemy"]] = RegionLibrary.xmlLibrary_[RegionLibrary.idToType_["Enemy"]];
				loc2[RegionLibrary.idToType_["Hallway 1"]] = RegionLibrary.xmlLibrary_[RegionLibrary.idToType_["Hallway 1"]];
				loc2[RegionLibrary.idToType_["Hallway 2"]] = RegionLibrary.xmlLibrary_[RegionLibrary.idToType_["Hallway 2"]];
				loc2[RegionLibrary.idToType_["Hallway 3"]] = RegionLibrary.xmlLibrary_[RegionLibrary.idToType_["Hallway 3"]];
				loc2[RegionLibrary.idToType_["Quest Monster Region"]] = RegionLibrary.xmlLibrary_[RegionLibrary.idToType_["Quest Monster Region"]];
				loc2[RegionLibrary.idToType_["Quest Monster Region 2"]] = RegionLibrary.xmlLibrary_[RegionLibrary.idToType_["Quest Monster Region 2"]];
			}
			GROUPS[GROUP_LABELS[0]] = loc1;
			GROUPS[GROUP_LABELS[1]] = loc3;
			GROUPS[GROUP_LABELS[2]] = loc4;
			GROUPS[GROUP_LABELS[3]] = loc6;
			GROUPS[GROUP_LABELS[4]] = loc5;
			GROUPS[GROUP_LABELS[5]] = loc7;
			GROUPS[GROUP_LABELS[6]] = loc2;
			GROUPS[GROUP_LABELS[7]] = loc9;
			GROUPS[GROUP_LABELS[8]] = loc8;
		}

		public static function getDungeonsLabel():Vector.<String> {
			var loc2:* = null;
			var loc1:Vector.<String> = new Vector.<String>();
			for (loc2 in ObjectLibrary.dungeonsXMLLibrary_) {
				loc1.push(loc2);
			}
			loc1.sort(MoreStringUtil.cmp);
			return loc1;
		}

		public static function getDungeonsXML(param1:String):Dictionary {
			return GROUPS[GROUP_LABELS[7]][param1];
		}

		public static function getCategoryByType(param1:int, param2:int):String {
			var loc4:XML = null;
			var loc3:PlayerModel = StaticInjectorContext.getInjector().getInstance(PlayerModel);
			if (param2 == Layer.REGION) {
				return GROUP_LABELS[6];
			}
			if (param2 == Layer.GROUND) {
				return GROUP_LABELS[0];
			}
			if (loc3.isAdmin()) {
				return GROUP_LABELS[5];
			}
			loc4 = ObjectLibrary.xmlLibrary_[param1];
			if (loc4.hasOwnProperty("Item") || loc4.hasOwnProperty("Player") || loc4.Class == "Projectile" || loc4.Class == "PetSkin" || loc4.Class == "Pet") {
				return "";
			}
			if (loc4.hasOwnProperty("Enemy")) {
				return GROUP_LABELS[2];
			}
			if (loc4.hasOwnProperty("Model")) {
				return GROUP_LABELS[4];
			}
			if (loc4.hasOwnProperty("Class") && String(loc4.Class).match(/wall$/i)) {
				return GROUP_LABELS[3];
			}
			if (loc4.hasOwnProperty("Static") && !loc4.hasOwnProperty("Price")) {
				return GROUP_LABELS[1];
			}
			return "";
		}
	}
}
