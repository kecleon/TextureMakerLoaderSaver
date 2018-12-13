package io.decagames.rotmg.social {
	import com.company.assembleegameclient.ui.tooltip.TextToolTip;

	import flash.events.KeyboardEvent;

	import io.decagames.rotmg.social.config.SocialConfig;
	import io.decagames.rotmg.social.data.SocialItemState;
	import io.decagames.rotmg.social.model.FriendVO;
	import io.decagames.rotmg.social.model.GuildMemberVO;
	import io.decagames.rotmg.social.model.GuildVO;
	import io.decagames.rotmg.social.model.SocialModel;
	import io.decagames.rotmg.social.popups.InviteFriendPopup;
	import io.decagames.rotmg.social.signals.RefreshListSignal;
	import io.decagames.rotmg.social.signals.SocialDataSignal;
	import io.decagames.rotmg.social.widgets.FriendListItem;
	import io.decagames.rotmg.social.widgets.GuildInfoItem;
	import io.decagames.rotmg.social.widgets.GuildListItem;
	import io.decagames.rotmg.ui.buttons.BaseButton;
	import io.decagames.rotmg.ui.buttons.SliceScalingButton;
	import io.decagames.rotmg.ui.popups.header.PopupHeader;
	import io.decagames.rotmg.ui.popups.signals.ClosePopupSignal;
	import io.decagames.rotmg.ui.popups.signals.ShowPopupSignal;
	import io.decagames.rotmg.ui.texture.TextureParser;

	import kabam.rotmg.core.signals.HideTooltipsSignal;
	import kabam.rotmg.core.signals.ShowTooltipSignal;
	import kabam.rotmg.tooltips.HoverTooltipDelegate;
	import kabam.rotmg.ui.model.HUDModel;

	import robotlegs.bender.bundles.mvcs.Mediator;

	public class SocialPopupMediator extends Mediator {


		[Inject]
		public var view:SocialPopupView;

		[Inject]
		public var closePopupSignal:ClosePopupSignal;

		[Inject]
		public var showTooltipSignal:ShowTooltipSignal;

		[Inject]
		public var hideTooltipSignal:HideTooltipsSignal;

		[Inject]
		public var hudModel:HUDModel;

		[Inject]
		public var socialModel:SocialModel;

		[Inject]
		public var refreshSignal:RefreshListSignal;

		[Inject]
		public var showPopupSignal:ShowPopupSignal;

		private var _isFriendsListLoaded:Boolean;

		private var _isGuildListLoaded:Boolean;

		private var closeButton:SliceScalingButton;

		private var addFriendToolTip:TextToolTip;

		private var hoverTooltipDelegate:HoverTooltipDelegate;

		public function SocialPopupMediator() {
			super();
		}

		override public function initialize():void {
			this.socialModel.socialDataSignal.add(this.onDataLoaded);
			this.view.tabs.tabSelectedSignal.add(this.onTabSelected);
			this.refreshSignal.add(this.refreshListHandler);
			this.closeButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI", "close_button"));
			this.closeButton.clickSignal.addOnce(this.onClose);
			this.view.header.addButton(this.closeButton, PopupHeader.RIGHT_BUTTON);
			this.view.addButton.clickSignal.add(this.addButtonHandler);
			this.createAddButtonTooltip();
			this.view.search.addEventListener(KeyboardEvent.KEY_UP, this.onSearchHandler);
		}

		private function onTabSelected(param1:String):void {
			if (param1 == SocialPopupView.FRIEND_TAB_LABEL) {
				if (!this._isFriendsListLoaded) {
					this.socialModel.loadFriendsData();
				}
			} else if (param1 == SocialPopupView.GUILD_TAB_LABEL) {
				if (!this._isGuildListLoaded) {
					this.socialModel.loadGuildData();
				}
			}
		}

		private function onDataLoaded(param1:String, param2:Boolean, param3:String):void {
			switch (param1) {
				case SocialDataSignal.FRIENDS_DATA_LOADED:
					this.view.clearFriendsList();
					if (param2) {
						this.showFriends();
						this._isFriendsListLoaded = true;
					} else {
						this._isFriendsListLoaded = false;
						this.showError(param1, param3);
					}
					break;
				case SocialDataSignal.GUILD_DATA_LOADED:
					this.view.clearGuildList();
					this.showGuild();
					this._isGuildListLoaded = true;
			}
		}

		private function createAddButtonTooltip():void {
			this.addFriendToolTip = new TextToolTip(3552822, 10197915, "Add a friend", "Click to add a friend", 200);
			this.hoverTooltipDelegate = new HoverTooltipDelegate();
			this.hoverTooltipDelegate.setShowToolTipSignal(this.showTooltipSignal);
			this.hoverTooltipDelegate.setHideToolTipsSignal(this.hideTooltipSignal);
			this.hoverTooltipDelegate.setDisplayObject(this.view.addButton);
			this.hoverTooltipDelegate.tooltip = this.addFriendToolTip;
		}

		private function addButtonHandler(param1:BaseButton):void {
			this.showPopupSignal.dispatch(new InviteFriendPopup());
		}

		private function refreshListHandler(param1:String, param2:Boolean):void {
			if (param1 == RefreshListSignal.CONTEXT_FRIENDS_LIST) {
				this.view.search.reset();
				this.view.clearFriendsList();
				this.showFriends();
			} else if (param1 == RefreshListSignal.CONTEXT_GUILD_LIST) {
				this.view.clearGuildList();
				this.showGuild();
			}
		}

		private function onSearchHandler(param1:KeyboardEvent):void {
			this.view.clearFriendsList();
			this.showFriends(this.view.search.text);
		}

		override public function destroy():void {
			this.closeButton.dispose();
			this.refreshSignal.remove(this.refreshListHandler);
			this.view.addButton.clickSignal.remove(this.addButtonHandler);
			this.view.search.removeEventListener(KeyboardEvent.KEY_UP, this.onSearchHandler);
			this.addFriendToolTip = null;
			this.hoverTooltipDelegate.removeDisplayObject();
			this.hoverTooltipDelegate = null;
		}

		private function onClose(param1:BaseButton):void {
			this.closePopupSignal.dispatch(this.view);
		}

		private function showFriends(param1:String = ""):void {
			var loc3:Vector.<FriendVO> = null;
			var loc4:FriendVO = null;
			var loc5:Vector.<FriendVO> = null;
			var loc6:int = 0;
			var loc7:int = 0;
			var loc8:int = 0;
			var loc2:* = param1 != "";
			if (this.socialModel.hasInvitations) {
				loc5 = this.socialModel.getAllInvitations();
				this.view.addFriendCategory("Invitations (" + loc5.length + ")");
				loc6 = loc5.length > SocialPopupView.MAX_VISIBLE_INVITATIONS ? int(SocialPopupView.MAX_VISIBLE_INVITATIONS) : int(loc5.length);
				loc7 = 0;
				while (loc7 < loc6) {
					this.view.addInvites(new FriendListItem(loc5[loc7], SocialItemState.INVITE));
					loc7++;
				}
				this.view.showInviteIndicator(true, SocialPopupView.FRIEND_TAB_LABEL);
			} else {
				this.view.showInviteIndicator(false, SocialPopupView.FRIEND_TAB_LABEL);
			}
			loc3 = !!loc2 ? this.socialModel.getFilterFriends(param1) : this.socialModel.friendsList;
			this.view.addFriendCategory("Friends (" + this.socialModel.numberOfFriends + "/" + SocialConfig.MAX_FRIENDS + ")");
			for each(loc4 in loc3) {
				loc8 = !!loc4.isOnline ? int(SocialItemState.ONLINE) : int(SocialItemState.OFFLINE);
				this.view.addFriend(new FriendListItem(loc4, loc8));
			}
			this.view.addFriendCategory("");
		}

		private function showError(param1:String, param2:String):void {
			switch (param1) {
				case SocialDataSignal.FRIENDS_DATA_LOADED:
					this.view.addFriendCategory("Error: " + param2);
					break;
				case SocialDataSignal.FRIEND_INVITATIONS_LOADED:
					this.view.addFriendCategory("Invitation Error: " + param2);
			}
		}

		private function showGuild():void {
			var loc4:Vector.<GuildMemberVO> = null;
			var loc5:int = 0;
			var loc6:int = 0;
			var loc7:GuildMemberVO = null;
			var loc8:int = 0;
			var loc1:GuildVO = this.socialModel.guildVO;
			var loc2:String = !!loc1 ? loc1.guildName : "No Guild";
			var loc3:int = !!loc1 ? int(loc1.guildTotalFame) : 0;
			this.view.addGuildInfo(new GuildInfoItem(loc2, loc3));
			if (loc1 && this.socialModel.numberOfGuildMembers > 0) {
				this.view.addGuildCategory("Guild Members (" + this.socialModel.numberOfGuildMembers + "/" + 50 + ")");
				loc4 = loc1.guildMembers;
				loc5 = loc4.length;
				loc6 = 0;
				while (loc6 < loc5) {
					loc7 = loc4[loc6];
					loc8 = !!loc7.isOnline ? int(SocialItemState.ONLINE) : int(SocialItemState.OFFLINE);
					this.view.addGuildMember(new GuildListItem(loc7, loc8, loc1.myRank));
					loc6++;
				}
				this.view.addGuildCategory("");
			} else {
				this.view.addGuildDefaultMessage(SocialPopupView.DEFAULT_NO_GUILD_MESSAGE);
			}
		}
	}
}
