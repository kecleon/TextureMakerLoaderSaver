package com.company.ui {
	import flash.events.Event;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;

	public class BaseSimpleText extends TextField {

		public static const MyriadPro:Class = BaseSimpleText_MyriadPro;


		public var inputWidth_:int;

		public var inputHeight_:int;

		public var actualWidth_:int;

		public var actualHeight_:int;

		public function BaseSimpleText(param1:int, param2:uint, param3:Boolean = false, param4:int = 0, param5:int = 0) {
			super();
			this.inputWidth_ = param4;
			if (this.inputWidth_ != 0) {
				width = param4;
			}
			this.inputHeight_ = param5;
			if (this.inputHeight_ != 0) {
				height = param5;
			}
			Font.registerFont(MyriadPro);
			var loc6:Font = new MyriadPro();
			var loc7:TextFormat = this.defaultTextFormat;
			loc7.font = loc6.fontName;
			loc7.bold = false;
			loc7.size = param1;
			loc7.color = param2;
			defaultTextFormat = loc7;
			if (param3) {
				selectable = true;
				mouseEnabled = true;
				type = TextFieldType.INPUT;
				embedFonts = true;
				border = true;
				borderColor = param2;
				setTextFormat(loc7);
				addEventListener(Event.CHANGE, this.onChange);
			} else {
				selectable = false;
				mouseEnabled = false;
			}
		}

		public function setFont(param1:String):void {
			var loc2:TextFormat = defaultTextFormat;
			loc2.font = param1;
			defaultTextFormat = loc2;
		}

		public function setSize(param1:int):void {
			var loc2:TextFormat = defaultTextFormat;
			loc2.size = param1;
			this.applyFormat(loc2);
		}

		public function setColor(param1:uint):void {
			var loc2:TextFormat = defaultTextFormat;
			loc2.color = param1;
			this.applyFormat(loc2);
		}

		public function setBold(param1:Boolean):void {
			var loc2:TextFormat = defaultTextFormat;
			loc2.bold = param1;
			this.applyFormat(loc2);
		}

		public function setAlignment(param1:String):void {
			var loc2:TextFormat = defaultTextFormat;
			loc2.align = param1;
			this.applyFormat(loc2);
		}

		public function setText(param1:String):void {
			this.text = param1;
		}

		public function setMultiLine(param1:Boolean):void {
			multiline = param1;
			wordWrap = param1;
		}

		private function applyFormat(param1:TextFormat):void {
			setTextFormat(param1);
			defaultTextFormat = param1;
		}

		private function onChange(param1:Event):void {
			this.updateMetrics();
		}

		public function updateMetrics():void {
			var loc2:TextLineMetrics = null;
			var loc3:int = 0;
			var loc4:int = 0;
			this.actualWidth_ = 0;
			this.actualHeight_ = 0;
			var loc1:int = 0;
			while (loc1 < numLines) {
				loc2 = getLineMetrics(loc1);
				loc3 = loc2.width + 4;
				loc4 = loc2.height + 4;
				if (loc3 > this.actualWidth_) {
					this.actualWidth_ = loc3;
				}
				this.actualHeight_ = this.actualHeight_ + loc4;
				loc1++;
			}
			width = this.inputWidth_ == 0 ? Number(this.actualWidth_) : Number(this.inputWidth_);
			height = this.inputHeight_ == 0 ? Number(this.actualHeight_) : Number(this.inputHeight_);
		}

		public function useTextDimensions():void {
			width = this.inputWidth_ == 0 ? Number(textWidth + 4) : Number(this.inputWidth_);
			height = this.inputHeight_ == 0 ? Number(textHeight + 4) : Number(this.inputHeight_);
		}
	}
}
