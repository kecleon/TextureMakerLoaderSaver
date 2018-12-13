 
package io.decagames.rotmg.pets.components.petStatsGrid {
	import io.decagames.rotmg.pets.data.ability.AbilitiesUtil;
	import io.decagames.rotmg.pets.data.vo.PetVO;
	import io.decagames.rotmg.pets.signals.ReleasePetSignal;
	import io.decagames.rotmg.pets.signals.SelectPetSignal;
	import io.decagames.rotmg.pets.signals.SimulateFeedSignal;
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	public class PetStatsGridMediator extends Mediator {
		 
		
		[Inject]
		public var view:PetStatsGrid;
		
		[Inject]
		public var selectPetSignal:SelectPetSignal;
		
		[Inject]
		public var simulateFeedSignal:SimulateFeedSignal;
		
		[Inject]
		public var release:ReleasePetSignal;
		
		public function PetStatsGridMediator() {
			super();
		}
		
		override public function initialize() : void {
			this.selectPetSignal.add(this.onPetSelected);
			if(this.view.petVO && this.view.petVO.updated) {
				this.view.petVO.updated.add(this.VOUpdated);
			}
			this.simulateFeedSignal.add(this.simulateFeed);
			this.release.add(this.onRelease);
		}
		
		override public function destroy() : void {
			this.selectPetSignal.remove(this.onPetSelected);
			if(this.view.petVO && this.view.petVO.updated) {
				this.view.petVO.updated.remove(this.VOUpdated);
			}
			this.simulateFeedSignal.remove(this.simulateFeed);
			this.release.remove(this.onRelease);
		}
		
		private function onRelease(param1:int) : void {
			this.view.updateVO(null);
		}
		
		private function simulateFeed(param1:int) : void {
			var loc2:Array = null;
			if(this.view.petVO) {
				loc2 = AbilitiesUtil.simulateAbilityUpgrade(this.view.petVO,param1);
				this.view.renderSimulation(loc2);
			}
		}
		
		private function VOUpdated() : void {
			this.view.updateVO(this.view.petVO);
		}
		
		private function onPetSelected(param1:PetVO) : void {
			if(this.view.petVO && this.view.petVO.updated) {
				this.view.petVO.updated.remove(this.VOUpdated);
			}
			this.view.updateVO(param1);
			if(this.view.petVO && this.view.petVO.updated) {
				this.view.petVO.updated.add(this.VOUpdated);
			}
		}
	}
}
