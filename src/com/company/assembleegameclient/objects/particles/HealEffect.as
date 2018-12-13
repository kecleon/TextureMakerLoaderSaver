package com.company.assembleegameclient.objects.particles {
	import com.company.assembleegameclient.objects.GameObject;

	public class HealEffect extends ParticleEffect {


		public var go_:GameObject;

		public var color_:uint;

		public function HealEffect(param1:GameObject, param2:uint) {
			super();
			this.go_ = param1;
			this.color_ = param2;
		}

		override public function update(param1:int, param2:int):Boolean {
			var loc5:Number = NaN;
			var loc6:int = 0;
			var loc7:Number = NaN;
			var loc8:HealParticle = null;
			if (this.go_.map_ == null) {
				return false;
			}
			x_ = this.go_.x_;
			y_ = this.go_.y_;
			var loc3:int = 10;
			var loc4:int = 0;
			while (loc4 < loc3) {
				loc5 = 2 * Math.PI * (loc4 / loc3);
				loc6 = (3 + int(Math.random() * 5)) * 20;
				loc7 = 0.3 + 0.4 * Math.random();
				loc8 = new HealParticle(this.color_, Math.random() * 0.3, loc6, 1000, 0.1 + Math.random() * 0.1, this.go_, loc5, loc7);
				map_.addObj(loc8, x_ + loc7 * Math.cos(loc5), y_ + loc7 * Math.sin(loc5));
				loc4++;
			}
			return false;
		}
	}
}
