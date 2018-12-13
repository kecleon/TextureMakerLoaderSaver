package com.company.assembleegameclient.objects.particles {
	import com.company.assembleegameclient.util.FreeList;

	public class BubbleParticle extends Particle {


		private const SPREAD_DAMPER:Number = 0.0025;

		public var startTime:int;

		public var speed:Number;

		public var spread:Number;

		public var dZ:Number;

		public var life:Number;

		public var lifeVariance:Number;

		public var speedVariance:Number;

		public var timeLeft:Number;

		public var frequencyX:Number;

		public var frequencyY:Number;

		public function BubbleParticle(param1:uint, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) {
			super(param1, 0, 75 + Math.random() * 50);
			this.dZ = param2;
			this.life = param3 * 1000;
			this.lifeVariance = param4;
			this.speedVariance = param5;
			this.spread = param6;
			this.frequencyX = 0;
			this.frequencyY = 0;
		}

		public static function create(param1:*, param2:uint, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number):BubbleParticle {
			var loc8:BubbleParticle = FreeList.getObject(param1) as BubbleParticle;
			if (!loc8) {
				loc8 = new BubbleParticle(param2, param3, param4, param5, param6, param7);
			}
			return loc8;
		}

		public function restart(param1:int, param2:int):void {
			this.startTime = param1;
			var loc3:Number = Math.random();
			this.speed = (this.dZ - this.dZ * (loc3 * (1 - this.speedVariance))) * 10;
			if (this.spread > 0) {
				this.frequencyX = Math.random() * this.spread - 0.1;
				this.frequencyY = Math.random() * this.spread - 0.1;
			}
			var loc4:Number = (param2 - param1) / 1000;
			this.timeLeft = this.life - this.life * (loc3 * (1 - this.lifeVariance));
			z_ = this.speed * loc4;
		}

		override public function removeFromMap():void {
			super.removeFromMap();
		}

		override public function update(param1:int, param2:int):Boolean {
			var loc3:Number = (param1 - this.startTime) / 1000;
			this.timeLeft = this.timeLeft - param2;
			if (this.timeLeft <= 0) {
				return false;
			}
			z_ = this.speed * loc3;
			if (this.spread > 0) {
				moveTo(x_ + this.frequencyX * param2 * this.SPREAD_DAMPER, y_ + this.frequencyY * param2 * this.SPREAD_DAMPER);
			}
			return true;
		}
	}
}
