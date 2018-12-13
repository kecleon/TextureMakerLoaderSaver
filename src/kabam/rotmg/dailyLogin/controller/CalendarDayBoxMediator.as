package kabam.rotmg.dailyLogin.controller {
	import com.company.assembleegameclient.map.Map;

	import flash.events.MouseEvent;

	import kabam.lib.net.api.MessageProvider;
	import kabam.lib.net.impl.SocketServer;
	import kabam.rotmg.core.model.MapModel;
	import kabam.rotmg.dailyLogin.message.ClaimDailyRewardMessage;
	import kabam.rotmg.dailyLogin.model.DailyLoginModel;
	import kabam.rotmg.dailyLogin.view.CalendarDayBox;
	import kabam.rotmg.messaging.impl.GameServerConnection;
	import kabam.rotmg.ui.model.HUDModel;

	import robotlegs.bender.bundles.mvcs.Mediator;

	public class CalendarDayBoxMediator extends Mediator {


		[Inject]
		public var view:CalendarDayBox;

		[Inject]
		public var socketServer:SocketServer;

		[Inject]
		public var messages:MessageProvider;

		[Inject]
		public var mapModel:MapModel;

		[Inject]
		public var hudModel:HUDModel;

		[Inject]
		public var model:DailyLoginModel;

		public function CalendarDayBoxMediator() {
			super();
		}

		override public function initialize():void {
			this.view.addEventListener(MouseEvent.CLICK, this.onClickHandler);
		}

		override public function destroy():void {
			this.view.removeEventListener(MouseEvent.CLICK, this.onClickHandler);
			super.destroy();
		}

		private function onClickHandler(param1:MouseEvent):void {
			var loc2:ClaimDailyRewardMessage = null;
			this.view.removeEventListener(MouseEvent.CLICK, this.onClickHandler);
			if (this.hudModel.gameSprite.map.name_ == Map.DAILY_QUEST_ROOM && this.view.day.claimKey != "" && !this.view.day.isClaimed) {
				loc2 = this.messages.require(GameServerConnection.CLAIM_LOGIN_REWARD_MSG) as ClaimDailyRewardMessage;
				loc2.claimKey = this.view.day.claimKey;
				loc2.type = this.view.getDay().calendarType;
				this.socketServer.sendMessage(loc2);
				this.view.markAsClaimed();
				this.model.markAsClaimed(this.view.getDay().dayNumber, this.view.getDay().calendarType);
			}
		}
	}
}
