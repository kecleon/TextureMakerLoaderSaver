 
package kabam.rotmg.ui.view {
	import flash.display.Sprite;
	import kabam.rotmg.ui.model.Key;
	import mx.core.BitmapAsset;
	
	public class KeysView extends Sprite {
		
		private static var keyBackgroundPng:Class = KeysView_keyBackgroundPng;
		
		private static var greenKeyPng:Class = KeysView_greenKeyPng;
		
		private static var redKeyPng:Class = KeysView_redKeyPng;
		
		private static var yellowKeyPng:Class = KeysView_yellowKeyPng;
		
		private static var purpleKeyPng:Class = KeysView_purpleKeyPng;
		 
		
		private var base:BitmapAsset;
		
		private var keys:Vector.<BitmapAsset>;
		
		public function KeysView() {
			super();
			this.base = new keyBackgroundPng();
			addChild(this.base);
			this.keys = new Vector.<BitmapAsset>(4,true);
			this.keys[0] = new purpleKeyPng();
			this.keys[1] = new greenKeyPng();
			this.keys[2] = new redKeyPng();
			this.keys[3] = new yellowKeyPng();
			var loc1:int = 0;
			while(loc1 < 4) {
				this.keys[loc1].x = 12 + 40 * loc1;
				this.keys[loc1].y = 12;
				loc1++;
			}
		}
		
		public function showKey(param1:Key) : void {
			var loc2:BitmapAsset = this.keys[param1.position];
			if(!contains(loc2)) {
				addChild(loc2);
			}
		}
		
		public function hideKey(param1:Key) : void {
			var loc2:BitmapAsset = this.keys[param1.position];
			if(contains(loc2)) {
				removeChild(loc2);
			}
		}
	}
}
