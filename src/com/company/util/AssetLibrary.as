package com.company.util {
	import flash.display.BitmapData;
	import flash.media.Sound;
	import flash.media.SoundTransform;
	import flash.utils.Dictionary;

	public class AssetLibrary {

		private static var images_:Dictionary = new Dictionary();

		private static var imageSets_:Dictionary = new Dictionary();

		private static var sounds_:Dictionary = new Dictionary();

		private static var imageLookup_:Dictionary = new Dictionary();


		public function AssetLibrary(param1:StaticEnforcer) {
			super();
		}

		public static function addImage(param1:String, param2:BitmapData):void {
			images_[param1] = param2;
			imageLookup_[param2] = param1;
		}

		public static function addImageSet(param1:String, param2:BitmapData, param3:int, param4:int):void {
			images_[param1] = param2;
			var loc5:ImageSet = new ImageSet();
			loc5.addFromBitmapData(param2, param3, param4);
			imageSets_[param1] = loc5;
			var loc6:int = 0;
			while (loc6 < loc5.images_.length) {
				imageLookup_[loc5.images_[loc6]] = [param1, loc6];
				loc6++;
			}
		}

		public static function addToImageSet(param1:String, param2:BitmapData):void {
			var loc3:ImageSet = imageSets_[param1];
			if (loc3 == null) {
				loc3 = new ImageSet();
				imageSets_[param1] = loc3;
			}
			loc3.add(param2);
			var loc4:int = loc3.images_.length - 1;
			imageLookup_[loc3.images_[loc4]] = [param1, loc4];
		}

		public static function addSound(param1:String, param2:Class):void {
			var loc3:Array = sounds_[param1];
			if (loc3 == null) {
				sounds_[param1] = new Array();
			}
			sounds_[param1].push(param2);
		}

		public static function lookupImage(param1:BitmapData):Object {
			return imageLookup_[param1];
		}

		public static function getImage(param1:String):BitmapData {
			return images_[param1];
		}

		public static function getImageSet(param1:String):ImageSet {
			return imageSets_[param1];
		}

		public static function getImageFromSet(param1:String, param2:int):BitmapData {
			var loc3:ImageSet = imageSets_[param1];
			return loc3.images_[param2];
		}

		public static function getSound(param1:String):Sound {
			var loc2:Array = sounds_[param1];
			var loc3:int = Math.random() * loc2.length;
			return new sounds_[param1][loc3]();
		}

		public static function playSound(param1:String, param2:Number = 1.0):void {
			var loc3:Array = sounds_[param1];
			var loc4:int = Math.random() * loc3.length;
			var loc5:Sound = new sounds_[param1][loc4]();
			var loc6:SoundTransform = null;
			if (param2 != 1) {
				loc6 = new SoundTransform(param2);
			}
			loc5.play(0, 0, loc6);
		}
	}
}

class StaticEnforcer {


	function StaticEnforcer() {
		super();
	}
}
