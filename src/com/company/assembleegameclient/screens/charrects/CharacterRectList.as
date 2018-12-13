package com.company.assembleegameclient.screens.charrects {
	import com.company.assembleegameclient.appengine.CharacterStats;
	import com.company.assembleegameclient.appengine.SavedCharacter;
	import com.company.assembleegameclient.parameters.Parameters;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import kabam.rotmg.assets.services.CharacterFactory;
	import kabam.rotmg.classes.model.CharacterClass;
	import kabam.rotmg.classes.model.CharacterSkin;
	import kabam.rotmg.classes.model.ClassesModel;
	import kabam.rotmg.core.StaticInjectorContext;
	import kabam.rotmg.core.model.PlayerModel;

	import org.osflash.signals.Signal;
	import org.swiftsuspenders.Injector;

	public class CharacterRectList extends Sprite {


		private var classes:ClassesModel;

		private var model:PlayerModel;

		private var assetFactory:CharacterFactory;

		public var newCharacter:Signal;

		public var buyCharacterSlot:Signal;

		public function CharacterRectList() {
			var loc5:SavedCharacter = null;
			var loc6:BuyCharacterRect = null;
			var loc7:CharacterClass = null;
			var loc8:CharacterStats = null;
			var loc9:CurrentCharacterRect = null;
			var loc10:int = 0;
			var loc11:CreateNewCharacterRect = null;
			super();
			var loc1:Injector = StaticInjectorContext.getInjector();
			this.classes = loc1.getInstance(ClassesModel);
			this.model = loc1.getInstance(PlayerModel);
			this.assetFactory = loc1.getInstance(CharacterFactory);
			this.newCharacter = new Signal();
			this.buyCharacterSlot = new Signal();
			var loc2:String = this.model.getName();
			var loc3:int = 4;
			var loc4:Vector.<SavedCharacter> = this.model.getSavedCharacters();
			for each(loc5 in loc4) {
				loc7 = this.classes.getCharacterClass(loc5.objectType());
				loc8 = this.model.getCharStats()[loc5.objectType()];
				loc9 = new CurrentCharacterRect(loc2, loc7, loc5, loc8);
				if (Parameters.skinTypes16.indexOf(loc5.skinType()) != -1) {
					loc9.setIcon(this.getIcon(loc5, 50));
				} else {
					loc9.setIcon(this.getIcon(loc5, 100));
				}
				loc9.y = loc3;
				addChild(loc9);
				loc3 = loc3 + (CharacterRect.HEIGHT + 4);
			}
			if (this.model.hasAvailableCharSlot()) {
				loc10 = 0;
				while (loc10 < this.model.getAvailableCharSlots()) {
					loc11 = new CreateNewCharacterRect(this.model);
					loc11.addEventListener(MouseEvent.MOUSE_DOWN, this.onNewChar);
					loc11.y = loc3;
					addChild(loc11);
					loc3 = loc3 + (CharacterRect.HEIGHT + 4);
					loc10++;
				}
			}
			loc6 = new BuyCharacterRect(this.model);
			loc6.addEventListener(MouseEvent.MOUSE_DOWN, this.onBuyCharSlot);
			loc6.y = loc3;
			addChild(loc6);
		}

		private function getIcon(param1:SavedCharacter, param2:int = 100):DisplayObject {
			var loc3:CharacterClass = this.classes.getCharacterClass(param1.objectType());
			var loc4:CharacterSkin = loc3.skins.getSkin(param1.skinType()) || loc3.skins.getDefaultSkin();
			var loc5:BitmapData = this.assetFactory.makeIcon(loc4.template, param2, param1.tex1(), param1.tex2());
			return new Bitmap(loc5);
		}

		private function onNewChar(param1:Event):void {
			this.newCharacter.dispatch();
		}

		private function onBuyCharSlot(param1:Event):void {
			this.buyCharacterSlot.dispatch(this.model.getNextCharSlotPrice());
		}
	}
}
