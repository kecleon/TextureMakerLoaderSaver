package kabam.rotmg.characters.reskin.view {
	import com.company.assembleegameclient.ui.DeprecatedTextButton;

	import flash.display.CapsStyle;
	import flash.display.DisplayObject;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;

	import kabam.rotmg.classes.view.CharacterSkinListView;
	import kabam.rotmg.text.model.TextKey;
	import kabam.rotmg.text.view.TextFieldDisplayConcrete;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;
	import kabam.rotmg.ui.view.SignalWaiter;
	import kabam.rotmg.util.components.DialogBackground;
	import kabam.rotmg.util.graphics.ButtonLayoutHelper;

	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeMappedSignal;

	public class ReskinCharacterView extends Sprite {

		private static const MARGIN:int = 10;

		private static const DIALOG_WIDTH:int = CharacterSkinListView.WIDTH + MARGIN * 2;

		private static const BUTTON_WIDTH:int = 120;

		private static const BUTTON_FONT:int = 16;

		private static const BUTTONS_HEIGHT:int = 40;

		private static const TITLE_OFFSET:int = 27;


		private const layoutListener:SignalWaiter = this.makeLayoutWaiter();

		private const background:DialogBackground = this.makeBackground();

		private const title:TextFieldDisplayConcrete = this.makeTitle();

		private const list:CharacterSkinListView = this.makeListView();

		private const cancel:DeprecatedTextButton = this.makeCancelButton();

		private const select:DeprecatedTextButton = this.makeSelectButton();

		public const cancelled:Signal = new NativeMappedSignal(this.cancel, MouseEvent.CLICK);

		public const selected:Signal = new NativeMappedSignal(this.select, MouseEvent.CLICK);

		public var viewHeight:int;

		public function ReskinCharacterView() {
			super();
		}

		private function makeLayoutWaiter():SignalWaiter {
			var loc1:SignalWaiter = new SignalWaiter();
			loc1.complete.add(this.positionButtons);
			return loc1;
		}

		private function makeBackground():DialogBackground {
			var loc1:DialogBackground = new DialogBackground();
			addChild(loc1);
			return loc1;
		}

		private function makeTitle():TextFieldDisplayConcrete {
			var loc1:TextFieldDisplayConcrete = new TextFieldDisplayConcrete().setSize(18).setColor(11974326).setTextWidth(DIALOG_WIDTH);
			loc1.setAutoSize(TextFieldAutoSize.CENTER).setBold(true);
			loc1.setStringBuilder(new LineBuilder().setParams(TextKey.RESKINCHARACTERVIEW_TITLE));
			loc1.y = MARGIN * 0.5;
			addChild(loc1);
			return loc1;
		}

		private function makeListView():CharacterSkinListView {
			var loc1:CharacterSkinListView = null;
			loc1 = new CharacterSkinListView();
			loc1.x = MARGIN;
			loc1.y = MARGIN + TITLE_OFFSET;
			addChild(loc1);
			return loc1;
		}

		private function makeCancelButton():DeprecatedTextButton {
			var loc1:DeprecatedTextButton = new DeprecatedTextButton(BUTTON_FONT, TextKey.RESKINCHARACTERVIEW_CANCEL, BUTTON_WIDTH);
			addChild(loc1);
			this.layoutListener.push(loc1.textChanged);
			return loc1;
		}

		private function makeSelectButton():DeprecatedTextButton {
			var loc1:DeprecatedTextButton = new DeprecatedTextButton(BUTTON_FONT, TextKey.RESKINCHARACTERVIEW_SELECT, BUTTON_WIDTH);
			addChild(loc1);
			this.layoutListener.push(loc1.textChanged);
			return loc1;
		}

		public function setList(param1:Vector.<DisplayObject>):void {
			this.list.setItems(param1);
			this.getDialogHeight();
			this.resizeBackground();
			this.positionButtons();
		}

		private function getDialogHeight():void {
			this.viewHeight = Math.min(CharacterSkinListView.HEIGHT + MARGIN, this.list.getListHeight());
			this.viewHeight = this.viewHeight + (BUTTONS_HEIGHT + MARGIN * 2 + TITLE_OFFSET);
		}

		private function resizeBackground():void {
			this.background.draw(DIALOG_WIDTH, this.viewHeight);
			this.background.graphics.lineStyle(2, 5987163, 1, false, LineScaleMode.NONE, CapsStyle.NONE, JointStyle.BEVEL);
			this.background.graphics.moveTo(1, TITLE_OFFSET);
			this.background.graphics.lineTo(DIALOG_WIDTH - 1, TITLE_OFFSET);
		}

		private function positionButtons():void {
			var loc1:ButtonLayoutHelper = new ButtonLayoutHelper();
			loc1.layout(DIALOG_WIDTH, this.cancel, this.select);
			this.cancel.y = this.select.y = this.viewHeight - BUTTONS_HEIGHT;
		}
	}
}
