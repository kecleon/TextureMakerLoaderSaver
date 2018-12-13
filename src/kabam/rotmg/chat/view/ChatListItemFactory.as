 
package kabam.rotmg.chat.view {
	import com.company.assembleegameclient.parameters.Parameters;
	import com.company.assembleegameclient.util.FameUtil;
	import com.company.assembleegameclient.util.StageProxy;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.StageQuality;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import io.decagames.rotmg.supportCampaign.data.SupporterCampaignModel;
	import kabam.rotmg.chat.model.ChatMessage;
	import kabam.rotmg.chat.model.ChatModel;
	import kabam.rotmg.text.model.FontModel;
	import kabam.rotmg.text.view.BitmapTextFactory;
	import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
	import kabam.rotmg.text.view.stringBuilder.StringBuilder;
	
	public class ChatListItemFactory {
		
		private static const IDENTITY_MATRIX:Matrix = new Matrix();
		
		private static const SERVER:String = Parameters.SERVER_CHAT_NAME;
		
		private static const CLIENT:String = Parameters.CLIENT_CHAT_NAME;
		
		private static const HELP:String = Parameters.HELP_CHAT_NAME;
		
		private static const ERROR:String = Parameters.ERROR_CHAT_NAME;
		
		private static const GUILD:String = Parameters.GUILD_CHAT_NAME;
		
		private static const testField:TextField = makeTestTextField();
		 
		
		[Inject]
		public var factory:BitmapTextFactory;
		
		[Inject]
		public var model:ChatModel;
		
		[Inject]
		public var fontModel:FontModel;
		
		[Inject]
		public var supporterCampaignModel:SupporterCampaignModel;
		
		[Inject]
		public var stageProxy:StageProxy;
		
		private var message:ChatMessage;
		
		private var buffer:Vector.<DisplayObject>;
		
		public function ChatListItemFactory() {
			super();
		}
		
		public static function isTradeMessage(param1:int, param2:int, param3:String) : Boolean {
			return (param1 == -1 || param2 == -1) && param3.search("/trade") != -1;
		}
		
		public static function isGuildMessage(param1:String) : Boolean {
			return param1 == GUILD;
		}
		
		private static function makeTestTextField() : TextField {
			var loc1:TextField = new TextField();
			var loc2:TextFormat = new TextFormat();
			loc2.size = 15;
			loc2.bold = true;
			loc1.defaultTextFormat = loc2;
			return loc1;
		}
		
		public function make(param1:ChatMessage, param2:Boolean = false) : ChatListItem {
			var loc5:int = 0;
			var loc7:String = null;
			var loc8:int = 0;
			this.message = param1;
			this.buffer = new Vector.<DisplayObject>();
			this.setTFonTestField();
			this.makeStarsIcon();
			this.makeWhisperText();
			this.makeNameText();
			this.makeMessageText();
			var loc3:Boolean = param1.numStars == -1 || param1.objectId == -1;
			var loc4:Boolean = false;
			var loc6:String = param1.name;
			if(loc3 && (loc5 = param1.text.search("/trade ")) != -1) {
				loc5 = loc5 + 7;
				loc7 = "";
				loc8 = loc5;
				while(loc8 < loc5 + 10) {
					if(param1.text.charAt(loc8) == "\"") {
						break;
					}
					loc7 = loc7 + param1.text.charAt(loc8);
					loc8++;
				}
				loc6 = loc7;
				loc4 = true;
			}
			return new ChatListItem(this.buffer,this.model.bounds.width,this.model.lineHeight,param2,param1.objectId,loc6,param1.recipient == GUILD,loc4);
		}
		
		private function makeStarsIcon() : void {
			var loc1:int = this.message.numStars;
			if(loc1 >= 0) {
				this.buffer.push(FameUtil.numStarsToIcon(loc1));
			}
		}
		
		private function makeWhisperText() : void {
			var loc1:StringBuilder = null;
			var loc2:BitmapData = null;
			if(this.message.isWhisper && !this.message.isToMe) {
				loc1 = new StaticStringBuilder("To: ");
				loc2 = this.getBitmapData(loc1,61695);
				this.buffer.push(new Bitmap(loc2));
			}
		}
		
		private function makeNameText() : void {
			if(!this.isSpecialMessageType()) {
				this.bufferNameText();
			}
		}
		
		private function isSpecialMessageType() : Boolean {
			var loc1:String = this.message.name;
			return loc1 == SERVER || loc1 == CLIENT || loc1 == HELP || loc1 == ERROR || loc1 == GUILD;
		}
		
		private function bufferNameText() : void {
			var loc1:StringBuilder = new StaticStringBuilder(this.processName());
			var loc2:BitmapData = this.getBitmapData(loc1,this.getNameColor());
			this.buffer.push(new Bitmap(loc2));
		}
		
		private function processName() : String {
			var loc1:String = this.message.isWhisper && !this.message.isToMe?this.message.recipient:this.message.name;
			if(loc1.charAt(0) == "#" || loc1.charAt(0) == "@") {
				loc1 = loc1.substr(1);
			}
			return "<" + loc1 + ">";
		}
		
		private function makeMessageText() : void {
			var loc2:int = 0;
			var loc1:Array = this.message.text.split("\n");
			if(loc1.length > 0) {
				this.makeNewLineFreeMessageText(loc1[0],true);
				loc2 = 1;
				while(loc2 < loc1.length) {
					this.makeNewLineFreeMessageText(loc1[loc2],false);
					loc2++;
				}
			}
		}
		
		private function makeNewLineFreeMessageText(param1:String, param2:Boolean) : void {
			var loc7:DisplayObject = null;
			var loc8:int = 0;
			var loc9:uint = 0;
			var loc10:int = 0;
			var loc11:int = 0;
			var loc3:String = param1;
			var loc4:int = 0;
			var loc5:int = 0;
			if(param2) {
				for each(loc7 in this.buffer) {
					loc4 = loc4 + loc7.width;
				}
				loc5 = loc3.length;
				testField.text = loc3;
				while(testField.textWidth >= this.model.bounds.width - loc4) {
					loc5 = loc5 - 10;
					testField.text = loc3.substr(0,loc5);
				}
				if(loc5 < loc3.length) {
					loc8 = loc3.substr(0,loc5).lastIndexOf(" ");
					loc5 = loc8 == 0 || loc8 == -1?int(loc5):int(loc8 + 1);
				}
				this.makeMessageLine(loc3.substr(0,loc5));
			}
			var loc6:int = loc3.length;
			if(loc6 > loc5) {
				loc9 = loc3.length;
				loc10 = loc5;
				while(loc10 < loc3.length) {
					testField.text = loc3.substr(loc10,loc9);
					while(testField.textWidth >= this.model.bounds.width) {
						loc9 = loc9 - 2;
						testField.text = loc3.substr(loc10,loc9);
					}
					loc11 = loc9;
					if(loc3.length > loc10 + loc9) {
						loc11 = loc3.substr(loc10,loc9).lastIndexOf(" ");
						loc11 = loc11 == 0 || loc11 == -1?int(loc9):int(loc11 + 1);
					}
					this.makeMessageLine(loc3.substr(loc10,loc11));
					loc10 = loc10 + loc11;
				}
			}
		}
		
		private function makeMessageLine(param1:String) : void {
			var loc2:StringBuilder = new StaticStringBuilder(param1);
			var loc3:BitmapData = this.getBitmapData(loc2,this.getTextColor());
			this.buffer.push(new Bitmap(loc3));
		}
		
		private function getNameColor() : uint {
			if(this.message.name.charAt(0) == "#") {
				return 16754688;
			}
			if(this.message.name.charAt(0) == "@") {
				return 16776960;
			}
			if(this.message.recipient == GUILD) {
				return 10944349;
			}
			if(this.message.recipient != "") {
				return 61695;
			}
			if(this.message.isFromSupporter) {
				return SupporterCampaignModel.SUPPORT_COLOR;
			}
			return 65280;
		}
		
		private function getTextColor() : uint {
			var loc1:String = this.message.name;
			if(loc1 == SERVER) {
				return 16776960;
			}
			if(loc1 == CLIENT) {
				return 255;
			}
			if(loc1 == HELP) {
				return 16734981;
			}
			if(loc1 == ERROR) {
				return 16711680;
			}
			if(loc1.charAt(0) == "@") {
				return 16776960;
			}
			if(this.message.recipient == GUILD) {
				return 10944349;
			}
			if(this.message.recipient != "") {
				return 61695;
			}
			return 16777215;
		}
		
		private function getBitmapData(param1:StringBuilder, param2:uint) : BitmapData {
			var loc3:String = this.stageProxy.getQuality();
			var loc4:Boolean = Parameters.data_["forceChatQuality"];
			loc4 && this.stageProxy.setQuality(StageQuality.HIGH);
			var loc5:BitmapData = this.factory.make(param1,14,param2,true,IDENTITY_MATRIX,true);
			loc4 && this.stageProxy.setQuality(loc3);
			return loc5;
		}
		
		private function setTFonTestField() : void {
			var loc1:TextFormat = testField.getTextFormat();
			loc1.font = this.fontModel.getFont().getName();
			testField.defaultTextFormat = loc1;
		}
	}
}
