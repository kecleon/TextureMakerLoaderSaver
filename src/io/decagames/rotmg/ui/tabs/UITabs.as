 
package io.decagames.rotmg.ui.tabs {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import io.decagames.rotmg.social.signals.TabSelectedSignal;
	import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
	import org.osflash.signals.Signal;
	
	public class UITabs extends Sprite {
		 
		
		public var buttonsRenderedSignal:Signal;
		
		public var tabSelectedSignal:TabSelectedSignal;
		
		private var tabsXSpace:int = 3;
		
		private var tabsButtonMargin:int = 14;
		
		private var content:Vector.<UITab>;
		
		private var buttons:Vector.<TabButton>;
		
		private var tabsWidth:int;
		
		private var background:TabContentBackground;
		
		private var currentContent:UITab;
		
		private var defaultSelectedIndex:int = 0;
		
		private var borderlessMode:Boolean;
		
		private var _currentTabLabel:String;
		
		public function UITabs(param1:int, param2:Boolean = false) {
			this.buttonsRenderedSignal = new Signal();
			this.tabSelectedSignal = new TabSelectedSignal();
			super();
			this.tabsWidth = param1;
			this.borderlessMode = param2;
			this.addEventListener(Event.ADDED_TO_STAGE,this.onAddedHandler);
			this.content = new Vector.<UITab>(0);
			this.buttons = new Vector.<TabButton>(0);
			if(!param2) {
				this.background = new TabContentBackground();
				this.background.addMargin(0,3);
				this.background.width = param1;
				this.background.height = 405;
				this.background.x = 0;
				this.background.y = 41;
				addChild(this.background);
			} else {
				this.tabsButtonMargin = 3;
			}
		}
		
		public function addTab(param1:UITab, param2:Boolean = false) : void {
			this.content.push(param1);
			param1.y = !!this.borderlessMode?Number(34):Number(56);
			if(param2) {
				this.defaultSelectedIndex = this.content.length - 1;
				this.currentContent = param1;
				this._currentTabLabel = param1.tabName;
				addChild(param1);
			}
			if(this._currentTabLabel == "") {
				this._currentTabLabel = param1.tabName;
			}
		}
		
		private function createTabButtons() : void {
			var loc1:int = 0;
			var loc2:int = 0;
			var loc3:String = null;
			var loc4:TabButton = null;
			var loc5:UITab = null;
			var loc6:TabButton = null;
			loc1 = 1;
			loc2 = (this.tabsWidth - (this.content.length - 1) * this.tabsXSpace - this.tabsButtonMargin * 2) / this.content.length;
			for each(loc5 in this.content) {
				if(loc1 == 1) {
					loc3 = TabButton.LEFT;
				} else if(loc1 == this.content.length) {
					loc3 = TabButton.RIGHT;
				} else {
					loc3 = TabButton.CENTER;
				}
				loc6 = this.createTabButton(loc5.tabName,loc3);
				loc6.width = loc2;
				loc6.selected = this.defaultSelectedIndex == loc1 - 1;
				if(loc6.selected) {
					loc4 = loc6;
				}
				loc6.y = 3;
				loc6.x = this.tabsButtonMargin + loc2 * (loc1 - 1) + this.tabsXSpace * (loc1 - 1);
				addChild(loc6);
				loc6.clickSignal.add(this.onButtonSelected);
				this.buttons.push(loc6);
				loc1++;
			}
			if(this.background) {
				this.background.addDecor(loc4.x - 4,loc4.x + loc4.width - 12,this.defaultSelectedIndex,this.buttons.length);
			}
			this.onButtonSelected(loc4);
			this.buttonsRenderedSignal.dispatch();
		}
		
		private function onButtonSelected(param1:TabButton) : void {
			var loc3:TabButton = null;
			var loc2:int = this.buttons.indexOf(param1);
			param1.y = 0;
			this._currentTabLabel = param1.label.text;
			this.tabSelectedSignal.dispatch(param1.label.text);
			for each(loc3 in this.buttons) {
				if(loc3 != param1) {
					loc3.selected = false;
					loc3.y = 3;
					this.updateTabButtonGraphicState(loc3,loc2);
				} else {
					loc3.selected = true;
				}
			}
			if(this.currentContent) {
				this.currentContent.displaySignal.dispatch(false);
				this.currentContent.alpha = 0;
				this.currentContent.mouseChildren = false;
				this.currentContent.mouseEnabled = false;
			}
			this.currentContent = this.content[loc2];
			if(this.background) {
				this.background.addDecor(param1.x - 5,param1.x + param1.width - 12,loc2,this.buttons.length);
			}
			addChild(this.currentContent);
			this.currentContent.displaySignal.dispatch(true);
			this.currentContent.alpha = 1;
			this.currentContent.mouseChildren = true;
			this.currentContent.mouseEnabled = true;
		}
		
		private function updateTabButtonGraphicState(param1:TabButton, param2:int) : void {
			var loc3:int = this.buttons.indexOf(param1);
			if(this.borderlessMode) {
				param1.changeBitmap("tab_button_borderless_idle",new Point(0,!!this.borderlessMode?Number(0):Number(TabButton.SELECTED_MARGIN)));
				param1.bitmap.alpha = 0;
			} else if(loc3 > param2) {
				param1.changeBitmap("tab_button_right_idle",new Point(0,!!this.borderlessMode?Number(0):Number(TabButton.SELECTED_MARGIN)));
			} else {
				param1.changeBitmap("tab_button_left_idle",new Point(0,!!this.borderlessMode?Number(0):Number(TabButton.SELECTED_MARGIN)));
			}
		}
		
		public function getTabButtonByLabel(param1:String) : TabButton {
			var loc2:TabButton = null;
			for each(loc2 in this.buttons) {
				if(loc2.label.text == param1) {
					return loc2;
				}
			}
			return null;
		}
		
		private function createTabButton(param1:String, param2:String) : TabButton {
			var loc3:TabButton = new TabButton(!!this.borderlessMode?TabButton.BORDERLESS:param2);
			loc3.setLabel(param1,DefaultLabelFormat.defaultInactiveTab);
			return loc3;
		}
		
		private function onAddedHandler(param1:Event) : void {
			this.removeEventListener(Event.ADDED_TO_STAGE,this.onAddedHandler);
			this.createTabButtons();
		}
		
		public function dispose() : void {
			var loc1:TabButton = null;
			var loc2:UITab = null;
			if(this.background) {
				this.background.dispose();
			}
			for each(loc1 in this.buttons) {
				loc1.dispose();
			}
			for each(loc2 in this.content) {
				loc2.dispose();
			}
			this.currentContent.dispose();
			this.content = null;
			this.buttons = null;
		}
		
		public function get currentTabLabel() : String {
			return this._currentTabLabel;
		}
	}
}
