package kabam.rotmg.account.core.services {
	import com.company.assembleegameclient.util.offer.Offers;

	import flash.utils.getTimer;

	import kabam.lib.tasks.BaseTask;
	import kabam.rotmg.account.core.Account;
	import kabam.rotmg.account.core.model.OfferModel;
	import kabam.rotmg.appengine.api.AppEngineClient;

	import robotlegs.bender.framework.api.ILogger;

	public class GetOffersTask extends BaseTask {


		[Inject]
		public var account:Account;

		[Inject]
		public var model:OfferModel;

		[Inject]
		public var logger:ILogger;

		[Inject]
		public var client:AppEngineClient;

		private var target:String;

		private var guid:String;

		public function GetOffersTask() {
			super();
		}

		override protected function startTask():void {
			this.target = this.account.getRequestPrefix() + "/getoffers";
			this.guid = this.account.getUserId();
			this.updateModelRequestTimeAndGUID();
			this.sendGetOffersRequest();
		}

		private function updateModelRequestTimeAndGUID():void {
			var loc1:int = getTimer();
			if (this.guid != this.model.lastOfferRequestGUID || loc1 - this.model.lastOfferRequestTime > OfferModel.TIME_BETWEEN_REQS) {
				this.model.lastOfferRequestGUID = this.guid;
				this.model.lastOfferRequestTime = loc1;
			}
		}

		private function sendGetOffersRequest():void {
			this.client.setMaxRetries(2);
			this.client.complete.addOnce(this.onComplete);
			this.client.sendRequest(this.target, this.makeRequestDataPacket());
		}

		private function makeRequestDataPacket():Object {
			var loc1:Object = this.account.getCredentials();
			loc1.time = this.model.lastOfferRequestTime;
			loc1.game_net_user_id = this.account.gameNetworkUserId();
			loc1.game_net = this.account.gameNetwork();
			loc1.play_platform = this.account.playPlatform();
			return loc1;
		}

		private function onComplete(param1:Boolean, param2:*):void {
			if (param1) {
				this.onDataResponse(param2);
			} else {
				this.onTextError(param2);
			}
			completeTask(param1);
		}

		private function onDataResponse(param1:String):void {
			this.model.offers = new Offers(new XML(param1));
		}

		private function onTextError(param1:String):void {
			this.logger.error(param1);
		}
	}
}
