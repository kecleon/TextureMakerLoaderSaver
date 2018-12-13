 
package io.decagames.rotmg.ui.sliceScaling {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class SliceScalingBitmap extends Bitmap {
		
		public static var SCALE_TYPE_NONE:String = "none";
		
		public static var SCALE_TYPE_3:String = "3grid";
		
		public static var SCALE_TYPE_9:String = "9grid";
		 
		
		private var scaleGrid:Rectangle;
		
		private var currentWidth:int;
		
		private var currentHeight:int;
		
		private var bitmapDataToSlice:BitmapData;
		
		private var _scaleType:String;
		
		private var fillColor:uint;
		
		protected var margin:Point;
		
		private var fillColorAlpha:Number;
		
		private var _forceRenderInNextFrame:Boolean;
		
		private var _sourceBitmapName:String;
		
		public function SliceScalingBitmap(param1:BitmapData, param2:String, param3:Rectangle = null, param4:uint = 0, param5:Number = 1) {
			this.margin = new Point();
			super();
			this.bitmapDataToSlice = param1;
			this.scaleGrid = param3;
			this.currentWidth = param1.width;
			this.currentHeight = param1.height;
			this._scaleType = param2;
			this.fillColor = param4;
			this.fillColorAlpha = param5;
			if(param2 != SCALE_TYPE_NONE) {
				this.render();
			} else {
				this.bitmapData = param1;
			}
		}
		
		public function clone() : SliceScalingBitmap {
			return new SliceScalingBitmap(this.bitmapDataToSlice.clone(),this.scaleType,this.scaleGrid,this.fillColor,this.fillColorAlpha);
		}
		
		override public function set width(param1:Number) : void {
			if(param1 != this.currentWidth || this._forceRenderInNextFrame) {
				this.currentWidth = param1;
				this.render();
			}
		}
		
		override public function set height(param1:Number) : void {
			if(param1 != this.currentHeight) {
				this.currentHeight = param1;
				this.render();
			}
		}
		
		override public function get width() : Number {
			return this.currentWidth;
		}
		
		override public function get height() : Number {
			return this.currentHeight;
		}
		
		protected function render() : void {
			if(this._scaleType == SCALE_TYPE_NONE) {
				return;
			}
			if(this.bitmapData) {
				this.bitmapData.dispose();
			}
			if(this._scaleType == SCALE_TYPE_3) {
				this.prepare3grid();
			}
			if(this._scaleType == SCALE_TYPE_9) {
				this.prepare9grid();
			}
			if(this._forceRenderInNextFrame) {
				this._forceRenderInNextFrame = false;
			}
		}
		
		private function prepare3grid() : void {
			var loc1:int = 0;
			var loc2:int = 0;
			var loc3:int = 0;
			var loc4:int = 0;
			if(this.scaleGrid.y == 0) {
				loc1 = this.currentWidth - this.bitmapDataToSlice.width + this.scaleGrid.width;
				this.bitmapData = new BitmapData(this.currentWidth + this.margin.x,this.currentHeight + this.margin.y,true,0);
				this.bitmapData.copyPixels(this.bitmapDataToSlice,new Rectangle(0,0,this.scaleGrid.x,this.bitmapDataToSlice.height),new Point(this.margin.x,this.margin.y));
				loc2 = 0;
				while(loc2 < loc1) {
					this.bitmapData.copyPixels(this.bitmapDataToSlice,new Rectangle(this.scaleGrid.x,0,this.scaleGrid.width,this.bitmapDataToSlice.height),new Point(this.scaleGrid.x + loc2 + this.margin.x,this.margin.y));
					loc2++;
				}
				this.bitmapData.copyPixels(this.bitmapDataToSlice,new Rectangle(this.scaleGrid.x + this.scaleGrid.width,0,this.bitmapDataToSlice.width - (this.scaleGrid.x + this.scaleGrid.width),this.bitmapDataToSlice.height),new Point(this.scaleGrid.x + loc1 + this.margin.x,this.margin.y));
			} else {
				loc3 = this.currentHeight - this.bitmapDataToSlice.height + this.scaleGrid.height;
				this.bitmapData = new BitmapData(this.currentWidth + this.margin.x,this.currentHeight + this.margin.y,true,0);
				this.bitmapData.copyPixels(this.bitmapDataToSlice,new Rectangle(0,0,this.bitmapDataToSlice.width,this.scaleGrid.y),new Point(this.margin.x,this.margin.y));
				loc4 = 0;
				while(loc4 < loc3) {
					this.bitmapData.copyPixels(this.bitmapDataToSlice,new Rectangle(0,this.scaleGrid.y,this.scaleGrid.width,this.bitmapDataToSlice.height),new Point(this.margin.x,this.margin.y + this.scaleGrid.y + loc4));
					loc4++;
				}
				this.bitmapData.copyPixels(this.bitmapDataToSlice,new Rectangle(0,this.scaleGrid.y + this.scaleGrid.height,this.bitmapDataToSlice.width,this.bitmapDataToSlice.height - (this.scaleGrid.y + this.scaleGrid.height)),new Point(this.margin.x,this.margin.y + this.scaleGrid.y + loc3));
			}
		}
		
		private function prepare9grid() : void {
			var loc10:int = 0;
			var loc1:Rectangle = new Rectangle();
			var loc2:Rectangle = new Rectangle();
			var loc3:Matrix = new Matrix();
			var loc4:BitmapData = new BitmapData(this.currentWidth + this.margin.x,this.currentHeight + this.margin.y,true,0);
			var loc5:Array = [0,this.scaleGrid.top,this.scaleGrid.bottom,this.bitmapDataToSlice.height];
			var loc6:Array = [0,this.scaleGrid.left,this.scaleGrid.right,this.bitmapDataToSlice.width];
			var loc7:Array = [0,this.scaleGrid.top,this.currentHeight - (this.bitmapDataToSlice.height - this.scaleGrid.bottom),this.currentHeight];
			var loc8:Array = [0,this.scaleGrid.left,this.currentWidth - (this.bitmapDataToSlice.width - this.scaleGrid.right),this.currentWidth];
			var loc9:int = 0;
			while(loc9 < 3) {
				loc10 = 0;
				while(loc10 < 3) {
					loc1.setTo(loc6[loc9],loc5[loc10],loc6[loc9 + 1] - loc6[loc9],loc5[loc10 + 1] - loc5[loc10]);
					loc2.setTo(loc8[loc9],loc7[loc10],loc8[loc9 + 1] - loc8[loc9],loc7[loc10 + 1] - loc7[loc10]);
					loc3.identity();
					loc3.a = loc2.width / loc1.width;
					loc3.d = loc2.height / loc1.height;
					loc3.tx = loc2.x - loc1.x * loc3.a;
					loc3.ty = loc2.y - loc1.y * loc3.d;
					loc4.draw(this.bitmapDataToSlice,loc3,null,null,loc2);
					loc10++;
				}
				loc9++;
			}
			this.bitmapData = loc4;
		}
		
		public function addMargin(param1:int, param2:int) : void {
			this.margin = new Point(param1,param2);
		}
		
		public function dispose() : void {
			this.bitmapData.dispose();
			this.bitmapDataToSlice.dispose();
		}
		
		public function get scaleType() : String {
			return this._scaleType;
		}
		
		public function set scaleType(param1:String) : void {
			this._scaleType = param1;
		}
		
		override public function set x(param1:Number) : void {
			super.x = Math.round(param1);
		}
		
		override public function set y(param1:Number) : void {
			super.y = Math.round(param1);
		}
		
		public function get forceRenderInNextFrame() : Boolean {
			return this._forceRenderInNextFrame;
		}
		
		public function set forceRenderInNextFrame(param1:Boolean) : void {
			this._forceRenderInNextFrame = param1;
		}
		
		public function get marginX() : int {
			return this.margin.x;
		}
		
		public function get marginY() : int {
			return this.margin.y;
		}
		
		public function get sourceBitmapName() : String {
			return this._sourceBitmapName;
		}
		
		public function set sourceBitmapName(param1:String) : void {
			this._sourceBitmapName = param1;
		}
	}
}
