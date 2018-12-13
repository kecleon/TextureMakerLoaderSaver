 
package kabam.rotmg.dailyLogin.view {
	import com.company.util.GraphicsUtil;
	import flash.display.CapsStyle;
	import flash.display.GraphicsPath;
	import flash.display.GraphicsSolidFill;
	import flash.display.GraphicsStroke;
	import flash.display.IGraphicsData;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import kabam.rotmg.dailyLogin.config.CalendarSettings;
	
	public class CalendarTabsView extends Sprite {
		 
		
		private var fill_:GraphicsSolidFill;
		
		private var fillTransparent_:GraphicsSolidFill;
		
		private var lineStyle_:GraphicsStroke;
		
		private var path_:GraphicsPath;
		
		private var graphicsDataBackgroundTransparent:Vector.<IGraphicsData>;
		
		private var modalRectangle:Rectangle;
		
		private var tabs:Vector.<CalendarTabButton>;
		
		private var calendar:CalendarView;
		
		public function CalendarTabsView() {
			this.fill_ = new GraphicsSolidFill(3552822,1);
			this.fillTransparent_ = new GraphicsSolidFill(3552822,0);
			this.lineStyle_ = new GraphicsStroke(CalendarSettings.BOX_BORDER,false,LineScaleMode.NORMAL,CapsStyle.NONE,JointStyle.ROUND,3,new GraphicsSolidFill(16777215));
			this.path_ = new GraphicsPath(new Vector.<int>(),new Vector.<Number>());
			this.graphicsDataBackgroundTransparent = new <IGraphicsData>[this.lineStyle_,this.fillTransparent_,this.path_,GraphicsUtil.END_FILL,GraphicsUtil.END_STROKE];
			super();
		}
		
		public function init(param1:Rectangle) : void {
			this.modalRectangle = param1;
			this.tabs = new Vector.<CalendarTabButton>();
		}
		
		public function addCalendar(param1:String, param2:String, param3:String) : CalendarTabButton {
			var loc4:CalendarTabButton = null;
			loc4 = new CalendarTabButton(param1,param3,param2,CalendarTabButton.STATE_IDLE,this.tabs.length);
			this.addChild(loc4);
			loc4.x = (CalendarSettings.TABS_WIDTH - 1) * this.tabs.length;
			this.tabs.push(loc4);
			return loc4;
		}
		
		public function selectTab(param1:String) : void {
			var loc2:CalendarTabButton = null;
			for each(loc2 in this.tabs) {
				if(loc2.calendarType == param1) {
					loc2.state = CalendarTabButton.STATE_SELECTED;
				} else {
					loc2.state = CalendarTabButton.STATE_IDLE;
				}
			}
			if(this.calendar) {
				removeChild(this.calendar);
			}
			this.calendar = new CalendarView();
			addChild(this.calendar);
			this.calendar.x = CalendarSettings.DAILY_LOGIN_TABS_PADDING;
		}
		
		public function drawTabs() : void {
			this.drawBorder();
		}
		
		private function drawBorder() : void {
			var loc1:Sprite = new Sprite();
			this.drawRectangle(loc1,this.modalRectangle.width,this.modalRectangle.height);
			addChild(loc1);
			loc1.y = CalendarSettings.TABS_HEIGHT;
		}
		
		private function drawRectangle(param1:Sprite, param2:int, param3:int) : void {
			param1.addChild(CalendarDayBox.drawRectangleWithCuts([0,0,1,1],param2,param3,3552822,1,this.graphicsDataBackgroundTransparent,this.path_));
		}
	}
}
