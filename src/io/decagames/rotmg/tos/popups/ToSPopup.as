 
package io.decagames.rotmg.tos.popups {
	import com.company.assembleegameclient.parameters.Parameters;
	import io.decagames.rotmg.tos.popups.buttons.AcceptButton;
	import io.decagames.rotmg.tos.popups.buttons.RefuseButton;
	import io.decagames.rotmg.ui.buttons.BaseButton;
	import io.decagames.rotmg.ui.popups.modal.TextModal;
	
	public class ToSPopup extends TextModal {
		 
		
		public function ToSPopup() {
			var loc1:Vector.<BaseButton> = new Vector.<BaseButton>();
			loc1.push(new RefuseButton());
			loc1.push(new AcceptButton());
			var loc2:* = "<font color=\"#7777EE\"><a href=\"" + Parameters.TERMS_OF_USE_URL + "\" target=\"_blank\">Terms of Service</a></font>";
			var loc3:* = "<font color=\"#7777EE\"><a href=\"" + Parameters.PRIVACY_POLICY_URL + "\" target=\"_blank\">Privacy Policy</a></font>";
			super(400,"Update to Terms of Service and Privacy","We have updated our " + loc2 + " and " + loc3 + " to be compliant with the new European regulations regarding data privacy and make them clearer for you to understand." + "\n\n" + "You need to review and accept our Terms of Service and Privacy Policy in order to be able to continue playing Realm of the Mad God." + "\n\n" + "By clicking accept you hereby confirm that you are at least 16 years old.",loc1,true);
		}
	}
}
