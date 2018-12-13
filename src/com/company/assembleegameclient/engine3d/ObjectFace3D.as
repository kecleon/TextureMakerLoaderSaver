 
package com.company.assembleegameclient.engine3d {
	import com.company.assembleegameclient.parameters.Parameters;
	import com.company.assembleegameclient.util.TextureRedrawer;
	import com.company.util.GraphicsUtil;
	import com.company.util.MoreColorUtil;
	import flash.display.BitmapData;
	import flash.display.GraphicsBitmapFill;
	import flash.display.GraphicsPath;
	import flash.display.GraphicsPathCommand;
	import flash.display.GraphicsSolidFill;
	import flash.display.IGraphicsData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Vector3D;
	import kabam.rotmg.stage3D.GraphicsFillExtra;
	
	public class ObjectFace3D {
		
		public static const blackBitmap:BitmapData = new BitmapData(1,1,true,4278190080);
		 
		
		public var obj_:Object3D;
		
		public var indices_:Vector.<int>;
		
		public var useTexture_:Boolean;
		
		public var softwareException_:Boolean = false;
		
		public var texture_:BitmapData = null;
		
		public var normalL_:Vector3D = null;
		
		public var normalW_:Vector3D;
		
		public var shade_:Number = 1.0;
		
		private var path_:GraphicsPath;
		
		private var solidFill_:GraphicsSolidFill;
		
		public const bitmapFill_:GraphicsBitmapFill = new GraphicsBitmapFill();
		
		private var tToS_:Matrix;
		
		private var tempMatrix_:Matrix;
		
		public function ObjectFace3D(param1:Object3D, param2:Vector.<int>, param3:Boolean = true) {
			this.solidFill_ = new GraphicsSolidFill(16777215,1);
			this.tToS_ = new Matrix();
			this.tempMatrix_ = new Matrix();
			super();
			this.obj_ = param1;
			this.indices_ = param2;
			this.useTexture_ = param3;
			var loc4:Vector.<int> = new Vector.<int>();
			var loc5:int = 0;
			while(loc5 < this.indices_.length) {
				loc4.push(loc5 == 0?GraphicsPathCommand.MOVE_TO:GraphicsPathCommand.LINE_TO);
				loc5++;
			}
			var loc6:Vector.<Number> = new Vector.<Number>();
			loc6.length = this.indices_.length * 2;
			this.path_ = new GraphicsPath(loc4,loc6);
		}
		
		public function dispose() : void {
			this.indices_ = null;
			this.path_.commands = null;
			this.path_.data = null;
			this.path_ = null;
		}
		
		public function computeLighting() : void {
			this.normalW_ = new Vector3D();
			Plane3D.computeNormal(this.obj_.getVecW(this.indices_[0]),this.obj_.getVecW(this.indices_[1]),this.obj_.getVecW(this.indices_[this.indices_.length - 1]),this.normalW_);
			this.shade_ = Lighting3D.shadeValue(this.normalW_,0.75);
			if(this.normalL_ != null) {
				this.normalW_ = this.obj_.lToW_.deltaTransformVector(this.normalL_);
			}
		}
		
		public function draw(param1:Vector.<IGraphicsData>, param2:uint, param3:BitmapData) : void {
			var loc13:int = 0;
			var loc4:int = this.indices_[0] * 2;
			var loc5:int = this.indices_[1] * 2;
			var loc6:int = this.indices_[this.indices_.length - 1] * 2;
			var loc7:Vector.<Number> = this.obj_.vS_;
			var loc8:Number = loc7[loc5] - loc7[loc4];
			var loc9:Number = loc7[loc5 + 1] - loc7[loc4 + 1];
			var loc10:Number = loc7[loc6] - loc7[loc4];
			var loc11:Number = loc7[loc6 + 1] - loc7[loc4 + 1];
			if(loc8 * loc11 - loc9 * loc10 < 0) {
				return;
			}
			if(!Parameters.data_.GPURender && (!this.useTexture_ || param3 == null)) {
				this.solidFill_.color = MoreColorUtil.transformColor(new ColorTransform(this.shade_,this.shade_,this.shade_),param2);
				param1.push(this.solidFill_);
			} else {
				if(param3 == null && Parameters.data_.GPURender) {
					param3 = blackBitmap;
				} else {
					param3 = TextureRedrawer.redrawFace(param3,this.shade_);
				}
				this.bitmapFill_.bitmapData = param3;
				this.bitmapFill_.matrix = this.tToS(param3);
				param1.push(this.bitmapFill_);
			}
			var loc12:int = 0;
			while(loc12 < this.indices_.length) {
				loc13 = this.indices_[loc12];
				this.path_.data[loc12 * 2] = loc7[loc13 * 2];
				this.path_.data[loc12 * 2 + 1] = loc7[loc13 * 2 + 1];
				loc12++;
			}
			param1.push(this.path_);
			param1.push(GraphicsUtil.END_FILL);
			if(this.softwareException_ && Parameters.isGpuRender() && this.bitmapFill_ != null) {
				GraphicsFillExtra.setSoftwareDraw(this.bitmapFill_,true);
			}
		}
		
		private function tToS(param1:BitmapData) : Matrix {
			var loc2:Vector.<Number> = this.obj_.uvts_;
			var loc3:int = this.indices_[0] * 3;
			var loc4:int = this.indices_[1] * 3;
			var loc5:int = this.indices_[this.indices_.length - 1] * 3;
			var loc6:Number = loc2[loc3] * param1.width;
			var loc7:Number = loc2[loc3 + 1] * param1.height;
			this.tToS_.a = loc2[loc4] * param1.width - loc6;
			this.tToS_.b = loc2[loc4 + 1] * param1.height - loc7;
			this.tToS_.c = loc2[loc5] * param1.width - loc6;
			this.tToS_.d = loc2[loc5 + 1] * param1.height - loc7;
			this.tToS_.tx = loc6;
			this.tToS_.ty = loc7;
			this.tToS_.invert();
			loc3 = this.indices_[0] * 2;
			loc4 = this.indices_[1] * 2;
			loc5 = this.indices_[this.indices_.length - 1] * 2;
			var loc8:Vector.<Number> = this.obj_.vS_;
			this.tempMatrix_.a = loc8[loc4] - loc8[loc3];
			this.tempMatrix_.b = loc8[loc4 + 1] - loc8[loc3 + 1];
			this.tempMatrix_.c = loc8[loc5] - loc8[loc3];
			this.tempMatrix_.d = loc8[loc5 + 1] - loc8[loc3 + 1];
			this.tempMatrix_.tx = loc8[loc3];
			this.tempMatrix_.ty = loc8[loc3 + 1];
			this.tToS_.concat(this.tempMatrix_);
			return this.tToS_;
		}
	}
}
