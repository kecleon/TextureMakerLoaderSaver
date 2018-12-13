package kabam.rotmg.messaging.impl {
	import kabam.rotmg.core.StaticInjectorContext;
	import kabam.rotmg.core.service.GoogleAnalytics;

	class OutstandingBuy {


		private var id_:String;

		private var price_:int;

		private var currency_:int;

		private var converted_:Boolean;

		function OutstandingBuy(param1:String, param2:int, param3:int, param4:Boolean) {
			super();
			this.id_ = param1;
			this.price_ = param2;
			this.currency_ = param3;
			this.converted_ = param4;
		}

		public function record():void {
			var loc1:GoogleAnalytics = StaticInjectorContext.getInjector().getInstance(GoogleAnalytics);
			if (!loc1) {
			}
		}
	}
}
