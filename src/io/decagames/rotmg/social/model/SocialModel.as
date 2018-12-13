 
package io.decagames.rotmg.social.model {
	import com.company.assembleegameclient.objects.Player;
	import com.company.assembleegameclient.parameters.Parameters;
	import com.company.assembleegameclient.util.FameUtil;
	import com.company.assembleegameclient.util.TimeUtil;
	import flash.utils.Dictionary;
	import io.decagames.rotmg.social.config.FriendsActions;
	import io.decagames.rotmg.social.config.GuildActions;
	import io.decagames.rotmg.social.config.SocialConfig;
	import io.decagames.rotmg.social.signals.SocialDataSignal;
	import io.decagames.rotmg.social.tasks.FriendDataRequestTask;
	import io.decagames.rotmg.social.tasks.GuildDataRequestTask;
	import io.decagames.rotmg.social.tasks.ISocialTask;
	import kabam.lib.tasks.BaseTask;
	import kabam.rotmg.servers.api.Server;
	import kabam.rotmg.servers.api.ServerModel;
	import kabam.rotmg.ui.model.HUDModel;
	import org.osflash.signals.Signal;
	
	public class SocialModel {
		 
		
		[Inject]
		public var hudModel:HUDModel;
		
		[Inject]
		public var serverModel:ServerModel;
		
		[Inject]
		public var friendsDataRequest:FriendDataRequestTask;
		
		[Inject]
		public var guildDataRequest:GuildDataRequestTask;
		
		public var socialDataSignal:SocialDataSignal;
		
		public var noInvitationSignal:Signal;
		
		private var _friendsList:Vector.<FriendVO>;
		
		private var _onlineFriends:Vector.<FriendVO>;
		
		private var _offlineFriends:Vector.<FriendVO>;
		
		private var _onlineFilteredFriends:Vector.<FriendVO>;
		
		private var _offlineFilteredFriends:Vector.<FriendVO>;
		
		private var _onlineGuildMembers:Vector.<GuildMemberVO>;
		
		private var _offlineGuildMembers:Vector.<GuildMemberVO>;
		
		private var _guildMembers:Vector.<GuildMemberVO>;
		
		private var _friends:Dictionary;
		
		private var _invitations:Dictionary;
		
		private var _friendsLoadInProcess:Boolean;
		
		private var _invitationsLoadInProgress:Boolean;
		
		private var _guildLoadInProgress:Boolean;
		
		private var _numberOfFriends:int;
		
		private var _numberOfGuildMembers:int;
		
		private var _numberOfInvitation:int;
		
		private var _isFriDataOK:Boolean;
		
		private var _serverDict:Dictionary;
		
		private var _currentServer:Server;
		
		private var _guildVO:GuildVO;
		
		public function SocialModel() {
			this.socialDataSignal = new SocialDataSignal();
			this.noInvitationSignal = new Signal();
			super();
			this._initSocialModel();
		}
		
		public function setCurrentServer(param1:Server) : void {
			this._currentServer = param1;
		}
		
		public function getCurrentServerName() : String {
			var loc1:String = !!this._currentServer?this._currentServer.name:"";
			return loc1;
		}
		
		public function loadFriendsData() : void {
			if(this._friendsLoadInProcess || this._invitationsLoadInProgress) {
				return;
			}
			this._friendsLoadInProcess = true;
			this._invitationsLoadInProgress = true;
			this.loadList(this.friendsDataRequest,FriendsActions.getURL(FriendsActions.FRIEND_LIST),this.onFriendListResponse);
		}
		
		public function loadInvitations() : void {
			if(this._friendsLoadInProcess || this._invitationsLoadInProgress) {
				return;
			}
			this._invitationsLoadInProgress = true;
			this.loadList(this.friendsDataRequest,FriendsActions.getURL(FriendsActions.INVITE_LIST),this.onInvitationListResponse);
		}
		
		public function loadGuildData() : void {
			if(this._guildLoadInProgress) {
				return;
			}
			this._guildLoadInProgress = true;
			this.loadList(this.guildDataRequest,GuildActions.getURL(GuildActions.GUILD_LIST),this.onGuildListResponse);
		}
		
		public function seedFriends(param1:XML) : void {
			var loc2:String = null;
			var loc3:String = null;
			var loc4:String = null;
			var loc5:FriendVO = null;
			var loc6:XML = null;
			this._onlineFriends.length = 0;
			this._offlineFriends.length = 0;
			for each(loc6 in param1.Account) {
				loc2 = loc6.Name;
				loc5 = this._friends[loc2] != null?this._friends[loc2].vo as FriendVO:new FriendVO(Player.fromPlayerXML(loc2,loc6.Character[0]));
				if(loc6.hasOwnProperty("Online")) {
					loc4 = String(loc6.Online);
					loc3 = this.serverNameDictionary()[loc4];
					loc5.online(loc3,loc4);
					this._onlineFriends.push(loc5);
					this._friends[loc5.getName()] = {
						"vo":loc5,
						"list":this._onlineFriends
					};
				} else {
					loc5.offline();
					loc5.lastLogin = this.getLastLoginInSeconds(loc6.LastLogin);
					this._offlineFriends.push(loc5);
					this._friends[loc5.getName()] = {
						"vo":loc5,
						"list":this._offlineFriends
					};
				}
			}
			this._onlineFriends.sort(this.sortFriend);
			this._offlineFriends.sort(this.sortFriend);
			this.updateFriendsList();
		}
		
		public function isMyFriend(param1:String) : Boolean {
			return this._friends[param1] != null;
		}
		
		public function updateFriendVO(param1:String, param2:Player) : void {
			var loc3:Object = null;
			var loc4:FriendVO = null;
			if(this.isMyFriend(param1)) {
				loc3 = this._friends[param1];
				loc4 = loc3.vo as FriendVO;
				loc4.updatePlayer(param2);
			}
		}
		
		public function getFilterFriends(param1:String) : Vector.<FriendVO> {
			var loc3:FriendVO = null;
			var loc2:RegExp = new RegExp(param1,"gix");
			this._onlineFilteredFriends.length = 0;
			this._offlineFilteredFriends.length = 0;
			var loc4:int = 0;
			while(loc4 < this._onlineFriends.length) {
				loc3 = this._onlineFriends[loc4];
				if(loc3.getName().search(loc2) >= 0) {
					this._onlineFilteredFriends.push(loc3);
				}
				loc4++;
			}
			loc4 = 0;
			while(loc4 < this._offlineFriends.length) {
				loc3 = this._offlineFriends[loc4];
				if(loc3.getName().search(loc2) >= 0) {
					this._offlineFilteredFriends.push(loc3);
				}
				loc4++;
			}
			this._onlineFilteredFriends.sort(this.sortFriend);
			this._offlineFilteredFriends.sort(this.sortFriend);
			return this._onlineFilteredFriends.concat(this._offlineFilteredFriends);
		}
		
		public function ifReachMax() : Boolean {
			return this._numberOfFriends >= SocialConfig.MAX_FRIENDS;
		}
		
		public function getAllInvitations() : Vector.<FriendVO> {
			var loc2:FriendVO = null;
			var loc1:Vector.<FriendVO> = new Vector.<FriendVO>();
			for each(loc2 in this._invitations) {
				loc1.push(loc2);
			}
			loc1.sort(this.sortFriend);
			return loc1;
		}
		
		public function removeFriend(param1:String) : Boolean {
			var loc2:Object = this._friends[param1];
			if(loc2) {
				this.removeFriendFromList(param1);
				this.removeFromList(loc2.list,param1);
				this._friends[param1] = null;
				delete this._friends[param1];
				return true;
			}
			return false;
		}
		
		public function removeInvitation(param1:String) : Boolean {
			if(this._invitations[param1] != null) {
				this._invitations[param1] = null;
				delete this._invitations[param1];
				this._numberOfInvitation--;
				if(this._numberOfInvitation == 0) {
					this.noInvitationSignal.dispatch();
				}
				return true;
			}
			return false;
		}
		
		public function removeGuildMember(param1:String) : void {
			var loc2:GuildMemberVO = null;
			for each(loc2 in this._onlineGuildMembers) {
				if(loc2.name == param1) {
					this._onlineGuildMembers.splice(this._onlineGuildMembers.indexOf(loc2),1);
					break;
				}
			}
			for each(loc2 in this._offlineGuildMembers) {
				if(loc2.name == param1) {
					this._offlineGuildMembers.splice(this._offlineGuildMembers.indexOf(loc2),1);
					break;
				}
			}
			this.updateGuildData();
		}
		
		private function _initSocialModel() : void {
			this._numberOfFriends = 0;
			this._numberOfInvitation = 0;
			this._friends = new Dictionary(true);
			this._onlineFriends = new Vector.<FriendVO>(0);
			this._offlineFriends = new Vector.<FriendVO>(0);
			this._onlineFilteredFriends = new Vector.<FriendVO>(0);
			this._offlineFilteredFriends = new Vector.<FriendVO>(0);
			this._onlineGuildMembers = new Vector.<GuildMemberVO>(0);
			this._offlineGuildMembers = new Vector.<GuildMemberVO>(0);
			this._friendsLoadInProcess = false;
			this._invitationsLoadInProgress = false;
			this._guildLoadInProgress = false;
		}
		
		private function loadList(param1:ISocialTask, param2:String, param3:Function) : void {
			param1.requestURL = param2;
			(param1 as BaseTask).finished.addOnce(param3);
			(param1 as BaseTask).start();
		}
		
		private function onFriendListResponse(param1:FriendDataRequestTask, param2:Boolean, param3:String = "") : void {
			this._isFriDataOK = param2;
			if(this._isFriDataOK) {
				this.seedFriends(param1.xml);
				param1.reset();
				this._friendsLoadInProcess = false;
				this.loadList(this.friendsDataRequest,FriendsActions.getURL(FriendsActions.INVITE_LIST),this.onInvitationListResponse);
			} else {
				this.socialDataSignal.dispatch(SocialDataSignal.FRIENDS_DATA_LOADED,this._isFriDataOK,param3);
			}
		}
		
		private function onInvitationListResponse(param1:FriendDataRequestTask, param2:Boolean, param3:String = "") : void {
			if(param2) {
				this.seedInvitations(param1.xml);
				this.socialDataSignal.dispatch(SocialDataSignal.FRIENDS_DATA_LOADED,this._isFriDataOK,param3);
			} else {
				this.socialDataSignal.dispatch(SocialDataSignal.FRIEND_INVITATIONS_LOADED,param2,param3);
			}
			param1.reset();
			this._invitationsLoadInProgress = false;
		}
		
		private function onGuildListResponse(param1:GuildDataRequestTask, param2:Boolean, param3:String = "") : void {
			if(param2) {
				this.seedGuild(param1.xml);
			} else {
				this.clearGuildData();
			}
			param1.reset();
			this._guildLoadInProgress = false;
			this.socialDataSignal.dispatch(SocialDataSignal.GUILD_DATA_LOADED,param2,param3);
		}
		
		private function seedInvitations(param1:XML) : void {
			var loc2:String = null;
			var loc3:XML = null;
			var loc4:Player = null;
			this._invitations = new Dictionary(true);
			this._numberOfInvitation = 0;
			for each(loc3 in param1.Account) {
				if(this.starFilter(int(loc3.Character[0].ObjectType),int(loc3.Character[0].CurrentFame),loc3.Stats[0])) {
					loc2 = loc3.Name;
					loc4 = Player.fromPlayerXML(loc2,loc3.Character[0]);
					this._invitations[loc2] = new FriendVO(loc4);
					this._numberOfInvitation++;
				}
			}
		}
		
		private function seedGuild(param1:XML) : void {
			var loc3:XML = null;
			var loc4:GuildMemberVO = null;
			var loc5:String = null;
			var loc6:String = null;
			this.clearGuildData();
			this._guildVO = new GuildVO();
			this._guildVO.guildName = param1.@name;
			this._guildVO.guildId = param1.@id;
			this._guildVO.guildTotalFame = param1.TotalFame;
			this._guildVO.guildCurrentFame = param1.CurrentFame.value;
			this._guildVO.guildHallType = param1.HallType;
			var loc2:XMLList = param1.child("Member");
			if(loc2.length() > 0) {
				for each(loc3 in loc2) {
					loc4 = new GuildMemberVO();
					loc5 = loc3.Name;
					if(loc5 == this.hudModel.getPlayerName()) {
						loc4.isMe = true;
						this._guildVO.myRank = loc3.Rank;
					}
					loc4.name = loc5;
					loc4.rank = loc3.Rank;
					loc4.fame = loc3.Fame;
					loc4.player = this.getPlayerObject(loc5,loc3);
					if(loc3.hasOwnProperty("Online")) {
						loc4.isOnline = true;
						loc6 = String(loc3.Online);
						loc4.serverAddress = loc6;
						loc4.serverName = this.serverNameDictionary()[loc6];
						this._onlineGuildMembers.push(loc4);
					} else {
						loc4.lastLogin = this.getLastLoginInSeconds(loc3.LastLogin);
						this._offlineGuildMembers.push(loc4);
					}
				}
			}
			this.updateGuildData();
		}
		
		private function getPlayerObject(param1:String, param2:XML) : Player {
			var loc3:XML = param2.Character[0];
			if(int(loc3.ObjectType) == 0) {
				loc3.ObjectType = "782";
			}
			return Player.fromPlayerXML(param1,loc3);
		}
		
		private function getLastLoginInSeconds(param1:String) : Number {
			var loc2:Date = new Date();
			return (loc2.getTime() - TimeUtil.parseUTCDate(param1).getTime()) / 1000;
		}
		
		private function updateGuildData() : void {
			this._onlineGuildMembers.sort(this.sortGuildMemberByRank);
			this._offlineGuildMembers.sort(this.sortGuildMemberByRank);
			this._onlineGuildMembers.sort(this.sortGuildMemberByAlphabet);
			this._offlineGuildMembers.sort(this.sortGuildMemberByAlphabet);
			this._guildMembers = this._onlineGuildMembers.concat(this._offlineGuildMembers);
			this._numberOfGuildMembers = this._guildMembers.length;
			this._guildVO.guildMembers = this._guildMembers;
		}
		
		private function clearGuildData() : void {
			this._onlineGuildMembers.length = 0;
			this._offlineGuildMembers.length = 0;
			this._guildVO = null;
		}
		
		private function removeFriendFromList(param1:String) : void {
			var loc2:FriendVO = null;
			for each(loc2 in this._onlineFriends) {
				if(loc2.getName() == param1) {
					this._onlineFriends.splice(this._onlineFriends.indexOf(loc2),1);
					break;
				}
			}
			for each(loc2 in this._offlineFriends) {
				if(loc2.getName() == param1) {
					this._offlineFriends.splice(this._offlineFriends.indexOf(loc2),1);
					break;
				}
			}
			this.updateFriendsList();
		}
		
		private function removeFromList(param1:Vector.<FriendVO>, param2:String) : void {
			var loc3:FriendVO = null;
			var loc4:int = 0;
			while(loc4 < param1.length) {
				loc3 = param1[loc4];
				if(loc3.getName() == param2) {
					param1.slice(loc4,1);
					return;
				}
				loc4++;
			}
		}
		
		private function sortFriend(param1:FriendVO, param2:FriendVO) : Number {
			if(param1.getName() < param2.getName()) {
				return -1;
			}
			if(param1.getName() > param2.getName()) {
				return 1;
			}
			return 0;
		}
		
		private function sortGuildMemberByRank(param1:GuildMemberVO, param2:GuildMemberVO) : Number {
			if(param1.rank > param2.rank) {
				return -1;
			}
			if(param1.rank < param2.rank) {
				return 1;
			}
			return 0;
		}
		
		private function sortGuildMemberByAlphabet(param1:GuildMemberVO, param2:GuildMemberVO) : Number {
			if(param1.rank == param2.rank) {
				if(param1.name < param2.name) {
					return -1;
				}
				if(param1.name > param2.name) {
					return 1;
				}
				return 0;
			}
			return 0;
		}
		
		private function serverNameDictionary() : Dictionary {
			var loc2:Server = null;
			if(this._serverDict) {
				return this._serverDict;
			}
			var loc1:Vector.<Server> = this.serverModel.getServers();
			this._serverDict = new Dictionary(true);
			for each(loc2 in loc1) {
				this._serverDict[loc2.address] = loc2.name;
			}
			return this._serverDict;
		}
		
		private function starFilter(param1:int, param2:int, param3:XML) : Boolean {
			return FameUtil.numAllTimeStars(param1,param2,param3) >= Parameters.data_.friendStarRequirement;
		}
		
		private function updateFriendsList() : void {
			this._friendsList = this._onlineFriends.concat(this._offlineFriends);
			this._numberOfFriends = this._friendsList.length;
		}
		
		public function get hasInvitations() : Boolean {
			return this._numberOfInvitation > 0;
		}
		
		public function get guildVO() : GuildVO {
			return this._guildVO;
		}
		
		public function get numberOfFriends() : int {
			return this._numberOfFriends;
		}
		
		public function get friendsList() : Vector.<FriendVO> {
			return this._friendsList;
		}
		
		public function get numberOfGuildMembers() : int {
			return this._numberOfGuildMembers;
		}
	}
}
