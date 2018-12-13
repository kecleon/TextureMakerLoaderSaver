 
package com.company.assembleegameclient.objects.particles {
	import com.company.assembleegameclient.objects.GameObject;
	import com.company.assembleegameclient.util.RandomUtil;
	
	public class PoisonEffect extends ParticleEffect {
		 
		
		public var go_:GameObject;
		
		public var color_:int;
		
		public function PoisonEffect(param1:GameObject, param2:int) {
			super();
			this.go_ = param1;
			this.color_ = param2;
		}
		
		override public function update(param1:int, param2:int) : Boolean {
			if(this.go_.map_ == null) {
				return false;
			}
			x_ = this.go_.x_;
			y_ = this.go_.y_;
			var loc3:int = 10;
			var loc4:int = 0;
			while(loc4 < loc3) {
				map_.addObj(new SparkParticle(100,this.color_,400,0.75,RandomUtil.plusMinus(4),RandomUtil.plusMinus(4)),x_,y_);
				loc4++;
			}
			return false;
		}
	}
}
