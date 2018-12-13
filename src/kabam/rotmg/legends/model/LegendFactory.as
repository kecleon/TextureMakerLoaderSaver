 
package kabam.rotmg.legends.model {
	import com.company.util.ConversionUtil;
	import kabam.rotmg.assets.services.CharacterFactory;
	import kabam.rotmg.classes.model.CharacterClass;
	import kabam.rotmg.classes.model.CharacterSkin;
	import kabam.rotmg.classes.model.ClassesModel;
	import kabam.rotmg.core.model.PlayerModel;
	
	public class LegendFactory {
		 
		
		[Inject]
		public var playerModel:PlayerModel;
		
		[Inject]
		public var classesModel:ClassesModel;
		
		[Inject]
		public var factory:CharacterFactory;
		
		private var ownAccountId:String;
		
		private var legends:Vector.<Legend>;
		
		public function LegendFactory() {
			super();
		}
		
		public function makeLegends(param1:XML) : Vector.<Legend> {
			this.ownAccountId = this.playerModel.getAccountId();
			this.legends = new Vector.<Legend>(0);
			this.makeLegendsFromList(param1.FameListElem,false);
			this.makeLegendsFromList(param1.MyFameListElem,true);
			return this.legends;
		}
		
		private function makeLegendsFromList(param1:XMLList, param2:Boolean) : void {
			var loc3:XML = null;
			var loc4:Legend = null;
			for each(loc3 in param1) {
				if(!this.legendsContains(loc3)) {
					loc4 = this.makeLegend(loc3);
					loc4.isOwnLegend = loc3.@accountId == this.ownAccountId;
					loc4.isFocus = param2;
					this.legends.push(loc4);
				}
			}
		}
		
		private function legendsContains(param1:XML) : Boolean {
			var loc2:Legend = null;
			for each(loc2 in this.legends) {
				if(loc2.accountId == param1.@accountId && loc2.charId == param1.@charId) {
					return true;
				}
			}
			return false;
		}
		
		public function makeLegend(param1:XML) : Legend {
			var loc2:int = param1.ObjectType;
			var loc3:int = param1.Texture;
			var loc4:CharacterClass = this.classesModel.getCharacterClass(loc2);
			var loc5:CharacterSkin = loc4.skins.getSkin(loc3);
			var loc6:int = !!param1.hasOwnProperty("Tex1")?int(param1.Tex1):0;
			var loc7:int = !!param1.hasOwnProperty("Tex2")?int(param1.Tex2):0;
			var loc8:int = !!loc5.is16x16?50:100;
			var loc9:Legend = new Legend();
			loc9.place = this.legends.length + 1;
			loc9.accountId = param1.@accountId;
			loc9.charId = param1.@charId;
			loc9.name = param1.Name;
			loc9.totalFame = param1.TotalFame;
			loc9.character = this.factory.makeIcon(loc5.template,loc8,loc6,loc7,loc9.place <= 10);
			loc9.equipmentSlots = loc4.slotTypes;
			loc9.equipment = ConversionUtil.toIntVector(param1.Equipment);
			return loc9;
		}
	}
}
