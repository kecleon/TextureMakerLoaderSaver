package com.company.assembleegameclient.objects.particles {
	import com.company.assembleegameclient.objects.GameObject;

	import flash.geom.Point;

	public class NovaEffect extends ParticleEffect {


		public var start_:Point;

		public var novaRadius_:Number;

		public var color_:int;

		public function NovaEffect(param1:GameObject, param2:Number, param3:int) {
			super();
			this.start_ = new Point(param1.x_, param1.y_);
			this.novaRadius_ = param2;
			this.color_ = param3;
		}

		override public function runNormalRendering(param1:int, param2:int):Boolean {
			var loc7:Number = NaN;
			var loc8:Point = null;
			var loc9:Particle = null;
			x_ = this.start_.x;
			y_ = this.start_.y;
			var loc3:int = 200;
			var loc4:int = 200;
			var loc5:int = 4 + this.novaRadius_ * 2;
			var loc6:int = 0;
			while (loc6 < loc5) {
				loc7 = loc6 * 2 * Math.PI / loc5;
				loc8 = new Point(this.start_.x + this.novaRadius_ * Math.cos(loc7), this.start_.y + this.novaRadius_ * Math.sin(loc7));
				loc9 = new SparkerParticle(loc3, this.color_, loc4, this.start_, loc8);
				map_.addObj(loc9, x_, y_);
				loc6++;
			}
			return false;
		}

		override public function runEasyRendering(param1:int, param2:int):Boolean {
			var loc7:Number = NaN;
			var loc8:Point = null;
			var loc9:Particle = null;
			x_ = this.start_.x;
			y_ = this.start_.y;
			var loc3:int = 10;
			var loc4:int = 200;
			var loc5:int = 0 + this.novaRadius_ * 2;
			var loc6:int = 0;
			while (loc6 < loc5) {
				loc7 = loc6 * 2 * Math.PI / loc5;
				loc8 = new Point(this.start_.x + this.novaRadius_ * Math.cos(loc7), this.start_.y + this.novaRadius_ * Math.sin(loc7));
				loc9 = new SparkerParticle(loc3, this.color_, loc4, this.start_, loc8);
				map_.addObj(loc9, x_, y_);
				loc6++;
			}
			return false;
		}
	}
}
