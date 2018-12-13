package com.company.assembleegameclient.mapeditor {
	import com.company.assembleegameclient.objects.ObjectLibrary;
	import com.company.util.MoreStringUtil;

	import flash.utils.Dictionary;

	public class DungeonChooser extends Chooser {


		public var currentDungon:String = "";

		private var cache:Dictionary;

		private var lastSearch:String = "";

		public function DungeonChooser() {
			super(Layer.OBJECT);
			this.cache = new Dictionary();
		}

		public function getLastSearch():String {
			return this.lastSearch;
		}

		public function reloadObjects(param1:String, param2:String):void {
			var loc4:RegExp = null;
			var loc6:String = null;
			var loc7:XML = null;
			var loc8:int = 0;
			var loc9:ObjectElement = null;
			this.currentDungon = param1;
			removeElements();
			this.lastSearch = param2;
			var loc3:Vector.<String> = new Vector.<String>();
			if (param2 != "") {
				loc4 = new RegExp(param2, "gix");
			}
			var loc5:Dictionary = GroupDivider.getDungeonsXML(this.currentDungon);
			for each(loc7 in loc5) {
				loc6 = String(loc7.@id);
				if (loc4 == null || loc6.search(loc4) >= 0) {
					loc3.push(loc6);
				}
			}
			loc3.sort(MoreStringUtil.cmp);
			for each(loc6 in loc3) {
				loc8 = ObjectLibrary.idToType_[loc6];
				loc7 = loc5[loc8];
				if (!this.cache[loc8]) {
					loc9 = new ObjectElement(loc7);
					this.cache[loc8] = loc9;
				} else {
					loc9 = this.cache[loc8];
				}
				addElement(loc9);
			}
			hasBeenLoaded = true;
			scrollBar_.setIndicatorSize(HEIGHT, elementContainer_.height, true);
		}
	}
}
