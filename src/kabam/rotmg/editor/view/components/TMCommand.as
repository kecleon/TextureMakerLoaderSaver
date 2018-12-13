 
package kabam.rotmg.editor.view.components {
	import com.company.assembleegameclient.editor.Command;
	import com.company.color.HSV;
	import kabam.rotmg.editor.view.components.drawer.Pixel;
	
	public class TMCommand extends Command {
		 
		
		public var pixel_:Pixel;
		
		public var prevHSV_:HSV;
		
		public var newHSV_:HSV;
		
		public function TMCommand(param1:Pixel, param2:HSV, param3:HSV) {
			super();
			this.pixel_ = param1;
			this.prevHSV_ = param2 != null?param2.clone():null;
			this.newHSV_ = param3 != null?param3.clone():null;
		}
		
		override public function execute() : void {
			this.pixel_.setHSV(this.newHSV_);
		}
		
		override public function unexecute() : void {
			this.pixel_.setHSV(this.prevHSV_);
		}
	}
}
