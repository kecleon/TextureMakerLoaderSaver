 
package kabam.rotmg.text.view.stringBuilder {
	import kabam.rotmg.language.model.StringMap;
	
	public class PatternBuilder implements StringBuilder {
		 
		
		private const PATTERN:RegExp = /(\{([^\{]+?)\})/gi;
		
		private var pattern:String = "";
		
		private var keys:Array;
		
		private var provider:StringMap;
		
		public function PatternBuilder() {
			super();
		}
		
		public function setPattern(param1:String) : PatternBuilder {
			this.pattern = param1;
			return this;
		}
		
		public function setStringMap(param1:StringMap) : void {
			this.provider = param1;
		}
		
		public function getString() : String {
			var loc2:String = null;
			this.keys = this.pattern.match(this.PATTERN);
			var loc1:String = this.pattern;
			for each(loc2 in this.keys) {
				loc1 = loc1.replace(loc2,this.provider.getValue(loc2.substr(1,loc2.length - 2)));
			}
			return loc1.replace(/\\n/g,"\n");
		}
	}
}
