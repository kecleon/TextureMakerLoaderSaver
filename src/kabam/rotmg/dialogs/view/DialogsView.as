 
package kabam.rotmg.dialogs.view {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class DialogsView extends Sprite {
		 
		
		private var background:Sprite;
		
		private var container:DisplayObjectContainer;
		
		private var current:Sprite;
		
		private var pushed:DisplayObject;
		
		public function DialogsView() {
			super();
			addChild(this.background = new Sprite());
			addChild(this.container = new Sprite());
			this.background.visible = false;
			this.background.mouseEnabled = true;
		}
		
		public function showBackground(param1:int = 1381653) : void {
			var loc2:Graphics = this.background.graphics;
			loc2.clear();
			loc2.beginFill(param1,0.6);
			loc2.drawRect(0,0,800,600);
			loc2.endFill();
			this.background.visible = true;
		}
		
		public function show(param1:Sprite, param2:Boolean) : void {
			this.removeCurrentDialog();
			this.addDialog(param1);
			param2 && this.showBackground();
		}
		
		public function hideAll() : void {
			this.background.visible = false;
			this.removeCurrentDialog();
		}
		
		public function push(param1:Sprite) : void {
			this.current.visible = false;
			this.pushed = param1;
			addChild(param1);
			this.background.visible = true;
		}
		
		public function getPushed() : DisplayObject {
			return this.pushed;
		}
		
		public function pop() : void {
			removeChild(this.pushed);
			this.current.visible = true;
		}
		
		private function addDialog(param1:Sprite) : void {
			this.current = param1;
			param1.addEventListener(Event.REMOVED,this.onRemoved);
			this.container.addChild(param1);
		}
		
		private function onRemoved(param1:Event) : void {
			var loc2:Sprite = param1.target as Sprite;
			if(this.current == loc2) {
				this.background.visible = false;
				this.current = null;
			}
		}
		
		private function removeCurrentDialog() : void {
			if(this.current && this.container.contains(this.current)) {
				this.current.removeEventListener(Event.REMOVED,this.onRemoved);
				this.container.removeChild(this.current);
				this.background.visible = false;
			}
		}
	}
}
