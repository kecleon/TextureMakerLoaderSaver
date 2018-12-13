package kabam.rotmg.dailyLogin.controller {
	import flash.events.MouseEvent;

	import kabam.rotmg.dailyLogin.config.CalendarSettings;
	import kabam.rotmg.dailyLogin.model.CalendarTypes;
	import kabam.rotmg.dailyLogin.model.DailyLoginModel;
	import kabam.rotmg.dailyLogin.view.CalendarTabButton;
	import kabam.rotmg.dailyLogin.view.CalendarTabsView;

	import robotlegs.bender.bundles.mvcs.Mediator;

	public class CalendarTabsViewMediator extends Mediator {


		[Inject]
		public var view:CalendarTabsView;

		[Inject]
		public var model:DailyLoginModel;

		private var tabs:Vector.<CalendarTabButton>;

		public function CalendarTabsViewMediator() {
			super();
		}

		override public function initialize():void {
			var loc2:CalendarTabButton = null;
			this.tabs = new Vector.<CalendarTabButton>();
			this.view.init(CalendarSettings.getTabsRectangle(this.model.overallMaxDays));
			var loc1:String = "";
			if (this.model.hasCalendar(CalendarTypes.NON_CONSECUTIVE)) {
				loc1 = CalendarTypes.NON_CONSECUTIVE;
				this.tabs.push(this.view.addCalendar("Login Calendar", CalendarTypes.NON_CONSECUTIVE, "Unlock rewards the more days you login. Logins do not need to be in consecutive days. You must claim all rewards before the end of the event."));
			}
			if (this.model.hasCalendar(CalendarTypes.CONSECUTIVE)) {
				if (loc1 == "") {
					loc1 = CalendarTypes.CONSECUTIVE;
				}
				this.tabs.push(this.view.addCalendar("Login Streak", CalendarTypes.CONSECUTIVE, "Login on consecutive days to keep your streak alive. The more consecutive days you login, the more rewards you can unlock. If you miss a day, you start over. All rewards must be claimed by the end of the event."));
			}
			for each(loc2 in this.tabs) {
				loc2.addEventListener(MouseEvent.CLICK, this.onTabChange);
			}
			this.view.drawTabs();
			if (loc1 != "") {
				this.model.currentDisplayedCaledar = loc1;
				this.view.selectTab(loc1);
			}
		}

		private function onTabChange(param1:MouseEvent):void {
			param1.stopImmediatePropagation();
			param1.stopPropagation();
			var loc2:CalendarTabButton = param1.currentTarget as CalendarTabButton;
			if (loc2 != null) {
				this.model.currentDisplayedCaledar = loc2.calendarType;
				this.view.selectTab(loc2.calendarType);
			}
		}

		override public function destroy():void {
			var loc1:CalendarTabButton = null;
			for each(loc1 in this.tabs) {
				loc1.removeEventListener(MouseEvent.CLICK, this.onTabChange);
			}
			this.tabs = new Vector.<CalendarTabButton>();
			super.destroy();
		}
	}
}
