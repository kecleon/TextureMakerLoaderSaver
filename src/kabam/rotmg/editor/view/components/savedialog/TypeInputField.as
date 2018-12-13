package kabam.rotmg.editor.view.components.savedialog {
	import com.company.ui.BaseSimpleText;

	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;

	public class TypeInputField extends Sprite {

		public static const HEIGHT:int = 88;


		public var nameText_:BaseSimpleText;

		public var typeDropDown_:TypeDropDown;

		public function TypeInputField(param1:Vector.<int>, param2:int) {
			super();
			this.typeDropDown_ = new TypeDropDown(param1);
			this.typeDropDown_.setType(param2);
			this.typeDropDown_.x = 80;
			addChild(this.typeDropDown_);
			this.nameText_ = new BaseSimpleText(18, 11776947, false, 0, 0);
			this.nameText_.setBold(true);
			this.nameText_.text = "Type: ";
			this.nameText_.updateMetrics();
			this.nameText_.filters = [new DropShadowFilter(0, 0, 0)];
			this.nameText_.y = this.typeDropDown_.height / 2 - this.nameText_.height / 2;
			addChild(this.nameText_);
		}

		public function getType():int {
			return this.typeDropDown_.getType();
		}
	}
}
