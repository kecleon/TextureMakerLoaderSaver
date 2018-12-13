 
package kabam.rotmg.text.model {
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class FontInfo {
		
		private static const renderingFontSize:Number = 200;
		
		private static const GUTTER:Number = 2;
		 
		
		protected var name:String;
		
		private var textColor:uint = 0;
		
		private var xHeightRatio:Number;
		
		private var verticalSpaceRatio:Number;
		
		public function FontInfo() {
			super();
		}
		
		public function setName(param1:String) : void {
			this.name = param1;
			this.computeRatiosByRendering();
		}
		
		public function getName() : String {
			return this.name;
		}
		
		public function getXHeight(param1:Number) : Number {
			return this.xHeightRatio * param1;
		}
		
		public function getVerticalSpace(param1:Number) : Number {
			return this.verticalSpaceRatio * param1;
		}
		
		private function computeRatiosByRendering() : void {
			var loc1:TextField = this.makeTextField();
			var loc2:BitmapData = new BitmapDataSpy(loc1.width,loc1.height);
			loc2.draw(loc1);
			var loc3:uint = 16777215;
			var loc4:Rectangle = loc2.getColorBoundsRect(loc3,this.textColor,true);
			this.xHeightRatio = this.deNormalize(loc4.height);
			this.verticalSpaceRatio = this.deNormalize(loc1.height - loc4.bottom - GUTTER);
		}
		
		private function makeTextField() : TextField {
			var loc1:TextField = new TextField();
			loc1.autoSize = TextFieldAutoSize.LEFT;
			loc1.text = "x";
			loc1.textColor = this.textColor;
			loc1.setTextFormat(new TextFormat(this.name,renderingFontSize));
			return loc1;
		}
		
		private function deNormalize(param1:Number) : Number {
			return param1 / renderingFontSize;
		}
	}
}
