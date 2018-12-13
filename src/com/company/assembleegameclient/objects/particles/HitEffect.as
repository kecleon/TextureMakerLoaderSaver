package com.company.assembleegameclient.objects.particles {
	public class HitEffect extends ParticleEffect {


		public var colors_:Vector.<uint>;

		public var numParts_:int;

		public var angle_:Number;

		public var speed_:Number;

		public function HitEffect(param1:Vector.<uint>, param2:int, param3:int, param4:Number, param5:Number) {
			super();
			this.colors_ = param1;
			size_ = param2;
			this.numParts_ = param3;
			this.angle_ = param4;
			this.speed_ = param5;
		}

		override public function runNormalRendering(param1:int, param2:int):Boolean {
			var loc6:uint = 0;
			var loc7:Particle = null;
			if (this.colors_.length == 0) {
				return false;
			}
			var loc3:Number = this.speed_ / 600 * Math.cos(this.angle_ + Math.PI);
			var loc4:Number = this.speed_ / 600 * Math.sin(this.angle_ + Math.PI);
			var loc5:int = 0;
			while (loc5 < this.numParts_) {
				loc6 = this.colors_[int(this.colors_.length * Math.random())];
				loc7 = new HitParticle(loc6, 0.5, size_, 200 + Math.random() * 100, loc3 + (Math.random() - 0.5) * 0.4, loc4 + (Math.random() - 0.5) * 0.4, 0);
				map_.addObj(loc7, x_, y_);
				loc5++;
			}
			return false;
		}

		override public function runEasyRendering(param1:int, param2:int):Boolean {
			var loc6:uint = 0;
			var loc7:Particle = null;
			if (this.colors_.length == 0) {
				return false;
			}
			var loc3:Number = this.speed_ / 600 * Math.cos(this.angle_ + Math.PI);
			var loc4:Number = this.speed_ / 600 * Math.sin(this.angle_ + Math.PI);
			this.numParts_ = this.numParts_ * 0.2;
			var loc5:int = 0;
			while (loc5 < this.numParts_) {
				loc6 = this.colors_[int(this.colors_.length * Math.random())];
				loc7 = new HitParticle(loc6, 0.5, 10, 5 + Math.random() * 100, loc3 + (Math.random() - 0.5) * 0.4, loc4 + (Math.random() - 0.5) * 0.4, 0);
				map_.addObj(loc7, x_, y_);
				loc5++;
			}
			return false;
		}
	}
}

import com.company.assembleegameclient.objects.particles.Particle;

import flash.geom.Vector3D;

class HitParticle extends Particle {


	public var lifetime_:int;

	public var timeLeft_:int;

	protected var moveVec_:Vector3D;

	function HitParticle(param1:uint, param2:Number, param3:int, param4:int, param5:Number, param6:Number, param7:Number) {
		this.moveVec_ = new Vector3D();
		super(param1, param2, param3);
		this.timeLeft_ = this.lifetime_ = param4;
		this.moveVec_.x = param5;
		this.moveVec_.y = param6;
		this.moveVec_.z = param7;
	}

	override public function update(param1:int, param2:int):Boolean {
		this.timeLeft_ = this.timeLeft_ - param2;
		if (this.timeLeft_ <= 0) {
			return false;
		}
		x_ = x_ + this.moveVec_.x * param2 * 0.008;
		y_ = y_ + this.moveVec_.y * param2 * 0.008;
		z_ = z_ + this.moveVec_.z * param2 * 0.008;
		return true;
	}
}
