 
package kabam.rotmg.editor.view.components.loaddialog.events {
	import flash.events.Event;
	
	public class DeletePictureEvent extends Event {
		
		public static const DELETE_PICTURE_EVENT:String = "DELETE_PICTURE_EVENT";
		 
		
		public var name_:String;
		
		public var id_:String;
		
		public function DeletePictureEvent(param1:String, param2:String) {
			super(DELETE_PICTURE_EVENT,true);
			this.name_ = param1;
			this.id_ = param2;
		}
	}
}
