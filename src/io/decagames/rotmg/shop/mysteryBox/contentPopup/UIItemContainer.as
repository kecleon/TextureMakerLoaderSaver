 
package io.decagames.rotmg.shop.mysteryBox.contentPopup {
	import com.company.assembleegameclient.objects.ObjectLibrary;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filters.DropShadowFilter;
	import flash.text.TextFormat;
	import io.decagames.rotmg.ui.gird.UIGridElement;
	import io.decagames.rotmg.ui.labels.UILabel;
	import kabam.rotmg.text.model.FontModel;
	
	public class UIItemContainer extends UIGridElement {
		 
		
		private var _itemId:int;
		
		private var size:int;
		
		private var background:uint;
		
		private var backgroundAlpha:Number;
		
		private var _imageBitmap:Bitmap;
		
		private var _quantity:int = 1;
		
		private var _showTooltip:Boolean;
		
		public function UIItemContainer(param1:int, param2:uint, param3:Number = 0.0, param4:int = 40) {
			super();
			this._itemId = param1;
			this.size = param4;
			this.background = param2;
			this.backgroundAlpha = param3;
			this.graphics.clear();
			this.graphics.beginFill(param2,param3);
			this.graphics.drawRect(0,0,param4,param4);
			this.graphics.endFill();
			var loc5:BitmapData = ObjectLibrary.getRedrawnTextureFromType(int(param1),param4 * 2,true,false);
			this._imageBitmap = new Bitmap(loc5);
			this._imageBitmap.x = -Math.round((this._imageBitmap.width - param4) / 2);
			this._imageBitmap.y = -Math.round((this._imageBitmap.height - param4) / 2);
			this.addChild(this._imageBitmap);
		}
		
		override public function dispose() : void {
			this._imageBitmap.bitmapData.dispose();
			super.dispose();
		}
		
		public function showQuantityLabel(param1:int) : void {
			var loc2:UILabel = null;
			this._quantity = param1;
			loc2 = new UILabel();
			var loc3:TextFormat = new TextFormat();
			loc3.color = 16777215;
			loc3.bold = true;
			loc3.font = FontModel.DEFAULT_FONT_NAME;
			loc3.size = this.size * 0.35;
			loc2.defaultTextFormat = loc3;
			loc2.text = param1 + "x";
			loc2.y = this.size - loc2.textHeight - this.size * 0.1;
			loc2.x = this.size - loc2.textWidth - this.size * 0.1;
			loc2.filters = [new DropShadowFilter(1,90,0,0.5,4,4)];
			addChild(loc2);
		}
		
		public function clone() : UIItemContainer {
			var loc1:UIItemContainer = new UIItemContainer(this._itemId,this.background,this.backgroundAlpha,this.size);
			if(this._quantity > 1) {
				loc1.showQuantityLabel(this._quantity);
			}
			return loc1;
		}
		
		public function get itemId() : int {
			return this._itemId;
		}
		
		override public function get width() : Number {
			return this.size;
		}
		
		override public function get height() : Number {
			return this.size;
		}
		
		public function get imageBitmap() : Bitmap {
			return this._imageBitmap;
		}
		
		public function get showTooltip() : Boolean {
			return this._showTooltip;
		}
		
		public function set showTooltip(param1:Boolean) : void {
			this._showTooltip = param1;
		}
		
		public function get quantity() : int {
			return this._quantity;
		}
	}
}
