 
package io.decagames.rotmg.pets.utils {
	import io.decagames.rotmg.pets.components.petIcon.PetIcon;
	import io.decagames.rotmg.pets.components.petIcon.PetIconFactory;
	import io.decagames.rotmg.pets.components.petItem.PetItem;
	import io.decagames.rotmg.pets.data.vo.PetVO;
	
	public class PetItemFactory {
		 
		
		[Inject]
		public var petIconFactory:PetIconFactory;
		
		public function PetItemFactory() {
			super();
		}
		
		public function create(param1:PetVO, param2:int, param3:uint = 5526612, param4:Number = 1) : PetItem {
			var loc5:PetItem = new PetItem(param3);
			var loc6:PetIcon = this.petIconFactory.create(param1,param2);
			loc5.setPetIcon(loc6);
			loc5.setSize(param2);
			loc5.setBackground(PetItem.REGULAR,param3,param4);
			return loc5;
		}
	}
}
