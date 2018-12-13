 
package kabam.rotmg.account.web.services {
	import kabam.lib.tasks.BaseTask;
	import kabam.rotmg.account.core.services.SendPasswordReminderTask;
	import kabam.rotmg.appengine.api.AppEngineClient;
	import kabam.rotmg.core.service.TrackingData;
	import kabam.rotmg.core.signals.TrackEventSignal;
	
	public class WebSendPasswordReminderTask extends BaseTask implements SendPasswordReminderTask {
		 
		
		[Inject]
		public var email:String;
		
		[Inject]
		public var track:TrackEventSignal;
		
		[Inject]
		public var client:AppEngineClient;
		
		public function WebSendPasswordReminderTask() {
			super();
		}
		
		override protected function startTask() : void {
			this.client.complete.addOnce(this.onComplete);
			this.client.sendRequest("/account/forgotPassword",{"guid":this.email});
		}
		
		private function onComplete(param1:Boolean, param2:*) : void {
			if(param1) {
				this.onForgotDone();
			} else {
				this.onForgotError(param2);
			}
		}
		
		private function onForgotDone() : void {
			this.trackPasswordReminder();
			completeTask(true);
		}
		
		private function trackPasswordReminder() : void {
			var loc1:TrackingData = new TrackingData();
			loc1.category = "account";
			loc1.action = "passwordSent";
		}
		
		private function onForgotError(param1:String) : void {
			completeTask(false,param1);
		}
	}
}
