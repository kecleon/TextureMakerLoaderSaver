 
package com.company.assembleegameclient.mapeditor {
	import com.company.assembleegameclient.objects.ObjectLibrary;
	import com.company.util.MoreStringUtil;
	import flash.utils.Dictionary;
	
	public class Object3DChooser extends Chooser {
		 
		
		private var cache:Dictionary;
		
		private var lastSearch:String = "";
		
		public function Object3DChooser() {
			super(Layer.OBJECT);
			this.cache = new Dictionary();
		}
		
		public function getLastSearch() : String {
			return this.lastSearch;
		}
		
		public function reloadObjects(param1:String = "") : void {
			var loc3:RegExp = null;
			var loc5:String = null;
			var loc6:XML = null;
			var loc7:int = 0;
			var loc8:ObjectElement = null;
			removeElements();
			this.lastSearch = param1;
			var loc2:Vector.<String> = new Vector.<String>();
			if(param1 != "") {
				loc3 = new RegExp(param1,"gix");
			}
			var loc4:Dictionary = GroupDivider.GROUPS["3D Objects"];
			for each(loc6 in loc4) {
				loc5 = String(loc6.@id);
				if(loc3 == null || loc5.search(loc3) >= 0) {
					loc2.push(loc5);
				}
			}
			loc2.sort(MoreStringUtil.cmp);
			for each(loc5 in loc2) {
				loc7 = ObjectLibrary.idToType_[loc5];
				loc6 = ObjectLibrary.xmlLibrary_[loc7];
				if(!this.cache[loc7]) {
					loc8 = new ObjectElement(loc6);
					this.cache[loc7] = loc8;
				} else {
					loc8 = this.cache[loc7];
				}
				addElement(loc8);
			}
			hasBeenLoaded = true;
			scrollBar_.setIndicatorSize(HEIGHT,elementContainer_.height,true);
		}
	}
}
