package kabam.rotmg.account.core.view {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;

	import io.decagames.rotmg.pets.utils.PetsViewAssetFactory;

	import kabam.rotmg.pets.view.components.DialogCloseButton;
	import kabam.rotmg.pets.view.components.PopupWindowBackground;
	import kabam.rotmg.text.view.TextFieldDisplayConcrete;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;
	import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;

	import org.osflash.signals.Signal;

	public class EmptyFrame extends Sprite {

		public static const TEXT_MARGIN:int = 20;


		public var register:Signal;

		public var cancel:Signal;

		protected var modalWidth:Number;

		protected var modalHeight:Number;

		protected var closeButton:DialogCloseButton;

		protected var background:Sprite;

		protected var backgroundContainer:Sprite;

		protected var title:TextFieldDisplayConcrete;

		protected var desc:TextFieldDisplayConcrete;

		public function EmptyFrame(param1:int = 288, param2:int = 150, param3:String = "") {
			super();
			this.modalWidth = param1;
			this.modalHeight = param2;
			x = WebMain.STAGE.stageWidth / 2 - this.modalWidth / 2;
			y = WebMain.STAGE.stageHeight / 2 - this.modalHeight / 2;
			if (param3 != "") {
				this.setTitle(param3, true);
			}
			if (this.background == null) {
				this.backgroundContainer = new Sprite();
				this.background = this.makeModalBackground();
				this.backgroundContainer.addChild(this.background);
				addChild(this.backgroundContainer);
			}
			if (param3 != "") {
				this.setTitle(param3, true);
			}
		}

		private function onRemovedFromStage(param1:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
			if (this.closeButton != null) {
				this.closeButton.removeEventListener(MouseEvent.CLICK, this.onCloseClick);
			}
		}

		public function setWidth(param1:Number):void {
			this.modalWidth = param1;
			x = WebMain.STAGE.stageWidth / 2 - this.modalWidth / 2;
			this.refreshBackground();
		}

		public function setHeight(param1:Number):void {
			this.modalHeight = param1;
			y = WebMain.STAGE.stageHeight / 2 - this.modalHeight / 2;
			this.refreshBackground();
		}

		public function setTitle(param1:String, param2:Boolean):void {
			if (this.title != null && this.title.parent != null) {
				removeChild(this.title);
			}
			if (param1 != null) {
				this.title = this.getText(param1, TEXT_MARGIN, 5, param2);
				addChild(this.title);
			} else {
				this.title = null;
			}
		}

		public function setDesc(param1:String, param2:Boolean):void {
			if (param1 != null) {
				if (this.desc != null && this.desc.parent != null) {
					removeChild(this.desc);
				}
				this.desc = this.getText(param1, TEXT_MARGIN, 50, param2);
				addChild(this.desc);
			}
		}

		public function setCloseButton(param1:Boolean):void {
			if (this.closeButton == null && param1) {
				this.closeButton = PetsViewAssetFactory.returnCloseButton(this.modalWidth);
				this.closeButton.addEventListener(MouseEvent.CLICK, this.onCloseClick);
				addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
				addChild(this.closeButton);
			} else if (this.closeButton != null && !param1) {
				removeChild(this.closeButton);
				this.closeButton = null;
			}
		}

		protected function getText(param1:String, param2:int, param3:int, param4:Boolean):TextFieldDisplayConcrete {
			var loc5:TextFieldDisplayConcrete = null;
			loc5 = new TextFieldDisplayConcrete().setSize(16).setColor(16777215).setTextWidth(this.modalWidth - TEXT_MARGIN * 2);
			loc5.setBold(true);
			if (param4) {
				loc5.setStringBuilder(new StaticStringBuilder(param1));
			} else {
				loc5.setStringBuilder(new LineBuilder().setParams(param1));
			}
			loc5.setWordWrap(true);
			loc5.setMultiLine(true);
			loc5.setAutoSize(TextFieldAutoSize.CENTER);
			loc5.setHorizontalAlign(TextFormatAlign.CENTER);
			loc5.filters = [new DropShadowFilter(0, 0, 0)];
			loc5.x = param2;
			loc5.y = param3;
			return loc5;
		}

		protected function makeModalBackground():Sprite {
			x = WebMain.STAGE.stageWidth / 2 - this.modalWidth / 2;
			y = WebMain.STAGE.stageHeight / 2 - this.modalHeight / 2;
			var loc1:PopupWindowBackground = new PopupWindowBackground();
			loc1.draw(this.modalWidth, this.modalHeight, PopupWindowBackground.TYPE_DEFAULT_GREY);
			if (this.title != null) {
				loc1.divide(PopupWindowBackground.HORIZONTAL_DIVISION, 30);
			}
			return loc1;
		}

		public function alignAssets():void {
			this.desc.setTextWidth(this.modalWidth - TEXT_MARGIN * 2);
			this.title.setTextWidth(this.modalWidth - TEXT_MARGIN * 2);
		}

		protected function refreshBackground():void {
			this.backgroundContainer.removeChild(this.background);
			this.background = this.makeModalBackground();
			this.backgroundContainer.addChild(this.background);
		}

		public function onCloseClick(param1:MouseEvent):void {
		}
	}
}
