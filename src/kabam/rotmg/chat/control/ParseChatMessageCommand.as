package kabam.rotmg.chat.control {
	import com.company.assembleegameclient.objects.GameObject;
	import com.company.assembleegameclient.objects.ObjectLibrary;
	import com.company.assembleegameclient.parameters.Parameters;
	import com.company.util.MoreObjectUtil;

	import kabam.rotmg.account.core.Account;
	import kabam.rotmg.appengine.api.AppEngineClient;
	import kabam.rotmg.build.api.BuildData;
	import kabam.rotmg.chat.model.ChatMessage;
	import kabam.rotmg.core.model.PlayerModel;
	import kabam.rotmg.core.service.GoogleAnalytics;
	import kabam.rotmg.dailyLogin.model.DailyLoginModel;
	import kabam.rotmg.dialogs.model.PopupNamesConfig;
	import kabam.rotmg.game.signals.AddTextLineSignal;
	import kabam.rotmg.text.model.TextKey;
	import kabam.rotmg.ui.model.HUDModel;

	public class ParseChatMessageCommand {


		[Inject]
		public var data:String;

		[Inject]
		public var hudModel:HUDModel;

		[Inject]
		public var addTextLine:AddTextLineSignal;

		[Inject]
		public var client:AppEngineClient;

		[Inject]
		public var account:Account;

		[Inject]
		public var buildData:BuildData;

		[Inject]
		public var dailyLoginModel:DailyLoginModel;

		[Inject]
		public var player:PlayerModel;

		[Inject]
		public var tracking:GoogleAnalytics;

		public function ParseChatMessageCommand() {
			super();
		}

		public function execute():void {
			var loc1:Object = null;
			var loc2:Object = null;
			var loc3:uint = 0;
			var loc4:GameObject = null;
			var loc5:String = null;
			var loc6:* = null;
			switch (this.data) {
				case "/resetDailyQuests":
					if (this.player.isAdmin()) {
						loc1 = {};
						MoreObjectUtil.addToObject(loc1, this.account.getCredentials());
						this.client.sendRequest("/dailyquest/resetDailyQuests", loc1);
						this.addTextLine.dispatch(ChatMessage.make(Parameters.SERVER_CHAT_NAME, "Restarting daily quests. Please refresh game."));
					}
					break;
				case "/resetPackagePopup":
					Parameters.data_[PopupNamesConfig.PACKAGES_OFFER_POPUP] = null;
					break;
				case "/h":
				case "/help":
					this.addTextLine.dispatch(ChatMessage.make(Parameters.HELP_CHAT_NAME, TextKey.HELP_COMMAND));
					break;
				case "/c":
				case "/class":
				case "/classes":
					loc2 = {};
					loc3 = 0;
					for each(loc4 in this.hudModel.gameSprite.map.goDict_) {
						if (loc4.props_.isPlayer_) {
							loc2[loc4.objectType_] = loc2[loc4.objectType_] != undefined ? loc2[loc4.objectType_] + 1 : uint(1);
							loc3++;
						}
					}
					loc5 = "";
					for (loc6 in loc2) {
						loc5 = loc5 + (" " + ObjectLibrary.typeToDisplayId_[loc6] + ": " + loc2[loc6]);
					}
					this.addTextLine.dispatch(ChatMessage.make("", "Classes online (" + loc3 + "):" + loc5));
					break;
				default:
					this.hudModel.gameSprite.gsc_.playerText(this.data);
			}
		}
	}
}
