package io.decagames.rotmg.ui.popups.header {
	import flash.display.Sprite;

	import io.decagames.rotmg.ui.buttons.SliceScalingButton;
	import io.decagames.rotmg.ui.labels.UILabel;
	import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
	import io.decagames.rotmg.ui.texture.TextureParser;

	public class PopupHeader extends Sprite {

		public static const LEFT_BUTTON:String = "left_button";

		public static const RIGHT_BUTTON:String = "right_button";

		public static var TYPE_FULL:String = "full";

		public static var TYPE_MODAL:String = "modal";


		private var backgroundBitmap:SliceScalingBitmap;

		private var titleBackgroundBitmap:SliceScalingBitmap;

		private var _titleLabel:UILabel;

		private var buttonsContainers:Vector.<Sprite>;

		private var buttons:Vector.<SliceScalingButton>;

		private var _coinsField:CoinsField;

		private var _fameField:FameField;

		private var headerWidth:int;

		private var headerType:String;

		public function PopupHeader(param1:int, param2:String) {
			super();
			this.headerWidth = param1;
			this.headerType = param2;
			if (param2 == TYPE_FULL) {
				this.backgroundBitmap = TextureParser.instance.getSliceScalingBitmap("UI", "popup_header", param1);
				addChild(this.backgroundBitmap);
			}
			this.buttonsContainers = new Vector.<Sprite>();
			this.buttons = new Vector.<SliceScalingButton>();
		}

		public function setTitle(param1:String, param2:int, param3:Function = null):void {
			if (!this.titleBackgroundBitmap) {
				if (this.headerType == TYPE_FULL) {
					this.titleBackgroundBitmap = TextureParser.instance.getSliceScalingBitmap("UI", "popup_header_title", param2);
					addChild(this.titleBackgroundBitmap);
					this.titleBackgroundBitmap.x = Math.round((this.headerWidth - param2) / 2);
					this.titleBackgroundBitmap.y = 29;
				} else {
					this.titleBackgroundBitmap = TextureParser.instance.getSliceScalingBitmap("UI", "modal_header_title", param2);
					addChild(this.titleBackgroundBitmap);
					this.titleBackgroundBitmap.x = Math.round((this.headerWidth - param2) / 2);
				}
				this._titleLabel = new UILabel();
				if (param3 != null) {
					param3(this._titleLabel);
				}
				this._titleLabel.text = param1;
				addChild(this._titleLabel);
				this._titleLabel.x = this.titleBackgroundBitmap.x + (this.titleBackgroundBitmap.width - this._titleLabel.textWidth) / 2;
				if (this.headerType == TYPE_FULL) {
					this._titleLabel.y = this.titleBackgroundBitmap.height - this._titleLabel.height / 2 - 3;
				} else {
					this._titleLabel.y = this.titleBackgroundBitmap.y + (this.titleBackgroundBitmap.height - this._titleLabel.height) / 2;
				}
			}
		}

		public function addButton(param1:SliceScalingButton, param2:String):void {
			var loc4:SliceScalingBitmap = null;
			var loc3:Sprite = new Sprite();
			if (this.headerType == TYPE_FULL) {
				loc4 = TextureParser.instance.getSliceScalingBitmap("UI", "popup_header_button_decor");
				loc3.addChild(loc4);
			}
			loc3.addChild(param1);
			addChild(loc3);
			this.buttonsContainers.push(loc3);
			this.buttons.push(param1);
			if (this.headerType == TYPE_FULL) {
				loc4.y = (this.backgroundBitmap.height - loc4.height) / 2;
				param1.y = loc4.y + 8;
			} else {
				param1.y = 5;
			}
			if (param2 == RIGHT_BUTTON) {
				if (this.headerType == TYPE_FULL) {
					loc4.x = this.headerWidth - loc4.width;
					param1.x = loc4.x + 6;
				} else {
					param1.x = this.titleBackgroundBitmap.x + this.titleBackgroundBitmap.width - param1.width - 3;
				}
			} else if (this.headerType == TYPE_FULL) {
				loc4.x = loc4.width;
				loc4.scaleX = -1;
				param1.x = 16;
			} else {
				param1.x = this.titleBackgroundBitmap.x + 3;
			}
		}

		public function showCoins(param1:int):CoinsField {
			var loc2:Sprite = null;
			this._coinsField = new CoinsField(param1);
			this._coinsField.x = 44;
			addChild(this._coinsField);
			this.alignCurrency();
			for each(loc2 in this.buttonsContainers) {
				addChild(loc2);
			}
			return this._coinsField;
		}

		public function showFame(param1:int):FameField {
			this._fameField = new FameField(param1);
			this._fameField.x = 44;
			addChild(this._fameField);
			this.alignCurrency();
			return this._fameField;
		}

		private function alignCurrency():void {
			if (this._coinsField && this._fameField) {
				this._coinsField.y = 39;
				this._fameField.y = 63;
			} else if (this._coinsField) {
				this._coinsField.y = 51;
			} else if (this._fameField) {
				this._fameField.y = 51;
			}
		}

		public function dispose():void {
			var loc1:SliceScalingButton = null;
			if (this.backgroundBitmap) {
				this.backgroundBitmap.dispose();
			}
			this.titleBackgroundBitmap.dispose();
			if (this._coinsField) {
				this._coinsField.dispose();
			}
			if (this._fameField) {
				this._fameField.dispose();
			}
			for each(loc1 in this.buttons) {
				loc1.dispose();
			}
			this.buttonsContainers = null;
			this.buttons = null;
		}

		public function get titleLabel():UILabel {
			return this._titleLabel;
		}

		public function get coinsField():CoinsField {
			return this._coinsField;
		}

		public function get fameField():FameField {
			return this._fameField;
		}
	}
}
