package kabam.rotmg.news.view {
	import com.company.assembleegameclient.ui.Scrollbar;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;

	import kabam.rotmg.core.StaticInjectorContext;
	import kabam.rotmg.text.model.FontModel;
	import kabam.rotmg.text.view.TextFieldDisplayConcrete;

	public class NewsModalPage extends Sprite {

		public static const TEXT_MARGIN:int = 22;

		public static const TEXT_MARGIN_HTML:int = 26;

		public static const TEXT_TOP_MARGIN_HTML:int = 40;

		private static const SCROLLBAR_WIDTH:int = 10;

		public static const WIDTH:int = 136;

		public static const HEIGHT:int = 310;


		protected var scrollBar_:Scrollbar;

		private var innerModalWidth:int;

		private var htmlText:TextField;

		public function NewsModalPage(param1:String, param2:String) {
			var loc4:Sprite = null;
			var loc5:Sprite = null;
			super();
			this.doubleClickEnabled = false;
			this.mouseEnabled = false;
			this.innerModalWidth = NewsModal.MODAL_WIDTH - 2 - TEXT_MARGIN_HTML * 2;
			this.htmlText = new TextField();
			var loc3:FontModel = StaticInjectorContext.getInjector().getInstance(FontModel);
			loc3.apply(this.htmlText, 16, 15792127, false, false);
			this.htmlText.width = this.innerModalWidth;
			this.htmlText.multiline = true;
			this.htmlText.wordWrap = true;
			this.htmlText.htmlText = param2;
			this.htmlText.filters = [new DropShadowFilter(0, 0, 0)];
			this.htmlText.height = this.htmlText.textHeight + 8;
			loc4 = new Sprite();
			loc4.addChild(this.htmlText);
			loc4.y = TEXT_TOP_MARGIN_HTML;
			loc4.x = TEXT_MARGIN_HTML;
			loc5 = new Sprite();
			loc5.graphics.beginFill(16711680);
			loc5.graphics.drawRect(0, 0, this.innerModalWidth, HEIGHT);
			loc5.x = TEXT_MARGIN_HTML;
			loc5.y = TEXT_TOP_MARGIN_HTML;
			addChild(loc5);
			loc4.mask = loc5;
			disableMouseOnText(this.htmlText);
			addChild(loc4);
			var loc6:TextFieldDisplayConcrete = NewsModal.getText(param1, TEXT_MARGIN, 6, true);
			addChild(loc6);
			if (this.htmlText.height >= HEIGHT) {
				this.scrollBar_ = new Scrollbar(SCROLLBAR_WIDTH, HEIGHT, 0.1, loc4);
				this.scrollBar_.x = NewsModal.MODAL_WIDTH - SCROLLBAR_WIDTH - 10;
				this.scrollBar_.y = TEXT_TOP_MARGIN_HTML;
				this.scrollBar_.setIndicatorSize(HEIGHT, loc4.height);
				addChild(this.scrollBar_);
			}
			this.addEventListener(Event.ADDED_TO_STAGE, this.onAddedHandler);
		}

		private static function disableMouseOnText(param1:TextField):void {
			param1.mouseWheelEnabled = false;
		}

		protected function onScrollBarChange(param1:Event):void {
			this.htmlText.y = -this.scrollBar_.pos() * (this.htmlText.height - HEIGHT);
		}

		private function onAddedHandler(param1:Event):void {
			this.addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
			if (this.scrollBar_) {
				this.scrollBar_.addEventListener(Event.CHANGE, this.onScrollBarChange);
			}
		}

		private function onRemovedFromStage(param1:Event):void {
			this.removeEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
			this.removeEventListener(Event.ADDED_TO_STAGE, this.onAddedHandler);
			if (this.scrollBar_) {
				this.scrollBar_.removeEventListener(Event.CHANGE, this.onScrollBarChange);
			}
		}
	}
}
