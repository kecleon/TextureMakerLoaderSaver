 
package com.company.assembleegameclient.screens {
	import com.company.assembleegameclient.sound.SoundEffectLibrary;
	import com.company.util.MoreColorUtil;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.ColorTransform;
	import flash.utils.getTimer;
	import kabam.rotmg.text.view.TextFieldDisplayConcrete;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;
	import org.osflash.signals.Signal;
	
	public class TitleMenuOption extends Sprite {
		
		protected static const OVER_COLOR_TRANSFORM:ColorTransform = new ColorTransform(1,220 / 255,133 / 255);
		
		private static const DROP_SHADOW_FILTER:DropShadowFilter = new DropShadowFilter(0,0,0,0.5,12,12);
		 
		
		public const clicked:Signal = new Signal();
		
		public const textField:TextFieldDisplayConcrete = this.makeTextFieldDisplayConcrete();
		
		public const changed:Signal = this.textField.textChanged;
		
		private var colorTransform:ColorTransform;
		
		private var size:int;
		
		private var isPulse:Boolean;
		
		private var originalWidth:Number;
		
		private var originalHeight:Number;
		
		private var active:Boolean;
		
		private var color:uint = 16777215;
		
		private var hoverColor:uint;
		
		public function TitleMenuOption(param1:String, param2:int, param3:Boolean) {
			super();
			this.size = param2;
			this.isPulse = param3;
			this.textField.setSize(param2).setColor(16777215).setBold(true);
			this.setTextKey(param1);
			this.originalWidth = width;
			this.originalHeight = height;
			this.activate();
		}
		
		public function activate() : void {
			addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
			addEventListener(MouseEvent.CLICK,this.onMouseClick);
			addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
			this.active = true;
		}
		
		public function deactivate() : void {
			var loc1:ColorTransform = new ColorTransform();
			loc1.color = 3552822;
			this.setColorTransform(loc1);
			removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
			removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
			removeEventListener(MouseEvent.CLICK,this.onMouseClick);
			removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
			removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
			this.active = false;
		}
		
		public function setColor(param1:uint) : void {
			this.color = param1;
			var loc2:uint = (param1 & 16711680) >> 16;
			var loc3:uint = (param1 & 65280) >> 8;
			var loc4:uint = param1 & 255;
			var loc5:ColorTransform = new ColorTransform(loc2 / 255,loc3 / 255,loc4 / 255);
			this.setColorTransform(loc5);
		}
		
		public function isActive() : Boolean {
			return this.active;
		}
		
		private function makeTextFieldDisplayConcrete() : TextFieldDisplayConcrete {
			var loc1:TextFieldDisplayConcrete = new TextFieldDisplayConcrete();
			loc1.filters = [DROP_SHADOW_FILTER];
			addChild(loc1);
			return loc1;
		}
		
		public function setTextKey(param1:String) : void {
			name = param1;
			this.textField.setStringBuilder(new LineBuilder().setParams(param1));
		}
		
		public function setAutoSize(param1:String) : void {
			this.textField.setAutoSize(param1);
		}
		
		public function setVerticalAlign(param1:String) : void {
			this.textField.setVerticalAlign(param1);
		}
		
		private function onAddedToStage(param1:Event) : void {
			if(this.isPulse) {
				addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
			}
		}
		
		private function onRemovedFromStage(param1:Event) : void {
			if(this.isPulse) {
				removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
			}
		}
		
		private function onEnterFrame(param1:Event) : void {
			var loc2:Number = 1.05 + 0.05 * Math.sin(getTimer() / 200);
			this.textField.scaleX = loc2;
			this.textField.scaleY = loc2;
		}
		
		public function setColorTransform(param1:ColorTransform) : void {
			if(param1 == this.colorTransform) {
				return;
			}
			this.colorTransform = param1;
			if(this.colorTransform == null) {
				this.textField.transform.colorTransform = MoreColorUtil.identity;
			} else {
				this.textField.transform.colorTransform = this.colorTransform;
			}
		}
		
		protected function onMouseOver(param1:MouseEvent) : void {
			this.setColorTransform(OVER_COLOR_TRANSFORM);
		}
		
		protected function onMouseOut(param1:MouseEvent) : void {
			if(this.color != 16777215) {
				this.setColor(this.color);
			} else {
				this.setColorTransform(null);
			}
		}
		
		protected function onMouseClick(param1:MouseEvent) : void {
			SoundEffectLibrary.play("button_click");
			this.clicked.dispatch();
		}
		
		override public function toString() : String {
			return "[TitleMenuOption " + this.textField.getText() + "]";
		}
		
		public function createNoticeTag(param1:String, param2:int, param3:uint, param4:Boolean) : void {
			var loc5:TextFieldDisplayConcrete = null;
			loc5 = new TextFieldDisplayConcrete();
			loc5.setSize(param2).setColor(param3).setBold(param4);
			loc5.setStringBuilder(new LineBuilder().setParams(param1));
			loc5.x = this.textField.x - 4;
			loc5.y = this.textField.y - 20;
			addChild(loc5);
		}
	}
}
