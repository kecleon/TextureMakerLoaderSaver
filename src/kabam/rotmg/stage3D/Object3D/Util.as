package kabam.rotmg.stage3D.Object3D {
	import flash.geom.Matrix3D;
	import flash.utils.ByteArray;

	public class Util {


		public function Util() {
			super();
		}

		public static function perspectiveProjection(param1:Number = 90, param2:Number = 1, param3:Number = 1, param4:Number = 2048):Matrix3D {
			var loc5:Number = param3 * Math.tan(param1 * Math.PI / 360);
			var loc6:Number = -loc5;
			var loc7:Number = loc6 * param2;
			var loc8:Number = loc5 * param2;
			var loc9:Number = 2 * param3 / (loc8 - loc7);
			var loc10:Number = 2 * param3 / (loc5 - loc6);
			var loc11:Number = (loc8 + loc7) / (loc8 - loc7);
			var loc12:Number = (loc5 + loc6) / (loc5 - loc6);
			var loc13:Number = -(param4 + param3) / (param4 - param3);
			var loc14:Number = -2 * (param4 * param3) / (param4 - param3);
			return new Matrix3D(Vector.<Number>([loc9, 0, 0, 0, 0, loc10, 0, 0, loc11, loc12, loc13, -1, 0, 0, loc14, 0]));
		}

		public static function readString(param1:ByteArray, param2:int):String {
			var loc5:uint = 0;
			var loc3:String = "";
			var loc4:int = 0;
			while (loc4 < param2) {
				loc5 = param1.readUnsignedByte();
				if (loc5 === 0) {
					param1.position = param1.position + Math.max(0, param2 - (loc4 + 1));
					break;
				}
				loc3 = loc3 + String.fromCharCode(loc5);
				loc4++;
			}
			return loc3;
		}

		public static function upperPowerOfTwo(param1:uint):uint {
			param1--;
			param1 = param1 | param1 >> 1;
			param1 = param1 | param1 >> 2;
			param1 = param1 | param1 >> 4;
			param1 = param1 | param1 >> 8;
			param1 = param1 | param1 >> 16;
			param1++;
			return param1;
		}
	}
}
