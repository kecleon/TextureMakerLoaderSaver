package io.decagames.rotmg.dailyQuests.view.list {
	import flash.display.Sprite;

	import io.decagames.rotmg.ui.buttons.BaseButton;
	import io.decagames.rotmg.ui.scroll.UIScrollbar;
	import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
	import io.decagames.rotmg.ui.tabs.TabButton;
	import io.decagames.rotmg.ui.tabs.UITab;
	import io.decagames.rotmg.ui.tabs.UITabs;
	import io.decagames.rotmg.ui.texture.TextureParser;

	public class DailyQuestsList extends Sprite {

		public static const LIST_WIDTH:int = 223;

		public static const SCROLL_WIDTH:int = 14;

		public static const SCROLL_TOP_MARGIN:int = 0;

		public static const SCROLL_RIGHT_MARGIN:int = 6;

		public static const QUEST_ELEMENTS_MARGIN:int = 9;

		public static const QUEST_ELEMENTS_LEFT_MARGIN:int = 5;

		public static const SCROLL_BAR_HEIGHT:int = 435;


		private var questLinesPosition:int = 0;

		private var eventLinesPosition:int = 0;

		private var questsContainer:Sprite;

		private var eventsContainer:Sprite;

		private var _tabs:UITabs;

		private var eventsTab:TabButton;

		private var contentTabs:SliceScalingBitmap;

		private var contentInset:SliceScalingBitmap;

		public function DailyQuestsList() {
			super();
			this.contentTabs = TextureParser.instance.getSliceScalingBitmap("UI", "tab_inset_content_background", 230);
			addChild(this.contentTabs);
			this.contentTabs.height = 45;
			this.contentTabs.x = 0;
			this.contentTabs.y = 0;
			this.contentInset = TextureParser.instance.getSliceScalingBitmap("UI", "popup_content_inset", 230);
			addChild(this.contentInset);
			this.contentInset.height = 380;
			this.contentInset.x = 0;
			this.contentInset.y = 35;
			this._tabs = new UITabs(230, true);
			this._tabs.addTab(this.createQuestsTab(), true);
			this._tabs.addTab(this.createEventsTab());
			this._tabs.y = 1;
			this._tabs.x = 0;
			addChild(this._tabs);
		}

		private function createQuestsTab():UITab {
			var loc1:UITab = null;
			var loc2:Sprite = null;
			var loc3:UIScrollbar = null;
			loc1 = new UITab("Quests");
			loc2 = new Sprite();
			this.questsContainer = new Sprite();
			this.questsContainer.x = this.contentInset.x;
			this.questsContainer.y = 10;
			loc2.addChild(this.questsContainer);
			loc3 = new UIScrollbar(365);
			loc3.mouseRollSpeedFactor = 1;
			loc3.scrollObject = loc1;
			loc3.content = this.questsContainer;
			loc2.addChild(loc3);
			loc3.x = this.contentInset.x + this.contentInset.width - 25;
			loc3.y = 7;
			var loc4:Sprite = new Sprite();
			loc4.graphics.beginFill(0);
			loc4.graphics.drawRect(0, 0, 230, 365);
			loc4.x = this.questsContainer.x;
			loc4.y = this.questsContainer.y;
			this.questsContainer.mask = loc4;
			loc2.addChild(loc4);
			loc1.addContent(loc2);
			return loc1;
		}

		private function createEventsTab():UITab {
			var loc1:UITab = new UITab("Events");
			var loc2:Sprite = new Sprite();
			this.eventsContainer = new Sprite();
			this.eventsContainer.x = this.contentInset.x;
			this.eventsContainer.y = 10;
			loc2.addChild(this.eventsContainer);
			var loc3:UIScrollbar = new UIScrollbar(365);
			loc3.mouseRollSpeedFactor = 1;
			loc3.scrollObject = loc1;
			loc3.content = this.eventsContainer;
			loc2.addChild(loc3);
			loc3.x = this.contentInset.x + this.contentInset.width - 25;
			loc3.y = 7;
			var loc4:Sprite = new Sprite();
			loc4.graphics.beginFill(0);
			loc4.graphics.drawRect(0, 0, 230, 365);
			loc4.x = this.eventsContainer.x;
			loc4.y = this.eventsContainer.y;
			this.eventsContainer.mask = loc4;
			loc2.addChild(loc4);
			loc1.addContent(loc2);
			return loc1;
		}

		public function addIndicator(param1:Boolean):void {
			this.eventsTab = this._tabs.getTabButtonByLabel("Events");
			if (this.eventsTab) {
				this.eventsTab.showIndicator = param1;
				this.eventsTab.clickSignal.add(this.onEventsClick);
			}
		}

		private function onEventsClick(param1:BaseButton):void {
			if (TabButton(param1).hasIndicator) {
				TabButton(param1).showIndicator = false;
			}
		}

		public function addQuestToList(param1:DailyQuestListElement):void {
			param1.x = 10;
			param1.y = this.questLinesPosition * 35;
			this.questsContainer.addChild(param1);
			this.questLinesPosition++;
		}

		public function addEventToList(param1:DailyQuestListElement):void {
			param1.x = 10;
			param1.y = this.eventLinesPosition * 35;
			this.eventsContainer.addChild(param1);
			this.eventLinesPosition++;
		}

		public function get list():Sprite {
			return this.questsContainer;
		}

		public function get tabs():UITabs {
			return this._tabs;
		}
	}
}
