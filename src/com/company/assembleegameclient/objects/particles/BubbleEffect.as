 
package com.company.assembleegameclient.objects.particles {
	import com.company.assembleegameclient.objects.GameObject;
	import com.company.assembleegameclient.util.FreeList;
	
	public class BubbleEffect extends ParticleEffect {
		
		private static const PERIOD_MAX:Number = 400;
		 
		
		private var poolID:String;
		
		public var go_:GameObject;
		
		public var lastUpdate_:int = -1;
		
		public var rate_:Number;
		
		private var fxProps:EffectProperties;
		
		public function BubbleEffect(param1:GameObject, param2:EffectProperties) {
			super();
			this.go_ = param1;
			this.fxProps = param2;
			this.rate_ = (1 - param2.rate) * PERIOD_MAX + 1;
			this.poolID = "BubbleEffect_" + Math.random();
		}
		
		override public function update(param1:int, param2:int) : Boolean {
			var loc3:int = 0;
			var loc5:int = 0;
			var loc6:Number = NaN;
			var loc7:Number = NaN;
			var loc8:Number = NaN;
			var loc9:Number = NaN;
			var loc11:BubbleParticle = null;
			var loc12:Number = NaN;
			var loc13:Number = NaN;
			if(this.go_.map_ == null) {
				return false;
			}
			if(!this.lastUpdate_) {
				this.lastUpdate_ = param1;
				return true;
			}
			loc3 = int(this.lastUpdate_ / this.rate_);
			var loc4:int = int(param1 / this.rate_);
			loc8 = this.go_.x_;
			loc9 = this.go_.y_;
			if(this.lastUpdate_ < 0) {
				this.lastUpdate_ = Math.max(0,param1 - PERIOD_MAX);
			}
			x_ = loc8;
			y_ = loc9;
			var loc10:int = loc3;
			while(loc10 < loc4) {
				loc5 = loc10 * this.rate_;
				loc11 = BubbleParticle.create(this.poolID,this.fxProps.color,this.fxProps.speed,this.fxProps.life,this.fxProps.lifeVariance,this.fxProps.speedVariance,this.fxProps.spread);
				loc11.restart(loc5,param1);
				loc6 = Math.random() * Math.PI;
				loc7 = Math.random() * 0.4;
				loc12 = loc8 + loc7 * Math.cos(loc6);
				loc13 = loc9 + loc7 * Math.sin(loc6);
				map_.addObj(loc11,loc12,loc13);
				loc10++;
			}
			this.lastUpdate_ = param1;
			return true;
		}
		
		override public function removeFromMap() : void {
			super.removeFromMap();
			FreeList.dump(this.poolID);
		}
	}
}
