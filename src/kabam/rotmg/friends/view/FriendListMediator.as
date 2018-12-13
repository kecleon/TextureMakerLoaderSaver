package kabam.rotmg.friends.view {
	import com.company.assembleegameclient.appengine.SavedCharacter;
	import com.company.assembleegameclient.parameters.Parameters;
	import com.company.assembleegameclient.ui.dialogs.ErrorDialog;

	import io.decagames.rotmg.social.config.FriendsActions;
	import io.decagames.rotmg.social.model.FriendRequestVO;
	import io.decagames.rotmg.social.model.SocialModel;
	import io.decagames.rotmg.social.signals.FriendActionSignal;

	import kabam.rotmg.chat.control.ShowChatInputSignal;
	import kabam.rotmg.core.model.PlayerModel;
	import kabam.rotmg.dialogs.control.CloseDialogsSignal;
	import kabam.rotmg.dialogs.control.OpenDialogSignal;
	import kabam.rotmg.game.model.GameInitData;
	import kabam.rotmg.game.signals.PlayGameSignal;
	import kabam.rotmg.text.model.TextKey;
	import kabam.rotmg.ui.signals.EnterGameSignal;

	import robotlegs.bender.bundles.mvcs.Mediator;

	public class FriendListMediator extends Mediator {


		[Inject]
		public var view:FriendListView;

		[Inject]
		public var model:SocialModel;

		[Inject]
		public var openDialog:OpenDialogSignal;

		[Inject]
		public var closeDialog:CloseDialogsSignal;

		[Inject]
		public var actionSignal:FriendActionSignal;

		[Inject]
		public var chatSignal:ShowChatInputSignal;

		[Inject]
		public var enterGame:EnterGameSignal;

		[Inject]
		public var playerModel:PlayerModel;

		[Inject]
		public var playGame:PlayGameSignal;

		public function FriendListMediator() {
			super();
		}

		override public function initialize():void {
			this.view.actionSignal.add(this.onFriendActed);
			this.view.tabSignal.add(this.onTabSwitched);
			this.model.socialDataSignal.add(this.initView);
			this.model.loadFriendsData();
		}

		override public function destroy():void {
			this.view.actionSignal.removeAll();
			this.view.tabSignal.removeAll();
		}

		private function initView(param1:Boolean = false):void {
			if (param1) {
				this.view.init(this.model.friendsList, this.model.getAllInvitations(), this.model.getCurrentServerName());
			}
		}

		private function reportError(param1:String):void {
			this.openDialog.dispatch(new ErrorDialog(param1));
		}

		private function onTabSwitched(param1:String):void {
			switch (param1) {
				case FriendsActions.FRIEND_TAB:
					this.view.updateFriendTab(this.model.friendsList, this.model.getCurrentServerName());
					break;
				case FriendsActions.INVITE_TAB:
					this.view.updateInvitationTab(this.model.getAllInvitations());
			}
		}

		private function onFriendActed(param1:String, param2:String):void {
			var loc4:String = null;
			var loc5:String = null;
			var loc3:FriendRequestVO = new FriendRequestVO(param1, param2);
			switch (param1) {
				case FriendsActions.SEARCH:
					if (param2 != null && param2 != "") {
						this.view.updateFriendTab(this.model.getFilterFriends(param2), this.model.getCurrentServerName());
					} else if (param2 == "") {
						this.view.updateFriendTab(this.model.friendsList, this.model.getCurrentServerName());
					}
					return;
				case FriendsActions.INVITE:
					if (this.model.ifReachMax()) {
						this.view.updateInput(TextKey.FRIEND_REACH_CAPACITY);
						return;
					}
					loc3.callback = this.inviteFriendCallback;
					break;
				case FriendsActions.REMOVE:
					loc3.callback = this.removeFriendCallback;
					loc4 = TextKey.FRIEND_REMOVE_TITLE;
					loc5 = TextKey.FRIEND_REMOVE_TEXT;
					this.openDialog.dispatch(new FriendUpdateConfirmDialog(loc4, loc5, TextKey.FRAME_CANCEL, TextKey.FRIEND_REMOVE_BUTTON, loc3, {"name": loc3.target}));
					return;
				case FriendsActions.ACCEPT:
					loc3.callback = this.acceptInvitationCallback;
					break;
				case FriendsActions.REJECT:
					loc3.callback = this.rejectInvitationCallback;
					break;
				case FriendsActions.BLOCK:
					loc3.callback = this.blockInvitationCallback;
					loc4 = TextKey.FRIEND_BLOCK_TITLE;
					loc5 = TextKey.FRIEND_BLOCK_TEXT;
					this.openDialog.dispatch(new FriendUpdateConfirmDialog(loc4, loc5, TextKey.FRAME_CANCEL, TextKey.FRIEND_BLOCK_BUTTON, loc3, {"name": loc3.target}));
					return;
				case FriendsActions.WHISPER:
					this.whisperCallback(param2);
					return;
				case FriendsActions.JUMP:
					this.jumpCallback(param2);
					return;
			}
			this.actionSignal.dispatch(loc3);
		}

		private function inviteFriendCallback(param1:Boolean, param2:String, param3:String):void {
			if (param1) {
				this.view.updateInput(TextKey.FRIEND_SENT_INVITATION_TEXT, {"name": param3});
			} else if (param2 == "Blocked") {
				this.view.updateInput(TextKey.FRIEND_SENT_INVITATION_TEXT, {"name": param3});
			} else {
				this.view.updateInput(param2);
			}
		}

		private function removeFriendCallback(param1:Boolean, param2:String, param3:String):void {
			if (param1) {
				this.model.removeFriend(param3);
			} else {
				this.reportError(param2);
			}
		}

		private function acceptInvitationCallback(param1:Boolean, param2:String, param3:String):void {
			if (param1) {
				this.model.seedFriends(XML(param2));
				if (this.model.removeInvitation(param3)) {
					this.view.updateInvitationTab(this.model.getAllInvitations());
				}
			} else {
				this.reportError(param2);
			}
		}

		private function rejectInvitationCallback(param1:Boolean, param2:String, param3:String):void {
			if (param1) {
				if (this.model.removeInvitation(param3)) {
					this.view.updateInvitationTab(this.model.getAllInvitations());
				}
			} else {
				this.reportError(param2);
			}
		}

		private function blockInvitationCallback(param1:String):void {
			this.model.removeInvitation(param1);
		}

		private function whisperCallback(param1:String):void {
			this.chatSignal.dispatch(true, "/tell " + param1 + " ");
			this.view.getCloseSignal().dispatch();
		}

		private function jumpCallback(param1:String):void {
			Parameters.data_.preferredServer = param1;
			Parameters.save();
			this.enterGame.dispatch();
			var loc2:SavedCharacter = this.playerModel.getCharacterById(this.playerModel.currentCharId);
			var loc3:GameInitData = new GameInitData();
			loc3.createCharacter = false;
			loc3.charId = loc2.charId();
			loc3.isNewGame = true;
			this.playGame.dispatch(loc3);
			this.closeDialog.dispatch();
		}
	}
}
