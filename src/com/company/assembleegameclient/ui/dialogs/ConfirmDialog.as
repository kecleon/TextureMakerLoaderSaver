 
package com.company.assembleegameclient.ui.dialogs {
	import flash.events.Event;
	import kabam.rotmg.core.StaticInjectorContext;
	import kabam.rotmg.dialogs.control.CloseDialogsSignal;
	
	public class ConfirmDialog extends StaticDialog {
		 
		
		private var _callback:Function;
		
		public function ConfirmDialog(param1:String, param2:String, param3:Function) {
			this._callback = param3;
			super(param1,param2,"Cancel","OK",null);
			addEventListener(Dialog.LEFT_BUTTON,this.onCancel);
			addEventListener(Dialog.RIGHT_BUTTON,this.onConfirm);
		}
		
		private function onConfirm(param1:Event) : void {
			this._callback();
			var loc2:CloseDialogsSignal = StaticInjectorContext.getInjector().getInstance(CloseDialogsSignal);
			loc2.dispatch();
		}
		
		private function onCancel(param1:Event) : void {
			var loc2:CloseDialogsSignal = StaticInjectorContext.getInjector().getInstance(CloseDialogsSignal);
			loc2.dispatch();
		}
	}
}
