package io.decagames.rotmg.ui.popups.modal.error {
	import io.decagames.rotmg.ui.buttons.BaseButton;
	import io.decagames.rotmg.ui.popups.modal.TextModal;
	import io.decagames.rotmg.ui.popups.modal.buttons.ClosePopupButton;

	public class ErrorModal extends TextModal {


		public function ErrorModal(param1:int, param2:String, param3:String) {
			var loc4:Vector.<BaseButton> = new Vector.<BaseButton>();
			loc4.push(new ClosePopupButton("Ok"));
			super(param1, param2, param3, loc4);
		}
	}
}
