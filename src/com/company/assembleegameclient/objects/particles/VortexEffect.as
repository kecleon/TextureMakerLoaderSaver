 
package com.company.assembleegameclient.objects.particles {
	import com.company.assembleegameclient.objects.GameObject;
	import com.company.assembleegameclient.util.FreeList;
	
	public class VortexEffect extends ParticleEffect {
		 
		
		public var go_:GameObject;
		
		public var color_:uint;
		
		public var rad_:Number;
		
		public var lastUpdate_:int = -1;
		
		public function VortexEffect(param1:GameObject, param2:EffectProperties) {
			super();
			this.go_ = param1;
			this.color_ = param2.color;
			this.color_ = param2.color;
			this.rad_ = param2.minRadius;
		}
		
		override public function update(param1:int, param2:int) : Boolean {
			var loc4:int = 0;
			var loc5:VortexParticle = null;
			var loc6:Number = NaN;
			var loc7:Number = NaN;
			var loc8:Number = NaN;
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
				loc5 = FreeList.newObject(VortexParticle) as VortexParticle;
				loc5.setColor(this.color_);
				loc6 = 2 * Math.PI * Math.random();
				loc7 = Math.cos(loc6) * 6;
				loc8 = Math.sin(loc6) * 6;
				map_.addObj(loc5,x_ + loc7,y_ + loc8);
				loc5.restart(loc4,param1,x_,y_);
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

class VortexParticle extends Particle {
	
	private static const G:Number = 4;
	 
	
	public var startTime_:int;
	
	protected var moveVec_:Vector3D;
	
	private var A:Number;
	
	private var mSize:Number;
	
	private var centerX_:Number;
	
	private var centerY_:Number;
	
	private var initAccelX:Number;
	
	private var initAccelY:Number;
	
	private var fSize:Number = 0;
	
	function VortexParticle(param1:uint = 2556008) {
		this.moveVec_ = new Vector3D();
		this.A = 2.5 + 0.5 * Math.random();
		this.mSize = 3.5 + 2 * Math.random();
		super(param1,1,0);
	}
	
	public function restart(param1:int, param2:int, param3:Number, param4:Number) : void {
		this.centerX_ = param3;
		this.centerY_ = param4;
		var loc5:Number = Math.atan2(this.centerX_ - x_,this.centerY_ - y_) + Math.PI / 2 - Math.PI / 6;
		this.initAccelX = Math.sin(loc5) * this.A;
		this.initAccelY = Math.cos(loc5) * this.A;
		z_ = 1;
		this.fSize = 0;
		size_ = this.fSize;
	}
	
	override public function removeFromMap() : void {
		super.removeFromMap();
		FreeList.deleteObject(this);
	}
	
	override public function update(param1:int, param2:int) : Boolean {
		var loc3:Number = Math.atan2(this.centerX_ - x_,this.centerY_ - y_);
		var loc4:Number = 1;
		var loc5:Number = Math.sin(loc3) / loc4 * G;
		var loc6:Number = Math.cos(loc3) / loc4 * G;
		if(this.mSize > size_) {
			this.fSize = this.fSize + param2 * 0.01;
		}
		size_ = this.fSize;
		moveTo(x_ + (loc5 + this.initAccelX) * param2 * 0.0006,y_ + (loc6 + this.initAccelY) * param2 * 0.0006);
		z_ = z_ + -0.5 * param2 * 0.0006;
		return z_ > 0;
	}
}
