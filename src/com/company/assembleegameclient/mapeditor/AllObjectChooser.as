 
package com.company.assembleegameclient.mapeditor {
	import com.company.assembleegameclient.objects.ObjectLibrary;
	import com.company.util.MoreStringUtil;
	import flash.utils.Dictionary;
	
	class AllObjectChooser extends Chooser {
		
		public static const GROUP_NAME_MAP_OBJECTS:String = "All Map Objects";
		
		public static const GROUP_NAME_GAME_OBJECTS:String = "All Game Objects";
		 
		
		private var cache:Dictionary;
		
		private var lastSearch:String = "";
		
		function AllObjectChooser() {
			super(Layer.OBJECT);
			this.cache = new Dictionary();
		}
		
		public function getLastSearch() : String {
			return this.lastSearch;
		}
		
		public function reloadObjects(param1:String = "", param2:String = "All Map Objects") : void {
			var loc4:RegExp = null;
			var loc6:String = null;
			var loc7:int = 0;
			var loc8:XML = null;
			var loc9:int = 0;
			var loc10:ObjectElement = null;
			removeElements();
			this.lastSearch = param1;
			var loc3:Vector.<String> = new Vector.<String>();
			if(param1 != "") {
				loc4 = new RegExp(param1,"gix");
			}
			var loc5:Dictionary = GroupDivider.GROUPS[param2];
			for each(loc8 in loc5) {
				loc6 = String(loc8.@id);
				loc7 = int(loc8.@type);
				if(loc4 == null || loc6.search(loc4) >= 0 || loc7 == int(param1)) {
					loc3.push(loc6);
				}
			}
			loc3.sort(MoreStringUtil.cmp);
			for each(loc6 in loc3) {
				loc9 = ObjectLibrary.idToType_[loc6];
				loc8 = ObjectLibrary.xmlLibrary_[loc9];
				if(!this.cache[loc9]) {
					loc10 = new ObjectElement(loc8);
					if(param2 == GROUP_NAME_GAME_OBJECTS) {
						loc10.downloadOnly = true;
					}
					this.cache[loc9] = loc10;
				} else {
					loc10 = this.cache[loc9];
				}
				addElement(loc10);
			}
			hasBeenLoaded = true;
			scrollBar_.setIndicatorSize(HEIGHT,elementContainer_.height,true);
		}
	}
}
