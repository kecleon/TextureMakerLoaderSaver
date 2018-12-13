package kabam.rotmg.editor.view {
	import com.company.assembleegameclient.parameters.Parameters;
	import com.company.assembleegameclient.ui.dialogs.Dialog;

	import flash.display.Sprite;
	import flash.events.Event;

	import kabam.rotmg.text.model.TextKey;
	import kabam.rotmg.ui.view.components.ScreenBase;

	import org.osflash.signals.Signal;

	public class TermsView extends Sprite {


		public const response:Signal = new Signal(Boolean);

		private var termsDialog:Dialog;

		private var rejectDialog:Dialog;

		public function TermsView() {
			super();
			addChild(new ScreenBase());
			this.termsDialog = new Dialog(TextKey.TERMSVIEW_TITLE, "", TextKey.TERMSVIEW_NO, TextKey.TERMSVIEW_YES, null);
			var loc1:* = "<font color=\"#7777EE\"><a href=\"" + Parameters.TERMS_OF_USE_URL + "\" target=\"_blank\">";
			var loc2:String = "</a></font>";
			this.termsDialog.textText_.setHTML(true);
			this.termsDialog.setTextParams(TextKey.TERMSVIEW_DESCRIPTION, {
				"tou": loc1,
				"_tou": loc2
			});
			this.termsDialog.addEventListener(Dialog.LEFT_BUTTON, this.reject);
			this.termsDialog.addEventListener(Dialog.RIGHT_BUTTON, this.agree);
			addChild(this.termsDialog);
		}

		private function agree(param1:Event):void {
			this.response.dispatch(true);
		}

		private function reject(param1:Event):void {
			removeChild(this.termsDialog);
			this.rejectDialog = new Dialog(null, TextKey.TERMSVIEW_TEXT, TextKey.TERMSVIEW_YEAWEARECOOL, null, "/noWay");
			this.rejectDialog.addEventListener(Dialog.LEFT_BUTTON, this.onYeaWereCool);
			addChild(this.rejectDialog);
		}

		private function onYeaWereCool(param1:Event):void {
			removeChild(this.rejectDialog);
			var loc2:Dialog = new Dialog(null, TextKey.TERMSVIEW_PEACEOUT, null, null, "/peaceOut");
			addChild(loc2);
			this.response.dispatch(false);
		}
	}
}
