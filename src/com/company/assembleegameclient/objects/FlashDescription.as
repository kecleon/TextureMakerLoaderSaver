package com.company.assembleegameclient.objects {
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;

	import kabam.rotmg.stage3D.GraphicsFillExtra;

	public class FlashDescription {


		public var startTime_:int;

		public var color_:uint;

		public var periodMS_:int;

		public var repeats_:int;

		public var targetR:int;

		public var targetG:int;

		public var targetB:int;

		public function FlashDescription(param1:int, param2:uint, param3:Number, param4:int) {
			super();
			this.startTime_ = param1;
			this.color_ = param2;
			this.periodMS_ = param3 * 1000;
			this.repeats_ = param4;
			this.targetR = param2 >> 16 & 255;
			this.targetG = param2 >> 8 & 255;
			this.targetB = param2 & 255;
		}

		public function apply(param1:BitmapData, param2:int):BitmapData {
			var loc3:int = (param2 - this.startTime_) % this.periodMS_;
			var loc4:Number = Math.sin(loc3 / this.periodMS_ * Math.PI);
			var loc5:Number = loc4 * 0.5;
			var loc6:ColorTransform = new ColorTransform(1 - loc5, 1 - loc5, 1 - loc5, 1, loc5 * this.targetR, loc5 * this.targetG, loc5 * this.targetB, 0);
			var loc7:BitmapData = param1.clone();
			loc7.colorTransform(loc7.rect, loc6);
			return loc7;
		}

		public function applyGPUTextureColorTransform(param1:BitmapData, param2:int):void {
			var loc3:int = (param2 - this.startTime_) % this.periodMS_;
			var loc4:Number = Math.sin(loc3 / this.periodMS_ * Math.PI);
			var loc5:Number = loc4 * 0.5;
			var loc6:ColorTransform = new ColorTransform(1 - loc5, 1 - loc5, 1 - loc5, 1, loc5 * this.targetR, loc5 * this.targetG, loc5 * this.targetB, 0);
			GraphicsFillExtra.setColorTransform(param1, loc6);
		}

		public function doneAt(param1:int):Boolean {
			return param1 > this.startTime_ + this.periodMS_ * this.repeats_;
		}
	}
}
