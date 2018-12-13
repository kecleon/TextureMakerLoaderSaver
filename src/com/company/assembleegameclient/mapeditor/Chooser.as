 
package com.company.assembleegameclient.mapeditor {
	import com.adobe.images.PNGEncoder;
	import com.company.assembleegameclient.ui.Scrollbar;
	import com.company.util.GraphicsUtil;
	import flash.display.BitmapData;
	import flash.display.CapsStyle;
	import flash.display.GraphicsPath;
	import flash.display.GraphicsSolidFill;
	import flash.display.GraphicsStroke;
	import flash.display.IGraphicsData;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	class Chooser extends Sprite {
		
		public static const WIDTH:int = 136;
		
		public static const HEIGHT:int = 430;
		
		public static const SCROLLBAR_WIDTH:int = 20;
		 
		
		public var layer_:int;
		
		public var selected_:Element;
		
		protected var elementContainer_:Sprite;
		
		protected var scrollBar_:Scrollbar;
		
		private var graphicsData_:Vector.<IGraphicsData>;
		private var elements_:Vector.<Element>;

		private var outlineFill_:GraphicsSolidFill;

		private var lineStyle_:GraphicsStroke;

		private var backgroundFill_:GraphicsSolidFill;

		private var path_:GraphicsPath;

		private var _hasBeenLoaded:Boolean;

		function Chooser(param1:int) {
			this.elements_ = new Vector.<Element>();
			this.outlineFill_ = new GraphicsSolidFill(16777215,1);
			this.lineStyle_ = new GraphicsStroke(1,false,LineScaleMode.NORMAL,CapsStyle.NONE,JointStyle.ROUND,3,this.outlineFill_);
			this.backgroundFill_ = new GraphicsSolidFill(3552822,1);
			this.path_ = new GraphicsPath(new Vector.<int>(),new Vector.<Number>());

			graphicsData_ = new <IGraphicsData>[this.lineStyle_,this.backgroundFill_,this.path_,GraphicsUtil.END_FILL,GraphicsUtil.END_STROKE];
			super();
			this.layer_ = param1;
			this.init();
		}
		
		public function selectedType() : int {
			return this.selected_.type_;
		}
		
		public function setSelectedType(param1:int) : void {
			var loc2:Element = null;
			for each(loc2 in this.elements_) {
				if(loc2.type_ == param1) {
					this.setSelected(loc2);
					return;
				}
			}
		}
		
		protected function addElement(param1:Element) : void {
			var loc2:int = this.elements_.length;
			param1.x = loc2 % 2 == 0?Number(0):Number(2 + Element.WIDTH);
			param1.y = int(loc2 / 2) * Element.HEIGHT + 6;
			this.elementContainer_.addChild(param1);
			if(loc2 == 0) {
				this.setSelected(param1);
			}
			param1.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
			this.elements_.push(param1);
		}
		
		protected function removeElements() : void {
			this.elementContainer_.removeChildren();
			if(!this.elements_) {
				this.elements_ = new Vector.<Element>();
			} else {
				this.cleanupElements();
			}
			this._hasBeenLoaded = false;
		}
		
		private function cleanupElements() : void {
			var loc2:Element = null;
			var loc1:int = this.elements_.length - 1;
			while(loc1 >= 0) {
				loc2 = this.elements_.pop();
				loc2.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
				loc1--;
			}
		}
		
		protected function setSelected(param1:Element) : void {
			if(this.selected_ != null) {
				this.selected_.setSelected(false);
			}
			this.selected_ = param1;
			this.selected_.setSelected(true);
		}
		
		private function init() : void {
			this.drawBackground();
			this.elementContainer_ = new Sprite();
			this.elementContainer_.x = 4;
			this.elementContainer_.y = 6;
			addChild(this.elementContainer_);
			this.scrollBar_ = new Scrollbar(SCROLLBAR_WIDTH,HEIGHT - 8,0.1,this);
			this.scrollBar_.x = WIDTH - SCROLLBAR_WIDTH - 6;
			this.scrollBar_.y = 4;
			var loc1:Shape = new Shape();
			loc1.graphics.beginFill(0);
			loc1.graphics.drawRect(0,2,Chooser.WIDTH - SCROLLBAR_WIDTH - 4,Chooser.HEIGHT - 4);
			addChild(loc1);
			this.elementContainer_.mask = loc1;
			addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
		}
		
		private function downloadElement(param1:Element) : void {
			var loc3:ByteArray = null;
			var loc4:FileReference = null;
			var loc2:BitmapData = param1.objectBitmap;
			if(loc2 != null) {
				loc3 = PNGEncoder.encode(param1.objectBitmap);
				loc4 = new FileReference();
				loc4.save(loc3,param1.type_ + ".png");
			}
		}
		
		private function drawBackground() : void {
			GraphicsUtil.clearPath(this.path_);
			GraphicsUtil.drawCutEdgeRect(0,0,WIDTH,HEIGHT,4,[1,1,1,1],this.path_);
			graphics.drawGraphicsData(this.graphicsData_);
		}
		
		protected function onMouseDown(param1:MouseEvent) : void {
			var loc2:Element = param1.currentTarget as Element;
			if(loc2.downloadOnly) {
				this.downloadElement(loc2);
			} else {
				this.setSelected(loc2);
			}
		}
		
		protected function onScrollBarChange(param1:Event) : void {
			this.elementContainer_.y = 6 - this.scrollBar_.pos() * (this.elementContainer_.height + 12 - HEIGHT);
		}
		
		protected function onAddedToStage(param1:Event) : void {
			removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
			this.scrollBar_.addEventListener(Event.CHANGE,this.onScrollBarChange);
			this.scrollBar_.setIndicatorSize(HEIGHT,this.elementContainer_.height);
			addChild(this.scrollBar_);
		}
		
		protected function onRemovedFromStage(param1:Event) : void {
			removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
		}
		
		public function get hasBeenLoaded() : Boolean {
			return this._hasBeenLoaded;
		}
		
		public function set hasBeenLoaded(param1:Boolean) : void {
			this._hasBeenLoaded = param1;
		}
	}
}
