package kabam.rotmg.editor.view.components.savedialog {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class TypeDropDown extends Sprite {


		public var items_:Vector.<TypeDropDownItem>;

		public var selected_:TypeDropDownItem;

		public function TypeDropDown(param1:Vector.<int>) {
			var loc2:int = 0;
			this.items_ = new Vector.<TypeDropDownItem>();
			super();
			for each(loc2 in param1) {
				this.addItem(new TypeDropDownItem(loc2));
			}
			this.setSelected(this.items_[0]);
		}

		public function setType(param1:int):void {
			var loc2:TypeDropDownItem = null;
			for each(loc2 in this.items_) {
				if (loc2.type_ == param1) {
					this.setSelected(loc2);
				}
			}
		}

		public function getType():int {
			return this.selected_.type_;
		}

		private function addItem(param1:TypeDropDownItem):void {
			this.items_.push(param1);
		}

		private function removeSelected():void {
			if (this.selected_ != null) {
				if (contains(this.selected_)) {
					removeChild(this.selected_);
				}
				this.selected_.removeEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
			}
		}

		private function setSelected(param1:TypeDropDownItem):void {
			this.removeSelected();
			this.selected_ = param1;
			this.selected_.y = 0;
			addChild(this.selected_);
			this.selected_.addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
		}

		private function onMouseDown(param1:MouseEvent):void {
			if (this.items_.length == 1) {
				return;
			}
			this.removeSelected();
			this.showAll();
		}

		private function showAll():void {
			var loc3:TypeDropDownItem = null;
			var loc1:int = 0;
			var loc2:int = 0;
			while (loc2 < this.items_.length) {
				loc3 = this.items_[loc2];
				loc3.addEventListener(MouseEvent.MOUSE_DOWN, this.onSelect);
				loc3.y = loc1;
				addChild(loc3);
				loc1 = loc1 + TypeDropDownItem.HEIGHT;
				loc2++;
			}
		}

		private function hideAll():void {
			var loc2:TypeDropDownItem = null;
			var loc1:int = 0;
			while (loc1 < this.items_.length) {
				loc2 = this.items_[loc1];
				loc2.removeEventListener(MouseEvent.MOUSE_DOWN, this.onSelect);
				removeChild(loc2);
				loc1++;
			}
		}

		private function onSelect(param1:MouseEvent):void {
			this.hideAll();
			this.setSelected(param1.target as TypeDropDownItem);
			dispatchEvent(new Event(Event.CHANGE));
		}
	}
}
