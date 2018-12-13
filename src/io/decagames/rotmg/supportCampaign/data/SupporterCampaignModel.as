package io.decagames.rotmg.supportCampaign.data {
	import com.company.assembleegameclient.util.TimeUtil;

	import io.decagames.rotmg.supportCampaign.data.vo.RankVO;
	import io.decagames.rotmg.supportCampaign.signals.UpdateCampaignProgress;
	import io.decagames.rotmg.utils.date.TimeLeft;

	import kabam.rotmg.core.StaticInjectorContext;

	public class SupporterCampaignModel {

		public static const DEFAULT_DONATE_AMOUNT:int = 100;

		public static const DEFAULT_DONATE_SPINNER_STEP:int = 100;

		public static const DONATE_MAX_INPUT_CHARS:int = 5;

		public static const SUPPORT_COLOR:Number = 13395711;

		public static const RANKS_NAMES:Array = ["Basic", "Greater", "Superior", "Paramount", "Exalted", "Unbound"];


		private var _unlockPrice:int;

		private var _points:int;

		private var _rank:int;

		private var _tempRank:int;

		private var _donatePointsRatio:int;

		private var _shopPurchasePointsRatio:int;

		private var _endDate:Date;

		private var _startDate:Date;

		private var _ranks:Array;

		private var _isUnlocked:Boolean;

		private var _hasValidData:Boolean;

		private var _claimed:int;

		private var _rankConfig:Vector.<RankVO>;

		public function SupporterCampaignModel() {
			super();
		}

		public function parseConfigData(param1:XML):void {
			this._hasValidData = true;
			if (param1.hasOwnProperty("CampaignConfig")) {
				this.parseConfig(param1);
			} else {
				this._hasValidData = false;
			}
			if (param1.hasOwnProperty("CampaignProgress")) {
				this.parseUpdateData(param1.CampaignProgress, false);
			}
		}

		public function updatePoints(param1:int):void {
			this._points = param1;
			this._rank = this.getRankByPoints(this._points);
			StaticInjectorContext.getInjector().getInstance(UpdateCampaignProgress).dispatch();
		}

		public function getRankByPoints(param1:int):int {
			var loc3:int = 0;
			if (!this.hasValidData) {
				return 0;
			}
			var loc2:int = 0;
			if (this._ranks != null && this._ranks.length > 0) {
				loc3 = 0;
				while (loc3 < this._ranks.length) {
					if (param1 >= this._ranks[loc3]) {
						loc2 = loc3 + 1;
					}
					loc3++;
				}
			}
			return loc2;
		}

		public function get rankConfig():Vector.<RankVO> {
			return this._rankConfig;
		}

		public function parseUpdateData(param1:Object, param2:Boolean = true):void {
			this._isUnlocked = int(this.getXMLData(param1, "Unlocked", false)) === 1;
			this._points = int(this.getXMLData(param1, "Points", false));
			this._rank = int(this.getXMLData(param1, "Rank", false));
			if (this._tempRank == 0) {
				this._tempRank = this._rank;
			}
			this._claimed = int(this.getXMLData(param1, "Claimed", false));
			if (param2) {
				StaticInjectorContext.getInjector().getInstance(UpdateCampaignProgress).dispatch();
			}
		}

		private function parseConfig(param1:XML):void {
			this._unlockPrice = int(this.getXMLData(param1.CampaignConfig, "UnlockPrice", true));
			this._donatePointsRatio = int(this.getXMLData(param1.CampaignConfig, "DonatePointsRatio", true));
			this._endDate = new Date(int(this.getXMLData(param1.CampaignConfig, "CampaignEndDate", true)) * 1000);
			this._startDate = new Date(int(this.getXMLData(param1.CampaignConfig, "CampaignStartDate", true)) * 1000);
			this._ranks = this.getXMLData(param1.CampaignConfig, "RanksList", true).split(",");
			this._shopPurchasePointsRatio = int(this.getXMLData(param1.CampaignConfig, "ShopPurchasePointsRatio", true));
			this._rankConfig = new Vector.<RankVO>();
			var loc2:int = 0;
			while (loc2 < this._ranks.length) {
				this._rankConfig.push(new RankVO(this._ranks[loc2], SupporterCampaignModel.RANKS_NAMES[loc2]));
				loc2++;
			}
		}

		private function parseConfigStatus(param1:XML):void {
			this._isUnlocked = int(this.getXMLData(param1.CampaignProgress, "Unlocked", false)) === 1;
			this._points = int(this.getXMLData(param1.CampaignProgress, "Points", false));
			this._rank = int(this.getXMLData(param1.CampaignProgress, "Rank", false));
			this._claimed = int(this.getXMLData(param1, "Claimed", false));
		}

		private function getXMLData(param1:Object, param2:String, param3:Boolean):String {
			if (param1.hasOwnProperty(param2)) {
				return String(param1[param2]);
			}
			if (param3) {
				this._hasValidData = false;
			}
			return "";
		}

		public function get isStarted():Boolean {
			return new Date().time >= this._startDate.time;
		}

		public function get isEnded():Boolean {
			return new Date().time >= this._endDate.time;
		}

		public function get isActive():Boolean {
			return this.isStarted && !this.isEnded;
		}

		public function get nextClaimableTier():int {
			var loc2:String = null;
			if (this._ranks.length == 0) {
				return 1;
			}
			var loc1:int = 1;
			for each(loc2 in this._ranks) {
				if (this._rank >= loc1 && this._claimed < loc1) {
					return loc1;
				}
				loc1++;
			}
			return this._rank;
		}

		public function getStartTimeString():String {
			var loc1:String = "";
			var loc2:Number = this.getSecondsToStart();
			if (loc2 <= 0) {
				return "";
			}
			if (loc2 > TimeUtil.DAY_IN_S) {
				loc1 = loc1 + TimeLeft.parse(loc2, "%dd %hh");
			} else if (loc2 > TimeUtil.HOUR_IN_S) {
				loc1 = loc1 + TimeLeft.parse(loc2, "%hh %mm");
			} else if (loc2 > TimeUtil.MIN_IN_S) {
				loc1 = loc1 + TimeLeft.parse(loc2, "%mm %ss");
			} else {
				loc1 = loc1 + TimeLeft.parse(loc2, "%ss");
			}
			return loc1;
		}

		private function getSecondsToStart():Number {
			var loc1:Date = new Date();
			return (this._startDate.time - loc1.time) / 1000;
		}

		public function get unlockPrice():int {
			return this._unlockPrice;
		}

		public function get donatePointsRatio():int {
			return this._donatePointsRatio;
		}

		public function get shopPurchasePointsRatio():int {
			return this._shopPurchasePointsRatio;
		}

		public function get ranks():Array {
			return this._ranks;
		}

		public function get isUnlocked():Boolean {
			return this._isUnlocked;
		}

		public function get hasValidData():Boolean {
			return this._hasValidData;
		}

		public function get endDate():Date {
			return this._endDate;
		}

		public function get points():int {
			return this._points;
		}

		public function get rank():int {
			return this._rank;
		}

		public function get claimed():int {
			return this._claimed;
		}

		public function get tempRank():int {
			return this._tempRank;
		}

		public function set tempRank(param1:int):void {
			this._tempRank = param1;
		}

		public function get startDate():Date {
			return this._startDate;
		}
	}
}
