package com.company.assembleegameclient.map {
	import com.company.assembleegameclient.engine3d.Face3D;
	import com.company.assembleegameclient.parameters.Parameters;

	import flash.display.BitmapData;
	import flash.display.IGraphicsData;

	import kabam.rotmg.stage3D.GraphicsFillExtra;

	public class SquareFace {


		public var animate_:int;

		public var face_:Face3D;

		public var xOffset_:Number = 0;

		public var yOffset_:Number = 0;

		public var animateDx_:Number = 0;

		public var animateDy_:Number = 0;

		public function SquareFace(param1:BitmapData, param2:Vector.<Number>, param3:Number, param4:Number, param5:int, param6:Number, param7:Number) {
			super();
			this.face_ = new Face3D(param1, param2, Square.UVT.concat());
			this.xOffset_ = param3;
			this.yOffset_ = param4;
			if (this.xOffset_ != 0 || this.yOffset_ != 0) {
				this.face_.bitmapFill_.repeat = true;
			}
			this.animate_ = param5;
			if (this.animate_ != AnimateProperties.NO_ANIMATE) {
				this.face_.bitmapFill_.repeat = true;
			}
			this.animateDx_ = param6;
			this.animateDy_ = param7;
		}

		public function dispose():void {
			this.face_.dispose();
			this.face_ = null;
		}

		public function draw(param1:Vector.<IGraphicsData>, param2:Camera, param3:int):Boolean {
			var loc4:Number = NaN;
			var loc5:Number = NaN;
			if (this.animate_ != AnimateProperties.NO_ANIMATE) {
				switch (this.animate_) {
					case AnimateProperties.WAVE_ANIMATE:
						loc4 = this.xOffset_ + Math.sin(this.animateDx_ * param3 / 1000);
						loc5 = this.yOffset_ + Math.sin(this.animateDy_ * param3 / 1000);
						break;
					case AnimateProperties.FLOW_ANIMATE:
						loc4 = this.xOffset_ + this.animateDx_ * param3 / 1000;
						loc5 = this.yOffset_ + this.animateDy_ * param3 / 1000;
				}
			} else {
				loc4 = this.xOffset_;
				loc5 = this.yOffset_;
			}
			if (Parameters.isGpuRender()) {
				GraphicsFillExtra.setOffsetUV(this.face_.bitmapFill_, loc4, loc5);
				loc4 = loc5 = 0;
			}
			this.face_.uvt_.length = 0;
			this.face_.uvt_.push(0 + loc4, 0 + loc5, 0, 1 + loc4, 0 + loc5, 0, 1 + loc4, 1 + loc5, 0, 0 + loc4, 1 + loc5, 0);
			this.face_.setUVT(this.face_.uvt_);
			return this.face_.draw(param1, param2);
		}
	}
}
