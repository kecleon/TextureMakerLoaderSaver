package com.company.assembleegameclient.objects.particles {
	import com.company.assembleegameclient.objects.GameObject;
	import com.company.assembleegameclient.util.RandomUtil;

	import flash.geom.Point;

	import kabam.rotmg.messaging.impl.data.WorldPosData;

	public class LightningEffect extends ParticleEffect {


		public var start_:Point;

		public var end_:Point;

		public var color_:int;

		public var particleSize_:int;

		public var lifetimeMultiplier_:Number;

		public function LightningEffect(param1:GameObject, param2:WorldPosData, param3:int, param4:int, param5:Number = 1.0) {
			super();
			this.start_ = new Point(param1.x_, param1.y_);
			this.end_ = new Point(param2.x_, param2.y_);
			this.color_ = param3;
			this.particleSize_ = param4;
			this.lifetimeMultiplier_ = param5;
		}

		override public function runNormalRendering(param1:int, param2:int):Boolean {
			var loc6:Point = null;
			var loc7:Particle = null;
			var loc8:Number = NaN;
			x_ = this.start_.x;
			y_ = this.start_.y;
			var loc3:Number = Point.distance(this.start_, this.end_);
			var loc4:int = loc3 * 3;
			var loc5:int = 0;
			while (loc5 < loc4) {
				loc6 = Point.interpolate(this.start_, this.end_, loc5 / loc4);
				loc7 = new SparkParticle(this.particleSize_, this.color_, 1000 * this.lifetimeMultiplier_ - loc5 / loc4 * 900 * this.lifetimeMultiplier_, 0.5, 0, 0);
				loc8 = Math.min(loc5, loc4 - loc5);
				map_.addObj(loc7, loc6.x + RandomUtil.plusMinus(loc3 / 200 * loc8), loc6.y + RandomUtil.plusMinus(loc3 / 200 * loc8));
				loc5++;
			}
			return false;
		}

		override public function runEasyRendering(param1:int, param2:int):Boolean {
			var loc6:Point = null;
			var loc7:Particle = null;
			var loc8:Number = NaN;
			x_ = this.start_.x;
			y_ = this.start_.y;
			var loc3:Number = Point.distance(this.start_, this.end_);
			var loc4:int = loc3 * 2;
			this.particleSize_ = 80;
			var loc5:int = 0;
			while (loc5 < loc4) {
				loc6 = Point.interpolate(this.start_, this.end_, loc5 / loc4);
				loc7 = new SparkParticle(this.particleSize_, this.color_, 750 * this.lifetimeMultiplier_ - loc5 / loc4 * 675 * this.lifetimeMultiplier_, 0.5, 0, 0);
				loc8 = Math.min(loc5, loc4 - loc5);
				map_.addObj(loc7, loc6.x + RandomUtil.plusMinus(loc3 / 200 * loc8), loc6.y + RandomUtil.plusMinus(loc3 / 200 * loc8));
				loc5++;
			}
			return false;
		}
	}
}
