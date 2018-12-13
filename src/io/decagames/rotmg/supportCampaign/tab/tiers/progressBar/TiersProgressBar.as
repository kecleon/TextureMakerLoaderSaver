package io.decagames.rotmg.supportCampaign.tab.tiers.progressBar {
	import flash.display.Sprite;

	import io.decagames.rotmg.supportCampaign.data.vo.RankVO;
	import io.decagames.rotmg.supportCampaign.tab.tiers.button.TierButton;
	import io.decagames.rotmg.supportCampaign.tab.tiers.button.status.TierButtonStatus;
	import io.decagames.rotmg.ui.ProgressBar;
	import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
	import io.decagames.rotmg.ui.texture.TextureParser;

	public class TiersProgressBar extends Sprite {


		private var ranks:Vector.<RankVO>;

		private var componentWidth:int;

		private var currentRank:int;

		private var claimed:int;

		private var buttonAreReady:Boolean;

		private var buttons:Vector.<TierButton>;

		private var progressBars:Vector.<ProgressBar>;

		private var points:int;

		private var supportIcon:SliceScalingBitmap;

		public function TiersProgressBar(param1:Vector.<RankVO>, param2:int) {
			super();
			this.ranks = param1;
			this.componentWidth = param2;
			this.buttons = new Vector.<TierButton>();
			this.progressBars = new Vector.<ProgressBar>();
			this.supportIcon = TextureParser.instance.getSliceScalingBitmap("UI", "campaign_Points");
		}

		public function show(param1:int, param2:int, param3:int):void {
			this.currentRank = param2;
			this.claimed = param3;
			this.points = param1;
			if (!this.buttonAreReady) {
				this.renderButtons();
				this.renderProgressBar();
			}
			this.updateButtons();
			this.updateProgressBar();
		}

		private function getStatusByTier(param1:int):int {
			if (this.claimed >= param1) {
				return TierButtonStatus.CLAIMED;
			}
			if (this.currentRank >= param1) {
				return TierButtonStatus.UNLOCKED;
			}
			return TierButtonStatus.LOCKED;
		}

		private function updateButtons():void {
			var loc2:TierButton = null;
			var loc1:Boolean = false;
			for each(loc2 in this.buttons) {
				loc2.updateStatus(this.getStatusByTier(loc2.tier));
				if (!loc1 && this.getStatusByTier(loc2.tier) == TierButtonStatus.UNLOCKED) {
					loc1 = true;
					loc2.selected = true;
				} else {
					loc2.selected = false;
				}
			}
			if (!loc1) {
				if (this.currentRank != 0) {
					for each(loc2 in this.buttons) {
						if (this.currentRank == loc2.tier) {
							loc1 = true;
							loc2.selected = true;
						}
					}
				}
			}
			if (!loc1) {
				this.buttons[0].selected = true;
			}
		}

		private function updateProgressBar():void {
			var loc3:ProgressBar = null;
			var loc1:int = this.points;
			var loc2:int = 0;
			for each(loc3 in this.progressBars) {
				if (this.claimed > loc2) {
					loc3.maxColor = 4958208;
				}
				if (loc3.value != loc1) {
					if (loc1 > loc3.maxValue - loc3.minValue) {
						loc3.value = loc3.maxValue - loc3.minValue;
					} else {
						loc3.value = loc1;
					}
				}
				loc1 = this.points;
				loc1 = loc1 - loc3.maxValue;
				if (loc1 <= 0) {
					break;
				}
				loc2++;
			}
		}

		private function renderProgressBar():void {
			var loc4:TierButton = null;
			var loc5:int = 0;
			var loc6:ProgressBar = null;
			var loc1:TierButton = null;
			var loc2:int = 0;
			var loc3:Vector.<TierButton> = this.buttons.concat();
			for each(loc4 in loc3) {
				loc5 = loc1 == null ? 0 : int(loc1.x + loc1.width);
				loc6 = new ProgressBar(loc4.x - loc5 + 4, 4, "", "", loc2 == 0 ? 0 : int(this.ranks[loc2 - 1].points), this.ranks[loc2].points, 0, 5526612, 15585539);
				loc6.x = loc5 - 2;
				loc6.y = 7;
				loc6.shouldAnimate = false;
				this.progressBars.push(loc6);
				addChild(loc6);
				if (loc1 != null) {
					addChild(loc1);
				}
				addChild(loc4);
				loc1 = loc4;
				loc2++;
			}
			addChild(this.supportIcon);
			this.supportIcon.x = -3;
			this.supportIcon.y = 5;
		}

		private function renderButtons():void {
			var loc2:RankVO = null;
			var loc3:TierButton = null;
			var loc1:int = 1;
			for each(loc2 in this.ranks) {
				loc3 = this.getButtonByTier(loc1);
				this.buttons.push(addChild(loc3));
				loc1++;
			}
			this.buttonAreReady = true;
		}

		private function getButtonByTier(param1:int):TierButton {
			var loc2:TierButton = new TierButton(param1, this.getStatusByTier(param1));
			if (param1 > 0) {
				loc2.x = this.getPositionByTier(param1, loc2);
			}
			return loc2;
		}

		private function getPositionByTier(param1:int, param2:TierButton):int {
			var loc3:int = this.ranks[this.ranks.length - 1].points;
			var loc4:int = this.componentWidth - param2.width * 1.5;
			return Math.round(param2.width / 2 + loc4 * this.ranks[param1 - 1].points / loc3);
		}
	}
}
