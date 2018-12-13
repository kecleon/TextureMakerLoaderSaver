 
package com.company.assembleegameclient.util {
	import flash.utils.Dictionary;
	
	public class FreeList {
		
		private static var dict_:Dictionary = new Dictionary();
		 
		
		public function FreeList() {
			super();
		}
		
		public static function newObject(param1:Class) : Object {
			var loc2:Vector.<Object> = dict_[param1];
			if(loc2 == null) {
				loc2 = new Vector.<Object>();
				dict_[param1] = loc2;
			} else if(loc2.length > 0) {
				return loc2.pop();
			}
			return new param1();
		}
		
		public static function storeObject(param1:*, param2:Object) : void {
			var loc3:Vector.<Object> = dict_[param1];
			if(loc3 == null) {
				loc3 = new Vector.<Object>();
				dict_[param1] = loc3;
			}
			loc3.push(param2);
		}
		
		public static function getObject(param1:*) : Object {
			var loc2:Vector.<Object> = dict_[param1];
			if(loc2 != null && loc2.length > 0) {
				return loc2.pop();
			}
			return null;
		}
		
		public static function dump(param1:*) : void {
			delete dict_[param1];
		}
		
		public static function deleteObject(param1:Object) : void {
			var loc2:Class = Object(param1).constructor;
			var loc3:Vector.<Object> = dict_[loc2];
			if(loc3 == null) {
				loc3 = new Vector.<Object>();
				dict_[loc2] = loc3;
			}
			loc3.push(param1);
		}
	}
}
