package com.company.assembleegameclient.ui.tooltip.slotcomparisons {
	import com.company.assembleegameclient.ui.tooltip.TooltipHelper;

	import kabam.rotmg.text.model.TextKey;
	import kabam.rotmg.text.view.stringBuilder.AppendingLineBuilder;

	public class GeneralProjectileComparison extends SlotComparison {


		private var itemXML:XML;

		private var curItemXML:XML;

		private var projXML:XML;

		private var otherProjXML:XML;

		public function GeneralProjectileComparison() {
			super();
		}

		override protected function compareSlots(param1:XML, param2:XML):void {
			this.itemXML = param1;
			this.curItemXML = param2;
			comparisonStringBuilder = new AppendingLineBuilder();
			if (param1.hasOwnProperty("NumProjectiles")) {
				this.addNumProjectileText();
				processedTags[param1.NumProjectiles.toXMLString()] = true;
			}
			if (param1.hasOwnProperty("Projectile")) {
				this.addProjectileText();
				processedTags[param1.Projectile.toXMLString()] = true;
			}
			this.buildRateOfFireText();
		}

		private function addProjectileText():void {
			this.addDamageText();
			var loc1:Number = Number(this.projXML.Speed) * Number(this.projXML.LifetimeMS) / 10000;
			var loc2:Number = Number(this.otherProjXML.Speed) * Number(this.otherProjXML.LifetimeMS) / 10000;
			var loc3:String = TooltipHelper.getFormattedRangeString(loc1);
			comparisonStringBuilder.pushParams(TextKey.RANGE, {"range": wrapInColoredFont(loc3, getTextColor(loc1 - loc2))});
			if (this.projXML.hasOwnProperty("MultiHit")) {
				comparisonStringBuilder.pushParams(TextKey.MULTIHIT, {}, TooltipHelper.getOpenTag(NO_DIFF_COLOR), TooltipHelper.getCloseTag());
			}
			if (this.projXML.hasOwnProperty("PassesCover")) {
				comparisonStringBuilder.pushParams(TextKey.PASSES_COVER, {}, TooltipHelper.getOpenTag(NO_DIFF_COLOR), TooltipHelper.getCloseTag());
			}
			if (this.projXML.hasOwnProperty("ArmorPiercing")) {
				comparisonStringBuilder.pushParams(TextKey.ARMOR_PIERCING, {}, TooltipHelper.getOpenTag(NO_DIFF_COLOR), TooltipHelper.getCloseTag());
			}
		}

		private function addNumProjectileText():void {
			var loc1:int = int(this.itemXML.NumProjectiles);
			var loc2:int = int(this.curItemXML.NumProjectiles);
			var loc3:uint = getTextColor(loc1 - loc2);
			comparisonStringBuilder.pushParams(TextKey.SHOTS, {"numShots": wrapInColoredFont(loc1.toString(), loc3)});
		}

		private function addDamageText():void {
			this.projXML = XML(this.itemXML.Projectile);
			var loc1:int = int(this.projXML.MinDamage);
			var loc2:int = int(this.projXML.MaxDamage);
			var loc3:Number = (loc2 + loc1) / 2;
			this.otherProjXML = XML(this.curItemXML.Projectile);
			var loc4:int = int(this.otherProjXML.MinDamage);
			var loc5:int = int(this.otherProjXML.MaxDamage);
			var loc6:Number = (loc5 + loc4) / 2;
			var loc7:String = (loc1 == loc2 ? loc1 : loc1 + " - " + loc2).toString();
			comparisonStringBuilder.pushParams(TextKey.DAMAGE, {"damage": wrapInColoredFont(loc7, getTextColor(loc3 - loc6))});
		}

		private function buildRateOfFireText():void {
			if (this.itemXML.RateOfFire.length() == 0 || this.curItemXML.RateOfFire.length() == 0) {
				return;
			}
			var loc1:Number = Number(this.curItemXML.RateOfFire[0]);
			var loc2:Number = Number(this.itemXML.RateOfFire[0]);
			var loc3:int = int(loc2 / loc1 * 100);
			var loc4:int = loc3 - 100;
			if (loc4 == 0) {
				return;
			}
			var loc5:uint = getTextColor(loc4);
			var loc6:String = loc4.toString();
			if (loc4 > 0) {
				loc6 = "+" + loc6;
			}
			loc6 = wrapInColoredFont(loc6 + "%", loc5);
			comparisonStringBuilder.pushParams(TextKey.RATE_OF_FIRE, {"data": loc6});
			processedTags[this.itemXML.RateOfFire[0].toXMLString()];
		}
	}
}
