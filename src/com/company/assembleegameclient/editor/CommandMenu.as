 
package com.company.assembleegameclient.editor {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;
	
	public class CommandMenu extends Sprite {
		 
		
		private var keyCodeDict_:Dictionary;
		
		private var yOffset_:int = 0;
		
		private var selected_:CommandMenuItem = null;
		
		public function CommandMenu() {
			this.keyCodeDict_ = new Dictionary();
			super();
			addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
		}
		
		public function getCommand() : int {
			return this.selected_.command_;
		}
		
		public function setCommand(param1:int) : void {
			var loc3:CommandMenuItem = null;
			var loc2:int = 0;
			while(loc2 < numChildren) {
				loc3 = getChildAt(loc2) as CommandMenuItem;
				if(loc3 != null) {
					if(loc3.command_ == param1) {
						this.setSelected(loc3);
						break;
					}
				}
				loc2++;
			}
		}
		
		protected function setSelected(param1:CommandMenuItem) : void {
			if(this.selected_ != null) {
				this.selected_.setSelected(false);
			}
			this.selected_ = param1;
			this.selected_.setSelected(true);
		}
		
		private function onAddedToStage(param1:Event) : void {
			stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
		}
		
		private function onRemovedFromStage(param1:Event) : void {
			stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
		}
		
		private function onKeyDown(param1:KeyboardEvent) : void {
			if(stage.focus != null) {
				return;
			}
			var loc2:CommandMenuItem = this.keyCodeDict_[param1.keyCode];
			if(loc2 == null) {
				return;
			}
			loc2.callback_(loc2);
		}
		
		protected function addCommandMenuItem(param1:String, param2:int, param3:Function, param4:int) : void {
			var loc5:CommandMenuItem = new CommandMenuItem(param1,param3,param4);
			loc5.y = this.yOffset_;
			addChild(loc5);
			if(param2 != -1) {
				this.keyCodeDict_[param2] = loc5;
			}
			if(this.selected_ == null) {
				this.setSelected(loc5);
			}
			this.yOffset_ = this.yOffset_ + 30;
		}
		
		protected function addBreak() : void {
			this.yOffset_ = this.yOffset_ + 30;
		}
	}
}
