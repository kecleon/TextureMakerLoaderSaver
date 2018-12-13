package io.decagames.rotmg.supportCampaign.tab.tiers.button {
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;

	import flash.display.Sprite;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.text.TextFormatAlign;

	import io.decagames.rotmg.supportCampaign.tab.tiers.button.status.TierButtonStatus;
	import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
	import io.decagames.rotmg.ui.labels.UILabel;
	import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
	import io.decagames.rotmg.ui.texture.TextureParser;

	public class TierButton extends Sprite {


		private var background:SliceScalingBitmap;

		private var _tier:int;

		private var _status:int;

		private var _selected:Boolean;

		private var tierLabel:UILabel;

		private var tierTween:TimelineMax;

		private var claimTween:TimelineMax;

		private const OUTLINE_FILTER:GlowFilter = new GlowFilter(16777215, 1, 3, 3, 16, BitmapFilterQuality.HIGH, false, false);

		private const GLOW_FILTER:GlowFilter = new GlowFilter(5439314, 0.4, 2, 2, 16, BitmapFilterQuality.HIGH, false, false);

		public function TierButton(param1:int, param2:int) {
			super();
			this._tier = param1;
			this._status = param2;
			this.tierLabel = new UILabel();
			this.updateStatus(param2);
		}

		private function convertToRoman(param1:int):String {
			var keys:Object = null;
			var i:int = 0;
			var roman:String = null;
			var num:int = param1;
			if (num > 9999) {
				return "";
			}
			if (!num) {
				return "";
			}
			var arr:Array = String(num).split("");
			keys = {
				1: ["", "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX"],
				2: ["", "X", "XX", "XXX", "XL", "L", "LX", "LXX", "LXXX", "XC"],
				3: ["", "C", "CC", "CCC", "CD", "D", "DC", "DCC", "DCCC", "CM"],
				4: ["", "M", "MM", "MMM", "MMMM", "MMMMM", "MMMMMM", "MMMMMMM", "MMMMMMMM", "MMMMMMMMM"]
			};
			i = arr.length;
			roman = "";
			arr.forEach(function (param1:int, param2:int, param3:Array):void {
				roman = roman + keys[i][param1];
				i--;
			});
			return roman;
		}

		public function updateStatus(param1:int):void {
			if (this.background && this.background.parent) {
				removeChild(this.background);
			}
			switch (param1) {
				case TierButtonStatus.LOCKED:
					this.background = TextureParser.instance.getSliceScalingBitmap("UI", "tier_locked_" + this.convertToRoman(this._tier));
					this.background.y = -3;
					addChildAt(this.background, 0);
					DefaultLabelFormat.createLabelFormat(this.tierLabel, 12, 3487029, TextFormatAlign.CENTER, true);
					this.tierLabel.wordWrap = true;
					this.tierLabel.text = this.convertToRoman(this._tier);
					this.tierLabel.width = this.background.width;
					this.tierLabel.y = 6;
					break;
				case TierButtonStatus.UNLOCKED:
					this.background = TextureParser.instance.getSliceScalingBitmap("UI", "tier_unlocked");
					this.background.y = -3;
					addChildAt(this.background, 0);
					DefaultLabelFormat.createLabelFormat(this.tierLabel, 18, 16777215, TextFormatAlign.CENTER, true);
					this.tierLabel.wordWrap = true;
					this.tierLabel.text = this.convertToRoman(this._tier);
					this.tierLabel.width = this.background.width;
					this.tierLabel.y = 4;
					this.tierLabel.filters = [this.GLOW_FILTER];
					if (!this.claimTween) {
						this.claimTween = new TimelineMax({"repeat": -1});
						this.claimTween.add(TweenMax.to(this, 0.2, {
							"tint": null,
							"ease": Expo.easeIn
						}));
						this.claimTween.add(TweenMax.to(this, 0.2, {
							"delay": 0.5,
							"tint": 16777215
						}));
						this.claimTween.add(TweenMax.to(this, 0.5, {
							"tint": null,
							"ease": Expo.easeOut
						}));
					} else {
						this.claimTween.play(0);
					}
					break;
				case TierButtonStatus.CLAIMED:
					this.background = TextureParser.instance.getSliceScalingBitmap("UI", "tier_claimed");
					this.background.y = -3;
					DefaultLabelFormat.createLabelFormat(this.tierLabel, 0, 16777215, TextFormatAlign.CENTER, true);
					this.tierLabel.text = "";
					addChildAt(this.background, 0);
					if (this.claimTween) {
						this.claimTween.pause(0);
					}
			}
			addChild(this.tierLabel);
			this.applySelectFilter();
		}

		public function get selected():Boolean {
			return this._selected;
		}

		public function set selected(param1:Boolean):void {
			this._selected = param1;
			this.applySelectFilter();
		}

		private function applySelectFilter():void {
			if (this._selected) {
				this.background.filters = [this.OUTLINE_FILTER];
				if (!this.tierTween) {
					this.tierTween = new TimelineMax();
					this.tierTween.add(TweenMax.to(this, 0.05, {
						"scaleX": 0.9,
						"scaleY": 0.9,
						"x": this.x + this.width * 0.1 / 2,
						"y": this.y + this.height * 0.1 / 2,
						"tint": 16777215
					}));
					this.tierTween.add(TweenMax.to(this, 0.3, {
						"scaleX": 1,
						"scaleY": 1,
						"x": this.x,
						"y": this.y,
						"tint": null,
						"ease": Expo.easeOut
					}));
				} else {
					this.tierTween.play(0);
				}
			} else {
				this.background.filters = [];
			}
		}

		public function get label():UILabel {
			return this.tierLabel;
		}

		public function get tier():int {
			return this._tier;
		}
	}
}
