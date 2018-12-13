package kabam.rotmg.arena.service {
	import com.company.util.ConversionUtil;

	import io.decagames.rotmg.pets.data.vo.PetVO;

	import kabam.rotmg.arena.model.ArenaLeaderboardEntry;
	import kabam.rotmg.arena.model.CurrentArenaRunModel;
	import kabam.rotmg.assets.services.CharacterFactory;
	import kabam.rotmg.classes.model.CharacterClass;
	import kabam.rotmg.classes.model.CharacterSkin;
	import kabam.rotmg.classes.model.ClassesModel;

	public class ArenaLeaderboardFactory {


		[Inject]
		public var classesModel:ClassesModel;

		[Inject]
		public var factory:CharacterFactory;

		[Inject]
		public var currentRunModel:CurrentArenaRunModel;

		public function ArenaLeaderboardFactory() {
			super();
		}

		public function makeEntries(param1:XMLList):Vector.<ArenaLeaderboardEntry> {
			var loc4:XML = null;
			var loc2:Vector.<ArenaLeaderboardEntry> = new Vector.<ArenaLeaderboardEntry>();
			var loc3:int = 1;
			for each(loc4 in param1) {
				loc2.push(this.makeArenaEntry(loc4, loc3));
				loc3++;
			}
			loc2 = this.removeDuplicateUser(loc2);
			loc2 = this.addCurrentRun(loc2);
			return loc2;
		}

		private function addCurrentRun(param1:Vector.<ArenaLeaderboardEntry>):Vector.<ArenaLeaderboardEntry> {
			var loc3:Boolean = false;
			var loc4:Boolean = false;
			var loc5:ArenaLeaderboardEntry = null;
			var loc2:Vector.<ArenaLeaderboardEntry> = new Vector.<ArenaLeaderboardEntry>();
			if (this.currentRunModel.hasEntry()) {
				loc3 = false;
				loc4 = false;
				for each(loc5 in param1) {
					if (!loc3 && this.currentRunModel.entry.isBetterThan(loc5)) {
						this.currentRunModel.entry.rank = loc5.rank;
						loc2.push(this.currentRunModel.entry);
						loc3 = true;
					}
					if (loc5.isPersonalRecord) {
						loc4 = true;
					}
					if (loc3) {
						loc5.rank++;
					}
					loc2.push(loc5);
				}
				if (loc2.length < 20 && !loc3 && !loc4) {
					this.currentRunModel.entry.rank = loc2.length + 1;
					loc2.push(this.currentRunModel.entry);
				}
			}
			return loc2.length > 0 ? loc2 : param1;
		}

		private function removeDuplicateUser(param1:Vector.<ArenaLeaderboardEntry>):Vector.<ArenaLeaderboardEntry> {
			var loc3:Boolean = false;
			var loc4:ArenaLeaderboardEntry = null;
			var loc5:ArenaLeaderboardEntry = null;
			var loc2:int = -1;
			if (this.currentRunModel.hasEntry()) {
				loc3 = false;
				loc4 = this.currentRunModel.entry;
				for each(loc5 in param1) {
					if (loc5.isPersonalRecord && loc4.isBetterThan(loc5)) {
						loc2 = loc5.rank - 1;
						loc3 = true;
					} else if (loc3) {
						loc5.rank--;
					}
				}
			}
			if (loc2 != -1) {
				param1.splice(loc2, 1);
			}
			return param1;
		}

		private function makeArenaEntry(param1:XML, param2:int):ArenaLeaderboardEntry {
			var loc10:PetVO = null;
			var loc11:XML = null;
			var loc3:ArenaLeaderboardEntry = new ArenaLeaderboardEntry();
			loc3.isPersonalRecord = param1.hasOwnProperty("IsPersonalRecord");
			loc3.runtime = param1.Time;
			loc3.name = param1.PlayData.CharacterData.Name;
			loc3.rank = !!param1.hasOwnProperty("Rank") ? int(param1.Rank) : int(param2);
			var loc4:int = param1.PlayData.CharacterData.Texture;
			var loc5:int = param1.PlayData.CharacterData.Class;
			var loc6:CharacterClass = this.classesModel.getCharacterClass(loc5);
			var loc7:CharacterSkin = loc6.skins.getSkin(loc4);
			var loc8:int = !!param1.PlayData.CharacterData.hasOwnProperty("Tex1") ? int(param1.PlayData.CharacterData.Tex1) : 0;
			var loc9:int = !!param1.PlayData.CharacterData.hasOwnProperty("Tex2") ? int(param1.PlayData.CharacterData.Tex2) : 0;
			loc3.playerBitmap = this.factory.makeIcon(loc7.template, !!loc7.is16x16 ? 50 : 100, loc8, loc9);
			loc3.equipment = ConversionUtil.toIntVector(param1.PlayData.CharacterData.Inventory);
			loc3.slotTypes = loc6.slotTypes;
			loc3.guildName = param1.PlayData.CharacterData.GuildName;
			loc3.guildRank = param1.PlayData.CharacterData.GuildRank;
			loc3.currentWave = param1.WaveNumber;
			if (param1.PlayData.hasOwnProperty("Pet")) {
				loc10 = new PetVO();
				loc11 = new XML(param1.PlayData.Pet);
				loc10.apply(loc11);
				loc3.pet = loc10;
			}
			return loc3;
		}
	}
}
