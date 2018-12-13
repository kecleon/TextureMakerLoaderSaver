package kabam.rotmg.ui.view.components.dropdown {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import kabam.rotmg.ui.view.SignalWaiter;

	public class LocalizedDropDown extends Sprite {


		protected var strings_:Vector.<String>;

		protected var w_:int = 0;

		protected const h_:int = 36;

		protected var selected_:LocalizedDropDownItem;

		private var items_:Vector.<LocalizedDropDownItem>;

		private var all_:Sprite;

		private var waiter:SignalWaiter;

		public function LocalizedDropDown(param1:Vector.<String>) {
			this.items_ = new Vector.<LocalizedDropDownItem>();
			this.all_ = new Sprite();
			this.waiter = new SignalWaiter();
			super();
			this.strings_ = param1;
			this.makeDropDownItems();
			this.updateView();
			addChild(this.all_);
			this.all_.visible = false;
			this.waiter.complete.addOnce(this.onComplete);
		}

		public function getValue():String {
			return this.selected_.getValue();
		}

		public function setValue(param1:String):void {
			var loc3:String = null;
			var loc2:int = this.strings_.indexOf(param1);
			if (loc2 > 0) {
				loc3 = this.strings_[0];
				this.strings_[loc2] = loc3;
				this.strings_[0] = param1;
				this.updateView();
				dispatchEvent(new Event(Event.CHANGE));
			}
		}

		public function getClosedHeight():int {
			return this.h_;
		}

		private function makeDropDownItems():void {
			var loc1:LocalizedDropDownItem = null;
			if (this.strings_.length > 0) {
				loc1 = this.makeDropDownItem(this.strings_[0]);
				this.items_.push(loc1);
				this.selected_ = loc1;
				this.selected_.addEventListener(MouseEvent.CLICK, this.onClick);
				addChild(this.selected_);
			}
			var loc2:int = 1;
			while (loc2 < this.strings_.length) {
				loc1 = this.makeDropDownItem(this.strings_[loc2]);
				loc1.addEventListener(MouseEvent.CLICK, this.onSelect);
				loc1.y = this.h_ * loc2;
				this.items_.push(loc1);
				this.all_.addChild(loc1);
				loc2++;
			}
		}

		private function makeDropDownItem(param1:String):LocalizedDropDownItem {
			var loc2:LocalizedDropDownItem = new LocalizedDropDownItem(param1, 0, this.h_);
			this.waiter.push(loc2.getTextChanged());
			return loc2;
		}

		private function updateView():void {
			var loc1:int = 0;
			while (loc1 < this.strings_.length) {
				this.items_[loc1].setValue(this.strings_[loc1]);
				this.items_[loc1].setWidth(this.w_);
				loc1++;
			}
			if (this.items_.length > 0) {
				this.selected_ = this.items_[0];
			}
		}

		private function showAll():void {
			this.addEventListener(MouseEvent.ROLL_OUT, this.onOut);
			this.all_.visible = true;
		}

		private function hideAll():void {
			this.removeEventListener(MouseEvent.ROLL_OUT, this.onOut);
			this.all_.visible = false;
		}

		private function onComplete():void {
			var loc2:LocalizedDropDownItem = null;
			var loc1:int = 83;
			for each(loc2 in this.items_) {
				loc1 = Math.max(loc2.width, loc1);
			}
			this.w_ = loc1;
			this.updateView();
		}

		private function onClick(param1:MouseEvent):void {
			param1.stopImmediatePropagation();
			this.selected_.removeEventListener(MouseEvent.CLICK, this.onClick);
			this.selected_.addEventListener(MouseEvent.CLICK, this.onSelect);
			this.showAll();
		}

		private function onSelect(param1:MouseEvent):void {
			param1.stopImmediatePropagation();
			this.selected_.addEventListener(MouseEvent.CLICK, this.onClick);
			this.selected_.removeEventListener(MouseEvent.CLICK, this.onSelect);
			this.hideAll();
			var loc2:LocalizedDropDownItem = param1.target as LocalizedDropDownItem;
			this.setValue(loc2.getValue());
		}

		private function onOut(param1:MouseEvent):void {
			this.selected_.addEventListener(MouseEvent.CLICK, this.onClick);
			this.selected_.removeEventListener(MouseEvent.CLICK, this.onSelect);
			this.hideAll();
		}
	}
}
