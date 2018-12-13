package kabam.rotmg.dailyLogin.tasks {
	import com.company.assembleegameclient.parameters.Parameters;
	import com.company.util.MoreObjectUtil;

	import kabam.lib.tasks.BaseTask;
	import kabam.rotmg.account.core.Account;
	import kabam.rotmg.appengine.api.AppEngineClient;
	import kabam.rotmg.build.api.BuildData;
	import kabam.rotmg.build.api.BuildEnvironment;
	import kabam.rotmg.core.signals.SetLoadingMessageSignal;
	import kabam.rotmg.dailyLogin.model.CalendarDayModel;
	import kabam.rotmg.dailyLogin.model.CalendarTypes;
	import kabam.rotmg.dailyLogin.model.DailyLoginModel;

	import robotlegs.bender.framework.api.ILogger;

	public class FetchPlayerCalendarTask extends BaseTask {


		[Inject]
		public var account:Account;

		[Inject]
		public var logger:ILogger;

		[Inject]
		public var client:AppEngineClient;

		[Inject]
		public var setLoadingMessage:SetLoadingMessageSignal;

		[Inject]
		public var dailyLoginModel:DailyLoginModel;

		[Inject]
		public var buildData:BuildData;

		private var requestData:Object;

		public function FetchPlayerCalendarTask() {
			super();
		}

		override protected function startTask():void {
			this.logger.info("FetchPlayerCalendarTask start");
			this.requestData = this.makeRequestData();
			this.sendRequest();
		}

		private function sendRequest():void {
			this.client.complete.addOnce(this.onComplete);
			this.client.sendRequest("/dailyLogin/fetchCalendar", this.requestData);
		}

		private function onComplete(param1:Boolean, param2:*):void {
			if (param1) {
				this.onCalendarUpdate(param2);
			} else {
				this.onTextError(param2);
			}
		}

		private function onCalendarUpdate(param1:String):void {
			var xmlData:XML = null;
			var data:String = param1;
			try {
				xmlData = new XML(data);
			}
			catch (e:Error) {
				completeTask(true);
				return;
			}
			this.dailyLoginModel.clear();
			var serverTimestamp:Number = parseFloat(xmlData.attribute("serverTime")) * 1000;
			this.dailyLoginModel.setServerTime(serverTimestamp);
			if (!Parameters.data_.calendarShowOnDay || Parameters.data_.calendarShowOnDay < this.dailyLoginModel.getTimestampDay()) {
				this.dailyLoginModel.shouldDisplayCalendarAtStartup = true;
			}
			if (this.buildData.getEnvironment() == BuildEnvironment.LOCALHOST) {
			}
			if (xmlData.hasOwnProperty("NonConsecutive") && xmlData.NonConsecutive..Login.length() > 0) {
				this.parseCalendar(xmlData.NonConsecutive, CalendarTypes.NON_CONSECUTIVE, xmlData.attribute("nonconCurDay"));
			}
			if (xmlData.hasOwnProperty("Consecutive") && xmlData.Consecutive..Login.length() > 0) {
				this.parseCalendar(xmlData.Consecutive, CalendarTypes.CONSECUTIVE, xmlData.attribute("conCurDay"));
			}
			completeTask(true);
		}

		private function parseCalendar(param1:XMLList, param2:String, param3:String):void {
			var loc4:XML = null;
			var loc5:CalendarDayModel = null;
			for each(loc4 in param1..Login) {
				loc5 = this.getDayFromXML(loc4, param2);
				if (loc4.hasOwnProperty("key")) {
					loc5.claimKey = loc4.key;
				}
				this.dailyLoginModel.addDay(loc5, param2);
			}
			if (param3) {
				this.dailyLoginModel.setCurrentDay(param2, int(param3));
			}
			this.dailyLoginModel.setUserDay(param1.attribute("days"), param2);
			this.dailyLoginModel.calculateCalendar(param2);
		}

		private function getDayFromXML(param1:XML, param2:String):CalendarDayModel {
			return new CalendarDayModel(param1.Days, param1.ItemId, param1.Gold, param1.ItemId.attribute("quantity"), param1.hasOwnProperty("Claimed"), param2);
		}

		private function onTextError(param1:String):void {
			completeTask(true);
		}

		public function makeRequestData():Object {
			var loc1:Object = {};
			loc1.game_net_user_id = this.account.gameNetworkUserId();
			loc1.game_net = this.account.gameNetwork();
			loc1.play_platform = this.account.playPlatform();
			loc1.do_login = Parameters.sendLogin_;
			MoreObjectUtil.addToObject(loc1, this.account.getCredentials());
			return loc1;
		}
	}
}
