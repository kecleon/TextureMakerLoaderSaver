package com.company.assembleegameclient.mapeditor {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	public class BigBitmapData {

		private static const CHUNK_SIZE:int = 256;


		public var width_:int;

		public var height_:int;

		public var fillColor_:uint;

		private var maxChunkX_:int;

		private var maxChunkY_:int;

		private var chunks_:Vector.<BitmapData>;

		public function BigBitmapData(param1:int, param2:int, param3:Boolean, param4:uint) {
			var loc6:int = 0;
			var loc7:int = 0;
			var loc8:int = 0;
			super();
			this.width_ = param1;
			this.height_ = param2;
			this.fillColor_ = param4;
			this.maxChunkX_ = Math.ceil(this.width_ / CHUNK_SIZE);
			this.maxChunkY_ = Math.ceil(this.height_ / CHUNK_SIZE);
			this.chunks_ = new Vector.<BitmapData>(this.maxChunkX_ * this.maxChunkY_, true);
			var loc5:int = 0;
			while (loc5 < this.maxChunkX_) {
				loc6 = 0;
				while (loc6 < this.maxChunkY_) {
					loc7 = Math.min(CHUNK_SIZE, this.width_ - loc5 * CHUNK_SIZE);
					loc8 = Math.min(CHUNK_SIZE, this.height_ - loc6 * CHUNK_SIZE);
					this.chunks_[loc5 + loc6 * this.maxChunkX_] = new BitmapDataSpy(loc7, loc8, param3, this.fillColor_);
					loc6++;
				}
				loc5++;
			}
		}

		public function copyTo(param1:BitmapData, param2:Rectangle, param3:Rectangle):void {
			var loc12:int = 0;
			var loc13:BitmapData = null;
			var loc14:Rectangle = null;
			var loc4:Number = param3.width / param2.width;
			var loc5:Number = param3.height / param2.height;
			var loc6:int = int(param3.x / CHUNK_SIZE);
			var loc7:int = int(param3.y / CHUNK_SIZE);
			var loc8:int = Math.ceil(param3.right / CHUNK_SIZE);
			var loc9:int = Math.ceil(param3.bottom / CHUNK_SIZE);
			var loc10:Matrix = new Matrix();
			var loc11:int = loc6;
			while (loc11 < loc8) {
				loc12 = loc7;
				while (loc12 < loc9) {
					loc13 = this.chunks_[loc11 + loc12 * this.maxChunkX_];
					loc10.identity();
					loc10.scale(loc4, loc5);
					loc10.translate(param3.x - loc11 * CHUNK_SIZE - param2.x * loc4, param3.y - loc12 * CHUNK_SIZE - param2.x * loc5);
					loc14 = new Rectangle(param3.x - loc11 * CHUNK_SIZE, param3.y - loc12 * CHUNK_SIZE, param3.width, param3.height);
					loc13.draw(param1, loc10, null, null, loc14, false);
					loc12++;
				}
				loc11++;
			}
		}

		public function copyFrom(param1:Rectangle, param2:BitmapData, param3:Rectangle):void {
			var loc13:int = 0;
			var loc14:BitmapData = null;
			var loc4:Number = param3.width / param1.width;
			var loc5:Number = param3.height / param1.height;
			var loc6:int = Math.max(0, int(param1.x / CHUNK_SIZE));
			var loc7:int = Math.max(0, int(param1.y / CHUNK_SIZE));
			var loc8:int = Math.min(this.maxChunkX_ - 1, int(param1.right / CHUNK_SIZE));
			var loc9:int = Math.min(this.maxChunkY_ - 1, int(param1.bottom / CHUNK_SIZE));
			var loc10:Rectangle = new Rectangle();
			var loc11:Matrix = new Matrix();
			var loc12:int = loc6;
			while (loc12 <= loc8) {
				loc13 = loc7;
				while (loc13 <= loc9) {
					loc14 = this.chunks_[loc12 + loc13 * this.maxChunkX_];
					loc11.identity();
					loc11.translate(param3.x / loc4 - param1.x + loc12 * CHUNK_SIZE, param3.y / loc5 - param1.y + loc13 * CHUNK_SIZE);
					loc11.scale(loc4, loc5);
					param2.draw(loc14, loc11, null, null, param3, false);
					loc13++;
				}
				loc12++;
			}
		}

		public function erase(param1:Rectangle):void {
			var loc8:int = 0;
			var loc9:BitmapData = null;
			var loc2:int = int(param1.x / CHUNK_SIZE);
			var loc3:int = int(param1.y / CHUNK_SIZE);
			var loc4:int = Math.ceil(param1.right / CHUNK_SIZE);
			var loc5:int = Math.ceil(param1.bottom / CHUNK_SIZE);
			var loc6:Rectangle = new Rectangle();
			var loc7:int = loc2;
			while (loc7 < loc4) {
				loc8 = loc3;
				while (loc8 < loc5) {
					loc9 = this.chunks_[loc7 + loc8 * this.maxChunkX_];
					loc6.x = param1.x - loc7 * CHUNK_SIZE;
					loc6.y = param1.y - loc8 * CHUNK_SIZE;
					loc6.right = param1.right - loc7 * CHUNK_SIZE;
					loc6.bottom = param1.bottom - loc8 * CHUNK_SIZE;
					loc9.fillRect(loc6, this.fillColor_);
					loc8++;
				}
				loc7++;
			}
		}

		public function getDebugSprite():Sprite {
			var loc3:int = 0;
			var loc4:BitmapData = null;
			var loc5:Bitmap = null;
			var loc1:Sprite = new Sprite();
			var loc2:int = 0;
			while (loc2 < this.maxChunkX_) {
				loc3 = 0;
				while (loc3 < this.maxChunkY_) {
					loc4 = this.chunks_[loc2 + loc3 * this.maxChunkX_];
					loc5 = new Bitmap(loc4);
					loc5.x = loc2 * CHUNK_SIZE;
					loc5.y = loc3 * CHUNK_SIZE;
					loc1.addChild(loc5);
					loc3++;
				}
				loc2++;
			}
			return loc1;
		}
	}
}
