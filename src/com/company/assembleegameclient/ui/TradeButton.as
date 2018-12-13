package com.company.assembleegameclient.ui {
	import com.company.util.GraphicsUtil;

	import flash.display.CapsStyle;
	import flash.display.GraphicsSolidFill;
	import flash.display.GraphicsStroke;
	import flash.display.IGraphicsData;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	import flash.utils.getTimer;

	import kabam.rotmg.text.model.TextKey;
	import kabam.rotmg.text.view.StaticTextDisplay;
	import kabam.rotmg.text.view.TextFieldDisplayConcrete;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;

	public class TradeButton extends BackgroundFilledText {

		private static const WAIT_TIME:int = 2999;

		private static const COUNTDOWN_STATE:int = 0;

		private static const NORMAL_STATE:int = 1;

		private static const WAITING_STATE:int = 2;

		private static const DISABLED_STATE:int = 3;


		public var statusBar_:Sprite;

		public var barMask_:Shape;

		public var myText:StaticTextDisplay;

		public var h_:int;

		private var state_:int;

		private var lastResetTime_:int;

		private var barGraphicsData_:Vector.<IGraphicsData>;

		private var outlineGraphicsData_:Vector.<IGraphicsData>;

		public function TradeButton(param1:int, param2:int = 0) {
			super(param2);
			this.makeGraphics();
			this.lastResetTime_ = getTimer();
			this.myText = new StaticTextDisplay();
			this.myText.setAutoSize(TextFieldAutoSize.CENTER).setVerticalAlign(TextFieldDisplayConcrete.MIDDLE);
			this.myText.setSize(param1).setColor(3552822).setBold(true);
			this.myText.setStringBuilder(new LineBuilder().setParams(TextKey.PLAYERMENU_TRADE));
			w_ = param2 != 0 ? int(param2) : int(this.myText.width + 12);
			this.h_ = this.myText.height + 8;
			this.myText.x = w_ / 2;
			this.myText.y = this.h_ / 2;
			GraphicsUtil.clearPath(path_);
			GraphicsUtil.drawCutEdgeRect(0, 0, w_, this.myText.height + 8, 4, [1, 1, 1, 1], path_);
			this.statusBar_ = this.newStatusBar();
			addChild(this.statusBar_);
			addChild(this.myText);
			this.draw();
			addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
			addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
			addEventListener(MouseEvent.ROLL_OUT, this.onRollOut);
			addEventListener(MouseEvent.CLICK, this.onClick);
		}

		private function makeGraphics():void {
			var loc1:GraphicsSolidFill = new GraphicsSolidFill(12566463, 1);
			this.barGraphicsData_ = new <IGraphicsData>[loc1, path_, GraphicsUtil.END_FILL];
			var loc2:GraphicsSolidFill = new GraphicsSolidFill(16777215, 1);
			var loc3:GraphicsStroke = new GraphicsStroke(2, false, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.ROUND, 3, loc2);
			this.outlineGraphicsData_ = new <IGraphicsData>[loc3, path_, GraphicsUtil.END_STROKE];
		}

		public function reset():void {
			this.lastResetTime_ = getTimer();
			this.state_ = COUNTDOWN_STATE;
			this.setEnabled(false);
			this.setText(TextKey.PLAYERMENU_TRADE);
		}

		public function disable():void {
			this.state_ = DISABLED_STATE;
			this.setEnabled(false);
			this.setText(TextKey.PLAYERMENU_TRADE);
		}

		private function setText(param1:String):void {
			this.myText.setStringBuilder(new LineBuilder().setParams(param1));
		}

		private function setEnabled(param1:Boolean):void {
			if (param1 == mouseEnabled) {
				return;
			}
			mouseEnabled = param1;
			mouseChildren = param1;
			graphicsData_[0] = !!param1 ? enabledFill_ : disabledFill_;
			this.draw();
		}

		private function onAddedToStage(param1:Event):void {
			addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
			this.reset();
			this.draw();
		}

		private function onRemovedFromStage(param1:Event):void {
			removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
		}

		private function onEnterFrame(param1:Event):void {
			this.draw();
		}

		private function onMouseOver(param1:MouseEvent):void {
			enabledFill_.color = 16768133;
			this.draw();
		}

		private function onRollOut(param1:MouseEvent):void {
			enabledFill_.color = 16777215;
			this.draw();
		}

		private function onClick(param1:MouseEvent):void {
			this.state_ = WAITING_STATE;
			this.setEnabled(false);
			this.setText(TextKey.PLAYERMENU_WAITING);
		}

		private function newStatusBar():Sprite {
			var loc1:Sprite = new Sprite();
			var loc2:Sprite = new Sprite();
			var loc3:Shape = new Shape();
			loc3.graphics.clear();
			loc3.graphics.drawGraphicsData(this.barGraphicsData_);
			loc2.addChild(loc3);
			this.barMask_ = new Shape();
			loc2.addChild(this.barMask_);
			loc2.mask = this.barMask_;
			loc1.addChild(loc2);
			var loc4:Shape = new Shape();
			loc4.graphics.clear();
			loc4.graphics.drawGraphicsData(this.outlineGraphicsData_);
			loc1.addChild(loc4);
			return loc1;
		}

		private function drawCountDown(param1:Number):void {
			this.barMask_.graphics.clear();
			this.barMask_.graphics.beginFill(12566463);
			this.barMask_.graphics.drawRect(0, 0, w_ * param1, this.h_);
			this.barMask_.graphics.endFill();
		}

		private function draw():void {
			var loc1:int = 0;
			var loc2:Number = NaN;
			loc1 = getTimer();
			if (this.state_ == COUNTDOWN_STATE) {
				if (loc1 - this.lastResetTime_ >= WAIT_TIME) {
					this.state_ = NORMAL_STATE;
					this.setEnabled(true);
				}
			}
			switch (this.state_) {
				case COUNTDOWN_STATE:
					this.statusBar_.visible = true;
					loc2 = (loc1 - this.lastResetTime_) / WAIT_TIME;
					this.drawCountDown(loc2);
					break;
				case DISABLED_STATE:
				case NORMAL_STATE:
				case WAITING_STATE:
					this.statusBar_.visible = false;
			}
			graphics.clear();
			graphics.drawGraphicsData(graphicsData_);
		}
	}
}
