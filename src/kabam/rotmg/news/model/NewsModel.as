 
package kabam.rotmg.news.model {
	import com.company.assembleegameclient.parameters.Parameters;
	import kabam.rotmg.account.core.Account;
	import kabam.rotmg.news.controller.NewsButtonRefreshSignal;
	import kabam.rotmg.news.controller.NewsDataUpdatedSignal;
	import kabam.rotmg.news.view.NewsModalPage;
	
	public class NewsModel {
		
		private static const COUNT:int = 3;
		
		public static const MODAL_PAGE_COUNT:int = 4;
		 
		
		[Inject]
		public var update:NewsDataUpdatedSignal;
		
		[Inject]
		public var updateNoParams:NewsButtonRefreshSignal;
		
		[Inject]
		public var account:Account;
		
		public var news:Vector.<NewsCellVO>;
		
		public var modalPages:Vector.<NewsModalPage>;
		
		public var modalPageData:Vector.<NewsCellVO>;
		
		private var inGameNews:Vector.<InGameNews>;
		
		public function NewsModel() {
			this.inGameNews = new Vector.<InGameNews>();
			super();
		}
		
		public function addInGameNews(param1:InGameNews) : void {
			if(this.isValidForPlatform(param1)) {
				this.inGameNews.push(param1);
			}
			this.sortNews();
		}
		
		private function sortNews() : void {
			this.inGameNews.sort(function(param1:InGameNews, param2:InGameNews):int {
				if(param1.weight > param2.weight) {
					return -1;
				}
				if(param1.weight == param2.weight) {
					return 0;
				}
				return 1;
			});
		}
		
		public function markAsRead() : void {
			var loc1:InGameNews = this.getFirstNews();
			if(loc1 != null) {
				Parameters.data_["lastNewsKey"] = loc1.newsKey;
				Parameters.save();
			}
		}
		
		public function hasUpdates() : Boolean {
			var loc1:InGameNews = this.getFirstNews();
			if(loc1 == null || Parameters.data_["lastNewsKey"] == loc1.newsKey) {
				return false;
			}
			return true;
		}
		
		public function getFirstNews() : InGameNews {
			if(this.inGameNews && this.inGameNews.length > 0) {
				return this.inGameNews[0];
			}
			return null;
		}
		
		public function initNews() : void {
			this.news = new Vector.<NewsCellVO>(COUNT,true);
			var loc1:int = 0;
			while(loc1 < COUNT) {
				this.news[loc1] = new DefaultNewsCellVO(loc1);
				loc1++;
			}
		}
		
		public function updateNews(param1:Vector.<NewsCellVO>) : void {
			var loc3:NewsCellVO = null;
			var loc4:int = 0;
			var loc5:int = 0;
			this.initNews();
			var loc2:Vector.<NewsCellVO> = new Vector.<NewsCellVO>();
			this.modalPageData = new Vector.<NewsCellVO>(4,true);
			for each(loc3 in param1) {
				if(loc3.slot <= 3) {
					loc2.push(loc3);
				} else {
					loc4 = loc3.slot - 4;
					loc5 = loc4 + 1;
					this.modalPageData[loc4] = loc3;
					if(Parameters.data_["newsTimestamp" + loc5] != loc3.endDate) {
						Parameters.data_["newsTimestamp" + loc5] = loc3.endDate;
						Parameters.data_["hasNewsUpdate" + loc5] = true;
					}
				}
			}
			this.sortByPriority(loc2);
			this.update.dispatch(this.news);
			this.updateNoParams.dispatch();
		}
		
		private function sortByPriority(param1:Vector.<NewsCellVO>) : void {
			var loc2:NewsCellVO = null;
			for each(loc2 in param1) {
				if(this.isNewsTimely(loc2) && this.isValidForPlatformGlobal(loc2)) {
					this.prioritize(loc2);
				}
			}
		}
		
		private function prioritize(param1:NewsCellVO) : void {
			var loc2:uint = param1.slot - 1;
			if(this.news[loc2]) {
				param1 = this.comparePriority(this.news[loc2],param1);
			}
			this.news[loc2] = param1;
		}
		
		private function comparePriority(param1:NewsCellVO, param2:NewsCellVO) : NewsCellVO {
			return param1.priority < param2.priority?param1:param2;
		}
		
		private function isNewsTimely(param1:NewsCellVO) : Boolean {
			var loc2:Number = new Date().getTime();
			return param1.startDate < loc2 && loc2 < param1.endDate;
		}
		
		public function hasValidNews() : Boolean {
			return this.news[0] != null && this.news[1] != null && this.news[2] != null;
		}
		
		public function hasValidModalNews() : Boolean {
			return this.inGameNews.length > 0;
		}
		
		public function get numberOfNews() : int {
			return this.inGameNews.length;
		}
		
		public function getModalPage(param1:int) : NewsModalPage {
			var loc2:InGameNews = null;
			if(this.hasValidModalNews()) {
				loc2 = this.inGameNews[param1 - 1];
				return new NewsModalPage(loc2.title,loc2.text);
			}
			return new NewsModalPage("No new information","Please check back later.");
		}
		
		private function isValidForPlatformGlobal(param1:NewsCellVO) : Boolean {
			var loc2:String = this.account.playPlatform();
			return param1.networks.indexOf(loc2) != -1;
		}
		
		private function isValidForPlatform(param1:InGameNews) : Boolean {
			var loc2:String = this.account.gameNetwork();
			return param1.platform.indexOf(loc2) != -1;
		}
	}
}
