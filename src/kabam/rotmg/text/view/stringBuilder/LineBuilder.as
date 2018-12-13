 
package kabam.rotmg.text.view.stringBuilder {
	import kabam.rotmg.core.StaticInjectorContext;
	import kabam.rotmg.language.model.StringMap;
	
	public class LineBuilder implements StringBuilder {
		 
		
		public var key:String;
		
		public var tokens:Object;
		
		private var postfix:String = "";
		
		private var prefix:String = "";
		
		private var map:StringMap;
		
		public function LineBuilder() {
			super();
		}
		
		public static function fromJSON(param1:String) : LineBuilder {
			var loc2:Object = JSON.parse(param1);
			return new LineBuilder().setParams(loc2.key,loc2.tokens);
		}
		
		public static function getLocalizedStringFromKey(param1:String, param2:Object = null) : String {
			var loc3:LineBuilder = new LineBuilder();
			loc3.setParams(param1,param2);
			var loc4:StringMap = StaticInjectorContext.getInjector().getInstance(StringMap);
			loc3.setStringMap(loc4);
			return loc3.getString() == ""?param1:loc3.getString();
		}
		
		public static function getLocalizedStringFromJSON(param1:String) : String {
			var loc2:LineBuilder = null;
			var loc3:StringMap = null;
			if(param1.charAt(0) == "{") {
				loc2 = LineBuilder.fromJSON(param1);
				loc3 = StaticInjectorContext.getInjector().getInstance(StringMap);
				loc2.setStringMap(loc3);
				return loc2.getString();
			}
			return param1;
		}
		
		public static function returnStringReplace(param1:String, param2:Object = null, param3:String = "", param4:String = "") : String {
			var loc6:* = null;
			var loc7:String = null;
			var loc8:* = null;
			var loc5:String = stripCurlyBrackets(param1);
			for(loc6 in param2) {
				loc7 = param2[loc6];
				loc8 = "{" + loc6 + "}";
				while(loc5.indexOf(loc8) != -1) {
					loc5 = loc5.replace(loc8,loc7);
				}
			}
			loc5 = loc5.replace(/\\n/g,"\n");
			return param3 + loc5 + param4;
		}
		
		public static function getLocalizedString2(param1:String, param2:Object = null) : String {
			var loc3:LineBuilder = new LineBuilder();
			loc3.setParams(param1,param2);
			var loc4:StringMap = StaticInjectorContext.getInjector().getInstance(StringMap);
			loc3.setStringMap(loc4);
			return loc3.getString();
		}
		
		private static function stripCurlyBrackets(param1:String) : String {
			var loc2:Boolean = param1 != null && param1.charAt(0) == "{" && param1.charAt(param1.length - 1) == "}";
			return !!loc2?param1.substr(1,param1.length - 2):param1;
		}
		
		public function toJson() : String {
			return JSON.stringify({
				"key":this.key,
				"tokens":this.tokens
			});
		}
		
		public function setParams(param1:String, param2:Object = null) : LineBuilder {
			this.key = param1 || "";
			this.tokens = param2;
			return this;
		}
		
		public function setPrefix(param1:String) : LineBuilder {
			this.prefix = param1;
			return this;
		}
		
		public function setPostfix(param1:String) : LineBuilder {
			this.postfix = param1;
			return this;
		}
		
		public function setStringMap(param1:StringMap) : void {
			this.map = param1;
		}
		
		public function getString() : String {
			var loc3:* = null;
			var loc4:String = null;
			var loc5:* = null;
			var loc1:String = stripCurlyBrackets(this.key);
			var loc2:String = this.map.getValue(loc1) || "";
			for(loc3 in this.tokens) {
				loc4 = this.tokens[loc3];
				if(loc4.charAt(0) == "{" && loc4.charAt(loc4.length - 1) == "}") {
					loc4 = this.map.getValue(loc4.substr(1,loc4.length - 2));
				}
				loc5 = "{" + loc3 + "}";
				while(loc2.indexOf(loc5) != -1) {
					loc2 = loc2.replace(loc5,loc4);
				}
			}
			loc2 = loc2.replace(/\\n/g,"\n");
			return this.prefix + loc2 + this.postfix;
		}
	}
}
