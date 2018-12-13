 
package com.company.assembleegameclient.tutorial {
	import com.company.util.ConversionUtil;
	import com.company.util.PointUtil;
	import flash.display.Graphics;
	import flash.geom.Point;
	
	public class UIDrawArrow {
		 
		
		public var p0_:Point;
		
		public var p1_:Point;
		
		public var color_:uint;
		
		public const ANIMATION_MS:int = 500;
		
		public function UIDrawArrow(param1:XML) {
			super();
			var loc2:Array = ConversionUtil.toPointPair(param1);
			this.p0_ = loc2[0];
			this.p1_ = loc2[1];
			this.color_ = uint(param1.@color);
		}
		
		public function draw(param1:int, param2:Graphics, param3:int) : void {
			var loc6:Point = null;
			var loc4:Point = new Point();
			if(param3 < this.ANIMATION_MS) {
				loc4.x = this.p0_.x + (this.p1_.x - this.p0_.x) * param3 / this.ANIMATION_MS;
				loc4.y = this.p0_.y + (this.p1_.y - this.p0_.y) * param3 / this.ANIMATION_MS;
			} else {
				loc4.x = this.p1_.x;
				loc4.y = this.p1_.y;
			}
			param2.lineStyle(param1,this.color_);
			param2.moveTo(this.p0_.x,this.p0_.y);
			param2.lineTo(loc4.x,loc4.y);
			var loc5:Number = PointUtil.angleTo(loc4,this.p0_);
			loc6 = PointUtil.pointAt(loc4,loc5 + Math.PI / 8,30);
			param2.lineTo(loc6.x,loc6.y);
			loc6 = PointUtil.pointAt(loc4,loc5 - Math.PI / 8,30);
			param2.moveTo(loc4.x,loc4.y);
			param2.lineTo(loc6.x,loc6.y);
		}
	}
}
