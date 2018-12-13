 
package io.decagames.rotmg.dailyQuests.view.info {
	import flash.display.Sprite;
	import io.decagames.rotmg.dailyQuests.data.DailyQuestItemSlotType;
	import io.decagames.rotmg.dailyQuests.model.DailyQuest;
	import io.decagames.rotmg.dailyQuests.utils.SlotsRendered;
	import io.decagames.rotmg.dailyQuests.view.slot.DailyQuestItemSlot;
	import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
	import io.decagames.rotmg.ui.labels.UILabel;
	import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
	import io.decagames.rotmg.ui.texture.TextureParser;
	
	public class DailyQuestInfo extends Sprite {
		
		public static var INFO_WIDTH:int = 328;
		
		public static const INFO_HEIGHT:int = 434;
		 
		
		private var contentInset:SliceScalingBitmap;
		
		private var contentTitle:SliceScalingBitmap;
		
		private var contentButton:SliceScalingBitmap;
		
		private var contentDivider:SliceScalingBitmap;
		
		private var contentDividerTitle:SliceScalingBitmap;
		
		private var questName:UILabel;
		
		private var questDescription:UILabel;
		
		private var rewardsTitle:UILabel;
		
		private var rewardsChoice:UILabel;
		
		private var slots:Vector.<DailyQuestItemSlot>;
		
		private var slotMargin:int = 4;
		
		private var requirementsTopMargin:int = 100;
		
		private var rewardsTopMargin:int = 255;
		
		private var requirementsContainer:Sprite;
		
		private var rewardsContainer:Sprite;
		
		private var _completeButton:DailyQuestCompleteButton;
		
		private var playerEquipment:Vector.<int>;
		
		public function DailyQuestInfo() {
			super();
			this.contentInset = TextureParser.instance.getSliceScalingBitmap("UI","popup_content_inset",325);
			addChild(this.contentInset);
			this.contentInset.height = 425;
			this.contentInset.x = 0;
			this.contentInset.y = 0;
			this.contentTitle = TextureParser.instance.getSliceScalingBitmap("UI","content_title_decoration",325);
			addChild(this.contentTitle);
			this.contentTitle.x = 0;
			this.contentTitle.y = 0;
			this.contentButton = TextureParser.instance.getSliceScalingBitmap("UI","content_button_decoration",325);
			addChild(this.contentButton);
			this.contentButton.x = 0;
			this.contentButton.y = 340;
			this.contentDivider = TextureParser.instance.getSliceScalingBitmap("UI","content_divider",305);
			addChild(this.contentDivider);
			this.contentDivider.x = 10;
			this.contentDivider.y = 203;
			this.contentDividerTitle = TextureParser.instance.getSliceScalingBitmap("UI","content_divider_title",145);
			addChild(this.contentDividerTitle);
			this.contentDividerTitle.x = this.contentInset.width / 2 - this.contentDividerTitle.width / 2;
			this.contentDividerTitle.y = 193;
			this.questName = new UILabel();
			DefaultLabelFormat.questNameLabel(this.questName);
			this.questName.width = INFO_WIDTH;
			this.questName.wordWrap = true;
			this.questName.y = 6;
			this.questName.x = 0;
			addChild(this.questName);
			this.requirementsContainer = new Sprite();
			addChild(this.requirementsContainer);
			this.rewardsContainer = new Sprite();
			addChild(this.rewardsContainer);
			this.questDescription = new UILabel();
			DefaultLabelFormat.questDescriptionLabel(this.questDescription);
			this.questDescription.width = INFO_WIDTH - 30;
			this.questDescription.wordWrap = true;
			this.questDescription.multiline = true;
			this.questDescription.y = 44;
			this.questDescription.x = 15;
			addChild(this.questDescription);
			this.rewardsTitle = new UILabel();
			DefaultLabelFormat.questRewardLabel(this.rewardsTitle);
			this.rewardsTitle.text = "Rewards";
			this.rewardsTitle.y = 200;
			this.rewardsTitle.x = this.contentInset.width / 2 - this.rewardsTitle.width / 2;
			addChild(this.rewardsTitle);
			this.rewardsChoice = new UILabel();
			DefaultLabelFormat.questChoiceLabel(this.rewardsChoice);
			this.rewardsChoice.text = "Choose one of the following Items";
			this.rewardsChoice.y = 230;
			this.rewardsChoice.x = this.contentInset.width / 2 - this.rewardsChoice.width / 2;
			addChild(this.rewardsChoice);
			this._completeButton = new DailyQuestCompleteButton();
			this._completeButton.x = 92;
			this._completeButton.y = 370;
		}
		
		public static function hasAllItems(param1:Vector.<int>, param2:Vector.<int>) : Boolean {
			var loc4:int = 0;
			var loc5:int = 0;
			var loc3:Vector.<int> = param1.concat();
			for each(loc4 in param2) {
				loc5 = loc3.indexOf(loc4);
				if(loc5 >= 0) {
					loc3.splice(loc5,1);
				}
			}
			return loc3.length == 0;
		}
		
		public function clear() : void {
			var loc1:DailyQuestItemSlot = null;
			for each(loc1 in this.slots) {
				loc1.parent.removeChild(loc1);
			}
			this.slots = new Vector.<DailyQuestItemSlot>();
		}
		
		public function show(param1:DailyQuest, param2:Vector.<int>) : void {
			this.playerEquipment = param2.concat();
			if(param1.itemOfChoice) {
				this.rewardsChoice.visible = true;
			} else {
				this.rewardsChoice.visible = false;
			}
			this.questName.text = param1.name;
			this.questDescription.text = param1.description;
			SlotsRendered.renderSlots(param1.requirements,this.playerEquipment,DailyQuestItemSlotType.REQUIREMENT,this.requirementsContainer,this.requirementsTopMargin,this.slotMargin,INFO_WIDTH,this.slots);
			SlotsRendered.renderSlots(param1.rewards,this.playerEquipment,DailyQuestItemSlotType.REWARD,this.rewardsContainer,this.rewardsTopMargin,this.slotMargin,INFO_WIDTH,this.slots,param1.itemOfChoice);
			this._completeButton.disabled = !!param1.completed?true:!hasAllItems(param1.requirements,param2);
			this._completeButton.completed = param1.completed;
			addChild(this._completeButton);
		}
		
		public function get completeButton() : DailyQuestCompleteButton {
			return this._completeButton;
		}
	}
}
