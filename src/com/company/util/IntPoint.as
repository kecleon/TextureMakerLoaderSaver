package com.company.util {
	import flash.geom.Matrix;
	import flash.geom.Point;

	public class IntPoint {


		public var x_:int;

		public var y_:int;

		public function IntPoint(param1:int = 0, param2:int = 0) {
			super();
			this.x_ = param1;
			this.y_ = param2;
		}

		public static function unitTest():void {
			var loc1:UnitTest = new UnitTest();
		}

		public static function fromPoint(param1:Point):IntPoint {
			return new IntPoint(Math.round(param1.x), Math.round(param1.y));
		}

		public function x():int {
			return this.x_;
		}

		public function y():int {
			return this.y_;
		}

		public function setX(param1:int):void {
			this.x_ = param1;
		}

		public function setY(param1:int):void {
			this.y_ = param1;
		}

		public function clone():IntPoint {
			return new IntPoint(this.x_, this.y_);
		}

		public function same(param1:IntPoint):Boolean {
			return this.x_ == param1.x_ && this.y_ == param1.y_;
		}

		public function distanceAsInt(param1:IntPoint):int {
			var loc2:int = param1.x_ - this.x_;
			var loc3:int = param1.y_ - this.y_;
			return Math.round(Math.sqrt(loc2 * loc2 + loc3 * loc3));
		}

		public function distanceAsNumber(param1:IntPoint):Number {
			var loc2:int = param1.x_ - this.x_;
			var loc3:int = param1.y_ - this.y_;
			return Math.sqrt(loc2 * loc2 + loc3 * loc3);
		}

		public function distanceToPoint(param1:Point):Number {
			var loc2:int = param1.x - this.x_;
			var loc3:int = param1.y - this.y_;
			return Math.sqrt(loc2 * loc2 + loc3 * loc3);
		}

		public function trunc1000():IntPoint {
			return new IntPoint(int(this.x_ / 1000) * 1000, int(this.y_ / 1000) * 1000);
		}

		public function round1000():IntPoint {
			return new IntPoint(Math.round(this.x_ / 1000) * 1000, Math.round(this.y_ / 1000) * 1000);
		}

		public function distanceSquared(param1:IntPoint):int {
			var loc2:int = param1.x() - this.x_;
			var loc3:int = param1.y() - this.y_;
			return loc2 * loc2 + loc3 * loc3;
		}

		public function toPoint():Point {
			return new Point(this.x_, this.y_);
		}

		public function transform(param1:Matrix):IntPoint {
			var loc2:Point = param1.transformPoint(this.toPoint());
			return new IntPoint(Math.round(loc2.x), Math.round(loc2.y));
		}

		public function toString():String {
			return "(" + this.x_ + ", " + this.y_ + ")";
		}
	}
}

import com.company.util.IntPoint;

class UnitTest {


	function UnitTest() {
		var loc1:IntPoint = null;
		var loc2:IntPoint = null;
		var loc3:Number = NaN;
		super();
		trace("STARTING UNITTEST: IntPoint");
		loc1 = new IntPoint(999, 1001);
		loc2 = loc1.round1000();
		if (loc2.x() != 1000 || loc2.y() != 1000) {
			trace("ERROR IN UNITTEST: IntPoint1");
		}
		loc1 = new IntPoint(500, 400);
		loc2 = loc1.round1000();
		if (loc2.x() != 1000 || loc2.y() != 0) {
			trace("ERROR IN UNITTEST: IntPoint2");
		}
		loc1 = new IntPoint(-400, -500);
		loc2 = loc1.round1000();
		if (loc2.x() != 0 || loc2.y() != 0) {
			trace("ERROR IN UNITTEST: IntPoint3");
		}
		loc1 = new IntPoint(-501, -999);
		loc2 = loc1.round1000();
		if (loc2.x() != -1000 || loc2.y() != -1000) {
			trace("ERROR IN UNITTEST: IntPoint4");
		}
		loc1 = new IntPoint(-1000, -1001);
		loc2 = loc1.round1000();
		if (loc2.x() != -1000 || loc2.y() != -1000) {
			trace("ERROR IN UNITTEST: IntPoint5");
		}
		loc1 = new IntPoint(999, 1001);
		loc2 = loc1.trunc1000();
		if (loc2.x() != 0 || loc2.y() != 1000) {
			trace("ERROR IN UNITTEST: IntPoint6");
		}
		loc1 = new IntPoint(500, 400);
		loc2 = loc1.trunc1000();
		if (loc2.x() != 0 || loc2.y() != 0) {
			trace("ERROR IN UNITTEST: IntPoint7");
		}
		loc1 = new IntPoint(-400, -500);
		loc2 = loc1.trunc1000();
		if (loc2.x() != 0 || loc2.y() != 0) {
			trace("ERROR IN UNITTEST: IntPoint8");
		}
		loc1 = new IntPoint(-501, -999);
		loc2 = loc1.trunc1000();
		if (loc2.x() != 0 || loc2.y() != 0) {
			trace("ERROR IN UNITTEST: IntPoint9");
		}
		loc1 = new IntPoint(-1000, -1001);
		loc2 = loc1.trunc1000();
		if (loc2.x() != -1000 || loc2.y() != -1000) {
			trace("ERROR IN UNITTEST: IntPoint10");
		}
		loc3 = 0.9999998;
		if (int(loc3) != 0) {
			trace("ERROR IN UNITTEST: IntPoint40");
		}
		loc3 = 0.5;
		if (int(loc3) != 0) {
			trace("ERROR IN UNITTEST: IntPoint41");
		}
		loc3 = 0.499999;
		if (int(loc3) != 0) {
			trace("ERROR IN UNITTEST: IntPoint42");
		}
		loc3 = -0.499999;
		if (int(loc3) != 0) {
			trace("ERROR IN UNITTEST: IntPoint43");
		}
		loc3 = -0.5;
		if (int(loc3) != 0) {
			trace("ERROR IN UNITTEST: IntPoint44");
		}
		loc3 = -0.99999;
		if (int(loc3) != 0) {
			trace("ERROR IN UNITTEST: IntPoint45");
		}
		trace("FINISHED UNITTEST: IntPoint");
	}
}
