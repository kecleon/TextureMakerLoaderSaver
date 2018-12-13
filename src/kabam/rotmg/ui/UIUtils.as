 
package kabam.rotmg.ui {
	import flash.display.Sprite;
	import flash.display.StageQuality;
	
	public class UIUtils {
		
		private static const NOTIFICATION_BACKGROUND_WIDTH:Number = 95;
		
		public static const NOTIFICATION_BACKGROUND_HEIGHT:Number = 25;
		
		private static const NOTIFICATION_BACKGROUND_ALPHA:Number = 0.4;
		
		private static const NOTIFICATION_BACKGROUND_COLOR:Number = 0;
		
		public static const EXPERIMENTAL_MENU_PASSWORD:String = "decamenu";
		
		public static var SHOW_EXPERIMENTAL_MENU:Boolean = true;
		
		public static const NOTIFICATION_SPACE:uint = 28;
		 
		
		public function UIUtils() {
			super();
		}
		
		public static function makeStaticHUDBackground() : Sprite {
			var loc1:Number = NOTIFICATION_BACKGROUND_WIDTH;
			var loc2:Number = NOTIFICATION_BACKGROUND_HEIGHT;
			return makeHUDBackground(loc1,loc2);
		}
		
		public static function makeHUDBackground(param1:Number, param2:Number) : Sprite {
			var loc3:Sprite = new Sprite();
			return drawHUDBackground(loc3,param1,param2);
		}
		
		private static function drawHUDBackground(param1:Sprite, param2:Number, param3:Number) : Sprite {
			param1.graphics.beginFill(NOTIFICATION_BACKGROUND_COLOR,NOTIFICATION_BACKGROUND_ALPHA);
			param1.graphics.drawRoundRect(0,0,param2,param3,12,12);
			param1.graphics.endFill();
			return param1;
		}
		
		public static function toggleQuality(param1:Boolean) : void {
			if(WebMain.STAGE != null) {
				WebMain.STAGE.quality = !!param1?StageQuality.HIGH:StageQuality.LOW;
			}
		}
	}
}
