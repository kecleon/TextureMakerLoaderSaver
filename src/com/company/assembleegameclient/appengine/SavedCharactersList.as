 
package com.company.assembleegameclient.appengine {
	import com.company.assembleegameclient.objects.ObjectLibrary;
	import com.company.assembleegameclient.objects.Player;
	import flash.events.Event;
	import io.decagames.rotmg.tos.popups.ToSPopup;
	import io.decagames.rotmg.ui.popups.signals.ShowPopupSignal;
	import kabam.rotmg.account.core.Account;
	import kabam.rotmg.core.StaticInjectorContext;
	import kabam.rotmg.promotions.model.BeginnersPackageModel;
	import kabam.rotmg.servers.api.LatLong;
	import org.swiftsuspenders.Injector;
	
	public class SavedCharactersList extends Event {
		
		public static const SAVED_CHARS_LIST:String = "SAVED_CHARS_LIST";
		
		public static const AVAILABLE:String = "available";
		
		public static const UNAVAILABLE:String = "unavailable";
		
		public static const UNRESTRICTED:String = "unrestricted";
		
		private static const DEFAULT_LATLONG:LatLong = new LatLong(37.4436,-122.412);
		
		private static const DEFAULT_SALESFORCE:String = "unavailable";
		 
		
		private var origData_:String;
		
		private var charsXML_:XML;
		
		public var accountId_:String;
		
		public var nextCharId_:int;
		
		public var maxNumChars_:int;
		
		public var numChars_:int = 0;
		
		public var savedChars_:Vector.<SavedCharacter>;
		
		public var charStats_:Object;
		
		public var totalFame_:int = 0;
		
		public var bestCharFame_:int = 0;
		
		public var fame_:int = 0;
		
		public var credits_:int = 0;
		
		public var tokens_:int = 0;
		
		public var numStars_:int = 0;
		
		public var nextCharSlotPrice_:int;
		
		public var guildName_:String;
		
		public var guildRank_:int;
		
		public var name_:String = null;
		
		public var nameChosen_:Boolean;
		
		public var converted_:Boolean;
		
		public var isAdmin_:Boolean;
		
		public var canMapEdit_:Boolean;
		
		public var news_:Vector.<SavedNewsItem>;
		
		public var myPos_:LatLong;
		
		public var salesForceData_:String = "unavailable";
		
		public var hasPlayerDied:Boolean = false;
		
		public var classAvailability:Object;
		
		public var isAgeVerified:Boolean;
		
		private var account:Account;
		
		public function SavedCharactersList(param1:String) {
			var loc4:* = undefined;
			var loc5:Account = null;
			this.savedChars_ = new Vector.<SavedCharacter>();
			this.charStats_ = {};
			this.news_ = new Vector.<SavedNewsItem>();
			super(SAVED_CHARS_LIST);
			this.origData_ = param1;
			this.charsXML_ = new XML(this.origData_);
			var loc2:XML = XML(this.charsXML_.Account);
			this.parseUserData(loc2);
			this.parseBeginnersPackageData(loc2);
			this.parseGuildData(loc2);
			this.parseCharacterData();
			this.parseCharacterStatsData();
			this.parseNewsData();
			this.parseGeoPositioningData();
			this.parseSalesForceData();
			this.parseTOSPopup();
			this.reportUnlocked();
			var loc3:Injector = StaticInjectorContext.getInjector();
			if(loc3) {
				loc5 = loc3.getInstance(Account);
				loc5.reportIntStat("BestLevel",this.bestOverallLevel());
				loc5.reportIntStat("BestFame",this.bestOverallFame());
				loc5.reportIntStat("NumStars",this.numStars_);
				loc5.verify(loc2.hasOwnProperty("VerifiedEmail"));
			}
			this.classAvailability = new Object();
			for each(loc4 in this.charsXML_.ClassAvailabilityList.ClassAvailability) {
				this.classAvailability[loc4.@id.toString()] = loc4.toString();
			}
		}
		
		public function getCharById(param1:int) : SavedCharacter {
			var loc2:SavedCharacter = null;
			for each(loc2 in this.savedChars_) {
				if(loc2.charId() == param1) {
					return loc2;
				}
			}
			return null;
		}
		
		private function parseUserData(param1:XML) : void {
			this.accountId_ = param1.AccountId;
			this.name_ = param1.Name;
			this.nameChosen_ = param1.hasOwnProperty("NameChosen");
			this.converted_ = param1.hasOwnProperty("Converted");
			this.isAdmin_ = param1.hasOwnProperty("Admin");
			Player.isAdmin = this.isAdmin_;
			Player.isMod = param1.hasOwnProperty("Mod");
			this.canMapEdit_ = param1.hasOwnProperty("MapEditor");
			this.totalFame_ = int(param1.Stats.TotalFame);
			this.bestCharFame_ = int(param1.Stats.BestCharFame);
			this.fame_ = int(param1.Stats.Fame);
			this.credits_ = int(param1.Credits);
			this.tokens_ = int(param1.FortuneToken);
			this.nextCharSlotPrice_ = int(param1.NextCharSlotPrice);
			this.isAgeVerified = this.accountId_ != "" && param1.IsAgeVerified == 1;
			this.hasPlayerDied = true;
		}
		
		private function parseBeginnersPackageData(param1:XML) : void {
			var loc2:int = 0;
			var loc3:BeginnersPackageModel = null;
			if(param1.hasOwnProperty("BeginnerPackageStatus")) {
				loc2 = param1.BeginnerPackageStatus;
				loc3 = this.getBeginnerModel();
				loc3.status = loc2;
			}
		}
		
		private function getBeginnerModel() : BeginnersPackageModel {
			var loc1:Injector = StaticInjectorContext.getInjector();
			var loc2:BeginnersPackageModel = loc1.getInstance(BeginnersPackageModel);
			return loc2;
		}
		
		private function parseGuildData(param1:XML) : void {
			var loc2:XML = null;
			if(param1.hasOwnProperty("Guild")) {
				loc2 = XML(param1.Guild);
				this.guildName_ = loc2.Name;
				this.guildRank_ = int(loc2.Rank);
			}
		}
		
		private function parseCharacterData() : void {
			var loc1:XML = null;
			this.nextCharId_ = int(this.charsXML_.@nextCharId);
			this.maxNumChars_ = int(this.charsXML_.@maxNumChars);
			for each(loc1 in this.charsXML_.Char) {
				this.savedChars_.push(new SavedCharacter(loc1,this.name_));
				this.numChars_++;
			}
			this.savedChars_.sort(SavedCharacter.compare);
		}
		
		private function parseCharacterStatsData() : void {
			var loc2:XML = null;
			var loc3:int = 0;
			var loc4:CharacterStats = null;
			var loc1:XML = XML(this.charsXML_.Account.Stats);
			for each(loc2 in loc1.ClassStats) {
				loc3 = int(loc2.@objectType);
				loc4 = new CharacterStats(loc2);
				this.numStars_ = this.numStars_ + loc4.numStars();
				this.charStats_[loc3] = loc4;
			}
		}
		
		private function parseNewsData() : void {
			var loc2:XML = null;
			var loc1:XML = XML(this.charsXML_.News);
			for each(loc2 in loc1.Item) {
				this.news_.push(new SavedNewsItem(loc2.Icon,loc2.Title,loc2.TagLine,loc2.Link,int(loc2.Date)));
			}
		}
		
		private function parseGeoPositioningData() : void {
			if(this.charsXML_.hasOwnProperty("Lat") && this.charsXML_.hasOwnProperty("Long")) {
				this.myPos_ = new LatLong(Number(this.charsXML_.Lat),Number(this.charsXML_.Long));
			} else {
				this.myPos_ = DEFAULT_LATLONG;
			}
		}
		
		private function parseSalesForceData() : void {
			if(this.charsXML_.hasOwnProperty("SalesForce") && this.charsXML_.hasOwnProperty("SalesForce")) {
				this.salesForceData_ = String(this.charsXML_.SalesForce);
			}
		}
		
		private function parseTOSPopup() : void {
			if(this.charsXML_.hasOwnProperty("TOSPopup")) {
				StaticInjectorContext.getInjector().getInstance(ShowPopupSignal).dispatch(new ToSPopup());
			}
		}
		
		public function isFirstTimeLogin() : Boolean {
			return !this.charsXML_.hasOwnProperty("TOSPopup");
		}
		
		public function bestLevel(param1:int) : int {
			var loc2:CharacterStats = this.charStats_[param1];
			return loc2 == null?0:int(loc2.bestLevel());
		}
		
		public function bestOverallLevel() : int {
			var loc2:CharacterStats = null;
			var loc1:int = 0;
			for each(loc2 in this.charStats_) {
				if(loc2.bestLevel() > loc1) {
					loc1 = loc2.bestLevel();
				}
			}
			return loc1;
		}
		
		public function bestFame(param1:int) : int {
			var loc2:CharacterStats = this.charStats_[param1];
			return loc2 == null?0:int(loc2.bestFame());
		}
		
		public function bestOverallFame() : int {
			var loc2:CharacterStats = null;
			var loc1:int = 0;
			for each(loc2 in this.charStats_) {
				if(loc2.bestFame() > loc1) {
					loc1 = loc2.bestFame();
				}
			}
			return loc1;
		}
		
		public function levelRequirementsMet(param1:int) : Boolean {
			var loc3:XML = null;
			var loc4:int = 0;
			var loc2:XML = ObjectLibrary.xmlLibrary_[param1];
			for each(loc3 in loc2.UnlockLevel) {
				loc4 = ObjectLibrary.idToType_[loc3.toString()];
				if(this.bestLevel(loc4) < int(loc3.@level)) {
					return false;
				}
			}
			return true;
		}
		
		public function availableCharSlots() : int {
			return this.maxNumChars_ - this.numChars_;
		}
		
		public function hasAvailableCharSlot() : Boolean {
			return this.numChars_ < this.maxNumChars_;
		}
		
		public function newUnlocks(param1:int, param2:int) : Array {
			var loc5:XML = null;
			var loc6:int = 0;
			var loc7:Boolean = false;
			var loc8:Boolean = false;
			var loc9:XML = null;
			var loc10:int = 0;
			var loc11:int = 0;
			var loc3:Array = new Array();
			var loc4:int = 0;
			while(loc4 < ObjectLibrary.playerChars_.length) {
				loc5 = ObjectLibrary.playerChars_[loc4];
				loc6 = int(loc5.@type);
				if(!this.levelRequirementsMet(loc6)) {
					loc7 = true;
					loc8 = false;
					for each(loc9 in loc5.UnlockLevel) {
						loc10 = ObjectLibrary.idToType_[loc9.toString()];
						loc11 = int(loc9.@level);
						if(this.bestLevel(loc10) < loc11) {
							if(loc10 != param1 || loc11 != param2) {
								loc7 = false;
								break;
							}
							loc8 = true;
						}
					}
					if(loc7 && loc8) {
						loc3.push(loc6);
					}
				}
				loc4++;
			}
			return loc3;
		}
		
		override public function clone() : Event {
			return new SavedCharactersList(this.origData_);
		}
		
		override public function toString() : String {
			return "[" + " numChars: " + this.numChars_ + " maxNumChars: " + this.maxNumChars_ + " ]";
		}
		
		private function reportUnlocked() : void {
			var loc1:Injector = StaticInjectorContext.getInjector();
			if(loc1) {
				this.account = loc1.getInstance(Account);
				this.account && this.updateAccount();
			}
		}
		
		private function updateAccount() : void {
			var loc3:XML = null;
			var loc4:int = 0;
			var loc1:int = 0;
			var loc2:int = 0;
			while(loc2 < ObjectLibrary.playerChars_.length) {
				loc3 = ObjectLibrary.playerChars_[loc2];
				loc4 = int(loc3.@type);
				if(this.levelRequirementsMet(loc4)) {
					this.account.reportIntStat(loc3.@id + "Unlocked",1);
					loc1++;
				}
				loc2++;
			}
			this.account.reportIntStat("ClassesUnlocked",loc1);
		}
	}
}
