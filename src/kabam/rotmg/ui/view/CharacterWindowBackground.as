 
package kabam.rotmg.ui.view {
	import flash.display.Sprite;
	
	public class CharacterWindowBackground extends Sprite {
		 
		
		public function CharacterWindowBackground() {
			super();
			var loc1:Sprite = new Sprite();
			loc1.graphics.beginFill(3552822);
			loc1.graphics.drawRect(0,0,200,600);
			addChild(loc1);
		}
	}
}
