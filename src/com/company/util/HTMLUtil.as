 
package com.company.util {
	import flash.external.ExternalInterface;
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	import flash.xml.XMLNodeType;
	
	public class HTMLUtil {
		 
		
		public function HTMLUtil() {
			super();
		}
		
		public static function unescape(param1:String) : String {
			return new XMLDocument(param1).firstChild.nodeValue;
		}
		
		public static function escape(param1:String) : String {
			return XML(new XMLNode(XMLNodeType.TEXT_NODE,param1)).toXMLString();
		}
		
		public static function refreshPageNoParams() : void {
			var loc1:String = null;
			var loc2:Array = null;
			var loc3:String = null;
			if(ExternalInterface.available) {
				loc1 = ExternalInterface.call("window.location.toString");
				loc2 = loc1.split("?");
				if(loc2.length > 0) {
					loc3 = loc2[0];
					if(loc3.indexOf("www.kabam") != -1) {
						loc3 = "http://www.realmofthemadgod.com";
					}
					ExternalInterface.call("window.location.assign",loc3);
				}
			}
		}
	}
}
