package com.company.assembleegameclient.objects.particles {
	import com.company.assembleegameclient.objects.GameObject;

	import flash.geom.Point;

	import kabam.rotmg.messaging.impl.data.WorldPosData;

	public class FlowEffect extends ParticleEffect {


		public var start_:Point;

		public var go_:GameObject;

		public var color_:int;

		public function FlowEffect(param1:WorldPosData, param2:GameObject, param3:int) {
			super();
			this.start_ = new Point(param1.x_, param1.y_);
			this.go_ = param2;
			this.color_ = param3;
		}

		override public function runNormalRendering(param1:int, param2:int):Boolean {
			var loc5:int = 0;
			var loc6:Particle = null;
			if (FlowParticle.total_ > 200) {
				return false;
			}
			x_ = this.start_.x;
			y_ = this.start_.y;
			var loc3:int = 5;
			var loc4:int = 0;
			while (loc4 < loc3) {
				loc5 = (3 + int(Math.random() * 5)) * 20;
				loc6 = new FlowParticle(0.5, loc5, this.color_, this.start_, this.go_);
				map_.addObj(loc6, x_, y_);
				loc4++;
			}
			return false;
		}

		override public function runEasyRendering(param1:int, param2:int):Boolean {
			var loc5:int = 0;
			var loc6:Particle = null;
			if (FlowParticle.total_ > 200) {
				return false;
			}
			x_ = this.start_.x;
			y_ = this.start_.y;
			var loc3:int = 3;
			var loc4:int = 0;
			while (loc4 < loc3) {
				loc5 = (3 + int(Math.random() * 5)) * 10;
				loc6 = new FlowParticle(0.5, loc5, this.color_, this.start_, this.go_);
				map_.addObj(loc6, x_, y_);
				loc4++;
			}
			return false;
		}
	}
}

import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.objects.particles.Particle;

import flash.geom.Point;

class FlowParticle extends Particle {

	public static var total_:int = 0;


	public var start_:Point;

	public var go_:GameObject;

	public var maxDist_:Number;

	public var flowSpeed_:Number;

	function FlowParticle(param1:Number, param2:int, param3:int, param4:Point, param5:GameObject) {
		super(param3, param1, param2);
		this.start_ = param4;
		this.go_ = param5;
		var loc6:Point = new Point(x_, y_);
		var loc7:Point = new Point(this.go_.x_, this.go_.y_);
		this.maxDist_ = Point.distance(loc6, loc7);
		this.flowSpeed_ = Math.random() * 5;
		total_++;
	}

	override public function update(param1:int, param2:int):Boolean {
		var loc3:Number = 8;
		var loc4:Point = new Point(x_, y_);
		var loc5:Point = new Point(this.go_.x_, this.go_.y_);
		var loc6:Number = Point.distance(loc4, loc5);
		if (loc6 < 0.5) {
			total_--;
			return false;
		}
		this.flowSpeed_ = this.flowSpeed_ + loc3 * param2 / 1000;
		this.maxDist_ = this.maxDist_ - this.flowSpeed_ * param2 / 1000;
		var loc7:Number = loc6 - this.flowSpeed_ * param2 / 1000;
		if (loc7 > this.maxDist_) {
			loc7 = this.maxDist_;
		}
		var loc8:Number = this.go_.x_ - x_;
		var loc9:Number = this.go_.y_ - y_;
		loc8 = loc8 * (loc7 / loc6);
		loc9 = loc9 * (loc7 / loc6);
		moveTo(this.go_.x_ - loc8, this.go_.y_ - loc9);
		return true;
	}
}

import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.objects.particles.Particle;

import flash.geom.Point;

class FlowParticle2 extends Particle {


	public var start_:Point;

	public var go_:GameObject;

	public var accel_:Number;

	public var dx_:Number;

	public var dy_:Number;

	function FlowParticle2(param1:Number, param2:int, param3:int, param4:Number, param5:Point, param6:GameObject) {
		super(param3, param1, param2);
		this.start_ = param5;
		this.go_ = param6;
		this.accel_ = param4;
		this.dx_ = Math.random() - 0.5;
		this.dy_ = Math.random() - 0.5;
	}

	override public function update(param1:int, param2:int):Boolean {
		var loc3:Point = new Point(x_, y_);
		var loc4:Point = new Point(this.go_.x_, this.go_.y_);
		var loc5:Number = Point.distance(loc3, loc4);
		if (loc5 < 0.5) {
			return false;
		}
		var loc6:Number = Math.atan2(this.go_.y_ - y_, this.go_.x_ - x_);
		this.dx_ = this.dx_ + this.accel_ * Math.cos(loc6) * param2 / 1000;
		this.dy_ = this.dy_ + this.accel_ * Math.sin(loc6) * param2 / 1000;
		var loc7:Number = x_ + this.dx_ * param2 / 1000;
		var loc8:Number = y_ + this.dy_ * param2 / 1000;
		moveTo(loc7, loc8);
		return true;
	}
}
