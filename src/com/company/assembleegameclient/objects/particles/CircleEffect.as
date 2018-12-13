 
package com.company.assembleegameclient.objects.particles {
	import com.company.assembleegameclient.objects.GameObject;
	import com.company.assembleegameclient.util.ColorUtil;
	
	public class CircleEffect extends ParticleEffect {
		 
		
		public var go_:GameObject;
		
		public var color_:uint;
		
		public var rise_:Number;
		
		public var rad_:Number;
		
		public var maxRad_:Number;
		
		public var lastUpdate_:int = -1;
		
		public var bInitialized_:Boolean = false;
		
		public var amount_:int;
		
		public var maxLife_:int;
		
		public var speed_:Number;
		
		public var parts_:Vector.<CircleParticle>;
		
		public function CircleEffect(param1:GameObject, param2:EffectProperties) {
			this.parts_ = new Vector.<CircleParticle>();
			super();
			this.go_ = param1;
			this.color_ = param2.color;
			this.rise_ = param2.rise;
			this.rad_ = param2.minRadius;
			this.maxRad_ = param2.maxRadius;
			this.amount_ = param2.amount;
			this.maxLife_ = param2.life * 1000;
			this.speed_ = param2.speed;
		}
		
		override public function update(param1:int, param2:int) : Boolean {
			var loc3:CircleParticle = null;
			var loc4:int = 0;
			var loc5:CircleParticle = null;
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
					loc5 = new CircleParticle(ColorUtil.randomSmart(this.color_));
					loc5.cX_ = x_;
					loc5.cY_ = y_;
					loc6 = 2 * Math.PI;
					loc7 = loc6 / this.amount_;
					loc5.startTime_ = param1;
					loc5.angle_ = loc7 * loc4;
					loc5.rad_ = this.rad_;
					loc5.speed_ = this.speed_;
					this.parts_.push(loc5);
					map_.addObj(loc5,x_,y_);
					loc5.move();
					loc4++;
				}
				this.bInitialized_ = true;
			}
			for each(loc3 in this.parts_) {
				loc3.rad_ = this.rad_;
			}
			this.rad_ = Math.min(this.rad_ + this.rise_ * (param2 / 1000),this.maxRad_);
			this.maxLife_ = this.maxLife_ - param2;
			if(this.maxLife_ <= 0) {
				this.endEffect();
				return false;
			}
			this.lastUpdate_ = param1;
			return true;
		}
		
		private function endEffect() : void {
			var loc1:CircleParticle = null;
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

class CircleParticle extends Particle {
	 
	
	public var startTime_:int;
	
	public var speed_:Number;
	
	public var cX_:Number;
	
	public var cY_:Number;
	
	public var angle_:Number;
	
	public var rad_:Number;
	
	public var alive_:Boolean = true;
	
	function CircleParticle(param1:uint = 0) {
		var loc2:Number = Math.random();
		super(param1,0.2 + Math.random() * 0.2,100 + loc2 * 20);
	}
	
	override public function removeFromMap() : void {
		super.removeFromMap();
		FreeList.deleteObject(this);
	}
	
	public function move() : void {
		x_ = this.cX_ + this.rad_ * Math.cos(this.angle_);
		y_ = this.cY_ + this.rad_ * Math.sin(this.angle_);
		this.angle_ = this.angle_ + this.speed_;
	}
	
	override public function update(param1:int, param2:int) : Boolean {
		this.move();
		return this.alive_;
	}
}
