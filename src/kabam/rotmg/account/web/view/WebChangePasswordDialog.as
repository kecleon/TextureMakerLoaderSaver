 
package kabam.rotmg.account.web.view {
	import com.company.assembleegameclient.account.ui.Frame;
	import com.company.assembleegameclient.account.ui.TextInputField;
	import flash.events.MouseEvent;
	import kabam.rotmg.account.web.model.ChangePasswordData;
	import kabam.rotmg.text.model.TextKey;
	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeMappedSignal;
	
	public class WebChangePasswordDialog extends Frame {
		 
		
		public var cancel:Signal;
		
		public var change:Signal;
		
		public var password_:TextInputField;
		
		public var newPassword_:TextInputField;
		
		public var retypeNewPassword_:TextInputField;
		
		public function WebChangePasswordDialog() {
			super(TextKey.WEB_CHANGE_PASSWORD_TITLE,TextKey.WEB_CHANGE_PASSWORD_LEFT,TextKey.WEB_CHANGE_PASSWORD_RIGHT,"/changePassword");
			this.password_ = new TextInputField(TextKey.WEB_CHANGE_PASSWORD_PASSWORD,true);
			addTextInputField(this.password_);
			this.newPassword_ = new TextInputField(TextKey.WEB_CHANGE_PASSWORD_NEW_PASSWORD,true);
			addTextInputField(this.newPassword_);
			this.retypeNewPassword_ = new TextInputField(TextKey.WEB_CHANGE_PASSWORD_RETYPE_PASSWORD,true);
			addTextInputField(this.retypeNewPassword_);
			this.cancel = new NativeMappedSignal(leftButton_,MouseEvent.CLICK);
			this.change = new NativeMappedSignal(rightButton_,MouseEvent.CLICK);
		}
		
		private function onChange(param1:MouseEvent) : void {
			var loc2:ChangePasswordData = null;
			if(this.isCurrentPasswordValid() && this.isNewPasswordValid() && this.isNewPasswordVerified()) {
				disable();
				loc2 = new ChangePasswordData();
				loc2.currentPassword = this.password_.text();
				loc2.newPassword = this.newPassword_.text();
				this.change.dispatch(loc2);
			}
		}
		
		private function isCurrentPasswordValid() : Boolean {
			var loc1:* = this.password_.text().length >= 5;
			if(!loc1) {
				this.password_.setError(TextKey.WEB_CHANGE_PASSWORD_INCORRECT);
			}
			return loc1;
		}
		
		private function isNewPasswordValid() : Boolean {
			var loc1:* = this.newPassword_.text().length >= 5;
			if(!loc1) {
				this.newPassword_.setError(TextKey.LINK_WEB_ACCOUNT_SHORT);
			}
			return loc1;
		}
		
		private function isNewPasswordVerified() : Boolean {
			var loc1:* = this.newPassword_.text() == this.retypeNewPassword_.text();
			if(!loc1) {
				this.retypeNewPassword_.setError(TextKey.PASSWORD_DOES_NOT_MATCH);
			}
			return loc1;
		}
		
		public function setError(param1:String) : void {
			this.password_.setError(param1);
		}
		
		public function clearError() : void {
			this.password_.clearError();
			this.retypeNewPassword_.clearError();
			this.newPassword_.clearError();
		}
	}
}
