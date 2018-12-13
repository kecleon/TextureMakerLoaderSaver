 
package kabam.rotmg.account.kongregate.services {
	import com.company.assembleegameclient.util.offer.Offer;
	import kabam.lib.tasks.BaseTask;
	import kabam.rotmg.account.core.Account;
	import kabam.rotmg.account.core.PaymentData;
	import kabam.rotmg.account.core.services.MakePaymentTask;
	import kabam.rotmg.account.kongregate.view.KongregateApi;
	
	public class KongregateMakePaymentTask extends BaseTask implements MakePaymentTask {
		 
		
		[Inject]
		public var payment:PaymentData;
		
		[Inject]
		public var account:Account;
		
		[Inject]
		public var api:KongregateApi;
		
		public function KongregateMakePaymentTask() {
			super();
		}
		
		override protected function startTask() : void {
			var loc1:Offer = this.payment.offer;
			var loc2:Object = {
				"identifier":loc1.id_,
				"data":loc1.data_
			};
			this.api.purchaseResponse.addOnce(this.onPurchaseResult);
			this.api.purchaseItems(loc2);
		}
		
		private function onPurchaseResult(param1:Object) : void {
			completeTask(true);
		}
	}
}
