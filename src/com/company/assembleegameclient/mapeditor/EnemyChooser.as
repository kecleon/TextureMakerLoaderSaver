package com.company.assembleegameclient.mapeditor {
	import com.company.assembleegameclient.objects.ObjectLibrary;
	import com.company.util.MoreStringUtil;

	import flash.utils.Dictionary;

	class EnemyChooser extends Chooser {


		private var cache:Dictionary;

		private var lastSearch:String = "";

		private var filterTypes:Dictionary;

		function EnemyChooser() {
			this.filterTypes = new Dictionary(true);
			super(Layer.OBJECT);
			this.cache = new Dictionary();
			this.filterTypes[ObjectLibrary.ENEMY_FILTER_LIST[0]] = "";
			this.filterTypes[ObjectLibrary.ENEMY_FILTER_LIST[1]] = "MaxHitPoints";
			this.filterTypes[ObjectLibrary.ENEMY_FILTER_LIST[2]] = ObjectLibrary.ENEMY_FILTER_LIST[2];
		}

		public function getLastSearch():String {
			return this.lastSearch;
		}

		public function reloadObjects(param1:String, param2:String = "", param3:Number = 0, param4:Number = -1):void {
			var loc7:XML = null;
			var loc10:RegExp = null;
			var loc12:String = null;
			var loc13:int = 0;
			var loc14:ObjectElement = null;
			removeElements();
			this.lastSearch = param1;
			var loc5:* = true;
			var loc6:* = true;
			var loc8:Number = -1;
			var loc9:Vector.<String> = new Vector.<String>();
			if (param1 != "") {
				loc10 = new RegExp(param1, "gix");
			}
			if (param2 != "") {
				param2 = this.filterTypes[param2];
			}
			var loc11:Dictionary = GroupDivider.GROUPS["Enemies"];
			for each(loc7 in loc11) {
				loc12 = String(loc7.@id);
				if (!(loc10 != null && loc12.search(loc10) < 0)) {
					if (param2 != "") {
						loc8 = !!loc7.hasOwnProperty(param2) ? Number(Number(loc7.elements(param2))) : Number(-1);
						if (loc8 < 0) {
							continue;
						}
						loc5 = loc8 >= param3;
						loc6 = !(param4 > 0 && loc8 > param4);
					}
					if (loc5 && loc6) {
						loc9.push(loc12);
					}
				}
			}
			loc9.sort(MoreStringUtil.cmp);
			for each(loc12 in loc9) {
				loc13 = ObjectLibrary.idToType_[loc12];
				if (!this.cache[loc13]) {
					loc14 = new ObjectElement(ObjectLibrary.xmlLibrary_[loc13]);
					this.cache[loc13] = loc14;
				} else {
					loc14 = this.cache[loc13];
				}
				addElement(loc14);
			}
			hasBeenLoaded = true;
			scrollBar_.setIndicatorSize(HEIGHT, elementContainer_.height, true);
		}
	}
}
