 
package kabam.rotmg.friends.view {
	import com.company.ui.BaseSimpleText;
	import com.company.util.GraphicsUtil;
	import flash.display.GraphicsPath;
	import flash.display.GraphicsSolidFill;
	import flash.display.IGraphicsData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import kabam.rotmg.game.view.components.TabBackground;
	import kabam.rotmg.game.view.components.TabConstants;
	import kabam.rotmg.game.view.components.TabTextView;
	import kabam.rotmg.game.view.components.TabView;
	import org.osflash.signals.Signal;
	
	public class FriendTabView extends Sprite {
		 
		
		public const tabSelected:Signal = new Signal(String);
		
		private const TAB_WIDTH:int = 120;
		
		private const TAB_HEIGHT:int = 30;
		
		private const tabSprite:Sprite = new Sprite();
		
		private const background:Sprite = new Sprite();
		
		private const containerSprite:Sprite = new Sprite();
		
		public var tabs:Vector.<TabView>;
		
		public var currentTabIndex:int;
		
		private var _width:Number;
		
		private var _height:Number;
		
		private var contents:Vector.<Sprite>;
		
		public function FriendTabView(param1:Number, param2:Number) {
			this.tabs = new Vector.<TabView>();
			this.contents = new Vector.<Sprite>();
			super();
			this._width = param1;
			this._height = param2;
			this.tabSprite.addEventListener(MouseEvent.CLICK,this.onTabClicked);
			addChild(this.tabSprite);
			this.drawBackground();
			addChild(this.containerSprite);
		}
		
		public function destroy() : void {
			while(numChildren > 0) {
				this.removeChildAt(numChildren - 1);
			}
			this.tabSprite.removeEventListener(MouseEvent.CLICK,this.onTabClicked);
			this.tabs = null;
			this.contents = null;
		}
		
		public function addTab(param1:BaseSimpleText, param2:Sprite) : void {
			var loc3:int = this.tabs.length;
			var loc4:TabView = this.addTextTab(loc3,param1 as BaseSimpleText);
			this.tabs.push(loc4);
			this.tabSprite.addChild(loc4);
			param2.y = this.TAB_HEIGHT + 5;
			this.contents.push(param2);
			this.containerSprite.addChild(param2);
			if(loc3 > 0) {
				param2.visible = false;
			} else {
				loc4.setSelected(true);
				this.showContent(0);
				this.tabSelected.dispatch(param2.name);
			}
		}
		
		public function clearTabs() : void {
			var loc1:uint = 0;
			this.currentTabIndex = 0;
			var loc2:uint = this.tabs.length;
			loc1 = 0;
			while(loc1 < loc2) {
				this.tabSprite.removeChild(this.tabs[loc1]);
				this.containerSprite.removeChild(this.contents[loc1]);
				loc1++;
			}
			this.tabs = new Vector.<TabView>();
			this.contents = new Vector.<Sprite>();
		}
		
		public function removeTab() : void {
		}
		
		public function setSelectedTab(param1:uint) : void {
			this.selectTab(this.tabs[param1]);
		}
		
		public function showTabBadget(param1:uint, param2:int) : void {
			var loc3:TabView = this.tabs[param1];
			(loc3 as TabTextView).setBadge(param2);
		}
		
		private function onTabClicked(param1:MouseEvent) : void {
			this.selectTab(param1.target.parent as TabView);
		}
		
		private function selectTab(param1:TabView) : void {
			var loc2:TabView = null;
			if(param1) {
				loc2 = this.tabs[this.currentTabIndex];
				if(loc2.index != param1.index) {
					loc2.setSelected(false);
					param1.setSelected(true);
					this.showContent(param1.index);
					this.tabSelected.dispatch(this.contents[param1.index].name);
				}
			}
		}
		
		private function addTextTab(param1:int, param2:BaseSimpleText) : TabTextView {
			var loc3:Sprite = new TabBackground(this.TAB_WIDTH,this.TAB_HEIGHT);
			var loc4:TabTextView = new TabTextView(param1,loc3,param2);
			loc4.x = param1 * (param2.width + 12);
			loc4.y = 4;
			return loc4;
		}
		
		private function showContent(param1:int) : void {
			var loc2:Sprite = null;
			var loc3:Sprite = null;
			if(param1 != this.currentTabIndex) {
				loc2 = this.contents[this.currentTabIndex];
				loc3 = this.contents[param1];
				loc2.visible = false;
				loc3.visible = true;
				this.currentTabIndex = param1;
			}
		}
		
		private function drawBackground() : void {
			var loc1:GraphicsSolidFill = new GraphicsSolidFill(TabConstants.BACKGROUND_COLOR,1);
			var loc2:GraphicsPath = new GraphicsPath(new Vector.<int>(),new Vector.<Number>());
			var loc3:Vector.<IGraphicsData> = new <IGraphicsData>[loc1,loc2,GraphicsUtil.END_FILL];
			GraphicsUtil.drawCutEdgeRect(0,0,this._width,this._height - TabConstants.TAB_TOP_OFFSET,6,[1,1,1,1],loc2);
			this.background.graphics.drawGraphicsData(loc3);
			this.background.y = TabConstants.TAB_TOP_OFFSET;
			addChild(this.background);
		}
	}
}
