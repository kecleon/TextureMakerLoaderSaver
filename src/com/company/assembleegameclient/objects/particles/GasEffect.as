 
package com.company.assembleegameclient.objects.particles {
	import com.company.assembleegameclient.objects.GameObject;
	import com.company.assembleegameclient.util.RandomUtil;
	
	public class GasEffect extends ParticleEffect {
		 
		
		public var go_:GameObject;
		
		public var props:EffectProperties;
		
		public var color_:int;
		
		public var rate:Number;
		
		public var type:String;
		
		public function GasEffect(param1:GameObject, param2:EffectProperties) {
			super();
			this.go_ = param1;
			this.color_ = param2.color;
			this.rate = param2.rate;
			this.props = param2;
		}
		
		override public function update(param1:int, param2:int) : Boolean {
			var loc5:Number = NaN;
			var loc6:Number = NaN;
			var loc7:Number = NaN;
			var loc8:Number = NaN;
			var loc9:Number = NaN;
			var loc10:GasParticle = null;
			if(this.go_.map_ == null) {
				return false;
			}
			x_ = this.go_.x_;
			y_ = this.go_.y_;
			var loc3:int = 20;
			var loc4:int = 0;
			while(loc4 < this.rate) {
				loc5 = (Math.random() + 0.3) * 200;
				loc6 = Math.random();
				loc7 = RandomUtil.plusMinus(this.props.speed - this.props.speed * (loc6 * (1 - this.props.speedVariance)));
				loc8 = RandomUtil.plusMinus(this.props.speed - this.props.speed * (loc6 * (1 - this.props.speedVariance)));
				loc9 = this.props.life * 1000 - this.props.life * 1000 * (loc6 * this.props.lifeVariance);
				loc10 = new GasParticle(loc5,this.color_,loc9,this.props.spread,0.75,loc7,loc8);
				map_.addObj(loc10,x_,y_);
				loc4++;
			}
			return true;
		}
	}
}
