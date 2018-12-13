package io.decagames.rotmg.shop {
	import com.company.assembleegameclient.util.Currency;

	import io.decagames.rotmg.ui.buttons.BaseButton;
	import io.decagames.rotmg.ui.popups.modal.TextModal;
	import io.decagames.rotmg.ui.popups.modal.buttons.BuyGoldButton;
	import io.decagames.rotmg.ui.popups.modal.buttons.ClosePopupButton;

	public class NotEnoughResources extends TextModal {


		public function NotEnoughResources(param1:int, param2:int) {
			var loc3:String = param2 == Currency.GOLD ? "gold" : "fame";
			var loc4:String = param2 == Currency.GOLD ? "You do not have enough Gold for this item. Would you like to buy Gold?" : "You do not have enough Fame for this item. You gain Fame when your character dies after having accomplished great things.";
			var loc5:Vector.<BaseButton> = new Vector.<BaseButton>();
			loc5.push(new ClosePopupButton("Cancel"));
			if (param2 == Currency.GOLD) {
				loc5.push(new BuyGoldButton());
			}
			super(param1, "Not enough " + loc3, loc4, loc5);
		}
	}
}
