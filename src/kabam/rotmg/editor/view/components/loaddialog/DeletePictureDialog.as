 
package kabam.rotmg.editor.view.components.loaddialog {
	import com.company.assembleegameclient.ui.dialogs.Dialog;
	import kabam.rotmg.text.model.TextKey;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;
	
	public class DeletePictureDialog extends Dialog {
		 
		
		public var id_:String;
		
		public function DeletePictureDialog(param1:String, param2:String) {
			super(TextKey.DELETE_PICTURE_DIALOG_TITLE,"",TextKey.FRAME_CANCEL,TextKey.CONFIRMDELETE_DELETE,"/deletePicture");
			textText_.setStringBuilder(new LineBuilder().setParams(TextKey.DELETE_PICTURE_DIALOG_DESCRIPTION,{"name":param1}));
			this.id_ = param2;
		}
	}
}
