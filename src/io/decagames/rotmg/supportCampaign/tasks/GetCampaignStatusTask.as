package io.decagames.rotmg.supportCampaign.tasks {
	import io.decagames.rotmg.supportCampaign.data.SupporterCampaignModel;

	import kabam.lib.tasks.BaseTask;
	import kabam.rotmg.account.core.Account;
	import kabam.rotmg.appengine.api.AppEngineClient;

	import robotlegs.bender.framework.api.ILogger;

	public class GetCampaignStatusTask extends BaseTask {


		[Inject]
		public var client:AppEngineClient;

		[Inject]
		public var account:Account;

		[Inject]
		public var logger:ILogger;

		[Inject]
		public var model:SupporterCampaignModel;

		public function GetCampaignStatusTask() {
			super();
		}

		override protected function startTask():void {
			this.logger.info("GetCampaignStatus start");
			var loc1:Object = this.account.getCredentials();
			this.client.complete.addOnce(this.onComplete);
			this.client.sendRequest("/supportCampaign/status", loc1);
		}

		private function onComplete(param1:Boolean, param2:*):void {
			if (param1) {
				this.onCampaignUpdate(param2);
			} else {
				this.onTextError(param2);
			}
		}

		private function onTextError(param1:String):void {
			this.logger.info("GetCampaignStatus error");
			completeTask(true);
		}

		private function onCampaignUpdate(param1:String):void {
			var xmlData:XML = null;
			var data:String = param1;
			try {
				xmlData = new XML(data);
			}
			catch (e:Error) {
				logger.error("Error parsing campaign data: " + data);
				completeTask(true);
				return;
			}
			this.logger.info("GetCampaignStatus update");
			this.logger.info(xmlData);
			this.model.parseConfigData(xmlData);
			completeTask(true);
		}
	}
}
