 
package kabam.rotmg.messaging.impl.incoming {
	import flash.utils.IDataInput;
	
	public class TradeAccepted extends IncomingMessage {
		 
		
		public var myOffer_:Vector.<Boolean>;
		
		public var yourOffer_:Vector.<Boolean>;
		
		public function TradeAccepted(param1:uint, param2:Function) {
			this.myOffer_ = new Vector.<Boolean>();
			this.yourOffer_ = new Vector.<Boolean>();
			super(param1,param2);
		}
		
		override public function parseFromInput(param1:IDataInput) : void {
			var loc2:int = 0;
			this.myOffer_.length = 0;
			var loc3:int = param1.readShort();
			loc2 = 0;
			while(loc2 < loc3) {
				this.myOffer_.push(param1.readBoolean());
				loc2++;
			}
			this.yourOffer_.length = 0;
			loc3 = param1.readShort();
			loc2 = 0;
			while(loc2 < loc3) {
				this.yourOffer_.push(param1.readBoolean());
				loc2++;
			}
		}
		
		override public function toString() : String {
			return formatToString("TRADEACCEPTED","myOffer_","yourOffer_");
		}
	}
}
