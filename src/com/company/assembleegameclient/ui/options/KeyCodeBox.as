 
package com.company.assembleegameclient.ui.options {
	import com.company.util.KeyCodes;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextFieldAutoSize;
	import flash.utils.getTimer;
	import kabam.rotmg.text.model.TextKey;
	import kabam.rotmg.text.view.TextFieldDisplayConcrete;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;
	import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
	import kabam.rotmg.text.view.stringBuilder.StringBuilder;
	
	public class KeyCodeBox extends Sprite {
		
		public static const WIDTH:int = 80;
		
		public static const HEIGHT:int = 32;
		 
		
		public var keyCode_:uint;
		
		public var selected_:Boolean;
		
		public var inputMode_:Boolean;
		
		private var char_:TextFieldDisplayConcrete = null;
		
		public function KeyCodeBox(param1:uint) {
			super();
			this.keyCode_ = param1;
			this.selected_ = false;
			this.inputMode_ = false;
			this.char_ = new TextFieldDisplayConcrete().setSize(16).setColor(16777215);
			this.char_.setBold(true);
			this.char_.filters = [new DropShadowFilter(0,0,0,1,4,4,2)];
			this.char_.setAutoSize(TextFieldAutoSize.CENTER).setVerticalAlign(TextFieldDisplayConcrete.MIDDLE);
			addChild(this.char_);
			this.drawBackground();
			this.setNormalMode();
			addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
			addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
		}
		
		public function value() : uint {
			return this.keyCode_;
		}
		
		public function setKeyCode(param1:uint) : void {
			if(param1 == this.keyCode_) {
				return;
			}
			this.keyCode_ = param1;
			this.setTextToKey();
			dispatchEvent(new Event(Event.CHANGE,true));
		}
		
		public function setTextToKey() : void {
			this.setText(new StaticStringBuilder(KeyCodes.CharCodeStrings[this.keyCode_]));
		}
		
		private function drawBackground() : void {
			var loc1:Graphics = graphics;
			loc1.clear();
			loc1.lineStyle(2,this.selected_ || this.inputMode_?uint(11776947):uint(4473924));
			loc1.beginFill(3355443);
			loc1.drawRect(0,0,WIDTH,HEIGHT);
			loc1.endFill();
			loc1.lineStyle();
		}
		
		private function onMouseOver(param1:MouseEvent) : void {
			this.selected_ = true;
			this.drawBackground();
		}
		
		private function onRollOut(param1:MouseEvent) : void {
			this.selected_ = false;
			this.drawBackground();
		}
		
		private function setText(param1:StringBuilder) : void {
			this.char_.setStringBuilder(param1);
			this.char_.x = WIDTH / 2;
			this.char_.y = HEIGHT / 2;
			this.drawBackground();
		}
		
		private function setNormalMode() : void {
			this.inputMode_ = false;
			removeEventListener(Event.ENTER_FRAME,this.onInputEnterFrame);
			if(stage != null) {
				removeEventListener(KeyboardEvent.KEY_DOWN,this.onInputKeyDown);
				stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.onInputMouseDown,true);
			}
			this.setTextToKey();
			addEventListener(MouseEvent.CLICK,this.onNormalClick);
		}
		
		private function setInputMode() : void {
			if(stage == null) {
				return;
			}
			stage.stageFocusRect = false;
			stage.focus = this;
			this.inputMode_ = true;
			removeEventListener(MouseEvent.CLICK,this.onNormalClick);
			addEventListener(Event.ENTER_FRAME,this.onInputEnterFrame);
			addEventListener(KeyboardEvent.KEY_DOWN,this.onInputKeyDown);
			stage.addEventListener(MouseEvent.MOUSE_DOWN,this.onInputMouseDown,true);
		}
		
		private function onNormalClick(param1:MouseEvent) : void {
			this.setInputMode();
		}
		
		private function onInputEnterFrame(param1:Event) : void {
			var loc2:int = getTimer() / 400;
			var loc3:* = loc2 % 2 == 0;
			if(loc3) {
				this.setText(new StaticStringBuilder(""));
			} else {
				this.setText(new LineBuilder().setParams(TextKey.KEYCODEBOX_HITKEY));
			}
		}
		
		private function onInputKeyDown(param1:KeyboardEvent) : void {
			param1.stopImmediatePropagation();
			this.keyCode_ = param1.keyCode;
			this.setNormalMode();
			dispatchEvent(new Event(Event.CHANGE,true));
		}
		
		private function onInputMouseDown(param1:MouseEvent) : void {
			this.setNormalMode();
		}
	}
}
