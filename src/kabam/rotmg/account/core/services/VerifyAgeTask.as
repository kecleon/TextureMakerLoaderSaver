 
package kabam.rotmg.account.core.services {
	import kabam.lib.tasks.BaseTask;
	import kabam.rotmg.account.core.Account;
	import kabam.rotmg.appengine.api.AppEngineClient;
	import kabam.rotmg.core.model.PlayerModel;
	
	public class VerifyAgeTask extends BaseTask {
		 
		
		[Inject]
		public var account:Account;
		
		[Inject]
		public var playerModel:PlayerModel;
		
		[Inject]
		public var client:AppEngineClient;
		
		public function VerifyAgeTask() {
			super();
		}
		
		override protected function startTask() : void {
			if(this.account.isRegistered()) {
				this.sendVerifyToServer();
			} else {
				this.verifyUserAge();
			}
		}
		
		private function sendVerifyToServer() : void {
			this.client.complete.addOnce(this.onComplete);
			this.client.sendRequest("/account/verifyage",this.makeDataPacket());
		}
		
		private function makeDataPacket() : Object {
			var loc1:Object = this.account.getCredentials();
			loc1.isAgeVerified = 1;
			return loc1;
		}
		
		private function onComplete(param1:Boolean, param2:*) : void {
			param1 && this.verifyUserAge();
			completeTask(param1,param2);
		}
		
		private function verifyUserAge() : void {
			this.playerModel.setIsAgeVerified(true);
			completeTask(true);
		}
	}
}
