package io.decagames.rotmg.dailyQuests.view {
	import com.company.assembleegameclient.ui.tooltip.TextToolTip;

	import flash.events.Event;

	import io.decagames.rotmg.dailyQuests.model.DailyQuestsModel;
	import io.decagames.rotmg.dailyQuests.signal.CloseRedeemPopupSignal;
	import io.decagames.rotmg.dailyQuests.signal.LockQuestScreenSignal;
	import io.decagames.rotmg.dailyQuests.signal.QuestRedeemCompleteSignal;
	import io.decagames.rotmg.dailyQuests.view.popup.DailyQuestRedeemPopup;
	import io.decagames.rotmg.ui.buttons.BaseButton;
	import io.decagames.rotmg.ui.buttons.SliceScalingButton;
	import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
	import io.decagames.rotmg.ui.popups.header.PopupHeader;
	import io.decagames.rotmg.ui.popups.signals.ClosePopupSignal;
	import io.decagames.rotmg.ui.popups.signals.ShowPopupSignal;
	import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
	import io.decagames.rotmg.ui.texture.TextureParser;
	import io.decagames.rotmg.utils.date.TimeSpan;

	import kabam.rotmg.core.signals.HideTooltipsSignal;
	import kabam.rotmg.core.signals.ShowTooltipSignal;
	import kabam.rotmg.dailyLogin.model.DailyLoginModel;
	import kabam.rotmg.messaging.impl.incoming.QuestRedeemResponse;
	import kabam.rotmg.tooltips.HoverTooltipDelegate;

	import robotlegs.bender.bundles.mvcs.Mediator;

	public class DailyQuestWindowMediator extends Mediator {


		[Inject]
		public var view:DailyQuestWindow;

		[Inject]
		public var lockScreen:LockQuestScreenSignal;

		[Inject]
		public var redeemCompleteSignal:QuestRedeemCompleteSignal;

		[Inject]
		public var dailyQuestsModel:DailyQuestsModel;

		[Inject]
		public var closeRedeem:CloseRedeemPopupSignal;

		[Inject]
		public var dailyLoginModel:DailyLoginModel;

		[Inject]
		public var showTooltipSignal:ShowTooltipSignal;

		[Inject]
		public var hideTooltipsSignal:HideTooltipsSignal;

		[Inject]
		public var closePopupSignal:ClosePopupSignal;

		[Inject]
		public var showPopupSignal:ShowPopupSignal;

		private var toolTip:TextToolTip;

		private var hoverTooltipDelegate:HoverTooltipDelegate;

		private var closeButton:SliceScalingButton;

		private var infoButton:SliceScalingButton;

		private var contentBackground:SliceScalingBitmap;

		private var redeemPopup:DailyQuestRedeemPopup;

		public function DailyQuestWindowMediator() {
			this.hoverTooltipDelegate = new HoverTooltipDelegate();
			super();
		}

		override public function initialize():void {
			this.closeButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI", "close_button"));
			this.infoButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI", "info_button"));
			this.view.header.setTitle("The Tinkerer", 450, DefaultLabelFormat.defaultPopupTitle);
			this.closeButton.clickSignal.addOnce(this.onClose);
			this.view.header.addButton(this.closeButton, PopupHeader.RIGHT_BUTTON);
			this.view.header.addButton(this.infoButton, PopupHeader.LEFT_BUTTON);
			this.contentBackground = TextureParser.instance.getSliceScalingBitmap("UI", "tab_cointainer_background_filled");
			this.contentBackground.width = 580;
			this.contentBackground.height = 445;
			this.view.contentContainer.addChildAt(this.contentBackground, 0);
			this.lockScreen.add(this.onLockScreen);
			this.redeemCompleteSignal.add(this.onRedeemComplete);
			this.closeRedeem.add(this.onRedeemClose);
			this.view.addEventListener(Event.ENTER_FRAME, this.updateTimeHandler);
			this.setToolTipTitle("The Tinkerer", "Complete the quests to earn great rewards!\n\nYou can select a quest from the list to display the quest requirements. Bring the items back to me to complete the quest and rewards will be sent directly to your Gift Chest.\n\nItems will be directly consumed from your inventory or backpack when you press \"Complete!\".\n\nYou can complete each quest only once per day but the Tinkerer will offer you new quests everyday!");
		}

		private function setToolTipTitle(param1:String, param2:String):void {
			this.toolTip = new TextToolTip(3552822, 10197915, param1, param2, 300, null);
			this.hoverTooltipDelegate.setDisplayObject(this.infoButton);
			this.hoverTooltipDelegate.setHideToolTipsSignal(this.hideTooltipsSignal);
			this.hoverTooltipDelegate.setShowToolTipSignal(this.showTooltipSignal);
			this.hoverTooltipDelegate.tooltip = this.toolTip;
		}

		private function updateTimeHandler(param1:Event):void {
			var loc2:Date = this.dailyLoginModel.getServerTime();
			var loc3:Date = new Date();
			loc3.setTime(loc2.valueOf() + 86400000);
			loc3.setUTCHours(0);
			loc3.setUTCMinutes(0);
			loc3.setUTCSeconds(0);
			loc3.setUTCMilliseconds(0);
			var loc4:TimeSpan = new TimeSpan(loc3.valueOf() - loc2.valueOf());
			var loc5:* = "Quests refresh in " + (loc4.hours > 9 ? loc4.hours.toString() : "0" + loc4.hours.toString()) + "h " + (loc4.minutes > 9 ? loc4.minutes.toString() : "0" + loc4.minutes.toString()) + "m";
			this.view.setQuestRefreshHeader(loc5);
		}

		override public function destroy():void {
			this.lockScreen.remove(this.onLockScreen);
			this.redeemCompleteSignal.remove(this.onRedeemComplete);
			this.closeRedeem.remove(this.onRedeemClose);
			this.view.removeEventListener(Event.ENTER_FRAME, this.updateTimeHandler);
			this.dailyQuestsModel.isPopupOpened = false;
			this.toolTip = null;
			this.hoverTooltipDelegate.removeDisplayObject();
			this.hoverTooltipDelegate = null;
		}

		private function onRedeemComplete(param1:QuestRedeemResponse):void {
			var loc2:String = null;
			var loc3:int = 0;
			if (param1.ok) {
				loc2 = this.dailyQuestsModel.currentQuest.id;
				this.redeemPopup = new DailyQuestRedeemPopup(this.dailyQuestsModel.getQuestById(loc2), this.dailyQuestsModel.selectedItem);
				this.dailyQuestsModel.markAsCompleted(this.dailyQuestsModel.currentQuest.id);
				loc3 = this.dailyQuestsModel.numberOfCompletedQuests;
				if (!this.dailyQuestsModel.currentQuest.repeatable) {
					this.dailyQuestsModel.currentQuest.completed = true;
				}
				loc3++;
				this.view.renderList();
				this.view.renderQuestInfo();
				this.view.hideFade();
				this.view.showFade(1381653, loc3 == this.dailyQuestsModel.numberOfActiveQuests);
				this.showPopupSignal.dispatch(this.redeemPopup);
			}
		}

		private function onLockScreen():void {
			this.view.showFade();
		}

		private function onRedeemClose():void {
			this.view.hideFade();
			this.closePopupSignal.dispatch(this.redeemPopup);
		}

		private function onClose(param1:BaseButton):void {
			this.closePopupSignal.dispatch(this.view);
		}
	}
}
