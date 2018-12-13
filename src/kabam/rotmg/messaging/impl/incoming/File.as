 
package kabam.rotmg.messaging.impl.incoming {
	import flash.utils.IDataInput;
	
	public class File extends IncomingMessage {
		 
		
		public var filename_:String;
		
		public var file_:String;
		
		public function File(param1:uint, param2:Function) {
			super(param1,param2);
		}
		
		override public function parseFromInput(param1:IDataInput) : void {
			this.filename_ = param1.readUTF();
			var loc2:int = param1.readInt();
			this.file_ = param1.readUTFBytes(loc2);
		}
		
		override public function toString() : String {
			return formatToString("CLIENTSTAT","filename_","file_");
		}
	}
}
