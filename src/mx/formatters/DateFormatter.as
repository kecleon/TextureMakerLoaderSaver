 
package mx.formatters {
	import mx.core.mx_internal;
	
	use namespace mx_internal;
	
	public class DateFormatter extends Formatter {
		
		mx_internal static const VERSION:String = "4.6.0.23201";
		
		private static const VALID_PATTERN_CHARS:String = "Y,M,D,A,E,H,J,K,L,N,S,Q";
		 
		
		private var _formatString:String;
		
		private var formatStringOverride:String;
		
		public function DateFormatter() {
			super();
		}
		
		public static function parseDateString(param1:String) : Date {
			var loc14:String = null;
			var loc15:int = 0;
			var loc16:int = 0;
			var loc17:String = null;
			var loc18:String = null;
			var loc19:int = 0;
			if(!param1 || param1 == "") {
				return null;
			}
			var loc2:int = -1;
			var loc3:int = -1;
			var loc4:int = -1;
			var loc5:int = -1;
			var loc6:int = -1;
			var loc7:int = -1;
			var loc8:String = "";
			var loc9:Object = 0;
			var loc10:int = 0;
			var loc11:int = param1.length;
			var loc12:RegExp = /(GMT|UTC)((\+|-)\d\d\d\d )?/ig;
			param1 = param1.replace(loc12,"");
			while(loc10 < loc11) {
				loc8 = param1.charAt(loc10);
				loc10++;
				if(!(loc8 <= " " || loc8 == ",")) {
					if(loc8 == "/" || loc8 == ":" || loc8 == "+" || loc8 == "-") {
						loc9 = loc8;
					} else if("a" <= loc8 && loc8 <= "z" || "A" <= loc8 && loc8 <= "Z") {
						loc14 = loc8;
						while(loc10 < loc11) {
							loc8 = param1.charAt(loc10);
							if(!("a" <= loc8 && loc8 <= "z" || "A" <= loc8 && loc8 <= "Z")) {
								break;
							}
							loc14 = loc14 + loc8;
							loc10++;
						}
						loc15 = DateBase.defaultStringKey.length;
						loc16 = 0;
						while(loc16 < loc15) {
							loc17 = String(DateBase.defaultStringKey[loc16]);
							if(loc17.toLowerCase() == loc14.toLowerCase() || loc17.toLowerCase().substr(0,3) == loc14.toLowerCase()) {
								if(loc16 == 13) {
									if(loc5 > 12 || loc5 < 1) {
										break;
									}
									if(loc5 < 12) {
										loc5 = loc5 + 12;
									}
								} else if(loc16 == 12) {
									if(loc5 > 12 || loc5 < 1) {
										break;
									}
									if(loc5 == 12) {
										loc5 = 0;
									}
								} else if(loc16 < 12) {
									if(loc3 < 0) {
										loc3 = loc16;
									} else {
										break;
									}
								}
								break;
							}
							loc16++;
						}
						loc9 = 0;
					} else if("0" <= loc8 && loc8 <= "9") {
						loc18 = loc8;
						while("0" <= (loc8 = param1.charAt(loc10)) && loc8 <= "9" && loc10 < loc11) {
							loc18 = loc18 + loc8;
							loc10++;
						}
						loc19 = int(loc18);
						if(loc19 >= 70) {
							if(loc2 != -1) {
								break;
							}
							if(loc8 <= " " || loc8 == "," || loc8 == "." || loc8 == "/" || loc8 == "-" || loc10 >= loc11) {
								loc2 = loc19;
							} else {
								break;
							}
						} else if(loc8 == "/" || loc8 == "-" || loc8 == ".") {
							if(loc3 < 0) {
								loc3 = loc19 - 1;
							} else if(loc4 < 0) {
								loc4 = loc19;
							} else {
								break;
							}
						} else if(loc8 == ":") {
							if(loc5 < 0) {
								loc5 = loc19;
							} else if(loc6 < 0) {
								loc6 = loc19;
							} else {
								break;
							}
						} else if(loc5 >= 0 && loc6 < 0) {
							loc6 = loc19;
						} else if(loc6 >= 0 && loc7 < 0) {
							loc7 = loc19;
						} else if(loc4 < 0) {
							loc4 = loc19;
						} else if(loc2 < 0 && loc3 >= 0 && loc4 >= 0) {
							loc2 = 2000 + loc19;
						} else {
							break;
						}
						loc9 = 0;
					}
				}
			}
			if(loc2 < 0 || loc3 < 0 || loc3 > 11 || loc4 < 1 || loc4 > 31) {
				return null;
			}
			if(loc7 < 0) {
				loc7 = 0;
			}
			if(loc6 < 0) {
				loc6 = 0;
			}
			if(loc5 < 0) {
				loc5 = 0;
			}
			var loc13:Date = new Date(loc2,loc3,loc4,loc5,loc6,loc7);
			if(loc4 != loc13.getDate() || loc3 != loc13.getMonth()) {
				return null;
			}
			return loc13;
		}
		
		public function get formatString() : String {
			return this._formatString;
		}
		
		public function set formatString(param1:String) : void {
			this.formatStringOverride = param1;
			this._formatString = param1 != null?param1:resourceManager.getString("SharedResources","dateFormat");
		}
		
		override protected function resourcesChanged() : void {
			super.resourcesChanged();
			this.formatString = this.formatStringOverride;
		}
		
		override public function format(param1:Object) : String {
			var loc2:String = null;
			if(error) {
				error = null;
			}
			if(!param1 || param1 is String && param1 == "") {
				error = defaultInvalidValueError;
				return "";
			}
			if(param1 is String) {
				param1 = DateFormatter.parseDateString(String(param1));
				if(!param1) {
					error = defaultInvalidValueError;
					return "";
				}
			} else if(!(param1 is Date)) {
				error = defaultInvalidValueError;
				return "";
			}
			var loc3:int = 0;
			var loc4:String = "";
			var loc5:int = this.formatString.length;
			var loc6:int = 0;
			while(loc6 < loc5) {
				loc2 = this.formatString.charAt(loc6);
				if(VALID_PATTERN_CHARS.indexOf(loc2) != -1 && loc2 != ",") {
					loc3++;
					if(loc4.indexOf(loc2) == -1) {
						loc4 = loc4 + loc2;
					} else if(loc2 != this.formatString.charAt(Math.max(loc6 - 1,0))) {
						error = defaultInvalidFormatError;
						return "";
					}
				}
				loc6++;
			}
			if(loc3 < 1) {
				error = defaultInvalidFormatError;
				return "";
			}
			var loc7:StringFormatter = new StringFormatter(this.formatString,VALID_PATTERN_CHARS,DateBase.extractTokenDate);
			return loc7.formatValue(param1);
		}
	}
}
