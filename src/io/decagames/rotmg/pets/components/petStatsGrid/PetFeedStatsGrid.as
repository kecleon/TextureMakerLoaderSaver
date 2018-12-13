 
package io.decagames.rotmg.pets.components.petStatsGrid {
	import flash.display.Sprite;
	import flash.text.TextFormatAlign;
	import io.decagames.rotmg.pets.components.petInfoSlot.PetInfoSlot;
	import io.decagames.rotmg.pets.data.ability.AbilitiesUtil;
	import io.decagames.rotmg.pets.data.vo.AbilityVO;
	import io.decagames.rotmg.pets.data.vo.IPetVO;
	import io.decagames.rotmg.ui.PetFeedProgressBar;
	import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
	import io.decagames.rotmg.ui.gird.UIGrid;
	import io.decagames.rotmg.ui.labels.UILabel;
	
	public class PetFeedStatsGrid extends UIGrid {
		 
		
		private var _petVO:IPetVO;
		
		private var abilityBars:Vector.<PetFeedProgressBar>;
		
		private var _labelContainer:Sprite;
		
		private var _plusLabels:Vector.<UILabel>;
		
		private var _currentLevels:Vector.<int>;
		
		private var _maxLevel:int;
		
		public function PetFeedStatsGrid(param1:int, param2:IPetVO) {
			super(param1,1,3);
			this._petVO = param2;
			this.init();
		}
		
		private function init() : void {
			this.abilityBars = new Vector.<PetFeedProgressBar>();
			this._currentLevels = new Vector.<int>(0);
			this._labelContainer = new Sprite();
			this._labelContainer.x = -2;
			this._labelContainer.y = -13;
			this._labelContainer.visible = false;
			addChild(this._labelContainer);
			this.createLabels();
			this.createPlusLabels();
			if(this._petVO) {
				this._maxLevel = this._petVO.maxAbilityPower;
				this.refreshAbilities(this._petVO);
			}
		}
		
		private function createPlusLabels() : void {
			var loc1:int = 0;
			var loc2:UILabel = null;
			this._plusLabels = new Vector.<UILabel>(0);
			loc1 = 0;
			while(loc1 < 3) {
				loc2 = new UILabel();
				DefaultLabelFormat.petStatLabelRight(loc2,6538829);
				loc2.x = PetInfoSlot.FEED_STATS_WIDTH + 8;
				loc2.y = loc1 * 23;
				loc2.visible = false;
				addChild(loc2);
				this._plusLabels.push(loc2);
				loc1++;
			}
		}
		
		private function createLabels() : void {
			var loc2:UILabel = null;
			var loc1:UILabel = new UILabel();
			DefaultLabelFormat.petStatLabelLeftSmall(loc1,10658466);
			loc1.text = "Ability";
			loc1.y = -3;
			this._labelContainer.addChild(loc1);
			loc2 = new UILabel();
			DefaultLabelFormat.petStatLabelRightSmall(loc2,10658466);
			loc2.text = "Level";
			loc2.x = 195 - loc2.width + 4;
			loc2.y = -3;
			this._labelContainer.addChild(loc2);
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
			var loc2:int = 0;
			var loc3:AbilityVO = null;
			this._currentLevels.length = 0;
			this._maxLevel = this._petVO.maxAbilityPower;
			this._labelContainer.visible = true;
			loc2 = 0;
			for each(loc3 in param1.abilityList) {
				this._currentLevels.push(loc3.level);
				this._plusLabels[loc2].text = "";
				this._plusLabels[loc2].visible = false;
				this.renderAbility(loc3,loc2);
				loc2++;
			}
		}
		
		private function renderAbilitySimulation(param1:AbilityVO, param2:int) : void {
			var loc3:PetFeedProgressBar = null;
			if(param1.getUnlocked()) {
				loc3 = this.abilityBars[param2];
				loc3.maxLevel = this._maxLevel;
				loc3.simulatedValue = param1.points;
				if(param1.level - this._currentLevels[param2] > 0) {
					this._plusLabels[param2].text = "+" + (param1.level - this._currentLevels[param2]);
					this._plusLabels[param2].visible = true;
				} else {
					this._plusLabels[param2].visible = false;
				}
			}
		}
		
		private function renderAbility(param1:AbilityVO, param2:int) : void {
			var loc3:PetFeedProgressBar = null;
			var loc4:int = AbilitiesUtil.abilityPowerToMinPoints(param1.level + 1);
			if(this.abilityBars.length > param2) {
				loc3 = this.abilityBars[param2];
				if(param1.getUnlocked()) {
					if(loc3.maxValue != loc4 || loc3.value != param1.points) {
						this.updateProgressBarValues(loc3,param1,loc4);
					}
				}
			} else {
				loc3 = new PetFeedProgressBar(195,4,param1.name,loc4,!!param1.getUnlocked()?int(param1.points):0,param1.level,this._maxLevel,5526612,15306295,6538829);
				loc3.showMaxLabel = true;
				loc3.maxColor = 6538829;
				DefaultLabelFormat.petStatLabelLeft(loc3.abilityLabel,16777215);
				DefaultLabelFormat.petStatLabelRight(loc3.levelLabel,16777215);
				DefaultLabelFormat.petStatLabelRight(loc3.maxLabel,6538829,true);
				loc3.simulatedValueTextFormat = DefaultLabelFormat.createTextFormat(12,6538829,TextFormatAlign.RIGHT,true);
				this.abilityBars.push(loc3);
				addGridElement(loc3);
			}
			if(!param1.getUnlocked()) {
				loc3.alpha = 0.4;
			} else {
				if(loc3.alpha != 1) {
					loc3.maxValue = loc4;
					loc3.value = param1.points;
				}
				loc3.alpha = 1;
			}
		}
		
		private function updateProgressBarValues(param1:PetFeedProgressBar, param2:AbilityVO, param3:int) : void {
			param1.maxLevel = this._maxLevel;
			param1.currentLevel = param2.level;
			param1.maxValue = param3;
			param1.value = param2.points;
		}
		
		public function updateVO(param1:IPetVO) : void {
			if(this._petVO != param1) {
				this.abilityBars.length = 0;
				this._labelContainer.visible = false;
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
