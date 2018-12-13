package kabam.rotmg.chat.view {
	import com.company.assembleegameclient.util.TextureRedrawer;
	import com.company.util.AssetLibrary;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;

	import kabam.rotmg.chat.model.ChatModel;
	import kabam.rotmg.text.model.TextKey;
	import kabam.rotmg.text.view.TextFieldDisplayConcrete;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;

	public class ChatInputNotAllowed extends Sprite {

		public static const IMAGE_NAME:String = "lofiInterfaceBig";

		public static const IMADE_ID:int = 21;


		public function ChatInputNotAllowed() {
			super();
			this.makeTextField();
			this.makeSpeechBubble();
		}

		public function setup(param1:ChatModel):void {
			x = 0;
			y = param1.bounds.height - param1.lineHeight;
		}

		private function makeTextField():TextFieldDisplayConcrete {
			var loc1:LineBuilder = new LineBuilder().setParams(TextKey.CHAT_REGISTER_TO_CHAT);
			var loc2:TextFieldDisplayConcrete = new TextFieldDisplayConcrete();
			loc2.setStringBuilder(loc1);
			loc2.x = 29;
			addChild(loc2);
			return loc2;
		}

		private function makeSpeechBubble():Bitmap {
			var loc2:Bitmap = null;
			var loc1:BitmapData = AssetLibrary.getImageFromSet(IMAGE_NAME, IMADE_ID);
			loc1 = TextureRedrawer.redraw(loc1, 20, true, 0, false);
			loc2 = new Bitmap(loc1);
			loc2.x = -5;
			loc2.y = -10;
			addChild(loc2);
			return loc2;
		}
	}
}
