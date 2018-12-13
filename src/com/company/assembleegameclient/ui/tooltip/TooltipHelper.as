package com.company.assembleegameclient.ui.tooltip {
	public class TooltipHelper {

		public static const BETTER_COLOR:uint = 65280;

		public static const WORSE_COLOR:uint = 16711680;

		public static const NO_DIFF_COLOR:uint = 16777103;

		public static const WIS_BONUS_COLOR:uint = 4219875;

		public static const UNTIERED_COLOR:uint = 9055202;

		public static const SET_COLOR:uint = 16750848;


		public function TooltipHelper() {
			super();
		}

		public static function wrapInFontTag(param1:String, param2:String):String {
			var loc3:* = "<font color=\"" + param2 + "\">" + param1 + "</font>";
			return loc3;
		}

		public static function getOpenTag(param1:uint):String {
			return "<font color=\"#" + param1.toString(16) + "\">";
		}

		public static function getCloseTag():String {
			return "</font>";
		}

		public static function getFormattedRangeString(param1:Number):String {
			var loc2:Number = param1 - int(param1);
			return int(loc2 * 10) == 0 ? int(param1).toString() : param1.toFixed(1);
		}

		public static function compareAndGetPlural(param1:Number, param2:Number, param3:String, param4:Boolean = true, param5:Boolean = true):String {
			return wrapInFontTag(getPlural(param1, param3), "#" + getTextColor((!!param4 ? param1 - param2 : param2 - param1) * int(param5)).toString(16));
		}

		public static function compare(param1:Number, param2:Number, param3:Boolean = true, param4:String = "", param5:Boolean = false, param6:Boolean = true):String {
			return wrapInFontTag((!!param5 ? Math.abs(param1) : param1) + param4, "#" + getTextColor((!!param3 ? param1 - param2 : param2 - param1) * int(param6)).toString(16));
		}

		public static function getPlural(param1:Number, param2:String):String {
			var loc3:String = param1 + " " + param2;
			if (param1 != 1) {
				return loc3 + "s";
			}
			return loc3;
		}

		public static function getTextColor(param1:Number):uint {
			if (param1 < 0) {
				return WORSE_COLOR;
			}
			if (param1 > 0) {
				return BETTER_COLOR;
			}
			return NO_DIFF_COLOR;
		}
	}
}
