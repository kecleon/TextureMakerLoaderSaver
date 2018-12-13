 
package com.company.assembleegameclient.engine3d {
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	
	public class TextureMatrix {
		 
		
		public var texture_:BitmapData = null;
		
		public var tToS_:Matrix;
		
		private var uvMatrix_:Matrix = null;
		
		private var tempMatrix_:Matrix;
		
		public function TextureMatrix(param1:BitmapData, param2:Vector.<Number>) {
			this.tToS_ = new Matrix();
			this.tempMatrix_ = new Matrix();
			super();
			this.texture_ = param1;
			this.calculateUVMatrix(param2);
		}
		
		public function setUVT(param1:Vector.<Number>) : void {
			this.calculateUVMatrix(param1);
		}
		
		public function setVOut(param1:Vector.<Number>) : void {
			this.calculateTextureMatrix(param1);
		}
		
		public function calculateTextureMatrix(param1:Vector.<Number>) : void {
			this.tToS_.a = this.uvMatrix_.a;
			this.tToS_.b = this.uvMatrix_.b;
			this.tToS_.c = this.uvMatrix_.c;
			this.tToS_.d = this.uvMatrix_.d;
			this.tToS_.tx = this.uvMatrix_.tx;
			this.tToS_.ty = this.uvMatrix_.ty;
			var loc2:int = param1.length - 2;
			var loc3:int = loc2 + 1;
			this.tempMatrix_.a = param1[2] - param1[0];
			this.tempMatrix_.b = param1[3] - param1[1];
			this.tempMatrix_.c = param1[loc2] - param1[0];
			this.tempMatrix_.d = param1[loc3] - param1[1];
			this.tempMatrix_.tx = param1[0];
			this.tempMatrix_.ty = param1[1];
			this.tToS_.concat(this.tempMatrix_);
		}
		
		public function calculateUVMatrix(param1:Vector.<Number>) : void {
			if(this.texture_ == null) {
				this.uvMatrix_ = null;
				return;
			}
			var loc2:int = param1.length - 3;
			var loc3:Number = param1[0] * this.texture_.width;
			var loc4:Number = param1[1] * this.texture_.height;
			var loc5:Number = param1[3] * this.texture_.width;
			var loc6:Number = param1[4] * this.texture_.height;
			var loc7:Number = param1[loc2] * this.texture_.width;
			var loc8:Number = param1[loc2 + 1] * this.texture_.height;
			var loc9:Number = loc5 - loc3;
			var loc10:Number = loc6 - loc4;
			var loc11:Number = loc7 - loc3;
			var loc12:Number = loc8 - loc4;
			this.uvMatrix_ = new Matrix(loc9,loc10,loc11,loc12,loc3,loc4);
			this.uvMatrix_.invert();
		}
	}
}
