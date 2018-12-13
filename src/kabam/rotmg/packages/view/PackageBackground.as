 
package kabam.rotmg.packages.view {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class PackageBackground extends Sprite {
		
		private static const Background:Class = PackageBackground_Background;
		 
		
		private const asset:DisplayObject = this.makeBackground();
		
		public function PackageBackground() {
			super();
		}
		
		private function makeBackground() : DisplayObject {
			var loc1:DisplayObject = new Background();
			addChild(loc1);
			return loc1;
		}
	}
}
