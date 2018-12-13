 
package com.company.assembleegameclient.editor {
	public class CommandList {
		 
		
		private var list_:Vector.<Command>;
		
		public function CommandList() {
			this.list_ = new Vector.<Command>();
			super();
		}
		
		public function empty() : Boolean {
			return this.list_.length == 0;
		}
		
		public function addCommand(param1:Command) : void {
			this.list_.push(param1);
		}
		
		public function execute() : void {
			var loc1:Command = null;
			for each(loc1 in this.list_) {
				loc1.execute();
			}
		}
		
		public function unexecute() : void {
			var loc1:Command = null;
			for each(loc1 in this.list_) {
				loc1.unexecute();
			}
		}
	}
}
