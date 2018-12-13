 
package kabam.rotmg.legends.model {
	public class LegendsModel {
		 
		
		private var timespan:Timespan;
		
		private const map:Object = {};
		
		public function LegendsModel() {
			this.timespan = Timespan.WEEK;
			super();
		}
		
		public function getTimespan() : Timespan {
			return this.timespan;
		}
		
		public function setTimespan(param1:Timespan) : void {
			this.timespan = param1;
		}
		
		public function hasLegendList() : Boolean {
			return this.map[this.timespan.getId()] != null;
		}
		
		public function getLegendList() : Vector.<Legend> {
			return this.map[this.timespan.getId()];
		}
		
		public function setLegendList(param1:Vector.<Legend>) : void {
			this.map[this.timespan.getId()] = param1;
		}
		
		public function clear() : void {
			var loc1:* = null;
			for(loc1 in this.map) {
				this.dispose(this.map[loc1]);
				delete this.map[loc1];
			}
		}
		
		private function dispose(param1:Vector.<Legend>) : void {
			var loc2:Legend = null;
			for each(loc2 in param1) {
				loc2.character && this.removeLegendCharacter(loc2);
			}
		}
		
		private function removeLegendCharacter(param1:Legend) : void {
			param1.character.dispose();
			param1.character = null;
		}
	}
}
