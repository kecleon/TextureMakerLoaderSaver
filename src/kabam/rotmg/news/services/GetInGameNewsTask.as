package kabam.rotmg.news.services {
	import kabam.lib.tasks.BaseTask;
	import kabam.rotmg.appengine.api.AppEngineClient;
	import kabam.rotmg.dialogs.control.AddPopupToStartupQueueSignal;
	import kabam.rotmg.dialogs.control.OpenDialogSignal;
	import kabam.rotmg.dialogs.model.PopupNamesConfig;
	import kabam.rotmg.news.model.InGameNews;
	import kabam.rotmg.news.model.NewsModel;
	import kabam.rotmg.news.view.NewsModal;

	import robotlegs.bender.framework.api.ILogger;

	public class GetInGameNewsTask extends BaseTask {


		[Inject]
		public var logger:ILogger;

		[Inject]
		public var client:AppEngineClient;

		[Inject]
		public var model:NewsModel;

		[Inject]
		public var addToQueueSignal:AddPopupToStartupQueueSignal;

		[Inject]
		public var openDialogSignal:OpenDialogSignal;

		private var requestData:Object;

		public function GetInGameNewsTask() {
			super();
		}

		override protected function startTask():void {
			this.logger.info("GetInGameNewsTask start");
			this.requestData = this.makeRequestData();
			this.sendRequest();
		}

		public function makeRequestData():Object {
			var loc1:Object = {};
			return loc1;
		}

		private function sendRequest():void {
			this.client.complete.addOnce(this.onComplete);
			this.client.sendRequest("/inGameNews/getNews", this.requestData);
		}

		private function onComplete(param1:Boolean, param2:*):void {
			this.logger.info("String response from GetInGameNewsTask: " + param2);
			if (param1) {
				this.parseNews(param2);
			} else {
				completeTask(true);
			}
		}

		private function parseNews(param1:String):void {
			var loc3:Object = null;
			var loc4:Object = null;
			var loc5:InGameNews = null;
			this.logger.info("Parsing news");
			try {
				loc3 = JSON.parse(param1);
				for each(loc4 in loc3) {
					this.logger.info("Parse single news");
					loc5 = new InGameNews();
					loc5.newsKey = loc4.newsKey;
					loc5.showAtStartup = loc4.showAtStartup;
					loc5.startTime = loc4.startTime;
					loc5.text = loc4.text;
					loc5.title = loc4.title;
					loc5.platform = loc4.platform;
					loc5.weight = loc4.weight;
					this.model.addInGameNews(loc5);
				}
			}
			catch (e:Error) {
			}
			var loc2:InGameNews = this.model.getFirstNews();
			if (loc2 && loc2.showAtStartup && this.model.hasUpdates()) {
				this.addToQueueSignal.dispatch(PopupNamesConfig.NEWS_POPUP, this.openDialogSignal, -1, new NewsModal(true));
			}
			completeTask(true);
		}
	}
}
