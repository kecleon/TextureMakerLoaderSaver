package com.company.assembleegameclient.mapeditor {
	import com.company.assembleegameclient.map.AnimateProperties;
	import com.company.assembleegameclient.map.Camera;
	import com.company.assembleegameclient.map.GroundLibrary;
	import com.company.assembleegameclient.map.SquareFace;
	import com.company.assembleegameclient.ui.tooltip.ToolTip;

	import flash.display.BitmapData;
	import flash.display.IGraphicsData;
	import flash.display.Shape;
	import flash.geom.Rectangle;

	class GroundElement extends Element {

		private static const VIN:Vector.<Number> = new <Number>[0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 1, 0];

		private static const SCALE:Number = 0.6;


		public var groundXML_:XML;

		private var tileShape_:Shape;

		private var tileBD:BitmapData;

		function GroundElement(param1:XML) {
			super(int(param1.@type));
			this.groundXML_ = param1;
			var loc2:Vector.<IGraphicsData> = new Vector.<IGraphicsData>();
			var loc3:Camera = new Camera();
			loc3.configure(0.5, 0.5, 12, Math.PI / 4, new Rectangle(-100, -100, 200, 200));
			this.tileBD = GroundLibrary.getBitmapData(type_);
			var loc4:SquareFace = new SquareFace(this.tileBD, VIN, 0, 0, AnimateProperties.NO_ANIMATE, 0, 0);
			loc4.draw(loc2, loc3, 0);
			this.tileShape_ = new Shape();
			this.tileShape_.graphics.drawGraphicsData(loc2);
			this.tileShape_.scaleX = this.tileShape_.scaleY = SCALE;
			this.tileShape_.x = WIDTH / 2;
			this.tileShape_.y = HEIGHT / 2;
			addChild(this.tileShape_);
		}

		override protected function getToolTip():ToolTip {
			return new GroundTypeToolTip(this.groundXML_);
		}

		override public function get objectBitmap():BitmapData {
			return this.tileBD;
		}
	}
}
