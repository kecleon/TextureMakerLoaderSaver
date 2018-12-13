package com.company.assembleegameclient.objects {
	import com.company.assembleegameclient.map.Camera;
	import com.company.assembleegameclient.util.TextureRedrawer;

	import flash.display.BitmapData;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	import kabam.rotmg.core.StaticInjectorContext;
	import kabam.rotmg.language.model.StringMap;
	import kabam.rotmg.text.model.FontModel;

	public class Sign extends GameObject {


		private var stringMap:StringMap;

		private var fontModel:FontModel;

		public function Sign(param1:XML) {
			super(param1);
			texture_ = null;
			this.stringMap = StaticInjectorContext.getInjector().getInstance(StringMap);
			this.fontModel = StaticInjectorContext.getInjector().getInstance(FontModel);
		}

		override protected function getTexture(param1:Camera, param2:int):BitmapData {
			if (texture_ != null) {
				return texture_;
			}
			var loc3:TextField = new TextField();
			loc3.multiline = true;
			loc3.wordWrap = false;
			loc3.autoSize = TextFieldAutoSize.LEFT;
			loc3.textColor = 16777215;
			loc3.embedFonts = true;
			var loc4:TextFormat = new TextFormat();
			loc4.align = TextFormatAlign.CENTER;
			loc4.font = this.fontModel.getFont().getName();
			loc4.size = 24;
			loc4.color = 16777215;
			loc4.bold = true;
			loc3.defaultTextFormat = loc4;
			var loc5:String = this.stringMap.getValue(this.stripCurlyBrackets(name_));
			if (loc5 == null) {
				loc5 = name_ != null ? name_ : "null";
			}
			loc3.text = loc5.split("|").join("\n");
			var loc6:BitmapData = new BitmapDataSpy(loc3.width, loc3.height, true, 0);
			loc6.draw(loc3);
			texture_ = TextureRedrawer.redraw(loc6, size_, false, 0);
			return texture_;
		}

		private function stripCurlyBrackets(param1:String):String {
			var loc2:Boolean = param1 != null && param1.charAt(0) == "{" && param1.charAt(param1.length - 1) == "}";
			return !!loc2 ? param1.substr(1, param1.length - 2) : param1;
		}
	}
}
