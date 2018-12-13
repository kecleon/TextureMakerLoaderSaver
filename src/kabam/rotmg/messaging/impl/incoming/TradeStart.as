package kabam.rotmg.messaging.impl.incoming {
	import com.company.assembleegameclient.util.FreeList;

	import flash.utils.IDataInput;

	import kabam.rotmg.messaging.impl.data.TradeItem;

	public class TradeStart extends IncomingMessage {


		public var myItems_:Vector.<TradeItem>;

		public var yourName_:String;

		public var yourItems_:Vector.<TradeItem>;

		public function TradeStart(param1:uint, param2:Function) {
			this.myItems_ = new Vector.<TradeItem>();
			this.yourItems_ = new Vector.<TradeItem>();
			super(param1, param2);
		}

		override public function parseFromInput(param1:IDataInput):void {
			var loc2:int = 0;
			var loc3:int = param1.readShort();
			loc2 = loc3;
			while (loc2 < this.myItems_.length) {
				FreeList.deleteObject(this.myItems_[loc2]);
				loc2++;
			}
			this.myItems_.length = Math.min(loc3, this.myItems_.length);
			while (this.myItems_.length < loc3) {
				this.myItems_.push(FreeList.newObject(TradeItem) as TradeItem);
			}
			loc2 = 0;
			while (loc2 < loc3) {
				this.myItems_[loc2].parseFromInput(param1);
				loc2++;
			}
			this.yourName_ = param1.readUTF();
			loc3 = param1.readShort();
			loc2 = loc3;
			while (loc2 < this.yourItems_.length) {
				FreeList.deleteObject(this.yourItems_[loc2]);
				loc2++;
			}
			this.yourItems_.length = Math.min(loc3, this.yourItems_.length);
			while (this.yourItems_.length < loc3) {
				this.yourItems_.push(FreeList.newObject(TradeItem) as TradeItem);
			}
			loc2 = 0;
			while (loc2 < loc3) {
				this.yourItems_[loc2].parseFromInput(param1);
				loc2++;
			}
		}

		override public function toString():String {
			return formatToString("TRADESTART", "myItems_", "yourName_", "yourItems_");
		}
	}
}
