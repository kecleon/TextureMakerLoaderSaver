 
package kabam.rotmg.characters.deletion.view {
	import com.company.assembleegameclient.ui.dialogs.Dialog;
	import flash.display.Sprite;
	import flash.events.Event;
	import kabam.rotmg.text.model.TextKey;
	import org.osflash.signals.Signal;
	
	public class ConfirmDeleteCharacterDialog extends Sprite {
		 
		
		private const CANCEL_EVENT:String = Dialog.LEFT_BUTTON;
		
		private const DELETE_EVENT:String = Dialog.RIGHT_BUTTON;
		
		public var deleteCharacter:Signal;
		
		public var cancel:Signal;
		
		public function ConfirmDeleteCharacterDialog() {
			super();
			this.deleteCharacter = new Signal();
			this.cancel = new Signal();
		}
		
		public function setText(param1:String, param2:String) : void {
			var loc3:Dialog = new Dialog(TextKey.CONFIRMDELETE_VERIFYDELETION,"",TextKey.CONFIRMDELETE_CANCEL,TextKey.CONFIRMDELETE_DELETE,"/deleteDialog");
			loc3.setTextParams(TextKey.CONFIRMDELETECHARACTERDIALOG,{
				"name":param1,
				"displayID":param2
			});
			loc3.addEventListener(this.CANCEL_EVENT,this.onCancel);
			loc3.addEventListener(this.DELETE_EVENT,this.onDelete);
			addChild(loc3);
		}
		
		private function onCancel(param1:Event) : void {
			this.cancel.dispatch();
		}
		
		private function onDelete(param1:Event) : void {
			this.deleteCharacter.dispatch();
		}
	}
}
