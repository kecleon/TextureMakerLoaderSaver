 
package com.company.assembleegameclient.ui.board {
	import com.company.assembleegameclient.ui.DeprecatedTextButton;
	import com.company.assembleegameclient.ui.Scrollbar;
	import com.company.ui.BaseSimpleText;
	import com.company.util.GraphicsUtil;
	import com.company.util.HTMLUtil;
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
	import kabam.rotmg.text.model.TextKey;
	
	class ViewBoard extends Sprite {
		
		public static const TEXT_WIDTH:int = 400;
		
		public static const TEXT_HEIGHT:int = 400;
		
		private static const URL_REGEX:RegExp = /((https?|ftp):((\/\/)|(\\\\))+[\w\d:#@%\/;$()~_?\+-=\\\.&]*)/g;
		 
		
		private var text_:String;
		
		public var w_:int;
		
		public var h_:int;
		
		private var boardText_:BaseSimpleText;
		
		private var mainSprite_:Sprite;
		
		private var scrollBar_:Scrollbar;
		
		private var editButton_:DeprecatedTextButton;
		
		private var closeButton_:DeprecatedTextButton;
		
		private var backgroundFill_:GraphicsSolidFill;
		
		private var outlineFill_:GraphicsSolidFill;
		
		private var lineStyle_:GraphicsStroke;
		
		private var path_:GraphicsPath;
		
		private var graphicsData_:Vector.<IGraphicsData>;
		function ViewBoard(param1:String, param2:Boolean) {
			this.backgroundFill_ = new GraphicsSolidFill(3355443,1);
			this.outlineFill_ = new GraphicsSolidFill(16777215,1);
			this.lineStyle_ = new GraphicsStroke(2,false,LineScaleMode.NORMAL,CapsStyle.NONE,JointStyle.ROUND,3,this.outlineFill_);
			this.path_ = new GraphicsPath(new Vector.<int>(),new Vector.<Number>());

			graphicsData_ = new <IGraphicsData>[this.lineStyle_,this.backgroundFill_,this.path_,GraphicsUtil.END_FILL,GraphicsUtil.END_STROKE];
			super();
			this.text_ = param1;
			this.mainSprite_ = new Sprite();
			var loc3:Shape = new Shape();
			var loc4:Graphics = loc3.graphics;
			loc4.beginFill(0);
			loc4.drawRect(0,0,TEXT_WIDTH,TEXT_HEIGHT);
			loc4.endFill();
			this.mainSprite_.addChild(loc3);
			this.mainSprite_.mask = loc3;
			addChild(this.mainSprite_);
			var loc5:String = HTMLUtil.escape(param1);
			loc5 = loc5.replace(URL_REGEX,"<font color=\"#7777EE\"><a href=\"$1\" target=\"_blank\">" + "$1</a></font>");
			this.boardText_ = new BaseSimpleText(16,11776947,false,TEXT_WIDTH,0);
			this.boardText_.border = false;
			this.boardText_.mouseEnabled = true;
			this.boardText_.multiline = true;
			this.boardText_.wordWrap = true;
			this.boardText_.htmlText = loc5;
			this.boardText_.useTextDimensions();
			this.mainSprite_.addChild(this.boardText_);
			var loc6:* = this.boardText_.height > 400;
			if(loc6) {
				this.scrollBar_ = new Scrollbar(16,TEXT_HEIGHT - 4);
				this.scrollBar_.x = TEXT_WIDTH + 6;
				this.scrollBar_.y = 0;
				this.scrollBar_.setIndicatorSize(400,this.boardText_.height);
				this.scrollBar_.addEventListener(Event.CHANGE,this.onScrollBarChange);
				addChild(this.scrollBar_);
			}
			this.w_ = TEXT_WIDTH + (!!loc6?26:0);
			this.editButton_ = new DeprecatedTextButton(14,TextKey.VIEW_GUILD_BOARD_EDIT,120);
			this.editButton_.x = 4;
			this.editButton_.y = TEXT_HEIGHT + 4;
			this.editButton_.addEventListener(MouseEvent.CLICK,this.onEdit);
			addChild(this.editButton_);
			this.editButton_.visible = param2;
			this.closeButton_ = new DeprecatedTextButton(14,TextKey.VIEW_GUILD_BOARD_CLOSE,120);
			this.closeButton_.x = this.w_ - 124;
			this.closeButton_.y = TEXT_HEIGHT + 4;
			this.closeButton_.addEventListener(MouseEvent.CLICK,this.onClose);
			this.closeButton_.textChanged.addOnce(this.layoutBackground);
			addChild(this.closeButton_);
		}
		
		private function layoutBackground() : void {
			this.h_ = TEXT_HEIGHT + this.closeButton_.height + 8;
			x = 800 / 2 - this.w_ / 2;
			y = 600 / 2 - this.h_ / 2;
			graphics.clear();
			GraphicsUtil.clearPath(this.path_);
			GraphicsUtil.drawCutEdgeRect(-6,-6,this.w_ + 12,this.h_ + 12,4,[1,1,1,1],this.path_);
			graphics.drawGraphicsData(this.graphicsData_);
		}
		
		private function onScrollBarChange(param1:Event) : void {
			this.boardText_.y = -this.scrollBar_.pos() * (this.boardText_.height - 400);
		}
		
		private function onEdit(param1:Event) : void {
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function onClose(param1:Event) : void {
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}
