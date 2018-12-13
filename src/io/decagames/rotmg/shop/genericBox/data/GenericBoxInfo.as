package io.decagames.rotmg.shop.genericBox.data {
	import com.company.assembleegameclient.util.TimeUtil;

	import io.decagames.rotmg.utils.date.TimeLeft;

	import org.osflash.signals.Signal;

	public class GenericBoxInfo {


		protected var _id:String;

		protected var _title:String;

		protected var _description:String;

		protected var _weight:String;

		protected var _contents:String;

		protected var _priceAmount:int;

		protected var _priceCurrency:int;

		protected var _saleAmount:int;

		protected var _saleCurrency:int;

		protected var _quantity:int;

		protected var _saleEnd:Date;

		protected var _startTime:Date;

		protected var _endTime:Date;

		protected var _unitsLeft:int = -1;

		protected var _totalUnits:int = -1;

		protected var _slot:int = 0;

		protected var _tags:String = "";

		public const updateSignal:Signal = new Signal();

		public function GenericBoxInfo() {
			super();
		}

		public function get id():String {
			return this._id;
		}

		public function set id(param1:String):void {
			this._id = param1;
		}

		public function get title():String {
			return this._title;
		}

		public function set title(param1:String):void {
			this._title = param1;
		}

		public function get description():String {
			return this._description;
		}

		public function set description(param1:String):void {
			this._description = param1;
		}

		public function get weight():String {
			return this._weight;
		}

		public function set weight(param1:String):void {
			this._weight = param1;
		}

		public function get contents():String {
			return this._contents;
		}

		public function set contents(param1:String):void {
			this._contents = param1;
		}

		public function get priceAmount():int {
			return this._priceAmount;
		}

		public function set priceAmount(param1:int):void {
			this._priceAmount = param1;
		}

		public function get priceCurrency():int {
			return this._priceCurrency;
		}

		public function set priceCurrency(param1:int):void {
			this._priceCurrency = param1;
		}

		public function get saleAmount():int {
			return this._saleAmount;
		}

		public function set saleAmount(param1:int):void {
			this._saleAmount = param1;
		}

		public function get saleCurrency():int {
			return this._saleCurrency;
		}

		public function set saleCurrency(param1:int):void {
			this._saleCurrency = param1;
		}

		public function get quantity():int {
			return this._quantity;
		}

		public function set quantity(param1:int):void {
			this._quantity = param1;
		}

		public function get saleEnd():Date {
			return this._saleEnd;
		}

		public function set saleEnd(param1:Date):void {
			this._saleEnd = param1;
		}

		public function get startTime():Date {
			return this._startTime;
		}

		public function set startTime(param1:Date):void {
			this._startTime = param1;
		}

		public function get endTime():Date {
			return this._endTime;
		}

		public function set endTime(param1:Date):void {
			this._endTime = param1;
		}

		public function get unitsLeft():int {
			return this._unitsLeft;
		}

		public function set unitsLeft(param1:int):void {
			this._unitsLeft = param1;
			this.updateSignal.dispatch();
		}

		public function get totalUnits():int {
			return this._totalUnits;
		}

		public function set totalUnits(param1:int):void {
			this._totalUnits = param1;
		}

		public function get slot():int {
			return this._slot;
		}

		public function set slot(param1:int):void {
			this._slot = param1;
		}

		public function get tags():String {
			return this._tags;
		}

		public function set tags(param1:String):void {
			this._tags = param1;
		}

		public function getSecondsToEnd():Number {
			if (!this._endTime) {
				return int.MAX_VALUE;
			}
			var loc1:Date = new Date();
			return (this._endTime.time - loc1.time) / 1000;
		}

		public function getSecondsToStart():Number {
			var loc1:Date = new Date();
			return (this._startTime.time - loc1.time) / 1000;
		}

		public function isOnSale():Boolean {
			var loc1:Date = null;
			if (this._saleAmount > 0 && this._saleEnd) {
				loc1 = new Date();
				return loc1.time < this._saleEnd.time;
			}
			return false;
		}

		public function isNew():Boolean {
			var loc1:Date = new Date();
			if (this._startTime.time > loc1.time) {
				return false;
			}
			return Math.ceil(TimeUtil.secondsToDays((loc1.time - this._startTime.time) / 1000)) <= 1;
		}

		public function getStartTimeString():String {
			var loc1:String = "Available in: ";
			var loc2:Number = this.getSecondsToStart();
			if (loc2 <= 0) {
				return "";
			}
			if (loc2 > TimeUtil.DAY_IN_S) {
				loc1 = loc1 + TimeLeft.parse(loc2, "%dd %hh");
			} else if (loc2 > TimeUtil.HOUR_IN_S) {
				loc1 = loc1 + TimeLeft.parse(loc2, "%hh %mm");
			} else {
				loc1 = loc1 + TimeLeft.parse(loc2, "%mm %ss");
			}
			return loc1;
		}

		public function getEndTimeString():String {
			if (!this._endTime) {
				return "";
			}
			var loc1:String = "Ends in: ";
			var loc2:Number = this.getSecondsToEnd();
			if (loc2 <= 0) {
				return "";
			}
			if (loc2 > TimeUtil.DAY_IN_S) {
				loc1 = loc1 + TimeLeft.parse(loc2, "%dd %hh");
			} else if (loc2 > TimeUtil.HOUR_IN_S) {
				loc1 = loc1 + TimeLeft.parse(loc2, "%hh %mm");
			} else {
				loc1 = loc1 + TimeLeft.parse(loc2, "%mm %ss");
			}
			return loc1;
		}
	}
}
