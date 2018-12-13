 
package kabam.rotmg.ui.view {
	import com.company.assembleegameclient.mapeditor.MapEditor;
	import com.company.assembleegameclient.parameters.Parameters;
	import com.company.assembleegameclient.screens.ServersScreen;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	import flash.system.Capabilities;
	import kabam.rotmg.account.core.Account;
	import kabam.rotmg.account.core.signals.OpenAccountInfoSignal;
	import kabam.rotmg.account.securityQuestions.data.SecurityQuestionsModel;
	import kabam.rotmg.account.securityQuestions.view.SecurityQuestionsInfoDialog;
	import kabam.rotmg.appengine.api.AppEngineClient;
	import kabam.rotmg.application.DynamicSettings;
	import kabam.rotmg.application.api.ApplicationSetup;
	import kabam.rotmg.build.api.BuildData;
	import kabam.rotmg.core.model.PlayerModel;
	import kabam.rotmg.core.service.GoogleAnalytics;
	import kabam.rotmg.core.signals.SetScreenSignal;
	import kabam.rotmg.core.signals.SetScreenWithValidDataSignal;
	import kabam.rotmg.core.view.Layers;
	import kabam.rotmg.dialogs.control.OpenDialogSignal;
	import kabam.rotmg.legends.view.LegendsView;
	import kabam.rotmg.ui.model.EnvironmentData;
	import kabam.rotmg.ui.signals.EnterGameSignal;
	import robotlegs.bender.bundles.mvcs.Mediator;
	import robotlegs.bender.framework.api.ILogger;
	
	public class TitleMediator extends Mediator {
		
		private static var supportCalledBefore:Boolean = false;
		 
		
		[Inject]
		public var view:TitleView;
		
		[Inject]
		public var account:Account;
		
		[Inject]
		public var playerModel:PlayerModel;
		
		[Inject]
		public var setScreen:SetScreenSignal;
		
		[Inject]
		public var setScreenWithValidData:SetScreenWithValidDataSignal;
		
		[Inject]
		public var enterGame:EnterGameSignal;
		
		[Inject]
		public var openAccountInfo:OpenAccountInfoSignal;
		
		[Inject]
		public var openDialog:OpenDialogSignal;
		
		[Inject]
		public var setup:ApplicationSetup;
		
		[Inject]
		public var layers:Layers;
		
		[Inject]
		public var securityQuestionsModel:SecurityQuestionsModel;
		
		[Inject]
		public var logger:ILogger;
		
		[Inject]
		public var client:AppEngineClient;
		
		[Inject]
		public var buildData:BuildData;
		
		[Inject]
		public var tracking:GoogleAnalytics;
		
		public function TitleMediator() {
			super();
		}
		
		override public function initialize() : void {
			this.view.optionalButtonsAdded.add(this.onOptionalButtonsAdded);
			this.view.initialize(this.makeEnvironmentData());
			this.view.playClicked.add(this.handleIntentionToPlay);
			this.view.serversClicked.add(this.showServersScreen);
			this.view.accountClicked.add(this.handleIntentionToReviewAccount);
			this.view.legendsClicked.add(this.showLegendsScreen);
			this.view.supportClicked.add(this.openSupportPage);
			if(this.playerModel.isNewToEditing()) {
				this.view.putNoticeTagToOption(ButtonFactory.getEditorButton(),"new");
			}
			if(this.securityQuestionsModel.showSecurityQuestionsOnStartup) {
				this.openDialog.dispatch(new SecurityQuestionsInfoDialog());
			}
			if(!Parameters.sessionStarted) {
				Parameters.sessionStarted = true;
			}
		}
		
		private function openSupportPage() : void {
			var loc1:URLRequest = new URLRequest();
			loc1.url = "https://decagames.desk.com";
			navigateToURL(loc1,"_blank");
		}
		
		private function onSupportVerifyComplete(param1:Boolean, param2:*) : void {
			var loc3:XML = null;
			if(param1) {
				loc3 = new XML(param2);
				if(loc3.hasOwnProperty("mp") && loc3.hasOwnProperty("sg")) {
					this.toSupportPage(loc3.mp,loc3.sg);
				}
			}
		}
		
		private function toSupportPage(param1:String, param2:String) : void {
			var loc3:URLVariables = new URLVariables();
			var loc4:URLRequest = new URLRequest();
			var loc5:Boolean = false;
			loc3.mp = param1;
			loc3.sg = param2;
			if(DynamicSettings.settingExists("SalesforceMobile") && DynamicSettings.getSettingValue("SalesforceMobile") == 1) {
				loc5 = true;
			}
			var loc6:String = this.playerModel.getSalesForceData();
			if(loc6 == "unavailable" || !loc5) {
				loc4.url = "https://decagames.desk.com/customer/authentication/multipass/callback";
				loc4.method = URLRequestMethod.GET;
				loc4.data = loc3;
				navigateToURL(loc4,"_blank");
			} else if(Capabilities.playerType == "PlugIn" || Capabilities.playerType == "ActiveX") {
				if(!supportCalledBefore) {
					ExternalInterface.call("openSalesForceFirstTime",loc6);
					supportCalledBefore = true;
				} else {
					ExternalInterface.call("reopenSalesForce");
				}
			} else {
				loc3.data = loc6;
				loc4.url = "https://decagames.desk.com/customer/authentication/multipass/callback";
				loc4.method = URLRequestMethod.GET;
				loc4.data = loc3;
				navigateToURL(loc4,"_blank");
			}
		}
		
		private function onOptionalButtonsAdded() : void {
			this.view.editorClicked && this.view.editorClicked.add(this.showMapEditor);
			this.view.quitClicked && this.view.quitClicked.add(this.attemptToCloseClient);
		}
		
		private function makeEnvironmentData() : EnvironmentData {
			var loc1:EnvironmentData = new EnvironmentData();
			loc1.isDesktop = Capabilities.playerType == "Desktop";
			loc1.canMapEdit = this.playerModel.isAdmin() || this.playerModel.mapEditor();
			loc1.buildLabel = this.setup.getBuildLabel();
			return loc1;
		}
		
		override public function destroy() : void {
			this.view.playClicked.remove(this.handleIntentionToPlay);
			this.view.serversClicked.remove(this.showServersScreen);
			this.view.accountClicked.remove(this.handleIntentionToReviewAccount);
			this.view.legendsClicked.remove(this.showLegendsScreen);
			this.view.supportClicked.remove(this.openSupportPage);
			this.view.optionalButtonsAdded.remove(this.onOptionalButtonsAdded);
			this.view.editorClicked && this.view.editorClicked.remove(this.showMapEditor);
			this.view.quitClicked && this.view.quitClicked.remove(this.attemptToCloseClient);
		}
		
		private function handleIntentionToPlay() : void {
			if(this.account.isRegistered()) {
				this.enterGame.dispatch();
			} else {
				this.openAccountInfo.dispatch(false);
			}
		}
		
		private function showServersScreen() : void {
			this.setScreen.dispatch(new ServersScreen());
		}
		
		private function handleIntentionToReviewAccount() : void {
			this.openAccountInfo.dispatch(false);
		}
		
		private function showLegendsScreen() : void {
			this.setScreen.dispatch(new LegendsView());
		}
		
		private function showMapEditor() : void {
			this.setScreen.dispatch(new MapEditor());
		}
		
		private function attemptToCloseClient() : void {
			dispatch(new Event("APP_CLOSE_EVENT"));
		}
	}
}
