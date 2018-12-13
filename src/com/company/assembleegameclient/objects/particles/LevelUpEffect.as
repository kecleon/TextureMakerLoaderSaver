 
package com.company.assembleegameclient.objects.particles {
	import com.company.assembleegameclient.objects.GameObject;
	
	public class LevelUpEffect extends ParticleEffect {
		
		private static const LIFETIME:int = 2000;
		 
		
		public var go_:GameObject;
		
		public var parts1_:Vector.<LevelUpParticle>;
		
		public var parts2_:Vector.<LevelUpParticle>;
		
		public var startTime_:int = -1;
		
		public function LevelUpEffect(param1:GameObject, param2:uint, param3:int) {
			var loc4:LevelUpParticle = null;
			this.parts1_ = new Vector.<LevelUpParticle>();
			this.parts2_ = new Vector.<LevelUpParticle>();
			super();
			this.go_ = param1;
			var loc5:int = 0;
			while(loc5 < param3) {
				loc4 = new LevelUpParticle(param2,100);
				this.parts1_.push(loc4);
				loc4 = new LevelUpParticle(param2,100);
				this.parts2_.push(loc4);
				loc5++;
			}
		}
		
		override public function update(param1:int, param2:int) : Boolean {
			if(this.go_.map_ == null) {
				this.endEffect();
				return false;
			}
			x_ = this.go_.x_;
			y_ = this.go_.y_;
			if(this.startTime_ < 0) {
				this.startTime_ = param1;
			}
			var loc3:Number = (param1 - this.startTime_) / LIFETIME;
			if(loc3 >= 1) {
				this.endEffect();
				return false;
			}
			this.updateSwirl(this.parts1_,1,0,loc3);
			this.updateSwirl(this.parts2_,1,Math.PI,loc3);
			return true;
		}
		
		private function endEffect() : void {
			var loc1:LevelUpParticle = null;
			for each(loc1 in this.parts1_) {
				loc1.alive_ = false;
			}
			for each(loc1 in this.parts2_) {
				loc1.alive_ = false;
			}
		}
		
		public function updateSwirl(param1:Vector.<LevelUpParticle>, param2:Number, param3:Number, param4:Number) : void {
			var loc5:int = 0;
			var loc6:LevelUpParticle = null;
			var loc7:Number = NaN;
			var loc8:Number = NaN;
			var loc9:Number = NaN;
			loc5 = 0;
			while(loc5 < param1.length) {
				loc6 = param1[loc5];
				loc6.z_ = param4 * 2 - 1 + loc5 / param1.length;
				if(loc6.z_ >= 0) {
					if(loc6.z_ > 1) {
						loc6.alive_ = false;
					} else {
						loc7 = param2 * (2 * Math.PI * (loc5 / param1.length) + 2 * Math.PI * param4 + param3);
						loc8 = this.go_.x_ + 0.5 * Math.cos(loc7);
						loc9 = this.go_.y_ + 0.5 * Math.sin(loc7);
						if(loc6.map_ == null) {
							map_.addObj(loc6,loc8,loc9);
						} else {
							loc6.moveTo(loc8,loc9);
						}
					}
				}
				loc5++;
			}
		}
	}
}

import com.company.assembleegameclient.objects.particles.Particle;

class LevelUpParticle extends Particle {
	 
	
	public var alive_:Boolean = true;
	
	function LevelUpParticle(param1:uint, param2:int) {
		super(param1,0,param2);
	}
	
	override public function update(param1:int, param2:int) : Boolean {
		return this.alive_;
	}
}
