package kabam.rotmg.dailyLogin.view {
	import com.company.assembleegameclient.objects.ObjectLibrary;
	import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.EquipmentTile;
	import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.ItemTile;
	import com.company.assembleegameclient.ui.tooltip.EquipmentToolTip;
	import com.company.assembleegameclient.ui.tooltip.TextToolTip;
	import com.company.assembleegameclient.ui.tooltip.ToolTip;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Matrix;

	import kabam.rotmg.constants.ItemConstants;
	import kabam.rotmg.core.StaticInjectorContext;
	import kabam.rotmg.core.signals.HideTooltipsSignal;
	import kabam.rotmg.core.signals.ShowTooltipSignal;
	import kabam.rotmg.dailyLogin.config.CalendarSettings;
	import kabam.rotmg.text.model.TextKey;
	import kabam.rotmg.text.view.BitmapTextFactory;
	import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;

	import org.swiftsuspenders.Injector;

	public class ItemTileRenderer extends Sprite {

		protected static const DIM_FILTER:Array = [new ColorMatrixFilter([0.4, 0, 0, 0, 0, 0, 0.4, 0, 0, 0, 0, 0, 0.4, 0, 0, 0, 0, 0, 1, 0])];

		private static const IDENTITY_MATRIX:Matrix = new Matrix();

		private static const DOSE_MATRIX:Matrix = function ():Matrix {
			var loc1:* = new Matrix();
			loc1.translate(10, 5);
			return loc1;
		}();


		private var itemId:int;

		private var bitmapFactory:BitmapTextFactory;

		private var tooltip:ToolTip;

		private var itemBitmap:Bitmap;

		public function ItemTileRenderer(param1:int) {
			super();
			this.itemId = param1;
			this.itemBitmap = new Bitmap();
			addChild(this.itemBitmap);
			this.drawTile();
			this.addEventListener(MouseEvent.MOUSE_OVER, this.onTileHover);
			this.addEventListener(MouseEvent.MOUSE_OUT, this.onTileOut);
		}

		private function onTileOut(param1:MouseEvent):void {
			var loc2:Injector = StaticInjectorContext.getInjector();
			var loc3:HideTooltipsSignal = loc2.getInstance(HideTooltipsSignal);
			loc3.dispatch();
		}

		private function onTileHover(param1:MouseEvent):void {
			if (!stage) {
				return;
			}
			var loc2:ItemTile = param1.currentTarget as ItemTile;
			this.addToolTipToTile(loc2);
		}

		private function addToolTipToTile(param1:ItemTile):void {
			var loc4:String = null;
			if (this.itemId > 0) {
				this.tooltip = new EquipmentToolTip(this.itemId, null, -1, "");
			} else {
				if (param1 is EquipmentTile) {
					loc4 = ItemConstants.itemTypeToName((param1 as EquipmentTile).itemType);
				} else {
					loc4 = TextKey.ITEM;
				}
				this.tooltip = new TextToolTip(3552822, 10197915, null, TextKey.ITEM_EMPTY_SLOT, 200, {"itemType": TextKey.wrapForTokenResolution(loc4)});
			}
			this.tooltip.attachToTarget(param1);
			var loc2:Injector = StaticInjectorContext.getInjector();
			var loc3:ShowTooltipSignal = loc2.getInstance(ShowTooltipSignal);
			loc3.dispatch(this.tooltip);
		}

		public function drawTile():void {
			var loc2:BitmapData = null;
			var loc3:XML = null;
			var loc4:BitmapData = null;
			var loc5:BitmapData = null;
			var loc1:int = this.itemId;
			if (loc1 != ItemConstants.NO_ITEM) {
				if (loc1 >= 36864 && loc1 < 61440) {
					loc1 = 36863;
				}
				loc2 = ObjectLibrary.getRedrawnTextureFromType(loc1, CalendarSettings.ITEM_SIZE, true);
				loc3 = ObjectLibrary.xmlLibrary_[loc1];
				if (loc3 && loc3.hasOwnProperty("Doses") && this.bitmapFactory) {
					loc2 = loc2.clone();
					loc4 = this.bitmapFactory.make(new StaticStringBuilder(String(loc3.Doses)), 12, 16777215, false, IDENTITY_MATRIX, false);
					loc2.draw(loc4, DOSE_MATRIX);
				}
				if (loc3 && loc3.hasOwnProperty("Quantity") && this.bitmapFactory) {
					loc2 = loc2.clone();
					loc5 = this.bitmapFactory.make(new StaticStringBuilder(String(loc3.Quantity)), 12, 16777215, false, IDENTITY_MATRIX, false);
					loc2.draw(loc5, DOSE_MATRIX);
				}
				this.itemBitmap.bitmapData = loc2;
				this.itemBitmap.x = -loc2.width / 2;
				this.itemBitmap.y = -loc2.width / 2;
				visible = true;
			} else {
				visible = false;
			}
		}
	}
}
