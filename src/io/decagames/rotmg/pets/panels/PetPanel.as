package io.decagames.rotmg.pets.panels {
	import com.company.assembleegameclient.game.AGameSprite;
	import com.company.assembleegameclient.ui.panels.Panel;
	import com.company.assembleegameclient.ui.tooltip.ToolTip;

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	import io.decagames.rotmg.pets.components.tooltip.PetTooltip;
	import io.decagames.rotmg.pets.data.vo.PetVO;
	import io.decagames.rotmg.pets.utils.PetsConstants;
	import io.decagames.rotmg.pets.utils.PetsViewAssetFactory;

	import kabam.rotmg.editor.view.StaticTextButton;
	import kabam.rotmg.text.model.TextKey;
	import kabam.rotmg.text.view.TextFieldDisplayConcrete;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;

	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeSignal;

	public class PetPanel extends Panel {

		private static const FONT_SIZE:int = 16;

		private static const INVENTORY_PADDING:int = 6;

		private static const HUD_PADDING:int = 5;


		public var petBitmapRollover:NativeSignal;

		public var petBitmapContainer:Sprite;

		public var followButton:StaticTextButton;

		public var releaseButton:StaticTextButton;

		public var unFollowButton:StaticTextButton;

		public var petVO:PetVO;

		public const addToolTip:Signal = new Signal(ToolTip);

		private const nameTextField:TextFieldDisplayConcrete = PetsViewAssetFactory.returnTextfield(16777215, 16, true);

		private const rarityTextField:TextFieldDisplayConcrete = PetsViewAssetFactory.returnTextfield(11974326, 12, false);

		private var petBitmap:Bitmap;

		public function PetPanel(param1:AGameSprite, param2:PetVO) {
			this.petBitmapContainer = new Sprite();
			super(param1);
			this.petVO = param2;
			this.petBitmapRollover = new NativeSignal(this.petBitmapContainer, MouseEvent.MOUSE_OVER);
			this.petBitmapRollover.add(this.onRollOver);
			this.petBitmap = param2.getSkinBitmap();
			this.addChildren();
			this.positionChildren();
			this.updateTextFields();
			this.createButtons();
		}

		private static function sendToBottom(param1:StaticTextButton):void {
			param1.y = HEIGHT - param1.height - 4;
		}

		private function createButtons():void {
			this.followButton = this.makeButton(TextKey.PET_PANEL_FOLLOW);
			this.releaseButton = this.makeButton(TextKey.RELEASE);
			this.unFollowButton = this.makeButton(TextKey.PET_PANEL_UNFOLLOW);
			this.alignButtons();
		}

		private function makeButton(param1:String):StaticTextButton {
			var loc2:StaticTextButton = new StaticTextButton(FONT_SIZE, param1);
			addChild(loc2);
			return loc2;
		}

		public function setState(param1:uint):void {
			this.toggleButtons(param1 == PetsConstants.INTERACTING);
		}

		public function toggleButtons(param1:Boolean):void {
			this.followButton.visible = param1;
			this.releaseButton.visible = param1;
			this.unFollowButton.visible = !param1;
		}

		private function addChildren():void {
			this.petBitmapContainer.addChild(this.petBitmap);
			addChild(this.petBitmapContainer);
			addChild(this.nameTextField);
			addChild(this.rarityTextField);
		}

		private function updateTextFields():void {
			this.nameTextField.setStringBuilder(new LineBuilder().setParams(this.petVO.name)).setColor(this.petVO.rarity.color).setSize(this.petVO.name.length > 17 ? 11 : 15);
			this.rarityTextField.setStringBuilder(new LineBuilder().setParams(this.petVO.rarity.rarityKey));
		}

		private function positionChildren():void {
			this.petBitmap.x = 4;
			this.petBitmap.y = -3;
			this.nameTextField.x = 58;
			this.nameTextField.y = 21;
			this.rarityTextField.x = 58;
			this.rarityTextField.y = 35;
		}

		private function alignButtons():void {
			this.positionFollow();
			this.positionRelease();
			this.positionUnfollow();
		}

		private function positionFollow():void {
			this.followButton.x = INVENTORY_PADDING;
			sendToBottom(this.followButton);
		}

		private function positionRelease():void {
			this.releaseButton.x = WIDTH - this.releaseButton.width - INVENTORY_PADDING - HUD_PADDING;
			sendToBottom(this.releaseButton);
		}

		private function positionUnfollow():void {
			this.unFollowButton.x = (WIDTH - this.unFollowButton.width) / 2;
			sendToBottom(this.unFollowButton);
		}

		private function onRollOver(param1:MouseEvent):void {
			var loc2:PetTooltip = new PetTooltip(this.petVO);
			loc2.attachToTarget(this);
			this.addToolTip.dispatch(loc2);
		}
	}
}
