 
package com.company.assembleegameclient.objects.particles {
	import com.company.assembleegameclient.objects.GameObject;
	import com.company.assembleegameclient.util.FreeList;
	
	public class FountainEffect extends ParticleEffect {
		 
		
		public var go_:GameObject;
		
		public var color_:uint;
		
		public var lastUpdate_:int = -1;
		
		public function FountainEffect(param1:GameObject, param2:EffectProperties) {
			super();
			this.go_ = param1;
			this.color_ = param2.color;
		}
		
		override public function update(param1:int, param2:int) : Boolean {
			var loc4:int = 0;
			var loc5:FountainParticle = null;
			if(this.go_.map_ == null) {
				return false;
			}
			if(this.lastUpdate_ < 0) {
				this.lastUpdate_ = Math.max(0,param1 - 400);
			}
			x_ = this.go_.x_;
			y_ = this.go_.y_;
			var loc3:int = this.lastUpdate_ / 50;
			while(loc3 < param1 / 50) {
				loc4 = loc3 * 50;
				loc5 = FreeList.newObject(FountainParticle) as FountainParticle;
				loc5.setColor(this.color_);
				loc5.restart(loc4,param1);
				map_.addObj(loc5,x_,y_);
				loc3++;
			}
			this.lastUpdate_ = param1;
			return true;
		}
	}
}

import com.company.assembleegameclient.objects.particles.Particle;
import com.company.assembleegameclient.util.FreeList;
import flash.geom.Vector3D;

class FountainParticle extends Particle {
	
	private static const G:Number = -4.9;
	
	private static const VI:Number = 6.5;
	
	private static const ZI:Number = 0.75;
	 
	
	public var startTime_:int;
	
	protected var moveVec_:Vector3D;
	
	function FountainParticle(param1:uint = 4285909) {
		this.moveVec_ = new Vector3D();
		super(param1,ZI,100);
	}
	
	public function restart(param1:int, param2:int) : void {
		var loc3:Number = 2 * Math.PI * Math.random();
		this.moveVec_.x = Math.cos(loc3);
		this.moveVec_.y = Math.sin(loc3);
		this.startTime_ = param1;
		var loc4:int = param2 - this.startTime_;
		x_ = x_ + this.moveVec_.x * loc4 * 0.0008;
		y_ = y_ + this.moveVec_.y * loc4 * 0.0008;
		var loc5:Number = (param2 - this.startTime_) / 1000;
		z_ = 0.75 + VI * loc5 + G * (loc5 * loc5);
	}
	
	override public function removeFromMap() : void {
		super.removeFromMap();
		FreeList.deleteObject(this);
	}
	
	override public function update(param1:int, param2:int) : Boolean {
		var loc3:Number = (param1 - this.startTime_) / 1000;
		moveTo(x_ + this.moveVec_.x * param2 * 0.0008,y_ + this.moveVec_.y * param2 * 0.0008);
		z_ = 0.75 + VI * loc3 + G * (loc3 * loc3);
		return z_ > 0;
	}
}
