 
package kabam.rotmg.arena.view {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import kabam.lib.ui.api.Size;
	import kabam.rotmg.arena.model.ArenaLeaderboardEntry;
	import kabam.rotmg.util.components.VerticalScrollingList;
	
	public class ArenaLeaderboardList extends Sprite {
		 
		
		private const MAX_SIZE:int = 20;
		
		private var listItemPool:Vector.<DisplayObject>;
		
		private var scrollList:VerticalScrollingList;
		
		public function ArenaLeaderboardList() {
			this.listItemPool = new Vector.<DisplayObject>(this.MAX_SIZE);
			this.scrollList = new VerticalScrollingList();
			super();
			var loc1:int = 0;
			while(loc1 < this.MAX_SIZE) {
				this.listItemPool[loc1] = new ArenaLeaderboardListItem();
				loc1++;
			}
			this.scrollList.setSize(new Size(786,400));
			addChild(this.scrollList);
		}
		
		public function setItems(param1:Vector.<ArenaLeaderboardEntry>, param2:Boolean) : void {
			var loc4:ArenaLeaderboardEntry = null;
			var loc5:ArenaLeaderboardListItem = null;
			var loc3:int = 0;
			while(loc3 < this.listItemPool.length) {
				loc4 = loc3 < param1.length?param1[loc3]:null;
				loc5 = this.listItemPool[loc3] as ArenaLeaderboardListItem;
				loc5.apply(loc4,param2);
				loc3++;
			}
			this.scrollList.setItems(this.listItemPool);
		}
	}
}
