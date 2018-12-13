 
package kabam.rotmg.classes.control {
	import com.company.assembleegameclient.objects.ObjectLibrary;
	import kabam.rotmg.assets.EmbeddedData;
	import kabam.rotmg.assets.model.CharacterTemplate;
	import kabam.rotmg.classes.model.CharacterClass;
	import kabam.rotmg.classes.model.CharacterSkin;
	import kabam.rotmg.classes.model.ClassesModel;
	
	public class ParseSkinsXmlCommand {
		 
		
		[Inject]
		public var model:ClassesModel;
		
		public function ParseSkinsXmlCommand() {
			super();
		}
		
		private static function parseNodeEquipment(param1:XML) : void {
			var loc2:XMLList = null;
			var loc3:XML = null;
			var loc4:int = 0;
			var loc5:int = 0;
			loc2 = param1.children();
			for each(loc3 in loc2) {
				if(loc3.attribute("skinType").length() != 0) {
					loc4 = int(loc3.@skinType);
					loc5 = 16766720;
					if(loc3.attribute("color").length() != 0) {
						loc5 = int(loc3.@color);
					}
					ObjectLibrary.skinSetXMLDataLibrary_[loc4] = loc3;
				}
			}
		}
		
		public function execute() : void {
			var loc1:XML = null;
			var loc2:XMLList = null;
			var loc3:XML = null;
			loc1 = EmbeddedData.skinsXML;
			loc2 = loc1.children();
			for each(loc3 in loc2) {
				this.parseNode(loc3);
			}
			loc1 = EmbeddedData.skinsEquipmentSetsXML;
			loc2 = loc1.children();
			for each(loc3 in loc2) {
				parseNodeEquipment(loc3);
			}
		}
		
		private function parseNode(param1:XML) : void {
			var loc2:String = param1.AnimatedTexture.File;
			var loc3:int = param1.AnimatedTexture.Index;
			var loc4:CharacterSkin = new CharacterSkin();
			loc4.id = param1.@type;
			loc4.name = param1.DisplayId == undefined?param1.@id:param1.DisplayId;
			loc4.unlockLevel = param1.UnlockLevel;
			if(param1.hasOwnProperty("NoSkinSelect")) {
				loc4.skinSelectEnabled = false;
			}
			if(param1.hasOwnProperty("UnlockSpecial")) {
				loc4.unlockSpecial = param1.UnlockSpecial;
			}
			loc4.template = new CharacterTemplate(loc2,loc3);
			if(loc2.indexOf("16") >= 0) {
				loc4.is16x16 = true;
			}
			var loc5:CharacterClass = this.model.getCharacterClass(param1.PlayerClassType);
			loc5.skins.addSkin(loc4);
		}
	}
}
