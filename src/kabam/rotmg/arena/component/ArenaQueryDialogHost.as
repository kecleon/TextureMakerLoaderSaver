 
package kabam.rotmg.arena.component {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import kabam.rotmg.arena.view.HostQueryDialog;
	
	public class ArenaQueryDialogHost extends Sprite {
		 
		
		private const speechBubble:HostQuerySpeechBubble = this.makeSpeechBubble();
		
		private const detailBubble:HostQueryDetailBubble = this.makeDetailBubble();
		
		private const icon:Bitmap = this.makeHostIcon();
		
		public function ArenaQueryDialogHost() {
			super();
		}
		
		private function makeSpeechBubble() : HostQuerySpeechBubble {
			var loc1:HostQuerySpeechBubble = null;
			loc1 = new HostQuerySpeechBubble(HostQueryDialog.QUERY);
			loc1.x = 60;
			addChild(loc1);
			return loc1;
		}
		
		private function makeDetailBubble() : HostQueryDetailBubble {
			var loc1:HostQueryDetailBubble = new HostQueryDetailBubble();
			loc1.y = 60;
			return loc1;
		}
		
		private function makeHostIcon() : Bitmap {
			var loc1:Bitmap = null;
			loc1 = new Bitmap(this.makeDebugBitmapData());
			loc1.x = 0;
			loc1.y = 0;
			addChild(loc1);
			return loc1;
		}
		
		private function makeDebugBitmapData() : BitmapData {
			return new BitmapData(42,42,true,4278255360);
		}
		
		public function showDetail(param1:String) : void {
			this.detailBubble.setText(param1);
			removeChild(this.speechBubble);
			addChild(this.detailBubble);
		}
		
		public function showSpeech() : void {
			removeChild(this.detailBubble);
			addChild(this.speechBubble);
		}
		
		public function setHostIcon(param1:BitmapData) : void {
			this.icon.bitmapData = param1;
		}
	}
}
