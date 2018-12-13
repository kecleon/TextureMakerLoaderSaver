 
package kabam.rotmg.tooltips {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import kabam.rotmg.core.signals.HideTooltipsSignal;
	import kabam.rotmg.core.signals.ShowTooltipSignal;
	
	public class HoverTooltipDelegate implements TooltipAble {
		 
		
		public var tooltip:Sprite;
		
		private var hideToolTips:HideTooltipsSignal;
		
		private var showToolTip:ShowTooltipSignal;
		
		private var displayObject:DisplayObject;
		
		public function HoverTooltipDelegate() {
			super();
		}
		
		public function setDisplayObject(param1:DisplayObject) : void {
			this.displayObject = param1;
			this.displayObject.addEventListener(MouseEvent.CLICK,this.onMouseOut);
			this.displayObject.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
			this.displayObject.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
			this.displayObject.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
		}
		
		public function removeDisplayObject() : void {
			if(this.displayObject != null) {
				this.displayObject.removeEventListener(MouseEvent.CLICK,this.onMouseOut);
				this.displayObject.removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
				this.displayObject.removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
				this.displayObject.removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
				this.displayObject = null;
			}
		}
		
		public function getDisplayObject() : DisplayObject {
			return this.displayObject;
		}
		
		public function setShowToolTipSignal(param1:ShowTooltipSignal) : void {
			this.showToolTip = param1;
		}
		
		public function getShowToolTip() : ShowTooltipSignal {
			return this.showToolTip;
		}
		
		public function setHideToolTipsSignal(param1:HideTooltipsSignal) : void {
			this.hideToolTips = param1;
		}
		
		public function getHideToolTips() : HideTooltipsSignal {
			return this.hideToolTips;
		}
		
		private function onRemovedFromStage(param1:Event) : void {
			if(this.tooltip != null && this.tooltip.parent != null) {
				this.hideToolTips.dispatch();
			}
			this.displayObject.removeEventListener(MouseEvent.CLICK,this.onMouseOut);
			this.displayObject.removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
			this.displayObject.removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
			this.displayObject.removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
		}
		
		private function onMouseOut(param1:MouseEvent) : void {
			this.hideToolTips.dispatch();
		}
		
		private function onMouseOver(param1:MouseEvent) : void {
			this.showToolTip.dispatch(this.tooltip);
		}
	}
}
