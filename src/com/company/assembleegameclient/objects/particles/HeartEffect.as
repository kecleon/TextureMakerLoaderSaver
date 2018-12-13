 
package com.company.assembleegameclient.objects.particles {
	import com.company.assembleegameclient.objects.GameObject;
	import com.company.assembleegameclient.util.ColorUtil;
	
	public class HeartEffect extends ParticleEffect {
		 
		
		public var go_:GameObject;
		
		public var color_:uint;
		
		public var color2_:uint;
		
		public var rise_:Number;
		
		public var rad_:Number;
		
		public var maxRad_:Number;
		
		public var lastUpdate_:int = -1;
		
		public var bInitialized_:Boolean = false;
		
		public var amount_:int;
		
		public var maxLife_:int;
		
		public var speed_:Number;
		
		public var parts_:Vector.<HeartParticle>;
		
		public function HeartEffect(param1:GameObject, param2:EffectProperties) {
			this.parts_ = new Vector.<HeartParticle>();
			super();
			this.go_ = param1;
			this.color_ = param2.color;
			this.color2_ = param2.color2;
			this.rise_ = param2.rise;
			this.rad_ = param2.minRadius;
			this.maxRad_ = param2.maxRadius;
			this.amount_ = param2.amount;
			this.maxLife_ = param2.life * 1000;
			this.speed_ = param2.speed / (2 * Math.PI);
		}
		
		override public function update(param1:int, param2:int) : Boolean {
			var loc3:HeartParticle = null;
			var loc4:int = 0;
			var loc5:HeartParticle = null;
			var loc6:Number = NaN;
			var loc7:Number = NaN;
			if(this.go_.map_ == null) {
				return false;
			}
			if(this.lastUpdate_ < 0) {
				this.lastUpdate_ = Math.max(0,param1 - 400);
			}
			x_ = this.go_.x_;
			y_ = this.go_.y_;
			if(!this.bInitialized_) {
				loc4 = 0;
				while(loc4 < this.amount_) {
					loc5 = new HeartParticle(ColorUtil.rangeRandomSmart(this.color_,this.color2_));
					loc5.cX_ = x_;
					loc5.cY_ = y_;
					loc6 = 2 * Math.PI;
					loc7 = loc6 / this.amount_;
					loc5.restart(param1 + loc7 * loc4 * 1000,param1);
					loc5.rad_ = this.rad_;
					this.parts_.push(loc5);
					map_.addObj(loc5,x_,y_);
					loc5.z_ = 0.4 + Math.sin(loc7 * loc4 * 1.5) * 0.05;
					loc4++;
				}
				this.bInitialized_ = true;
			}
			for each(loc3 in this.parts_) {
				loc3.rad_ = this.rad_;
			}
			if(this.maxLife_ <= 500) {
				this.rad_ = Math.max(this.rad_ - 2 * this.maxRad_ * (param2 / 1000),0);
			} else {
				this.rad_ = Math.min(this.rad_ + this.rise_ * (param2 / 1000),this.maxRad_);
			}
			this.maxLife_ = this.maxLife_ - param2;
			if(this.maxLife_ <= 0) {
				this.endEffect();
				return false;
			}
			this.lastUpdate_ = param1;
			return true;
		}
		
		private function endEffect() : void {
			var loc1:HeartParticle = null;
			for each(loc1 in this.parts_) {
				loc1.alive_ = false;
			}
		}
		
		override public function removeFromMap() : void {
			this.endEffect();
			super.removeFromMap();
		}
	}
}

import com.company.assembleegameclient.objects.particles.Particle;
import com.company.assembleegameclient.util.FreeList;

class HeartParticle extends Particle {
	 
	
	public var startTime_:int;
	
	public var cX_:Number;
	
	public var cY_:Number;
	
	public var rad_:Number;
	
	public var alive_:Boolean = true;
	
	public var speed_:Number;
	
	private var radVar_:Number;
	
	function HeartParticle(param1:uint = 16711680) {
		this.radVar_ = 0.97 + Math.random() * 0.06;
		super(param1,0,140 + Math.random() * 40);
	}
	
	private function move(param1:Number) : void {
		x_ = this.cX_ + 16 * Math.sin(param1) * Math.sin(param1) * Math.sin(param1) / 16 * (this.rad_ * this.radVar_);
		y_ = this.cY_ - (13 * Math.cos(param1) - 5 * Math.cos(2 * param1) - 2 * Math.cos(3 * param1) - Math.cos(4 * param1)) / 16 * (this.rad_ * this.radVar_);
	}
	
	public function restart(param1:int, param2:int) : void {
		this.startTime_ = param1;
		var loc3:Number = (param2 - this.startTime_) / 1000;
		this.move(loc3);
	}
	
	override public function removeFromMap() : void {
		super.removeFromMap();
		FreeList.deleteObject(this);
	}
	
	override public function update(param1:int, param2:int) : Boolean {
		var loc3:Number = (param1 - this.startTime_) / 1000;
		this.move(loc3);
		return this.alive_;
	}
}
