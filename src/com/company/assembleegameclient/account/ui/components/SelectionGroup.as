 
package com.company.assembleegameclient.account.ui.components {
	public class SelectionGroup {
		 
		
		private var selectables:Vector.<Selectable>;
		
		private var selected:Selectable;
		
		public function SelectionGroup(param1:Vector.<Selectable>) {
			super();
			this.selectables = param1;
		}
		
		public function setSelected(param1:String) : void {
			var loc2:Selectable = null;
			for each(loc2 in this.selectables) {
				if(loc2.getValue() == param1) {
					this.replaceSelected(loc2);
					return;
				}
			}
		}
		
		public function getSelected() : Selectable {
			return this.selected;
		}
		
		private function replaceSelected(param1:Selectable) : void {
			if(this.selected != null) {
				this.selected.setSelected(false);
			}
			this.selected = param1;
			this.selected.setSelected(true);
		}
	}
}
