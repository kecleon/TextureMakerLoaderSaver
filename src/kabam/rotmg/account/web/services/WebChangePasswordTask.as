 
package kabam.rotmg.account.web.services {
	import kabam.lib.tasks.BaseTask;
	import kabam.rotmg.account.core.Account;
	import kabam.rotmg.account.core.services.ChangePasswordTask;
	import kabam.rotmg.account.web.model.ChangePasswordData;
	import kabam.rotmg.appengine.api.AppEngineClient;
	
	public class WebChangePasswordTask extends BaseTask implements ChangePasswordTask {
		 
		
		[Inject]
		public var account:Account;
		
		[Inject]
		public var data:ChangePasswordData;
		
		[Inject]
		public var client:AppEngineClient;
		
		public function WebChangePasswordTask() {
			super();
		}
		
		override protected function startTask() : void {
			this.client.complete.addOnce(this.onComplete);
			this.client.sendRequest("/account/changePassword",this.makeDataPacket());
		}
		
		private function onComplete(param1:Boolean, param2:*) : void {
			param1 && this.onChangeDone();
			completeTask(param1,param2);
		}
		
		private function makeDataPacket() : Object {
			var loc1:Object = {};
			loc1.guid = this.account.getUserId();
			loc1.password = this.data.currentPassword;
			loc1.newPassword = this.data.newPassword;
			return loc1;
		}
		
		private function onChangeDone() : void {
			this.account.updateUser(this.account.getUserId(),this.data.newPassword,this.account.getToken());
			completeTask(true);
		}
	}
}