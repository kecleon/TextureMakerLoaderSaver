 
package kabam.rotmg.account.web.view {
	import kabam.rotmg.account.core.Account;
	import kabam.rotmg.account.web.signals.WebChangePasswordSignal;
	import kabam.rotmg.appengine.api.AppEngineClient;
	import kabam.rotmg.core.StaticInjectorContext;
	import kabam.rotmg.core.signals.TaskErrorSignal;
	import kabam.rotmg.dialogs.control.CloseDialogsSignal;
	import kabam.rotmg.dialogs.control.OpenDialogSignal;
	import kabam.rotmg.text.model.TextKey;
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	public class WebChangePasswordMediatorForced extends Mediator {
		 
		
		[Inject]
		public var view:WebChangePasswordDialogForced;
		
		[Inject]
		public var change:WebChangePasswordSignal;
		
		[Inject]
		public var openDialog:OpenDialogSignal;
		
		[Inject]
		public var closeDialogs:CloseDialogsSignal;
		
		[Inject]
		public var loginError:TaskErrorSignal;
		
		[Inject]
		public var account:Account;
		
		private var newPassword:String;
		
		public function WebChangePasswordMediatorForced() {
			super();
		}
		
		override public function initialize() : void {
			this.view.change.add(this.onChange);
			this.loginError.add(this.onError);
		}
		
		override public function destroy() : void {
			this.view.change.remove(this.onChange);
			this.loginError.remove(this.onError);
		}
		
		private function onChange() : void {
			var loc1:AppEngineClient = null;
			var loc2:Object = null;
			if(this.isCurrentPasswordValid() && this.isNewPasswordValid() && this.isNewPasswordVerified()) {
				this.view.clearError();
				this.view.disable();
				loc1 = StaticInjectorContext.getInjector().getInstance(AppEngineClient);
				loc2 = {};
				loc2.password = this.view.password_.text();
				this.newPassword = this.view.newPassword_.text();
				loc2.newPassword = this.view.newPassword_.text();
				loc2.guid = this.account.getUserId();
				loc1.sendRequest("/account/changePassword",loc2);
				loc1.complete.addOnce(this.onComplete);
			}
		}
		
		private function isCurrentPasswordValid() : Boolean {
			var loc1:* = this.view.password_.text().length >= 5;
			if(!loc1) {
				this.view.password_.setError(TextKey.WEB_CHANGE_PASSWORD_INCORRECT);
			}
			return loc1;
		}
		
		private function isNewPasswordValid() : Boolean {
			var loc1:* = this.view.newPassword_.text().length >= 10;
			if(!loc1) {
				this.view.newPassword_.setError(TextKey.REGISTER_WEB_SHORT_ERROR);
			}
			return loc1;
		}
		
		private function isNewPasswordVerified() : Boolean {
			var loc1:* = this.view.newPassword_.text() == this.view.retypeNewPassword_.text();
			if(!loc1) {
				this.view.retypeNewPassword_.setError(TextKey.REGISTER_WEB_MATCH_ERROR);
			}
			return loc1;
		}
		
		private function onComplete(param1:Boolean, param2:*) : void {
			if(!param1) {
				this.onError(param2);
			} else {
				this.account.updateUser(this.account.getUserId(),this.newPassword,this.account.getToken());
				this.closeDialogs.dispatch();
			}
		}
		
		private function onError(param1:String) : void {
			this.view.newPassword_.setError(param1);
			this.view.enable();
		}
	}
}
