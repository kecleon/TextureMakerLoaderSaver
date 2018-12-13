package com.company.assembleegameclient.ui.icons {
	import flash.display.BitmapData;

	public class IconButtonFactory {


		public function IconButtonFactory() {
			super();
		}

		public function create(param1:BitmapData, param2:String, param3:String, param4:String, param5:int = 0):IconButton {
			var loc6:IconButton = new IconButton(param1, param2, param3, param4, param5);
			return loc6;
		}
	}
}
