package kabam.rotmg.messaging.impl.incoming {
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;

	public class Pic extends IncomingMessage {


		public var bitmapData_:BitmapData = null;

		public function Pic(param1:uint, param2:Function) {
			super(param1, param2);
		}

		override public function parseFromInput(param1:IDataInput):void {
			var loc2:int = param1.readInt();
			var loc3:int = param1.readInt();
			var loc4:ByteArray = new ByteArray();
			param1.readBytes(loc4, 0, loc2 * loc3 * 4);
			this.bitmapData_ = new BitmapDataSpy(loc2, loc3);
			this.bitmapData_.setPixels(this.bitmapData_.rect, loc4);
		}

		override public function toString():String {
			return formatToString("PIC", "bitmapData_");
		}
	}
}
