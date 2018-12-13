package com.company.assembleegameclient.objects {
	import com.company.assembleegameclient.map.Map;
	import com.company.util.PointUtil;

	import flash.utils.Dictionary;

	import kabam.rotmg.messaging.impl.incoming.AccountList;

	public class Party {

		public static const NUM_MEMBERS:int = 6;

		private static const SORT_ON_FIELDS:Array = ["starred_", "distSqFromThisPlayer_", "objectId_"];

		private static const SORT_ON_PARAMS:Array = [Array.NUMERIC | Array.DESCENDING, Array.NUMERIC, Array.NUMERIC];

		private static const PARTY_DISTANCE_SQ:int = 50 * 50;


		public var map_:Map;

		public var members_:Array;

		private var starred_:Dictionary;

		private var ignored_:Dictionary;

		private var lastUpdate_:int = -2147483648;

		public function Party(param1:Map) {
			this.members_ = [];
			this.starred_ = new Dictionary(true);
			this.ignored_ = new Dictionary(true);
			super();
			this.map_ = param1;
		}

		public function update(param1:int, param2:int):void {
			var loc4:GameObject = null;
			var loc5:Player = null;
			if (param1 < this.lastUpdate_ + 500) {
				return;
			}
			this.lastUpdate_ = param1;
			this.members_.length = 0;
			var loc3:Player = this.map_.player_;
			if (loc3 == null) {
				return;
			}
			for each(loc4 in this.map_.goDict_) {
				loc5 = loc4 as Player;
				if (!(loc5 == null || loc5 == loc3)) {
					loc5.starred_ = this.starred_[loc5.accountId_] != undefined;
					loc5.ignored_ = this.ignored_[loc5.accountId_] != undefined;
					loc5.distSqFromThisPlayer_ = PointUtil.distanceSquaredXY(loc3.x_, loc3.y_, loc5.x_, loc5.y_);
					if (!(loc5.distSqFromThisPlayer_ > PARTY_DISTANCE_SQ && !loc5.starred_)) {
						this.members_.push(loc5);
					}
				}
			}
			this.members_.sortOn(SORT_ON_FIELDS, SORT_ON_PARAMS);
			if (this.members_.length > NUM_MEMBERS) {
				this.members_.length = NUM_MEMBERS;
			}
		}

		public function lockPlayer(param1:Player):void {
			this.starred_[param1.accountId_] = 1;
			this.lastUpdate_ = int.MIN_VALUE;
			this.map_.gs_.gsc_.editAccountList(0, true, param1.objectId_);
		}

		public function unlockPlayer(param1:Player):void {
			delete this.starred_[param1.accountId_];
			param1.starred_ = false;
			this.lastUpdate_ = int.MIN_VALUE;
			this.map_.gs_.gsc_.editAccountList(0, false, param1.objectId_);
		}

		public function setStars(param1:AccountList):void {
			var loc3:String = null;
			var loc2:int = 0;
			while (loc2 < param1.accountIds_.length) {
				loc3 = param1.accountIds_[loc2];
				this.starred_[loc3] = 1;
				this.lastUpdate_ = int.MIN_VALUE;
				loc2++;
			}
		}

		public function removeStars(param1:AccountList):void {
			var loc3:String = null;
			var loc2:int = 0;
			while (loc2 < param1.accountIds_.length) {
				loc3 = param1.accountIds_[loc2];
				delete this.starred_[loc3];
				this.lastUpdate_ = int.MIN_VALUE;
				loc2++;
			}
		}

		public function ignorePlayer(param1:Player):void {
			this.ignored_[param1.accountId_] = 1;
			this.lastUpdate_ = int.MIN_VALUE;
			this.map_.gs_.gsc_.editAccountList(1, true, param1.objectId_);
		}

		public function unignorePlayer(param1:Player):void {
			delete this.ignored_[param1.accountId_];
			param1.ignored_ = false;
			this.lastUpdate_ = int.MIN_VALUE;
			this.map_.gs_.gsc_.editAccountList(1, false, param1.objectId_);
		}

		public function setIgnores(param1:AccountList):void {
			var loc3:String = null;
			this.ignored_ = new Dictionary(true);
			var loc2:int = 0;
			while (loc2 < param1.accountIds_.length) {
				loc3 = param1.accountIds_[loc2];
				this.ignored_[loc3] = 1;
				this.lastUpdate_ = int.MIN_VALUE;
				loc2++;
			}
		}
	}
}
