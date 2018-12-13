package com.company.assembleegameclient.mapeditor {
	import com.company.assembleegameclient.map.RegionLibrary;
	import com.company.assembleegameclient.ui.tooltip.ToolTip;

	import flash.display.Shape;

	public class RegionElement extends Element {


		public var regionXML_:XML;

		public function RegionElement(param1:XML) {
			var loc2:Shape = null;
			super(int(param1.@type));
			this.regionXML_ = param1;
			loc2 = new Shape();
			loc2.graphics.beginFill(RegionLibrary.getColor(type_), 0.5);
			loc2.graphics.drawRect(0, 0, WIDTH - 8, HEIGHT - 8);
			loc2.graphics.endFill();
			loc2.x = WIDTH / 2 - loc2.width / 2;
			loc2.y = HEIGHT / 2 - loc2.height / 2;
			addChild(loc2);
		}

		override protected function getToolTip():ToolTip {
			return new RegionTypeToolTip(this.regionXML_);
		}
	}
}
