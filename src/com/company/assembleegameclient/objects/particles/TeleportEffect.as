package com.company.assembleegameclient.objects.particles {
	public class TeleportEffect extends ParticleEffect {


		public function TeleportEffect() {
			super();
		}

		override public function runNormalRendering(param1:int, param2:int):Boolean {
			var loc5:Number = NaN;
			var loc6:Number = NaN;
			var loc7:int = 0;
			var loc8:TeleportParticle = null;
			var loc3:int = 20;
			var loc4:int = 0;
			while (loc4 < loc3) {
				loc5 = 2 * Math.PI * Math.random();
				loc6 = 0.7 * Math.random();
				loc7 = 500 + 1000 * Math.random();
				loc8 = new TeleportParticle(255, 50, 0.1, loc7);
				map_.addObj(loc8, x_ + loc6 * Math.cos(loc5), y_ + loc6 * Math.sin(loc5));
				loc4++;
			}
			return false;
		}

		override public function runEasyRendering(param1:int, param2:int):Boolean {
			var loc5:Number = NaN;
			var loc6:Number = NaN;
			var loc7:int = 0;
			var loc8:TeleportParticle = null;
			var loc3:int = 10;
			var loc4:int = 0;
			while (loc4 < loc3) {
				loc5 = 2 * Math.PI * Math.random();
				loc6 = 0.7 * Math.random();
				loc7 = 5 + 500 * Math.random();
				loc8 = new TeleportParticle(255, 50, 0.1, loc7);
				map_.addObj(loc8, x_ + loc6 * Math.cos(loc5), y_ + loc6 * Math.sin(loc5));
				loc4++;
			}
			return false;
		}
	}
}

import com.company.assembleegameclient.objects.particles.Particle;

import flash.geom.Vector3D;

class TeleportParticle extends Particle {


	public var timeLeft_:int;

	protected var moveVec_:Vector3D;

	function TeleportParticle(param1:uint, param2:int, param3:Number, param4:int) {
		this.moveVec_ = new Vector3D();
		super(param1, 0, param2);
		this.moveVec_.z = param3;
		this.timeLeft_ = param4;
	}

	override public function update(param1:int, param2:int):Boolean {
		this.timeLeft_ = this.timeLeft_ - param2;
		if (this.timeLeft_ <= 0) {
			return false;
		}
		z_ = z_ + this.moveVec_.z * param2 * 0.008;
		return true;
	}
}
