 
package kabam.rotmg.core.commands {
	import com.company.assembleegameclient.objects.ObjectLibrary;
	import io.decagames.rotmg.pets.data.PetsModel;
	import io.decagames.rotmg.pets.data.vo.PetVO;
	import io.decagames.rotmg.pets.data.yard.PetYardEnum;
	import robotlegs.bender.bundles.mvcs.Command;
	
	public class UpdatePetsModelCommand extends Command {
		 
		
		[Inject]
		public var model:PetsModel;
		
		[Inject]
		public var data:XML;
		
		public function UpdatePetsModelCommand() {
			super();
		}
		
		override public function execute() : void {
			if(this.data.Account.hasOwnProperty("PetYardType")) {
				this.model.setPetYardType(this.parseYardFromXML());
			}
			if(this.data.hasOwnProperty("Pet")) {
				this.model.setActivePet(this.parsePetFromXML());
			}
		}
		
		private function parseYardFromXML() : int {
			var loc1:String = PetYardEnum.selectByOrdinal(this.data.Account.PetYardType).value;
			var loc2:XML = ObjectLibrary.getXMLfromId(loc1);
			return loc2.@type;
		}
		
		private function parsePetFromXML() : PetVO {
			var loc1:XMLList = this.data.Pet;
			var loc2:PetVO = this.model.getPetVO(loc1.@instanceId);
			loc2.apply(loc1[0]);
			return loc2;
		}
	}
}
