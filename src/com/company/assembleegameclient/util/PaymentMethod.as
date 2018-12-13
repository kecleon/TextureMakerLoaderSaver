 
package com.company.assembleegameclient.util {
	import com.company.assembleegameclient.util.offer.Offer;
	import flash.net.URLVariables;
	import kabam.rotmg.account.core.Account;
	import kabam.rotmg.application.api.ApplicationSetup;
	import kabam.rotmg.core.StaticInjectorContext;
	import kabam.rotmg.text.model.TextKey;
	
	public class PaymentMethod {
		
		public static const GO_METHOD:PaymentMethod = new PaymentMethod(TextKey.PAYMENTS_GOOGLE_CHECKOUT,"co","");
		
		public static const PAYPAL_METHOD:PaymentMethod = new PaymentMethod(TextKey.PAYMENTS_PAYPAL,"ps","P3");
		
		public static const CREDITS_METHOD:PaymentMethod = new PaymentMethod(TextKey.PAYMENTS_CREDIT_CARDS,"ps","CH");
		
		public static const PAYMENT_METHODS:Vector.<PaymentMethod> = new <PaymentMethod>[GO_METHOD,PAYPAL_METHOD,CREDITS_METHOD];
		 
		
		public var label_:String;
		
		public var provider_:String;
		
		public var paymentid_:String;
		
		public function PaymentMethod(param1:String, param2:String, param3:String) {
			super();
			this.label_ = param1;
			this.provider_ = param2;
			this.paymentid_ = param3;
		}
		
		public static function getPaymentMethodByLabel(param1:String) : PaymentMethod {
			var loc2:PaymentMethod = null;
			for each(loc2 in PAYMENT_METHODS) {
				if(loc2.label_ == param1) {
					return loc2;
				}
			}
			return null;
		}
		
		public function getURL(param1:String, param2:String, param3:Offer) : String {
			var loc4:Account = StaticInjectorContext.getInjector().getInstance(Account);
			var loc5:ApplicationSetup = StaticInjectorContext.getInjector().getInstance(ApplicationSetup);
			var loc6:URLVariables = new URLVariables();
			loc6["tok"] = param1;
			loc6["exp"] = param2;
			loc6["guid"] = loc4.getUserId();
			loc6["provider"] = this.provider_;
			switch(this.provider_) {
				case "co":
					loc6["jwt"] = param3.jwt_;
					break;
				case "ps":
					loc6["jwt"] = param3.jwt_;
					loc6["price"] = param3.price_.toString();
					loc6["paymentid"] = this.paymentid_;
			}
			return loc5.getAppEngineUrl(true) + "/credits/add?" + loc6.toString();
		}
	}
}
