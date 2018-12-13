 
package io.decagames.rotmg.shop.mysteryBox.contentPopup {
	import com.company.assembleegameclient.objects.ObjectLibrary;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextFieldAutoSize;
	import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
	import io.decagames.rotmg.ui.gird.UIGridElement;
	import io.decagames.rotmg.ui.labels.UILabel;
	import kabam.rotmg.assets.services.IconFactory;
	
	public class SlotBox extends UIGridElement {
		
		public static const CHAR_SLOT:String = "CHAR_SLOT";
		
		public static const VAULT_SLOT:String = "VAULT_SLOT";
		
		public static const GOLD_SLOT:String = "GOLD_SLOT";
		 
		
		private var itemSize:int = 40;
		
		private var itemMargin:int = 2;
		
		private var _itemBackground:Sprite;
		
		private var targetWidth:int = 260;
		
		private var showFullName:Boolean;
		
		private var isLastElement:Boolean;
		
		private var amount:int;
		
		private var label:UILabel;
		
		private var isBackgroundCleared:Boolean;
		
		private var _slotType:String;
		
		private var imageBitmap:Bitmap;
		
		public function SlotBox(param1:String, param2:int, param3:Boolean, param4:String = "", param5:Boolean = false) {
			super();
			this.isLastElement = param5;
			this.amount = param2;
			this.showFullName = param3;
			this._slotType = param1;
			this.label = new UILabel();
			this.label.multiline = true;
			this.label.autoSize = TextFieldAutoSize.LEFT;
			this.label.wordWrap = true;
			DefaultLabelFormat.mysteryBoxContentItemName(this.label);
			this.drawBackground("",param5,260);
			this.drawElement(param2);
			this.resizeLabel();
		}
		
		private function buildCharSlotIcon() : Shape {
			var loc1:Shape = new Shape();
			loc1.graphics.beginFill(3880246);
			loc1.graphics.lineStyle(1,4603457);
			loc1.graphics.drawCircle(19,19,19);
			loc1.graphics.lineStyle();
			loc1.graphics.endFill();
			loc1.graphics.beginFill(2039583);
			loc1.graphics.drawRect(11,17,16,4);
			loc1.graphics.endFill();
			loc1.graphics.beginFill(2039583);
			loc1.graphics.drawRect(17,11,4,16);
			loc1.graphics.endFill();
			loc1.scaleX = 0.95;
			loc1.scaleY = 0.95;
			return loc1;
		}
		
		private function drawElement(param1:int) : void {
			var loc2:* = null;
			var loc3:BitmapData = null;
			var loc4:BitmapData = null;
			this._itemBackground = new Sprite();
			this._itemBackground.graphics.clear();
			this._itemBackground.graphics.beginFill(16777215,0);
			this._itemBackground.graphics.drawRect(0,0,this.itemSize,this.itemSize);
			this._itemBackground.graphics.endFill();
			addChild(this._itemBackground);
			this._itemBackground.x = 10;
			this._itemBackground.y = 4;
			switch(this._slotType) {
				case CHAR_SLOT:
					loc2 = param1.toString() + "x Character Slot";
					this._itemBackground.addChild(this.buildCharSlotIcon());
					break;
				case VAULT_SLOT:
					loc2 = param1.toString() + "x Vault Slot";
					loc3 = ObjectLibrary.getRedrawnTextureFromType(ObjectLibrary.idToType_["Vault Chest"],this._itemBackground.width * 2,true,false);
					this.imageBitmap = new Bitmap(loc3);
					this.imageBitmap.x = -Math.round((this.imageBitmap.width - this.itemSize) / 2);
					this.imageBitmap.y = -Math.round((this.imageBitmap.height - this.itemSize) / 2);
					this._itemBackground.addChild(this.imageBitmap);
					break;
				case GOLD_SLOT:
					loc2 = param1.toString() + " Gold";
					loc4 = IconFactory.makeCoin(this._itemBackground.width * 2);
					this.imageBitmap = new Bitmap(loc4);
					this.imageBitmap.x = -Math.round((this.imageBitmap.width - this.itemSize) / 2);
					this.imageBitmap.y = -Math.round((this.imageBitmap.height - this.itemSize) / 2) - 2;
					this._itemBackground.addChild(this.imageBitmap);
			}
			if(this.showFullName) {
				this.label.text = loc2;
				this.label.x = 55;
			} else {
				this.label.text = param1 + "x";
				this.label.x = 10;
				this._itemBackground.x = this._itemBackground.x + (this.label.x + 10);
			}
			addChild(this.label);
		}
		
		private function resizeLabel() : void {
			this.label.width = this.targetWidth - (this.itemSize + 2 * this.itemMargin) - 16;
			this.label.y = (height - this.label.textHeight - 4) / 2;
		}
		
		override public function resize(param1:int, param2:int = -1) : void {
			if(!this.isBackgroundCleared) {
				this.drawBackground("",this.isLastElement,param1);
			}
			this.targetWidth = param1;
			this.resizeLabel();
		}
		
		override public function dispose() : void {
			if(this.imageBitmap) {
				this.imageBitmap.bitmapData.dispose();
			}
			super.dispose();
		}
		
		public function get itemId() : String {
			return "Vault Chest";
		}
		
		public function get itemBackground() : Sprite {
			return this._itemBackground;
		}
		
		private function drawBackground(param1:String, param2:Boolean, param3:int) : void {
			if(param1 == "") {
				this.graphics.clear();
				this.graphics.beginFill(2960685);
				this.graphics.drawRect(0,0,param3,this.itemSize + 2 * this.itemMargin);
				this.graphics.endFill();
			}
		}
		
		public function get slotType() : String {
			return this._slotType;
		}
	}
}
