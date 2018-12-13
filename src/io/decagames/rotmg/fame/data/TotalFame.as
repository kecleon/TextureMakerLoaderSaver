package io.decagames.rotmg.fame.data {
	import flash.utils.Dictionary;

	import io.decagames.rotmg.fame.data.bonus.FameBonus;

	public class TotalFame {


		private var _bonuses:Vector.<FameBonus>;

		private var _baseFame:Number;

		private var _currentFame:Number;

		public function TotalFame(param1:Number) {
			this._bonuses = new Vector.<FameBonus>();
			super();
			this._baseFame = param1;
			this._currentFame = param1;
		}

		public function addBonus(param1:FameBonus):void {
			if (param1 != null) {
				this._bonuses.push(param1);
				this._currentFame = this._currentFame + param1.fameAdded;
			}
		}

		public function get bonuses():Dictionary {
			var loc2:FameBonus = null;
			var loc1:Dictionary = new Dictionary();
			for each(loc2 in this._bonuses) {
				loc1[loc2.id] = loc2;
			}
			return loc1;
		}

		public function get baseFame():int {
			return this._baseFame;
		}

		public function get currentFame():int {
			return this._currentFame;
		}
	}
}
