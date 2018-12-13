 
package com.company.assembleegameclient.ui.tooltip.slotcomparisons {
	import com.company.assembleegameclient.ui.tooltip.TooltipHelper;
	import kabam.rotmg.text.model.TextKey;
	import kabam.rotmg.text.view.stringBuilder.AppendingLineBuilder;
	
	public class SealComparison extends SlotComparison {
		 
		
		private var healingTag:XML;
		
		private var damageTag:XML;
		
		private var otherHealingTag:XML;
		
		private var otherDamageTag:XML;
		
		public function SealComparison() {
			super();
		}
		
		override protected function compareSlots(param1:XML, param2:XML) : void {
			var tag:XML = null;
			var itemXML:XML = param1;
			var curItemXML:XML = param2;
			comparisonStringBuilder = new AppendingLineBuilder();
			this.healingTag = this.getEffectTag(itemXML,"Healing");
			this.damageTag = this.getEffectTag(itemXML,"Damaging");
			this.otherHealingTag = this.getEffectTag(curItemXML,"Healing");
			this.otherDamageTag = this.getEffectTag(curItemXML,"Damaging");
			if(this.canCompare()) {
				this.handleHealingText();
				this.handleDamagingText();
				if(itemXML.@id == "Seal of Blasphemous Prayer") {
					tag = itemXML.Activate.(text() == "ConditionEffectSelf")[0];
					comparisonStringBuilder.pushParams(TextKey.EFFECT_ON_SELF,{"effect":""});
					comparisonStringBuilder.pushParams(TextKey.EFFECT_FOR_DURATION,{
						"effect":TextKey.wrapForTokenResolution(TextKey.ACTIVE_EFFECT_INVULERABLE),
						"duration":tag.@duration
					},TooltipHelper.getOpenTag(UNTIERED_COLOR),TooltipHelper.getCloseTag());
					processedTags[tag.toXMLString()] = true;
				}
			}
		}
		
		private function canCompare() : Boolean {
			return this.healingTag != null && this.damageTag != null && this.otherHealingTag != null && this.otherDamageTag != null;
		}
		
		private function getEffectTag(param1:XML, param2:String) : XML {
			var matches:XMLList = null;
			var tag:XML = null;
			var xml:XML = param1;
			var effectName:String = param2;
			matches = xml.Activate.(text() == "ConditionEffectAura");
			for each(tag in matches) {
				if(tag.@effect == effectName) {
					return tag;
				}
			}
			return null;
		}
		
		private function handleHealingText() : void {
			var loc1:int = int(this.healingTag.@duration);
			var loc2:int = int(this.otherHealingTag.@duration);
			var loc3:Number = Number(this.healingTag.@range);
			var loc4:Number = Number(this.otherHealingTag.@range);
			var loc5:Number = 0.5 * loc1 * 0.5 * loc3;
			var loc6:Number = 0.5 * loc2 * 0.5 * loc4;
			var loc7:uint = getTextColor(loc5 - loc6);
			var loc8:AppendingLineBuilder = new AppendingLineBuilder();
			loc8.pushParams(TextKey.WITHIN_SQRS,{"range":this.healingTag.@range},TooltipHelper.getOpenTag(loc7),TooltipHelper.getCloseTag());
			loc8.pushParams(TextKey.EFFECT_FOR_DURATION,{
				"effect":TextKey.wrapForTokenResolution(TextKey.ACTIVE_EFFECT_HEALING),
				"duration":loc1.toString()
			},TooltipHelper.getOpenTag(loc7),TooltipHelper.getCloseTag());
			comparisonStringBuilder.pushParams(TextKey.PARTY_EFFECT,{"effect":loc8});
			processedTags[this.healingTag.toXMLString()] = true;
		}
		
		private function handleDamagingText() : void {
			var loc1:int = int(this.damageTag.@duration);
			var loc2:int = int(this.otherDamageTag.@duration);
			var loc3:Number = Number(this.damageTag.@range);
			var loc4:Number = Number(this.otherDamageTag.@range);
			var loc5:Number = 0.5 * loc1 * 0.5 * loc3;
			var loc6:Number = 0.5 * loc2 * 0.5 * loc4;
			var loc7:uint = getTextColor(loc5 - loc6);
			var loc8:AppendingLineBuilder = new AppendingLineBuilder();
			loc8.pushParams(TextKey.WITHIN_SQRS,{"range":this.damageTag.@range},TooltipHelper.getOpenTag(loc7),TooltipHelper.getCloseTag());
			loc8.pushParams(TextKey.EFFECT_FOR_DURATION,{
				"effect":TextKey.wrapForTokenResolution(TextKey.ACTIVE_EFFECT_DAMAGING),
				"duration":loc1.toString()
			},TooltipHelper.getOpenTag(loc7),TooltipHelper.getCloseTag());
			comparisonStringBuilder.pushParams(TextKey.PARTY_EFFECT,{"effect":loc8});
			processedTags[this.damageTag.toXMLString()] = true;
		}
	}
}
