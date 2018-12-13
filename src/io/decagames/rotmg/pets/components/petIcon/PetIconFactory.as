 
package io.decagames.rotmg.pets.components.petIcon {
	import com.company.assembleegameclient.util.TextureRedrawer;
	import com.company.assembleegameclient.util.redrawers.GlowRedrawer;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import io.decagames.rotmg.pets.data.vo.IPetVO;
	import io.decagames.rotmg.pets.data.vo.PetVO;
	
	public class PetIconFactory {
		 
		
		public var outlineSize:Number = 1.4;
		
		public function PetIconFactory() {
			super();
		}
		
		public function create(param1:PetVO, param2:int) : PetIcon {
			var loc3:BitmapData = this.getPetSkinTexture(param1,param2);
			var loc4:Bitmap = new Bitmap(loc3);
			var loc5:PetIcon = new PetIcon(param1);
			loc5.setBitmap(loc4);
			return loc5;
		}
		
		public function getPetSkinTexture(param1:IPetVO, param2:int, param3:uint = 0) : BitmapData {
			var loc5:Number = NaN;
			var loc6:BitmapData = null;
			var loc4:BitmapData = !!param1.getSkinMaskedImage()?param1.getSkinMaskedImage().image_:null;
			if(loc4) {
				loc5 = 5 * (16 / loc4.width);
				loc6 = TextureRedrawer.resize(loc4,param1.getSkinMaskedImage().mask_,param2,true,0,0,loc5);
				loc6 = GlowRedrawer.outlineGlow(loc6,param3,this.outlineSize);
				return loc6;
			}
			return new BitmapDataSpy(param2,param2);
		}
	}
}
