 
package com.company.assembleegameclient.ui.tooltip.slotcomparisons {
	import com.company.assembleegameclient.ui.tooltip.TooltipHelper;
	import kabam.rotmg.text.model.TextKey;
	import kabam.rotmg.text.view.stringBuilder.AppendingLineBuilder;
	
	public class HelmetComparison extends SlotComparison {
		 
		
		private var berserk:XML;
		
		private var speedy:XML;
		
		private var otherBerserk:XML;
		
		private var otherSpeedy:XML;
		
		private var armored:XML;
		
		private var otherArmored:XML;
		
		public function HelmetComparison() {
			super();
		}
		
		override protected function compareSlots(param1:XML, param2:XML) : void {
			this.extractDataFromXML(param1,param2);
			comparisonStringBuilder = new AppendingLineBuilder();
			this.handleBerserk();
			this.handleSpeedy();
			this.handleArmored();
		}
		
		private function extractDataFromXML(param1:XML, param2:XML) : void {
			this.berserk = this.getAuraTagByType(param1,"Berserk");
			this.speedy = this.getSelfTagByType(param1,"Speedy");
			this.armored = this.getSelfTagByType(param1,"Armored");
			this.otherBerserk = this.getAuraTagByType(param2,"Berserk");
			this.otherSpeedy = this.getSelfTagByType(param2,"Speedy");
			this.otherArmored = this.getSelfTagByType(param2,"Armored");
		}
		
		private function getAuraTagByType(param1:XML, param2:String) : XML {
			var matches:XMLList = null;
			var tag:XML = null;
			var xml:XML = param1;
			var typeName:String = param2;
			matches = xml.Activate.(text() == ActivationType.COND_EFFECT_AURA);
			for each(tag in matches) {
				if(tag.@effect == typeName) {
					return tag;
				}
			}
			return null;
		}
		
		private function getSelfTagByType(param1:XML, param2:String) : XML {
			var matches:XMLList = null;
			var tag:XML = null;
			var xml:XML = param1;
			var typeName:String = param2;
			matches = xml.Activate.(text() == ActivationType.COND_EFFECT_SELF);
			for each(tag in matches) {
				if(tag.@effect == typeName) {
					return tag;
				}
			}
			return null;
		}
		
		private function handleBerserk() : void {
			if(this.berserk == null || this.otherBerserk == null) {
				return;
			}
			var loc1:Number = Number(this.berserk.@range);
			var loc2:Number = Number(this.otherBerserk.@range);
			var loc3:Number = Number(this.berserk.@duration);
			var loc4:Number = Number(this.otherBerserk.@duration);
			var loc5:Number = 0.5 * loc1 + 0.5 * loc3;
			var loc6:Number = 0.5 * loc2 + 0.5 * loc4;
			var loc7:uint = getTextColor(loc5 - loc6);
			var loc8:AppendingLineBuilder = new AppendingLineBuilder();
			loc8.pushParams(TextKey.WITHIN_SQRS,{"range":loc1.toString()},TooltipHelper.getOpenTag(loc7),TooltipHelper.getCloseTag());
			loc8.pushParams(TextKey.EFFECT_FOR_DURATION,{
				"effect":TextKey.wrapForTokenResolution(TextKey.ACTIVE_EFFECT_BERSERK),
				"duration":loc3.toString()
			},TooltipHelper.getOpenTag(loc7),TooltipHelper.getCloseTag());
			comparisonStringBuilder.pushParams(TextKey.PARTY_EFFECT,{"effect":loc8});
			processedTags[this.berserk.toXMLString()] = true;
		}
		
		private function handleSpeedy() : void {
			var loc1:Number = NaN;
			var loc2:Number = NaN;
			if(this.speedy != null && this.otherSpeedy != null) {
				loc1 = Number(this.speedy.@duration);
				loc2 = Number(this.otherSpeedy.@duration);
				comparisonStringBuilder.pushParams(TextKey.EFFECT_ON_SELF,{"effect":""});
				comparisonStringBuilder.pushParams(TextKey.EFFECT_FOR_DURATION,{
					"effect":TextKey.wrapForTokenResolution(TextKey.ACTIVE_EFFECT_SPEEDY),
					"duration":loc1.toString()
				},TooltipHelper.getOpenTag(getTextColor(loc1 - loc2)),TooltipHelper.getCloseTag());
				processedTags[this.speedy.toXMLString()] = true;
			} else if(this.speedy != null && this.otherSpeedy == null) {
				comparisonStringBuilder.pushParams(TextKey.EFFECT_ON_SELF,{"effect":""});
				comparisonStringBuilder.pushParams(TextKey.EFFECT_FOR_DURATION,{
					"effect":TextKey.wrapForTokenResolution(TextKey.ACTIVE_EFFECT_SPEEDY),
					"duration":this.speedy.@duration
				},TooltipHelper.getOpenTag(BETTER_COLOR),TooltipHelper.getCloseTag());
				processedTags[this.speedy.toXMLString()] = true;
			}
		}
		
		private function handleArmored() : void {
			if(this.armored != null) {
				comparisonStringBuilder.pushParams(TextKey.EFFECT_ON_SELF,{"effect":""});
				comparisonStringBuilder.pushParams(TextKey.EFFECT_FOR_DURATION,{
					"effect":TextKey.wrapForTokenResolution(TextKey.ACTIVE_EFFECT_ARMORED),
					"duration":this.armored.@duration
				},TooltipHelper.getOpenTag(UNTIERED_COLOR),TooltipHelper.getCloseTag());
				processedTags[this.armored.toXMLString()] = true;
			}
		}
	}
}
