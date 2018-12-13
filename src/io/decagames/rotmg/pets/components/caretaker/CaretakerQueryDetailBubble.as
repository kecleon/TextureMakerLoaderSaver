 
package io.decagames.rotmg.pets.components.caretaker {
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextFieldAutoSize;
	import flashx.textLayout.formats.VerticalAlign;
	import kabam.rotmg.text.view.TextFieldDisplayConcrete;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;
	import kabam.rotmg.util.graphics.BevelRect;
	import kabam.rotmg.util.graphics.GraphicsHelper;
	
	public class CaretakerQueryDetailBubble extends Sprite {
		 
		
		private const WIDTH:int = 441;
		
		private const HEIGHT:int = 252;
		
		private const BEVEL:int = 4;
		
		private const POINT:int = 6;
		
		private const POINT_CENTER:int = 25;
		
		private const PADDING:int = 8;
		
		private const bubble:Shape = new Shape();
		
		private const textfield:TextFieldDisplayConcrete = this.makeText();
		
		public function CaretakerQueryDetailBubble() {
			super();
			addChild(this.bubble);
			addChild(this.textfield);
		}
		
		private function makeText() : TextFieldDisplayConcrete {
			var loc1:TextFieldDisplayConcrete = new TextFieldDisplayConcrete().setSize(16).setLeading(3).setAutoSize(TextFieldAutoSize.LEFT).setVerticalAlign(VerticalAlign.TOP).setMultiLine(true).setWordWrap(true).setPosition(this.PADDING,this.PADDING).setTextWidth(this.WIDTH - 2 * this.PADDING).setTextHeight(this.HEIGHT - 2 * this.PADDING);
			return loc1;
		}
		
		public function setText(param1:String) : void {
			this.textfield.setStringBuilder(new LineBuilder().setParams(param1));
			this.textfield.textChanged.add(this.onTextUpdated);
		}
		
		private function onTextUpdated() : void {
			this.makeBubble();
		}
		
		private function makeBubble() : void {
			var loc1:GraphicsHelper = new GraphicsHelper();
			var loc2:BevelRect = new BevelRect(this.WIDTH,this.textfield.height + 16,this.BEVEL);
			this.bubble.graphics.beginFill(14737632);
			loc1.drawBevelRect(0,0,loc2,this.bubble.graphics);
			this.bubble.graphics.endFill();
			this.bubble.graphics.beginFill(14737632);
			this.bubble.graphics.moveTo(this.POINT_CENTER - this.POINT,0);
			this.bubble.graphics.lineTo(this.POINT_CENTER,-this.POINT);
			this.bubble.graphics.lineTo(this.POINT_CENTER + this.POINT,0);
			this.bubble.graphics.endFill();
		}
	}
}
