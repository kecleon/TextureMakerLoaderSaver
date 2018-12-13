 
package kabam.rotmg.account.core.services {
	import kabam.lib.tasks.BaseTask;
	import kabam.rotmg.account.core.Account;
	import kabam.rotmg.appengine.api.AppEngineClient;
	import kabam.rotmg.core.model.PlayerModel;
	import kabam.rotmg.dialogs.control.OpenDialogSignal;
	
	public class BuyCharacterSlotTask extends BaseTask {
		 
		
		[Inject]
		public var account:Account;
		
		[Inject]
		public var price:int;
		
		[Inject]
		public var client:AppEngineClient;
		
		[Inject]
		public var openDialog:OpenDialogSignal;
		
		[Inject]
		public var model:PlayerModel;
		
		public function BuyCharacterSlotTask() {
			super();
		}
		
		override protected function startTask() : void {
			this.client.setMaxRetries(2);
			this.client.complete.addOnce(this.onComplete);
			this.client.sendRequest("/account/purchaseCharSlot",this.account.getCredentials());
		}
		
		private function onComplete(param1:Boolean, param2:*) : void {
			param1 && this.updatePlayerData();
			completeTask(param1,param2);
		}
		
		private function updatePlayerData() : void {
			this.model.setMaxCharacters(this.model.getMaxCharacters() + 1);
			this.model.changeCredits(-this.price);
		}
	}
}
