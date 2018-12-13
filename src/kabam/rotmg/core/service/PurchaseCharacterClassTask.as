 
package kabam.rotmg.core.service {
	import com.company.assembleegameclient.appengine.SavedCharactersList;
	import com.company.assembleegameclient.parameters.Parameters;
	import com.company.util.MoreObjectUtil;
	import kabam.lib.tasks.BaseTask;
	import kabam.rotmg.account.core.Account;
	import kabam.rotmg.appengine.api.AppEngineClient;
	import kabam.rotmg.core.model.PlayerModel;
	import robotlegs.bender.framework.api.ILogger;
	
	public class PurchaseCharacterClassTask extends BaseTask {
		 
		
		[Inject]
		public var classType:int;
		
		[Inject]
		public var account:Account;
		
		[Inject]
		public var client:AppEngineClient;
		
		[Inject]
		public var playerModel:PlayerModel;
		
		[Inject]
		public var logger:ILogger;
		
		public function PurchaseCharacterClassTask() {
			super();
		}
		
		override protected function startTask() : void {
			this.logger.info("PurchaseCharacterClassTask.startTask: Started ");
			this.client.complete.addOnce(this.onComplete);
			this.client.sendRequest("/char/purchaseClassUnlock",this.makeRequestPacket());
		}
		
		public function makeRequestPacket() : Object {
			var loc1:Object = {};
			loc1.game_net_user_id = this.account.gameNetworkUserId();
			loc1.game_net = this.account.gameNetwork();
			loc1.play_platform = this.account.playPlatform();
			loc1.do_login = Parameters.sendLogin_;
			loc1.classType = this.classType;
			MoreObjectUtil.addToObject(loc1,this.account.getCredentials());
			return loc1;
		}
		
		private function onComplete(param1:Boolean, param2:*) : void {
			this.logger.info("PurchaseCharacterClassTask.onComplete: Ended ");
			param1 && this.onReceiveResponseFromClassPurchase();
			completeTask(param1,param2);
		}
		
		private function onReceiveResponseFromClassPurchase() : void {
			this.playerModel.setClassAvailability(this.classType,SavedCharactersList.UNRESTRICTED);
			completeTask(true);
		}
	}
}
