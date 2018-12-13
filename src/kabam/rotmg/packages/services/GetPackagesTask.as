package kabam.rotmg.packages.services {
	import com.company.assembleegameclient.util.TimeUtil;

	import kabam.lib.tasks.BaseTask;
	import kabam.rotmg.account.core.Account;
	import kabam.rotmg.appengine.api.AppEngineClient;
	import kabam.rotmg.language.model.LanguageModel;
	import kabam.rotmg.packages.model.PackageInfo;

	import robotlegs.bender.framework.api.ILogger;

	public class GetPackagesTask extends BaseTask {

		private static var version:String = "0";


		[Inject]
		public var client:AppEngineClient;

		[Inject]
		public var packageModel:PackageModel;

		[Inject]
		public var account:Account;

		[Inject]
		public var logger:ILogger;

		[Inject]
		public var languageModel:LanguageModel;

		public function GetPackagesTask() {
			super();
		}

		override protected function startTask():void {
			var loc1:Object = this.account.getCredentials();
			loc1.language = this.languageModel.getLanguage();
			loc1.version = version;
			this.client.sendRequest("/package/getPackages", loc1);
			this.client.complete.addOnce(this.onComplete);
		}

		private function onComplete(param1:Boolean, param2:*):void {
			if (param1) {
				this.handleOkay(param2);
			} else {
				this.logger.warn("GetPackageTask.onComplete: Request failed.");
				completeTask(true);
			}
			reset();
		}

		private function handleOkay(param1:*):void {
			version = XML(param1).attribute("version").toString();
			var loc2:XMLList = XML(param1).child("Package");
			var loc3:XMLList = XML(param1).child("SoldCounter");
			if (loc3.length() > 0) {
				this.updateSoldCounters(loc3);
			}
			if (loc2.length() > 0) {
				this.parse(loc2);
			} else if (this.packageModel.getInitialized()) {
				this.packageModel.updateSignal.dispatch();
			}
			completeTask(true);
		}

		private function updateSoldCounters(param1:XMLList):void {
			var loc2:XML = null;
			var loc3:PackageInfo = null;
			for each(loc2 in param1) {
				loc3 = this.packageModel.getPackageById(loc2.attribute("id").toString());
				loc3.unitsLeft = loc2.attribute("left");
			}
		}

		private function hasNoPackage(param1:*):Boolean {
			var loc2:XMLList = XML(param1).children();
			var loc3:* = loc2.length() == 0;
			return loc3;
		}

		private function parse(param1:XMLList):void {
			var loc3:XML = null;
			var loc4:PackageInfo = null;
			var loc2:Array = [];
			for each(loc3 in param1) {
				loc4 = new PackageInfo();
				loc4.id = loc3.attribute("id").toString();
				loc4.title = loc3.attribute("title").toString();
				loc4.weight = loc3.attribute("weight").toString();
				loc4.description = loc3.Description.toString();
				loc4.contents = loc3.Contents.toString();
				loc4.priceAmount = int(loc3.Price.attribute("amount").toString());
				loc4.priceCurrency = loc3.Price.attribute("currency").toString();
				if (loc3.hasOwnProperty("Sale")) {
					loc4.saleAmount = int(loc3.Sale.attribute("price").toString());
					loc4.saleCurrency = int(loc3.Sale.attribute("currency").toString());
					if (loc3.Sale.End.toString()) {
						loc4.saleEnd = TimeUtil.parseUTCDate(loc3.Sale.End.toString());
					}
				}
				if (loc3.hasOwnProperty("Left")) {
					loc4.unitsLeft = loc3.Left;
				}
				if (loc3.hasOwnProperty("ShowOnLogin")) {
					loc4.showOnLogin = int(loc3.ShowOnLogin) == 1;
				}
				if (loc3.hasOwnProperty("Total")) {
					loc4.totalUnits = loc3.Total;
				}
				if (loc3.hasOwnProperty("Slot")) {
					loc4.slot = loc3.Slot;
				}
				if (loc3.hasOwnProperty("Tags")) {
					loc4.tags = loc3.Tags;
				}
				loc4.startTime = TimeUtil.parseUTCDate(loc3.StartTime.toString());
				if (loc3.EndTime.toString()) {
					loc4.endTime = TimeUtil.parseUTCDate(loc3.EndTime.toString());
				}
				loc4.image = loc3.Image.toString();
				loc4.charSlot = int(loc3.CharSlot.toString());
				loc4.vaultSlot = int(loc3.VaultSlot.toString());
				loc4.gold = int(loc3.Gold.toString());
				if (loc3.PopupImage.toString() != "") {
					loc4.popupImage = loc3.PopupImage.toString();
				}
				loc2.push(loc4);
			}
			this.packageModel.setPackages(loc2);
		}
	}
}
