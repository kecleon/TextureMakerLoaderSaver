 
package io.decagames.rotmg.pets.commands {
	import com.company.assembleegameclient.editor.Command;
	import io.decagames.rotmg.pets.utils.PetsConstants;
	import kabam.lib.net.api.MessageProvider;
	import kabam.lib.net.impl.SocketServer;
	import kabam.rotmg.messaging.impl.GameServerConnection;
	import kabam.rotmg.messaging.impl.outgoing.ActivePetUpdateRequest;
	
	public class ReleasePetCommand extends Command {
		 
		
		[Inject]
		public var messages:MessageProvider;
		
		[Inject]
		public var server:SocketServer;
		
		[Inject]
		public var instanceID:int;
		
		public function ReleasePetCommand() {
			super();
		}
		
		override public function execute() : void {
			var loc1:ActivePetUpdateRequest = this.messages.require(GameServerConnection.ACTIVE_PET_UPDATE_REQUEST) as ActivePetUpdateRequest;
			loc1.instanceid = this.instanceID;
			loc1.commandtype = PetsConstants.RELEASE;
			this.server.sendMessage(loc1);
		}
	}
}
