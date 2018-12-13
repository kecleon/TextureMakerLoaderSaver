package kabam.rotmg.dailyLogin.view {
	import com.company.assembleegameclient.ui.DeprecatedTextButtonStatic;
	import com.company.assembleegameclient.util.TextureRedrawer;
	import com.company.util.AssetLibrary;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;

	import kabam.rotmg.dailyLogin.config.CalendarSettings;
	import kabam.rotmg.dailyLogin.model.DailyLoginModel;
	import kabam.rotmg.mysterybox.components.MysteryBoxSelectModal;
	import kabam.rotmg.pets.view.components.DialogCloseButton;
	import kabam.rotmg.pets.view.components.PopupWindowBackground;
	import kabam.rotmg.text.view.TextFieldDisplayConcrete;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;
	import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;

	public class DailyLoginModal extends Sprite {


		private var content:Sprite;

		private var calendarView:CalendarView;

		private var titleTxt:TextFieldDisplayConcrete;

		private var serverTimeTxt:TextFieldDisplayConcrete;

		public var closeButton:DialogCloseButton;

		private var modalRectangle:Rectangle;

		private var daysLeft:int = 300;

		public var claimButton:DeprecatedTextButtonStatic;

		private var tabs:CalendarTabsView;

		public function DailyLoginModal() {
			this.calendarView = new CalendarView();
			this.closeButton = new DialogCloseButton();
			super();
		}

		public function init(param1:DailyLoginModel):void {
			this.daysLeft = param1.daysLeftToCalendarEnd;
			this.modalRectangle = CalendarSettings.getCalendarModalRectangle(param1.overallMaxDays, this.daysLeft < CalendarSettings.CLAIM_WARNING_BEFORE_DAYS);
			this.content = new Sprite();
			addChild(this.content);
			this.createModalBox();
			this.tabs = new CalendarTabsView();
			addChild(this.tabs);
			this.tabs.y = CalendarSettings.TABS_Y_POSITION;
			if (this.daysLeft < CalendarSettings.CLAIM_WARNING_BEFORE_DAYS) {
				this.tabs.y = this.tabs.y + 20;
			}
			this.centerModal();
		}

		private function addClaimButton():void {
			this.claimButton = new DeprecatedTextButtonStatic(16, "Go & Claim");
			this.claimButton.textChanged.addOnce(this.alignClaimButton);
			addChild(this.claimButton);
		}

		public function showLegend(param1:Boolean):void {
			var loc2:Sprite = null;
			var loc6:Bitmap = null;
			var loc8:Bitmap = null;
			loc2 = new Sprite();
			loc2.y = this.modalRectangle.height - 55;
			var loc3:TextFieldDisplayConcrete = new TextFieldDisplayConcrete().setSize(16).setColor(16777215).setTextWidth(this.modalRectangle.width).setHorizontalAlign(TextFormatAlign.LEFT);
			loc3.setStringBuilder(new StaticStringBuilder(!!param1 ? "- Reward ready to claim. Click on day to claim reward." : "- Reward ready to claim."));
			var loc4:TextFieldDisplayConcrete = new TextFieldDisplayConcrete().setSize(16).setColor(16777215).setTextWidth(this.modalRectangle.width).setHorizontalAlign(TextFormatAlign.LEFT);
			loc4.setStringBuilder(new StaticStringBuilder("- Item claimed already."));
			loc3.x = 20;
			loc3.y = 0;
			loc4.x = 20;
			loc4.y = 20;
			var loc5:BitmapData = AssetLibrary.getImageFromSet("lofiInterface", 52);
			loc5.colorTransform(new Rectangle(0, 0, loc5.width, loc5.height), CalendarSettings.GREEN_COLOR_TRANSFORM);
			loc5 = TextureRedrawer.redraw(loc5, 40, true, 0);
			loc6 = new Bitmap(loc5);
			loc6.x = -Math.round(loc6.width / 2) + 10;
			loc6.y = -Math.round(loc6.height / 2) + 9;
			loc2.addChild(loc6);
			var loc7:BitmapData = AssetLibrary.getImageFromSet("lofiInterfaceBig", 11);
			loc7 = TextureRedrawer.redraw(loc7, 20, true, 0);
			loc8 = new Bitmap(loc7);
			loc8.x = -Math.round(loc8.width / 2) + 10;
			loc8.y = -Math.round(loc8.height / 2) + 30;
			loc2.addChild(loc8);
			loc2.addChild(loc3);
			loc2.addChild(loc4);
			if (!param1) {
				this.addClaimButton();
				loc2.x = CalendarSettings.DAILY_LOGIN_MODAL_PADDING + this.claimButton.width + 10;
			} else {
				loc2.x = CalendarSettings.DAILY_LOGIN_MODAL_PADDING;
			}
			addChild(loc2);
		}

		private function alignClaimButton():void {
			this.claimButton.x = CalendarSettings.DAILY_LOGIN_MODAL_PADDING;
			this.claimButton.y = this.modalRectangle.height - this.claimButton.height - CalendarSettings.DAILY_LOGIN_MODAL_PADDING;
			if (this.daysLeft < CalendarSettings.CLAIM_WARNING_BEFORE_DAYS) {
			}
		}

		private function createModalBox():void {
			var loc1:DisplayObject = new MysteryBoxSelectModal.backgroundImageEmbed();
			loc1.width = this.modalRectangle.width - 1;
			loc1.height = this.modalRectangle.height - 27;
			loc1.y = 27;
			loc1.alpha = 0.95;
			this.content.addChild(loc1);
			this.content.addChild(this.makeModalBackground(this.modalRectangle.width, this.modalRectangle.height));
		}

		private function makeModalBackground(param1:int, param2:int):PopupWindowBackground {
			var loc3:PopupWindowBackground = new PopupWindowBackground();
			loc3.draw(param1, param2, PopupWindowBackground.TYPE_TRANSPARENT_WITH_HEADER);
			return loc3;
		}

		public function addCloseButton():void {
			this.closeButton.y = 4;
			this.closeButton.x = this.modalRectangle.width - this.closeButton.width - 5;
			addChild(this.closeButton);
		}

		public function addTitle(param1:String):void {
			this.titleTxt = this.getText(param1, 0, 6, true).setSize(18);
			this.titleTxt.setColor(16768512);
			addChild(this.titleTxt);
		}

		public function showServerTime(param1:String, param2:String):void {
			var loc3:TextFieldDisplayConcrete = null;
			this.serverTimeTxt = new TextFieldDisplayConcrete().setSize(14).setColor(16777215).setTextWidth(this.modalRectangle.width);
			this.serverTimeTxt.setStringBuilder(new StaticStringBuilder("Server time: " + param1 + ", ends on: " + param2));
			this.serverTimeTxt.x = CalendarSettings.DAILY_LOGIN_MODAL_PADDING;
			if (this.daysLeft < CalendarSettings.CLAIM_WARNING_BEFORE_DAYS) {
				loc3 = new TextFieldDisplayConcrete().setSize(14).setColor(16711680).setTextWidth(this.modalRectangle.width);
				loc3.setStringBuilder(new StaticStringBuilder("Calendar will soon end, remember to claim before it ends."));
				loc3.x = CalendarSettings.DAILY_LOGIN_MODAL_PADDING;
				loc3.y = 40;
				this.serverTimeTxt.y = 60;
				this.calendarView.y = 90;
				addChild(loc3);
			} else {
				this.calendarView.y = 70;
				this.serverTimeTxt.y = 40;
			}
			addChild(this.serverTimeTxt);
		}

		public function getText(param1:String, param2:int, param3:int, param4:Boolean = false):TextFieldDisplayConcrete {
			var loc5:TextFieldDisplayConcrete = new TextFieldDisplayConcrete().setSize(16).setColor(16777215).setTextWidth(this.modalRectangle.width);
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

		private function centerModal():void {
			this.x = WebMain.STAGE.stageWidth / 2 - this.width / 2;
			this.y = WebMain.STAGE.stageHeight / 2 - this.height / 2;
			this.tabs.x = CalendarSettings.DAILY_LOGIN_MODAL_PADDING;
		}
	}
}
