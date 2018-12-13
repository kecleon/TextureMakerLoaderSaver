 
package kabam.rotmg.protip.model {
	public class EmbeddedProTipModel implements IProTipModel {
		
		public static var protipsXML:Class = EmbeddedProTipModel_protipsXML;
		 
		
		private var tips:Vector.<String>;
		
		private var indices:Vector.<int>;
		
		private var index:int;
		
		private var count:int;
		
		public function EmbeddedProTipModel() {
			super();
			this.index = 0;
			this.makeTipsVector();
			this.count = this.tips.length;
			this.makeRandomizedIndexVector();
		}
		
		public function getTip() : String {
			var loc1:int = this.indices[this.index++ % this.count];
			return this.tips[loc1];
		}
		
		private function makeTipsVector() : void {
			var loc2:XML = null;
			var loc1:XML = XML(new protipsXML());
			this.tips = new Vector.<String>(0);
			for each(loc2 in loc1.Protip) {
				this.tips.push(loc2.toString());
			}
			this.count = this.tips.length;
		}
		
		private function makeRandomizedIndexVector() : void {
			var loc1:Vector.<int> = new Vector.<int>(0);
			var loc2:int = 0;
			while(loc2 < this.count) {
				loc1.push(loc2);
				loc2++;
			}
			this.indices = new Vector.<int>(0);
			while(loc2 > 0) {
				this.indices.push(loc1.splice(Math.floor(Math.random() * loc2--),1)[0]);
			}
			this.indices.fixed = true;
		}
	}
}
