package com.company.assembleegameclient.objects {
	import com.company.assembleegameclient.objects.animation.AnimationsData;
	import com.company.assembleegameclient.parameters.Parameters;
	import com.company.assembleegameclient.util.TextureRedrawer;
	import com.company.assembleegameclient.util.redrawers.GlowRedrawer;
	import com.company.util.AssetLibrary;
	import com.company.util.ConversionUtil;

	import flash.display.BitmapData;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;

	import kabam.rotmg.assets.EmbeddedData;
	import kabam.rotmg.constants.GeneralConstants;
	import kabam.rotmg.constants.ItemConstants;
	import kabam.rotmg.messaging.impl.data.StatData;

	public class ObjectLibrary {

		public static var textureDataFactory:TextureDataFactory = new TextureDataFactory();

		public static const IMAGE_SET_NAME:String = "lofiObj3";

		public static const IMAGE_ID:int = 255;

		public static var playerChars_:Vector.<XML> = new Vector.<XML>();

		public static var hexTransforms_:Vector.<XML> = new Vector.<XML>();

		public static var playerClassAbbr_:Dictionary = new Dictionary();

		public static const propsLibrary_:Dictionary = new Dictionary();

		public static const xmlLibrary_:Dictionary = new Dictionary();

		public static const setLibrary_:Dictionary = new Dictionary();

		public static const idToType_:Dictionary = new Dictionary();

		public static const typeToDisplayId_:Dictionary = new Dictionary();

		public static const typeToTextureData_:Dictionary = new Dictionary();

		public static const typeToTopTextureData_:Dictionary = new Dictionary();

		public static const typeToAnimationsData_:Dictionary = new Dictionary();

		public static const petXMLDataLibrary_:Dictionary = new Dictionary();

		public static const skinSetXMLDataLibrary_:Dictionary = new Dictionary();

		public static const dungeonToPortalTextureData_:Dictionary = new Dictionary();

		public static const petSkinIdToPetType_:Dictionary = new Dictionary();

		public static const dungeonsXMLLibrary_:Dictionary = new Dictionary(true);

		public static const ENEMY_FILTER_LIST:Vector.<String> = new <String>["None", "Hp", "Defense"];

		public static const TILE_FILTER_LIST:Vector.<String> = new <String>["ALL", "Walkable", "Unwalkable", "Slow", "Speed=1"];

		public static const defaultProps_:ObjectProperties = new ObjectProperties(null);

		public static const TYPE_MAP:Object = {
			"ArenaGuard": ArenaGuard,
			"ArenaPortal": ArenaPortal,
			"CaveWall": CaveWall,
			"Character": Character,
			"CharacterChanger": CharacterChanger,
			"ClosedGiftChest": ClosedGiftChest,
			"ClosedVaultChest": ClosedVaultChest,
			"ConnectedWall": ConnectedWall,
			"Container": Container,
			"DoubleWall": DoubleWall,
			"FortuneGround": FortuneGround,
			"FortuneTeller": FortuneTeller,
			"GameObject": GameObject,
			"GuildBoard": GuildBoard,
			"GuildChronicle": GuildChronicle,
			"GuildHallPortal": GuildHallPortal,
			"GuildMerchant": GuildMerchant,
			"GuildRegister": GuildRegister,
			"Merchant": Merchant,
			"MoneyChanger": MoneyChanger,
			"MysteryBoxGround": MysteryBoxGround,
			"NameChanger": NameChanger,
			"ReskinVendor": ReskinVendor,
			"OneWayContainer": OneWayContainer,
			"Player": Player,
			"Portal": Portal,
			"Projectile": Projectile,
			"QuestRewards": QuestRewards,
			"DailyLoginRewards": DailyLoginRewards,
			"Sign": Sign,
			"SpiderWeb": SpiderWeb,
			"Stalagmite": Stalagmite,
			"Wall": Wall,
			"Pet": Pet,
			"PetUpgrader": PetUpgrader,
			"YardUpgrader": YardUpgrader
		};

		private static var currentDungeon:String = "";


		public function ObjectLibrary() {
			super();
		}

		public static function parseDungeonXML(param1:String, param2:XML):void {
			var loc3:int = param1.indexOf("_") + 1;
			var loc4:int = param1.indexOf("CXML");
			if (param1.indexOf("_ObjectsCXML") == -1 && param1.indexOf("_StaticObjectsCXML") == -1) {
				if (param1.indexOf("Objects") != -1) {
					loc4 = param1.indexOf("ObjectsCXML");
				} else if (param1.indexOf("Object") != -1) {
					loc4 = param1.indexOf("ObjectCXML");
				}
			}
			currentDungeon = param1.substr(loc3, loc4 - loc3);
			dungeonsXMLLibrary_[currentDungeon] = new Dictionary(true);
			parseFromXML(param2, parseDungeonCallbak);
		}

		private static function parseDungeonCallbak(param1:int, param2:XML):void {
			if (currentDungeon != "" && dungeonsXMLLibrary_[currentDungeon] != null) {
				dungeonsXMLLibrary_[currentDungeon][param1] = param2;
				propsLibrary_[param1].belonedDungeon = currentDungeon;
			}
		}

		public static function parseFromXML(param1:XML, param2:Function = null):void {
			var loc3:XML = null;
			var loc4:String = null;
			var loc5:String = null;
			var loc6:int = 0;
			var loc7:Boolean = false;
			var loc8:int = 0;
			for each(loc3 in param1.Object) {
				loc4 = String(loc3.@id);
				loc5 = loc4;
				if (loc3.hasOwnProperty("DisplayId")) {
					loc5 = loc3.DisplayId;
				}
				if (loc3.hasOwnProperty("Group")) {
					if (loc3.Group == "Hexable") {
						hexTransforms_.push(loc3);
					}
				}
				loc6 = int(loc3.@type);
				if (loc3.hasOwnProperty("PetBehavior") || loc3.hasOwnProperty("PetAbility")) {
					petXMLDataLibrary_[loc6] = loc3;
				} else {
					propsLibrary_[loc6] = new ObjectProperties(loc3);
					xmlLibrary_[loc6] = loc3;
					idToType_[loc4] = loc6;
					typeToDisplayId_[loc6] = loc5;
					if (param2 != null) {
						param2(loc6, loc3);
					}
					if (String(loc3.Class) == "Player") {
						playerClassAbbr_[loc6] = String(loc3.@id).substr(0, 2);
						loc7 = false;
						loc8 = 0;
						while (loc8 < playerChars_.length) {
							if (int(playerChars_[loc8].@type) == loc6) {
								playerChars_[loc8] = loc3;
								loc7 = true;
							}
							loc8++;
						}
						if (!loc7) {
							playerChars_.push(loc3);
						}
					}
					typeToTextureData_[loc6] = textureDataFactory.create(loc3);
					if (loc3.hasOwnProperty("Top")) {
						typeToTopTextureData_[loc6] = textureDataFactory.create(XML(loc3.Top));
					}
					if (loc3.hasOwnProperty("Animation")) {
						typeToAnimationsData_[loc6] = new AnimationsData(loc3);
					}
					if (loc3.hasOwnProperty("IntergamePortal") && loc3.hasOwnProperty("DungeonName")) {
						dungeonToPortalTextureData_[String(loc3.DungeonName)] = typeToTextureData_[loc6];
					}
					if (String(loc3.Class) == "Pet" && loc3.hasOwnProperty("DefaultSkin")) {
						petSkinIdToPetType_[String(loc3.DefaultSkin)] = loc6;
					}
				}
			}
		}

		public static function getIdFromType(param1:int):String {
			var loc2:XML = xmlLibrary_[param1];
			if (loc2 == null) {
				return null;
			}
			return String(loc2.@id);
		}

		public static function getSetXMLFromType(param1:int):XML {
			var loc2:XML = null;
			var loc3:int = 0;
			if (setLibrary_[param1] != undefined) {
				return setLibrary_[param1];
			}
			for each(loc2 in EmbeddedData.skinsEquipmentSetsXML.EquipmentSet) {
				loc3 = int(loc2.@type);
				setLibrary_[loc3] = loc2;
			}
			return setLibrary_[param1];
		}

		public static function getPropsFromId(param1:String):ObjectProperties {
			var loc2:int = idToType_[param1];
			return propsLibrary_[loc2];
		}

		public static function getXMLfromId(param1:String):XML {
			var loc2:int = idToType_[param1];
			return xmlLibrary_[loc2];
		}

		public static function getObjectFromType(param1:int):GameObject {
			var objectXML:XML = null;
			var typeReference:String = null;
			var objectType:int = param1;
			try {
				objectXML = xmlLibrary_[objectType];
				typeReference = objectXML.Class;
			}
			catch (e:Error) {
				throw new Error("Type: 0x" + objectType.toString(16));
			}
			var typeClass:Class = TYPE_MAP[typeReference] || makeClass(typeReference);
			return new typeClass(objectXML);
		}

		private static function makeClass(param1:String):Class {
			var loc2:String = "com.company.assembleegameclient.objects." + param1;
			return getDefinitionByName(loc2) as Class;
		}

		public static function getTextureFromType(param1:int):BitmapData {
			var loc2:TextureData = typeToTextureData_[param1];
			if (loc2 == null) {
				return null;
			}
			return loc2.getTexture();
		}

		public static function getBitmapData(param1:int):BitmapData {
			var loc2:TextureData = typeToTextureData_[param1];
			var loc3:BitmapData = !!loc2 ? loc2.getTexture() : null;
			if (loc3) {
				return loc3;
			}
			return AssetLibrary.getImageFromSet(IMAGE_SET_NAME, IMAGE_ID);
		}

		public static function getRedrawnTextureFromType(param1:int, param2:int, param3:Boolean, param4:Boolean = true, param5:Number = 5):BitmapData {
			var loc6:BitmapData = getBitmapData(param1);
			if (Parameters.itemTypes16.indexOf(param1) != -1 || loc6.height == 16) {
				param2 = param2 * 0.5;
			}
			var loc7:TextureData = typeToTextureData_[param1];
			var loc8:BitmapData = !!loc7 ? loc7.mask_ : null;
			if (loc8 == null) {
				return TextureRedrawer.redraw(loc6, param2, param3, 0, param4, param5);
			}
			var loc9:XML = xmlLibrary_[param1];
			var loc10:int = !!loc9.hasOwnProperty("Tex1") ? int(int(loc9.Tex1)) : 0;
			var loc11:int = !!loc9.hasOwnProperty("Tex2") ? int(int(loc9.Tex2)) : 0;
			loc6 = TextureRedrawer.resize(loc6, loc8, param2, param3, loc10, loc11, param5);
			loc6 = GlowRedrawer.outlineGlow(loc6, 0);
			return loc6;
		}

		public static function getSizeFromType(param1:int):int {
			var loc2:XML = xmlLibrary_[param1];
			if (!loc2.hasOwnProperty("Size")) {
				return 100;
			}
			return int(loc2.Size);
		}

		public static function getSlotTypeFromType(param1:int):int {
			var loc2:XML = xmlLibrary_[param1];
			if (!loc2.hasOwnProperty("SlotType")) {
				return -1;
			}
			return int(loc2.SlotType);
		}

		public static function isEquippableByPlayer(param1:int, param2:Player):Boolean {
			if (param1 == ItemConstants.NO_ITEM) {
				return false;
			}
			var loc3:XML = xmlLibrary_[param1];
			var loc4:int = int(loc3.SlotType.toString());
			var loc5:uint = 0;
			while (loc5 < GeneralConstants.NUM_EQUIPMENT_SLOTS) {
				if (param2.slotTypes_[loc5] == loc4) {
					return true;
				}
				loc5++;
			}
			return false;
		}

		public static function getMatchingSlotIndex(param1:int, param2:Player):int {
			var loc3:XML = null;
			var loc4:int = 0;
			var loc5:uint = 0;
			if (param1 != ItemConstants.NO_ITEM) {
				loc3 = xmlLibrary_[param1];
				loc4 = int(loc3.SlotType);
				loc5 = 0;
				while (loc5 < GeneralConstants.NUM_EQUIPMENT_SLOTS) {
					if (param2.slotTypes_[loc5] == loc4) {
						return loc5;
					}
					loc5++;
				}
			}
			return -1;
		}

		public static function isUsableByPlayer(param1:int, param2:Player):Boolean {
			if (param2 == null || param2.slotTypes_ == null) {
				return true;
			}
			var loc3:XML = xmlLibrary_[param1];
			if (loc3 == null || !loc3.hasOwnProperty("SlotType")) {
				return false;
			}
			var loc4:int = loc3.SlotType;
			if (loc4 == ItemConstants.POTION_TYPE || loc4 == ItemConstants.EGG_TYPE) {
				return true;
			}
			var loc5:int = 0;
			while (loc5 < param2.slotTypes_.length) {
				if (param2.slotTypes_[loc5] == loc4) {
					return true;
				}
				loc5++;
			}
			return false;
		}

		public static function isSoulbound(param1:int):Boolean {
			var loc2:XML = xmlLibrary_[param1];
			return loc2 != null && loc2.hasOwnProperty("Soulbound");
		}

		public static function isDropTradable(param1:int):Boolean {
			var loc2:XML = xmlLibrary_[param1];
			return loc2 != null && loc2.hasOwnProperty("DropTradable");
		}

		public static function usableBy(param1:int):Vector.<String> {
			var loc5:XML = null;
			var loc6:Vector.<int> = null;
			var loc7:int = 0;
			var loc2:XML = xmlLibrary_[param1];
			if (loc2 == null || !loc2.hasOwnProperty("SlotType")) {
				return null;
			}
			var loc3:int = loc2.SlotType;
			if (loc3 == ItemConstants.POTION_TYPE || loc3 == ItemConstants.RING_TYPE || loc3 == ItemConstants.EGG_TYPE) {
				return null;
			}
			var loc4:Vector.<String> = new Vector.<String>();
			for each(loc5 in playerChars_) {
				loc6 = ConversionUtil.toIntVector(loc5.SlotTypes);
				loc7 = 0;
				while (loc7 < loc6.length) {
					if (loc6[loc7] == loc3) {
						loc4.push(typeToDisplayId_[int(loc5.@type)]);
						break;
					}
					loc7++;
				}
			}
			return loc4;
		}

		public static function playerMeetsRequirements(param1:int, param2:Player):Boolean {
			var loc4:XML = null;
			if (param2 == null) {
				return true;
			}
			var loc3:XML = xmlLibrary_[param1];
			for each(loc4 in loc3.EquipRequirement) {
				if (!playerMeetsRequirement(loc4, param2)) {
					return false;
				}
			}
			return true;
		}

		public static function playerMeetsRequirement(param1:XML, param2:Player):Boolean {
			var loc3:int = 0;
			if (param1.toString() == "Stat") {
				loc3 = int(param1.@value);
				switch (int(param1.@stat)) {
					case StatData.MAX_HP_STAT:
						return param2.maxHP_ >= loc3;
					case StatData.MAX_MP_STAT:
						return param2.maxMP_ >= loc3;
					case StatData.LEVEL_STAT:
						return param2.level_ >= loc3;
					case StatData.ATTACK_STAT:
						return param2.attack_ >= loc3;
					case StatData.DEFENSE_STAT:
						return param2.defense_ >= loc3;
					case StatData.SPEED_STAT:
						return param2.speed_ >= loc3;
					case StatData.VITALITY_STAT:
						return param2.vitality_ >= loc3;
					case StatData.WISDOM_STAT:
						return param2.wisdom_ >= loc3;
					case StatData.DEXTERITY_STAT:
						return param2.dexterity_ >= loc3;
				}
			}
			return false;
		}

		public static function getPetDataXMLByType(param1:int):XML {
			return petXMLDataLibrary_[param1];
		}
	}
}
