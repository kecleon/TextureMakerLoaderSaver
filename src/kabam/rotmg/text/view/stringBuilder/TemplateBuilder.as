 
package kabam.rotmg.text.view.stringBuilder {
	import kabam.rotmg.language.model.StringMap;
	
	public class TemplateBuilder implements StringBuilder {
		 
		
		private var template:String;
		
		private var tokens:Object;
		
		private var postfix:String = "";
		
		private var prefix:String = "";
		
		private var provider:StringMap;
		
		public function TemplateBuilder() {
			super();
		}
		
		public function setTemplate(param1:String, param2:Object = null) : TemplateBuilder {
			this.template = param1;
			this.tokens = param2;
			return this;
		}
		
		public function setPrefix(param1:String) : TemplateBuilder {
			this.prefix = param1;
			return this;
		}
		
		public function setPostfix(param1:String) : TemplateBuilder {
			this.postfix = param1;
			return this;
		}
		
		public function setStringMap(param1:StringMap) : void {
			this.provider = param1;
		}
		
		public function getString() : String {
			var loc2:* = null;
			var loc3:String = null;
			var loc1:String = this.template;
			for(loc2 in this.tokens) {
				loc3 = this.tokens[loc2];
				if(loc3.charAt(0) == "{" && loc3.charAt(loc3.length - 1) == "}") {
					loc3 = this.provider.getValue(loc3.substr(1,loc3.length - 2));
				}
				loc1 = loc1.replace("{" + loc2 + "}",loc3);
			}
			loc1 = loc1.replace(/\\n/g,"\n");
			return this.prefix + loc1 + this.postfix;
		}
	}
}
