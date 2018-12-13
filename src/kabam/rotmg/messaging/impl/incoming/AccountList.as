 
package kabam.rotmg.messaging.impl.incoming {
	import flash.utils.IDataInput;
	
	public class AccountList extends IncomingMessage {
		 
		
		public var accountListId_:int;
		
		public var accountIds_:Vector.<String>;
		
		public var lockAction_:int = -1;
		
		public function AccountList(param1:uint, param2:Function) {
			this.accountIds_ = new Vector.<String>();
			super(param1,param2);
		}
		
		override public function parseFromInput(param1:IDataInput) : void {
			var loc2:int = 0;
			this.accountListId_ = param1.readInt();
			this.accountIds_.length = 0;
			var loc3:int = param1.readShort();
			loc2 = 0;
			while(loc2 < loc3) {
				this.accountIds_.push(param1.readUTF());
				loc2++;
			}
			this.lockAction_ = param1.readInt();
		}
		
		override public function toString() : String {
			return formatToString("ACCOUNTLIST","accountListId_","accountIds_","lockAction_");
		}
	}
}
