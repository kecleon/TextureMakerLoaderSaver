package kabam.rotmg.editor.view.components.drawer {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class FrameSelector extends Sprite {

		public static const STAND:String = "Stand";

		public static const WALK1:String = "Walk 1";

		public static const WALK2:String = "Walk 2";

		public static const ATTACK1:String = "Attack 1";

		public static const ATTACK2:String = "Attack 2";

		public static const FRAMES:Vector.<String> = new <String>[STAND, WALK1, WALK2, ATTACK1, ATTACK2];


		public var buttons_:Vector.<FrameButton>;

		public var selected_:FrameButton = null;

		public function FrameSelector() {
			var loc2:String = null;
			var loc3:FrameButton = null;
			this.buttons_ = new Vector.<FrameButton>();
			super();
			var loc1:int = 0;
			for each(loc2 in FRAMES) {
				loc3 = new FrameButton(loc2);
				loc3.addEventListener(MouseEvent.CLICK, this.onClick);
				loc3.x = loc1;
				loc1 = loc1 + (loc3.width + 5);
				addChild(loc3);
				this.buttons_.push(loc3);
			}
			this.setSelected(this.buttons_[0]);
		}

		public function getSelected():String {
			return this.selected_.label_;
		}

		private function setSelected(param1:FrameButton):void {
			if (this.selected_ != null) {
				this.selected_.setSelected(false);
			}
			this.selected_ = param1;
			this.selected_.setSelected(true);
			dispatchEvent(new Event(Event.CHANGE));
		}

		private function onClick(param1:MouseEvent):void {
			var loc2:FrameButton = param1.target as FrameButton;
			this.setSelected(loc2);
		}
	}
}
