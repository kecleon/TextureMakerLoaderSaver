 
package io.decagames.rotmg.ui.popups.modal {
	import io.decagames.rotmg.ui.buttons.BaseButton;
	import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
	import io.decagames.rotmg.ui.labels.UILabel;
	
	public class TextModal extends ModalPopup {
		 
		
		private var buttonsMargin:int = 30;
		
		public function TextModal(param1:int, param2:String, param3:String, param4:Vector.<BaseButton>, param5:Boolean = false) {
			var loc6:UILabel = null;
			var loc8:BaseButton = null;
			var loc9:int = 0;
			super(param1,0,param2);
			loc6 = new UILabel();
			loc6.multiline = true;
			DefaultLabelFormat.defaultTextModalText(loc6);
			loc6.multiline = true;
			loc6.width = param1;
			if(param5) {
				loc6.htmlText = param3;
			} else {
				loc6.text = param3;
			}
			loc6.wordWrap = true;
			addChild(loc6);
			var loc7:int = 0;
			for each(loc8 in param4) {
				loc7 = loc7 + loc8.width;
			}
			loc7 = loc7 + this.buttonsMargin * (param4.length - 1);
			loc9 = (param1 - loc7) / 2;
			for each(loc8 in param4) {
				loc8.x = loc9;
				loc9 = loc9 + (this.buttonsMargin + loc8.width);
				loc8.y = loc6.y + loc6.textHeight + 15;
				addChild(loc8);
				registerButton(loc8);
			}
		}
	}
}
