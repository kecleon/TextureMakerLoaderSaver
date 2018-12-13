 
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
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;
	import kabam.rotmg.text.view.stringBuilder.StringBuilder;
	import kabam.rotmg.ui.view.SignalWaiter;
	
	public class Dialog extends Sprite {
		
		public static const LEFT_BUTTON:String = "dialogLeftButton";
		
		public static const RIGHT_BUTTON:String = "dialogRightButton";
		
		public static const GREY:int = 11776947;
		
		public static const WIDTH:int = 300;
		 
		
		public var box_:Sprite;
		
		public var rect_:Shape;
		
		public var textText_:TextFieldDisplayConcrete;
		
		public var titleText_:TextFieldDisplayConcrete = null;
		
		public var analyticsPageName_:String = null;
		
		public var offsetX:Number = 0;
		
		public var offsetY:Number = 0;
		
		public var stageProxy:StageProxy;
		
		public var titleYPosition:int = 2;
		
		public var titleTextSpace:int = 8;
		
		public var buttonSpace:int = 16;
		
		public var bottomSpace:int = 10;
		
		public var dialogWidth:int;
		
		private var outlineFill_:GraphicsSolidFill;
		
		private var lineStyle_:GraphicsStroke;
		
		private var backgroundFill_:GraphicsSolidFill;
		
		protected var path_:GraphicsPath;
		
		protected var graphicsData_:Vector.<IGraphicsData>;
		protected var uiWaiter:SignalWaiter;

		protected var leftButton:DeprecatedTextButton;

		protected var rightButton:DeprecatedTextButton;

		private var leftButtonKey:String;

		private var rightButtonKey:String;

		private var replaceTokens:Object;

		public function Dialog(param1:String, param2:String, param3:String, param4:String, param5:String, param6:Object = null) {
			this.box_ = new Sprite();
			this.rect_ = new Shape();
			this.dialogWidth = this.setDialogWidth();
			this.outlineFill_ = new GraphicsSolidFill(16777215,1);
			this.lineStyle_ = new GraphicsStroke(1,false,LineScaleMode.NORMAL,CapsStyle.NONE,JointStyle.ROUND,3,this.outlineFill_);
			this.backgroundFill_ = new GraphicsSolidFill(3552822,1);
			this.path_ = new GraphicsPath(new Vector.<int>(),new Vector.<Number>());
			this.uiWaiter = new SignalWaiter();
			this.replaceTokens = param6;
			this.leftButtonKey = param3;
			this.rightButtonKey = param4;

			graphicsData_ = new <IGraphicsData>[this.lineStyle_,this.backgroundFill_,this.path_,GraphicsUtil.END_FILL,GraphicsUtil.END_STROKE];
			super();
			this.stageProxy = new StageProxy(this);
			this.analyticsPageName_ = param5;
			this._makeUIAndAdd(param2,param1);
			this.makeUIAndAdd();
			this.uiWaiter.complete.addOnce(this.onComplete);
			addChild(this.box_);
		}
		
		public function getLeftButtonKey() : String {
			return this.leftButtonKey;
		}
		
		public function getRightButtonKey() : String {
			return this.rightButtonKey;
		}
		
		public function setTextParams(param1:String, param2:Object) : void {
			this.textText_.setStringBuilder(new LineBuilder().setParams(param1,param2));
		}
		
		public function setTitleStringBuilder(param1:StringBuilder) : void {
			this.titleText_.setStringBuilder(param1);
		}
		
		protected function setDialogWidth() : int {
			return WIDTH;
		}
		
		private function _makeUIAndAdd(param1:String, param2:String) : void {
			this.initText(param1);
			this.addTextFieldDisplay(this.textText_);
			this.initNonNullTitleAndAdd(param2);
			this.makeNonNullButtons();
		}
		
		protected function makeUIAndAdd() : void {
		}
		
		protected function initText(param1:String) : void {
			this.textText_ = new TextFieldDisplayConcrete().setSize(14).setColor(GREY);
			this.textText_.setTextWidth(this.dialogWidth - 40);
			this.textText_.x = 20;
			this.textText_.setMultiLine(true).setWordWrap(true).setAutoSize(TextFieldAutoSize.CENTER);
			this.textText_.setHTML(true);
			var loc2:LineBuilder = new LineBuilder().setParams(param1).setPrefix("<p align=\"center\">").setPostfix("</p>");
			if(this.replaceTokens) {
				loc2.setParams(param1,this.replaceTokens);
			}
			this.textText_.setStringBuilder(loc2);
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
				this.titleText_.setBold(true);
				this.titleText_.setAutoSize(TextFieldAutoSize.CENTER);
				this.titleText_.filters = [new DropShadowFilter(0,0,0,1,8,8,1)];
				this.titleText_.setStringBuilder(new LineBuilder().setParams(param1));
				this.addTextFieldDisplay(this.titleText_);
			}
		}
		
		private function makeNonNullButtons() : void {
			if(this.leftButtonKey != null) {
				this.leftButton = new DeprecatedTextButton(16,this.leftButtonKey,120);
				this.leftButton.addEventListener(MouseEvent.CLICK,this.onLeftButtonClick);
			}
			if(this.rightButtonKey != null) {
				this.rightButton = new DeprecatedTextButton(16,this.rightButtonKey,120);
				this.rightButton.addEventListener(MouseEvent.CLICK,this.onRightButtonClick);
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
			this.drawGraphicsTemplate();
			this.box_.addChildAt(this.rect_,0);
			this.box_.filters = [new DropShadowFilter(0,0,0,1,16,16,1)];
		}
		
		protected function drawGraphicsTemplate() : void {
		}
		
		private function drawBackground() : void {
			GraphicsUtil.clearPath(this.path_);
			GraphicsUtil.drawCutEdgeRect(0,0,this.dialogWidth,this.getBoxHeight() + this.bottomSpace,4,[1,1,1,1],this.path_);
			var loc1:Graphics = this.rect_.graphics;
			loc1.clear();
			loc1.drawGraphicsData(this.graphicsData_);
		}
		
		protected function getBoxHeight() : Number {
			return this.box_.height;
		}
		
		private function addButtonsAndLayout() : void {
			var loc1:int = 0;
			if(this.leftButton != null) {
				loc1 = this.box_.height + this.buttonSpace;
				this.box_.addChild(this.leftButton);
				this.leftButton.y = loc1;
				if(this.rightButton == null) {
					this.leftButton.x = this.dialogWidth / 2 - this.leftButton.width / 2;
				} else {
					this.leftButton.x = this.dialogWidth / 4 - this.leftButton.width / 2;
					this.box_.addChild(this.rightButton);
					this.rightButton.x = 3 * this.dialogWidth / 4 - this.rightButton.width / 2;
					this.rightButton.y = loc1;
				}
			}
		}
		
		private function drawTitleAndText() : void {
			if(this.titleText_ != null) {
				this.titleText_.x = this.dialogWidth / 2;
				this.titleText_.y = this.titleYPosition;
				this.textText_.y = this.titleText_.height + this.titleTextSpace;
			} else {
				this.textText_.y = 4;
			}
		}
		
		private function removeButtonsIfAlreadyAdded() : void {
			if(this.leftButton && this.box_.contains(this.leftButton)) {
				this.box_.removeChild(this.leftButton);
			}
			if(this.rightButton && this.box_.contains(this.rightButton)) {
				this.box_.removeChild(this.rightButton);
			}
		}
		
		protected function onLeftButtonClick(param1:MouseEvent) : void {
			dispatchEvent(new Event(LEFT_BUTTON));
		}
		
		protected function onRightButtonClick(param1:Event) : void {
			dispatchEvent(new Event(RIGHT_BUTTON));
		}
	}
}
