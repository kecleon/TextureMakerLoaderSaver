 
package kabam.rotmg.editor.view.components.loaddialog {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import kabam.rotmg.editor.model.TextureData;
	import org.osflash.signals.Signal;
	
	public class ResultsBoxes extends Sprite {
		 
		
		public const selected:Signal = new Signal();
		
		protected var resultBoxes_:Vector.<ResultsBox>;
		
		public var offset_:int;
		
		public var num_:int;
		
		protected var cols_:int;
		
		protected var rows_:int;
		
		public function ResultsBoxes(param1:XML, param2:int, param3:int) {
			var loc5:int = 0;
			var loc7:XML = null;
			var loc8:ResultsBox = null;
			this.resultBoxes_ = new Vector.<ResultsBox>();
			super();
			this.offset_ = int(param1.@offset);
			this.num_ = 0;
			this.cols_ = param2;
			this.rows_ = param3;
			var loc4:int = 0;
			loc5 = 0;
			var loc6:Boolean = param1.hasOwnProperty("Admin");
			for each(loc7 in param1.Pic) {
				loc8 = new ResultsBox(loc7,loc6);
				loc8.x = loc4 * ResultsBox.WIDTH;
				loc8.y = loc5 * ResultsBox.HEIGHT;
				loc8.addEventListener(MouseEvent.CLICK,this.onMouseClick);
				addChild(loc8);
				this.num_++;
				loc4 = (loc4 + 1) % param2;
				if(loc4 == 0) {
					loc5++;
					if(loc5 >= param3) {
						break;
					}
				}
			}
		}
		
		private function onMouseClick(param1:MouseEvent) : void {
			var loc3:TextureData = null;
			var loc2:ResultsBox = param1.target as ResultsBox;
			if(loc2.bitmapData_ != null) {
				loc3 = new TextureData();
				loc3.name = loc2.name_;
				loc3.type = loc2.pictureType_;
				loc3.tags = loc2.tags_;
				loc3.bitmapData = loc2.bitmapData_;
				this.selected.dispatch(loc3);
			}
		}
	}
}
