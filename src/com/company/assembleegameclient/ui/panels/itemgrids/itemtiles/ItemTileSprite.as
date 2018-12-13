 
package com.company.assembleegameclient.ui.panels.itemgrids.itemtiles {
	import com.company.assembleegameclient.objects.ObjectLibrary;
	import com.company.util.PointUtil;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Matrix;
	import kabam.rotmg.constants.ItemConstants;
	import kabam.rotmg.text.view.BitmapTextFactory;
	import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
	import kabam.rotmg.ui.view.components.PotionSlotView;
	
	public class ItemTileSprite extends Sprite {
		
		protected static const DIM_FILTER:Array = [new ColorMatrixFilter([0.4,0,0,0,0,0,0.4,0,0,0,0,0,0.4,0,0,0,0,0,1,0])];
		
		private static const IDENTITY_MATRIX:Matrix = new Matrix();
		
		private static const DOSE_MATRIX:Matrix = function():Matrix {
			var loc1:* = new Matrix();
			loc1.translate(8,7);
			return loc1;
		}();
		 
		
		public var itemId:int;
		
		public var itemBitmap:Bitmap;
		
		private var bitmapFactory:BitmapTextFactory;
		
		public function ItemTileSprite() {
			super();
			this.itemBitmap = new Bitmap();
			addChild(this.itemBitmap);
			this.itemId = -1;
		}
		
		public function setDim(param1:Boolean) : void {
			filters = !!param1?DIM_FILTER:null;
		}
		
		public function setType(param1:int) : void {
			this.itemId = param1;
			this.drawTile();
		}
		
		public function drawTile() : void {
			var loc2:BitmapData = null;
			var loc3:XML = null;
			var loc4:BitmapData = null;
			var loc5:BitmapData = null;
			var loc1:int = this.itemId;
			if(loc1 != ItemConstants.NO_ITEM) {
				if(loc1 >= 36864 && loc1 < 61440) {
					loc1 = 36863;
				}
				loc2 = ObjectLibrary.getRedrawnTextureFromType(loc1,80,true);
				loc3 = ObjectLibrary.xmlLibrary_[loc1];
				if(loc3 && loc3.hasOwnProperty("Doses") && this.bitmapFactory) {
					loc2 = loc2.clone();
					loc4 = this.bitmapFactory.make(new StaticStringBuilder(String(loc3.Doses)),12,16777215,false,IDENTITY_MATRIX,false);
					loc4.applyFilter(loc4,loc4.rect,PointUtil.ORIGIN,PotionSlotView.READABILITY_SHADOW_2);
					loc2.draw(loc4,DOSE_MATRIX);
				}
				if(loc3 && loc3.hasOwnProperty("Quantity") && this.bitmapFactory) {
					loc2 = loc2.clone();
					loc5 = this.bitmapFactory.make(new StaticStringBuilder(String(loc3.Quantity)),12,16777215,false,IDENTITY_MATRIX,false);
					loc5.applyFilter(loc5,loc5.rect,PointUtil.ORIGIN,PotionSlotView.READABILITY_SHADOW_2);
					loc2.draw(loc5,DOSE_MATRIX);
				}
				this.itemBitmap.bitmapData = loc2;
				this.itemBitmap.x = -loc2.width / 2;
				this.itemBitmap.y = -loc2.height / 2;
				visible = true;
			} else {
				visible = false;
			}
		}
		
		public function setBitmapFactory(param1:BitmapTextFactory) : void {
			this.bitmapFactory = param1;
		}
	}
}
