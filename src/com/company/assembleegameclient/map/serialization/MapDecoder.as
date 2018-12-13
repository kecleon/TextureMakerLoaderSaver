package com.company.assembleegameclient.map.serialization {
	import com.company.assembleegameclient.map.GroundLibrary;
	import com.company.assembleegameclient.map.Map;
	import com.company.assembleegameclient.objects.BasicObject;
	import com.company.assembleegameclient.objects.GameObject;
	import com.company.assembleegameclient.objects.ObjectLibrary;
	import com.company.util.IntPoint;
	import com.hurlant.util.Base64;

	import flash.utils.ByteArray;

	import kabam.lib.json.JsonParser;
	import kabam.rotmg.core.StaticInjectorContext;

	public class MapDecoder {


		public function MapDecoder() {
			super();
		}

		private static function get json():JsonParser {
			return StaticInjectorContext.getInjector().getInstance(JsonParser);
		}

		public static function decodeMap(param1:String):Map {
			var loc2:Object = json.parse(param1);
			var loc3:Map = new Map(null);
			loc3.setProps(loc2["width"], loc2["height"], loc2["name"], loc2["back"], false, false);
			loc3.initialize();
			writeMapInternal(loc2, loc3, 0, 0);
			return loc3;
		}

		public static function writeMap(param1:String, param2:Map, param3:int, param4:int):void {
			var loc5:Object = json.parse(param1);
			writeMapInternal(loc5, param2, param3, param4);
		}

		public static function getSize(param1:String):IntPoint {
			var loc2:Object = json.parse(param1);
			return new IntPoint(loc2["width"], loc2["height"]);
		}

		private static function writeMapInternal(param1:Object, param2:Map, param3:int, param4:int):void {
			var loc7:int = 0;
			var loc8:int = 0;
			var loc9:Object = null;
			var loc10:Array = null;
			var loc11:int = 0;
			var loc12:Object = null;
			var loc13:GameObject = null;
			var loc5:ByteArray = Base64.decodeToByteArray(param1["data"]);
			loc5.uncompress();
			var loc6:Array = param1["dict"];
			loc7 = param4;
			while (loc7 < param4 + param1["height"]) {
				loc8 = param3;
				while (loc8 < param3 + param1["width"]) {
					loc9 = loc6[loc5.readShort()];
					if (!(loc8 < 0 || loc8 >= param2.width_ || loc7 < 0 || loc7 >= param2.height_)) {
						if (loc9.hasOwnProperty("ground")) {
							loc11 = GroundLibrary.idToType_[loc9["ground"]];
							param2.setGroundTile(loc8, loc7, loc11);
						}
						loc10 = loc9["objs"];
						if (loc10 != null) {
							for each(loc12 in loc10) {
								loc13 = getGameObject(loc12);
								loc13.objectId_ = BasicObject.getNextFakeObjectId();
								param2.addObj(loc13, loc8 + 0.5, loc7 + 0.5);
							}
						}
					}
					loc8++;
				}
				loc7++;
			}
		}

		public static function getGameObject(param1:Object):GameObject {
			var loc2:int = ObjectLibrary.idToType_[param1["id"]];
			var loc3:XML = ObjectLibrary.xmlLibrary_[loc2];
			var loc4:GameObject = ObjectLibrary.getObjectFromType(loc2);
			loc4.size_ = !!param1.hasOwnProperty("size") ? int(param1["size"]) : int(loc4.props_.getSize());
			return loc4;
		}
	}
}
