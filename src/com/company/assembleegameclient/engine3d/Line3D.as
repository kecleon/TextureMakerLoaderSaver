 
package com.company.assembleegameclient.engine3d {
	import flash.geom.Vector3D;
	
	public class Line3D {
		 
		
		public var v0_:Vector3D;
		
		public var v1_:Vector3D;
		
		public function Line3D(param1:Vector3D, param2:Vector3D) {
			super();
			this.v0_ = param1;
			this.v1_ = param2;
		}
		
		public static function unitTest() : Boolean {
			return UnitTest.run();
		}
		
		public function crossZ(param1:Line3D) : int {
			var loc2:Number = (param1.v1_.y - param1.v0_.y) * (this.v1_.x - this.v0_.x) - (param1.v1_.x - param1.v0_.x) * (this.v1_.y - this.v0_.y);
			if(loc2 < 0.001 && loc2 > -0.001) {
				return Order.NEITHER;
			}
			var loc3:Number = (param1.v1_.x - param1.v0_.x) * (this.v0_.y - param1.v0_.y) - (param1.v1_.y - param1.v0_.y) * (this.v0_.x - param1.v0_.x);
			var loc4:Number = (this.v1_.x - this.v0_.x) * (this.v0_.y - param1.v0_.y) - (this.v1_.y - this.v0_.y) * (this.v0_.x - param1.v0_.x);
			if(loc3 < 0.001 && loc3 > -0.001 && loc4 < 0.001 && loc4 > -0.001) {
				return Order.NEITHER;
			}
			var loc5:Number = loc3 / loc2;
			var loc6:Number = loc4 / loc2;
			if(loc5 > 1 || loc5 < 0 || loc6 > 1 || loc6 < 0) {
				return Order.NEITHER;
			}
			var loc7:Number = this.v0_.z + loc5 * (this.v1_.z - this.v0_.z) - (param1.v0_.z + loc6 * (param1.v1_.z - param1.v0_.z));
			if(loc7 < 0.001 && loc7 > -0.001) {
				return Order.NEITHER;
			}
			if(loc7 > 0) {
				return Order.IN_FRONT;
			}
			return Order.BEHIND;
		}
		
		public function lerp(param1:Number) : Vector3D {
			return new Vector3D(this.v0_.x + (this.v1_.x - this.v0_.x) * param1,this.v0_.y + (this.v1_.y - this.v0_.y) * param1,this.v0_.z + (this.v1_.z - this.v0_.z) * param1);
		}
		
		public function toString() : String {
			return "(" + this.v0_ + ", " + this.v1_ + ")";
		}
	}
}

import com.company.assembleegameclient.engine3d.Line3D;
import com.company.assembleegameclient.engine3d.Order;
import flash.geom.Vector3D;

class UnitTest{
	 
	
	function UnitTest() {
		super();
	}
	
	private static function testCrossZ() : Boolean {
		var loc1:Line3D = new Line3D(new Vector3D(0,0,0),new Vector3D(0,100,0));
		var loc2:Line3D = new Line3D(new Vector3D(10,0,10),new Vector3D(-10,100,-100));
		if(loc1.crossZ(loc2) != Order.IN_FRONT) {
			return false;
		}
		if(loc2.crossZ(loc1) != Order.BEHIND) {
			return false;
		}
		loc1 = new Line3D(new Vector3D(1,1,200),new Vector3D(6,6,200));
		loc2 = new Line3D(new Vector3D(3,1,-100),new Vector3D(1,3,-100));
		if(loc1.crossZ(loc2) != Order.IN_FRONT) {
			return false;
		}
		if(loc2.crossZ(loc1) != Order.BEHIND) {
			return false;
		}
		return true;
	}
	
	public static function run() : Boolean {
		if(!testCrossZ()) {
			return false;
		}
		return true;
	}
}
