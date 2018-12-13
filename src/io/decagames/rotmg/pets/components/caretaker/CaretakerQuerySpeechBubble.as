package io.decagames.rotmg.pets.components.caretaker {
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextFieldAutoSize;

	import flashx.textLayout.formats.VerticalAlign;

	import kabam.rotmg.text.view.TextFieldDisplayConcrete;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;
	import kabam.rotmg.util.graphics.BevelRect;
	import kabam.rotmg.util.graphics.GraphicsHelper;

	public class CaretakerQuerySpeechBubble extends Sprite {


		private const WIDTH:int = 380;

		private const HEIGHT:int = 42;

		private const BEVEL:int = 4;

		private const POINT:int = 6;

		public function CaretakerQuerySpeechBubble(param1:String) {
			super();
			addChild(this.makeBubble());
			addChild(this.makeText(param1));
		}

		private function makeBubble():Shape {
			var loc1:Shape = new Shape();
			this.drawBubble(loc1);
			return loc1;
		}

		private function drawBubble(param1:Shape):void {
			var loc2:GraphicsHelper = new GraphicsHelper();
			var loc3:BevelRect = new BevelRect(this.WIDTH, this.HEIGHT, this.BEVEL);
			var loc4:int = this.HEIGHT / 2;
			param1.graphics.beginFill(14737632);
			loc2.drawBevelRect(0, 0, loc3, param1.graphics);
			param1.graphics.endFill();
			param1.graphics.beginFill(14737632);
			param1.graphics.moveTo(0, loc4 - this.POINT);
			param1.graphics.lineTo(-this.POINT, loc4);
			param1.graphics.lineTo(0, loc4 + this.POINT);
			param1.graphics.endFill();
		}

		private function makeText(param1:String):TextFieldDisplayConcrete {
			var loc2:TextFieldDisplayConcrete = new TextFieldDisplayConcrete().setSize(16).setAutoSize(TextFieldAutoSize.CENTER).setVerticalAlign(VerticalAlign.MIDDLE).setPosition(this.WIDTH / 2, this.HEIGHT / 2);
			loc2.setStringBuilder(new LineBuilder().setParams(param1));
			return loc2;
		}
	}
}
