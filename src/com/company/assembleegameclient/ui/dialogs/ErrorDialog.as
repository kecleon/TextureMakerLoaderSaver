 
package com.company.assembleegameclient.ui.dialogs {
	import com.company.assembleegameclient.ui.DeprecatedTextButton;
	import com.company.assembleegameclient.util.StageProxy;
	import com.company.util.GraphicsUtil;
	import flash.display.CapsStyle;
	import flash.display.Graphics;
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
	import flash.filters.DropShadowFilter;
	import flash.text.TextFieldAutoSize;
	import kabam.rotmg.core.StaticInjectorContext;
	import kabam.rotmg.core.service.GoogleAnalytics;
	import kabam.rotmg.text.view.TextFieldDisplayConcrete;
	import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
	import kabam.rotmg.ui.view.SignalWaiter;
	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeMappedSignal;
	
	public class ErrorDialog extends Sprite {
		
		public static const GREY:int = 11776947;
		
		protected static const WIDTH:int = 300;
		 
		
		public var ok:Signal;
		
		public var box_:Sprite;
		
		public var rect_:Shape;
		
		public var textText_:TextFieldDisplayConcrete;
		
		public var titleText_:TextFieldDisplayConcrete = null;
		
		public var button1_:DeprecatedTextButton = null;
		
		public var button2_:DeprecatedTextButton = null;
		
		public var analyticsPageName_:String = null;
		
		public var offsetX:Number = 0;
		
		public var offsetY:Number = 0;
		
		public var stageProxy:StageProxy;
		
		private var outlineFill_:GraphicsSolidFill;
		
		private var lineStyle_:GraphicsStroke;
		
		private var backgroundFill_:GraphicsSolidFill;
		
		protected var path_:GraphicsPath;
		
		protected var graphicsData_:Vector.<IGraphicsData>;
		protected var uiWaiter:SignalWaiter;

		public function ErrorDialog(param1:String) {
			this.box_ = new Sprite();
			this.rect_ = new Shape();
			this.outlineFill_ = new GraphicsSolidFill(16777215,1);
			this.lineStyle_ = new GraphicsStroke(1,false,LineScaleMode.NORMAL,CapsStyle.NONE,JointStyle.ROUND,3,this.outlineFill_);
			this.backgroundFill_ = new GraphicsSolidFill(3552822,1);
			this.path_ = new GraphicsPath(new Vector.<int>(),new Vector.<Number>());
			this.uiWaiter = new SignalWaiter();

			graphicsData_ = new <IGraphicsData>[this.lineStyle_,this.backgroundFill_,this.path_,GraphicsUtil.END_FILL,GraphicsUtil.END_STROKE];
			super();
			var loc2:String = ["An error has occured:",param1].join("\n");
			this.stageProxy = new StageProxy(this);
			this.analyticsPageName_ = "/error";
			this._makeUIAndAdd(loc2,"D\'oh, this isn\'t good","ErrorWindow.buttonOK",null);
			this.makeUIAndAdd();
			this.uiWaiter.complete.addOnce(this.onComplete);
			addChild(this.box_);
			this.ok = new NativeMappedSignal(this,Dialog.LEFT_BUTTON);
		}
		
		private function _makeUIAndAdd(param1:String, param2:String, param3:String, param4:String) : void {
			this.initText(param1);
			this.addTextFieldDisplay(this.textText_);
			this.initNonNullTitleAndAdd(param2);
			this.makeNonNullButtons(param3,param4);
		}
		
		protected function makeUIAndAdd() : void {
		}
		
		protected function initText(param1:String) : void {
			this.textText_ = new TextFieldDisplayConcrete().setSize(14).setColor(GREY);
			this.textText_.setTextWidth(WIDTH - 40);
			this.textText_.x = 20;
			this.textText_.setMultiLine(true).setWordWrap(true).setAutoSize(TextFieldAutoSize.CENTER);
			this.textText_.setStringBuilder(new StaticStringBuilder(param1));
			this.textText_.mouseEnabled = true;
			this.textText_.filters = [new DropShadowFilter(0,0,0,1,6,6,1)];
		}
		
		private function addTextFieldDisplay(param1:TextFieldDisplayConcrete) : void {
			this.box_.addChild(param1);
			this.uiWaiter.push(param1.textChanged);
		}
		
		private function initNonNullTitleAndAdd(param1:String) : void {
			if(param1 != null) {
				this.titleText_ = new TextFieldDisplayConcrete().setSize(18).setColor(5746018);
				this.titleText_.setTextWidth(WIDTH);
				this.titleText_.setBold(true);
				this.titleText_.setAutoSize(TextFieldAutoSize.CENTER);
				this.titleText_.filters = [new DropShadowFilter(0,0,0,1,8,8,1)];
				this.titleText_.setStringBuilder(new StaticStringBuilder(param1));
				this.addTextFieldDisplay(this.titleText_);
			}
		}
		
		private function makeNonNullButtons(param1:String, param2:String) : void {
			if(param1 != null) {
				this.button1_ = new DeprecatedTextButton(16,param1,120);
				this.button1_.addEventListener(MouseEvent.CLICK,this.onButton1Click);
			}
			if(param2 != null) {
				this.button2_ = new DeprecatedTextButton(16,param2,120);
				this.button2_.addEventListener(MouseEvent.CLICK,this.onButton2Click);
			}
		}
		
		private function onComplete() : void {
			this.draw();
			this.positionDialogAndTryAnalytics();
		}
		
		private function positionDialogAndTryAnalytics() : void {
			this.box_.x = this.offsetX + this.stageProxy.getStageWidth() / 2 - this.box_.width / 2;
			this.box_.y = this.offsetY + this.stageProxy.getStageHeight() / 2 - this.getBoxHeight() / 2;
			if(this.analyticsPageName_ != null) {
				this.tryAnalytics();
			}
		}
		
		private function tryAnalytics() : void {
			var loc1:GoogleAnalytics = null;
			try {
				loc1 = StaticInjectorContext.getInjector().getInstance(GoogleAnalytics);
				if(loc1) {
					loc1.trackPageView(this.analyticsPageName_);
				}
				return;
			}
			catch(error:Error) {
				return;
			}
		}
		
		private function draw() : void {
			this.drawTitleAndText();
			this.drawAdditionalUI();
			this.drawButtonsAndBackground();
		}
		
		protected function drawAdditionalUI() : void {
		}
		
		protected function drawButtonsAndBackground() : void {
			if(this.box_.contains(this.rect_)) {
				this.box_.removeChild(this.rect_);
			}
			this.removeButtonsIfAlreadyAdded();
			this.addButtonsAndLayout();
			this.drawBackground();
			this.box_.addChildAt(this.rect_,0);
			this.box_.filters = [new DropShadowFilter(0,0,0,1,16,16,1)];
		}
		
		private function drawBackground() : void {
			GraphicsUtil.clearPath(this.path_);
			GraphicsUtil.drawCutEdgeRect(0,0,WIDTH,this.getBoxHeight() + 10,4,[1,1,1,1],this.path_);
			var loc1:Graphics = this.rect_.graphics;
			loc1.clear();
			loc1.drawGraphicsData(this.graphicsData_);
		}
		
		protected function getBoxHeight() : Number {
			return this.box_.height;
		}
		
		private function addButtonsAndLayout() : void {
			var loc1:int = 0;
			if(this.button1_ != null) {
				loc1 = this.box_.height + 16;
				this.box_.addChild(this.button1_);
				this.button1_.y = loc1;
				if(this.button2_ == null) {
					this.button1_.x = WIDTH / 2 - this.button1_.width / 2;
				} else {
					this.button1_.x = WIDTH / 4 - this.button1_.width / 2;
					this.box_.addChild(this.button2_);
					this.button2_.x = 3 * WIDTH / 4 - this.button2_.width / 2;
					this.button2_.y = loc1;
				}
			}
		}
		
		private function removeButtonsIfAlreadyAdded() : void {
			if(this.button1_ && this.box_.contains(this.button1_)) {
				this.box_.removeChild(this.button1_);
			}
			if(this.button2_ && this.box_.contains(this.button2_)) {
				this.box_.removeChild(this.button2_);
			}
		}
		
		private function drawTitleAndText() : void {
			if(this.titleText_ != null) {
				this.titleText_.y = 2;
				this.textText_.y = this.titleText_.height + 8;
			} else {
				this.textText_.y = 4;
			}
		}
		
		private function onButton1Click(param1:MouseEvent) : void {
			dispatchEvent(new Event(Dialog.LEFT_BUTTON));
		}
		
		private function onButton2Click(param1:Event) : void {
			dispatchEvent(new Event(Dialog.RIGHT_BUTTON));
		}
		
		public function setBaseAlpha(param1:Number) : void {
			this.rect_.alpha = param1 > 1?Number(1):param1 < 0?Number(0):Number(param1);
		}
	}
}
