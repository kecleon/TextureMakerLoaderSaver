package io.decagames.rotmg.pets.components.caretaker {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;

	public class CaretakerQueryDialogCaretaker extends Sprite {


		private const speechBubble:CaretakerQuerySpeechBubble = this.makeSpeechBubble();

		private const detailBubble:CaretakerQueryDetailBubble = this.makeDetailBubble();

		private const icon:Bitmap = this.makeCaretakerIcon();

		public function CaretakerQueryDialogCaretaker() {
			super();
		}

		private function makeSpeechBubble():CaretakerQuerySpeechBubble {
			var loc1:CaretakerQuerySpeechBubble = null;
			loc1 = new CaretakerQuerySpeechBubble(CaretakerQueryDialog.QUERY);
			loc1.x = 60;
			addChild(loc1);
			return loc1;
		}

		private function makeDetailBubble():CaretakerQueryDetailBubble {
			var loc1:CaretakerQueryDetailBubble = new CaretakerQueryDetailBubble();
			loc1.y = 60;
			return loc1;
		}

		private function makeCaretakerIcon():Bitmap {
			var loc1:Bitmap = null;
			loc1 = new Bitmap(this.makeDebugBitmapData());
			loc1.x = -16;
			loc1.y = -32;
			addChild(loc1);
			return loc1;
		}

		private function makeDebugBitmapData():BitmapData {
			return new BitmapDataSpy(42, 42, true, 4278255360);
		}

		public function showDetail(param1:String):void {
			this.detailBubble.setText(param1);
			removeChild(this.speechBubble);
			addChild(this.detailBubble);
		}

		public function showSpeech():void {
			removeChild(this.detailBubble);
			addChild(this.speechBubble);
		}

		public function setCaretakerIcon(param1:BitmapData):void {
			this.icon.bitmapData = param1;
		}
	}
}
