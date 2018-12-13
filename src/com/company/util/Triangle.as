package com.company.util {
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class Triangle {


		public var x0_:Number;

		public var y0_:Number;

		public var x1_:Number;

		public var y1_:Number;

		public var x2_:Number;

		public var y2_:Number;

		public var vx1_:Number;

		public var vy1_:Number;

		public var vx2_:Number;

		public var vy2_:Number;

		public function Triangle(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) {
			super();
			this.x0_ = param1;
			this.y0_ = param2;
			this.x1_ = param3;
			this.y1_ = param4;
			this.x2_ = param5;
			this.y2_ = param6;
			this.vx1_ = this.x1_ - this.x0_;
			this.vy1_ = this.y1_ - this.y0_;
			this.vx2_ = this.x2_ - this.x0_;
			this.vy2_ = this.y2_ - this.y0_;
		}

		public static function containsXY(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number):Boolean {
			var loc9:Number = param3 - param1;
			var loc10:Number = param4 - param2;
			var loc11:Number = param5 - param1;
			var loc12:Number = param6 - param2;
			var loc13:Number = (param7 * loc12 - param8 * loc11 - (param1 * loc12 - param2 * loc11)) / (loc9 * loc12 - loc10 * loc11);
			var loc14:Number = -(param7 * loc10 - param8 * loc9 - (param1 * loc10 - param2 * loc9)) / (loc9 * loc12 - loc10 * loc11);
			return loc13 >= 0 && loc14 >= 0 && loc13 + loc14 <= 1;
		}

		public static function intersectTriAABB(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number, param10:Number):Boolean {
			if (param7 > param1 && param7 > param3 && param7 > param5 || param9 < param1 && param9 < param3 && param9 < param5 || param8 > param2 && param8 > param4 && param8 > param6 || param10 < param2 && param10 < param4 && param10 < param6) {
				return false;
			}
			if (param7 < param1 && param1 < param9 && param8 < param2 && param2 < param10 || param7 < param3 && param3 < param9 && param8 < param4 && param4 < param10 || param7 < param5 && param5 < param9 && param8 < param6 && param6 < param10) {
				return true;
			}
			return lineRectIntersect(param1, param2, param3, param4, param7, param8, param9, param10) || lineRectIntersect(param3, param4, param5, param6, param7, param8, param9, param10) || lineRectIntersect(param5, param6, param1, param2, param7, param8, param9, param10);
		}

		private static function lineRectIntersect(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number):Boolean {
			var loc11:Number = NaN;
			var loc12:Number = NaN;
			var loc13:Number = NaN;
			var loc14:Number = NaN;
			var loc9:Number = (param4 - param2) / (param3 - param1);
			var loc10:Number = param2 - loc9 * param1;
			if (loc9 > 0) {
				loc11 = loc9 * param5 + loc10;
				loc12 = loc9 * param7 + loc10;
			} else {
				loc11 = loc9 * param7 + loc10;
				loc12 = loc9 * param5 + loc10;
			}
			if (param2 < param4) {
				loc13 = param2;
				loc14 = param4;
			} else {
				loc13 = param4;
				loc14 = param2;
			}
			var loc15:Number = loc11 > loc13 ? Number(loc11) : Number(loc13);
			var loc16:Number = loc12 < loc14 ? Number(loc12) : Number(loc14);
			return loc15 < loc16 && !(loc16 < param6 || loc15 > param8);
		}

		public function aabb():Rectangle {
			var loc1:Number = Math.min(this.x0_, this.x1_, this.x2_);
			var loc2:Number = Math.max(this.x0_, this.x1_, this.x2_);
			var loc3:Number = Math.min(this.y0_, this.y1_, this.y2_);
			var loc4:Number = Math.max(this.y0_, this.y1_, this.y2_);
			return new Rectangle(loc1, loc3, loc2 - loc1, loc4 - loc3);
		}

		public function area():Number {
			return Math.abs((this.x0_ * (this.y1_ - this.y2_) + this.x1_ * (this.y2_ - this.y0_) + this.x2_ * (this.y0_ - this.y1_)) / 2);
		}

		public function incenter(param1:Point):void {
			var loc2:Number = PointUtil.distanceXY(this.x1_, this.y1_, this.x2_, this.y2_);
			var loc3:Number = PointUtil.distanceXY(this.x0_, this.y0_, this.x2_, this.y2_);
			var loc4:Number = PointUtil.distanceXY(this.x0_, this.y0_, this.x1_, this.y1_);
			param1.x = (loc2 * this.x0_ + loc3 * this.x1_ + loc4 * this.x2_) / (loc2 + loc3 + loc4);
			param1.y = (loc2 * this.y0_ + loc3 * this.y1_ + loc4 * this.y2_) / (loc2 + loc3 + loc4);
		}

		public function contains(param1:Number, param2:Number):Boolean {
			var loc3:Number = (param1 * this.vy2_ - param2 * this.vx2_ - (this.x0_ * this.vy2_ - this.y0_ * this.vx2_)) / (this.vx1_ * this.vy2_ - this.vy1_ * this.vx2_);
			var loc4:Number = -(param1 * this.vy1_ - param2 * this.vx1_ - (this.x0_ * this.vy1_ - this.y0_ * this.vx1_)) / (this.vx1_ * this.vy2_ - this.vy1_ * this.vx2_);
			return loc3 >= 0 && loc4 >= 0 && loc3 + loc4 <= 1;
		}

		public function distance(param1:Number, param2:Number):Number {
			if (this.contains(param1, param2)) {
				return 0;
			}
			return Math.min(LineSegmentUtil.pointDistance(param1, param2, this.x0_, this.y0_, this.x1_, this.y1_), LineSegmentUtil.pointDistance(param1, param2, this.x1_, this.y1_, this.x2_, this.y2_), LineSegmentUtil.pointDistance(param1, param2, this.x0_, this.y0_, this.x2_, this.y2_));
		}

		public function intersectAABB(param1:Number, param2:Number, param3:Number, param4:Number):Boolean {
			return intersectTriAABB(this.x0_, this.y0_, this.x1_, this.y1_, this.x2_, this.y2_, param1, param2, param3, param4);
		}
	}
}
