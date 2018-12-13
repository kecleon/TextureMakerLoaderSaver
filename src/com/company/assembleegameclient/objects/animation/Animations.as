package com.company.assembleegameclient.objects.animation {
	import flash.display.BitmapData;

	public class Animations {


		public var animationsData_:AnimationsData;

		public var nextRun_:Vector.<int> = null;

		public var running_:RunningAnimation = null;

		public function Animations(param1:AnimationsData) {
			super();
			this.animationsData_ = param1;
		}

		public function getTexture(param1:int):BitmapData {
			var loc2:AnimationData = null;
			var loc4:BitmapData = null;
			var loc5:int = 0;
			if (this.nextRun_ == null) {
				this.nextRun_ = new Vector.<int>();
				for each(loc2 in this.animationsData_.animations) {
					this.nextRun_.push(loc2.getLastRun(param1));
				}
			}
			if (this.running_ != null) {
				loc4 = this.running_.getTexture(param1);
				if (loc4 != null) {
					return loc4;
				}
				this.running_ = null;
			}
			var loc3:int = 0;
			while (loc3 < this.nextRun_.length) {
				if (param1 > this.nextRun_[loc3]) {
					loc5 = this.nextRun_[loc3];
					loc2 = this.animationsData_.animations[loc3];
					this.nextRun_[loc3] = loc2.getNextRun(param1);
					if (!(loc2.prob_ != 1 && Math.random() > loc2.prob_)) {
						this.running_ = new RunningAnimation(loc2, loc5);
						return this.running_.getTexture(param1);
					}
				}
				loc3++;
			}
			return null;
		}
	}
}

import com.company.assembleegameclient.objects.animation.AnimationData;
import com.company.assembleegameclient.objects.animation.FrameData;

import flash.display.BitmapData;

class RunningAnimation {


	public var animationData_:AnimationData;

	public var start_:int;

	public var frameId_:int;

	public var frameStart_:int;

	public var texture_:BitmapData;

	function RunningAnimation(param1:AnimationData, param2:int) {
		super();
		this.animationData_ = param1;
		this.start_ = param2;
		this.frameId_ = 0;
		this.frameStart_ = param2;
		this.texture_ = null;
	}

	public function getTexture(param1:int):BitmapData {
		var loc2:FrameData = this.animationData_.frames[this.frameId_];
		while (param1 - this.frameStart_ > loc2.time_) {
			if (this.frameId_ >= this.animationData_.frames.length - 1) {
				return null;
			}
			this.frameStart_ = this.frameStart_ + loc2.time_;
			this.frameId_++;
			loc2 = this.animationData_.frames[this.frameId_];
			this.texture_ = null;
		}
		if (this.texture_ == null) {
			this.texture_ = loc2.textureData_.getTexture(Math.random() * 100);
		}
		return this.texture_;
	}
}
