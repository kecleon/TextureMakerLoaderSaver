 
package kabam.rotmg.classes.control {
	import kabam.rotmg.classes.model.CharacterClass;
	import kabam.rotmg.classes.model.CharacterSkin;
	import kabam.rotmg.classes.model.CharacterSkinState;
	import kabam.rotmg.classes.model.ClassesModel;
	
	public class ResetClassDataCommand {
		 
		
		[Inject]
		public var classes:ClassesModel;
		
		public function ResetClassDataCommand() {
			super();
		}
		
		public function execute() : void {
			var loc1:int = this.classes.getCount();
			var loc2:int = 0;
			while(loc2 < loc1) {
				this.resetClass(this.classes.getClassAtIndex(loc2));
				loc2++;
			}
		}
		
		private function resetClass(param1:CharacterClass) : void {
			param1.setIsSelected(param1.id == ClassesModel.WIZARD_ID);
			this.resetClassSkins(param1);
		}
		
		private function resetClassSkins(param1:CharacterClass) : void {
			var loc5:CharacterSkin = null;
			var loc2:CharacterSkin = param1.skins.getDefaultSkin();
			var loc3:int = param1.skins.getCount();
			var loc4:int = 0;
			while(loc4 < loc3) {
				loc5 = param1.skins.getSkinAt(loc4);
				if(loc5 != loc2) {
					this.resetSkin(param1.skins.getSkinAt(loc4));
				}
				loc4++;
			}
		}
		
		private function resetSkin(param1:CharacterSkin) : void {
			param1.setState(CharacterSkinState.LOCKED);
		}
	}
}
