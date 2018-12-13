 
package io.decagames.rotmg.dailyQuests.view.slot {
	import com.company.assembleegameclient.objects.ObjectLibrary;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import io.decagames.rotmg.utils.colors.GreyScale;
	import kabam.rotmg.core.StaticInjectorContext;
	import kabam.rotmg.text.view.BitmapTextFactory;
	import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
	
	public class DailyQuestItemSlot extends Sprite {
		
		public static const SELECTED_BORDER_SIZE:int = 2;
		
		public static const SLOT_SIZE:int = 40;
		 
		
		private var _itemID:int;
		
		private var _type:String;
		
		private var bitmapFactory:BitmapTextFactory;
		
		private var imageContainer:Sprite;
		
		private var _isSlotsSelectable:Boolean;
		
		private var _selected:Boolean;
		
		private var backgroundShape:Shape;
		
		private var hasItem:Boolean;
		
		private var imageBitmap:Bitmap;
		
		public function DailyQuestItemSlot(param1:int, param2:String, param3:Boolean = false, param4:Boolean = false) {
			super();
			this._itemID = param1;
			this._type = param2;
			this._isSlotsSelectable = param4;
			this.hasItem = param3;
			this.imageBitmap = new Bitmap();
			this.imageContainer = new Sprite();
			addChild(this.imageContainer);
			this.imageContainer.x = Math.round(SLOT_SIZE / 2);
			this.imageContainer.y = Math.round(SLOT_SIZE / 2);
			this.createBackground();
			this.renderItem();
		}
		
		private function createBackground() : void {
			if(!this.backgroundShape) {
				this.backgroundShape = new Shape();
				this.imageContainer.addChild(this.backgroundShape);
			}
			this.backgroundShape.graphics.clear();
			if(this.isSlotsSelectable) {
				if(this._selected) {
					this.backgroundShape.graphics.beginFill(14846006,1);
					this.backgroundShape.graphics.drawRect(-SELECTED_BORDER_SIZE,-SELECTED_BORDER_SIZE,SLOT_SIZE + SELECTED_BORDER_SIZE * 2,SLOT_SIZE + SELECTED_BORDER_SIZE * 2);
					this.backgroundShape.graphics.beginFill(14846006,1);
				} else {
					this.backgroundShape.graphics.beginFill(4539717,1);
				}
			} else {
				this.backgroundShape.graphics.beginFill(!!this.hasItem?uint(1286144):uint(4539717),1);
			}
			this.backgroundShape.graphics.drawRect(0,0,SLOT_SIZE,SLOT_SIZE);
			this.backgroundShape.x = -Math.round((SLOT_SIZE + SELECTED_BORDER_SIZE * 2) / 2);
			this.backgroundShape.y = -Math.round((SLOT_SIZE + SELECTED_BORDER_SIZE * 2) / 2);
		}
		
		private function renderItem() : void {
			var loc3:BitmapData = null;
			var loc4:Matrix = null;
			if(this.imageBitmap.bitmapData) {
				this.imageBitmap.bitmapData.dispose();
			}
			var loc1:BitmapData = ObjectLibrary.getRedrawnTextureFromType(this._itemID,SLOT_SIZE * 2,true);
			loc1 = loc1.clone();
			var loc2:XML = ObjectLibrary.xmlLibrary_[this._itemID];
			this.bitmapFactory = StaticInjectorContext.getInjector().getInstance(BitmapTextFactory);
			if(loc2 && loc2.hasOwnProperty("Quantity") && this.bitmapFactory) {
				loc3 = this.bitmapFactory.make(new StaticStringBuilder(String(loc2.Quantity)),12,16777215,false,new Matrix(),true);
				loc4 = new Matrix();
				loc4.translate(8,7);
				loc1.draw(loc3,loc4);
			}
			this.imageBitmap.bitmapData = loc1;
			if(this.isSlotsSelectable && !this._selected) {
				GreyScale.setGreyScale(loc1);
			}
			if(!this.imageBitmap.parent) {
				this.imageBitmap.x = -Math.round(this.imageBitmap.width / 2);
				this.imageBitmap.y = -Math.round(this.imageBitmap.height / 2);
				this.imageContainer.addChild(this.imageBitmap);
			}
		}
		
		public function set selected(param1:Boolean) : void {
			this._selected = param1;
			this.createBackground();
			this.renderItem();
		}
		
		public function dispose() : void {
			if(this.imageBitmap && this.imageBitmap.bitmapData) {
				this.imageBitmap.bitmapData.dispose();
			}
		}
		
		public function get itemID() : int {
			return this._itemID;
		}
		
		public function get type() : String {
			return this._type;
		}
		
		public function get isSlotsSelectable() : Boolean {
			return this._isSlotsSelectable;
		}
		
		public function get selected() : Boolean {
			return this._selected;
		}
	}
}
