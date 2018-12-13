package kabam.rotmg.chat.model {
	public class ChatMessage {


		public var name:String;

		public var text:String;

		public var objectId:int = -1;

		public var numStars:int = -1;

		public var recipient:String = "";

		public var isToMe:Boolean;

		public var isWhisper:Boolean;

		public var isFromSupporter:Boolean;

		public var tokens:Object;

		public function ChatMessage() {
			super();
		}

		public static function make(param1:String, param2:String, param3:int = -1, param4:int = -1, param5:String = "", param6:Boolean = false, param7:Object = null, param8:Boolean = false, param9:Boolean = false):ChatMessage {
			var loc10:ChatMessage = new ChatMessage();
			loc10.name = param1;
			loc10.text = param2;
			loc10.objectId = param3;
			loc10.numStars = param4;
			loc10.recipient = param5;
			loc10.isToMe = param6;
			loc10.isWhisper = param8;
			loc10.isFromSupporter = param9;
			loc10.tokens = param7 == null ? {} : param7;
			return loc10;
		}
	}
}
