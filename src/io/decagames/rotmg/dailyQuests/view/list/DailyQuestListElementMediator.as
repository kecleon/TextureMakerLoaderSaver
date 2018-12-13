 
package io.decagames.rotmg.dailyQuests.view.list {
	import flash.events.MouseEvent;
	import io.decagames.rotmg.dailyQuests.signal.ShowQuestInfoSignal;
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	public class DailyQuestListElementMediator extends Mediator {
		 
		
		[Inject]
		public var view:DailyQuestListElement;
		
		[Inject]
		public var showInfoSignal:ShowQuestInfoSignal;
		
		public function DailyQuestListElementMediator() {
			super();
		}
		
		override public function initialize() : void {
			this.showInfoSignal.add(this.resetElement);
			this.view.addEventListener(MouseEvent.CLICK,this.onClickHandler);
		}
		
		private function resetElement(param1:int) : void {
			this.view.isSelected = false;
		}
		
		override public function destroy() : void {
			this.view.removeEventListener(MouseEvent.CLICK,this.onClickHandler);
		}
		
		private function onClickHandler(param1:MouseEvent) : void {
			this.showInfoSignal.dispatch(this.view.id);
			this.view.isSelected = true;
		}
	}
}
