 
package io.decagames.rotmg.dailyQuests.view.popup {
	import flash.display.Sprite;
	import flash.text.TextFieldAutoSize;
	import io.decagames.rotmg.dailyQuests.data.DailyQuestItemSlotType;
	import io.decagames.rotmg.dailyQuests.model.DailyQuest;
	import io.decagames.rotmg.dailyQuests.utils.SlotsRendered;
	import io.decagames.rotmg.dailyQuests.view.slot.DailyQuestItemSlot;
	import io.decagames.rotmg.ui.buttons.SliceScalingButton;
	import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
	import io.decagames.rotmg.ui.labels.UILabel;
	import io.decagames.rotmg.ui.popups.modal.ModalPopup;
	import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
	import io.decagames.rotmg.ui.texture.TextureParser;
	
	public class DailyQuestRedeemPopup extends ModalPopup {
		 
		
		private var w_:int = 326;
		
		private var h_:int = 238;
		
		private var _thanksButton:SliceScalingButton;
		
		private var slots:Vector.<DailyQuestItemSlot>;
		
		private var slotContainerPosition:int = 15;
		
		public function DailyQuestRedeemPopup(param1:DailyQuest, param2:int = -1) {
			var loc6:UILabel = null;
			super(this.w_,this.h_,"Quest Complete");
			var loc3:SliceScalingBitmap = TextureParser.instance.getSliceScalingBitmap("UI","popup_content_inset",this.w_);
			loc3.height = 117;
			addChild(loc3);
			this.slots = new Vector.<DailyQuestItemSlot>();
			var loc4:SliceScalingBitmap = new TextureParser().getSliceScalingBitmap("UI","main_button_decoration",194);
			addChild(loc4);
			loc4.y = 179;
			loc4.x = Math.round((this.w_ - loc4.width) / 2);
			this._thanksButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI","generic_green_button"));
			this._thanksButton.setLabel("Thanks",DefaultLabelFormat.questButtonCompleteLabel);
			this._thanksButton.width = 149;
			addChild(this._thanksButton);
			this._thanksButton.x = Math.round((this.w_ - 149) / 2);
			this._thanksButton.y = 185;
			var loc5:Sprite = new Sprite();
			addChild(loc5);
			if(param1.itemOfChoice) {
				SlotsRendered.renderSlots(new <int>[param2],new Vector.<int>(),DailyQuestItemSlotType.REWARD,loc5,this.slotContainerPosition,4,this.w_,this.slots);
			} else {
				SlotsRendered.renderSlots(param1.rewards,new Vector.<int>(),DailyQuestItemSlotType.REWARD,loc5,this.slotContainerPosition,4,this.w_,this.slots);
			}
			loc6 = new UILabel();
			DefaultLabelFormat.questRefreshLabel(loc6);
			loc6.width = this.w_;
			loc6.autoSize = TextFieldAutoSize.CENTER;
			loc6.text = "Rewards are sent to the Gift Chest!";
			loc6.y = 140;
			addChild(loc6);
		}
		
		public function get thanksButton() : SliceScalingButton {
			return this._thanksButton;
		}
	}
}
