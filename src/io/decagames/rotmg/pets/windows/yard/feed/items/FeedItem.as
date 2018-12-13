package io.decagames.rotmg.pets.windows.yard.feed.items {
	import com.company.assembleegameclient.objects.ObjectLibrary;
	import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.InventoryTile;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;

	import io.decagames.rotmg.ui.gird.UIGridElement;

	import kabam.rotmg.core.StaticInjectorContext;
	import kabam.rotmg.text.view.BitmapTextFactory;
	import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;

	public class FeedItem extends UIGridElement {


		private var _item:InventoryTile;

		private var imageBitmap:Bitmap;

		private var _feedPower:int;

		private var _selected:Boolean;

		public function FeedItem(param1:InventoryTile) {
			super();
			this._item = param1;
			this.renderBackground(4539717, 0.25);
			this.renderItem();
		}

		private function renderBackground(param1:uint, param2:Number):void {
			graphics.clear();
			graphics.beginFill(param1, param2);
			graphics.drawRect(0, 0, 40, 40);
		}

		private function renderItem():void {
			var loc4:BitmapData = null;
			var loc5:Matrix = null;
			this.imageBitmap = new Bitmap();
			var loc1:BitmapData = ObjectLibrary.getRedrawnTextureFromType(this._item.getItemId(), 40, true);
			loc1 = loc1.clone();
			var loc2:XML = ObjectLibrary.xmlLibrary_[this._item.getItemId()];
			this._feedPower = loc2.feedPower;
			var loc3:BitmapTextFactory = StaticInjectorContext.getInjector().getInstance(BitmapTextFactory);
			if (loc2 && loc2.hasOwnProperty("Quantity") && loc3) {
				loc4 = loc3.make(new StaticStringBuilder(String(loc2.Quantity)), 12, 16777215, false, new Matrix(), true);
				loc5 = new Matrix();
				loc5.translate(8, 7);
				loc1.draw(loc4, loc5);
			}
			this.imageBitmap.bitmapData = loc1;
			addChild(this.imageBitmap);
		}

		override public function dispose():void {
			super.dispose();
			this.imageBitmap.bitmapData.dispose();
		}

		public function get itemId():int {
			return this._item.getItemId();
		}

		public function get feedPower():int {
			return this._feedPower;
		}

		public function get selected():Boolean {
			return this._selected;
		}

		public function set selected(param1:Boolean):void {
			this._selected = param1;
			if (param1) {
				this.renderBackground(15306295, 1);
			} else {
				this.renderBackground(4539717, 0.25);
			}
		}

		public function get item():InventoryTile {
			return this._item;
		}
	}
}
