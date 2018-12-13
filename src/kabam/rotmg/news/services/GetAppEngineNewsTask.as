package kabam.rotmg.news.services {
	import flash.utils.getTimer;

	import kabam.lib.tasks.BaseTask;
	import kabam.rotmg.appengine.api.AppEngineClient;
	import kabam.rotmg.language.model.LanguageModel;
	import kabam.rotmg.news.model.NewsCellLinkType;
	import kabam.rotmg.news.model.NewsCellVO;
	import kabam.rotmg.news.model.NewsModel;

	public class GetAppEngineNewsTask extends BaseTask implements GetNewsTask {

		private static const TEN_MINUTES:int = 600;


		[Inject]
		public var client:AppEngineClient;

		[Inject]
		public var model:NewsModel;

		[Inject]
		public var languageModel:LanguageModel;

		private var lastRan:int = -1;

		private var numUpdateAttempts:int = 0;

		private var updateCooldown:int = 600;

		public function GetAppEngineNewsTask() {
			super();
		}

		override protected function startTask():void {
			this.numUpdateAttempts++;
			if (this.lastRan == -1 || this.lastRan + this.updateCooldown < getTimer() / 1000) {
				this.lastRan = getTimer() / 1000;
				this.client.complete.addOnce(this.onComplete);
				this.client.sendRequest("/app/globalNews", {"language": this.languageModel.getLanguage()});
			} else {
				completeTask(true);
				reset();
			}
			if ("production".toLowerCase() != "dev" && this.updateCooldown != 0 && this.numUpdateAttempts >= 2) {
				this.updateCooldown = 0;
			}
		}

		private function onComplete(param1:Boolean, param2:*):void {
			if (param1) {
				this.onNewsRequestDone(param2);
			}
			completeTask(param1, param2);
			reset();
		}

		private function onNewsRequestDone(param1:String):void {
			var loc4:Object = null;
			var loc2:Vector.<NewsCellVO> = new Vector.<NewsCellVO>();
			var loc3:Object = JSON.parse(param1);
			for each(loc4 in loc3) {
				loc2.push(this.returnNewsCellVO(loc4));
			}
			this.model.updateNews(loc2);
		}

		private function returnNewsCellVO(param1:Object):NewsCellVO {
			var loc2:NewsCellVO = new NewsCellVO();
			loc2.headline = param1.title;
			loc2.imageURL = param1.image;
			loc2.linkDetail = param1.linkDetail;
			loc2.startDate = Number(param1.startTime);
			loc2.endDate = Number(param1.endTime);
			loc2.linkType = NewsCellLinkType.parse(param1.linkType);
			loc2.networks = String(param1.platform).split(",");
			loc2.priority = uint(param1.priority);
			loc2.slot = uint(param1.slot);
			return loc2;
		}
	}
}
