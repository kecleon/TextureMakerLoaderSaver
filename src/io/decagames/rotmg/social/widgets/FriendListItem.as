 
package io.decagames.rotmg.social.widgets {
	import com.company.assembleegameclient.parameters.Parameters;
	import com.company.assembleegameclient.ui.icons.IconButton;
	import com.company.assembleegameclient.util.TimeUtil;
	import flash.events.Event;
	import io.decagames.rotmg.social.data.SocialItemState;
	import io.decagames.rotmg.social.model.FriendVO;
	import kabam.rotmg.text.model.TextKey;
	
	public class FriendListItem extends BaseListItem {
		 
		
		public var teleportButton:IconButton;
		
		public var messageButton:IconButton;
		
		public var removeButton:IconButton;
		
		public var acceptButton:IconButton;
		
		public var rejectButton:IconButton;
		
		public var blockButton:IconButton;
		
		private var _vo:FriendVO;
		
		public function FriendListItem(param1:FriendVO, param2:int) {
			super(param2);
			this._vo = param1;
			this.init();
		}
		
		override protected function init() : void {
			super.init();
			addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved);
			this.setState();
			createListLabel(this._vo.getName());
			createListPortrait(this._vo.getPortrait());
		}
		
		private function onRemoved(param1:Event) : void {
			removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved);
			this.teleportButton && this.teleportButton.destroy();
			this.messageButton && this.messageButton.destroy();
			this.removeButton && this.removeButton.destroy();
			this.acceptButton && this.acceptButton.destroy();
			this.rejectButton && this.rejectButton.destroy();
			this.blockButton && this.blockButton.destroy();
		}
		
		private function setState() : void {
			var loc1:String = null;
			var loc2:String = null;
			var loc3:* = null;
			switch(_state) {
				case SocialItemState.ONLINE:
					loc1 = this._vo.getServerName();
					loc2 = !!Parameters.data_.preferredServer?Parameters.data_.preferredServer:Parameters.data_.bestServer;
					if(loc2 != loc1) {
						loc3 = "Your friend is playing on server: " + loc1 + ". " + "Clicking this will take you to this server.";
						this.teleportButton = addButton("lofiInterface2",3,230,12,TextKey.FRIEND_TELEPORT_TITLE,loc3);
					}
					this.messageButton = addButton("lofiInterfaceBig",21,255,12,TextKey.PLAYERMENU_PM);
					this.removeButton = addButton("lofiInterfaceBig",12,280,12,TextKey.FRIEND_REMOVE_BUTTON);
					break;
				case SocialItemState.OFFLINE:
					hoverTooltipDelegate.setDisplayObject(_characterContainer);
					setToolTipTitle("Last Seen:");
					setToolTipText(TimeUtil.humanReadableTime(this._vo.lastLogin) + " ago!");
					this.removeButton = addButton("lofiInterfaceBig",12,280,12,TextKey.FRIEND_REMOVE_BUTTON,TextKey.FRIEND_REMOVE_BUTTON_DESC);
					break;
				case SocialItemState.INVITE:
					this.acceptButton = addButton("lofiInterfaceBig",11,230,12,TextKey.GUILD_ACCEPT);
					this.rejectButton = addButton("lofiInterfaceBig",12,255,12,TextKey.GUILD_REJECTION);
					this.blockButton = addButton("lofiInterfaceBig",8,280,12,TextKey.FRIEND_BLOCK_BUTTON,TextKey.FRIEND_BLOCK_BUTTON_DESC);
			}
		}
		
		public function get vo() : FriendVO {
			return this._vo;
		}
	}
}
