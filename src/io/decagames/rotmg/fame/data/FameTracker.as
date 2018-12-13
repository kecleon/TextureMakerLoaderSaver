 
package io.decagames.rotmg.fame.data {
	import com.company.assembleegameclient.appengine.SavedCharacter;
	import io.decagames.rotmg.characterMetrics.data.MetricsID;
	import io.decagames.rotmg.characterMetrics.tracker.CharactersMetricsTracker;
	import io.decagames.rotmg.fame.data.bonus.FameBonus;
	import io.decagames.rotmg.fame.data.bonus.FameBonusConfig;
	import io.decagames.rotmg.fame.data.bonus.FameBonusID;
	import kabam.rotmg.core.model.PlayerModel;
	import kabam.rotmg.ui.model.HUDModel;
	
	public class FameTracker {
		 
		
		[Inject]
		public var metrics:CharactersMetricsTracker;
		
		[Inject]
		public var hudModel:HUDModel;
		
		[Inject]
		public var player:PlayerModel;
		
		public function FameTracker() {
			super();
		}
		
		private function getFameBonus(param1:int, param2:int, param3:int) : FameBonus {
			var loc4:FameBonus = FameBonusConfig.getBonus(param2);
			var loc5:int = this.getCharacterLevel(param1);
			if(loc5 < loc4.level) {
				return null;
			}
			loc4.fameAdded = Math.floor(loc4.added * param3 / 100 + loc4.numAdded);
			return loc4;
		}
		
		private function getWellEquippedBonus(param1:int, param2:int) : FameBonus {
			var loc3:FameBonus = FameBonusConfig.getBonus(FameBonusID.WELL_EQUIPPED);
			loc3.fameAdded = Math.floor(param1 * param2 / 100);
			return loc3;
		}
		
		public function getCurrentTotalFame(param1:int) : TotalFame {
			var loc2:TotalFame = new TotalFame(this.currentFame(param1));
			var loc3:int = this.getCharacterLevel(param1);
			var loc4:int = this.getCharacterType(param1);
			if(this.player.getTotalFame() == 0) {
				loc2.addBonus(this.getFameBonus(param1,FameBonusID.ANCESTOR,loc2.currentFame));
			}
			if(this.metrics.getCharacterStat(param1,MetricsID.POTIONS_DRUNK) == 0) {
				loc2.addBonus(this.getFameBonus(param1,FameBonusID.THIRSTY,loc2.currentFame));
			}
			if(this.metrics.getCharacterStat(param1,MetricsID.SHOTS_THAT_DAMAGE) == 0) {
				loc2.addBonus(this.getFameBonus(param1,FameBonusID.PACIFIST,loc2.currentFame));
			}
			if(this.metrics.getCharacterStat(param1,MetricsID.SPECIAL_ABILITY_USES) == 0) {
				loc2.addBonus(this.getFameBonus(param1,FameBonusID.MUNDANE,loc2.currentFame));
			}
			if(this.metrics.getCharacterStat(param1,MetricsID.TELEPORTS) == 0) {
				loc2.addBonus(this.getFameBonus(param1,FameBonusID.BOOTS_ON_THE_GROUND,loc2.currentFame));
			}
			if(this.metrics.getCharacterStat(param1,MetricsID.PIRATE_CAVES_COMPLETED) > 0 && this.metrics.getCharacterStat(param1,MetricsID.UNDEAD_LAIRS_COMPLETED) > 0 && this.metrics.getCharacterStat(param1,MetricsID.ABYSS_OF_DEMONS_COMPLETED) > 0 && this.metrics.getCharacterStat(param1,MetricsID.SNAKE_PITS_COMPLETED) > 0 && this.metrics.getCharacterStat(param1,MetricsID.SPIDER_DENS_COMPLETED) > 0 && this.metrics.getCharacterStat(param1,MetricsID.SPRITE_WORLDS_COMPLETED) > 0 && this.metrics.getCharacterStat(param1,MetricsID.TOMBS_COMPLETED) > 0 && this.metrics.getCharacterStat(param1,MetricsID.TRENCHES_COMPLETED) > 0 && this.metrics.getCharacterStat(param1,MetricsID.JUNGLES_COMPLETED) > 0 && this.metrics.getCharacterStat(param1,MetricsID.MANORS_COMPLETED) > 0) {
				loc2.addBonus(this.getFameBonus(param1,FameBonusID.TUNNEL_RAT,loc2.currentFame));
			}
			var loc5:int = this.metrics.getCharacterStat(param1,MetricsID.MONSTER_KILLS);
			var loc6:int = this.metrics.getCharacterStat(param1,MetricsID.GOD_KILLS);
			if(loc5 + loc6 > 0) {
				if(loc6 / (loc5 + loc6) > 0.1) {
					loc2.addBonus(this.getFameBonus(param1,FameBonusID.ENEMY_OF_THE_GODS,loc2.currentFame));
				}
				if(loc6 / (loc5 + loc6) > 0.5) {
					loc2.addBonus(this.getFameBonus(param1,FameBonusID.SLAYER_OF_THE_GODS,loc2.currentFame));
				}
			}
			if(this.metrics.getCharacterStat(param1,MetricsID.ORYX_KILLS) > 0) {
				loc2.addBonus(this.getFameBonus(param1,FameBonusID.ORYX_SLAYER,loc2.currentFame));
			}
			var loc7:int = this.metrics.getCharacterStat(param1,MetricsID.SHOTS);
			var loc8:int = this.metrics.getCharacterStat(param1,MetricsID.SHOTS_THAT_DAMAGE);
			if(loc8 > 0 && loc7 > 0) {
				if(loc8 / loc7 > 0.25) {
					loc2.addBonus(this.getFameBonus(param1,FameBonusID.ACCURATE,loc2.currentFame));
				}
				if(loc8 / loc7 > 0.5) {
					loc2.addBonus(this.getFameBonus(param1,FameBonusID.SHARPSHOOTER,loc2.currentFame));
				}
				if(loc8 / loc7 > 0.75) {
					loc2.addBonus(this.getFameBonus(param1,FameBonusID.SNIPER,loc2.currentFame));
				}
			}
			if(this.metrics.getCharacterStat(param1,MetricsID.TILES_UNCOVERED) > 1000000) {
				loc2.addBonus(this.getFameBonus(param1,FameBonusID.EXPLORER,loc2.currentFame));
			}
			if(this.metrics.getCharacterStat(param1,MetricsID.TILES_UNCOVERED) > 4000000) {
				loc2.addBonus(this.getFameBonus(param1,FameBonusID.CARTOGRAPHER,loc2.currentFame));
			}
			if(this.metrics.getCharacterStat(param1,MetricsID.CUBE_KILLS) == 0) {
				loc2.addBonus(this.getFameBonus(param1,FameBonusID.FRIEND_OF_THE_CUBES,loc2.currentFame));
			}
			if(this.metrics.getCharacterStat(param1,MetricsID.LEVEL_UP_ASSISTS) > 100) {
				loc2.addBonus(this.getFameBonus(param1,FameBonusID.TEAM_PLAYER,loc2.currentFame));
			}
			if(this.metrics.getCharacterStat(param1,MetricsID.LEVEL_UP_ASSISTS) > 1000) {
				loc2.addBonus(this.getFameBonus(param1,FameBonusID.LEADER_OF_MEN,loc2.currentFame));
			}
			if(this.metrics.getCharacterStat(param1,MetricsID.QUESTS_COMPLETED) > 1000) {
				loc2.addBonus(this.getFameBonus(param1,FameBonusID.DOER_OF_DEEDS,loc2.currentFame));
			}
			loc2.addBonus(this.getWellEquippedBonus(this.getCharacterFameBonus(param1),loc2.currentFame));
			if(loc2.currentFame > this.player.getBestCharFame()) {
				loc2.addBonus(this.getFameBonus(param1,FameBonusID.FIRST_BORN,loc2.currentFame));
			}
			return loc2;
		}
		
		private function hasMapPlayer() : Boolean {
			return this.hudModel.gameSprite && this.hudModel.gameSprite.map && this.hudModel.gameSprite.map.player_;
		}
		
		private function getSavedCharacter(param1:int) : SavedCharacter {
			return this.player.getCharacterById(param1);
		}
		
		private function getCharacterExp(param1:int) : int {
			if(this.hasMapPlayer()) {
				return this.hudModel.gameSprite.map.player_.exp_;
			}
			return this.getSavedCharacter(param1).xp();
		}
		
		private function getCharacterLevel(param1:int) : int {
			if(this.hasMapPlayer()) {
				return this.hudModel.gameSprite.map.player_.level_;
			}
			return this.getSavedCharacter(param1).level();
		}
		
		private function getCharacterType(param1:int) : int {
			if(this.hasMapPlayer()) {
				return this.hudModel.gameSprite.map.player_.objectType_;
			}
			return this.getSavedCharacter(param1).objectType();
		}
		
		private function getCharacterFameBonus(param1:int) : int {
			if(this.hasMapPlayer()) {
				return this.hudModel.gameSprite.map.player_.getFameBonus();
			}
			return this.getSavedCharacter(param1).fameBonus();
		}
		
		public function currentFame(param1:int) : int {
			var loc2:int = this.metrics.getCharacterStat(param1,MetricsID.MINUTES_ACTIVE);
			var loc3:int = this.getCharacterExp(param1);
			var loc4:int = this.getCharacterLevel(param1);
			if(this.hasMapPlayer()) {
				loc3 = loc3 + (loc4 - 1) * (loc4 - 1) * 50;
			}
			return this.calculateBaseFame(loc3,loc2);
		}
		
		public function calculateBaseFame(param1:int, param2:int) : int {
			var loc3:Number = 0;
			loc3 = loc3 + Math.max(0,Math.min(20000,param1)) * 0.001;
			loc3 = loc3 + Math.max(0,Math.min(45200,param1) - 20000) * 0.002;
			loc3 = loc3 + Math.max(0,Math.min(80000,param1) - 45200) * 0.003;
			loc3 = loc3 + Math.max(0,Math.min(101200,param1) - 80000) * 0.002;
			loc3 = loc3 + Math.max(0,param1 - 101200) * 0.0005;
			loc3 = loc3 + Math.min(Math.floor(param2 / 6),30);
			return Math.floor(loc3);
		}
	}
}
