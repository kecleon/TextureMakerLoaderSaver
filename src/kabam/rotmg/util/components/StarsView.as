 
package kabam.rotmg.util.components {
	import com.company.rotmg.graphics.StarGraphic;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	
	public class StarsView extends Sprite {
		
		private static const TOTAL:int = 5;
		
		private static const MARGIN:int = 4;
		
		private static const CORNER:int = 15;
		
		private static const BACKGROUND_COLOR:uint = 2434341;
		
		private static const EMPTY_STAR_COLOR:uint = 8618883;
		
		private static const FILLED_STAR_COLOR:uint = 16777215;
		 
		
		private const stars:Vector.<StarGraphic> = this.makeStars();
		
		private const background:Sprite = this.makeBackground();
		
		public function StarsView() {
			super();
		}
		
		private function makeStars() : Vector.<StarGraphic> {
			var loc1:Vector.<StarGraphic> = this.makeStarList();
			this.layoutStars(loc1);
			return loc1;
		}
		
		private function makeStarList() : Vector.<StarGraphic> {
			var loc1:Vector.<StarGraphic> = new Vector.<StarGraphic>(TOTAL,true);
			var loc2:int = 0;
			while(loc2 < TOTAL) {
				loc1[loc2] = new StarGraphic();
				addChild(loc1[loc2]);
				loc2++;
			}
			return loc1;
		}
		
		private function layoutStars(param1:Vector.<StarGraphic>) : void {
			var loc2:int = 0;
			while(loc2 < TOTAL) {
				param1[loc2].x = MARGIN + param1[0].width * loc2;
				param1[loc2].y = MARGIN;
				loc2++;
			}
		}
		
		private function makeBackground() : Sprite {
			var loc1:Sprite = new Sprite();
			this.drawBackground(loc1.graphics);
			addChildAt(loc1,0);
			return loc1;
		}
		
		private function drawBackground(param1:Graphics) : void {
			var loc2:StarGraphic = this.stars[0];
			var loc3:int = loc2.width * TOTAL + 2 * MARGIN;
			var loc4:int = loc2.height + 2 * MARGIN;
			param1.clear();
			param1.beginFill(BACKGROUND_COLOR);
			param1.drawRoundRect(0,0,loc3,loc4,CORNER,CORNER);
			param1.endFill();
		}
		
		public function setStars(param1:int) : void {
			var loc2:int = 0;
			while(loc2 < TOTAL) {
				this.updateStar(loc2,param1);
				loc2++;
			}
		}
		
		private function updateStar(param1:int, param2:int) : void {
			var loc3:StarGraphic = this.stars[param1];
			var loc4:ColorTransform = loc3.transform.colorTransform;
			loc4.color = param1 < param2?uint(FILLED_STAR_COLOR):uint(EMPTY_STAR_COLOR);
			loc3.transform.colorTransform = loc4;
		}
	}
}
