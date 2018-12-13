package com.company.assembleegameclient.ui.tooltip {
	import com.company.assembleegameclient.ui.tooltip.slotcomparisons.CloakComparison;
	import com.company.assembleegameclient.ui.tooltip.slotcomparisons.GeneralProjectileComparison;
	import com.company.assembleegameclient.ui.tooltip.slotcomparisons.GenericArmorComparison;
	import com.company.assembleegameclient.ui.tooltip.slotcomparisons.HelmetComparison;
	import com.company.assembleegameclient.ui.tooltip.slotcomparisons.OrbComparison;
	import com.company.assembleegameclient.ui.tooltip.slotcomparisons.SealComparison;
	import com.company.assembleegameclient.ui.tooltip.slotcomparisons.SlotComparison;
	import com.company.assembleegameclient.ui.tooltip.slotcomparisons.TomeComparison;

	import kabam.rotmg.constants.ItemConstants;

	public class SlotComparisonFactory {


		private var hash:Object;

		public function SlotComparisonFactory() {
			super();
			var loc1:GeneralProjectileComparison = new GeneralProjectileComparison();
			var loc2:GenericArmorComparison = new GenericArmorComparison();
			this.hash = {};
			this.hash[ItemConstants.TOME_TYPE] = new TomeComparison();
			this.hash[ItemConstants.LEATHER_TYPE] = loc2;
			this.hash[ItemConstants.PLATE_TYPE] = loc2;
			this.hash[ItemConstants.SEAL_TYPE] = new SealComparison();
			this.hash[ItemConstants.CLOAK_TYPE] = new CloakComparison();
			this.hash[ItemConstants.ROBE_TYPE] = loc2;
			this.hash[ItemConstants.HELM_TYPE] = new HelmetComparison();
			this.hash[ItemConstants.ORB_TYPE] = new OrbComparison();
		}

		public function getComparisonResults(param1:XML, param2:XML):SlotComparisonResult {
			var loc3:int = int(param1.SlotType);
			var loc4:SlotComparison = this.hash[loc3];
			var loc5:SlotComparisonResult = new SlotComparisonResult();
			if (loc4 != null) {
				loc4.compare(param1, param2);
				loc5.lineBuilder = loc4.comparisonStringBuilder;
				loc5.processedTags = loc4.processedTags;
			}
			return loc5;
		}
	}
}
