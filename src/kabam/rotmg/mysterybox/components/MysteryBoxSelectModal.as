package kabam.rotmg.mysterybox.components {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;

	import io.decagames.rotmg.pets.utils.PetsViewAssetFactory;

	import kabam.rotmg.core.StaticInjectorContext;
	import kabam.rotmg.mysterybox.model.MysteryBoxInfo;
	import kabam.rotmg.mysterybox.services.MysteryBoxModel;
	import kabam.rotmg.pets.view.components.DialogCloseButton;
	import kabam.rotmg.pets.view.components.PopupWindowBackground;
	import kabam.rotmg.text.view.TextFieldDisplayConcrete;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;

	import org.swiftsuspenders.Injector;

	public class MysteryBoxSelectModal extends Sprite {

		public static var modalWidth:int;

		public static var modalHeight:int;

		public static var aMysteryBoxHeight:int;

		public static const TEXT_MARGIN:int = 20;

		public static var open:Boolean;

		public static var backgroundImageEmbed:Class = MysteryBoxSelectModal_backgroundImageEmbed;


		private var closeButton:DialogCloseButton;

		private var box_:Sprite;

		private var mysteryData:Object;

		private var titleString:String = "MysteryBoxSelectModal.titleString";

		private var selectEntries:Vector.<MysteryBoxSelectEntry>;

		public function MysteryBoxSelectModal() {
			this.box_ = new Sprite();
			super();
			modalWidth = 385;
			modalHeight = 60;
			aMysteryBoxHeight = 77;
			this.selectEntries = new Vector.<MysteryBoxSelectEntry>();
			var loc1:Injector = StaticInjectorContext.getInjector();
			var loc2:MysteryBoxModel = loc1.getInstance(MysteryBoxModel);
			this.mysteryData = loc2.getBoxesOrderByWeight();
			addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
			addChild(this.box_);
			this.addBoxChildren();
			this.positionAndStuff();
			open = true;
		}

		public static function getRightBorderX():int {
			return 300 + modalWidth / 2;
		}

		private static function makeModalBackground(param1:int, param2:int):PopupWindowBackground {
			var loc3:PopupWindowBackground = new PopupWindowBackground();
			loc3.draw(param1, param2, PopupWindowBackground.TYPE_TRANSPARENT_WITH_HEADER);
			return loc3;
		}

		public function getText(param1:String, param2:int, param3:int):TextFieldDisplayConcrete {
			var loc4:TextFieldDisplayConcrete = new TextFieldDisplayConcrete().setSize(16).setColor(16777215).setTextWidth(modalWidth - TEXT_MARGIN * 2);
			loc4.setBold(true);
			loc4.setStringBuilder(new LineBuilder().setParams(param1));
			loc4.setWordWrap(true);
			loc4.setMultiLine(true);
			loc4.setAutoSize(TextFieldAutoSize.CENTER);
			loc4.setHorizontalAlign(TextFormatAlign.CENTER);
			loc4.filters = [new DropShadowFilter(0, 0, 0)];
			loc4.x = param2;
			loc4.y = param3;
			return loc4;
		}

		private function positionAndStuff():void {
			this.box_.x = 600 / 2 - modalWidth / 2;
			this.box_.y = WebMain.STAGE.stageHeight / 2 - modalHeight / 2;
		}

		private function addBoxChildren():void {
			var loc1:MysteryBoxInfo = null;
			var loc2:DisplayObject = null;
			var loc4:Number = NaN;
			var loc5:int = 0;
			var loc6:MysteryBoxSelectEntry = null;
			for each(loc1 in this.mysteryData) {
				modalHeight = modalHeight + aMysteryBoxHeight;
			}
			loc2 = new backgroundImageEmbed();
			loc2.width = modalWidth + 1;
			loc2.height = modalHeight - 25;
			loc2.y = 27;
			loc2.alpha = 0.95;
			this.box_.addChild(loc2);
			this.box_.addChild(makeModalBackground(modalWidth, modalHeight));
			this.closeButton = PetsViewAssetFactory.returnCloseButton(modalWidth);
			this.box_.addChild(this.closeButton);
			this.box_.addChild(this.getText(this.titleString, TEXT_MARGIN, 6).setSize(18));
			var loc3:Number = 20;
			loc4 = 50;
			loc5 = 0;
			for each(loc1 in this.mysteryData) {
				if (loc5 == 6) {
					break;
				}
				loc6 = new MysteryBoxSelectEntry(loc1);
				loc6.x = x + loc3;
				loc6.y = y + loc4;
				loc4 = loc4 + aMysteryBoxHeight;
				this.box_.addChild(loc6);
				this.selectEntries.push(loc6);
				loc5++;
			}
		}

		public function updateContent():void {
			var loc1:MysteryBoxSelectEntry = null;
			for each(loc1 in this.selectEntries) {
				loc1.updateContent();
			}
		}

		private function onRemovedFromStage(param1:Event):void {
			open = false;
		}
	}
}
