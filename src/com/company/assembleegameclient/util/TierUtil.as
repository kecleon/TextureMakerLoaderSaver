 
package com.company.assembleegameclient.util {
	import com.company.assembleegameclient.ui.tooltip.TooltipHelper;
	import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
	import io.decagames.rotmg.ui.labels.UILabel;
	
	public class TierUtil {
		 
		
		public function TierUtil() {
			super();
		}
		
		public static function getTierTag(param1:XML, param2:int = 12) : UILabel {
			var loc9:UILabel = null;
			var loc10:Number = NaN;
			var loc11:String = null;
			var loc3:* = isPet(param1) == false;
			var loc4:* = param1.hasOwnProperty("Consumable") == false;
			var loc5:* = param1.hasOwnProperty("InvUse") == false;
			var loc6:* = param1.hasOwnProperty("Treasure") == false;
			var loc7:* = param1.hasOwnProperty("PetFood") == false;
			var loc8:Boolean = param1.hasOwnProperty("Tier");
			if(loc3 && loc4 && loc5 && loc6 && loc7) {
				loc9 = new UILabel();
				if(loc8) {
					loc10 = 16777215;
					loc11 = "T" + param1.Tier;
				} else if(param1.hasOwnProperty("@setType")) {
					loc10 = TooltipHelper.SET_COLOR;
					loc11 = "ST";
				} else {
					loc10 = TooltipHelper.UNTIERED_COLOR;
					loc11 = "UT";
				}
				loc9.text = loc11;
				DefaultLabelFormat.tierLevelLabel(loc9,param2,loc10);
				return loc9;
			}
			return null;
		}
		
		public static function isPet(param1:XML) : Boolean {
			var activateTags:XMLList = null;
			var itemDataXML:XML = param1;
			activateTags = itemDataXML.Activate.(text() == "PermaPet");
			return activateTags.length() >= 1;
		}
	}
}
