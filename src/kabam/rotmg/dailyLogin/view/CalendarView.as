 
package kabam.rotmg.dailyLogin.view {
	import flash.display.Sprite;
	import kabam.rotmg.dailyLogin.config.CalendarSettings;
	import kabam.rotmg.dailyLogin.model.CalendarDayModel;
	
	public class CalendarView extends Sprite {
		 
		
		public function CalendarView() {
			super();
		}
		
		public function init(param1:Vector.<CalendarDayModel>, param2:int, param3:int) : void {
			var loc5:int = 0;
			var loc6:int = 0;
			var loc7:CalendarDayModel = null;
			var loc8:int = 0;
			var loc9:CalendarDayBox = null;
			var loc4:int = 0;
			loc5 = 0;
			loc6 = 0;
			for each(loc7 in param1) {
				loc9 = new CalendarDayBox(loc7,param2,loc4 + 1 == param3);
				addChild(loc9);
				loc9.x = loc5 * CalendarSettings.BOX_WIDTH;
				if(loc5 > 0) {
					loc9.x = loc9.x + loc5 * CalendarSettings.BOX_MARGIN;
				}
				loc9.y = loc6 * CalendarSettings.BOX_HEIGHT;
				if(loc6 > 0) {
					loc9.y = loc9.y + loc6 * CalendarSettings.BOX_MARGIN;
				}
				loc5++;
				loc4++;
				if(loc4 % CalendarSettings.NUMBER_OF_COLUMNS == 0) {
					loc5 = 0;
					loc6++;
				}
			}
			loc8 = CalendarSettings.BOX_WIDTH * CalendarSettings.NUMBER_OF_COLUMNS + (CalendarSettings.NUMBER_OF_COLUMNS - 1) * CalendarSettings.BOX_MARGIN;
			this.x = (this.parent.width - loc8) / 2;
			this.y = CalendarSettings.DAILY_LOGIN_TABS_PADDING + CalendarSettings.TABS_HEIGHT;
		}
	}
}
