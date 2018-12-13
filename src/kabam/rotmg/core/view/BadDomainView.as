 
package kabam.rotmg.core.view {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class BadDomainView extends Sprite {
		
		private static const BAD_DOMAIN_TEXT:String = "<p align=\"center\"><font color=\"#FFFFFF\">Play at: " + "<br/></font><font color=\"#7777EE\">" + "<a href=\"http://www.realmofthemadgod.com/\">" + "www.realmofthemadgod.com</font></a></p>";
		 
		
		public function BadDomainView() {
			super();
			var loc1:TextField = new TextField();
			loc1.selectable = false;
			var loc2:TextFormat = new TextFormat();
			loc2.size = 20;
			loc1.defaultTextFormat = loc2;
			loc1.htmlText = BAD_DOMAIN_TEXT;
			loc1.width = 800;
			loc1.y = 600 / 2 - loc1.height / 2;
			addChild(loc1);
		}
	}
}
