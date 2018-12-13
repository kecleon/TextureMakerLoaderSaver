 
package io.decagames.rotmg.pets.tasks {
	import com.company.util.MoreObjectUtil;
	import io.decagames.rotmg.pets.data.PetsModel;
	import kabam.lib.tasks.BaseTask;
	import kabam.rotmg.account.core.Account;
	import kabam.rotmg.appengine.api.AppEngineClient;
	import robotlegs.bender.framework.api.ILogger;
	
	public class GetOwnedPetSkinsTask extends BaseTask {
		 
		
		[Inject]
		public var account:Account;
		
		[Inject]
		public var client:AppEngineClient;
		
		[Inject]
		public var logger:ILogger;
		
		[Inject]
		public var petModel:PetsModel;
		
		public function GetOwnedPetSkinsTask() {
			super();
		}
		
		override protected function startTask() : void {
			this.logger.info("GetOwnedPetSkinsTask start");
			if(!this.account.isRegistered()) {
				this.logger.info("Guest account - skip skins check");
				completeTask(true,"");
			} else {
				this.client.complete.addOnce(this.onComplete);
				this.client.sendRequest("/account/getOwnedPetSkins",this.makeDataPacket());
			}
		}
		
		private function makeDataPacket() : Object {
			var loc1:Object = {};
			MoreObjectUtil.addToObject(loc1,this.account.getCredentials());
			return loc1;
		}
		
		private function onComplete(param1:Boolean, param2:*) : void {
			var isOK:Boolean = param1;
			var data:* = param2;
			isOK = isOK || data == "<Success/>";
			if(isOK) {
				try {
					this.petModel.parseOwnedSkins(XML(data));
				}
				catch(e:Error) {
					logger.error(e.message + " " + e.getStackTrace());
				}
				this.petModel.parsePetsData();
			}
			completeTask(isOK,data);
		}
	}
}
