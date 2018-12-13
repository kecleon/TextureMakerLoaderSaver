 
package com.company.assembleegameclient.objects.particles {
	import com.company.assembleegameclient.objects.GameObject;
	import com.company.assembleegameclient.util.FreeList;
	
	public class VentEffect extends ParticleEffect {
		
		private static const BUBBLE_PERIOD:int = 50;
		 
		
		public var go_:GameObject;
		
		public var lastUpdate_:int = -1;
		
		public function VentEffect(param1:GameObject) {
			super();
			this.go_ = param1;
		}
		
		override public function update(param1:int, param2:int) : Boolean {
			var loc4:int = 0;
			var loc5:VentParticle = null;
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
				loc5 = FreeList.newObject(VentParticle) as VentParticle;
				loc5.restart(loc4,param1);
				loc6 = Math.random() * Math.PI;
				loc7 = Math.random() * 0.4;
				loc8 = this.go_.x_ + loc7 * Math.cos(loc6);
				loc9 = this.go_.y_ + loc7 * Math.sin(loc6);
				map_.addObj(loc5,loc8,loc9);
				loc3++;
			}
			this.lastUpdate_ = param1;
			return true;
		}
	}
}

import com.company.assembleegameclient.objects.particles.Particle;
import com.company.assembleegameclient.util.FreeList;

class VentParticle extends Particle {
	 
	
	public var startTime_:int;
	
	public var speed_:int;
	
	function VentParticle() {
		var loc1:Number = Math.random();
		super(2542335,0,75 + loc1 * 50);
		this.speed_ = 2.5 - loc1 * 1.5;
	}
	
	public function restart(param1:int, param2:int) : void {
		this.startTime_ = param1;
		var loc3:Number = (param2 - this.startTime_) / 1000;
		z_ = 0 + this.speed_ * loc3;
	}
	
	override public function removeFromMap() : void {
		super.removeFromMap();
		FreeList.deleteObject(this);
	}
	
	override public function update(param1:int, param2:int) : Boolean {
		var loc3:Number = (param1 - this.startTime_) / 1000;
		z_ = 0 + this.speed_ * loc3;
		return z_ < 1;
	}
}
