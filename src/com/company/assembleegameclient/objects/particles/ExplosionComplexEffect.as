package com.company.assembleegameclient.objects.particles {
	import com.company.assembleegameclient.objects.GameObject;

	public class ExplosionComplexEffect extends ParticleEffect {


		public var go_:GameObject;

		public var color_:uint;

		public var rise_:Number;

		public var minRad_:Number;

		public var maxRad_:Number;

		public var lastUpdate_:int = -1;

		public var amount_:int;

		public var maxLife_:int;

		public var speed_:Number;

		public var bInitialized_:Boolean = false;

		public function ExplosionComplexEffect(param1:GameObject, param2:EffectProperties) {
			super();
			this.go_ = param1;
			this.color_ = param2.color;
			this.rise_ = param2.rise;
			this.minRad_ = param2.minRadius;
			this.maxRad_ = param2.maxRadius;
			this.amount_ = param2.amount;
			this.maxLife_ = param2.life * 1000;
			size_ = param2.size;
		}

		private function run(param1:int, param2:int, param3:int):Boolean {
			var loc5:Number = NaN;
			var loc6:Number = NaN;
			var loc7:Number = NaN;
			var loc8:Number = NaN;
			var loc9:Number = NaN;
			var loc10:Number = NaN;
			var loc11:ExplosionComplexParticle = null;
			var loc4:int = 0;
			while (loc4 < param3) {
				loc5 = Math.random() * Math.PI * 2;
				loc6 = this.minRad_ + Math.random() * (this.maxRad_ - this.minRad_);
				loc7 = loc6 * Math.cos(loc5) / (0.008 * this.maxLife_);
				loc8 = loc6 * Math.sin(loc5) / (0.008 * this.maxLife_);
				loc9 = Math.random() * Math.PI;
				loc10 = 0;
				loc11 = new ExplosionComplexParticle(this.color_, 0.2, size_, this.maxLife_, loc7, loc8, loc10);
				map_.addObj(loc11, x_, y_);
				loc4++;
			}
			return false;
		}

		override public function runNormalRendering(param1:int, param2:int):Boolean {
			return this.run(param1, param2, this.amount_);
		}

		override public function runEasyRendering(param1:int, param2:int):Boolean {
			return this.run(param1, param2, this.amount_ / 6);
		}
	}
}

import com.company.assembleegameclient.objects.particles.Particle;

import flash.geom.Vector3D;

class ExplosionComplexParticle extends Particle {

	public static var total_:int = 0;


	public var lifetime_:int;

	public var timeLeft_:int;

	protected var moveVec_:Vector3D;

	private var deleted:Boolean = false;

	function ExplosionComplexParticle(param1:uint, param2:Number, param3:int, param4:int, param5:Number, param6:Number, param7:Number) {
		this.moveVec_ = new Vector3D();
		super(param1, param2, param3);
		this.timeLeft_ = this.lifetime_ = param4;
		this.moveVec_.x = param5;
		this.moveVec_.y = param6;
		this.moveVec_.z = param7;
		total_++;
	}

	override public function update(param1:int, param2:int):Boolean {
		this.timeLeft_ = this.timeLeft_ - param2;
		if (this.timeLeft_ <= 0) {
			if (!this.deleted) {
				total_--;
				this.deleted = true;
			}
			return false;
		}
		x_ = x_ + this.moveVec_.x * param2 * 0.008;
		y_ = y_ + this.moveVec_.y * param2 * 0.008;
		z_ = z_ + this.moveVec_.z * param2 * 0.008;
		return true;
	}
}
