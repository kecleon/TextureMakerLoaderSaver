package io.decagames.rotmg.pets.commands {
	import io.decagames.rotmg.pets.data.vo.requests.FeedPetRequestVO;
	import io.decagames.rotmg.pets.data.vo.requests.FusePetRequestVO;
	import io.decagames.rotmg.pets.data.vo.requests.IUpgradePetRequestVO;
	import io.decagames.rotmg.pets.data.vo.requests.UpgradePetYardRequestVO;

	import kabam.lib.net.api.MessageProvider;
	import kabam.lib.net.impl.SocketServer;
	import kabam.rotmg.account.core.Account;
	import kabam.rotmg.account.core.view.RegisterPromptDialog;
	import kabam.rotmg.dialogs.control.OpenDialogSignal;
	import kabam.rotmg.messaging.impl.GameServerConnection;
	import kabam.rotmg.messaging.impl.PetUpgradeRequest;

	import robotlegs.bender.bundles.mvcs.Command;

	public class UpgradePetCommand extends Command {

		private static const PET_YARD_REGISTER_STRING:String = "In order to upgradeYard your yard you must be a registered user.";


		[Inject]
		public var vo:IUpgradePetRequestVO;

		[Inject]
		public var messages:MessageProvider;

		[Inject]
		public var server:SocketServer;

		[Inject]
		public var account:Account;

		[Inject]
		public var openDialog:OpenDialogSignal;

		public function UpgradePetCommand() {
			super();
		}

		override public function execute():void {
			var loc1:PetUpgradeRequest = null;
			if (this.vo is UpgradePetYardRequestVO) {
				if (!this.account.isRegistered()) {
					this.showPromptToRegister(PET_YARD_REGISTER_STRING);
				}
				loc1 = this.messages.require(GameServerConnection.PETUPGRADEREQUEST) as PetUpgradeRequest;
				loc1.petTransType = 1;
				loc1.objectId = UpgradePetYardRequestVO(this.vo).objectID;
				loc1.paymentTransType = UpgradePetYardRequestVO(this.vo).paymentTransType;
			}
			if (this.vo is FeedPetRequestVO) {
				loc1 = this.messages.require(GameServerConnection.PETUPGRADEREQUEST) as PetUpgradeRequest;
				loc1.petTransType = 2;
				loc1.PIDOne = FeedPetRequestVO(this.vo).petInstanceId;
				loc1.slotsObject = FeedPetRequestVO(this.vo).slotObjects;
				loc1.paymentTransType = FeedPetRequestVO(this.vo).paymentTransType;
			}
			if (this.vo is FusePetRequestVO) {
				loc1 = this.messages.require(GameServerConnection.PETUPGRADEREQUEST) as PetUpgradeRequest;
				loc1.petTransType = 3;
				loc1.PIDOne = FusePetRequestVO(this.vo).petInstanceIdOne;
				loc1.PIDTwo = FusePetRequestVO(this.vo).petInstanceIdTwo;
				loc1.paymentTransType = FusePetRequestVO(this.vo).paymentTransType;
			}
			if (loc1) {
				this.server.sendMessage(loc1);
			}
		}

		private function showPromptToRegister(param1:String):void {
			this.openDialog.dispatch(new RegisterPromptDialog(param1));
		}
	}
}
