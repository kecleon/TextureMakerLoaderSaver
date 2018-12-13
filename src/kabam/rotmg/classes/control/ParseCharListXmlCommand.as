package kabam.rotmg.classes.control {
	import io.decagames.rotmg.characterMetrics.tracker.CharactersMetricsTracker;

	import kabam.rotmg.classes.model.CharacterClass;
	import kabam.rotmg.classes.model.CharacterSkin;
	import kabam.rotmg.classes.model.CharacterSkinState;
	import kabam.rotmg.classes.model.ClassesModel;

	import robotlegs.bender.framework.api.ILogger;

	public class ParseCharListXmlCommand {


		[Inject]
		public var data:XML;

		[Inject]
		public var model:ClassesModel;

		[Inject]
		public var logger:ILogger;

		[Inject]
		public var statsTracker:CharactersMetricsTracker;

		public function ParseCharListXmlCommand() {
			super();
		}

		public function execute():void {
			this.parseMaxLevelsAchieved();
			this.parseItemCosts();
			this.parseOwnership();
			this.statsTracker.parseCharListData(this.data);
		}

		private function parseMaxLevelsAchieved():void {
			var loc2:XML = null;
			var loc3:CharacterClass = null;
			var loc1:XMLList = this.data.MaxClassLevelList.MaxClassLevel;
			for each(loc2 in loc1) {
				loc3 = this.model.getCharacterClass(loc2.@classType);
				loc3.setMaxLevelAchieved(loc2.@maxLevel);
			}
		}

		private function parseItemCosts():void {
			var loc2:XML = null;
			var loc3:CharacterSkin = null;
			var loc1:XMLList = this.data.ItemCosts.ItemCost;
			for each(loc2 in loc1) {
				loc3 = this.model.getCharacterSkin(loc2.@type);
				if (loc3) {
					loc3.cost = int(loc2);
					loc3.limited = Boolean(int(loc2.@expires));
					if (!Boolean(int(loc2.@purchasable)) && loc3.id != 0) {
						loc3.setState(CharacterSkinState.UNLISTED);
					}
				} else {
					this.logger.warn("Cannot set Character Skin cost: type {0} not found", [loc2.@type]);
				}
			}
		}

		private function parseOwnership():void {
			var loc2:int = 0;
			var loc3:CharacterSkin = null;
			var loc1:Array = !!this.data.OwnedSkins.length() ? this.data.OwnedSkins.split(",") : [];
			for each(loc2 in loc1) {
				loc3 = this.model.getCharacterSkin(loc2);
				if (loc3) {
					loc3.setState(CharacterSkinState.OWNED);
				} else {
					this.logger.warn("Cannot set Character Skin ownership: type {0} not found", [loc2]);
				}
			}
		}
	}
}
