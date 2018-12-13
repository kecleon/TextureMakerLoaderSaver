package com.company.assembleegameclient.appengine {
	import com.company.assembleegameclient.objects.ObjectLibrary;
	import com.company.assembleegameclient.objects.Player;
	import com.company.assembleegameclient.parameters.Parameters;
	import com.company.assembleegameclient.util.AnimatedChar;
	import com.company.assembleegameclient.util.AnimatedChars;
	import com.company.assembleegameclient.util.MaskedImage;
	import com.company.assembleegameclient.util.TextureRedrawer;
	import com.company.assembleegameclient.util.redrawers.GlowRedrawer;
	import com.company.util.CachingColorTransformer;

	import flash.display.BitmapData;
	import flash.geom.ColorTransform;

	import io.decagames.rotmg.pets.data.PetsModel;
	import io.decagames.rotmg.pets.data.vo.PetVO;

	import kabam.rotmg.assets.services.CharacterFactory;
	import kabam.rotmg.classes.model.CharacterClass;
	import kabam.rotmg.classes.model.CharacterSkin;
	import kabam.rotmg.classes.model.ClassesModel;
	import kabam.rotmg.constants.GeneralConstants;
	import kabam.rotmg.core.StaticInjectorContext;

	import org.swiftsuspenders.Injector;

	public class SavedCharacter {


		public var charXML_:XML;

		public var name_:String = null;

		private var pet:PetVO;

		public function SavedCharacter(param1:XML, param2:String) {
			var loc3:XML = null;
			var loc4:int = 0;
			var loc5:PetVO = null;
			super();
			this.charXML_ = param1;
			this.name_ = param2;
			if (this.charXML_.hasOwnProperty("Pet")) {
				loc3 = new XML(this.charXML_.Pet);
				loc4 = loc3.@instanceId;
				loc5 = StaticInjectorContext.getInjector().getInstance(PetsModel).getPetVO(loc4);
				loc5.apply(loc3);
				this.setPetVO(loc5);
			}
		}

		public static function getImage(param1:SavedCharacter, param2:XML, param3:int, param4:int, param5:Number, param6:Boolean, param7:Boolean):BitmapData {
			var loc8:AnimatedChar = AnimatedChars.getAnimatedChar(String(param2.AnimatedTexture.File), int(param2.AnimatedTexture.Index));
			var loc9:MaskedImage = loc8.imageFromDir(param3, param4, param5);
			var loc10:int = param1 != null ? int(param1.tex1()) : int(null);
			var loc11:int = param1 != null ? int(param1.tex2()) : int(null);
			var loc12:BitmapData = TextureRedrawer.resize(loc9.image_, loc9.mask_, 100, false, loc10, loc11);
			loc12 = GlowRedrawer.outlineGlow(loc12, 0);
			if (!param6) {
				loc12 = CachingColorTransformer.transformBitmapData(loc12, new ColorTransform(0, 0, 0, 0.5, 0, 0, 0, 0));
			} else if (!param7) {
				loc12 = CachingColorTransformer.transformBitmapData(loc12, new ColorTransform(0.75, 0.75, 0.75, 1, 0, 0, 0, 0));
			}
			return loc12;
		}

		public static function compare(param1:SavedCharacter, param2:SavedCharacter):Number {
			var loc3:Number = !!Parameters.data_.charIdUseMap.hasOwnProperty(param1.charId()) ? Number(Parameters.data_.charIdUseMap[param1.charId()]) : Number(0);
			var loc4:Number = !!Parameters.data_.charIdUseMap.hasOwnProperty(param2.charId()) ? Number(Parameters.data_.charIdUseMap[param2.charId()]) : Number(0);
			if (loc3 != loc4) {
				return loc4 - loc3;
			}
			return param2.xp() - param1.xp();
		}

		public function charId():int {
			return int(this.charXML_.@id);
		}

		public function fameBonus():int {
			var loc4:int = 0;
			var loc5:XML = null;
			var loc1:Player = Player.fromPlayerXML("", this.charXML_);
			var loc2:int = 0;
			var loc3:uint = 0;
			while (loc3 < GeneralConstants.NUM_EQUIPMENT_SLOTS) {
				if (loc1.equipment_ && loc1.equipment_.length > loc3) {
					loc4 = loc1.equipment_[loc3];
					if (loc4 != -1) {
						loc5 = ObjectLibrary.xmlLibrary_[loc4];
						if (loc5 != null && loc5.hasOwnProperty("FameBonus")) {
							loc2 = loc2 + int(loc5.FameBonus);
						}
					}
				}
				loc3++;
			}
			return loc2;
		}

		public function name():String {
			return this.name_;
		}

		public function objectType():int {
			return int(this.charXML_.ObjectType);
		}

		public function skinType():int {
			return int(this.charXML_.Texture);
		}

		public function level():int {
			return int(this.charXML_.Level);
		}

		public function tex1():int {
			return int(this.charXML_.Tex1);
		}

		public function tex2():int {
			return int(this.charXML_.Tex2);
		}

		public function xp():int {
			return int(this.charXML_.Exp);
		}

		public function fame():int {
			return int(this.charXML_.CurrentFame);
		}

		public function hp():int {
			return int(this.charXML_.MaxHitPoints);
		}

		public function mp():int {
			return int(this.charXML_.MaxMagicPoints);
		}

		public function att():int {
			return int(this.charXML_.Attack);
		}

		public function def():int {
			return int(this.charXML_.Defense);
		}

		public function spd():int {
			return int(this.charXML_.Speed);
		}

		public function dex():int {
			return int(this.charXML_.Dexterity);
		}

		public function vit():int {
			return int(this.charXML_.HpRegen);
		}

		public function wis():int {
			return int(this.charXML_.MpRegen);
		}

		public function displayId():String {
			return ObjectLibrary.typeToDisplayId_[this.objectType()];
		}

		public function getIcon(param1:int = 100):BitmapData {
			var loc2:Injector = StaticInjectorContext.getInjector();
			var loc3:ClassesModel = loc2.getInstance(ClassesModel);
			var loc4:CharacterFactory = loc2.getInstance(CharacterFactory);
			var loc5:CharacterClass = loc3.getCharacterClass(this.objectType());
			var loc6:CharacterSkin = loc5.skins.getSkin(this.skinType()) || loc5.skins.getDefaultSkin();
			var loc7:BitmapData = loc4.makeIcon(loc6.template, param1, this.tex1(), this.tex2());
			return loc7;
		}

		public function bornOn():String {
			if (!this.charXML_.hasOwnProperty("CreationDate")) {
				return "Unknown";
			}
			return this.charXML_.CreationDate;
		}

		public function getPetVO():PetVO {
			return this.pet;
		}

		public function setPetVO(param1:PetVO):void {
			this.pet = param1;
		}
	}
}
