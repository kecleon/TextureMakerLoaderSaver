package io.decagames.rotmg.pets.popup.ability {
	import io.decagames.rotmg.ui.buttons.SliceScalingButton;
	import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
	import io.decagames.rotmg.ui.labels.UILabel;
	import io.decagames.rotmg.ui.popups.modal.ModalPopup;
	import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
	import io.decagames.rotmg.ui.texture.TextureParser;

	import kabam.rotmg.text.view.stringBuilder.LineBuilder;

	public class NewAbilityUnlockedDialog extends ModalPopup {


		private var _okButton:SliceScalingButton;

		public function NewAbilityUnlockedDialog(param1:String) {
			var loc2:UILabel = null;
			var loc4:UILabel = null;
			var loc5:SliceScalingBitmap = null;
			super(270, 120, LineBuilder.getLocalizedStringFromKey("NewAbility.gratz"));
			loc2 = new UILabel();
			DefaultLabelFormat.newAbilityInfo(loc2);
			loc2.y = 5;
			loc2.width = _contentWidth;
			loc2.wordWrap = true;
			loc2.text = LineBuilder.getLocalizedStringFromKey("NewAbility.text");
			addChild(loc2);
			var loc3:SliceScalingBitmap = TextureParser.instance.getSliceScalingBitmap("UI", "popup_content_inset", 229);
			addChild(loc3);
			loc3.height = 35;
			loc3.y = loc2.y + loc2.textHeight + 10;
			loc3.x = Math.round((_contentWidth - loc3.width) / 2);
			loc4 = new UILabel();
			DefaultLabelFormat.newAbilityName(loc4);
			loc4.y = loc3.y + 8;
			loc4.width = _contentWidth;
			loc4.wordWrap = true;
			loc4.text = param1;
			addChild(loc4);
			loc5 = new TextureParser().getSliceScalingBitmap("UI", "main_button_decoration", 194);
			addChild(loc5);
			loc5.y = loc3.y + loc3.height + 10;
			loc5.x = Math.round((_contentWidth - loc5.width) / 2);
			this._okButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI", "generic_green_button"));
			this._okButton.setLabel(LineBuilder.getLocalizedStringFromKey("NewAbility.righteous"), DefaultLabelFormat.questButtonCompleteLabel);
			this._okButton.width = 149;
			this._okButton.x = Math.round((_contentWidth - this._okButton.width) / 2);
			this._okButton.y = loc5.y + 6;
			addChild(this._okButton);
		}

		public function get okButton():SliceScalingButton {
			return this._okButton;
		}
	}
}
