package com.company.assembleegameclient.mapeditor {
	import com.company.assembleegameclient.ui.tooltip.ToolTip;
	import com.company.ui.BaseSimpleText;

	import flash.filters.DropShadowFilter;

	public class ObjectTypeToolTip extends ToolTip {

		private static const MAX_WIDTH:int = 180;


		private var titleText_:BaseSimpleText;

		private var descText_:BaseSimpleText;

		public function ObjectTypeToolTip(param1:XML) {
			var loc3:XML = null;
			super(3552822, 1, 10197915, 1, true);
			this.titleText_ = new BaseSimpleText(16, 16777215, false, MAX_WIDTH - 4, 0);
			this.titleText_.setBold(true);
			this.titleText_.wordWrap = true;
			this.titleText_.text = String(param1.@id);
			this.titleText_.useTextDimensions();
			this.titleText_.filters = [new DropShadowFilter(0, 0, 0, 0.5, 12, 12)];
			this.titleText_.x = 0;
			this.titleText_.y = 0;
			addChild(this.titleText_);
			var loc2:* = "";
			if (param1.hasOwnProperty("Group")) {
				loc2 = loc2 + ("Group: " + param1.Group + "\n");
			}
			if (param1.hasOwnProperty("Static")) {
				loc2 = loc2 + "Static\n";
			}
			if (param1.hasOwnProperty("Enemy")) {
				loc2 = loc2 + "Enemy\n";
				if (param1.hasOwnProperty("MaxHitPoints")) {
					loc2 = loc2 + ("MaxHitPoints: " + param1.MaxHitPoints + "\n");
				}
				if (param1.hasOwnProperty("Defense")) {
					loc2 = loc2 + ("Defense: " + param1.Defense + "\n");
				}
			}
			if (param1.hasOwnProperty("God")) {
				loc2 = loc2 + "God\n";
			}
			if (param1.hasOwnProperty("Quest")) {
				loc2 = loc2 + "Quest\n";
			}
			if (param1.hasOwnProperty("Hero")) {
				loc2 = loc2 + "Hero\n";
			}
			if (param1.hasOwnProperty("Encounter")) {
				loc2 = loc2 + "Encounter\n";
			}
			if (param1.hasOwnProperty("Level")) {
				loc2 = loc2 + ("Level: " + param1.Level + "\n");
			}
			if (param1.hasOwnProperty("Terrain")) {
				loc2 = loc2 + ("Terrain: " + param1.Terrain + "\n");
			}
			for each(loc3 in param1.Projectile) {
				loc2 = loc2 + ("Projectile " + loc3.@id + ": " + loc3.ObjectId + "\n" + "\tDamage: " + loc3.Damage + "\n" + "\tSpeed: " + loc3.Speed + "\n");
				if (loc3.hasOwnProperty("PassesCover")) {
					loc2 = loc2 + "\tPassesCover\n";
				}
				if (loc3.hasOwnProperty("MultiHit")) {
					loc2 = loc2 + "\tMultiHit\n";
				}
				if (loc3.hasOwnProperty("ConditionEffect")) {
					loc2 = loc2 + ("\t" + loc3.ConditionEffect + " for " + loc3.ConditionEffect.@duration + " secs\n");
				}
				if (loc3.hasOwnProperty("Parametric")) {
					loc2 = loc2 + "\tParametric\n";
				}
			}
			this.descText_ = new BaseSimpleText(14, 11776947, false, MAX_WIDTH, 0);
			this.descText_.wordWrap = true;
			this.descText_.text = String(loc2);
			this.descText_.useTextDimensions();
			this.descText_.filters = [new DropShadowFilter(0, 0, 0, 0.5, 12, 12)];
			this.descText_.x = 0;
			this.descText_.y = this.titleText_.height + 2;
			addChild(this.descText_);
		}
	}
}
