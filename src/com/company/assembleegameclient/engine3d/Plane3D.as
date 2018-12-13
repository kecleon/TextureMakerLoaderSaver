 
package com.company.assembleegameclient.engine3d {
	import flash.geom.Vector3D;
	
	public class Plane3D {
		
		public static const NONE:int = 0;
		
		public static const POSITIVE:int = 1;
		
		public static const NEGATIVE:int = 2;
		
		public static const EQUAL:int = 3;
		 
		
		public var normal_:Vector3D;
		
		public var d_:Number;
		
		public function Plane3D(param1:Vector3D = null, param2:Vector3D = null, param3:Vector3D = null) {
			super();
			if(param1 != null && param2 != null && param3 != null) {
				this.normal_ = new Vector3D();
				computeNormal(param1,param2,param3,this.normal_);
				this.d_ = -this.normal_.dotProduct(param1);
			}
		}
		
		public static function computeNormal(param1:Vector3D, param2:Vector3D, param3:Vector3D, param4:Vector3D) : void {
			var loc5:Number = param2.x - param1.x;
			var loc6:Number = param2.y - param1.y;
			var loc7:Number = param2.z - param1.z;
			var loc8:Number = param3.x - param1.x;
			var loc9:Number = param3.y - param1.y;
			var loc10:Number = param3.z - param1.z;
			param4.x = loc6 * loc10 - loc7 * loc9;
			param4.y = loc7 * loc8 - loc5 * loc10;
			param4.z = loc5 * loc9 - loc6 * loc8;
			param4.normalize();
		}
		
		public static function computeNormalVec(param1:Vector.<Number>, param2:Vector3D) : void {
			var loc3:Number = param1[3] - param1[0];
			var loc4:Number = param1[4] - param1[1];
			var loc5:Number = param1[5] - param1[2];
			var loc6:Number = param1[6] - param1[0];
			var loc7:Number = param1[7] - param1[1];
			var loc8:Number = param1[8] - param1[2];
			param2.x = loc4 * loc8 - loc5 * loc7;
			param2.y = loc5 * loc6 - loc3 * loc8;
			param2.z = loc3 * loc7 - loc4 * loc6;
			param2.normalize();
		}
		
		public function testPoint(param1:Vector3D) : int {
			var loc2:Number = this.normal_.dotProduct(param1) + this.d_;
			if(loc2 > 0.001) {
				return POSITIVE;
			}
			if(loc2 < -0.001) {
				return NEGATIVE;
			}
			return EQUAL;
		}
		
		public function lineIntersect(param1:Line3D) : Number {
			var loc2:Number = -this.d_ - this.normal_.x * param1.v0_.x - this.normal_.y * param1.v0_.y - this.normal_.z * param1.v0_.z;
			var loc3:Number = this.normal_.x * (param1.v1_.x - param1.v0_.x) + this.normal_.y * (param1.v1_.y - param1.v0_.y) + this.normal_.z * (param1.v1_.z - param1.v0_.z);
			if(loc3 == 0) {
				return NaN;
			}
			return loc2 / loc3;
		}
		
		public function zAtXY(param1:Number, param2:Number) : Number {
			return -(this.d_ + this.normal_.x * param1 + this.normal_.y * param2) / this.normal_.z;
		}
		
		public function toString() : String {
			return "Plane(n = " + this.normal_ + ", d = " + this.d_ + ")";
		}
	}
}
