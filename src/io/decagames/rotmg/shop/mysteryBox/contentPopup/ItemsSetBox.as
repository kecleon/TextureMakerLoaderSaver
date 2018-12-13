package io.decagames.rotmg.shop.mysteryBox.contentPopup {
	import io.decagames.rotmg.ui.gird.UIGridElement;

	public class ItemsSetBox extends UIGridElement {


		private var items:Vector.<ItemBox>;

		public function ItemsSetBox(param1:Vector.<ItemBox>) {
			var loc3:ItemBox = null;
			super();
			this.items = param1;
			var loc2:int = 0;
			for each(loc3 in param1) {
				loc3.y = loc2;
				addChild(loc3);
				loc2 = loc2 + loc3.height;
			}
			this.drawBackground(260);
		}

		private function drawBackground(param1:int):void {
			this.graphics.clear();
			this.graphics.lineStyle(1, 10915138);
			this.graphics.beginFill(2960685);
			this.graphics.drawRect(0, 0, param1, this.items.length * 48);
			this.graphics.endFill();
		}

		override public function get height():Number {
			return this.items.length * 48;
		}

		override public function resize(param1:int, param2:int = -1):void {
			this.drawBackground(param1);
		}

		override public function dispose():void {
			var loc1:ItemBox = null;
			for each(loc1 in this.items) {
				loc1.dispose();
			}
			this.items = null;
			super.dispose();
		}
	}
}
