 
package kabam.lib.net.impl {
	import kabam.lib.net.api.MessageHandlerProxy;
	import kabam.lib.net.api.MessageMapping;
	import org.swiftsuspenders.Injector;
	
	public class MessageCenterMapping implements MessageMapping {
		 
		
		private const nullHandler:NullHandlerProxy = new NullHandlerProxy();
		
		private var id:int;
		
		private var injector:Injector;
		
		private var messageType:Class;
		
		private var population:int = 1;
		
		private var handler:MessageHandlerProxy;
		
		public function MessageCenterMapping() {
			this.handler = this.nullHandler;
			super();
		}
		
		public function setID(param1:int) : MessageMapping {
			this.id = param1;
			return this;
		}
		
		public function setInjector(param1:Injector) : MessageCenterMapping {
			this.injector = param1;
			return this;
		}
		
		public function toMessage(param1:Class) : MessageMapping {
			this.messageType = param1;
			return this;
		}
		
		public function toHandler(param1:Class) : MessageMapping {
			this.handler = new ClassHandlerProxy().setType(param1).setInjector(this.injector);
			return this;
		}
		
		public function toMethod(param1:Function) : MessageMapping {
			this.handler = new MethodHandlerProxy().setMethod(param1);
			return this;
		}
		
		public function setPopulation(param1:int) : MessageMapping {
			this.population = param1;
			return this;
		}
		
		public function makePool() : MessagePool {
			var loc1:MessagePool = new MessagePool(this.id,this.messageType,this.handler.getMethod());
			loc1.populate(this.population);
			return loc1;
		}
	}
}

import kabam.lib.net.api.MessageHandlerProxy;

class NullHandlerProxy implements MessageHandlerProxy {
	 
	
	function NullHandlerProxy() {
		super();
	}
	
	public function getMethod() : Function {
		return null;
	}
}
