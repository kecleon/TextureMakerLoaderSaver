 
package kabam.rotmg.editor.view.components.drawer {
	import com.company.util.BitmapUtil;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	public class AnimationDrawer extends PixelDrawer {
		 
		
		public var frameSelector_:FrameSelector;
		
		public var pixelDrawerDict_:Dictionary;
		
		private var selected_:ObjectDrawer = null;
		
		public function AnimationDrawer(param1:int, param2:int, param3:int, param4:int) {
			var loc5:String = null;
			var loc6:ObjectDrawer = null;
			this.pixelDrawerDict_ = new Dictionary();
			super();
			this.frameSelector_ = new FrameSelector();
			this.frameSelector_.x = param1 / 2 - this.frameSelector_.width / 2;
			this.frameSelector_.y = -28;
			this.frameSelector_.addEventListener(Event.CHANGE,this.onSelectedChange);
			addChild(this.frameSelector_);
			for each(loc5 in FrameSelector.FRAMES) {
				if(loc5 == FrameSelector.ATTACK2) {
					loc6 = new ObjectDrawer(param1,param2,param3 * 2,param4,true);
				} else {
					loc6 = new ObjectDrawer(param1,param2,param3,param4,true);
				}
				this.pixelDrawerDict_[loc5] = loc6;
			}
			this.selected_ = this.pixelDrawerDict_[this.frameSelector_.getSelected()];
			addChild(this.selected_);
		}
		
		override public function getBitmapData() : BitmapData {
			var loc1:BitmapData = this.pixelDrawerDict_[FrameSelector.STAND].getBitmapData();
			var loc2:int = loc1.width;
			var loc3:BitmapData = new BitmapDataSpy(loc2 * 7,loc1.height,true,0);
			loc3.copyPixels(loc1,loc1.rect,new Point(0,0));
			loc1 = this.pixelDrawerDict_[FrameSelector.WALK1].getBitmapData();
			loc3.copyPixels(loc1,loc1.rect,new Point(loc2,0));
			loc1 = this.pixelDrawerDict_[FrameSelector.WALK2].getBitmapData();
			loc3.copyPixels(loc1,loc1.rect,new Point(loc2 * 2,0));
			loc1 = this.pixelDrawerDict_[FrameSelector.ATTACK1].getBitmapData();
			loc3.copyPixels(loc1,loc1.rect,new Point(loc2 * 4,0));
			loc1 = this.pixelDrawerDict_[FrameSelector.ATTACK2].getBitmapData();
			loc3.copyPixels(loc1,loc1.rect,new Point(loc2 * 5,0));
			return loc3;
		}
		
		override public function loadBitmapData(param1:BitmapData) : void {
			var loc2:ObjectDrawer = null;
			var loc3:int = 0;
			var loc4:int = 0;
			if(param1.width <= 16) {
				loc2 = this.pixelDrawerDict_[FrameSelector.STAND];
				loc2.loadBitmapData(param1);
			} else {
				loc3 = param1.width / 7;
				loc4 = param1.height;
				this.pixelDrawerDict_[FrameSelector.STAND].loadBitmapData(BitmapUtil.cropToBitmapData(param1,0,0,loc3,loc4));
				this.pixelDrawerDict_[FrameSelector.WALK1].loadBitmapData(BitmapUtil.cropToBitmapData(param1,loc3,0,loc3,loc4));
				this.pixelDrawerDict_[FrameSelector.WALK2].loadBitmapData(BitmapUtil.cropToBitmapData(param1,loc3 * 2,0,loc3,loc4));
				this.pixelDrawerDict_[FrameSelector.ATTACK1].loadBitmapData(BitmapUtil.cropToBitmapData(param1,loc3 * 4,0,loc3,loc4));
				this.pixelDrawerDict_[FrameSelector.ATTACK2].loadBitmapData(BitmapUtil.cropToBitmapData(param1,loc3 * 5,0,loc3 * 2,loc4));
			}
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		override public function clear() : void {
			this.selected_.clear();
		}
		
		private function onSelectedChange(param1:Event) : void {
			var loc2:ObjectDrawer = null;
			if(this.selected_ != null) {
				removeChild(this.selected_);
			}
			this.selected_ = this.pixelDrawerDict_[this.frameSelector_.getSelected()];
			addChild(this.selected_);
			if(this.selected_.empty()) {
				loc2 = this.pixelDrawerDict_[FrameSelector.STAND];
				this.selected_.loadBitmapData(loc2.getBitmapData());
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
	}
}
