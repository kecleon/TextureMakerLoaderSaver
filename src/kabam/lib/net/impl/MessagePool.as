 
package kabam.lib.net.impl {
	public class MessagePool {
		 
		
		public var type:Class;
		
		public var callback:Function;
		
		public var id:int;
		
		private var tail:Message;
		
		private var count:int = 0;
		
		public function MessagePool(param1:int, param2:Class, param3:Function) {
			super();
			this.type = param2;
			this.id = param1;
			this.callback = param3;
		}
		
		public function populate(param1:int) : MessagePool {
			var loc2:Message = null;
			this.count = this.count + param1;
			while(param1--) {
				loc2 = new this.type(this.id,this.callback);
				loc2.pool = this;
				this.tail && (this.tail.next = loc2);
				loc2.prev = this.tail;
				this.tail = loc2;
			}
			return this;
		}
		
		public function require() : Message {
			var loc1:Message = this.tail;
			if(loc1) {
				this.tail = this.tail.prev;
				loc1.prev = null;
				loc1.next = null;
			} else {
				loc1 = new this.type(this.id,this.callback);
				loc1.pool = this;
				this.count++;
			}
			return loc1;
		}
		
		public function getCount() : int {
			return this.count;
		}
		
		function append(param1:Message) : void {
			this.tail && (this.tail.next = param1);
			param1.prev = this.tail;
			this.tail = param1;
		}
		
		public function dispose() : void {
			this.tail = null;
		}
	}
}
