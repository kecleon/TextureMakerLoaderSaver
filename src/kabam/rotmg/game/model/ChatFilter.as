 
package kabam.rotmg.game.model {
	import com.company.assembleegameclient.parameters.Parameters;
	
	public class ChatFilter {
		 
		
		public function ChatFilter() {
			super();
		}
		
		public function guestChatFilter(param1:String) : Boolean {
			var loc2:Boolean = false;
			if(param1 == null) {
				return true;
			}
			if(param1 == Parameters.SERVER_CHAT_NAME || param1 == Parameters.HELP_CHAT_NAME || param1 == Parameters.ERROR_CHAT_NAME || param1 == Parameters.CLIENT_CHAT_NAME) {
				loc2 = true;
			}
			if(param1.charAt(0) == "#") {
				loc2 = true;
			}
			if(param1.charAt(0) == "@") {
				loc2 = true;
			}
			return loc2;
		}
	}
}
