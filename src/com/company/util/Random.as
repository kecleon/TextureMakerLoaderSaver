package com.company.util {
	public class Random {


		public var seed:uint;

		public function Random(param1:uint = 1) {
			super();
			this.seed = param1;
		}

		public static function randomSeed():uint {
			return Math.round(Math.random() * (uint.MAX_VALUE - 1) + 1);
		}

		public function nextInt():uint {
			return this.gen();
		}

		public function nextDouble():Number {
			return this.gen() / 2147483647;
		}

		public function nextNormal(param1:Number = 0.0, param2:Number = 1.0):Number {
			var loc3:Number = this.gen() / 2147483647;
			var loc4:Number = this.gen() / 2147483647;
			var loc5:Number = Math.sqrt(-2 * Math.log(loc3)) * Math.cos(2 * loc4 * Math.PI);
			return param1 + loc5 * param2;
		}

		public function nextIntRange(param1:uint, param2:uint):uint {
			return param1 == param2 ? uint(param1) : uint(param1 + this.gen() % (param2 - param1));
		}

		public function nextDoubleRange(param1:Number, param2:Number):Number {
			return param1 + (param2 - param1) * this.nextDouble();
		}

		private function gen():uint {
			var loc1:uint = 0;
			var loc2:uint = 0;
			loc2 = 16807 * (this.seed & 65535);
			loc1 = 16807 * (this.seed >> 16);
			loc2 = loc2 + ((loc1 & 32767) << 16);
			loc2 = loc2 + (loc1 >> 15);
			if (loc2 > 2147483647) {
				loc2 = loc2 - 2147483647;
			}
			return this.seed = loc2;
		}
	}
}
