 
package com.company.assembleegameclient.ui.panels.itemgrids.itemtiles {
	import com.company.assembleegameclient.ui.panels.itemgrids.ItemGrid;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import kabam.rotmg.core.StaticInjectorContext;
	import kabam.rotmg.text.view.BitmapTextFactory;
	import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
	
	public class InventoryTile extends InteractiveItemTile {
		
		private static const IDENTITY_MATRIX:Matrix = new Matrix();
		 
		
		public var hotKey:int;
		
		private var hotKeyBMP:Bitmap;
		
		public function InventoryTile(param1:int, param2:ItemGrid, param3:Boolean) {
			super(param1,param2,param3);
		}
		
		public function addTileNumber(param1:int) : void {
			this.hotKey = param1;
			this.buildHotKeyBMP();
		}
		
		public function buildHotKeyBMP() : void {
			var loc1:BitmapTextFactory = StaticInjectorContext.getInjector().getInstance(BitmapTextFactory);
			var loc2:BitmapData = loc1.make(new StaticStringBuilder(String(this.hotKey)),26,3552822,true,IDENTITY_MATRIX,false);
			this.hotKeyBMP = new Bitmap(loc2);
			this.hotKeyBMP.x = WIDTH / 2 - this.hotKeyBMP.width / 2;
			this.hotKeyBMP.y = HEIGHT / 2 - 14;
			addChildAt(this.hotKeyBMP,0);
		}
		
		override public function setItemSprite(param1:ItemTileSprite) : void {
			super.setItemSprite(param1);
			param1.setDim(false);
		}
		
		override public function setItem(param1:int) : Boolean {
			var loc2:Boolean = super.setItem(param1);
			if(loc2) {
				this.hotKeyBMP.visible = itemSprite.itemId <= 0;
			}
			return loc2;
		}
		
		override protected function beginDragCallback() : void {
			this.hotKeyBMP.visible = true;
		}
		
		override protected function endDragCallback() : void {
			this.hotKeyBMP.visible = itemSprite.itemId <= 0;
		}
	}
}
