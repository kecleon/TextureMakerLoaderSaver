 
package kabam.rotmg.arena.model {
	import kabam.rotmg.text.model.TextKey;
	
	public class ArenaLeaderboardModel {
		
		public static const FILTERS:Vector.<ArenaLeaderboardFilter> = Vector.<ArenaLeaderboardFilter>([new ArenaLeaderboardFilter(TextKey.ARENA_LEADERBOARD_ALLTIME,"alltime"),new ArenaLeaderboardFilter(TextKey.ARENA_LEADERBOARD_WEEKLY,"weekly"),new ArenaLeaderboardFilter(TextKey.ARENA_LEADERBOARD_YOURRANK,"personal")]);
		 
		
		public function ArenaLeaderboardModel() {
			super();
		}
		
		public function clearFilters() : void {
			var loc1:ArenaLeaderboardFilter = null;
			for each(loc1 in FILTERS) {
				loc1.clearEntries();
			}
		}
	}
}
