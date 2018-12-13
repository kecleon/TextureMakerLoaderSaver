 
package ru.inspirit.net.events {
	import flash.events.Event;
	
	public class MultipartURLLoaderEvent extends Event {
		
		public static const DATA_PREPARE_PROGRESS:String = "dataPrepareProgress";
		
		public static const DATA_PREPARE_COMPLETE:String = "dataPrepareComplete";
		 
		
		public var bytesWritten:uint = 0;
		
		public var bytesTotal:uint = 0;
		
		public function MultipartURLLoaderEvent(param1:String, param2:uint = 0, param3:uint = 0) {
			super(param1);
			this.bytesTotal = param3;
			this.bytesWritten = param2;
		}
	}
}
