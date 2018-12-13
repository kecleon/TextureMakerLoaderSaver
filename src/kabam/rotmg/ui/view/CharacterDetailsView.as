package kabam.rotmg.ui.view {
	import com.company.assembleegameclient.objects.ImageFactory;
	import com.company.assembleegameclient.objects.Player;
	import com.company.assembleegameclient.ui.BoostPanelButton;
	import com.company.assembleegameclient.ui.ExperienceBoostTimerPopup;
	import com.company.assembleegameclient.ui.icons.IconButton;
	import com.company.assembleegameclient.ui.icons.IconButtonFactory;

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
	import io.decagames.rotmg.ui.labels.UILabel;

	import kabam.rotmg.text.model.TextKey;

	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeSignal;

	public class CharacterDetailsView extends Sprite {

		public static const NEXUS_BUTTON:String = "NEXUS_BUTTON";

		public static const OPTIONS_BUTTON:String = "OPTIONS_BUTTON";

		public static const IMAGE_SET_NAME:String = "lofiInterfaceBig";

		public static const NEXUS_IMAGE_ID:int = 6;

		public static const OPTIONS_IMAGE_ID:int = 5;


		public var gotoNexus:Signal;

		public var gotoOptions:Signal;

		public var iconButtonFactory:IconButtonFactory;

		public var imageFactory:ImageFactory;

		private var portrait_:Bitmap;

		private var button:IconButton;

		private var nameText_:UILabel;

		private var nexusClicked:NativeSignal;

		private var optionsClicked:NativeSignal;

		private var boostPanelButton:BoostPanelButton;

		private var expTimer:ExperienceBoostTimerPopup;

		public var friendsBtn:IconButton;

		private var indicator:Sprite;

		public function CharacterDetailsView() {
			this.gotoNexus = new Signal();
			this.gotoOptions = new Signal();
			this.portrait_ = new Bitmap(null);
			this.nexusClicked = new NativeSignal(this.button, MouseEvent.CLICK);
			this.optionsClicked = new NativeSignal(this.button, MouseEvent.CLICK);
			super();
		}

		public function init(param1:String, param2:String):void {
			this.indicator = new Sprite();
			this.indicator.graphics.beginFill(823807);
			this.indicator.graphics.drawCircle(0, 0, 4);
			this.indicator.graphics.endFill();
			this.indicator.x = 13;
			this.indicator.y = -5;
			this.createPortrait();
			this.createNameText(param1);
			this.createButton(param2);
		}

		private function createButton(param1:String):void {
			if (param1 == NEXUS_BUTTON) {
				this.button = this.iconButtonFactory.create(this.imageFactory.getImageFromSet(IMAGE_SET_NAME, NEXUS_IMAGE_ID), "", TextKey.CHARACTER_DETAILS_VIEW_NEXUS, "escapeToNexus", 6);
				this.nexusClicked = new NativeSignal(this.button, MouseEvent.CLICK, MouseEvent);
				this.nexusClicked.add(this.onNexusClick);
			} else if (param1 == OPTIONS_BUTTON) {
				this.button = this.iconButtonFactory.create(this.imageFactory.getImageFromSet(IMAGE_SET_NAME, OPTIONS_IMAGE_ID), "", TextKey.CHARACTER_DETAILS_VIEW_OPTIONS, "options", 6);
				this.optionsClicked = new NativeSignal(this.button, MouseEvent.CLICK, MouseEvent);
				this.optionsClicked.add(this.onOptionsClick);
			}
			this.button.x = 172;
			this.button.y = 12;
			addChild(this.button);
		}

		public function addInvitationIndicator():void {
			if (this.friendsBtn) {
				this.friendsBtn.addChild(this.indicator);
			}
		}

		public function clearInvitationIndicator():void {
			if (this.indicator && this.indicator.parent) {
				this.indicator.parent.removeChild(this.indicator);
			}
		}

		public function initFriendList(param1:ImageFactory, param2:IconButtonFactory, param3:Function, param4:Boolean):void {
			this.friendsBtn = param2.create(param1.getImageFromSet("lofiInterfaceBig", 13), "", "Social", "", 6);
			this.friendsBtn.x = 146;
			this.friendsBtn.y = 12;
			this.friendsBtn.addEventListener(MouseEvent.CLICK, param3);
			addChild(this.friendsBtn);
			if (param4) {
				this.addInvitationIndicator();
			}
		}

		private function createPortrait():void {
			this.portrait_.x = -2;
			this.portrait_.y = -8;
			addChild(this.portrait_);
		}

		private function createNameText(param1:String):void {
			this.nameText_ = new UILabel();
			this.nameText_.x = 35;
			this.nameText_.y = 6;
			this.setName(param1);
			addChild(this.nameText_);
		}

		public function update(param1:Player):void {
			this.portrait_.bitmapData = param1.getPortrait();
		}

		public function draw(param1:Player):void {
			if (this.expTimer) {
				this.expTimer.update(param1.xpTimer);
			}
			if (param1.tierBoost || param1.dropBoost) {
				this.boostPanelButton = this.boostPanelButton || new BoostPanelButton(param1);
				if (this.portrait_) {
					this.portrait_.x = 13;
				}
				if (this.nameText_) {
					this.nameText_.x = 47;
				}
				this.boostPanelButton.x = 6;
				this.boostPanelButton.y = 5;
				addChild(this.boostPanelButton);
			} else if (this.boostPanelButton) {
				removeChild(this.boostPanelButton);
				this.boostPanelButton = null;
				this.portrait_.x = -2;
				this.nameText_.x = 36;
			}
		}

		private function onNexusClick(param1:MouseEvent):void {
			this.gotoNexus.dispatch();
		}

		private function onOptionsClick(param1:MouseEvent):void {
			this.gotoOptions.dispatch();
		}

		public function setName(param1:String):void {
			this.nameText_.text = param1;
			DefaultLabelFormat.characterViewNameLabel(this.nameText_);
		}
	}
}
