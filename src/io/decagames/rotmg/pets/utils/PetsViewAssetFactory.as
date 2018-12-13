 
package io.decagames.rotmg.pets.utils {
	import com.company.assembleegameclient.objects.ObjectLibrary;
	import com.company.assembleegameclient.ui.LineBreakDesign;
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.filters.DropShadowFilter;
	import kabam.rotmg.pets.view.components.DialogCloseButton;
	import kabam.rotmg.text.view.TextFieldDisplayConcrete;
	
	public class PetsViewAssetFactory {
		 
		
		public function PetsViewAssetFactory() {
			super();
		}
		
		public static function returnPetSlotShape(param1:uint, param2:uint, param3:int, param4:Boolean, param5:Boolean, param6:int = 2) : Shape {
			var loc7:Shape = new Shape();
			param4 && loc7.graphics.beginFill(4605510,1);
			param5 && loc7.graphics.lineStyle(param6,param2);
			loc7.graphics.drawRoundRect(0,param3,param1,param1,16,16);
			loc7.x = (100 - param1) * 0.5;
			return loc7;
		}
		
		public static function returnCloseButton(param1:int) : DialogCloseButton {
			var loc2:DialogCloseButton = null;
			loc2 = new DialogCloseButton();
			loc2.y = 4;
			loc2.x = param1 - loc2.width - 5;
			return loc2;
		}
		
		public static function returnTooltipLineBreak() : LineBreakDesign {
			var loc1:LineBreakDesign = new LineBreakDesign(173,0);
			loc1.x = 5;
			loc1.y = 92;
			return loc1;
		}
		
		public static function returnBitmap(param1:uint, param2:uint = 80) : Bitmap {
			return new Bitmap(ObjectLibrary.getRedrawnTextureFromType(param1,param2,true));
		}
		
		public static function returnCaretakerBitmap(param1:uint) : Bitmap {
			return new Bitmap(ObjectLibrary.getRedrawnTextureFromType(param1,80,true,true,10));
		}
		
		public static function returnTextfield(param1:int, param2:int, param3:Boolean, param4:Boolean = false) : TextFieldDisplayConcrete {
			var loc5:TextFieldDisplayConcrete = new TextFieldDisplayConcrete();
			loc5.setSize(param2).setColor(param1).setBold(param3);
			loc5.setVerticalAlign(TextFieldDisplayConcrete.BOTTOM);
			loc5.filters = !!param4?[new DropShadowFilter(0,0,0)]:[];
			return loc5;
		}
	}
}
