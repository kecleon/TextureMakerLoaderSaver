package com.company.assembleegameclient.objects.particles {
	import com.company.assembleegameclient.objects.GameObject;

	public class HealingEffect extends ParticleEffect {


		public var go_:GameObject;

		public var lastPart_:int;

		public function HealingEffect(param1:GameObject) {
			super();
			this.go_ = param1;
			this.lastPart_ = 0;
		}

		override public function update(param1:int, param2:int):Boolean {
			var loc4:Number = NaN;
			var loc5:int = 0;
			var loc6:Number = NaN;
			var loc7:HealParticle = null;
			if (this.go_.map_ == null) {
				return false;
			}
			x_ = this.go_.x_;
			y_ = this.go_.y_;
			var loc3:int = param1 - this.lastPart_;
			if (loc3 > 500) {
				loc4 = 2 * Math.PI * Math.random();
				loc5 = (3 + int(Math.random() * 5)) * 20;
				loc6 = 0.3 + 0.4 * Math.random();
				loc7 = new HealParticle(16777215, Math.random() * 0.3, loc5, 1000, 0.1 + Math.random() * 0.1, this.go_, loc4, loc6);
				map_.addObj(loc7, x_ + loc6 * Math.cos(loc4), y_ + loc6 * Math.sin(loc4));
				this.lastPart_ = param1;
			}
			return true;
		}
	}
}
