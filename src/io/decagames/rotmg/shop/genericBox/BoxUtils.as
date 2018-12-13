package io.decagames.rotmg.shop.genericBox {
	import com.company.assembleegameclient.objects.Player;
	import com.company.assembleegameclient.util.Currency;

	import io.decagames.rotmg.shop.NotEnoughResources;
	import io.decagames.rotmg.shop.genericBox.data.GenericBoxInfo;
	import io.decagames.rotmg.ui.popups.signals.ShowPopupSignal;

	import kabam.rotmg.core.model.PlayerModel;
	import kabam.rotmg.game.model.GameModel;

	public class BoxUtils {


		public function BoxUtils() {
			super();
		}

		public static function moneyCheckPass(param1:GenericBoxInfo, param2:int, param3:GameModel, param4:PlayerModel, param5:ShowPopupSignal):Boolean {
			var loc6:int = 0;
			var loc7:int = 0;
			if (param1.isOnSale() && param1.saleAmount > 0) {
				loc6 = int(param1.saleCurrency);
				loc7 = int(param1.saleAmount) * param2;
			} else {
				loc6 = int(param1.priceCurrency);
				loc7 = int(param1.priceAmount) * param2;
			}
			var loc8:Boolean = true;
			var loc9:int = 0;
			var loc10:int = 0;
			var loc11:Player = param3.player;
			if (loc11 != null) {
				loc10 = loc11.credits_;
				loc9 = loc11.fame_;
			} else if (param4 != null) {
				loc10 = param4.getCredits();
				loc9 = param4.getFame();
			}
			if (loc6 == Currency.GOLD && loc10 < loc7) {
				param5.dispatch(new NotEnoughResources(300, Currency.GOLD));
				loc8 = false;
			} else if (loc6 == Currency.FAME && loc9 < loc7) {
				param5.dispatch(new NotEnoughResources(300, Currency.FAME));
				loc8 = false;
			}
			return loc8;
		}
	}
}
