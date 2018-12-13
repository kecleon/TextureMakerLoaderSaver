package kabam.rotmg.mysterybox.services {
	import com.company.assembleegameclient.util.TimeUtil;

	import kabam.lib.tasks.BaseTask;
	import kabam.rotmg.account.core.Account;
	import kabam.rotmg.appengine.api.AppEngineClient;
	import kabam.rotmg.dialogs.control.OpenDialogSignal;
	import kabam.rotmg.fortune.model.FortuneInfo;
	import kabam.rotmg.fortune.services.FortuneModel;
	import kabam.rotmg.language.model.LanguageModel;
	import kabam.rotmg.mysterybox.model.MysteryBoxInfo;

	import robotlegs.bender.framework.api.ILogger;

	public class GetMysteryBoxesTask extends BaseTask {

		private static var version:String = "0";


		[Inject]
		public var client:AppEngineClient;

		[Inject]
		public var mysteryBoxModel:MysteryBoxModel;

		[Inject]
		public var fortuneModel:FortuneModel;

		[Inject]
		public var account:Account;

		[Inject]
		public var logger:ILogger;

		[Inject]
		public var languageModel:LanguageModel;

		[Inject]
		public var openDialogSignal:OpenDialogSignal;

		public function GetMysteryBoxesTask() {
			super();
		}

		override protected function startTask():void {
			var loc1:Object = this.account.getCredentials();
			loc1.language = this.languageModel.getLanguage();
			loc1.version = version;
			this.client.sendRequest("/mysterybox/getBoxes", loc1);
			this.client.complete.addOnce(this.onComplete);
		}

		private function onComplete(param1:Boolean, param2:*):void {
			if (param1) {
				this.handleOkay(param2);
			} else {
				this.logger.warn("GetMysteryBox.onComplete: Request failed.");
				completeTask(true);
			}
			reset();
		}

		private function handleOkay(param1:*):void {
			version = XML(param1).attribute("version").toString();
			var loc2:XMLList = XML(param1).child("MysteryBox");
			var loc3:XMLList = XML(param1).child("SoldCounter");
			if (loc3.length() > 0) {
				this.updateSoldCounters(loc3);
			}
			if (loc2.length() > 0) {
				this.parse(loc2);
			} else if (this.mysteryBoxModel.isInitialized()) {
				this.mysteryBoxModel.updateSignal.dispatch();
			}
			var loc4:XMLList = XML(param1).child("FortuneGame");
			if (loc4.length() > 0) {
				this.parseFortune(loc4);
			}
			completeTask(true);
		}

		private function hasNoBoxes(param1:*):Boolean {
			var loc2:XMLList = XML(param1).children();
			var loc3:* = loc2.length() == 0;
			return loc3;
		}

		private function parseFortune(param1:XMLList):void {
			var loc2:FortuneInfo = new FortuneInfo();
			loc2.id = param1.attribute("id").toString();
			loc2.title = param1.attribute("title").toString();
			loc2.weight = param1.attribute("weight").toString();
			loc2.description = param1.Description.toString();
			loc2.contents = param1.Contents.toString();
			loc2.priceFirstInGold = param1.Price.attribute("firstInGold").toString();
			loc2.priceFirstInToken = param1.Price.attribute("firstInToken").toString();
			loc2.priceSecondInGold = param1.Price.attribute("secondInGold").toString();
			loc2.iconImageUrl = param1.Icon.toString();
			loc2.infoImageUrl = param1.Image.toString();
			loc2.startTime = TimeUtil.parseUTCDate(param1.StartTime.toString());
			loc2.endTime = TimeUtil.parseUTCDate(param1.EndTime.toString());
			loc2.parseContents();
			this.fortuneModel.setFortune(loc2);
		}

		private function updateSoldCounters(param1:XMLList):void {
			var loc2:XML = null;
			var loc3:MysteryBoxInfo = null;
			for each(loc2 in param1) {
				loc3 = this.mysteryBoxModel.getBoxById(loc2.attribute("id").toString());
				loc3.unitsLeft = loc2.attribute("left");
			}
		}

		private function parse(param1:XMLList):void {
			var loc4:XML = null;
			var loc5:MysteryBoxInfo = null;
			var loc2:Array = [];
			var loc3:Boolean = false;
			for each(loc4 in param1) {
				loc5 = new MysteryBoxInfo();
				loc5.id = loc4.attribute("id").toString();
				loc5.title = loc4.attribute("title").toString();
				loc5.weight = loc4.attribute("weight").toString();
				loc5.description = loc4.Description.toString();
				loc5.contents = loc4.Contents.toString();
				loc5.priceAmount = int(loc4.Price.attribute("amount").toString());
				loc5.priceCurrency = loc4.Price.attribute("currency").toString();
				if (loc4.hasOwnProperty("Sale")) {
					loc5.saleAmount = loc4.Sale.attribute("price").toString();
					loc5.saleCurrency = loc4.Sale.attribute("currency").toString();
					loc5.saleEnd = TimeUtil.parseUTCDate(loc4.Sale.End.toString());
				}
				if (loc4.hasOwnProperty("Left")) {
					loc5.unitsLeft = loc4.Left;
				}
				if (loc4.hasOwnProperty("Total")) {
					loc5.totalUnits = loc4.Total;
				}
				if (loc4.hasOwnProperty("Slot")) {
					loc5.slot = loc4.Slot;
				}
				if (loc4.hasOwnProperty("Jackpots")) {
					loc5.jackpots = loc4.Jackpots;
				}
				if (loc4.hasOwnProperty("DisplayedItems")) {
					loc5.displayedItems = loc4.DisplayedItems;
				}
				if (loc4.hasOwnProperty("Rolls")) {
					loc5.rolls = int(loc4.Rolls);
				}
				if (loc4.hasOwnProperty("Tags")) {
					loc5.tags = loc4.Tags;
				}
				loc5.iconImageUrl = loc4.Icon.toString();
				loc5.infoImageUrl = loc4.Image.toString();
				loc5.startTime = TimeUtil.parseUTCDate(loc4.StartTime.toString());
				if (loc4.EndTime.toString()) {
					loc5.endTime = TimeUtil.parseUTCDate(loc4.EndTime.toString());
				}
				loc5.parseContents();
				if (!loc3 && (loc5.isNew() || loc5.isOnSale())) {
					loc3 = true;
				}
				loc2.push(loc5);
			}
			this.mysteryBoxModel.setMysetryBoxes(loc2);
			this.mysteryBoxModel.isNew = loc3;
		}
	}
}
