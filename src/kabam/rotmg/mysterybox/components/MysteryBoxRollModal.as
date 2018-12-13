 
package kabam.rotmg.mysterybox.components {
	import com.company.assembleegameclient.map.ParticleModalMap;
	import com.company.assembleegameclient.objects.ObjectLibrary;
	import com.company.assembleegameclient.objects.Player;
	import com.company.assembleegameclient.ui.dialogs.Dialog;
	import com.company.assembleegameclient.ui.dialogs.NotEnoughFameDialog;
	import com.company.assembleegameclient.util.Currency;
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.easing.Sine;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	import io.decagames.rotmg.pets.utils.PetsViewAssetFactory;
	import io.decagames.rotmg.shop.ShopConfiguration;
	import io.decagames.rotmg.shop.ShopPopupView;
	import kabam.rotmg.account.core.Account;
	import kabam.rotmg.appengine.api.AppEngineClient;
	import kabam.rotmg.assets.EmbeddedAssets;
	import kabam.rotmg.core.StaticInjectorContext;
	import kabam.rotmg.core.model.PlayerModel;
	import kabam.rotmg.dialogs.control.OpenDialogSignal;
	import kabam.rotmg.fortune.components.ItemWithTooltip;
	import kabam.rotmg.game.model.GameModel;
	import kabam.rotmg.mysterybox.model.MysteryBoxInfo;
	import kabam.rotmg.mysterybox.services.GetMysteryBoxesTask;
	import kabam.rotmg.pets.view.components.DialogCloseButton;
	import kabam.rotmg.pets.view.components.PopupWindowBackground;
	import kabam.rotmg.text.view.TextFieldDisplayConcrete;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;
	import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
	import kabam.rotmg.ui.view.NotEnoughGoldDialog;
	import kabam.rotmg.ui.view.components.Spinner;
	import kabam.rotmg.util.components.LegacyBuyButton;
	import kabam.rotmg.util.components.UIAssetsHelper;
	import org.swiftsuspenders.Injector;
	
	public class MysteryBoxRollModal extends Sprite {
		
		public static const WIDTH:int = 415;
		
		public static const HEIGHT:int = 400;
		
		public static const TEXT_MARGIN:int = 20;
		
		public static var open:Boolean;
		 
		
		private const ROLL_STATE:int = 1;
		
		private const IDLE_STATE:int = 0;
		
		private const iconSize:Number = 160;
		
		public var client:AppEngineClient;
		
		public var account:Account;
		
		public var parentSelectModal:MysteryBoxSelectModal;
		
		private var state:int;
		
		private var isShowReward:Boolean = false;
		
		private var rollCount:int = 0;
		
		private var rollTarget:int = 0;
		
		private var quantity_:int = 0;
		
		private var mbi:MysteryBoxInfo;
		
		private var spinners:Sprite;
		
		private var itemBitmaps:Vector.<Bitmap>;
		
		private var rewardsArray:Vector.<ItemWithTooltip>;
		
		private var closeButton:DialogCloseButton;
		
		private var particleModalMap:ParticleModalMap;
		
		private const playAgainString:String = "MysteryBoxRollModal.playAgainString";
		
		private const playAgainXTimesString:String = "MysteryBoxRollModal.playAgainXTimesString";
		
		private const youWonString:String = "MysteryBoxRollModal.youWonString";
		
		private const rewardsInVaultString:String = "MysteryBoxRollModal.rewardsInVaultString";
		
		private var minusNavSprite:Sprite;
		
		private var plusNavSprite:Sprite;
		
		private var boxButton:LegacyBuyButton;
		
		private var titleText:TextFieldDisplayConcrete;
		
		private var infoText:TextFieldDisplayConcrete;
		
		private var descTexts:Vector.<TextFieldDisplayConcrete>;
		
		private var swapImageTimer:Timer;
		
		private var totalRollTimer:Timer;
		
		private var nextRollTimer:Timer;
		
		private var indexInRolls:Vector.<int>;
		
		private var lastReward:String = "";
		
		private var requestComplete:Boolean = false;
		
		private var timerComplete:Boolean = false;
		
		private var goldBackground:DisplayObject;
		
		private var goldBackgroundMask:DisplayObject;
		
		private var rewardsList:Array;
		
		public function MysteryBoxRollModal(param1:MysteryBoxInfo, param2:int) {
			this.spinners = new Sprite();
			this.itemBitmaps = new Vector.<Bitmap>();
			this.rewardsArray = new Vector.<ItemWithTooltip>();
			this.closeButton = PetsViewAssetFactory.returnCloseButton(WIDTH);
			this.boxButton = new LegacyBuyButton(this.playAgainString,16,0,Currency.INVALID);
			this.descTexts = new Vector.<TextFieldDisplayConcrete>();
			this.swapImageTimer = new Timer(50);
			this.totalRollTimer = new Timer(2000);
			this.nextRollTimer = new Timer(800);
			this.indexInRolls = new Vector.<int>();
			this.goldBackground = new EmbeddedAssets.EvolveBackground();
			this.goldBackgroundMask = new EmbeddedAssets.EvolveBackground();
			super();
			this.mbi = param1;
			this.closeButton.disableLegacyCloseBehavior();
			this.closeButton.addEventListener(MouseEvent.CLICK,this.onCloseClick);
			addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
			this.infoText = this.getText(this.rewardsInVaultString,TEXT_MARGIN,220).setSize(20).setColor(0);
			this.infoText.y = 40;
			this.infoText.filters = [];
			this.addComponemts();
			open = true;
			this.boxButton.x = this.boxButton.x + (WIDTH / 2 - 100);
			this.boxButton.y = this.boxButton.y + (HEIGHT - 43);
			this.boxButton._width = 200;
			this.boxButton.addEventListener(MouseEvent.CLICK,this.onRollClick);
			this.minusNavSprite = UIAssetsHelper.createLeftNevigatorIcon(UIAssetsHelper.LEFT_NEVIGATOR,3);
			this.minusNavSprite.addEventListener(MouseEvent.CLICK,this.onNavClick);
			this.minusNavSprite.filters = [new GlowFilter(0,1,2,2,10,1)];
			this.minusNavSprite.x = WIDTH / 2 + 110;
			this.minusNavSprite.y = HEIGHT - 35;
			this.minusNavSprite.alpha = 0;
			addChild(this.minusNavSprite);
			this.plusNavSprite = UIAssetsHelper.createLeftNevigatorIcon(UIAssetsHelper.RIGHT_NEVIGATOR,3);
			this.plusNavSprite.addEventListener(MouseEvent.CLICK,this.onNavClick);
			this.plusNavSprite.filters = [new GlowFilter(0,1,2,2,10,1)];
			this.plusNavSprite.x = WIDTH / 2 + 110;
			this.plusNavSprite.y = HEIGHT - 50;
			this.plusNavSprite.alpha = 0;
			addChild(this.plusNavSprite);
			var loc3:Injector = StaticInjectorContext.getInjector();
			this.client = loc3.getInstance(AppEngineClient);
			this.account = loc3.getInstance(Account);
			var loc4:uint = 0;
			while(loc4 < this.mbi._rollsWithContents.length) {
				this.indexInRolls.push(0);
				loc4++;
			}
			this.centerModal();
			this.configureRollByQuantity(param2);
			this.sendRollRequest();
		}
		
		private static function makeModalBackground(param1:int, param2:int) : PopupWindowBackground {
			var loc3:PopupWindowBackground = new PopupWindowBackground();
			loc3.draw(param1,param2,PopupWindowBackground.TYPE_TRANSPARENT_WITH_HEADER);
			return loc3;
		}
		
		private function configureRollByQuantity(param1:int) : void {
			var loc2:int = 0;
			var loc3:int = 0;
			this.quantity_ = param1;
			switch(param1) {
				case 1:
					this.rollCount = 1;
					this.rollTarget = 1;
					this.swapImageTimer.delay = 50;
					this.totalRollTimer.delay = 2000;
					break;
				case 5:
					this.rollCount = 0;
					this.rollTarget = 4;
					this.swapImageTimer.delay = 50;
					this.totalRollTimer.delay = 1000;
					break;
				case 10:
					this.rollCount = 0;
					this.rollTarget = 9;
					this.swapImageTimer.delay = 50;
					this.totalRollTimer.delay = 1000;
					break;
				default:
					this.rollCount = 1;
					this.rollTarget = 1;
					this.swapImageTimer.delay = 50;
					this.totalRollTimer.delay = 2000;
			}
			if(this.mbi.isOnSale()) {
				loc2 = this.mbi.saleAmount * this.quantity_;
				loc3 = this.mbi.saleCurrency;
			} else {
				loc2 = this.mbi.priceAmount * this.quantity_;
				loc3 = this.mbi.priceCurrency;
			}
			if(this.quantity_ == 1) {
				this.boxButton.setPrice(loc2,this.mbi.priceCurrency);
			} else {
				this.boxButton.currency = loc3;
				this.boxButton.price = loc2;
				this.boxButton.setStringBuilder(new LineBuilder().setParams(this.playAgainXTimesString,{
					"cost":loc2.toString(),
					"repeat":this.quantity_.toString()
				}));
			}
		}
		
		public function getText(param1:String, param2:int, param3:int, param4:Boolean = false) : TextFieldDisplayConcrete {
			var loc5:TextFieldDisplayConcrete = new TextFieldDisplayConcrete().setSize(16).setColor(16777215).setTextWidth(WIDTH - TEXT_MARGIN * 2);
			loc5.setBold(true);
			if(param4) {
				loc5.setStringBuilder(new StaticStringBuilder(param1));
			} else {
				loc5.setStringBuilder(new LineBuilder().setParams(param1));
			}
			loc5.setWordWrap(true);
			loc5.setMultiLine(true);
			loc5.setAutoSize(TextFieldAutoSize.CENTER);
			loc5.setHorizontalAlign(TextFormatAlign.CENTER);
			loc5.filters = [new DropShadowFilter(0,0,0)];
			loc5.x = param2;
			loc5.y = param3;
			return loc5;
		}
		
		private function addComponemts() : void {
			var loc1:int = 27;
			var loc2:int = 28;
			this.goldBackgroundMask.y = this.goldBackground.y = loc1;
			this.goldBackgroundMask.x = this.goldBackground.x = 1;
			this.goldBackgroundMask.width = this.goldBackground.width = WIDTH - 1;
			this.goldBackgroundMask.height = this.goldBackground.height = HEIGHT - loc2;
			addChild(this.goldBackground);
			addChild(this.goldBackgroundMask);
			var loc3:Spinner = new Spinner();
			var loc4:Spinner = new Spinner();
			loc3.degreesPerSecond = 50;
			loc4.degreesPerSecond = loc3.degreesPerSecond * 1.5;
			var loc5:Number = 0.7;
			loc4.width = loc3.width * loc5;
			loc4.height = loc3.height * loc5;
			loc4.alpha = loc3.alpha = 0.7;
			this.spinners.addChild(loc3);
			this.spinners.addChild(loc4);
			this.spinners.mask = this.goldBackgroundMask;
			this.spinners.x = WIDTH / 2;
			this.spinners.y = (HEIGHT - 30) / 3 + 50;
			this.spinners.alpha = 0;
			addChild(this.spinners);
			addChild(makeModalBackground(WIDTH,HEIGHT));
			addChild(this.closeButton);
			this.particleModalMap = new ParticleModalMap(ParticleModalMap.MODE_AUTO_UPDATE);
			addChild(this.particleModalMap);
		}
		
		private function sendRollRequest() : void {
			if(!this.moneyCheckPass()) {
				return;
			}
			this.state = this.ROLL_STATE;
			this.closeButton.visible = false;
			var loc1:Object = this.account.getCredentials();
			loc1.boxId = this.mbi.id;
			if(this.mbi.isOnSale()) {
				loc1.quantity = this.quantity_;
				loc1.price = this.mbi.saleAmount;
				loc1.currency = this.mbi.saleCurrency;
			} else {
				loc1.quantity = this.quantity_;
				loc1.price = this.mbi.priceAmount;
				loc1.currency = this.mbi.priceCurrency;
			}
			this.client.sendRequest("/account/purchaseMysteryBox",loc1);
			this.titleText = this.getText(this.mbi.title,TEXT_MARGIN,6,true).setSize(18);
			this.titleText.setColor(16768512);
			addChild(this.titleText);
			addChild(this.infoText);
			this.playRollAnimation();
			this.lastReward = "";
			this.rewardsList = [];
			this.requestComplete = false;
			this.timerComplete = false;
			this.totalRollTimer.addEventListener(TimerEvent.TIMER,this.onTotalRollTimeComplete);
			this.totalRollTimer.start();
			this.client.complete.addOnce(this.onComplete);
		}
		
		private function playRollAnimation() : void {
			var loc2:Bitmap = null;
			var loc1:int = 0;
			while(loc1 < this.mbi._rollsWithContents.length) {
				loc2 = new Bitmap(ObjectLibrary.getRedrawnTextureFromType(this.mbi._rollsWithContentsUnique[this.indexInRolls[loc1]],this.iconSize,true));
				this.itemBitmaps.push(loc2);
				loc1++;
			}
			this.displayItems(this.itemBitmaps);
			this.swapImageTimer.addEventListener(TimerEvent.TIMER,this.swapItemImage);
			this.swapImageTimer.start();
		}
		
		private function onTotalRollTimeComplete(param1:TimerEvent) : void {
			this.totalRollTimer.stop();
			this.timerComplete = true;
			if(this.requestComplete) {
				this.showReward();
			}
			this.totalRollTimer.removeEventListener(TimerEvent.TIMER,this.onTotalRollTimeComplete);
		}
		
		private function onNextRollTimerComplete(param1:TimerEvent) : void {
			this.nextRollTimer.stop();
			this.nextRollTimer.removeEventListener(TimerEvent.TIMER,this.onNextRollTimerComplete);
			this.shelveReward();
			this.clearReward();
			this.rollCount++;
			this.prepareNextRoll();
		}
		
		private function prepareNextRoll() : void {
			this.titleText = this.getText(this.mbi.title,TEXT_MARGIN,6,true).setSize(18);
			this.titleText.setColor(16768512);
			addChild(this.titleText);
			addChild(this.infoText);
			this.playRollAnimation();
			this.timerComplete = false;
			this.lastReward = this.rewardsList[0];
			this.totalRollTimer.addEventListener(TimerEvent.TIMER,this.onTotalRollTimeComplete);
			this.totalRollTimer.start();
		}
		
		private function swapItemImage(param1:TimerEvent) : void {
			this.swapImageTimer.stop();
			var loc2:uint = 0;
			while(loc2 < this.indexInRolls.length) {
				if(this.indexInRolls[loc2] < this.mbi._rollsWithContentsUnique.length - 1) {
					this.indexInRolls[loc2]++;
				} else {
					this.indexInRolls[loc2] = 0;
				}
				this.itemBitmaps[loc2].bitmapData = new Bitmap(ObjectLibrary.getRedrawnTextureFromType(this.mbi._rollsWithContentsUnique[this.indexInRolls[loc2]],this.iconSize,true)).bitmapData;
				loc2++;
			}
			this.swapImageTimer.start();
		}
		
		private function displayItems(param1:Vector.<Bitmap>) : void {
			var loc2:Bitmap = null;
			switch(param1.length) {
				case 1:
					param1[0].x = param1[0].x + (WIDTH / 2 - 40);
					param1[0].y = param1[0].y + HEIGHT / 3;
					break;
				case 2:
					param1[0].x = param1[0].x + (WIDTH / 2 + 20);
					param1[0].y = param1[0].y + HEIGHT / 3;
					param1[1].x = param1[1].x + (WIDTH / 2 - 100);
					param1[1].y = param1[1].y + HEIGHT / 3;
					break;
				case 3:
					param1[0].x = param1[0].x + (WIDTH / 2 - 140);
					param1[0].y = param1[0].y + HEIGHT / 3;
					param1[1].x = param1[1].x + (WIDTH / 2 - 40);
					param1[1].y = param1[1].y + HEIGHT / 3;
					param1[2].x = param1[2].x + (WIDTH / 2 + 60);
					param1[2].y = param1[2].y + HEIGHT / 3;
			}
			for each(loc2 in param1) {
				addChild(loc2);
			}
		}
		
		private function onComplete(param1:Boolean, param2:*) : void {
			var loc3:XML = null;
			var loc4:XML = null;
			var loc5:Player = null;
			var loc6:PlayerModel = null;
			var loc7:OpenDialogSignal = null;
			var loc8:String = null;
			var loc9:Dialog = null;
			var loc10:Injector = null;
			var loc11:GetMysteryBoxesTask = null;
			var loc12:Array = null;
			var loc13:int = 0;
			var loc14:Array = null;
			var loc15:int = 0;
			var loc16:Array = null;
			this.requestComplete = true;
			if(param1) {
				loc3 = new XML(param2);
				for each(loc4 in loc3.elements("Awards")) {
					this.rewardsList.push(loc4.toString());
				}
				this.lastReward = this.rewardsList[0];
				if(this.timerComplete) {
					this.showReward();
				}
				if(loc3.hasOwnProperty("Left") && this.mbi.unitsLeft != -1) {
					this.mbi.unitsLeft = int(loc3.Left);
				}
				loc5 = StaticInjectorContext.getInjector().getInstance(GameModel).player;
				if(loc5 != null) {
					if(loc3.hasOwnProperty("Gold")) {
						loc5.setCredits(int(loc3.Gold));
					} else if(loc3.hasOwnProperty("Fame")) {
						loc5.fame_ = loc3.Fame;
					}
				} else {
					loc6 = StaticInjectorContext.getInjector().getInstance(PlayerModel);
					if(loc6 != null) {
						if(loc3.hasOwnProperty("Gold")) {
							loc6.setCredits(int(loc3.Gold));
						} else if(loc3.hasOwnProperty("Fame")) {
							loc6.setFame(int(loc3.Fame));
						}
					}
				}
			} else {
				this.totalRollTimer.removeEventListener(TimerEvent.TIMER,this.onTotalRollTimeComplete);
				this.totalRollTimer.stop();
				loc7 = StaticInjectorContext.getInjector().getInstance(OpenDialogSignal);
				loc8 = "MysteryBoxRollModal.pleaseTryAgainString";
				if(LineBuilder.getLocalizedStringFromKey(param2) != "") {
					loc8 = param2;
				}
				if(param2.indexOf("MysteryBoxError.soldOut") >= 0) {
					loc12 = param2.split("|");
					if(loc12.length == 2) {
						loc13 = loc12[1];
						if(loc13 == 0) {
							loc8 = "MysteryBoxError.soldOutAll";
						} else {
							loc8 = LineBuilder.getLocalizedStringFromKey("MysteryBoxError.soldOutLeft",{
								"left":this.mbi.unitsLeft,
								"box":(this.mbi.unitsLeft == 1?LineBuilder.getLocalizedStringFromKey("MysteryBoxError.box"):LineBuilder.getLocalizedStringFromKey("MysteryBoxError.boxes"))
							});
						}
					}
				}
				if(param2.indexOf("MysteryBoxError.maxPurchase") >= 0) {
					loc14 = param2.split("|");
					if(loc14.length == 2) {
						loc15 = loc14[1];
						if(loc15 == 0) {
							loc8 = "MysteryBoxError.maxPurchase";
						} else {
							loc8 = LineBuilder.getLocalizedStringFromKey("MysteryBoxError.maxPurchaseLeft",{"left":loc15});
						}
					}
				}
				if(param2.indexOf("blockedForUser") >= 0) {
					loc16 = param2.split("|");
					if(loc16.length == 2) {
						loc8 = LineBuilder.getLocalizedStringFromKey("MysteryBoxError.blockedForUser",{"date":loc16[1]});
					}
				}
				loc9 = new Dialog("MysteryBoxRollModal.purchaseFailedString",loc8,"MysteryBoxRollModal.okString",null,null);
				loc9.addEventListener(Dialog.LEFT_BUTTON,this.onErrorOk);
				loc7.dispatch(loc9);
				loc10 = StaticInjectorContext.getInjector();
				loc11 = loc10.getInstance(GetMysteryBoxesTask);
				loc11.start();
				this.close(true);
			}
		}
		
		private function onErrorOk(param1:Event) : void {
			var loc2:OpenDialogSignal = null;
			loc2 = StaticInjectorContext.getInjector().getInstance(OpenDialogSignal);
			loc2.dispatch(new MysteryBoxSelectModal());
		}
		
		public function moneyCheckPass() : Boolean {
			var loc1:int = 0;
			var loc2:int = 0;
			var loc7:OpenDialogSignal = null;
			var loc8:PlayerModel = null;
			if(this.mbi.isOnSale() && this.mbi.saleAmount > 0) {
				loc1 = int(this.mbi.saleCurrency);
				loc2 = int(this.mbi.saleAmount) * this.quantity_;
			} else {
				loc1 = int(this.mbi.priceCurrency);
				loc2 = int(this.mbi.priceAmount) * this.quantity_;
			}
			var loc3:Boolean = true;
			var loc4:int = 0;
			var loc5:int = 0;
			var loc6:Player = StaticInjectorContext.getInjector().getInstance(GameModel).player;
			if(loc6 != null) {
				loc5 = loc6.credits_;
				loc4 = loc6.fame_;
			} else {
				loc8 = StaticInjectorContext.getInjector().getInstance(PlayerModel);
				if(loc8 != null) {
					loc5 = loc8.getCredits();
					loc4 = loc8.getFame();
				}
			}
			if(loc1 == Currency.GOLD && loc5 < loc2) {
				loc7 = StaticInjectorContext.getInjector().getInstance(OpenDialogSignal);
				loc7.dispatch(new NotEnoughGoldDialog());
				loc3 = false;
			} else if(loc1 == Currency.FAME && loc4 < loc2) {
				loc7 = StaticInjectorContext.getInjector().getInstance(OpenDialogSignal);
				loc7.dispatch(new NotEnoughFameDialog());
				loc3 = false;
			}
			return loc3;
		}
		
		public function onCloseClick(param1:MouseEvent) : void {
			this.close();
		}
		
		private function close(param1:Boolean = false) : void {
			var loc2:OpenDialogSignal = null;
			if(this.state == this.ROLL_STATE) {
				return;
			}
			if(!param1) {
				loc2 = StaticInjectorContext.getInjector().getInstance(OpenDialogSignal);
				if(this.parentSelectModal != null) {
					this.parentSelectModal.updateContent();
					loc2.dispatch(this.parentSelectModal);
				} else if(ShopConfiguration.USE_NEW_SHOP) {
					loc2.dispatch(new ShopPopupView());
				} else {
					loc2.dispatch(new MysteryBoxSelectModal());
				}
			}
			open = false;
		}
		
		private function onRemovedFromStage(param1:Event) : void {
			open = false;
		}
		
		private function showReward() : void {
			var loc4:String = null;
			var loc5:uint = 0;
			var loc6:TextFieldDisplayConcrete = null;
			this.swapImageTimer.removeEventListener(TimerEvent.TIMER,this.swapItemImage);
			this.swapImageTimer.stop();
			this.state = this.IDLE_STATE;
			if(this.rollCount < this.rollTarget) {
				this.nextRollTimer.addEventListener(TimerEvent.TIMER,this.onNextRollTimerComplete);
				this.nextRollTimer.start();
			}
			this.closeButton.visible = true;
			var loc1:String = this.rewardsList.shift();
			var loc2:Array = loc1.split(",");
			removeChild(this.infoText);
			this.titleText.setStringBuilder(new LineBuilder().setParams(this.youWonString));
			this.titleText.setColor(16768512);
			var loc3:int = 40;
			for each(loc4 in loc2) {
				loc6 = this.getText(ObjectLibrary.typeToDisplayId_[loc4],TEXT_MARGIN,loc3).setSize(16).setColor(0);
				loc6.filters = [];
				loc6.setSize(18);
				loc6.x = 20;
				addChild(loc6);
				this.descTexts.push(loc6);
				loc3 = loc3 + 25;
			}
			loc5 = 0;
			while(loc5 < loc2.length) {
				if(loc5 < this.itemBitmaps.length) {
					this.itemBitmaps[loc5].bitmapData = new Bitmap(ObjectLibrary.getRedrawnTextureFromType(int(loc2[loc5]),this.iconSize,true)).bitmapData;
				}
				loc5++;
			}
			loc5 = 0;
			while(loc5 < this.itemBitmaps.length) {
				this.doEaseInAnimation(this.itemBitmaps[loc5],{
					"scaleX":1.25,
					"scaleY":1.25
				},{
					"scaleX":1,
					"scaleY":1
				});
				loc5++;
			}
			this.boxButton.alpha = 0;
			addChild(this.boxButton);
			if(this.rollCount == this.rollTarget) {
				this.doEaseInAnimation(this.boxButton,{"alpha":0},{"alpha":1});
				this.doEaseInAnimation(this.minusNavSprite,{"alpha":0},{"alpha":1});
				this.doEaseInAnimation(this.plusNavSprite,{"alpha":0},{"alpha":1});
			}
			this.doEaseInAnimation(this.spinners,{"alpha":0},{"alpha":1});
			this.isShowReward = true;
		}
		
		private function doEaseInAnimation(param1:DisplayObject, param2:Object = null, param3:Object = null) : void {
			var loc4:GTween = new GTween(param1,0.5,param2,{"ease":Sine.easeOut});
			loc4.nextTween = new GTween(param1,0.5,param3,{"ease":Sine.easeIn});
			loc4.nextTween.paused = true;
		}
		
		private function shelveReward() : void {
			var loc2:ItemWithTooltip = null;
			var loc3:int = 0;
			var loc4:int = 0;
			var loc5:int = 0;
			var loc6:int = 0;
			var loc7:int = 0;
			var loc8:int = 0;
			var loc1:Array = this.lastReward.split(",");
			if(loc1.length > 0) {
				loc2 = new ItemWithTooltip(int(loc1[0]),64);
				loc3 = HEIGHT / 6 - 10;
				loc4 = WIDTH - 65;
				loc2.x = 5 + loc4 * int(this.rollCount / 5);
				loc2.y = 80 + loc3 * (this.rollCount % 5);
				loc5 = WIDTH / 2 - 40 + this.itemBitmaps[0].width * 0.5;
				loc6 = HEIGHT / 3 + this.itemBitmaps[0].height * 0.5;
				loc7 = loc2.x + loc2.height * 0.5;
				loc8 = 100 + loc3 * (this.rollCount % 5) + 0.5 * (HEIGHT / 6 - 20);
				this.particleModalMap.doLightning(loc5,loc6,loc7,loc8,115,15787660,0.2);
				addChild(loc2);
				this.rewardsArray.push(loc2);
			}
		}
		
		private function clearReward() : void {
			var loc1:TextFieldDisplayConcrete = null;
			var loc2:Bitmap = null;
			this.spinners.alpha = 0;
			this.minusNavSprite.alpha = 0;
			this.plusNavSprite.alpha = 0;
			removeChild(this.titleText);
			for each(loc1 in this.descTexts) {
				removeChild(loc1);
			}
			while(this.descTexts.length > 0) {
				this.descTexts.pop();
			}
			removeChild(this.boxButton);
			for each(loc2 in this.itemBitmaps) {
				removeChild(loc2);
			}
			while(this.itemBitmaps.length > 0) {
				this.itemBitmaps.pop();
			}
		}
		
		private function clearShelveReward() : void {
			var loc1:ItemWithTooltip = null;
			for each(loc1 in this.rewardsArray) {
				removeChild(loc1);
			}
			while(this.rewardsArray.length > 0) {
				this.rewardsArray.pop();
			}
		}
		
		private function centerModal() : void {
			x = WebMain.STAGE.stageWidth / 2 - WIDTH / 2;
			y = WebMain.STAGE.stageHeight / 2 - HEIGHT / 2;
		}
		
		private function onNavClick(param1:MouseEvent) : void {
			if(param1.currentTarget == this.minusNavSprite) {
				switch(this.quantity_) {
					case 5:
						this.configureRollByQuantity(1);
						break;
					case 10:
						this.configureRollByQuantity(5);
				}
			} else if(param1.currentTarget == this.plusNavSprite) {
				switch(this.quantity_) {
					case 1:
						this.configureRollByQuantity(5);
						break;
					case 5:
						this.configureRollByQuantity(10);
				}
			}
		}
		
		private function onRollClick(param1:MouseEvent) : void {
			this.configureRollByQuantity(this.quantity_);
			this.clearReward();
			this.clearShelveReward();
			this.sendRollRequest();
		}
	}
}
