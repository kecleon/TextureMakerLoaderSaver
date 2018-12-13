 
package io.decagames.rotmg.pets.components.petSkinsCollection {
	import io.decagames.rotmg.pets.data.family.PetFamilyColors;
	import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
	import io.decagames.rotmg.ui.gird.UIGridElement;
	import io.decagames.rotmg.ui.labels.UILabel;
	import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
	import io.decagames.rotmg.ui.texture.TextureParser;
	import io.decagames.rotmg.utils.colors.Tint;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;
	
	public class PetFamilyContainer extends UIGridElement {
		 
		
		public function PetFamilyContainer(param1:String, param2:int, param3:int) {
			var loc5:SliceScalingBitmap = null;
			var loc6:UILabel = null;
			var loc7:SliceScalingBitmap = null;
			super();
			var loc4:uint = PetFamilyColors.KEYS_TO_COLORS[param1];
			loc5 = TextureParser.instance.getSliceScalingBitmap("UI","content_divider_white",320);
			Tint.add(loc5,loc4,1);
			addChild(loc5);
			loc5.x = 10;
			loc5.y = 3;
			loc6 = new UILabel();
			DefaultLabelFormat.petFamilyLabel(loc6,16777215);
			loc6.text = LineBuilder.getLocalizedStringFromKey(param1);
			loc6.y = 0;
			loc6.x = 320 / 2 - loc6.width / 2 + 10;
			loc7 = TextureParser.instance.getSliceScalingBitmap("UI","content_divider_smalltitle_white",loc6.width + 20);
			Tint.add(loc7,loc4,1);
			addChild(loc7);
			loc7.x = 320 / 2 - loc7.width / 2 + 10;
			loc7.y = 0;
			addChild(loc6);
		}
	}
}
