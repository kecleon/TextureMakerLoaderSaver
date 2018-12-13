 
package io.decagames.rotmg.characterMetrics.tracker {
	import com.hurlant.util.Base64;
	import flash.utils.Dictionary;
	import flash.utils.IDataInput;
	import io.decagames.rotmg.characterMetrics.data.CharacterMetricsData;
	
	public class CharactersMetricsTracker {
		
		public static const STATS_SIZE:int = 5;
		 
		
		private var charactersStats:Dictionary;
		
		private var _lastUpdate:Date;
		
		public function CharactersMetricsTracker() {
			super();
		}
		
		public function setBinaryStringData(param1:int, param2:String) : void {
			var loc3:RegExp = /-/g;
			var loc4:RegExp = /_/g;
			var loc5:int = 4 - param2.length % 4;
			while(loc5--) {
				param2 = param2 + "=";
			}
			param2 = param2.replace(loc3,"+").replace(loc4,"/");
			this.setBinaryData(param1,Base64.decodeToByteArray(param2));
		}
		
		public function setBinaryData(param1:int, param2:IDataInput) : void {
			var loc3:int = 0;
			var loc4:int = 0;
			if(!this.charactersStats) {
				this.charactersStats = new Dictionary();
			}
			if(!this.charactersStats[param1]) {
				this.charactersStats[param1] = new CharacterMetricsData();
			}
			while(param2.bytesAvailable >= STATS_SIZE) {
				loc3 = param2.readByte();
				loc4 = param2.readInt();
				this.charactersStats[param1].setStat(loc3,loc4);
			}
			this._lastUpdate = new Date();
		}
		
		public function get lastUpdate() : Date {
			return this._lastUpdate;
		}
		
		public function getCharacterStat(param1:int, param2:int) : int {
			if(!this.charactersStats) {
				this.charactersStats = new Dictionary();
			}
			if(!this.charactersStats[param1]) {
				return 0;
			}
			return this.charactersStats[param1].getStat(param2);
		}
		
		public function parseCharListData(param1:XML) : void {
			var loc2:XML = null;
			for each(loc2 in param1.Char) {
				this.setBinaryStringData(int(loc2.@id),loc2.PCStats);
			}
		}
	}
}
