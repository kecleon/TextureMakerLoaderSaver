 
package io.decagames.rotmg.ui.popups.modal {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import io.decagames.rotmg.ui.buttons.BaseButton;
	import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
	import io.decagames.rotmg.ui.popups.BasePopup;
	import io.decagames.rotmg.ui.popups.header.PopupHeader;
	import io.decagames.rotmg.ui.scroll.UIScrollbar;
	import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
	import io.decagames.rotmg.ui.texture.TextureParser;
	
	public class ModalPopup extends BasePopup {
		 
		
		protected var _contentContainer:Sprite;
		
		protected var contentMask:Sprite;
		
		protected var background:SliceScalingBitmap;
		
		protected var contentMargin:int = 11;
		
		protected var maxHeight:int = 520;
		
		protected var _header:PopupHeader;
		
		protected var _autoSize:Boolean;
		
		protected var scroll:UIScrollbar;
		
		private var buttonsList:Vector.<BaseButton>;
		
		public function ModalPopup(param1:int, param2:int, param3:String = "", param4:Function = null, param5:Rectangle = null, param6:Number = 0.8) {
			var loc7:int = 0;
			super(param1 + 2 * this.contentMargin,param2 <= 2 * this.contentMargin?int(2 * this.contentMargin + 1):int(param2 + 2 * this.contentMargin),param5);
			this._contentWidth = param1;
			this._contentHeight = param2;
			this.buttonsList = new Vector.<BaseButton>();
			this._autoSize = param2 == 0;
			_popupFadeColor = 0;
			_popupFadeAlpha = param6;
			_showOnFullScreen = true;
			this.setBackground("popup_background_simple");
			this._contentContainer = new Sprite();
			this._contentContainer.x = this.contentMargin;
			this._contentContainer.y = this.contentMargin;
			this.contentMask = new Sprite();
			this.drawContentMask(param2);
			this._contentContainer.mask = this.contentMask;
			this.contentMask.x = this._contentContainer.x;
			this.contentMask.y = this._contentContainer.y;
			super.addChild(this.contentMask);
			super.addChild(this._contentContainer);
			if(param3 != "") {
				this._header = new PopupHeader(width,PopupHeader.TYPE_MODAL);
				this._header.setTitle(param3,popupWidth - 18,param4 == null?DefaultLabelFormat.defaultModalTitle:param4);
				super.addChild(this._header);
				loc7 = this._header.height / 2 - 1;
				this._contentContainer.y = this._contentContainer.y + (loc7 + 15);
				this.contentMask.y = this.contentMask.y + (loc7 + 15);
				this.background.y = this.background.y + loc7;
				this.background.height = this.background.height + 15;
			}
		}
		
		private function drawContentMask(param1:int) : void {
			this.contentMask.graphics.clear();
			this.contentMask.graphics.beginFill(16711680,0.2);
			this.contentMask.graphics.drawRect(0,0,_contentWidth,param1);
			this.contentMask.graphics.endFill();
		}
		
		override public function addChildAt(param1:DisplayObject, param2:int) : DisplayObject {
			return this._contentContainer.addChildAt(param1,param2);
		}
		
		override public function addChild(param1:DisplayObject) : DisplayObject {
			return this._contentContainer.addChild(param1);
		}
		
		override public function removeChild(param1:DisplayObject) : DisplayObject {
			return this._contentContainer.removeChild(param1);
		}
		
		override public function removeChildAt(param1:int) : DisplayObject {
			return this._contentContainer.removeChildAt(param1);
		}
		
		override public function get height() : Number {
			if(this._contentContainer.height > this.maxHeight) {
				return this.maxHeight + 2 * this.contentMargin + (!!this.header?this._header.height / 2 + 14:0);
			}
			return super.height;
		}
		
		public function resize() : void {
			var loc1:int = this._contentContainer.height;
			if(loc1 > this.maxHeight) {
				loc1 = this.maxHeight;
			}
			this.drawContentMask(loc1);
			this.background.height = loc1 + 2 * this.contentMargin + (!!this.header?15:0);
			if(this._contentContainer.height > this.maxHeight && !this.scroll) {
				this.scroll = new UIScrollbar(loc1);
				this.scroll.x = popupWidth - 18;
				this.scroll.y = this._contentContainer.y;
				super.addChild(this.scroll);
				this.scroll.scrollObject = this;
				this.scroll.content = this._contentContainer;
			}
		}
		
		public function get header() : PopupHeader {
			return this._header;
		}
		
		private function setBackground(param1:String) : void {
			this.background = TextureParser.instance.getSliceScalingBitmap("UI",param1);
			this.background.width = popupWidth;
			this.background.height = popupHeight;
			super.addChildAt(this.background,0);
		}
		
		public function dispose() : void {
			var loc1:BaseButton = null;
			if(this.background) {
				this.background.dispose();
				this.background = null;
			}
			if(this._header) {
				this._header.dispose();
			}
			for each(loc1 in this.buttonsList) {
				loc1.dispose();
			}
			this.buttonsList = null;
		}
		
		protected function registerButton(param1:BaseButton) : void {
			this.buttonsList.push(param1);
		}
		
		public function get contentContainer() : Sprite {
			return this._contentContainer;
		}
		
		public function get autoSize() : Boolean {
			return this._autoSize;
		}
	}
}
