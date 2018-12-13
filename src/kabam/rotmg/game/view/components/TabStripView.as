package kabam.rotmg.game.view.components {
	import com.company.assembleegameclient.objects.ImageFactory;
	import com.company.assembleegameclient.ui.icons.IconButtonFactory;
	import com.company.ui.BaseSimpleText;
	import com.company.util.GraphicsUtil;

	import flash.display.Bitmap;
	import flash.display.GraphicsPath;
	import flash.display.GraphicsSolidFill;
	import flash.display.IGraphicsData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	import org.osflash.signals.Signal;

	public class TabStripView extends Sprite {


		public var iconButtonFactory:IconButtonFactory;

		public var imageFactory:ImageFactory;

		public const tabSelected:Signal = new Signal(String);

		public const WIDTH:Number = 186;

		public const HEIGHT:Number = 153;

		private const tabSprite:Sprite = new Sprite();

		private const background:Sprite = new Sprite();

		private const containerSprite:Sprite = new Sprite();

		private var _width:Number;

		private var _height:Number;

		public var tabs:Vector.<TabView>;

		private var contents:Vector.<Sprite>;

		public var currentTabIndex:int;

		public function TabStripView(param1:Number = 186, param2:Number = 153) {
			this.tabs = new Vector.<TabView>();
			this.contents = new Vector.<Sprite>();
			super();
			this._width = param1;
			this._height = param2;
			this.tabSprite.addEventListener(MouseEvent.CLICK, this.onTabClicked);
			addChild(this.tabSprite);
			this.drawBackground();
			addChild(this.containerSprite);
			this.containerSprite.y = TabConstants.TAB_TOP_OFFSET;
		}

		private function onTabClicked(param1:MouseEvent):void {
			this.selectTab(param1.target.parent as TabView);
		}

		public function setSelectedTab(param1:uint):void {
			this.selectTab(this.tabs[param1]);
		}

		private function selectTab(param1:TabView):void {
			var loc2:TabView = null;
			if (param1) {
				loc2 = this.tabs[this.currentTabIndex];
				if (loc2.index != param1.index) {
					loc2.setSelected(false);
					param1.setSelected(true);
					this.showContent(param1.index);
					this.tabSelected.dispatch(this.contents[param1.index].name);
				}
			}
		}

		public function getTabView(param1:Class):* {
			var loc2:Sprite = null;
			for each(loc2 in this.contents) {
				if (loc2 is param1) {
					return loc2 as param1;
				}
			}
			return null;
		}

		public function drawBackground():void {
			var loc1:GraphicsSolidFill = new GraphicsSolidFill(TabConstants.BACKGROUND_COLOR, 1);
			var loc2:GraphicsPath = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());
			var loc3:Vector.<IGraphicsData> = new <IGraphicsData>[loc1, loc2, GraphicsUtil.END_FILL];
			GraphicsUtil.drawCutEdgeRect(0, 0, this._width, this._height - TabConstants.TAB_TOP_OFFSET, 6, [1, 1, 1, 1], loc2);
			this.background.graphics.drawGraphicsData(loc3);
			this.background.y = TabConstants.TAB_TOP_OFFSET;
			addChild(this.background);
		}

		public function clearTabs():void {
			var loc1:uint = 0;
			this.currentTabIndex = 0;
			var loc2:uint = this.tabs.length;
			loc1 = 0;
			while (loc1 < loc2) {
				this.tabSprite.removeChild(this.tabs[loc1]);
				this.containerSprite.removeChild(this.contents[loc1]);
				loc1++;
			}
			this.tabs = new Vector.<TabView>();
			this.contents = new Vector.<Sprite>();
		}

		public function addTab(param1:*, param2:Sprite):void {
			var loc4:TabView = null;
			var loc3:int = this.tabs.length;
			if (param1 is Bitmap) {
				loc4 = this.addIconTab(loc3, param1 as Bitmap);
			} else if (param1 is BaseSimpleText) {
				loc4 = this.addTextTab(loc3, param1 as BaseSimpleText);
			}
			this.tabs.push(loc4);
			this.tabSprite.addChild(loc4);
			this.contents.push(param2);
			this.containerSprite.addChild(param2);
			if (loc3 > 0) {
				param2.visible = false;
			} else {
				loc4.setSelected(true);
				this.showContent(0);
				this.tabSelected.dispatch(param2.name);
			}
		}

		public function removeTab():void {
		}

		private function addIconTab(param1:int, param2:Bitmap):TabIconView {
			var loc3:Sprite = new TabBackground();
			var loc4:TabIconView = new TabIconView(param1, loc3, param2);
			loc4.x = param1 * (loc3.width + TabConstants.PADDING);
			loc4.y = TabConstants.TAB_Y_POS;
			return loc4;
		}

		private function addTextTab(param1:int, param2:BaseSimpleText):TabTextView {
			var loc3:Sprite = new TabBackground();
			var loc4:TabTextView = new TabTextView(param1, loc3, param2);
			loc4.x = param1 * (loc3.width + TabConstants.PADDING);
			loc4.y = TabConstants.TAB_Y_POS;
			return loc4;
		}

		private function showContent(param1:int):void {
			var loc2:Sprite = null;
			var loc3:Sprite = null;
			if (param1 != this.currentTabIndex) {
				loc2 = this.contents[this.currentTabIndex];
				loc3 = this.contents[param1];
				loc2.visible = false;
				loc3.visible = true;
				this.currentTabIndex = param1;
			}
		}
	}
}
