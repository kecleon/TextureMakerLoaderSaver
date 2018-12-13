 
package kabam.rotmg.text.model {
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class FontModel {
		
		public static const MyriadPro:Class = FontModel_MyriadPro;
		
		public static const MyriadPro_Bold:Class = FontModel_MyriadPro_Bold;
		
		public static var DEFAULT_FONT_NAME:String = "";
		 
		
		private var fontInfo:FontInfo;
		
		public function FontModel() {
			super();
			Font.registerFont(MyriadPro);
			Font.registerFont(MyriadPro_Bold);
			var loc1:Font = new MyriadPro();
			DEFAULT_FONT_NAME = loc1.fontName;
			this.fontInfo = new FontInfo();
			this.fontInfo.setName(loc1.fontName);
		}
		
		public function getFont() : FontInfo {
			return this.fontInfo;
		}
		
		public function apply(param1:TextField, param2:int, param3:uint, param4:Boolean, param5:Boolean = false) : TextFormat {
			var loc6:TextFormat = param1.defaultTextFormat;
			loc6.size = param2;
			loc6.color = param3;
			loc6.font = this.getFont().getName();
			loc6.bold = param4;
			if(param5) {
				loc6.align = "center";
			}
			param1.defaultTextFormat = loc6;
			param1.setTextFormat(loc6);
			return loc6;
		}
		
		public function getFormat(param1:TextField, param2:int, param3:uint, param4:Boolean) : TextFormat {
			var loc5:TextFormat = param1.defaultTextFormat;
			loc5.size = param2;
			loc5.color = param3;
			loc5.font = this.getFont().getName();
			loc5.bold = param4;
			return loc5;
		}
	}
}
