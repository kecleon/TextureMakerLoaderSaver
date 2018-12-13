package kabam.rotmg.game.commands {
	import com.company.assembleegameclient.appengine.SavedCharacter;
	import com.company.assembleegameclient.game.GameSprite;
	import com.company.assembleegameclient.parameters.Parameters;

	import flash.utils.ByteArray;

	import io.decagames.rotmg.pets.data.PetsModel;

	import kabam.lib.net.impl.SocketServerModel;
	import kabam.lib.tasks.TaskMonitor;
	import kabam.rotmg.account.core.services.GetCharListTask;
	import kabam.rotmg.core.model.PlayerModel;
	import kabam.rotmg.core.signals.SetScreenSignal;
	import kabam.rotmg.game.model.GameInitData;
	import kabam.rotmg.servers.api.Server;
	import kabam.rotmg.servers.api.ServerModel;

	public class PlayGameCommand {

		public static const RECONNECT_DELAY:int = 2000;


		[Inject]
		public var setScreen:SetScreenSignal;

		[Inject]
		public var data:GameInitData;

		[Inject]
		public var model:PlayerModel;

		[Inject]
		public var petsModel:PetsModel;

		[Inject]
		public var servers:ServerModel;

		[Inject]
		public var task:GetCharListTask;

		[Inject]
		public var monitor:TaskMonitor;

		[Inject]
		public var socketServerModel:SocketServerModel;

		public function PlayGameCommand() {
			super();
		}

		public function execute():void {
			if (!this.data.isNewGame) {
				this.socketServerModel.connectDelayMS = PlayGameCommand.RECONNECT_DELAY;
			}
			this.recordCharacterUseInSharedObject();
			this.makeGameView();
			this.updatePet();
		}

		private function updatePet():void {
			var loc1:SavedCharacter = this.model.getCharacterById(this.model.currentCharId);
			if (loc1) {
				this.petsModel.setActivePet(loc1.getPetVO());
			} else {
				if (this.model.currentCharId && this.petsModel.getActivePet() && !this.data.isNewGame) {
					return;
				}
				this.petsModel.setActivePet(null);
			}
		}

		private function recordCharacterUseInSharedObject():void {
			Parameters.data_.charIdUseMap[this.data.charId] = new Date().getTime();
			Parameters.save();
		}

		private function makeGameView():void {
			var loc1:Server = this.data.server || this.servers.getServer();
			var loc2:int = !!this.data.isNewGame ? int(this.getInitialGameId()) : int(this.data.gameId);
			var loc3:Boolean = this.data.createCharacter;
			var loc4:int = this.data.charId;
			var loc5:int = !!this.data.isNewGame ? -1 : int(this.data.keyTime);
			var loc6:ByteArray = this.data.key;
			this.model.currentCharId = loc4;
			this.setScreen.dispatch(new GameSprite(loc1, loc2, loc3, loc4, loc5, loc6, this.model, null, this.data.isFromArena));
		}

		private function getInitialGameId():int {
			var loc1:int = 0;
			if (Parameters.data_.needsTutorial) {
				loc1 = Parameters.TUTORIAL_GAMEID;
			} else if (Parameters.data_.needsRandomRealm) {
				loc1 = Parameters.RANDOM_REALM_GAMEID;
			} else {
				loc1 = Parameters.NEXUS_GAMEID;
			}
			return loc1;
		}
	}
}
