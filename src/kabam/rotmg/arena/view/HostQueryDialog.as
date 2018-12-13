package kabam.rotmg.arena.view {
	import com.company.assembleegameclient.ui.DeprecatedTextButton;

	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;

	import kabam.rotmg.arena.component.ArenaQueryDialogHost;
	import kabam.rotmg.arena.util.ArenaViewAssetFactory;
	import kabam.rotmg.pets.view.components.PopupWindowBackground;
	import kabam.rotmg.text.view.TextFieldDisplayConcrete;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;
	import kabam.rotmg.ui.view.SignalWaiter;
	import kabam.rotmg.util.graphics.ButtonLayoutHelper;

	import org.osflash.signals.natives.NativeSignal;

	public class HostQueryDialog extends Sprite {

		public static const WIDTH:int = 274;

		public static const HEIGHT:int = 338;

		public static const TITLE:String = "ArenaQueryPanel.title";

		public static const CLOSE:String = "Close.text";

		public static const QUERY:String = "ArenaQueryDialog.info";

		public static const BACK:String = "Screens.back";


		private const layoutWaiter:SignalWaiter = this.makeDeferredLayout();

		private const container:DisplayObjectContainer = this.makeContainer();

		private const background:PopupWindowBackground = this.makeBackground();

		private const host:ArenaQueryDialogHost = this.makeHost();

		private const title:TextFieldDisplayConcrete = this.makeTitle();

		private const backButton:DeprecatedTextButton = this.makeBackButton();

		public const backClick:NativeSignal = new NativeSignal(this.backButton, MouseEvent.CLICK);

		public function HostQueryDialog() {
			super();
		}

		private function makeDeferredLayout():SignalWaiter {
			var loc1:SignalWaiter = new SignalWaiter();
			loc1.complete.addOnce(this.onLayout);
			return loc1;
		}

		private function onLayout():void {
			var loc1:ButtonLayoutHelper = new ButtonLayoutHelper();
			loc1.layout(WIDTH, this.backButton);
		}

		private function makeContainer():DisplayObjectContainer {
			var loc1:Sprite = null;
			loc1 = new Sprite();
			loc1.x = (800 - WIDTH) / 2;
			loc1.y = (600 - HEIGHT) / 2;
			addChild(loc1);
			return loc1;
		}

		private function makeBackground():PopupWindowBackground {
			var loc1:PopupWindowBackground = new PopupWindowBackground();
			loc1.draw(WIDTH, HEIGHT);
			loc1.divide(PopupWindowBackground.HORIZONTAL_DIVISION, 34);
			this.container.addChild(loc1);
			return loc1;
		}

		private function makeHost():ArenaQueryDialogHost {
			var loc1:ArenaQueryDialogHost = null;
			loc1 = new ArenaQueryDialogHost();
			loc1.x = 20;
			loc1.y = 50;
			this.container.addChild(loc1);
			return loc1;
		}

		private function makeTitle():TextFieldDisplayConcrete {
			var loc1:TextFieldDisplayConcrete = null;
			loc1 = ArenaViewAssetFactory.returnTextfield(16777215, 18, true);
			loc1.setStringBuilder(new LineBuilder().setParams(TITLE));
			loc1.setAutoSize(TextFieldAutoSize.CENTER);
			loc1.x = WIDTH / 2;
			loc1.y = 24;
			this.container.addChild(loc1);
			return loc1;
		}

		private function makeBackButton():DeprecatedTextButton {
			var loc1:DeprecatedTextButton = null;
			loc1 = new DeprecatedTextButton(16, BACK, 80);
			this.container.addChild(loc1);
			this.layoutWaiter.push(loc1.textChanged);
			loc1.y = 292;
			return loc1;
		}

		private function makeCloseButton():DeprecatedTextButton {
			var loc1:DeprecatedTextButton = null;
			loc1 = new DeprecatedTextButton(16, CLOSE, 110);
			loc1.y = 292;
			this.container.addChild(loc1);
			this.layoutWaiter.push(loc1.textChanged);
			return loc1;
		}

		public function setHostIcon(param1:BitmapData):void {
			this.host.setHostIcon(param1);
		}
	}
}
