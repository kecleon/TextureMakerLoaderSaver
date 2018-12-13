package io.decagames.rotmg.social.popups {
	import flash.text.TextFormatAlign;

	import io.decagames.rotmg.ui.buttons.SliceScalingButton;
	import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
	import io.decagames.rotmg.ui.popups.modal.ModalPopup;
	import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
	import io.decagames.rotmg.ui.textField.InputTextField;
	import io.decagames.rotmg.ui.texture.TextureParser;

	public class InviteFriendPopup extends ModalPopup {


		public var sendButton:SliceScalingButton;

		public var search:InputTextField;

		public function InviteFriendPopup() {
			var loc1:SliceScalingBitmap = null;
			super(400, 85, "Send invitation");
			loc1 = TextureParser.instance.getSliceScalingBitmap("UI", "popup_content_inset", 300);
			addChild(loc1);
			loc1.height = 30;
			loc1.x = 50;
			loc1.y = 10;
			this.search = new InputTextField("Account name");
			DefaultLabelFormat.defaultSmallPopupTitle(this.search, TextFormatAlign.CENTER);
			addChild(this.search);
			this.search.width = 290;
			this.search.x = loc1.x + 5;
			this.search.y = loc1.y + 7;
			this.sendButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI", "generic_green_button"));
			this.sendButton.width = 100;
			this.sendButton.setLabel("Send", DefaultLabelFormat.defaultButtonLabel);
			this.sendButton.y = 50;
			this.sendButton.x = Math.round(_contentWidth - this.sendButton.width) / 2;
			addChild(this.sendButton);
		}
	}
}
