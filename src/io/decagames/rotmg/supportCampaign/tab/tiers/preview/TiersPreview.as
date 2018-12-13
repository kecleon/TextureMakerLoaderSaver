 
package io.decagames.rotmg.supportCampaign.tab.tiers.preview {
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import flash.display.Sprite;
	import flash.text.TextFormatAlign;
	import io.decagames.rotmg.ui.buttons.SliceScalingButton;
	import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
	import io.decagames.rotmg.ui.labels.UILabel;
	import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
	import io.decagames.rotmg.ui.texture.TextureParser;
	
	public class TiersPreview extends Sprite {
		 
		
		private var background:SliceScalingBitmap;
		
		private var _leftArrow:SliceScalingButton;
		
		private var _rightArrow:SliceScalingButton;
		
		private var _startTier:int;
		
		private var _claimButton:SliceScalingButton;
		
		private var supportIcon:SliceScalingBitmap;
		
		private var donateButtonBackground:SliceScalingBitmap;
		
		private var componentWidth:int;
		
		private var requiredPointsContainer:Sprite;
		
		private var ranks:Array;
		
		private var selectTween:TimelineMax;
		
		public function TiersPreview(param1:int, param2:Array, param3:int, param4:int, param5:int) {
			super();
			this._startTier = param1;
			this.ranks = param2;
			this.componentWidth = param5;
			this._claimButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI","generic_green_button"));
			this._claimButton.setLabel("Claim",DefaultLabelFormat.defaultButtonLabel);
			this.showTier(param1,param3,param4);
			this._rightArrow = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI","tier_arrow"));
			addChild(this._rightArrow);
			this._rightArrow.x = 533;
			this._rightArrow.y = 103;
			this._leftArrow = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI","tier_arrow"));
			this._leftArrow.rotation = 180;
			this._leftArrow.x = -3;
			this._leftArrow.y = 133;
			addChild(this._leftArrow);
		}
		
		public function showTier(param1:int, param2:int, param3:int) : void {
			var tier:int = param1;
			var currentRank:int = param2;
			var claimed:int = param3;
			if(this.background && this.background.parent) {
				removeChild(this.background);
			}
			try {
				this.background = TextureParser.instance.getSliceScalingBitmap("UI","Banner_Tier_" + tier);
				addChildAt(this.background,0);
			}
			catch(e:Error) {
			}
			this.renderButtons(tier,currentRank,claimed);
		}
		
		private function renderButtons(param1:int, param2:int, param3:int) : void {
			var loc4:UILabel = null;
			var loc5:UILabel = null;
			if(this.donateButtonBackground && this.donateButtonBackground.parent) {
				removeChild(this.donateButtonBackground);
			}
			if(this._claimButton && this._claimButton.parent) {
				removeChild(this._claimButton);
			}
			if(this.requiredPointsContainer && this.requiredPointsContainer.parent) {
				removeChild(this.requiredPointsContainer);
			}
			if(param1 > param3 && param1 != this.ranks.length + 1) {
				this.donateButtonBackground = TextureParser.instance.getSliceScalingBitmap("UI","main_button_decoration_dark",160);
				this.donateButtonBackground.x = Math.round((this.componentWidth - this.donateButtonBackground.width) / 2);
				this.donateButtonBackground.y = 178;
				addChild(this.donateButtonBackground);
				if(param2 >= param1) {
					this._claimButton.width = this.donateButtonBackground.width - 48;
					this._claimButton.y = this.donateButtonBackground.y + 6;
					this._claimButton.x = this.donateButtonBackground.x + 24;
					addChild(this._claimButton);
				} else {
					this.requiredPointsContainer = new Sprite();
					loc4 = new UILabel();
					DefaultLabelFormat.createLabelFormat(loc4,22,15585539,TextFormatAlign.CENTER,true);
					this.requiredPointsContainer.addChild(loc4);
					this.supportIcon = TextureParser.instance.getSliceScalingBitmap("UI","campaign_Points");
					this.requiredPointsContainer.addChild(this.supportIcon);
					loc4.text = this.ranks[param1 - 1].toString();
					loc4.x = this.donateButtonBackground.x + Math.round((this.donateButtonBackground.width - loc4.width) / 2) - 10;
					loc4.y = this.donateButtonBackground.y + 13;
					this.supportIcon.y = loc4.y + 3;
					this.supportIcon.x = loc4.x + loc4.width;
					addChild(this.requiredPointsContainer);
				}
			} else if(param3) {
				this.requiredPointsContainer = new Sprite();
				loc5 = new UILabel();
				DefaultLabelFormat.createLabelFormat(loc5,22,4958208,TextFormatAlign.CENTER,true);
				this.requiredPointsContainer.addChild(loc5);
				loc5.text = "Claimed";
				loc5.x = this.background.x + Math.round((this.background.width - loc5.width) / 2);
				loc5.y = 190;
				addChild(this.requiredPointsContainer);
			}
		}
		
		public function selectAnimation() : void {
			if(!this.selectTween) {
				this.selectTween = new TimelineMax();
				this.selectTween.add(TweenMax.to(this,0.05,{"tint":16777215}));
				this.selectTween.add(TweenMax.to(this,0.3,{
					"tint":null,
					"ease":Expo.easeOut
				}));
			} else {
				this.selectTween.play(0);
			}
		}
		
		public function get leftArrow() : SliceScalingButton {
			return this._leftArrow;
		}
		
		public function get rightArrow() : SliceScalingButton {
			return this._rightArrow;
		}
		
		public function get startTier() : int {
			return this._startTier;
		}
		
		public function get claimButton() : SliceScalingButton {
			return this._claimButton;
		}
	}
}
