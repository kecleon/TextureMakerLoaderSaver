package com.company.assembleegameclient.util.offer {
	public class Offers {

		private static const BEST_DEAL:String = "(Best deal)";

		private static const MOST_POPULAR:String = "(Most popular)";


		public var tok:String;

		public var exp:String;

		public var offerList:Vector.<Offer>;

		public function Offers(param1:XML) {
			super();
			this.tok = param1.Tok;
			this.exp = param1.Exp;
			this.makeOffers(param1);
		}

		private function makeOffers(param1:XML):void {
			this.makeOfferList(param1);
			this.sortOfferList();
			this.defineBonuses();
			this.defineMostPopularTagline();
			this.defineBestDealTagline();
		}

		private function makeOfferList(param1:XML):void {
			var loc2:XML = null;
			this.offerList = new Vector.<Offer>(0);
			for each(loc2 in param1.Offer) {
				this.offerList.push(this.makeOffer(loc2));
			}
		}

		private function makeOffer(param1:XML):Offer {
			var loc2:String = param1.Id;
			var loc3:Number = Number(param1.Price);
			var loc4:int = int(param1.RealmGold);
			var loc5:String = param1.CheckoutJWT;
			var loc6:String = param1.Data;
			var loc7:String = !!param1.hasOwnProperty("Currency") ? param1.Currency : null;
			return new Offer(loc2, loc3, loc4, loc5, loc6, loc7);
		}

		private function sortOfferList():void {
			this.offerList.sort(this.sortOffers);
		}

		private function defineBonuses():void {
			var loc5:int = 0;
			var loc6:int = 0;
			var loc7:Number = NaN;
			var loc8:Number = NaN;
			if (this.offerList.length == 0) {
				return;
			}
			var loc1:int = this.offerList[0].realmGold_;
			var loc2:int = this.offerList[0].price_;
			var loc3:Number = loc1 / loc2;
			var loc4:int = 1;
			while (loc4 < this.offerList.length) {
				loc5 = this.offerList[loc4].realmGold_;
				loc6 = this.offerList[loc4].price_;
				loc7 = loc6 * loc3;
				loc8 = loc5 - loc7;
				this.offerList[loc4].bonus = loc8 / loc6;
				loc4++;
			}
		}

		private function sortOffers(param1:Offer, param2:Offer):int {
			return param1.price_ - param2.price_;
		}

		private function defineMostPopularTagline():void {
			var loc1:Offer = null;
			for each(loc1 in this.offerList) {
				if (loc1.price_ == 10) {
					loc1.tagline = MOST_POPULAR;
				}
			}
		}

		private function defineBestDealTagline():void {
			this.offerList[this.offerList.length - 1].tagline = BEST_DEAL;
		}
	}
}
