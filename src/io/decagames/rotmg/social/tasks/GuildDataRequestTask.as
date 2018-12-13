package io.decagames.rotmg.social.tasks {
	import kabam.lib.tasks.BaseTask;
	import kabam.rotmg.account.core.Account;
	import kabam.rotmg.appengine.api.AppEngineClient;

	public class GuildDataRequestTask extends BaseTask implements ISocialTask {


		[Inject]
		public var client:AppEngineClient;

		[Inject]
		public var account:Account;

		private var _requestURL:String;

		private var _xml:XML;

		public function GuildDataRequestTask() {
			super();
		}

		override protected function startTask():void {
			this.client.setMaxRetries(8);
			this.client.complete.addOnce(this.onComplete);
			this.client.sendRequest(this._requestURL, this.account.getCredentials());
		}

		private function onComplete(param1:Boolean, param2:*):void {
			if (param1) {
				this._xml = new XML(param2);
				completeTask(true);
			} else {
				completeTask(false, param2);
			}
		}

		public function get requestURL():String {
			return this._requestURL;
		}

		public function set requestURL(param1:String):void {
			this._requestURL = param1;
		}

		public function get xml():XML {
			return this._xml;
		}

		public function set xml(param1:XML):void {
			this._xml = param1;
		}
	}
}
