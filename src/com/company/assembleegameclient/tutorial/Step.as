 
package com.company.assembleegameclient.tutorial {
	public class Step {
		 
		
		public var text_:String;
		
		public var action_:String;
		
		public var uiDrawBoxes_:Vector.<UIDrawBox>;
		
		public var uiDrawArrows_:Vector.<UIDrawArrow>;
		
		public var reqs_:Vector.<Requirement>;
		
		public var satisfiedSince_:int = 0;
		
		public var trackingSent:Boolean;
		
		public function Step(param1:XML) {
			var loc2:XML = null;
			var loc3:XML = null;
			var loc4:XML = null;
			this.uiDrawBoxes_ = new Vector.<UIDrawBox>();
			this.uiDrawArrows_ = new Vector.<UIDrawArrow>();
			this.reqs_ = new Vector.<Requirement>();
			super();
			for each(loc2 in param1.UIDrawBox) {
				this.uiDrawBoxes_.push(new UIDrawBox(loc2));
			}
			for each(loc3 in param1.UIDrawArrow) {
				this.uiDrawArrows_.push(new UIDrawArrow(loc3));
			}
			for each(loc4 in param1.Requirement) {
				this.reqs_.push(new Requirement(loc4));
			}
		}
		
		public function toString() : String {
			return "[" + this.text_ + "]";
		}
	}
}
