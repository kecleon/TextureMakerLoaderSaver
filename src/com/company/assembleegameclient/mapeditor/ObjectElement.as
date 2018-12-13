package com.company.assembleegameclient.mapeditor {
	import com.company.assembleegameclient.objects.ObjectLibrary;
	import com.company.assembleegameclient.objects.animation.Animations;
	import com.company.assembleegameclient.objects.animation.AnimationsData;
	import com.company.assembleegameclient.ui.tooltip.ToolTip;

	import flash.display.Bitmap;
	import flash.display.BitmapData;

	class ObjectElement extends Element {


		public var objXML_:XML;

		function ObjectElement(param1:XML) {
			var loc3:Animations = null;
			var loc5:Bitmap = null;
			var loc7:BitmapData = null;
			super(int(param1.@type));
			this.objXML_ = param1;
			var loc2:BitmapData = ObjectLibrary.getRedrawnTextureFromType(type_, 100, true, false);
			var loc4:AnimationsData = ObjectLibrary.typeToAnimationsData_[int(param1.@type)];
			if (loc4 != null) {
				loc3 = new Animations(loc4);
				loc7 = loc3.getTexture(0.4);
				if (loc7 != null) {
					loc2 = loc7;
				}
			}
			loc5 = new Bitmap(loc2);
			var loc6:Number = (WIDTH - 4) / Math.max(loc5.width, loc5.height);
			loc5.scaleX = loc5.scaleY = loc6;
			loc5.x = WIDTH / 2 - loc5.width / 2;
			loc5.y = HEIGHT / 2 - loc5.height / 2;
			addChild(loc5);
		}

		override protected function getToolTip():ToolTip {
			return new ObjectTypeToolTip(this.objXML_);
		}

		override public function get objectBitmap():BitmapData {
			return ObjectLibrary.getRedrawnTextureFromType(type_, 200, true, false);
		}
	}
}
