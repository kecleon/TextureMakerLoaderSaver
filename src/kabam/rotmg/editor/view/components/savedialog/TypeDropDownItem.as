package kabam.rotmg.editor.view.components.savedialog {
	import com.company.ui.BaseSimpleText;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;

	import kabam.rotmg.editor.view.components.PictureType;

	public class TypeDropDownItem extends Sprite {

		public static const WIDTH:int = 260;

		public static const HEIGHT:int = 44;


		private var nameText_:BaseSimpleText;

		private var examplesText_:BaseSimpleText;

		public var type_:int = -1;

		public function TypeDropDownItem(param1:int) {
			super();
			this.type_ = param1;
			this.nameText_ = new BaseSimpleText(16, 11776947, false, 0, 0);
			this.nameText_.setBold(true);
			this.nameText_.text = param1 == PictureType.INVALID ? "Select Type" : PictureType.TYPES[param1].name_;
			this.nameText_.updateMetrics();
			this.nameText_.filters = [new DropShadowFilter(0, 0, 0)];
			this.nameText_.x = WIDTH / 2 - this.nameText_.width / 2;
			this.nameText_.y = 2;
			addChild(this.nameText_);
			var loc2:String = param1 == PictureType.INVALID ? null : PictureType.TYPES[param1].name_;
			if (loc2 != null) {
				this.examplesText_ = new BaseSimpleText(14, 11776947, false, 0, 0);
				this.examplesText_.text = PictureType.TYPES[param1].examples_;
				this.examplesText_.updateMetrics();
				this.examplesText_.filters = [new DropShadowFilter(0, 0, 0)];
				this.examplesText_.x = WIDTH / 2 - this.examplesText_.width / 2;
				this.examplesText_.y = 20;
				addChild(this.examplesText_);
			} else {
				this.nameText_.y = HEIGHT / 2 - this.nameText_.height / 2;
			}
			this.drawBackground(3552822);
			addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
		}

		private function onMouseOver(param1:MouseEvent):void {
			this.drawBackground(5658198);
		}

		private function onMouseOut(param1:MouseEvent):void {
			this.drawBackground(3552822);
		}

		private function drawBackground(param1:uint):void {
			graphics.clear();
			graphics.lineStyle(1, 11776947);
			graphics.beginFill(param1, 1);
			graphics.drawRect(0, 0, WIDTH, HEIGHT);
			graphics.endFill();
			graphics.lineStyle();
		}
	}
}
