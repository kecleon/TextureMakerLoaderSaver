package com.company.assembleegameclient.mapeditor {
	import com.company.assembleegameclient.map.GroundLibrary;
	import com.company.assembleegameclient.objects.ObjectLibrary;
	import com.company.util.MoreStringUtil;

	import flash.events.Event;
	import flash.utils.Dictionary;

	class GroundChooser extends Chooser {


		private var cache:Dictionary;

		private var lastSearch:String = "";

		function GroundChooser() {
			super(Layer.GROUND);
			this._init();
		}

		private function _init():void {
			this.cache = new Dictionary();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		public function getLastSearch():String {
			return this.lastSearch;
		}

		public function reloadObjects(param1:String, param2:String = "ALL"):void {
			var loc4:RegExp = null;
			var loc6:String = null;
			var loc7:XML = null;
			var loc8:int = 0;
			var loc9:GroundElement = null;
			removeElements();
			this.lastSearch = param1;
			var loc3:Vector.<String> = new Vector.<String>();
			if (param1 != "") {
				loc4 = new RegExp(param1, "gix");
			}
			var loc5:Dictionary = GroupDivider.GROUPS["Ground"];
			for each(loc7 in loc5) {
				loc6 = String(loc7.@id);
				if (!(param2 != "ALL" && !this.runFilter(loc7, param2))) {
					if (loc4 == null || loc6.search(loc4) >= 0) {
						loc3.push(loc6);
					}
				}
			}
			loc3.sort(MoreStringUtil.cmp);
			for each(loc6 in loc3) {
				loc8 = GroundLibrary.idToType_[loc6];
				loc7 = GroundLibrary.xmlLibrary_[loc8];
				if (!this.cache[loc8]) {
					loc9 = new GroundElement(loc7);
					this.cache[loc8] = loc9;
				} else {
					loc9 = this.cache[loc8];
				}
				addElement(loc9);
			}
			hasBeenLoaded = true;
			scrollBar_.setIndicatorSize(HEIGHT, elementContainer_.height, true);
		}

		private function runFilter(param1:XML, param2:String):Boolean {
			var loc3:int = 0;
			switch (param2) {
				case ObjectLibrary.TILE_FILTER_LIST[1]:
					return !param1.hasOwnProperty("NoWalk");
				case ObjectLibrary.TILE_FILTER_LIST[2]:
					return param1.hasOwnProperty("NoWalk");
				case ObjectLibrary.TILE_FILTER_LIST[3]:
					return param1.hasOwnProperty("Speed") && Number(param1.elements("Speed")) < 1;
				case ObjectLibrary.TILE_FILTER_LIST[4]:
					return !param1.hasOwnProperty("Speed") || Number(param1.elements("Speed")) >= 1;
				default:
					return true;
			}
		}
	}
}
