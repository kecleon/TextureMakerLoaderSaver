 
package io.decagames.rotmg.social.widgets {
	import com.company.assembleegameclient.ui.icons.IconButton;
	import com.company.assembleegameclient.ui.icons.IconButtonFactory;
	import com.company.assembleegameclient.ui.tooltip.TextToolTip;
	import com.company.util.AssetLibrary;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import io.decagames.rotmg.social.data.SocialItemState;
	import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
	import io.decagames.rotmg.ui.labels.UILabel;
	import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
	import io.decagames.rotmg.ui.texture.TextureParser;
	import kabam.rotmg.core.StaticInjectorContext;
	import kabam.rotmg.core.signals.HideTooltipsSignal;
	import kabam.rotmg.core.signals.ShowTooltipSignal;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;
	import kabam.rotmg.tooltips.HoverTooltipDelegate;
	import kabam.rotmg.tooltips.TooltipAble;
	
	public class BaseListItem extends Sprite implements TooltipAble {
		 
		
		protected const LIST_ITEM_WIDTH:int = 310;
		
		protected const LIST_ITEM_HEIGHT:int = 40;
		
		protected const ONLINE_COLOR:uint = 3407650;
		
		protected const OFFLINE_COLOR:uint = 11776947;
		
		protected var _characterContainer:Sprite;
		
		protected var hoverTooltipDelegate:HoverTooltipDelegate;
		
		protected var _state:int;
		
		protected var _iconButtonFactory:IconButtonFactory;
		
		protected var listBackground:SliceScalingBitmap;
		
		protected var listLabel:UILabel;
		
		protected var listPortrait:Bitmap;
		
		private var toolTip_:TextToolTip;
		
		public function BaseListItem(param1:int) {
			super();
			this._state = param1;
		}
		
		public function getLabelText() : String {
			return this.listLabel.text;
		}
		
		public function setToolTipTitle(param1:String, param2:Object = null) : void {
			if(param1 != "") {
				if(this.toolTip_ == null) {
					this.toolTip_ = new TextToolTip(3552822,10197915,"","",200);
					this.hoverTooltipDelegate.setDisplayObject(this._characterContainer);
					this.hoverTooltipDelegate.tooltip = this.toolTip_;
				}
				this.toolTip_.setTitle(new LineBuilder().setParams(param1,param2));
			}
		}
		
		public function setToolTipText(param1:String, param2:Object = null) : void {
			if(param1 != "") {
				if(this.toolTip_ == null) {
					this.toolTip_ = new TextToolTip(3552822,10197915,"","",200);
					this.hoverTooltipDelegate.setDisplayObject(this._characterContainer);
					this.hoverTooltipDelegate.tooltip = this.toolTip_;
				}
				this.toolTip_.setText(new LineBuilder().setParams(param1,param2));
			}
		}
		
		protected function init() : void {
			this._iconButtonFactory = StaticInjectorContext.getInjector().getInstance(IconButtonFactory);
			this.hoverTooltipDelegate = new HoverTooltipDelegate();
			this.setBaseItemState();
			this._characterContainer = new Sprite();
			addChild(this._characterContainer);
		}
		
		private function setBaseItemState() : void {
			switch(this._state) {
				case SocialItemState.ONLINE:
					this.listBackground = TextureParser.instance.getSliceScalingBitmap("UI","listitem_content_background");
					addChild(this.listBackground);
					break;
				case SocialItemState.OFFLINE:
					this.listBackground = TextureParser.instance.getSliceScalingBitmap("UI","listitem_content_background_inactive");
					addChild(this.listBackground);
					break;
				case SocialItemState.INVITE:
					this.listBackground = TextureParser.instance.getSliceScalingBitmap("UI","listitem_content_background_indicator");
					addChild(this.listBackground);
			}
			this.listBackground.height = this.LIST_ITEM_HEIGHT;
			this.listBackground.width = this.LIST_ITEM_WIDTH;
		}
		
		protected function createListLabel(param1:String) : void {
			this.listLabel = new UILabel();
			this.listLabel.x = 40;
			this.listLabel.y = 12;
			this.listLabel.text = param1;
			this.setLabelColorByState(this.listLabel);
			this._characterContainer.addChild(this.listLabel);
		}
		
		protected function createListPortrait(param1:BitmapData) : void {
			this.listPortrait = new Bitmap(param1);
			this.listPortrait.x = -Math.round(this.listPortrait.width / 2) + 22;
			this.listPortrait.y = -Math.round(this.listPortrait.height / 2) + 20;
			if(this.listPortrait) {
				this._characterContainer.addChild(this.listPortrait);
			}
		}
		
		protected function setLabelColorByState(param1:UILabel) : void {
			switch(this._state) {
				case SocialItemState.ONLINE:
					DefaultLabelFormat.friendsItemLabel(param1,this.ONLINE_COLOR);
					break;
				case SocialItemState.OFFLINE:
					DefaultLabelFormat.friendsItemLabel(param1,this.OFFLINE_COLOR);
					break;
				default:
					DefaultLabelFormat.defaultSmallPopupTitle(param1);
			}
		}
		
		protected function addButton(param1:String, param2:int, param3:int, param4:int, param5:String, param6:String = "") : IconButton {
			var loc7:IconButton = null;
			loc7 = this._iconButtonFactory.create(AssetLibrary.getImageFromSet(param1,param2),"","","");
			loc7.setToolTipTitle(param5);
			loc7.setToolTipText(param6);
			loc7.x = param3;
			loc7.y = param4;
			addChild(loc7);
			return loc7;
		}
		
		public function setShowToolTipSignal(param1:ShowTooltipSignal) : void {
			this.hoverTooltipDelegate.setShowToolTipSignal(param1);
		}
		
		public function getShowToolTip() : ShowTooltipSignal {
			return this.hoverTooltipDelegate.getShowToolTip();
		}
		
		public function setHideToolTipsSignal(param1:HideTooltipsSignal) : void {
			this.hoverTooltipDelegate.setHideToolTipsSignal(param1);
		}
		
		public function getHideToolTips() : HideTooltipsSignal {
			return this.hoverTooltipDelegate.getHideToolTips();
		}
	}
}
