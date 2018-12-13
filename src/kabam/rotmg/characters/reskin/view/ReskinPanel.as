package kabam.rotmg.characters.reskin.view {
	import com.company.assembleegameclient.game.GameSprite;
	import com.company.assembleegameclient.parameters.Parameters;
	import com.company.assembleegameclient.ui.DeprecatedTextButton;
	import com.company.assembleegameclient.ui.panels.Panel;

	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextFieldAutoSize;

	import kabam.rotmg.text.model.TextKey;
	import kabam.rotmg.text.view.TextFieldDisplayConcrete;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;

	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeMappedSignal;

	public class ReskinPanel extends Panel {


		private const title:TextFieldDisplayConcrete = this.makeTitle();

		private const button:DeprecatedTextButton = this.makeButton();

		private const click:Signal = new NativeMappedSignal(this.button, MouseEvent.CLICK);

		public const reskin:Signal = new Signal();

		public function ReskinPanel(param1:GameSprite = null) {
			super(param1);
			this.click.add(this.onClick);
			addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
		}

		private function onClick():void {
			this.reskin.dispatch();
		}

		private function makeTitle():TextFieldDisplayConcrete {
			var loc1:TextFieldDisplayConcrete = null;
			loc1 = new TextFieldDisplayConcrete().setSize(18).setColor(16777215).setAutoSize(TextFieldAutoSize.CENTER);
			loc1.x = int(WIDTH / 2);
			loc1.y = 6;
			loc1.setBold(true);
			loc1.filters = [new DropShadowFilter(0, 0, 0)];
			loc1.setStringBuilder(new LineBuilder().setParams(TextKey.RESKINPANEL_CHANGESKIN));
			addChild(loc1);
			return loc1;
		}

		private function makeButton():DeprecatedTextButton {
			var loc1:DeprecatedTextButton = new DeprecatedTextButton(16, TextKey.RESKINPANEL_CHOOSE);
			loc1.textChanged.addOnce(this.onTextSet);
			addChild(loc1);
			return loc1;
		}

		private function onTextSet():void {
			this.button.x = int(WIDTH / 2 - this.button.width / 2);
			this.button.y = HEIGHT - this.button.height - 4;
		}

		private function onAddedToStage(param1:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
		}

		private function onRemovedFromStage(param1:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
		}

		private function onKeyDown(param1:KeyboardEvent):void {
			if (param1.keyCode == Parameters.data_.interact && stage.focus == null) {
				this.reskin.dispatch();
			}
		}
	}
}
