 
package kabam.rotmg.language.model {
	import flash.net.SharedObject;
	import flash.utils.Dictionary;
	
	public class CookieLanguageModel implements LanguageModel {
		
		public static const DEFAULT_LOCALE:String = "en";
		 
		
		private var cookie:SharedObject;
		
		private var language:String;
		
		private var availableLanguages:Dictionary;
		
		public function CookieLanguageModel() {
			this.availableLanguages = this.makeAvailableLanguages();
			super();
			try {
				this.cookie = SharedObject.getLocal("RotMG","/");
				return;
			}
			catch(error:Error) {
				return;
			}
		}
		
		public function getLanguage() : String {
			return this.language = this.language || this.readLanguageFromCookie();
		}
		
		private function readLanguageFromCookie() : String {
			return this.cookie.data.locale || DEFAULT_LOCALE;
		}
		
		public function setLanguage(param1:String) : void {
			this.language = param1;
			try {
				this.cookie.data.locale = param1;
				this.cookie.flush();
				return;
			}
			catch(error:Error) {
				return;
			}
		}
		
		public function getLanguageFamily() : String {
			return this.getLanguage().substr(0,2).toLowerCase();
		}
		
		public function getLanguageNames() : Vector.<String> {
			var loc2:* = null;
			var loc1:Vector.<String> = new Vector.<String>();
			for(loc2 in this.availableLanguages) {
				loc1.push(loc2);
			}
			return loc1;
		}
		
		public function getLanguageCodeForName(param1:String) : String {
			return this.availableLanguages[param1];
		}
		
		public function getNameForLanguageCode(param1:String) : String {
			var loc2:String = null;
			var loc3:* = null;
			for(loc3 in this.availableLanguages) {
				if(this.availableLanguages[loc3] == param1) {
					loc2 = loc3;
				}
			}
			return loc2;
		}
		
		private function makeAvailableLanguages() : Dictionary {
			var loc1:Dictionary = new Dictionary();
			loc1["Languages.English"] = "en";
			loc1["Languages.French"] = "fr";
			loc1["Languages.Spanish"] = "es";
			loc1["Languages.Italian"] = "it";
			loc1["Languages.German"] = "de";
			loc1["Languages.Turkish"] = "tr";
			loc1["Languages.Russian"] = "ru";
			return loc1;
		}
	}
}
