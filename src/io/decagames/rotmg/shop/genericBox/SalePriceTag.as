 
package io.decagames.rotmg.shop.genericBox {
	import com.company.assembleegameclient.util.Currency;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
	import io.decagames.rotmg.ui.labels.UILabel;
	import kabam.rotmg.assets.services.IconFactory;
	
	public class SalePriceTag extends Sprite {
		 
		
		private var coinBitmap:Bitmap;
		
		public function SalePriceTag(param1:int, param2:int) {
			var loc4:Sprite = null;
			super();
			var loc3:UILabel = new UILabel();
			DefaultLabelFormat.originalPriceButtonLabel(loc3);
			loc3.text = param1.toString();
			loc4 = new Sprite();
			var loc5:BitmapData = param2 == Currency.GOLD?IconFactory.makeCoin(35):IconFactory.makeFame(35);
			this.coinBitmap = new Bitmap(loc5);
			this.coinBitmap.y = 0;
			addChild(this.coinBitmap);
			addChild(loc3);
			this.coinBitmap.x = loc3.textWidth + 5;
			addChild(loc4);
			loc4.graphics.lineStyle(2,16711722,0.6);
			loc4.graphics.lineTo(this.width,0);
			loc4.y = (loc3.textHeight + 2) / 2;
		}
		
		public function dispose() : void {
			this.coinBitmap.bitmapData.dispose();
		}
	}
}
