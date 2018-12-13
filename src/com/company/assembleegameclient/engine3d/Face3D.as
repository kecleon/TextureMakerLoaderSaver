package com.company.assembleegameclient.engine3d {
	import com.company.assembleegameclient.map.Camera;
	import com.company.assembleegameclient.util.TextureRedrawer;
	import com.company.util.GraphicsUtil;
	import com.company.util.Triangle;

	import flash.display.BitmapData;
	import flash.display.GraphicsBitmapFill;
	import flash.display.GraphicsPath;
	import flash.display.GraphicsPathCommand;
	import flash.display.GraphicsSolidFill;
	import flash.display.IGraphicsData;
	import flash.geom.Utils3D;
	import flash.geom.Vector3D;

	public class Face3D {

		private static const blackOutFill_:GraphicsSolidFill = new GraphicsSolidFill(0, 1);


		public var origTexture_:BitmapData;

		public var vin_:Vector.<Number>;

		public var uvt_:Vector.<Number>;

		public var vout_:Vector.<Number>;

		public var backfaceCull_:Boolean;

		public var shade_:Number = 1.0;

		public var blackOut_:Boolean = false;

		private var needGen_:Boolean = true;

		private var textureMatrix_:TextureMatrix = null;

		public var bitmapFill_:GraphicsBitmapFill;

		private var path_:GraphicsPath;

		public function Face3D(param1:BitmapData, param2:Vector.<Number>, param3:Vector.<Number>, param4:Boolean = false, param5:Boolean = false) {
			var loc7:Vector3D = null;
			this.vout_ = new Vector.<Number>();
			this.bitmapFill_ = new GraphicsBitmapFill(null, null, false, false);
			this.path_ = new GraphicsPath(new Vector.<int>(), null);
			super();
			this.origTexture_ = param1;
			this.vin_ = param2;
			this.uvt_ = param3;
			this.backfaceCull_ = param4;
			if (param5) {
				loc7 = new Vector3D();
				Plane3D.computeNormalVec(param2, loc7);
				this.shade_ = Lighting3D.shadeValue(loc7, 0.75);
			}
			this.path_.commands.push(GraphicsPathCommand.MOVE_TO);
			var loc6:int = 3;
			while (loc6 < this.vin_.length) {
				this.path_.commands.push(GraphicsPathCommand.LINE_TO);
				loc6 = loc6 + 3;
			}
			this.path_.data = this.vout_;
		}

		public function dispose():void {
			this.origTexture_ = null;
			this.vin_ = null;
			this.uvt_ = null;
			this.vout_ = null;
			this.textureMatrix_ = null;
			this.bitmapFill_ = null;
			this.path_.commands = null;
			this.path_.data = null;
			this.path_ = null;
		}

		public function setTexture(param1:BitmapData):void {
			if (this.origTexture_ == param1) {
				return;
			}
			this.origTexture_ = param1;
			this.needGen_ = true;
		}

		public function setUVT(param1:Vector.<Number>):void {
			this.uvt_ = param1;
			this.needGen_ = true;
		}

		public function maxY():Number {
			var loc1:Number = -Number.MAX_VALUE;
			var loc2:int = this.vout_.length;
			var loc3:int = 0;
			while (loc3 < loc2) {
				if (this.vout_[loc3 + 1] > loc1) {
					loc1 = this.vout_[loc3 + 1];
				}
				loc3 = loc3 + 2;
			}
			return loc1;
		}

		public function draw(param1:Vector.<IGraphicsData>, param2:Camera):Boolean {
			var loc10:Vector.<Number> = null;
			var loc11:Number = NaN;
			var loc12:Number = NaN;
			var loc13:Number = NaN;
			var loc14:Number = NaN;
			var loc15:int = 0;
			Utils3D.projectVectors(param2.wToS_, this.vin_, this.vout_, this.uvt_);
			if (this.backfaceCull_) {
				loc10 = this.vout_;
				loc11 = loc10[2] - loc10[0];
				loc12 = loc10[3] - loc10[1];
				loc13 = loc10[4] - loc10[0];
				loc14 = loc10[5] - loc10[1];
				if (loc11 * loc14 - loc12 * loc13 > 0) {
					return false;
				}
			}
			var loc3:Number = param2.clipRect_.x - 10;
			var loc4:Number = param2.clipRect_.y - 10;
			var loc5:Number = param2.clipRect_.right + 10;
			var loc6:Number = param2.clipRect_.bottom + 10;
			var loc7:Boolean = true;
			var loc8:int = this.vout_.length;
			var loc9:int = 0;
			while (loc9 < loc8) {
				loc15 = loc9 + 1;
				if (this.vout_[loc9] >= loc3 && this.vout_[loc9] <= loc5 && this.vout_[loc15] >= loc4 && this.vout_[loc15] <= loc6) {
					loc7 = false;
					break;
				}
				loc9 = loc9 + 2;
			}
			if (loc7) {
				return false;
			}
			if (this.blackOut_) {
				param1.push(blackOutFill_);
				param1.push(this.path_);
				param1.push(GraphicsUtil.END_FILL);
				return true;
			}
			if (this.needGen_) {
				this.generateTextureMatrix();
			}
			this.textureMatrix_.calculateTextureMatrix(this.vout_);
			this.bitmapFill_.bitmapData = this.textureMatrix_.texture_;
			this.bitmapFill_.matrix = this.textureMatrix_.tToS_;
			param1.push(this.bitmapFill_);
			param1.push(this.path_);
			param1.push(GraphicsUtil.END_FILL);
			return true;
		}

		public function contains(param1:Number, param2:Number):Boolean {
			if (Triangle.containsXY(this.vout_[0], this.vout_[1], this.vout_[2], this.vout_[3], this.vout_[4], this.vout_[5], param1, param2)) {
				return true;
			}
			if (this.vout_.length == 8 && Triangle.containsXY(this.vout_[0], this.vout_[1], this.vout_[4], this.vout_[5], this.vout_[6], this.vout_[7], param1, param2)) {
				return true;
			}
			return false;
		}

		private function generateTextureMatrix():void {
			var loc1:BitmapData = TextureRedrawer.redrawFace(this.origTexture_, this.shade_);
			if (this.textureMatrix_ == null) {
				this.textureMatrix_ = new TextureMatrix(loc1, this.uvt_);
			} else {
				this.textureMatrix_.texture_ = loc1;
				this.textureMatrix_.calculateUVMatrix(this.uvt_);
			}
			this.needGen_ = false;
		}
	}
}
