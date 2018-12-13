 
package com.company.assembleegameclient.objects.particles {
	import com.company.assembleegameclient.objects.GameObject;
	import com.company.assembleegameclient.util.FreeList;
	
	public class SkyBeamEffect extends ParticleEffect {
		
		private static const BUBBLE_PERIOD:int = 30;
		 
		
		public var go_:GameObject;
		
		public var color_:uint;
		
		public var rise_:Number;
		
		public var radius:Number;
		
		public var height_:Number;
		
		public var maxRadius:Number;
		
		public var speed_:Number;
		
		public var lastUpdate_:int = -1;
		
		public function SkyBeamEffect(param1:GameObject, param2:EffectProperties) {
			super();
			this.go_ = param1;
			this.color_ = param2.color;
			this.rise_ = param2.rise;
			this.radius = param2.minRadius;
			this.maxRadius = param2.maxRadius;
			this.height_ = param2.zOffset;
			this.speed_ = param2.speed;
		}
		
		override public function update(param1:int, param2:int) : Boolean {
			var loc4:int = 0;
			var loc5:SkyBeamParticle = null;
			var loc6:Number = NaN;
			var loc7:Number = NaN;
			var loc8:Number = NaN;
			var loc9:Number = NaN;
			if(this.go_.map_ == null) {
				return false;
			}
			if(this.lastUpdate_ < 0) {
				this.lastUpdate_ = Math.max(0,param1 - 400);
			}
			x_ = this.go_.x_;
			y_ = this.go_.y_;
			var loc3:int = int(this.lastUpdate_ / BUBBLE_PERIOD);
			while(loc3 < int(param1 / BUBBLE_PERIOD)) {
				loc4 = loc3 * BUBBLE_PERIOD;
				loc5 = FreeList.newObject(SkyBeamParticle) as SkyBeamParticle;
				loc5.setColor(this.color_);
				loc5.height_ = this.height_;
				loc5.restart(loc4,param1);
				loc6 = 2 * Math.random() * Math.PI;
				loc7 = Math.random() * this.radius;
				loc5.setSpeed(this.speed_ + (this.maxRadius - loc7));
				loc8 = this.go_.x_ + loc7 * Math.cos(loc6);
				loc9 = this.go_.y_ + loc7 * Math.sin(loc6);
				map_.addObj(loc5,loc8,loc9);
				loc3++;
			}
			this.radius = Math.min(this.radius + this.rise_ * (param2 / 1000),this.maxRadius);
			this.lastUpdate_ = param1;
			return true;
		}
	}
}

import com.company.assembleegameclient.objects.particles.Particle;
import com.company.assembleegameclient.util.FreeList;

class SkyBeamParticle extends Particle {
	 
	
	public var startTime_:int;
	
	public var speed_:Number;
	
	public var height_:Number;
	
	function SkyBeamParticle() {
		var loc1:Number = Math.random();
		super(2542335,this.height_,80 + loc1 * 40);
	}
	
	public function setSpeed(param1:Number) : void {
		this.speed_ = param1;
	}
	
	public function restart(param1:int, param2:int) : void {
		this.startTime_ = param1;
		var loc3:Number = (param2 - this.startTime_) / 1000;
		z_ = this.height_ - this.speed_ * loc3;
	}
	
	override public function removeFromMap() : void {
		super.removeFromMap();
		FreeList.deleteObject(this);
	}
	
	override public function update(param1:int, param2:int) : Boolean {
		var loc3:Number = (param1 - this.startTime_) / 1000;
		z_ = this.height_ - this.speed_ * loc3;
		return z_ > 0;
	}
}
