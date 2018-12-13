package com.company.assembleegameclient.objects {
	import com.company.assembleegameclient.engine3d.Face3D;
	import com.company.assembleegameclient.map.Camera;
	import com.company.assembleegameclient.map.Square;
	import com.company.util.BitmapUtil;

	import flash.display.BitmapData;
	import flash.display.IGraphicsData;

	public class DoubleWall extends GameObject {

		private static const UVT:Vector.<Number> = new <Number>[0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 1, 0];

		private static const UVTHEIGHT:Vector.<Number> = new <Number>[0, 0, 0, 1, 0, 0, 1, 2, 0, 0, 2, 0];

		private static const sqX:Vector.<int> = new <int>[0, 1, 0, -1];

		private static const sqY:Vector.<int> = new <int>[-1, 0, 1, 0];


		public var faces_:Vector.<Face3D>;

		private var topFace_:Face3D = null;

		private var topTexture_:BitmapData = null;

		public function DoubleWall(param1:XML) {
			this.faces_ = new Vector.<Face3D>();
			super(param1);
			hasShadow_ = false;
			var loc2:TextureData = ObjectLibrary.typeToTopTextureData_[objectType_];
			this.topTexture_ = loc2.getTexture(0);
		}

		override public function setObjectId(param1:int):void {
			super.setObjectId(param1);
			var loc2:TextureData = ObjectLibrary.typeToTopTextureData_[objectType_];
			this.topTexture_ = loc2.getTexture(param1);
		}

		override public function getColor():uint {
			return BitmapUtil.mostCommonColor(this.topTexture_);
		}

		override public function draw(param1:Vector.<IGraphicsData>, param2:Camera, param3:int):void {
			var loc6:BitmapData = null;
			var loc7:Face3D = null;
			var loc8:Square = null;
			if (texture_ == null) {
				return;
			}
			if (this.faces_.length == 0) {
				this.rebuild3D();
			}
			var loc4:BitmapData = texture_;
			if (animations_ != null) {
				loc6 = animations_.getTexture(param3);
				if (loc6 != null) {
					loc4 = loc6;
				}
			}
			var loc5:int = 0;
			while (loc5 < this.faces_.length) {
				loc7 = this.faces_[loc5];
				loc8 = map_.lookupSquare(x_ + sqX[loc5], y_ + sqY[loc5]);
				if (loc8 == null || loc8.texture_ == null || loc8 != null && loc8.obj_ is DoubleWall && !loc8.obj_.dead_) {
					loc7.blackOut_ = true;
				} else {
					loc7.blackOut_ = false;
					if (animations_ != null) {
						loc7.setTexture(loc4);
					}
				}
				loc7.draw(param1, param2);
				loc5++;
			}
			this.topFace_.draw(param1, param2);
		}

		public function rebuild3D():void {
			this.faces_.length = 0;
			var loc1:int = x_;
			var loc2:int = y_;
			var loc3:Vector.<Number> = new <Number>[loc1, loc2, 2, loc1 + 1, loc2, 2, loc1 + 1, loc2 + 1, 2, loc1, loc2 + 1, 2];
			this.topFace_ = new Face3D(this.topTexture_, loc3, UVT, false, true);
			this.topFace_.bitmapFill_.repeat = true;
			this.addWall(loc1, loc2, 2, loc1 + 1, loc2, 2);
			this.addWall(loc1 + 1, loc2, 2, loc1 + 1, loc2 + 1, 2);
			this.addWall(loc1 + 1, loc2 + 1, 2, loc1, loc2 + 1, 2);
			this.addWall(loc1, loc2 + 1, 2, loc1, loc2, 2);
		}

		private function addWall(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number):void {
			var loc7:Vector.<Number> = new <Number>[param1, param2, param3, param4, param5, param6, param4, param5, param6 - 2, param1, param2, param3 - 2];
			var loc8:Face3D = new Face3D(texture_, loc7, UVTHEIGHT, true, true);
			loc8.bitmapFill_.repeat = true;
			this.faces_.push(loc8);
		}
	}
}
