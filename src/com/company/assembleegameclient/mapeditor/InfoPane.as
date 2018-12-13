package com.company.assembleegameclient.mapeditor {
	import com.company.assembleegameclient.map.GroundLibrary;
	import com.company.assembleegameclient.map.RegionLibrary;
	import com.company.assembleegameclient.objects.ObjectLibrary;
	import com.company.ui.BaseSimpleText;
	import com.company.util.GraphicsUtil;

	import flash.display.CapsStyle;
	import flash.display.GraphicsPath;
	import flash.display.GraphicsSolidFill;
	import flash.display.GraphicsStroke;
	import flash.display.IGraphicsData;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;

	public class InfoPane extends Sprite {

		public static const WIDTH:int = 134;

		public static const HEIGHT:int = 120;

		private static const CSS_TEXT:String = ".in { margin-left:10px; text-indent: -10px; }";


		private var meMap_:MEMap;

		private var rectText_:BaseSimpleText;

		private var typeText_:BaseSimpleText;

		private var outlineFill_:GraphicsSolidFill;

		private var lineStyle_:GraphicsStroke;

		private var backgroundFill_:GraphicsSolidFill;

		private var path_:GraphicsPath;

		private var graphicsData_:Vector.<IGraphicsData>;

		public function InfoPane(param1:MEMap) {
			this.outlineFill_ = new GraphicsSolidFill(16777215, 1);
			this.lineStyle_ = new GraphicsStroke(1, false, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.ROUND, 3, this.outlineFill_);
			this.backgroundFill_ = new GraphicsSolidFill(3552822, 1);
			this.path_ = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());

			graphicsData_ = new <IGraphicsData>[this.lineStyle_, this.backgroundFill_, this.path_, GraphicsUtil.END_FILL, GraphicsUtil.END_STROKE];
			super();
			this.meMap_ = param1;
			this.drawBackground();
			this.rectText_ = new BaseSimpleText(12, 16777215, false, WIDTH - 10, 0);
			this.rectText_.filters = [new DropShadowFilter(0, 0, 0)];
			this.rectText_.y = 4;
			this.rectText_.x = 4;
			addChild(this.rectText_);
			this.typeText_ = new BaseSimpleText(12, 16777215, false, WIDTH - 10, 0);
			this.typeText_.wordWrap = true;
			this.typeText_.filters = [new DropShadowFilter(0, 0, 0)];
			this.typeText_.x = 4;
			this.typeText_.y = 36;
			addChild(this.typeText_);
			addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
		}

		private function onAddedToStage(param1:Event):void {
			addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
		}

		private function onRemovedFromStage(param1:Event):void {
			addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
		}

		private function onEnterFrame(param1:Event):void {
			var loc2:Rectangle = this.meMap_.mouseRectT();
			this.rectText_.text = "Position: " + loc2.x + ", " + loc2.y;
			if (loc2.width > 1 || loc2.height > 1) {
				this.rectText_.text = this.rectText_.text + ("\nRect: " + loc2.width + ", " + loc2.height);
			}
			this.rectText_.useTextDimensions();
			var loc3:METile = this.meMap_.getTile(loc2.x, loc2.y);
			var loc4:Vector.<int> = loc3 == null ? Layer.EMPTY_TILE : loc3.types_;
			var loc5:String = loc4[Layer.GROUND] == -1 ? "None" : GroundLibrary.getIdFromType(loc4[Layer.GROUND]);
			var loc6:String = loc4[Layer.OBJECT] == -1 ? "None" : ObjectLibrary.getIdFromType(loc4[Layer.OBJECT]);
			var loc7:String = loc4[Layer.REGION] == -1 ? "None" : RegionLibrary.getIdFromType(loc4[Layer.REGION]);
			this.typeText_.htmlText = "<span class=\'in\'>" + "Ground: " + loc5 + "\nObject: " + loc6 + (loc3 == null || loc3.objName_ == null ? "" : " (" + loc3.objName_ + ")") + "\nRegion: " + loc7 + "</span>";
			this.typeText_.useTextDimensions();
		}

		private function drawBackground():void {
			GraphicsUtil.clearPath(this.path_);
			GraphicsUtil.drawCutEdgeRect(0, 0, WIDTH, HEIGHT, 4, [1, 1, 1, 1], this.path_);
			graphics.drawGraphicsData(this.graphicsData_);
		}
	}
}
