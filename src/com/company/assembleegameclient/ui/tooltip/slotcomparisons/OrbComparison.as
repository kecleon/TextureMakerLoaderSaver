 
package com.company.assembleegameclient.ui.tooltip.slotcomparisons {
	import com.company.assembleegameclient.ui.tooltip.TooltipHelper;
	import kabam.rotmg.text.model.TextKey;
	import kabam.rotmg.text.view.stringBuilder.AppendingLineBuilder;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;
	
	public class OrbComparison extends SlotComparison {
		 
		
		public function OrbComparison() {
			super();
		}
		
		override protected function compareSlots(param1:XML, param2:XML) : void {
			var loc3:XML = null;
			var loc4:XML = null;
			var loc5:int = 0;
			var loc6:int = 0;
			var loc7:uint = 0;
			loc3 = this.getStasisBlastTag(param1);
			loc4 = this.getStasisBlastTag(param2);
			comparisonStringBuilder = new AppendingLineBuilder();
			if(loc3 != null && loc4 != null) {
				loc5 = int(loc3.@duration);
				loc6 = int(loc4.@duration);
				loc7 = getTextColor(loc5 - loc6);
				comparisonStringBuilder.pushParams(TextKey.STASIS_GROUP,{"stasis":new LineBuilder().setParams(TextKey.SEC_COUNT,{"duration":loc5}).setPrefix(TooltipHelper.getOpenTag(loc7)).setPostfix(TooltipHelper.getCloseTag())});
				processedTags[loc3.toXMLString()] = true;
				this.handleExceptions(param1);
			}
		}
		
		private function getStasisBlastTag(param1:XML) : XML {
			var matches:XMLList = null;
			var orbXML:XML = param1;
			matches = orbXML.Activate.(text() == "StasisBlast");
			return matches.length() == 1?matches[0]:null;
		}
		
		private function handleExceptions(param1:XML) : void {
			var selfTags:XMLList = null;
			var speedy:XML = null;
			var damaging:XML = null;
			var itemXML:XML = param1;
			if(itemXML.@id == "Orb of Conflict") {
				selfTags = itemXML.Activate.(text() == "ConditionEffectSelf");
				speedy = selfTags.(@effect == "Speedy")[0];
				damaging = selfTags.(@effect == "Damaging")[0];
				comparisonStringBuilder.pushParams(TextKey.EFFECT_ON_SELF,{"effect":""});
				comparisonStringBuilder.pushParams(TextKey.EFFECT_FOR_DURATION,{
					"effect":TextKey.wrapForTokenResolution(TextKey.ACTIVE_EFFECT_SPEEDY),
					"duration":speedy.@duration
				},TooltipHelper.getOpenTag(UNTIERED_COLOR),TooltipHelper.getCloseTag());
				comparisonStringBuilder.pushParams(TextKey.EFFECT_ON_SELF,{"effect":""});
				comparisonStringBuilder.pushParams(TextKey.EFFECT_FOR_DURATION,{
					"effect":TextKey.wrapForTokenResolution(TextKey.ACTIVE_EFFECT_DAMAGING),
					"duration":damaging.@duration
				},TooltipHelper.getOpenTag(UNTIERED_COLOR),TooltipHelper.getCloseTag());
				processedTags[speedy.toXMLString()] = true;
				processedTags[damaging.toXMLString()] = true;
			}
		}
	}
}
