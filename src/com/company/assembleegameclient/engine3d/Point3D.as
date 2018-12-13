package com.company.assembleegameclient.engine3d {
	import com.company.assembleegameclient.map.Camera;
	import com.company.util.Trig;

	import flash.display.BitmapData;
	import flash.display.GraphicsBitmapFill;
	import flash.display.GraphicsEndFill;
	import flash.display.GraphicsPath;
	import flash.display.GraphicsPathCommand;
	import flash.display.GraphicsSolidFill;
	import flash.display.IGraphicsData;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Utils3D;
	import flash.geom.Vector3D;

	public class Point3D {

		private static const commands_:Vector.<int> = new <int>[GraphicsPathCommand.MOVE_TO, GraphicsPathCommand.LINE_TO, GraphicsPathCommand.LINE_TO, GraphicsPathCommand.LINE_TO];

		private static const END_FILL:GraphicsEndFill = new GraphicsEndFill();


		public var size_:Number;

		public var posS_:Vector3D;

		private const data_:Vector.<Number> = new Vector.<Number>();

		private const path_:GraphicsPath = new GraphicsPath(commands_, this.data_);

		private const bitmapFill_:GraphicsBitmapFill = new GraphicsBitmapFill(null, new Matrix(), false, false);

		private const solidFill_:GraphicsSolidFill = new GraphicsSolidFill(0, 1);

		public function Point3D(param1:Number) {
			super();
			this.size_ = param1;
		}

		public function setSize(param1:Number):void {
			this.size_ = param1;
		}

		public function draw(param1:Vector.<IGraphicsData>, param2:Vector3D, param3:Number, param4:Matrix3D, param5:Camera, param6:BitmapData, param7:uint = 0):void {
			var loc10:Number = NaN;
			var loc11:Number = NaN;
			var loc12:Matrix = null;
			this.posS_ = Utils3D.projectVector(param4, param2);
			if (this.posS_.w < 0) {
				return;
			}
			var loc8:Number = this.posS_.w * Math.sin(param5.pp_.fieldOfView / 2 * Trig.toRadians);
			var loc9:Number = this.size_ / loc8;
			this.data_.length = 0;
			if (param3 == 0) {
				this.data_.push(this.posS_.x - loc9, this.posS_.y - loc9, this.posS_.x + loc9, this.posS_.y - loc9, this.posS_.x + loc9, this.posS_.y + loc9, this.posS_.x - loc9, this.posS_.y + loc9);
			} else {
				loc10 = Math.cos(param3);
				loc11 = Math.sin(param3);
				this.data_.push(this.posS_.x + (loc10 * -loc9 + loc11 * -loc9), this.posS_.y + (loc11 * -loc9 - loc10 * -loc9), this.posS_.x + (loc10 * loc9 + loc11 * -loc9), this.posS_.y + (loc11 * loc9 - loc10 * -loc9), this.posS_.x + (loc10 * loc9 + loc11 * loc9), this.posS_.y + (loc11 * loc9 - loc10 * loc9), this.posS_.x + (loc10 * -loc9 + loc11 * loc9), this.posS_.y + (loc11 * -loc9 - loc10 * loc9));
			}
			if (param6 != null) {
				this.bitmapFill_.bitmapData = param6;
				loc12 = this.bitmapFill_.matrix;
				loc12.identity();
				loc12.scale(2 * loc9 / param6.width, 2 * loc9 / param6.height);
				loc12.translate(-loc9, -loc9);
				loc12.rotate(param3);
				loc12.translate(this.posS_.x, this.posS_.y);
				param1.push(this.bitmapFill_);
			} else {
				this.solidFill_.color = param7;
				param1.push(this.solidFill_);
			}
			param1.push(this.path_);
			param1.push(END_FILL);
		}
	}
}
