package kabam.rotmg.classes.view {
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	import kabam.lib.ui.api.Size;
	import kabam.rotmg.util.components.VerticalScrollingList;

	public class CharacterSkinListView extends Sprite {

		public static const PADDING:int = 5;

		public static const WIDTH:int = 442;

		public static const HEIGHT:int = 400;


		private const list:VerticalScrollingList = this.makeList();

		private var items:Vector.<DisplayObject>;

		public function CharacterSkinListView() {
			super();
		}

		private function makeList():VerticalScrollingList {
			var loc1:VerticalScrollingList = new VerticalScrollingList();
			loc1.setSize(new Size(WIDTH, HEIGHT));
			loc1.scrollStateChanged.add(this.onScrollStateChanged);
			loc1.setPadding(PADDING);
			addChild(loc1);
			return loc1;
		}

		public function setItems(param1:Vector.<DisplayObject>):void {
			this.items = param1;
			this.list.setItems(param1);
			this.onScrollStateChanged(this.list.isScrollbarVisible());
		}

		private function onScrollStateChanged(param1:Boolean):void {
			var loc3:CharacterSkinListItem = null;
			var loc2:int = CharacterSkinListItem.WIDTH;
			if (!param1) {
				loc2 = loc2 + VerticalScrollingList.SCROLLBAR_GUTTER;
			}
			for each(loc3 in this.items) {
				loc3.setWidth(loc2);
			}
		}

		public function getListHeight():Number {
			return this.list.getListHeight();
		}
	}
}
