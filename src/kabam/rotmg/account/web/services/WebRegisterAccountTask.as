package kabam.rotmg.account.web.services {
	import kabam.lib.tasks.BaseTask;
	import kabam.rotmg.account.core.Account;
	import kabam.rotmg.account.core.services.RegisterAccountTask;
	import kabam.rotmg.account.web.model.AccountData;
	import kabam.rotmg.appengine.api.AppEngineClient;
	import kabam.rotmg.core.model.PlayerModel;

	public class WebRegisterAccountTask extends BaseTask implements RegisterAccountTask {


		[Inject]
		public var data:AccountData;

		[Inject]
		public var account:Account;

		[Inject]
		public var model:PlayerModel;

		[Inject]
		public var client:AppEngineClient;

		public function WebRegisterAccountTask() {
			super();
		}

		override protected function startTask():void {
			this.client.complete.addOnce(this.onComplete);
			this.client.sendRequest("/account/register", this.makeDataPacket());
		}

		private function makeDataPacket():Object {
			var loc1:Object = {};
			loc1.guid = this.account.getUserId();
			loc1.newGUID = this.data.username;
			loc1.newPassword = this.data.password;
			loc1.entrytag = this.account.getEntryTag();
			loc1.signedUpKabamEmail = this.data.signedUpKabamEmail;
			loc1.isAgeVerified = 1;
			return loc1;
		}

		private function onComplete(param1:Boolean, param2:*):void {
			param1 && this.onRegisterDone(param2);
			completeTask(param1, param2);
		}

		private function onRegisterDone(param1:String):void {
			this.model.setIsAgeVerified(true);
			var loc2:XML = new XML(param1);
			if (loc2.hasOwnProperty("token")) {
				this.data.token = loc2.token;
				this.account.updateUser(this.data.username, this.data.password, loc2.token);
			} else {
				this.account.updateUser(this.data.username, this.data.password, "");
			}
		}
	}
}
