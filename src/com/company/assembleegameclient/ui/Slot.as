package com.company.assembleegameclient.ui {
	import com.company.util.GraphicsUtil;
	import com.company.util.MoreColorUtil;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.GraphicsPath;
	import flash.display.GraphicsSolidFill;
	import flash.display.IGraphicsData;
	import flash.display.Sprite;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;

	import kabam.rotmg.constants.ItemConstants;
	import kabam.rotmg.core.StaticInjectorContext;
	import kabam.rotmg.text.view.BitmapTextFactory;
	import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;

	public class Slot extends Sprite {

		public static const IDENTITY_MATRIX:Matrix = new Matrix();

		public static const WIDTH:int = 40;

		public static const HEIGHT:int = 40;

		public static const BORDER:int = 4;

		private static const greyColorFilter:ColorMatrixFilter = new ColorMatrixFilter(MoreColorUtil.singleColorFilterMatrix(3552822));


		public var type_:int;

		public var hotkey_:int;

		public var cuts_:Array;

		public var backgroundImage_:Bitmap;

		protected var fill_:GraphicsSolidFill;

		protected var path_:GraphicsPath;

		private var graphicsData_:Vector.<IGraphicsData>;

		public function Slot(param1:int, param2:int, param3:Array) {
			this.fill_ = new GraphicsSolidFill(5526612, 1);
			this.path_ = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());
			this.graphicsData_ = new <IGraphicsData>[this.fill_, this.path_, GraphicsUtil.END_FILL];
			super();
			this.type_ = param1;
			this.hotkey_ = param2;
			this.cuts_ = param3;
			this.drawBackground();
		}

		protected function offsets(param1:int, param2:int, param3:Boolean):Point {
			var loc4:Point = new Point();
			switch (param2) {
				case ItemConstants.RING_TYPE:
					loc4.x = param1 == 2878 ? Number(0) : Number(-2);
					loc4.y = !!param3 ? Number(-2) : Number(0);
					break;
				case ItemConstants.SPELL_TYPE:
					loc4.y = -2;
			}
			return loc4;
		}

		protected function drawBackground():void {
			var loc2:Point = null;
			var loc3:BitmapTextFactory = null;
			GraphicsUtil.clearPath(this.path_);
			GraphicsUtil.drawCutEdgeRect(0, 0, WIDTH, HEIGHT, 4, this.cuts_, this.path_);
			graphics.clear();
			graphics.drawGraphicsData(this.graphicsData_);
			var loc1:BitmapData = ItemConstants.itemTypeToBaseSprite(this.type_);
			if (this.backgroundImage_ == null) {
				if (loc1 != null) {
					loc2 = this.offsets(-1, this.type_, true);
					this.backgroundImage_ = new Bitmap(loc1);
					this.backgroundImage_.x = BORDER + loc2.x;
					this.backgroundImage_.y = BORDER + loc2.y;
					this.backgroundImage_.scaleX = 4;
					this.backgroundImage_.scaleY = 4;
					this.backgroundImage_.filters = [greyColorFilter];
					addChild(this.backgroundImage_);
				} else if (this.hotkey_ > 0) {
					loc3 = StaticInjectorContext.getInjector().getInstance(BitmapTextFactory);
					loc1 = loc3.make(new StaticStringBuilder(String(this.hotkey_)), 26, 3552822, true, IDENTITY_MATRIX, false);
					this.backgroundImage_ = new Bitmap(loc1);
					this.backgroundImage_.x = WIDTH / 2 - loc1.width / 2;
					this.backgroundImage_.y = HEIGHT / 2 - 18;
					addChild(this.backgroundImage_);
				}
			}
		}
	}
}
