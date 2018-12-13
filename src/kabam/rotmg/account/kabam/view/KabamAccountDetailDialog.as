 
package kabam.rotmg.account.kabam.view {
	import com.company.assembleegameclient.account.ui.Frame;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import kabam.rotmg.text.model.TextKey;
	import kabam.rotmg.text.view.TextFieldDisplayConcrete;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;
	import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
	import org.osflash.signals.Signal;
	
	public class KabamAccountDetailDialog extends Sprite {
		 
		
		public var done:Signal;
		
		private var loginText_:TextFieldDisplayConcrete;
		
		private var usernameText_:TextFieldDisplayConcrete;
		
		public function KabamAccountDetailDialog() {
			super();
			this.done = new Signal();
		}
		
		public function setInfo(param1:String) : void {
			var loc2:Frame = null;
			loc2 = new Frame(TextKey.KABAMACCOUNTDETAILDIALOG_TITLE,"",TextKey.KABAMACCOUNTDETAILDIALOG_RIGHTBUTTON,"/currentKabamLogin");
			addChild(loc2);
			this.loginText_ = new TextFieldDisplayConcrete().setSize(18).setColor(11776947);
			this.loginText_.setBold(true);
			this.loginText_.setStringBuilder(new LineBuilder().setParams(TextKey.KABAMACCOUNTDETAILDIALOG_LOGINTEXT));
			this.loginText_.filters = [new DropShadowFilter(0,0,0)];
			this.loginText_.y = loc2.h_ - 60;
			this.loginText_.x = 17;
			loc2.addChild(this.loginText_);
			this.usernameText_ = new TextFieldDisplayConcrete().setSize(16).setColor(11776947).setTextWidth(238).setTextHeight(30);
			this.usernameText_.setStringBuilder(new StaticStringBuilder(param1));
			this.usernameText_.y = loc2.h_ - 30;
			this.usernameText_.x = 17;
			loc2.addChild(this.usernameText_);
			loc2.h_ = loc2.h_ + 88;
			loc2.w_ = loc2.w_ + 60;
			loc2.rightButton_.addEventListener(MouseEvent.CLICK,this.onContinue);
		}
		
		private function onContinue(param1:MouseEvent) : void {
			this.done.dispatch();
		}
	}
}
