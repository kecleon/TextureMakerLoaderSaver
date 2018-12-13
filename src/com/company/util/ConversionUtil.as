package com.company.util {
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;

	public class ConversionUtil {


		public function ConversionUtil(param1:StaticEnforcer) {
			super();
		}

		public static function toIntArray(param1:Object, param2:String = ","):Array {
			if (param1 == null) {
				return new Array();
			}
			var loc3:Array = param1.toString().split(param2).map(mapParseInt);
			return loc3;
		}

		public static function toNumberArray(param1:Object, param2:String = ","):Array {
			if (param1 == null) {
				return new Array();
			}
			var loc3:Array = param1.toString().split(param2).map(mapParseFloat);
			return loc3;
		}

		public static function toIntVector(param1:Object, param2:String = ","):Vector.<int> {
			if (param1 == null) {
				return new Vector.<int>();
			}
			var loc3:Vector.<int> = Vector.<int>(param1.toString().split(param2).map(mapParseInt));
			return loc3;
		}

		public static function toNumberVector(param1:Object, param2:String = ","):Vector.<Number> {
			if (param1 == null) {
				return new Vector.<Number>();
			}
			var loc3:Vector.<Number> = Vector.<Number>(param1.toString().split(param2).map(mapParseFloat));
			return loc3;
		}

		public static function toStringArray(param1:Object, param2:String = ","):Array {
			if (param1 == null) {
				return new Array();
			}
			var loc3:Array = param1.toString().split(param2);
			return loc3;
		}

		public static function toRectangle(param1:Object, param2:String = ","):Rectangle {
			if (param1 == null) {
				return new Rectangle();
			}
			var loc3:Array = param1.toString().split(param2).map(mapParseFloat);
			return loc3 == null || loc3.length < 4 ? new Rectangle() : new Rectangle(loc3[0], loc3[1], loc3[2], loc3[3]);
		}

		public static function toPoint(param1:Object, param2:String = ","):Point {
			if (param1 == null) {
				return new Point();
			}
			var loc3:Array = param1.toString().split(param2).map(ConversionUtil.mapParseFloat);
			return loc3 == null || loc3.length < 2 ? new Point() : new Point(loc3[0], loc3[1]);
		}

		public static function toPointPair(param1:Object, param2:String = ","):Array {
			var loc3:Array = new Array();
			if (param1 == null) {
				loc3.push(new Point());
				loc3.push(new Point());
				return loc3;
			}
			var loc4:Array = param1.toString().split(param2).map(ConversionUtil.mapParseFloat);
			if (loc4 == null || loc4.length < 4) {
				loc3.push(new Point());
				loc3.push(new Point());
				return loc3;
			}
			loc3.push(new Point(loc4[0], loc4[1]));
			loc3.push(new Point(loc4[2], loc4[3]));
			return loc3;
		}

		public static function toVector3D(param1:Object, param2:String = ","):Vector3D {
			if (param1 == null) {
				return new Vector3D();
			}
			var loc3:Array = param1.toString().split(param2).map(ConversionUtil.mapParseFloat);
			return loc3 == null || loc3.length < 3 ? new Vector3D() : new Vector3D(loc3[0], loc3[1], loc3[2]);
		}

		public static function toCharCodesVector(param1:Object, param2:String = ","):Vector.<int> {
			if (param1 == null) {
				return new Vector.<int>();
			}
			var loc3:Vector.<int> = Vector.<int>(param1.toString().split(param2).map(mapParseCharCode));
			return loc3;
		}

		public static function addToNumberVector(param1:Object, param2:Vector.<Number>, param3:String = ","):void {
			var loc5:Number = NaN;
			if (param1 == null) {
				return;
			}
			var loc4:Array = param1.toString().split(param3).map(mapParseFloat);
			for each(loc5 in loc4) {
				param2.push(loc5);
			}
		}

		public static function addToIntVector(param1:Object, param2:Vector.<int>, param3:String = ","):void {
			var loc5:int = 0;
			if (param1 == null) {
				return;
			}
			var loc4:Array = param1.toString().split(param3).map(mapParseFloat);
			for each(loc5 in loc4) {
				param2.push(loc5);
			}
		}

		public static function mapParseFloat(param1:*, ...rest):Number {
			return parseFloat(param1);
		}

		public static function mapParseInt(param1:*, ...rest):Number {
			return parseInt(param1);
		}

		public static function mapParseCharCode(param1:*, ...rest):Number {
			return String(param1).charCodeAt();
		}

		public static function vector3DToShaderParameter(param1:Vector3D):Array {
			return [param1.x, param1.y, param1.z];
		}
	}
}

class StaticEnforcer {


	function StaticEnforcer() {
		super();
	}
}
