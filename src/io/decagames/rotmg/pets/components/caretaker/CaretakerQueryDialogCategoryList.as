 
package io.decagames.rotmg.pets.components.caretaker {
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import kabam.lib.ui.impl.LayoutList;
	import kabam.lib.ui.impl.VerticalLayout;
	import kabam.rotmg.ui.view.SignalWaiter;
	import org.osflash.signals.Signal;
	
	public class CaretakerQueryDialogCategoryList extends LayoutList {
		 
		
		private const waiter:SignalWaiter = new SignalWaiter();
		
		public const ready:Signal = this.waiter.complete;
		
		public const selected:Signal = new Signal(String);
		
		public function CaretakerQueryDialogCategoryList(param1:Array) {
			super();
			setLayout(this.makeLayout());
			setItems(this.makeItems(param1));
			this.ready.addOnce(updateLayout);
		}
		
		private function makeLayout() : VerticalLayout {
			var loc1:VerticalLayout = new VerticalLayout();
			loc1.setPadding(2);
			return loc1;
		}
		
		private function makeItems(param1:Array) : Vector.<DisplayObject> {
			var loc2:Vector.<DisplayObject> = new Vector.<DisplayObject>();
			var loc3:int = 0;
			while(loc3 < param1.length) {
				loc2.push(this.makeItem(param1[loc3]));
				loc3++;
			}
			return loc2;
		}
		
		private function makeItem(param1:Object) : CaretakerQueryDialogCategoryItem {
			var loc2:CaretakerQueryDialogCategoryItem = new CaretakerQueryDialogCategoryItem(param1.category,param1.info);
			loc2.addEventListener(MouseEvent.CLICK,this.onClick);
			this.waiter.push(loc2.textChanged);
			return loc2;
		}
		
		private function onClick(param1:MouseEvent) : void {
			var loc2:CaretakerQueryDialogCategoryItem = param1.currentTarget as CaretakerQueryDialogCategoryItem;
			this.selected.dispatch(loc2.info);
		}
	}
}
