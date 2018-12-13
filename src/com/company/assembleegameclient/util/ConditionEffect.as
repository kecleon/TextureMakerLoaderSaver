package com.company.assembleegameclient.util {
	import com.company.assembleegameclient.util.redrawers.GlowRedrawer;
	import com.company.util.AssetLibrary;
	import com.company.util.PointUtil;

	import flash.display.BitmapData;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;

	import kabam.rotmg.text.model.TextKey;

	public class ConditionEffect {

		public static const NOTHING:uint = 0;

		public static const DEAD:uint = 1;

		public static const QUIET:uint = 2;

		public static const WEAK:uint = 3;

		public static const SLOWED:uint = 4;

		public static const SICK:uint = 5;

		public static const DAZED:uint = 6;

		public static const STUNNED:uint = 7;

		public static const BLIND:uint = 8;

		public static const HALLUCINATING:uint = 9;

		public static const DRUNK:uint = 10;

		public static const CONFUSED:uint = 11;

		public static const STUN_IMMUNE:uint = 12;

		public static const INVISIBLE:uint = 13;

		public static const PARALYZED:uint = 14;

		public static const SPEEDY:uint = 15;

		public static const BLEEDING:uint = 16;

		public static const ARMORBROKENIMMUNE:uint = 17;

		public static const HEALING:uint = 18;

		public static const DAMAGING:uint = 19;

		public static const BERSERK:uint = 20;

		public static const PAUSED:uint = 21;

		public static const STASIS:uint = 22;

		public static const STASIS_IMMUNE:uint = 23;

		public static const INVINCIBLE:uint = 24;

		public static const INVULNERABLE:uint = 25;

		public static const ARMORED:uint = 26;

		public static const ARMORBROKEN:uint = 27;

		public static const HEXED:uint = 28;

		public static const NINJA_SPEEDY:uint = 29;

		public static const UNSTABLE:uint = 30;

		public static const DARKNESS:uint = 31;

		public static const SLOWED_IMMUNE:uint = 32;

		public static const DAZED_IMMUNE:uint = 33;

		public static const PARALYZED_IMMUNE:uint = 34;

		public static const PETRIFIED:uint = 35;

		public static const PETRIFIED_IMMUNE:uint = 36;

		public static const PET_EFFECT_ICON:uint = 37;

		public static const CURSE:uint = 38;

		public static const CURSE_IMMUNE:uint = 39;

		public static const HP_BOOST:uint = 40;

		public static const MP_BOOST:uint = 41;

		public static const ATT_BOOST:uint = 42;

		public static const DEF_BOOST:uint = 43;

		public static const SPD_BOOST:uint = 44;

		public static const VIT_BOOST:uint = 45;

		public static const WIS_BOOST:uint = 46;

		public static const DEX_BOOST:uint = 47;

		public static const SILENCED:uint = 48;

		public static const EXPOSED:uint = 49;

		public static const GROUND_DAMAGE:uint = 99;

		public static const DEAD_BIT:uint = 1 << DEAD - 1;

		public static const QUIET_BIT:uint = 1 << QUIET - 1;

		public static const WEAK_BIT:uint = 1 << WEAK - 1;

		public static const SLOWED_BIT:uint = 1 << SLOWED - 1;

		public static const SICK_BIT:uint = 1 << SICK - 1;

		public static const DAZED_BIT:uint = 1 << DAZED - 1;

		public static const STUNNED_BIT:uint = 1 << STUNNED - 1;

		public static const BLIND_BIT:uint = 1 << BLIND - 1;

		public static const HALLUCINATING_BIT:uint = 1 << HALLUCINATING - 1;

		public static const DRUNK_BIT:uint = 1 << DRUNK - 1;

		public static const CONFUSED_BIT:uint = 1 << CONFUSED - 1;

		public static const STUN_IMMUNE_BIT:uint = 1 << STUN_IMMUNE - 1;

		public static const INVISIBLE_BIT:uint = 1 << INVISIBLE - 1;

		public static const PARALYZED_BIT:uint = 1 << PARALYZED - 1;

		public static const SPEEDY_BIT:uint = 1 << SPEEDY - 1;

		public static const BLEEDING_BIT:uint = 1 << BLEEDING - 1;

		public static const ARMORBROKEN_IMMUNE_BIT:uint = 1 << ARMORBROKENIMMUNE - 1;

		public static const HEALING_BIT:uint = 1 << HEALING - 1;

		public static const DAMAGING_BIT:uint = 1 << DAMAGING - 1;

		public static const BERSERK_BIT:uint = 1 << BERSERK - 1;

		public static const PAUSED_BIT:uint = 1 << PAUSED - 1;

		public static const STASIS_BIT:uint = 1 << STASIS - 1;

		public static const STASIS_IMMUNE_BIT:uint = 1 << STASIS_IMMUNE - 1;

		public static const INVINCIBLE_BIT:uint = 1 << INVINCIBLE - 1;

		public static const INVULNERABLE_BIT:uint = 1 << INVULNERABLE - 1;

		public static const ARMORED_BIT:uint = 1 << ARMORED - 1;

		public static const ARMORBROKEN_BIT:uint = 1 << ARMORBROKEN - 1;

		public static const HEXED_BIT:uint = 1 << HEXED - 1;

		public static const NINJA_SPEEDY_BIT:uint = 1 << NINJA_SPEEDY - 1;

		public static const UNSTABLE_BIT:uint = 1 << UNSTABLE - 1;

		public static const DARKNESS_BIT:uint = 1 << DARKNESS - 1;

		public static const SLOWED_IMMUNE_BIT:uint = 1 << SLOWED_IMMUNE - NEW_CON_THREASHOLD;

		public static const DAZED_IMMUNE_BIT:uint = 1 << DAZED_IMMUNE - NEW_CON_THREASHOLD;

		public static const PARALYZED_IMMUNE_BIT:uint = 1 << PARALYZED_IMMUNE - NEW_CON_THREASHOLD;

		public static const PETRIFIED_BIT:uint = 1 << PETRIFIED - NEW_CON_THREASHOLD;

		public static const PETRIFIED_IMMUNE_BIT:uint = 1 << PETRIFIED_IMMUNE - NEW_CON_THREASHOLD;

		public static const PET_EFFECT_ICON_BIT:uint = 1 << PET_EFFECT_ICON - NEW_CON_THREASHOLD;

		public static const CURSE_BIT:uint = 1 << CURSE - NEW_CON_THREASHOLD;

		public static const CURSE_IMMUNE_BIT:uint = 1 << CURSE_IMMUNE - NEW_CON_THREASHOLD;

		public static const HP_BOOST_BIT:uint = 1 << HP_BOOST - NEW_CON_THREASHOLD;

		public static const MP_BOOST_BIT:uint = 1 << MP_BOOST - NEW_CON_THREASHOLD;

		public static const ATT_BOOST_BIT:uint = 1 << ATT_BOOST - NEW_CON_THREASHOLD;

		public static const DEF_BOOST_BIT:uint = 1 << DEF_BOOST - NEW_CON_THREASHOLD;

		public static const SPD_BOOST_BIT:uint = 1 << SPD_BOOST - NEW_CON_THREASHOLD;

		public static const VIT_BOOST_BIT:uint = 1 << VIT_BOOST - NEW_CON_THREASHOLD;

		public static const WIS_BOOST_BIT:uint = 1 << WIS_BOOST - NEW_CON_THREASHOLD;

		public static const DEX_BOOST_BIT:uint = 1 << DEX_BOOST - NEW_CON_THREASHOLD;

		public static const SILENCED_BIT:uint = 1 << SILENCED - NEW_CON_THREASHOLD;

		public static const EXPOSED_BIT:uint = 1 << EXPOSED - NEW_CON_THREASHOLD;

		public static const MAP_FILTER_BITMASK:uint = DRUNK_BIT | BLIND_BIT | PAUSED_BIT;

		public static const CE_FIRST_BATCH:uint = 0;

		public static const CE_SECOND_BATCH:uint = 1;

		public static const NUMBER_CE_BATCHES:uint = 2;

		public static const NEW_CON_THREASHOLD:uint = 32;

		public static var effects_:Vector.<ConditionEffect> = new <ConditionEffect>[new ConditionEffect("Nothing", 0, null, TextKey.CONDITIONEFFECT_NOTHING), new ConditionEffect("Dead", DEAD_BIT, null, TextKey.CONDITIONEFFECT_DEAD), new ConditionEffect("Quiet", QUIET_BIT, [32], TextKey.CONDITIONEFFECT_QUIET), new ConditionEffect("Weak", WEAK_BIT, [34, 35, 36, 37], TextKey.CONDITIONEFFECT_WEAK), new ConditionEffect("Slowed", SLOWED_BIT, [1], TextKey.CONDITION_EFFECT_SLOWED), new ConditionEffect("Sick", SICK_BIT, [39], TextKey.CONDITIONEFFECT_SICK), new ConditionEffect("Dazed", DAZED_BIT, [44], TextKey.CONDITION_EFFECT_DAZED), new ConditionEffect("Stunned", STUNNED_BIT, [45], TextKey.CONDITIONEFFECT_STUNNED), new ConditionEffect("Blind", BLIND_BIT, [41], TextKey.CONDITIONEFFECT_BLIND), new ConditionEffect("Hallucinating", HALLUCINATING_BIT, [42], TextKey.CONDITIONEFFECT_HALLUCINATING), new ConditionEffect("Drunk", DRUNK_BIT, [43], TextKey.CONDITIONEFFECT_DRUNK), new ConditionEffect("Confused", CONFUSED_BIT, [2], TextKey.CONDITIONEFFECT_CONFUSED), new ConditionEffect("Stun Immune", STUN_IMMUNE_BIT, null, TextKey.CONDITIONEFFECT_STUN_IMMUNE), new ConditionEffect("Invisible", INVISIBLE_BIT, null, TextKey.CONDITIONEFFECT_INVISIBLE), new ConditionEffect("Paralyzed", PARALYZED_BIT, [53, 54], TextKey.CONDITION_EFFECT_PARALYZED), new ConditionEffect("Speedy", SPEEDY_BIT, [0], TextKey.CONDITIONEFFECT_SPEEDY), new ConditionEffect("Bleeding", BLEEDING_BIT, [46], TextKey.CONDITIONEFFECT_BLEEDING), new ConditionEffect("Armor Broken Immune", ARMORBROKEN_IMMUNE_BIT, null, TextKey.CONDITIONEFFECT_ARMOR_BROKEN_IMMUNE), new ConditionEffect("Healing", HEALING_BIT, [47], TextKey.CONDITIONEFFECT_HEALING), new ConditionEffect("Damaging", DAMAGING_BIT, [49], TextKey.CONDITIONEFFECT_DAMAGING), new ConditionEffect("Berserk", BERSERK_BIT, [50], TextKey.CONDITIONEFFECT_BERSERK), new ConditionEffect("Paused", PAUSED_BIT, null, TextKey.CONDITIONEFFECT_PAUSED), new ConditionEffect("Stasis", STASIS_BIT, null, TextKey.CONDITIONEFFECT_STASIS), new ConditionEffect("Stasis Immune", STASIS_IMMUNE_BIT, null, TextKey.CONDITIONEFFECT_STASIS_IMMUNE), new ConditionEffect("Invincible", INVINCIBLE_BIT, null, TextKey.CONDITIONEFFECT_INVINCIBLE), new ConditionEffect("Invulnerable", INVULNERABLE_BIT, [17], TextKey.CONDITIONEFFECT_INVULNERABLE), new ConditionEffect("Armored", ARMORED_BIT, [16], TextKey.CONDITIONEFFECT_ARMORED), new ConditionEffect("Armor Broken", ARMORBROKEN_BIT, [55], TextKey.CONDITIONEFFECT_ARMOR_BROKEN), new ConditionEffect("Hexed", HEXED_BIT, [42], TextKey.CONDITIONEFFECT_HEXED), new ConditionEffect("Ninja Speedy", NINJA_SPEEDY_BIT, [0], TextKey.CONDITIONEFFECT_NINJA_SPEEDY), new ConditionEffect("Unstable", UNSTABLE_BIT, [56], TextKey.CONDITIONEFFECT_UNSTABLE), new ConditionEffect("Darkness", DARKNESS_BIT, [57], TextKey.CONDITIONEFFECT_DARKNESS), new ConditionEffect("Slowed Immune", SLOWED_IMMUNE_BIT, null, TextKey.CONDITIONEFFECT_SLOWIMMUNE), new ConditionEffect("Dazed Immune", DAZED_IMMUNE_BIT, null, TextKey.CONDITIONEFFECT_DAZEDIMMUNE), new ConditionEffect("Paralyzed Immune", PARALYZED_IMMUNE_BIT, null, TextKey.CONDITIONEFFECT_PARALYZEDIMMUNE), new ConditionEffect("Petrify", PETRIFIED_BIT, null, TextKey.CONDITIONEFFECT_PETRIFIED), new ConditionEffect("Petrify Immune", PETRIFIED_IMMUNE_BIT, null, TextKey.CONDITIONEFFECT_PETRIFY_IMMUNE), new ConditionEffect("Pet Disable", PET_EFFECT_ICON_BIT, [27], TextKey.CONDITIONEFFECT_STASIS, true), new ConditionEffect("Curse", CURSE_BIT, [58], TextKey.CONDITIONEFFECT_CURSE), new ConditionEffect("Curse Immune", CURSE_IMMUNE_BIT, null, TextKey.CONDITIONEFFECT_CURSE_IMMUNE), new ConditionEffect("HP Boost", HP_BOOST_BIT, [32], "HP Boost", true), new ConditionEffect("MP Boost", MP_BOOST_BIT, [33], "MP Boost", true), new ConditionEffect("Att Boost", ATT_BOOST_BIT, [34], "Att Boost", true), new ConditionEffect("Def Boost", DEF_BOOST_BIT, [35], "Def Boost", true), new ConditionEffect("Spd Boost", SPD_BOOST_BIT, [36], "Spd Boost", true), new ConditionEffect("Vit Boost", VIT_BOOST_BIT, [38], "Vit Boost", true), new ConditionEffect("Wis Boost", WIS_BOOST_BIT, [39], "Wis Boost", true), new ConditionEffect("Dex Boost", DEX_BOOST_BIT, [37], "Dex Boost", true), new ConditionEffect("Silenced", SILENCED_BIT, [33], "Silenced"), new ConditionEffect("Exposed", EXPOSED_BIT, [59], "Exposed")];

		private static var conditionEffectFromName_:Object = null;

		private static var effectIconCache:Object = null;

		private static var bitToIcon_:Object = null;

		private static const GLOW_FILTER:GlowFilter = new GlowFilter(0, 0.3, 6, 6, 2, BitmapFilterQuality.LOW, false, false);

		private static var bitToIcon2_:Object = null;


		public var name_:String;

		public var bit_:uint;

		public var iconOffsets_:Array;

		public var localizationKey_:String;

		public var icon16Bit_:Boolean;

		public function ConditionEffect(param1:String, param2:uint, param3:Array, param4:String = "", param5:Boolean = false) {
			super();
			this.name_ = param1;
			this.bit_ = param2;
			this.iconOffsets_ = param3;
			this.localizationKey_ = param4;
			this.icon16Bit_ = param5;
		}

		public static function getConditionEffectFromName(param1:String):uint {
			var loc2:uint = 0;
			if (conditionEffectFromName_ == null) {
				conditionEffectFromName_ = new Object();
				loc2 = 0;
				while (loc2 < effects_.length) {
					conditionEffectFromName_[effects_[loc2].name_] = loc2;
					loc2++;
				}
			}
			return conditionEffectFromName_[param1];
		}

		public static function getConditionEffectEnumFromName(param1:String):ConditionEffect {
			var loc2:ConditionEffect = null;
			for each(loc2 in effects_) {
				if (loc2.name_ == param1) {
					return loc2;
				}
			}
			return null;
		}

		public static function getConditionEffectIcons(param1:uint, param2:Vector.<BitmapData>, param3:int):void {
			var loc4:uint = 0;
			var loc5:uint = 0;
			var loc6:Vector.<BitmapData> = null;
			while (param1 != 0) {
				loc4 = param1 & param1 - 1;
				loc5 = param1 ^ loc4;
				loc6 = getIconsFromBit(loc5);
				if (loc6 != null) {
					param2.push(loc6[param3 % loc6.length]);
				}
				param1 = loc4;
			}
		}

		public static function getConditionEffectIcons2(param1:uint, param2:Vector.<BitmapData>, param3:int):void {
			var loc4:uint = 0;
			var loc5:uint = 0;
			var loc6:Vector.<BitmapData> = null;
			while (param1 != 0) {
				loc4 = param1 & param1 - 1;
				loc5 = param1 ^ loc4;
				loc6 = getIconsFromBit2(loc5);
				if (loc6 != null) {
					param2.push(loc6[param3 % loc6.length]);
				}
				param1 = loc4;
			}
		}

		public static function addConditionEffectIcon(param1:Vector.<BitmapData>, param2:int, param3:Boolean):void {
			var loc4:BitmapData = null;
			var loc5:Matrix = null;
			var loc6:Matrix = null;
			if (effectIconCache == null) {
				effectIconCache = {};
			}
			if (effectIconCache[param2]) {
				loc4 = effectIconCache[param2];
			} else {
				loc5 = new Matrix();
				loc5.translate(4, 4);
				loc6 = new Matrix();
				loc6.translate(1.5, 1.5);
				if (param3) {
					loc4 = new BitmapDataSpy(18, 18, true, 0);
					loc4.draw(AssetLibrary.getImageFromSet("lofiInterfaceBig", param2), loc6);
				} else {
					loc4 = new BitmapDataSpy(16, 16, true, 0);
					loc4.draw(AssetLibrary.getImageFromSet("lofiInterface2", param2), loc5);
				}
				loc4 = GlowRedrawer.outlineGlow(loc4, 4294967295);
				loc4.applyFilter(loc4, loc4.rect, PointUtil.ORIGIN, GLOW_FILTER);
				effectIconCache[param2] = loc4;
			}
			param1.push(loc4);
		}

		private static function getIconsFromBit(param1:uint):Vector.<BitmapData> {
			var loc2:Matrix = null;
			var loc3:uint = 0;
			var loc4:Vector.<BitmapData> = null;
			var loc5:int = 0;
			var loc6:BitmapData = null;
			if (bitToIcon_ == null) {
				bitToIcon_ = new Object();
				loc2 = new Matrix();
				loc2.translate(4, 4);
				loc3 = 0;
				while (loc3 < 32) {
					loc4 = null;
					if (effects_[loc3].iconOffsets_ != null) {
						loc4 = new Vector.<BitmapData>();
						loc5 = 0;
						while (loc5 < effects_[loc3].iconOffsets_.length) {
							loc6 = new BitmapDataSpy(16, 16, true, 0);
							loc6.draw(AssetLibrary.getImageFromSet("lofiInterface2", effects_[loc3].iconOffsets_[loc5]), loc2);
							loc6 = GlowRedrawer.outlineGlow(loc6, 4294967295);
							loc6.applyFilter(loc6, loc6.rect, PointUtil.ORIGIN, GLOW_FILTER);
							loc4.push(loc6);
							loc5++;
						}
					}
					bitToIcon_[effects_[loc3].bit_] = loc4;
					loc3++;
				}
			}
			return bitToIcon_[param1];
		}

		private static function getIconsFromBit2(param1:uint):Vector.<BitmapData> {
			var loc2:Vector.<BitmapData> = null;
			var loc3:BitmapData = null;
			var loc4:Matrix = null;
			var loc5:Matrix = null;
			var loc6:uint = 0;
			var loc7:int = 0;
			if (bitToIcon2_ == null) {
				bitToIcon2_ = [];
				loc2 = new Vector.<BitmapData>();
				loc4 = new Matrix();
				loc4.translate(4, 4);
				loc5 = new Matrix();
				loc5.translate(1.5, 1.5);
				loc6 = 32;
				while (loc6 < effects_.length) {
					loc2 = null;
					if (effects_[loc6].iconOffsets_ != null) {
						loc2 = new Vector.<BitmapData>();
						loc7 = 0;
						while (loc7 < effects_[loc6].iconOffsets_.length) {
							if (effects_[loc6].icon16Bit_) {
								loc3 = new BitmapDataSpy(18, 18, true, 0);
								loc3.draw(AssetLibrary.getImageFromSet("lofiInterfaceBig", effects_[loc6].iconOffsets_[loc7]), loc5);
							} else {
								loc3 = new BitmapDataSpy(16, 16, true, 0);
								loc3.draw(AssetLibrary.getImageFromSet("lofiInterface2", effects_[loc6].iconOffsets_[loc7]), loc4);
							}
							loc3 = GlowRedrawer.outlineGlow(loc3, 4294967295);
							loc3.applyFilter(loc3, loc3.rect, PointUtil.ORIGIN, GLOW_FILTER);
							loc2.push(loc3);
							loc7++;
						}
					}
					bitToIcon2_[effects_[loc6].bit_] = loc2;
					loc6++;
				}
			}
			if (bitToIcon2_ != null && bitToIcon2_[param1] != null) {
				return bitToIcon2_[param1];
			}
			return null;
		}
	}
}
