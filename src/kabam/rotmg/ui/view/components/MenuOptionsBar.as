package kabam.rotmg.ui.view.components {
	import com.company.assembleegameclient.screens.TitleMenuOption;
	import com.company.rotmg.graphics.ScreenGraphic;

	import flash.display.Sprite;
	import flash.geom.Rectangle;

	public class MenuOptionsBar extends Sprite {

		private static const Y_POSITION:Number = 550;

		private static const SPACING:int = 20;

		public static const CENTER:String = "CENTER";

		public static const RIGHT:String = "RIGHT";

		public static const LEFT:String = "LEFT";


		private var screenGraphic:ScreenGraphic;

		private const leftObjects:Array = [];

		private const rightObjects:Array = [];

		public function MenuOptionsBar() {
			super();
			this.makeScreenGraphic();
		}

		private function makeScreenGraphic():void {
			this.screenGraphic = new ScreenGraphic();
			addChild(this.screenGraphic);
		}

		public function addButton(param1:TitleMenuOption, param2:String):void {
			this.screenGraphic.addChild(param1);
			switch (param2) {
				case CENTER:
					this.leftObjects[0] = this.rightObjects[0] = param1;
					param1.x = this.screenGraphic.width / 2;
					param1.y = Y_POSITION;
					break;
				case LEFT:
					this.layoutToLeftOf(this.leftObjects[this.leftObjects.length - 1], param1);
					this.leftObjects.push(param1);
					param1.changed.add(this.layoutLeftButtons);
					break;
				case RIGHT:
					this.layoutToRightOf(this.rightObjects[this.rightObjects.length - 1], param1);
					this.rightObjects.push(param1);
					param1.changed.add(this.layoutRightButtons);
			}
		}

		private function layoutLeftButtons():void {
			var loc1:int = 1;
			while (loc1 < this.leftObjects.length) {
				this.layoutToLeftOf(this.leftObjects[loc1 - 1], this.leftObjects[loc1]);
				loc1++;
			}
		}

		private function layoutToLeftOf(param1:TitleMenuOption, param2:TitleMenuOption):void {
			var loc3:Rectangle = param1.getBounds(param1);
			var loc4:Rectangle = param2.getBounds(param2);
			param2.x = param1.x + loc3.left - loc4.right - SPACING;
			param2.y = Y_POSITION;
		}

		private function layoutRightButtons():void {
			var loc1:int = 1;
			while (loc1 < this.rightObjects.length) {
				this.layoutToRightOf(this.rightObjects[loc1 - 1], this.rightObjects[loc1]);
				loc1++;
			}
		}

		private function layoutToRightOf(param1:TitleMenuOption, param2:TitleMenuOption):void {
			var loc3:Rectangle = param1.getBounds(param1);
			var loc4:Rectangle = param2.getBounds(param2);
			param2.x = param1.x + loc3.right - loc4.left + SPACING;
			param2.y = Y_POSITION;
		}
	}
}
