package kabam.rotmg.fortune.components {
	import com.company.assembleegameclient.game.GameSprite;
	import com.company.assembleegameclient.map.ParticleModalMap;
	import com.company.assembleegameclient.objects.GameObject;
	import com.company.assembleegameclient.objects.Player;
	import com.company.assembleegameclient.objects.particles.LightningEffect;
	import com.company.assembleegameclient.objects.particles.NovaEffect;
	import com.company.assembleegameclient.ui.dialogs.DebugDialog;
	import com.company.assembleegameclient.ui.dialogs.Dialog;
	import com.company.assembleegameclient.util.Currency;
	import com.company.assembleegameclient.util.TextureRedrawer;
	import com.company.util.AssetLibrary;
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.easing.Sine;

	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	import kabam.rotmg.account.core.Account;
	import kabam.rotmg.account.core.view.EmptyFrame;
	import kabam.rotmg.appengine.api.AppEngineClient;
	import kabam.rotmg.core.StaticInjectorContext;
	import kabam.rotmg.dialogs.control.CloseDialogsSignal;
	import kabam.rotmg.dialogs.control.OpenDialogSignal;
	import kabam.rotmg.fortune.model.FortuneInfo;
	import kabam.rotmg.fortune.services.FortuneModel;
	import kabam.rotmg.game.model.GameModel;
	import kabam.rotmg.game.view.CreditDisplay;
	import kabam.rotmg.messaging.impl.data.WorldPosData;
	import kabam.rotmg.pets.view.components.DialogCloseButton;
	import kabam.rotmg.ui.view.NotEnoughGoldDialog;
	import kabam.rotmg.ui.view.components.MapBackground;
	import kabam.rotmg.util.components.CountdownTimer;
	import kabam.rotmg.util.components.InfoHoverPaneFactory;
	import kabam.rotmg.util.components.SimpleButton;

	import org.osflash.signals.Signal;
	import org.swiftsuspenders.Injector;

	public class FortuneModal extends EmptyFrame {

		public static var backgroundImageEmbed:Class = FortuneModal_backgroundImageEmbed;

		public static var fortunePlatformEmbed:Class = FortuneModal_fortunePlatformEmbed;

		public static var fortunePlatformEmbed2:Class = FortuneModal_fortunePlatformEmbed2;

		public static const MODAL_WIDTH:int = 800;

		public static const MODAL_HEIGHT:int = 600;

		public static var modalWidth:int = MODAL_WIDTH;

		public static var modalHeight:int = MODAL_HEIGHT;

		private static var texts_:Vector.<TextField>;

		public static const STATE_ROUND_1:int = 1;

		public static const STATE_ROUND_2:int = 2;

		public static const INIT_RADIUS_FROM_MAINCRYTAL:Number = 200;

		public static var fMouseX:int;

		public static var fMouseY:int;

		public static var crystalMainY:int = MODAL_HEIGHT / 2 - 20;

		private static const ITEM_SIZE_IN_MC:int = 120;

		public static var modalIsOpen:Boolean = false;

		public static const closed:Signal = new Signal();


		public var crystalMain:CrystalMain;

		public var crystals:Vector.<CrystalSmall>;

		public var crystalClicked:CrystalSmall = null;

		private var buyButtonGold:SimpleButton;

		private var buyButtonFortune:SimpleButton;

		private var resetButton:SimpleButton;

		private var largeCloseButton:DialogCloseButton;

		private var currentString:int = -1;

		private var countdownTimer:CountdownTimer;

		public var client:AppEngineClient;

		public var account:Account;

		public var model:FortuneModel;

		public var fortuneInfo:FortuneInfo;

		public var state:int = 1;

		private var particleMap:ParticleModalMap;

		private const SWITCH_DELAY_NORMAL:Number = 1200;

		private const SWITCH_DELAY_FAST:Number = 100;

		private var itemSwitchTimer:Timer;

		private var tooltipItemIDIndex:int = -1;

		private var currenttooltipItem:int = 0;

		public var tooltipItems:Vector.<ItemWithTooltip>;

		private var lastUpdate_:int;

		public var mapBackground:MapBackground;

		private var pscale:Number;

		private var gameStage_:int = 0;

		private var boughtWithGold:Boolean = false;

		private const GAME_STAGE_IDLE:int = 0;

		private const GAME_STAGE_SPIN:int = 1;

		private var radius:int = 200;

		private var dtBuildup:Number = 0;

		private var direction:int = 4;

		private var spinSpeed:int = 0;

		private const MAX_SPIN_SPEED:int = 120;

		private var platformMain:Sprite;

		private var platformMainSub:Sprite;

		private const MASTERS_LORE_STRING_TIME:Number = 1.3;

		private const SHOW_PRIZES_TIME:Number = 6;

		private const SPIN_TIME:Number = 2.75;

		private const DISPLAY_PRIZE_TIME_1:Number = 3.75;

		private const DISPLAY_PRIZE_TIME_2:Number = 5;

		private const NOVA_DELAY_TIME:Number = 0.12;

		private const COUNTDOWN_AMOUNT:Number = 10;

		public var creditDisplay_:CreditDisplay;

		private var onHoverPanel:Sprite;

		private var goldPrice_:int = -1;

		private var goldPriceSecond_:int = -1;

		private var tokenPrice_:int = -1;

		private var gs_:GameSprite = null;

		private var chooseingState:Boolean = false;

		private var items:Array;

		public function FortuneModal(param1:GameSprite = null) {
			this.crystalMain = new CrystalMain();
			this.crystals = Vector.<CrystalSmall>([new CrystalSmall(), new CrystalSmall(), new CrystalSmall()]);
			this.buyButtonGold = new SimpleButton("Play for ", 0, Currency.INVALID);
			this.buyButtonFortune = new SimpleButton("Play for ", 0, Currency.INVALID);
			this.resetButton = new SimpleButton("Return", 0, Currency.INVALID);
			this.itemSwitchTimer = new Timer(this.SWITCH_DELAY_NORMAL);
			modalWidth = MODAL_WIDTH;
			modalHeight = MODAL_HEIGHT;
			super(modalWidth, modalHeight);
			modalIsOpen = true;
			this.makePlatforms();
			this.pscale = ParticleModalMap.PSCALE;
			this.particleMap = new ParticleModalMap();
			addChild(this.particleMap);
			this.largeCloseButton = new DialogCloseButton(1);
			addChild(this.largeCloseButton);
			this.largeCloseButton.y = 4;
			this.largeCloseButton.x = modalWidth - this.largeCloseButton.width - 5;
			var loc2:Injector = StaticInjectorContext.getInjector();
			this.client = loc2.getInstance(AppEngineClient);
			this.account = loc2.getInstance(Account);
			this.model = loc2.getInstance(FortuneModel);
			this.fortuneInfo = this.model.getFortune();
			if (this.fortuneInfo == null) {
				return;
			}
			this.crystalMain.setXPos(modalWidth / 2);
			this.crystalMain.setYPos(crystalMainY);
			this.resetBalls();
			addChild(this.crystalMain);
			this.lastUpdate_ = getTimer();
			this.countdownTimer = new CountdownTimer();
			this.countdownTimer.timerComplete.add(this.onCountdownComplete);
			addChild(this.countdownTimer);
			addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
			addEventListener(Event.REMOVED_FROM_STAGE, this.destruct);
			this.creditDisplay_ = new CreditDisplay(null, false, true);
			this.creditDisplay_.x = 734;
			this.creditDisplay_.y = 0;
			addChild(this.creditDisplay_);
			var loc3:Player = StaticInjectorContext.getInjector().getInstance(GameModel).player;
			if (loc3 != null) {
				this.creditDisplay_.draw(loc3.credits_, 0, loc3.tokens_);
			}
			if (param1 != null) {
				this.gs_ = param1;
				this.gs_.creditDisplay_.visible = false;
			}
			var loc4:BitmapData = AssetLibrary.getImageFromSet("lofiObj3", 1172);
			loc4 = TextureRedrawer.redraw(loc4, 75, true, 0);
			this.crystalMain.addEventListener(MouseEvent.ROLL_OVER, this.displayInfoHover);
			this.crystalMain.addEventListener(MouseEvent.ROLL_OUT, this.removeInfoHover);
			this.onHoverPanel = InfoHoverPaneFactory.make(this.fortuneInfo.infoImage);
			this.onHoverPanel.x = modalWidth - (this.onHoverPanel.width + 10);
			this.onHoverPanel.y = 10;
			this.addItemSwitch();
			this.InitTexts();
			this.setString(0);
			this.InitButtons();
			addChild(this.onHoverPanel);
			this.onHoverPanel.addEventListener(MouseEvent.ROLL_OVER, this.removeInfoHover);
			this.onHoverPanel.visible = false;
		}

		public static function doEaseOutInAnimation(param1:DisplayObject, param2:Object = null, param3:Object = null, param4:Function = null):void {
			var loc5:GTween = new GTween(param1, 0.5 * 1, param2, {"ease": Sine.easeOut});
			loc5.nextTween = new GTween(param1, 0.5 * 1, param3, {"ease": Sine.easeIn});
			loc5.nextTween.paused = true;
			loc5.nextTween.end();
			loc5.nextTween.onComplete = param4;
		}

		private function displayInfoHover(param1:MouseEvent):void {
			this.onHoverPanel.visible = true;
		}

		private function removeInfoHover(param1:MouseEvent):void {
			if (!(param1.relatedObject is ItemWithTooltip)) {
				this.onHoverPanel.visible = false;
			}
		}

		private function InitButtons():void {
			this.goldPrice_ = int(this.fortuneInfo.priceFirstInGold);
			this.tokenPrice_ = int(this.fortuneInfo.priceFirstInToken);
			this.goldPriceSecond_ = int(this.fortuneInfo.priceSecondInGold);
			this.buyButtonGold.setPrice(this.goldPrice_, Currency.GOLD);
			this.buyButtonGold.setEnabled(true);
			this.buyButtonGold.x = modalWidth / 2 - 100 - this.buyButtonGold.width;
			this.buyButtonGold.y = modalHeight * 70 / 75 - this.buyButtonGold.height / 2;
			addChild(this.buyButtonGold);
			this.buyButtonGold.addEventListener(MouseEvent.CLICK, this.onBuyWithGoldClick);
			this.buyButtonFortune.setPrice(this.tokenPrice_, Currency.FORTUNE);
			this.buyButtonFortune.setEnabled(true);
			this.resetButton.visible = false;
			addChild(this.resetButton);
			this.resetButton.setText("Return");
			addChild(this.buyButtonFortune);
			this.buyButtonFortune.x = modalWidth / 2 + 100;
			this.buyButtonFortune.y = modalHeight * 70 / 75 - this.buyButtonFortune.height / 2;
			this.resetButton.x = modalWidth / 2 + 100;
			this.resetButton.y = modalHeight * 70 / 75 - this.buyButtonFortune.height / 2;
			this.buyButtonFortune.addEventListener(MouseEvent.CLICK, this.onBuyWithFortuneClick);
		}

		private function InitTexts():void {
			var loc4:TextField = null;
			texts_ = new Vector.<TextField>();
			var loc1:Vector.<String> = Vector.<String>(["HOW WILL YOU PLAY?", "THE FIVE MASTERS OF GOZOR WILL DETERMINE YOUR PRIZE!", "HERE\'S WHAT YOU CAN WIN!", "Shuffling!", "PICK ONE TO WIN A PRIZE!", "YOU WON! ITEMS WILL BE PLACED IN YOUR GIFT CHEST", "TWO ITEMS LEFT! TAKE ANOTHER SHOT!", "PICK A SECOND PRIZE!", "PLAY AGAIN?", "Choose now or I will choose for you!", "Determining Prizes!", "Sorting Loot!", "What can you win?", "Big Prizes! Big Orbs! I love it!", "Wooah! Awesome lewt!", "Processing hadoop data..."]);
			var loc2:TextFormat = new TextFormat();
			loc2.size = 24;
			loc2.font = "Myriad Pro";
			loc2.bold = false;
			loc2.align = TextFormatAlign.LEFT;
			loc2.leftMargin = 0;
			loc2.indent = 0;
			loc2.leading = 0;
			var loc3:uint = 0;
			while (loc3 < loc1.length) {
				loc4 = new TextField();
				loc4.text = loc1[loc3];
				loc4.textColor = 16776960;
				loc4.autoSize = TextFieldAutoSize.CENTER;
				loc4.selectable = false;
				loc4.defaultTextFormat = loc2;
				loc4.setTextFormat(loc2);
				loc4.filters = [new GlowFilter(16777215, 1, 2, 2, 1.5, 1)];
				texts_.push(loc4);
				loc3++;
			}
		}

		private function setString(param1:int):void {
			if (this.parent == null) {
				return;
			}
			if (this.currentString >= 0 && texts_[this.currentString].parent != null) {
				removeChild(texts_[this.currentString]);
			}
			if (param1 < 0) {
				return;
			}
			this.currentString = param1;
			var loc2:TextField = texts_[this.currentString];
			loc2.x = modalWidth / 2 - loc2.width / 2;
			loc2.y = modalHeight * 66 / 75 - loc2.height / 2;
			addChild(texts_[this.currentString]);
		}

		private function destruct(param1:Event):void {
			this.largeCloseButton.clicked.removeAll();
			modalIsOpen = false;
			closed.dispatch();
			closed.removeAll();
			this.itemSwitchTimer.removeEventListener(TimerEvent.TIMER, this.onItemSwitch);
			removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
			removeEventListener(Event.REMOVED_FROM_STAGE, this.destruct);
			this.countdownTimer.timerComplete.removeAll();
			this.countdownTimer.end();
			this.countdownTimer = null;
			this.buyButtonsDisable();
			this.ballClickDisable();
			this.crystalMain.removeEventListener(MouseEvent.ROLL_OVER, this.displayInfoHover);
			this.crystalMain.removeEventListener(MouseEvent.ROLL_OUT, this.removeInfoHover);
			this.onHoverPanel.removeEventListener(MouseEvent.ROLL_OVER, this.removeInfoHover);
			this.resetButton.removeEventListener(MouseEvent.CLICK, this.onResetClick);
			if (this.gs_ != null) {
				this.gs_.creditDisplay_.visible = false;
			}
		}

		private function onItemSwitch(param1:TimerEvent = null):void {
			var loc5:ItemWithTooltip = null;
			this.tooltipItemIDIndex++;
			if (this.tooltipItems == null) {
				this.tooltipItems = Vector.<ItemWithTooltip>([new ItemWithTooltip(this.fortuneInfo._rollsWithContentsUnique[this.tooltipItemIDIndex], ITEM_SIZE_IN_MC), new ItemWithTooltip(this.fortuneInfo._rollsWithContentsUnique[this.tooltipItemIDIndex + 1], ITEM_SIZE_IN_MC)]);
			}
			if (this.tooltipItemIDIndex >= this.fortuneInfo._rollsWithContentsUnique.length) {
				this.tooltipItemIDIndex = 0;
			}
			var loc2:int = this.tooltipItemIDIndex % 2;
			if (this.tooltipItems[this.currenttooltipItem] != null && this.tooltipItems[this.currenttooltipItem].parent != null) {
				loc5 = this.tooltipItems[this.currenttooltipItem];
				this.doEaseInAnimation(loc5, {"alpha": 0}, this.removeChildAfterTween);
			}
			var loc3:ItemWithTooltip = new ItemWithTooltip(this.fortuneInfo._rollsWithContentsUnique[this.tooltipItemIDIndex], ITEM_SIZE_IN_MC, true);
			loc3.onMouseOver.add(this.onItemSwitchPause);
			loc3.onMouseOut.add(this.onItemSwitchContinue);
			loc3.setXPos(this.crystalMain.getCenterX());
			loc3.setYPos(this.crystalMain.getCenterY());
			this.tooltipItems[loc2] = loc3;
			loc3.alpha = 0;
			addChild(loc3);
			this.doEaseInAnimation(loc3, {"alpha": 1});
			this.currenttooltipItem = loc2;
			var loc4:Player = StaticInjectorContext.getInjector().getInstance(GameModel).player;
			if (this.creditDisplay_ != null && loc4 != null) {
				this.creditDisplay_.draw(loc4.credits_, 0, loc4.tokens_);
			}
		}

		private function removeChildAfterTween(param1:GTween):void {
			if (param1.target.parent != null) {
				param1.target.parent.removeChild(param1.target);
			}
		}

		public function onItemSwitchPause():void {
			this.itemSwitchTimer.stop();
		}

		public function onItemSwitchContinue():void {
			this.itemSwitchTimer.start();
			this.onItemSwitch();
		}

		public function addItemSwitch():void {
			this.itemSwitchTimer.delay = this.SWITCH_DELAY_NORMAL;
			this.itemSwitchTimer.addEventListener(TimerEvent.TIMER, this.onItemSwitch);
			this.onItemSwitchContinue();
		}

		private function removeItemSwitch():void {
			this.itemSwitchTimer.removeEventListener(TimerEvent.TIMER, this.onItemSwitch);
			var loc1:int = 0;
			while (loc1 < 2) {
				if (this.tooltipItems[loc1] != null && this.tooltipItems[loc1].parent != null) {
					this.tooltipItems[loc1].alpha = 0;
					this.tooltipItems[loc1].onMouseOut.removeAll();
					this.tooltipItems[loc1].onMouseOver.removeAll();
					this.tooltipItems[loc1].parent.removeChild(this.tooltipItems[loc1]);
				}
				loc1++;
			}
			this.onItemSwitchPause();
		}

		private function canUseFortuneModal():Boolean {
			return FortuneModel.HAS_FORTUNES;
		}

		private function doEaseInAnimation(param1:DisplayObject, param2:Object = null, param3:Function = null):void {
			var loc4:GTween = new GTween(param1, 0.5, param2, {
				"ease": Sine.easeOut,
				"onComplete": param3
			});
		}

		private function onCountdownComplete():void {
			var loc2:int = 0;
			var loc1:CrystalSmall = null;
			do {
				loc2 = int(Math.random() * 3);
				if (this.state == STATE_ROUND_1 || this.crystals[loc2] != this.crystalClicked) {
					loc1 = this.crystals[loc2];
				}
			}
			while (loc1 == null);

			this.smallBallClick(loc1);
		}

		protected function makePlatforms():void {
			var loc1:ImageSprite = null;
			this.platformMain = new Sprite();
			loc1 = new ImageSprite(new fortunePlatformEmbed2(), 500, 500);
			loc1.x = -loc1.width / 2;
			loc1.y = -loc1.height / 2;
			this.platformMain.addChild(loc1);
			this.platformMain.x = modalWidth / 2;
			this.platformMain.y = crystalMainY;
			this.platformMain.alpha = 0.25;
			addChild(this.platformMain);
			this.platformMainSub = new Sprite();
			loc1 = new ImageSprite(new fortunePlatformEmbed(), 700, 700);
			loc1.x = -loc1.width / 2;
			loc1.y = -loc1.height / 2;
			this.platformMainSub.addChild(loc1);
			this.platformMainSub.x = modalWidth / 2;
			this.platformMainSub.y = crystalMainY;
			this.platformMainSub.alpha = 0.15;
			addChild(this.platformMainSub);
		}

		override protected function makeModalBackground():Sprite {
			var loc1:Sprite = new Sprite();
			var loc2:DisplayObject = new backgroundImageEmbed();
			loc2.width = modalWidth;
			loc2.height = modalHeight;
			loc2.alpha = 0.7;
			loc1.addChild(loc2);
			return loc1;
		}

		private function onResetClick(param1:MouseEvent):void {
			this.resetButton.removeEventListener(MouseEvent.CLICK, this.onResetClick);
			this.resetGame();
		}

		private function onBuyWithGoldClick(param1:MouseEvent):void {
			this.onFirstBuySub(Currency.GOLD);
		}

		private function onBuyWithFortuneClick(param1:MouseEvent):void {
			this.onFirstBuySub(Currency.FORTUNE);
		}

		private function onFirstBuySub(param1:int):void {
			var loc4:OpenDialogSignal = null;
			if (!this.canUseFortuneModal()) {
				this.fortuneEventOver();
			}
			var loc2:Player = StaticInjectorContext.getInjector().getInstance(GameModel).player;
			if (loc2 != null) {
				if (param1 == Currency.GOLD && this.state == STATE_ROUND_2 && loc2.credits_ - this.goldPriceSecond_ < 0) {
					loc4 = StaticInjectorContext.getInjector().getInstance(OpenDialogSignal);
					loc4.dispatch(new NotEnoughGoldDialog());
					return;
				}
				if (param1 == Currency.GOLD && loc2.credits_ - this.goldPrice_ < 0) {
					loc4 = StaticInjectorContext.getInjector().getInstance(OpenDialogSignal);
					loc4.dispatch(new NotEnoughGoldDialog());
					return;
				}
				if (param1 == Currency.FORTUNE && loc2.tokens_ - this.tokenPrice_ < 0) {
					return;
				}
			}
			this.itemSwitchTimer.delay = this.SWITCH_DELAY_FAST;
			this.crystalMain.setAnimationStage(CrystalMain.ANIMATION_STAGE_WAITING);
			var loc3:Object = this.makeBasicParams();
			if (param1 == Currency.FORTUNE) {
				loc3.currency = 2;
			} else if (param1 == Currency.GOLD) {
				loc3.currency = 0;
			} else {
				return;
			}
			if (this.state == STATE_ROUND_1) {
				loc3.status = 0;
				this.crystalMain.removeEventListener(MouseEvent.ROLL_OVER, this.displayInfoHover);
			}
			if (this.state == STATE_ROUND_1 && !this.client.requestInProgress()) {
				this.buyButtonsDisable();
				this.boughtWithGold = param1 == Currency.GOLD;
				if (loc2 != null) {
					if (this.boughtWithGold) {
						loc2.credits_ = loc2.credits_ - this.goldPrice_;
						this.creditDisplay_.draw(loc2.credits_, 0, loc2.tokens_);
					} else {
						if (loc2.tokens_ - this.tokenPrice_ < 0) {
							return;
						}
						loc2.tokens_ = loc2.tokens_ - this.tokenPrice_;
						this.creditDisplay_.draw(loc2.credits_, 0, loc2.tokens_);
					}
				}
				this.client.sendRequest("/account/playFortuneGame", loc3);
				this.setString(10 + int(Math.random() * 6));
				this.client.complete.addOnce(this.onFirstBuyComplete);
				this.buyButtonGold.visible = false;
				this.buyButtonFortune.visible = false;
			} else if (this.state == STATE_ROUND_2) {
				this.buyButtonsDisable();
				this.onFirstBuyAnimateSub();
				loc2 = StaticInjectorContext.getInjector().getInstance(GameModel).player;
				if (loc2 != null) {
					loc2.credits_ = loc2.credits_ - this.goldPriceSecond_;
					this.creditDisplay_.draw(loc2.credits_, 0, loc2.tokens_);
				}
				this.buyButtonGold.visible = false;
				this.resetButton.visible = false;
			}
		}

		private function onFirstBuyComplete(param1:Boolean, param2:*):void {
			var loc3:XML = null;
			var loc4:Player = null;
			var loc5:Vector.<int> = null;
			var loc6:int = 0;
			var loc7:* = false;
			var loc8:Number = NaN;
			var loc9:Number = NaN;
			var loc10:Number = NaN;
			var loc11:Number = NaN;
			var loc12:int = 0;
			var loc13:Number = NaN;
			var loc14:Number = NaN;
			var loc15:Number = NaN;
			var loc16:Number = NaN;
			var loc17:String = null;
			if (param1) {
				loc3 = new XML(param2);
				this.items = loc3.Candidates.split(",");
				loc4 = StaticInjectorContext.getInjector().getInstance(GameModel).player;
				if (loc4 != null) {
					if (loc3.hasOwnProperty("Gold")) {
						loc4.credits_ = int(loc3.Gold);
						this.creditDisplay_.draw(loc4.credits_, 0, loc4.tokens_);
					} else if (loc3.hasOwnProperty("FortuneToken")) {
						loc4.tokens_ = int(loc3.FortuneToken);
						this.creditDisplay_.draw(loc4.credits_, 0, loc4.tokens_);
					}
				}
				loc5 = Vector.<int>([0, 2, 1]);
				loc6 = Math.floor(Math.random() * 3);
				loc7 = Math.random() > 0.5;
				loc8 = this.crystalMain.getCenterX();
				loc9 = this.crystalMain.getCenterY();
				loc10 = this.crystals[loc5[loc6]].getCenterX();
				loc11 = this.crystals[loc5[loc6]].getCenterY();
				loc12 = 0;
				loc13 = loc8;
				loc14 = loc9;
				loc15 = 0.25;
				loc16 = 1.2;
				this.removeItemSwitch();
				for each(loc17 in this.items) {
					if (loc12 == 0) {
						new TimerCallback(loc15, this.doLightning, loc8, loc9, loc10, loc11);
						new TimerCallback(loc15 + 0.1, this.crystals[loc5[loc6]].doItemShow, int(loc17));
					} else {
						loc10 = this.crystals[loc5[loc6]].getCenterX();
						loc11 = this.crystals[loc5[loc6]].getCenterY();
						new TimerCallback(loc15, this.doLightning, loc13, loc14, loc10, loc11);
						new TimerCallback(loc15 + 0.1, this.crystals[loc5[loc6]].doItemShow, int(loc17));
					}
					loc13 = loc10;
					loc14 = loc11;
					loc15 = loc15 + loc16;
					loc12++;
					if (loc7) {
						loc6 = (loc6 + 1) % 3;
					} else {
						loc6 = --loc6 < 0 ? 2 : int(loc6);
					}
				}
				new TimerCallback(this.SHOW_PRIZES_TIME, this.onFirstBuyAnimateSub);
			} else {
				this.handleError();
			}
		}

		private function onFirstBuyAnimateSub():void {
			if (this.state == STATE_ROUND_2 && this.crystalClicked != null) {
				this.resetBallsRound2();
			}
			var loc1:int = 0;
			while (loc1 < 3) {
				this.crystals[loc1].removeItemReveal();
				this.crystals[loc1].saveReturnPotion();
				this.crystals[loc1].setAnimation(6, 7);
				this.crystals[loc1].setAnimationDuration(50);
				loc1++;
			}
			this.setGameStage(this.GAME_STAGE_SPIN);
			this.crystalMain.setAnimationStage(CrystalMain.ANIMATION_STAGE_INNERROTATION);
			new TimerCallback(this.SPIN_TIME, this.onFirstBuyAnimateComplete);
			this.setString(3);
		}

		private function onFirstBuyAnimateComplete():void {
			this.setGameStage(this.GAME_STAGE_IDLE);
			if (this.state == STATE_ROUND_2) {
				this.setString(7);
			} else {
				this.setString(4);
			}
			this.ballClickEnable(this.crystalClicked);
			this.crystalMain.setAnimationStage(CrystalMain.ANIMATION_STAGE_BUZZING);
			this.doNova(this.crystalMain.getCenterX(), this.crystalMain.getCenterY(), 10, 65535);
			var loc1:int = 0;
			while (loc1 < 3) {
				if (!(this.state == STATE_ROUND_2 && this.crystals[loc1] == this.crystalClicked)) {
					this.crystals[loc1].setActive2();
					this.crystals[loc1].doItemReturn();
					new TimerCallback(this.NOVA_DELAY_TIME, this.doNova, int(this.crystals[loc1].returnCenterX()), int(this.crystals[loc1].returnCenterY()), 5, 65535);
					new TimerCallback(this.NOVA_DELAY_TIME, this.crystals[loc1].setAnimationPulse);
				}
				loc1++;
			}
			if (this.countdownTimer == null) {
				return;
			}
			new TimerCallback(this.NOVA_DELAY_TIME, this.crystalMain.setAnimationStage, CrystalMain.ANIMATION_STAGE_PULSE);
			this.countdownTimer.start(this.COUNTDOWN_AMOUNT);
			this.countdownTimer.setXPos(this.crystalMain.getCenterX());
			this.countdownTimer.setYPos(this.crystalMain.getCenterY());
			new TimerCallback(7, this.setCountdownWarningString);
			this.chooseingState = true;
		}

		private function setCountdownWarningString():void {
			if (this.countdownTimer != null && this.countdownTimer.isRunning()) {
				this.setString(9);
			}
		}

		private function handleError():void {
			var loc1:OpenDialogSignal = null;
			loc1 = StaticInjectorContext.getInjector().getInstance(OpenDialogSignal);
			var loc2:Dialog = new Dialog("MysteryBoxRollModal.purchaseFailedString", "MysteryBoxRollModal.pleaseTryAgainString", "MysteryBoxRollModal.okString", null, null);
			loc2.addEventListener(Dialog.LEFT_BUTTON, this.onErrorOk, false, 0, true);
			loc1.dispatch(loc2);
		}

		private function onErrorOk(param1:Event):void {
			var loc2:CloseDialogsSignal = null;
			loc2 = StaticInjectorContext.getInjector().getInstance(CloseDialogsSignal);
			loc2.dispatch();
		}

		private function fortuneEventOver():void {
			var loc1:OpenDialogSignal = null;
			loc1 = StaticInjectorContext.getInjector().getInstance(OpenDialogSignal);
			loc1.dispatch(new DebugDialog("The Alchemist has left the Nexus.Please check back later.", "Oh no!"));
		}

		private function makeBasicParams():Object {
			var loc1:Object = this.account.getCredentials();
			loc1.gameId = this.fortuneInfo.id;
			return loc1;
		}

		private function onSmallBallClick(param1:MouseEvent):void {
			this.smallBallClick(param1.currentTarget);
		}

		private function smallBallClick(param1:Object):void {
			var loc2:int = 0;
			var loc3:int = 0;
			while (loc3 < 3) {
				if (this.crystals[loc3] == param1) {
					this.smallBallClickSub(loc3, loc2);
					this.crystals[loc3].setAnimationClicked();
				}
				if (this.crystals[loc3] != this.crystalClicked) {
					loc2++;
				}
				this.crystals[loc3].setGlowState(CrystalSmall.GLOW_STATE_FADE);
				loc3++;
			}
			this.chooseingState = false;
		}

		private function smallBallClickSub(param1:int, param2:int):void {
			var loc3:Object = this.makeBasicParams();
			loc3.choice = param2;
			loc3.status = this.state;
			loc3.currency = 0;
			if (!this.client.requestInProgress()) {
				this.countdownTimer.remove();
				this.ballClickDisable();
				this.crystalClicked = this.crystals[param1];
				this.client.sendRequest("/account/playFortuneGame", loc3);
				this.client.complete.addOnce(this.onSmallBallClickComplete);
			}
		}

		private function onSmallBallClickComplete(param1:Boolean, param2:*):void {
			var loc3:XML = null;
			var loc4:OpenDialogSignal = null;
			if (param1) {
				loc3 = new XML(param2);
				if (this.state == STATE_ROUND_2) {
					new TimerCallback(0.25, this.doNova, this.crystalClicked.getCenterX(), this.crystalClicked.getCenterY(), 6, 65535);
					new TimerCallback(0.25, this.crystalClicked.doItemReveal, loc3.Awards);
					new TimerCallback(this.DISPLAY_PRIZE_TIME_2, this.resetGame);
				} else if (this.state == STATE_ROUND_1) {
					this.state = STATE_ROUND_2;
					new TimerCallback(this.DISPLAY_PRIZE_TIME_1, this.onSmallBallClickCompleteRound2, loc3.Awards);
					new TimerCallback(0.25, this.doNova, this.crystalClicked.getCenterX(), this.crystalClicked.getCenterY(), 6, 65535);
					new TimerCallback(0.25, this.crystalClicked.doItemReveal, loc3.Awards);
				}
				new TimerCallback(0.5, this.setString, 5);
			} else {
				this.ballClickEnable(null);
				loc4 = StaticInjectorContext.getInjector().getInstance(OpenDialogSignal);
				if (this.state == STATE_ROUND_1) {
					loc4.dispatch(new DebugDialog("You have run out of time to choose, but an item has been chosen for you.", "Oh no!"));
				} else {
					loc4.dispatch(new DebugDialog("You have run out of time to choose.", "Oh no!"));
				}
			}
		}

		private function onSmallBallClickCompleteRound2(param1:int):void {
			var loc2:int = 0;
			this.resetSpinCrystalsVars();
			this.buyButtonsEnable();
			this.buyButtonGold.setPrice(this.goldPriceSecond_, Currency.GOLD);
			this.buyButtonGold.visible = true;
			this.resetButton.visible = true;
			this.resetButton.addEventListener(MouseEvent.CLICK, this.onResetClick);
			loc2 = 0;
			while (loc2 < this.items.length) {
				if (int(this.items[loc2]) == param1) {
					this.items[loc2] = this.items[this.items.length - 1];
				}
				loc2++;
			}
			this.items.pop();
			loc2 = 0;
			while (loc2 < this.crystals.length) {
				if (this.crystals[loc2] != this.crystalClicked) {
					this.crystals[loc2].doItemShow(int(this.items.pop()));
				}
				loc2++;
			}
			this.setString(6);
		}

		private function resetGame():void {
			this.state = STATE_ROUND_1;
			this.ballClickDisable();
			this.buyButtonsEnable();
			this.buyButtonGold.setPrice(this.goldPrice_, Currency.GOLD);
			this.buyButtonGold.visible = true;
			this.buyButtonFortune.visible = true;
			this.resetButton.visible = false;
			this.addItemSwitch();
			this.setString(0);
			this.resetSpinCrystalsVars();
			this.boughtWithGold = false;
			this.crystalMain.addEventListener(MouseEvent.ROLL_OVER, this.displayInfoHover);
			this.crystalMain.reset();
			var loc1:int = 0;
			while (loc1 < 3) {
				this.crystals[loc1].resetVars();
				loc1++;
			}
			this.resetBalls();
		}

		private function resetSpinCrystalsVars():void {
			this.radius = INIT_RADIUS_FROM_MAINCRYTAL;
			this.dtBuildup = 0;
			this.direction = 8;
			this.spinSpeed = 0;
		}

		private function buyButtonsDisable():void {
			this.buyButtonGold.removeEventListener(MouseEvent.CLICK, this.onBuyWithGoldClick);
			this.buyButtonFortune.removeEventListener(MouseEvent.CLICK, this.onBuyWithFortuneClick);
		}

		private function buyButtonsEnable():void {
			if (this.state == STATE_ROUND_1) {
				this.buyButtonFortune.addEventListener(MouseEvent.CLICK, this.onBuyWithFortuneClick);
			}
			this.buyButtonGold.addEventListener(MouseEvent.CLICK, this.onBuyWithGoldClick);
		}

		private function ballClickDisable():void {
			var loc1:int = 0;
			while (loc1 < 3) {
				this.crystals[loc1].removeEventListener(MouseEvent.CLICK, this.onSmallBallClick);
				loc1++;
			}
		}

		private function ballClickEnable(param1:CrystalSmall = null):void {
			var loc2:int = 0;
			while (loc2 < 3) {
				if (this.crystals[loc2] == param1) {
					this.crystals[loc2].removeEventListener(MouseEvent.CLICK, this.onSmallBallClick);
				} else {
					this.crystals[loc2].addEventListener(MouseEvent.CLICK, this.onSmallBallClick);
					this.crystals[loc2].setMouseTracking(true);
				}
				loc2++;
			}
		}

		private function resetBalls():void {
			var loc3:Number = NaN;
			var loc1:int = INIT_RADIUS_FROM_MAINCRYTAL;
			var loc2:int = 0;
			while (loc2 < 3) {
				loc3 = ((loc2 + 1) * 120 - 60) * Math.PI / 180;
				this.crystals[loc2].setXPos(this.crystalMain.getCenterX() + loc1 * Math.sin(loc3));
				this.crystals[loc2].setYPos(this.crystalMain.getCenterY() + loc1 * Math.cos(loc3));
				if (this.crystals[loc2].parent == null) {
					addChild(this.crystals[loc2]);
				} else if (this.crystals[loc2].visible == false) {
					this.crystals[loc2].visible = true;
				}
				this.crystals[loc2].removeItemReveal();
				this.crystals[loc2].setInactive();
				this.crystals[loc2].reset();
				loc2++;
			}
			this.crystalClicked = null;
		}

		private function resetBallsRound2():void {
			var loc4:Number = NaN;
			var loc1:int = 0;
			var loc2:int = INIT_RADIUS_FROM_MAINCRYTAL;
			if (this.crystalClicked != null && this.crystalClicked.parent) {
				this.crystalClicked.visible = false;
				this.crystalClicked.setInactive();
			}
			var loc3:int = 0;
			while (loc3 < 3) {
				if (this.crystals[loc3] != this.crystalClicked) {
					loc4 = (loc1 * 120 - 60) * Math.PI / 180;
					this.crystals[loc3].setXPos(this.crystalMain.getCenterX() + loc2 * Math.sin(loc4));
					this.crystals[loc3].setYPos(this.crystalMain.getCenterY() + loc2 * Math.cos(loc4));
					loc1++;
				}
				loc3++;
			}
		}

		public function spinCrystals():void {
			var loc3:Number = NaN;
			var loc1:int = 200 * Math.abs(int(getTimer() / 2) % 1000 - 500) / 1000;
			if (this.spinSpeed < this.MAX_SPIN_SPEED) {
				this.spinSpeed = this.spinSpeed + 4;
			}
			var loc2:int = 0;
			while (loc2 < 3) {
				loc3 = ((loc2 + 1) * (120 + this.spinSpeed) - 60 - getTimer()) * Math.PI / 180;
				this.crystals[loc2].setXPos(this.crystalMain.getCenterX() + this.radius * Math.sin(loc3));
				this.crystals[loc2].setYPos(this.crystalMain.getCenterY() + this.radius * Math.cos(loc3));
				loc2++;
			}
			if (this.radius == INIT_RADIUS_FROM_MAINCRYTAL) {
				this.direction = this.direction * -1;
			}
			if (this.radius < 0) {
				this.radius = 0;
			} else if (this.spinSpeed == this.MAX_SPIN_SPEED) {
				this.radius = this.radius - this.direction * 2.85 / this.SPIN_TIME;
			}
		}

		public function onEnterFrame(param1:Event):void {
			var loc5:Number = NaN;
			var loc2:int = getTimer();
			var loc3:int = loc2 - this.lastUpdate_;
			fMouseX = mouseX;
			fMouseY = mouseY;
			if (this.gameStage_ == this.GAME_STAGE_SPIN) {
				this.spinCrystals();
				this.crystalMain.setAnimationDuration(this.MAX_SPIN_SPEED + 80 - this.spinSpeed);
			}
			var loc4:int = 0;
			while (loc4 < 3) {
				this.crystals[loc4].update(loc2, loc3);
				loc4++;
			}
			this.rotateAroundCenter(this.platformMain, 0.1);
			this.rotateAroundCenter(this.platformMainSub, -0.15);
			if (this.chooseingState) {
				loc5 = Math.random();
				if (loc5 < 0.05) {
					this.crystals[int(loc5 * 200 % 3)].setShake(true);
				}
			}
			this.draw(loc2, loc3);
		}

		public function rotateAroundCenter(param1:DisplayObject, param2:Number):void {
			if (param2 < 0) {
				param2 = param2 * -1;
				param1.rotation = Math.abs(param1.rotation - param2 + 360) % 360;
			} else {
				param1.rotation = (param1.rotation + param2) % 360;
			}
		}

		public function draw(param1:int, param2:int):void {
			this.crystalMain.drawAnimation(param1, param2);
			this.particleMap.update(param1, param2);
			this.particleMap.draw(null, param1);
			this.lastUpdate_ = param1;
		}

		private function doNova(param1:Number, param2:Number, param3:int = 20, param4:int = 12447231):void {
			var loc5:GameObject = null;
			var loc6:NovaEffect = null;
			if (this.particleMap != null) {
				loc5 = new GameObject(null);
				loc5.x_ = ParticleModalMap.getLocalPos(param1);
				loc5.y_ = ParticleModalMap.getLocalPos(param2);
				loc6 = new NovaEffect(loc5, param3, param4);
				this.particleMap.addObj(loc6, loc5.x_, loc5.y_);
			}
		}

		private function doLightning(param1:Number, param2:Number, param3:Number, param4:Number, param5:int = 200, param6:int = 12447231):void {
			if (this.parent == null) {
				return;
			}
			var loc7:GameObject = new GameObject(null);
			loc7.x_ = ParticleModalMap.getLocalPos(param1);
			loc7.y_ = ParticleModalMap.getLocalPos(param2);
			var loc8:WorldPosData = new WorldPosData();
			loc8.x_ = ParticleModalMap.getLocalPos(param3);
			loc8.y_ = ParticleModalMap.getLocalPos(param4);
			var loc9:LightningEffect = new LightningEffect(loc7, loc8, param6, param5);
			this.particleMap.addObj(loc9, loc7.x_, loc7.y_);
		}

		private function setGameStage(param1:int):void {
			this.gameStage_ = param1;
		}
	}
}
