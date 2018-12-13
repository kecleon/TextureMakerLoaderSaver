package kabam.rotmg.account.kongregate.view {
	import com.company.assembleegameclient.account.ui.Frame;
	import com.company.assembleegameclient.ui.DeprecatedClickableText;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;

	import kabam.rotmg.text.model.TextKey;
	import kabam.rotmg.text.view.TextFieldDisplayConcrete;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;
	import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;

	import org.osflash.signals.Signal;

	public class KongregateAccountDetailDialog extends Sprite {


		public var done:Signal;

		public var register:Signal;

		public var link:Signal;

		private var loginText_:TextFieldDisplayConcrete;

		private var usernameText_:TextFieldDisplayConcrete;

		private var webLoginText_:TextFieldDisplayConcrete;

		private var emailText_:TextFieldDisplayConcrete;

		private var register_:DeprecatedClickableText;

		public function KongregateAccountDetailDialog() {
			super();
			this.done = new Signal();
			this.register = new Signal();
		}

		public function setInfo(param1:String, param2:String, param3:Boolean):void {
			var loc4:Frame = null;
			loc4 = new Frame(TextKey.KONGREGATEACCOUNTDETAILDIALOG_TITLE, "", TextKey.KONGREGATEACCOUNTDETAILDIALOG_RIGHTBUTTON, "/kongregateCurrentLogin");
			addChild(loc4);
			this.loginText_ = new TextFieldDisplayConcrete().setSize(18).setColor(11776947);
			this.loginText_.setBold(true);
			this.loginText_.setStringBuilder(new LineBuilder().setParams(TextKey.KONGREGATEACCOUNTDETAILDIALOG_TITLE));
			this.loginText_.filters = [new DropShadowFilter(0, 0, 0)];
			this.loginText_.y = loc4.h_ - 60;
			this.loginText_.x = 17;
			loc4.addChild(this.loginText_);
			this.usernameText_ = new TextFieldDisplayConcrete().setSize(16).setColor(11776947).setTextWidth(238).setTextHeight(30);
			this.usernameText_.setStringBuilder(new StaticStringBuilder(param1));
			this.usernameText_.y = loc4.h_ - 30;
			this.usernameText_.x = 17;
			loc4.addChild(this.usernameText_);
			loc4.h_ = loc4.h_ + 88;
			if (param3) {
				loc4.h_ = loc4.h_ - 20;
				this.webLoginText_ = new TextFieldDisplayConcrete().setSize(18).setColor(11776947);
				this.webLoginText_.setBold(true);
				this.webLoginText_.setStringBuilder(new LineBuilder().setParams(TextKey.KONGREGATEACCOUNTDETAILDIALOG_LINKWEB));
				this.webLoginText_.filters = [new DropShadowFilter(0, 0, 0)];
				this.webLoginText_.y = loc4.h_ - 60;
				this.webLoginText_.x = 17;
				loc4.addChild(this.webLoginText_);
				this.emailText_ = new TextFieldDisplayConcrete().setSize(16).setColor(11776947).setTextWidth(238).setTextHeight(30);
				this.emailText_.setStringBuilder(new StaticStringBuilder(param2));
				this.emailText_.y = loc4.h_ - 30;
				this.emailText_.x = 17;
				loc4.addChild(this.emailText_);
				loc4.h_ = loc4.h_ + 88;
			} else {
				this.register_ = new DeprecatedClickableText(12, false, TextKey.KONGREGATEACCOUNTDETAILDIALOG_REGISTER);
				this.register_.addEventListener(MouseEvent.CLICK, this.onRegister);
			}
			loc4.rightButton_.addEventListener(MouseEvent.CLICK, this.onContinue);
		}

		private function onContinue(param1:MouseEvent):void {
			this.done.dispatch();
		}

		public function onRegister(param1:MouseEvent):void {
			this.register.dispatch();
		}
	}
}
