 
package io.decagames.rotmg.pets.components.petStatsGrid {
	import flash.text.TextFormatAlign;
	import io.decagames.rotmg.pets.data.vo.AbilityVO;
	import io.decagames.rotmg.pets.data.vo.IPetVO;
	import io.decagames.rotmg.ui.ProgressBar;
	import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
	import io.decagames.rotmg.ui.gird.UIGrid;
	
	public class PetStatsGrid extends UIGrid {
		 
		
		private var _petVO:IPetVO;
		
		private var abilityBars:Vector.<ProgressBar>;
		
		public function PetStatsGrid(param1:int, param2:IPetVO) {
			super(param1,1,3);
			this.abilityBars = new Vector.<ProgressBar>();
			this._petVO = param2;
			if(param2) {
				this.refreshAbilities(param2);
			}
		}
		
		public function renderSimulation(param1:Array) : void {
			var loc3:AbilityVO = null;
			var loc2:int = 0;
			for each(loc3 in param1) {
				this.renderAbilitySimulation(loc3,loc2);
				loc2++;
			}
		}
		
		private function refreshAbilities(param1:IPetVO) : void {
			var loc3:AbilityVO = null;
			var loc2:int = 0;
			for each(loc3 in param1.abilityList) {
				this.renderAbility(loc3,loc2);
				loc2++;
			}
		}
		
		private function renderAbilitySimulation(param1:AbilityVO, param2:int) : void {
			if(param1.getUnlocked()) {
				this.abilityBars[param2].simulatedValue = param1.level;
			}
		}
		
		private function renderAbility(param1:AbilityVO, param2:int) : void {
			var loc3:ProgressBar = null;
			if(this.abilityBars.length > param2) {
				loc3 = this.abilityBars[param2];
				if(loc3.maxValue != this._petVO.maxAbilityPower && param1.getUnlocked()) {
					loc3.maxValue = this._petVO.maxAbilityPower;
					loc3.value = param1.level;
				}
				if(loc3.value != param1.level && param1.getUnlocked()) {
					loc3.dynamicLabelString = "Lvl. " + ProgressBar.DYNAMIC_LABEL_TOKEN + "/" + ProgressBar.MAX_VALUE_TOKEN;
					loc3.value = param1.level;
				}
			} else {
				loc3 = new ProgressBar(150,4,param1.name,!!param1.getUnlocked()?"Lvl. " + ProgressBar.DYNAMIC_LABEL_TOKEN + "/" + ProgressBar.MAX_VALUE_TOKEN:"",0,this._petVO.maxAbilityPower,!!param1.getUnlocked()?int(param1.level):0,5526612,15306295,6538829);
				loc3.showMaxLabel = true;
				loc3.maxColor = 6538829;
				DefaultLabelFormat.petStatLabelLeft(loc3.staticLabel,16777215);
				DefaultLabelFormat.petStatLabelRight(loc3.dynamicLabel,16777215);
				DefaultLabelFormat.petStatLabelRight(loc3.maxLabel,6538829,true);
				loc3.simulatedValueTextFormat = DefaultLabelFormat.createTextFormat(12,6538829,TextFormatAlign.RIGHT,true);
				this.abilityBars.push(loc3);
				addGridElement(loc3);
			}
			if(!param1.getUnlocked()) {
				loc3.alpha = 0.4;
			} else {
				if(loc3.alpha != 1) {
					loc3.dynamicLabelString = "Lvl. " + ProgressBar.DYNAMIC_LABEL_TOKEN + "/" + ProgressBar.MAX_VALUE_TOKEN;
					loc3.maxValue = this._petVO.maxAbilityPower;
					loc3.value = param1.level;
				}
				loc3.alpha = 1;
			}
		}
		
		public function updateVO(param1:IPetVO) : void {
			if(this._petVO != param1) {
				this.abilityBars = new Vector.<ProgressBar>();
				clearGrid();
			}
			this._petVO = param1;
			if(this._petVO != null) {
				this.refreshAbilities(param1);
			}
		}
		
		public function get petVO() : IPetVO {
			return this._petVO;
		}
	}
}
