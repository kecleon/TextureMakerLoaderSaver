 
package kabam.rotmg.language.model {
	import kabam.rotmg.text.model.DebugTextInfo;
	
	public class DebugStringMap implements StringMap {
		 
		
		[Inject]
		public var delegate:StringMap;
		
		[Inject]
		public var languageModel:LanguageModel;
		
		public var debugTextInfos:Vector.<DebugTextInfo>;
		
		public function DebugStringMap() {
			this.debugTextInfos = new Vector.<DebugTextInfo>();
			super();
		}
		
		public function hasKey(param1:String) : Boolean {
			return true;
		}
		
		public function getValue(param1:String) : String {
			if(param1 != "" && this.isInvalid(param1)) {
				return param1;
			}
			return this.delegate.getValue(param1);
		}
		
		private function isInvalid(param1:String) : Boolean {
			return this.hasNo(param1) || this.hasWrongLanguage(param1);
		}
		
		private function hasNo(param1:String) : Boolean {
			return !this.delegate.hasKey(param1);
		}
		
		private function pushDebugInfo(param1:String) : void {
			var loc2:String = this.getLanguageFamily(param1);
			var loc3:DebugTextInfo = new DebugTextInfo();
			loc3.key = param1;
			loc3.hasKey = this.delegate.hasKey(param1);
			loc3.languageFamily = loc2;
			loc3.value = this.delegate.getValue(param1);
			this.debugTextInfos.push(loc3);
		}
		
		private function hasWrongLanguage(param1:String) : Boolean {
			return this.getLanguageFamily(param1) != this.languageModel.getLanguage();
		}
		
		public function clear() : void {
		}
		
		public function setValue(param1:String, param2:String, param3:String) : void {
			this.delegate.setValue(param1,param2,param3);
		}
		
		public function getLanguageFamily(param1:String) : String {
			return this.delegate.getLanguageFamily(param1);
		}
	}
}
