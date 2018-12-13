package io.decagames.rotmg.ui.gird {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;

	import io.decagames.rotmg.ui.scroll.UIScrollbar;
	import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
	import io.decagames.rotmg.ui.texture.TextureParser;

	public class UIGrid extends Sprite {


		private var elements:Vector.<UIGridElement>;

		private var decors:Vector.<SliceScalingBitmap>;

		private var gridMargin:int;

		private var gridWidth:int;

		private var numberOfColumns:int;

		private var scrollHeight:int;

		private var scroll:UIScrollbar;

		private var gridContent:Sprite;

		private var gridMask:Sprite;

		private var _centerLastRow:Boolean;

		private var lastRenderedItemsNumber:int = 0;

		private var elementWidth:int;

		private var _decorBitmap:String = "";

		public function UIGrid(param1:int, param2:int, param3:int, param4:int = -1, param5:int = 0, param6:DisplayObject = null) {
			super();
			this.elements = new Vector.<UIGridElement>();
			this.decors = new Vector.<SliceScalingBitmap>();
			this.gridMargin = param3;
			this.gridWidth = param1;
			this.gridContent = new Sprite();
			this.addChild(this.gridContent);
			this.scrollHeight = param4;
			if (param4 > 0) {
				this.scroll = new UIScrollbar(param4);
				this.scroll.x = param1 + param5;
				addChild(this.scroll);
				this.scroll.content = this.gridContent;
				this.scroll.scrollObject = param6;
				this.gridMask = new Sprite();
			}
			this.numberOfColumns = param2;
			this.addEventListener(Event.ADDED_TO_STAGE, this.onAddedHandler);
		}

		override public function set width(param1:Number):void {
			this.gridWidth = param1;
			this.render();
		}

		public function get numberOfElements():int {
			return this.elements.length;
		}

		private function onAddedHandler(param1:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, this.onAddedHandler);
			this.addEventListener(Event.ENTER_FRAME, this.onUpdate);
			this.render();
		}

		public function addGridElement(param1:UIGridElement):void {
			if (this.elements) {
				this.elements.push(param1);
				this.gridContent.addChild(param1);
				if (this.stage) {
					this.render();
				}
			}
		}

		private function addDecorToRow(param1:int, param2:int, param3:int):void {
			var loc5:SliceScalingBitmap = null;
			param3--;
			if (param3 == 0) {
				param3 = 1;
			}
			var loc4:int = 0;
			while (loc4 < param3) {
				loc5 = TextureParser.instance.getSliceScalingBitmap("UI", this._decorBitmap);
				loc5.x = Math.round(loc4 * (this.gridMargin / 2) + (loc4 + 1) * (this.elementWidth + this.gridMargin / 2) - loc5.width / 2);
				loc5.y = Math.round(param1 + param2 - loc5.height / 2 + this.gridMargin / 2);
				this.gridContent.addChild(loc5);
				this.decors.push(loc5);
				loc4++;
			}
		}

		public function clearGrid():void {
			var loc1:UIGridElement = null;
			var loc2:SliceScalingBitmap = null;
			for each(loc1 in this.elements) {
				this.gridContent.removeChild(loc1);
				loc1.dispose();
			}
			for each(loc2 in this.decors) {
				this.gridContent.removeChild(loc2);
				loc2.dispose();
			}
			if (this.elements) {
				this.elements.length = 0;
			}
			if (this.decors) {
				this.decors.length = 0;
			}
			this.lastRenderedItemsNumber = 0;
		}

		public function render():void {
			var loc8:UIGridElement = null;
			var loc9:int = 0;
			if (this.lastRenderedItemsNumber == this.elements.length) {
				return;
			}
			this.elementWidth = (this.gridWidth - (this.numberOfColumns - 1) * this.gridMargin) / this.numberOfColumns;
			var loc1:int = 1;
			var loc2:int = 0;
			var loc3:int = 0;
			var loc4:int = 0;
			var loc5:int = Math.ceil(this.elements.length / this.numberOfColumns);
			var loc6:int = 1;
			var loc7:int = 0;
			for each(loc8 in this.elements) {
				loc8.resize(this.elementWidth);
				if (loc8.height > loc4) {
					loc4 = loc8.height;
				}
				loc8.x = loc2;
				loc8.y = loc3;
				loc1++;
				if (loc1 > this.numberOfColumns) {
					if (this._decorBitmap != "") {
						loc7 = loc6;
						this.addDecorToRow(loc3, loc4, loc1 - 1);
					}
					loc6++;
					loc2 = 0;
					if (loc6 == loc5 && this._centerLastRow) {
						loc9 = loc6 * this.numberOfColumns - this.elements.length;
						loc2 = Math.round((loc9 * this.elementWidth + (loc9 - 1) * this.gridMargin) / 2);
					}
					loc3 = loc3 + (loc4 + this.gridMargin);
					loc4 = 0;
					loc1 = 1;
				} else {
					loc2 = loc2 + (this.elementWidth + this.gridMargin);
				}
			}
			if (this._decorBitmap != "" && loc7 != loc6) {
				this.addDecorToRow(loc3, loc4, loc1 - 1);
			}
			if (this.scrollHeight != -1) {
				this.gridMask.graphics.clear();
				this.gridMask.graphics.beginFill(16711680);
				this.gridMask.graphics.drawRect(0, 0, this.gridWidth, this.scrollHeight);
				this.gridContent.mask = this.gridMask;
				addChild(this.gridMask);
			}
			this.lastRenderedItemsNumber = this.elements.length;
		}

		public function dispose():void {
			var loc1:UIGridElement = null;
			var loc2:SliceScalingBitmap = null;
			this.removeEventListener(Event.ENTER_FRAME, this.onUpdate);
			for each(loc1 in this.elements) {
				loc1.dispose();
			}
			for each(loc2 in this.decors) {
				loc2.dispose();
			}
			this.elements = null;
		}

		private function onUpdate(param1:Event):void {
			var loc2:UIGridElement = null;
			for each(loc2 in this.elements) {
				loc2.update();
			}
		}

		public function get centerLastRow():Boolean {
			return this._centerLastRow;
		}

		public function set centerLastRow(param1:Boolean):void {
			this._centerLastRow = param1;
		}

		public function get decorBitmap():String {
			return this._decorBitmap;
		}

		public function set decorBitmap(param1:String):void {
			this._decorBitmap = param1;
		}
	}
}
