package com.company.assembleegameclient.screens.charrects {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.filters.DropShadowFilter;
	import flash.text.TextFieldAutoSize;

	import kabam.rotmg.assets.services.IconFactory;
	import kabam.rotmg.core.model.PlayerModel;
	import kabam.rotmg.text.model.TextKey;
	import kabam.rotmg.text.view.TextFieldDisplayConcrete;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;
	import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;

	public class BuyCharacterRect extends CharacterRect {

		public static const BUY_CHARACTER_RECT_CLASS_NAME_TEXT:String = "BuyCharacterRect.classNameText";


		private var model:PlayerModel;

		public function BuyCharacterRect(param1:PlayerModel) {
			super();
			this.model = param1;
			super.color = 2039583;
			super.overColor = 4342338;
			className = new LineBuilder().setParams(BUY_CHARACTER_RECT_CLASS_NAME_TEXT, {"nth": param1.getMaxCharacters() + 1});
			super.init();
			this.makeIcon();
			this.makeTagline();
			this.makePriceText();
			this.makeCoin();
		}

		private function makeCoin():void {
			var loc2:Bitmap = null;
			var loc1:BitmapData = IconFactory.makeCoin();
			loc2 = new Bitmap(loc1);
			loc2.x = WIDTH - 43;
			loc2.y = (HEIGHT - loc2.height) * 0.5 - 1;
			selectContainer.addChild(loc2);
		}

		private function makePriceText():void {
			var loc1:TextFieldDisplayConcrete = null;
			loc1 = new TextFieldDisplayConcrete().setSize(18).setColor(16777215).setAutoSize(TextFieldAutoSize.RIGHT);
			loc1.setStringBuilder(new StaticStringBuilder(this.model.getNextCharSlotPrice().toString()));
			loc1.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
			loc1.x = WIDTH - 43;
			loc1.y = 19;
			selectContainer.addChild(loc1);
		}

		private function makeTagline():void {
			var loc1:int = 100 - this.model.getNextCharSlotPrice() / 10;
			var loc2:String = String(loc1);
			if (loc1 != 0) {
				makeTaglineText(new LineBuilder().setParams(TextKey.BUY_CHARACTER_RECT_TAGLINE_TEXT, {"percentage": loc2}));
			}
		}

		private function makeIcon():void {
			var loc1:Shape = null;
			loc1 = this.buildIcon();
			loc1.x = CharacterRectConstants.ICON_POS_X + 5;
			loc1.y = (HEIGHT - loc1.height) * 0.5;
			addChild(loc1);
		}

		private function buildIcon():Shape {
			var loc1:Shape = new Shape();
			loc1.graphics.beginFill(3880246);
			loc1.graphics.lineStyle(1, 4603457);
			loc1.graphics.drawCircle(19, 19, 19);
			loc1.graphics.lineStyle();
			loc1.graphics.endFill();
			loc1.graphics.beginFill(2039583);
			loc1.graphics.drawRect(11, 17, 16, 4);
			loc1.graphics.endFill();
			loc1.graphics.beginFill(2039583);
			loc1.graphics.drawRect(17, 11, 4, 16);
			loc1.graphics.endFill();
			return loc1;
		}
	}
}
