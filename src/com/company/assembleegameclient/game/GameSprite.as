package com.company.assembleegameclient.game {
	import com.company.assembleegameclient.game.events.MoneyChangedEvent;
	import com.company.assembleegameclient.map.Map;
	import com.company.assembleegameclient.objects.GameObject;
	import com.company.assembleegameclient.objects.IInteractiveObject;
	import com.company.assembleegameclient.objects.Pet;
	import com.company.assembleegameclient.objects.Player;
	import com.company.assembleegameclient.objects.Projectile;
	import com.company.assembleegameclient.parameters.Parameters;
	import com.company.assembleegameclient.tutorial.Tutorial;
	import com.company.assembleegameclient.ui.GuildText;
	import com.company.assembleegameclient.ui.RankText;
	import com.company.assembleegameclient.ui.menu.PlayerMenu;
	import com.company.assembleegameclient.util.TextureRedrawer;
	import com.company.util.CachingColorTransformer;
	import com.company.util.MoreColorUtil;
	import com.company.util.MoreObjectUtil;
	import com.company.util.PointUtil;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.filters.ColorMatrixFilter;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;

	import kabam.lib.loopedprocs.LoopedCallback;
	import kabam.lib.loopedprocs.LoopedProcess;
	import kabam.rotmg.account.core.Account;
	import kabam.rotmg.appengine.api.AppEngineClient;
	import kabam.rotmg.arena.view.ArenaTimer;
	import kabam.rotmg.arena.view.ArenaWaveCounter;
	import kabam.rotmg.chat.view.Chat;
	import kabam.rotmg.constants.GeneralConstants;
	import kabam.rotmg.core.StaticInjectorContext;
	import kabam.rotmg.core.model.MapModel;
	import kabam.rotmg.core.model.PlayerModel;
	import kabam.rotmg.core.service.GoogleAnalytics;
	import kabam.rotmg.dailyLogin.signal.ShowDailyCalendarPopupSignal;
	import kabam.rotmg.dialogs.control.AddPopupToStartupQueueSignal;
	import kabam.rotmg.dialogs.control.FlushPopupStartupQueueSignal;
	import kabam.rotmg.dialogs.control.OpenDialogSignal;
	import kabam.rotmg.dialogs.model.DialogsModel;
	import kabam.rotmg.dialogs.model.PopupNamesConfig;
	import kabam.rotmg.game.view.CreditDisplay;
	import kabam.rotmg.game.view.GiftStatusDisplay;
	import kabam.rotmg.game.view.NewsModalButton;
	import kabam.rotmg.game.view.ShopDisplay;
	import kabam.rotmg.maploading.signals.HideMapLoadingSignal;
	import kabam.rotmg.maploading.signals.MapLoadedSignal;
	import kabam.rotmg.messaging.impl.GameServerConnectionConcrete;
	import kabam.rotmg.messaging.impl.incoming.MapInfo;
	import kabam.rotmg.news.model.NewsModel;
	import kabam.rotmg.news.view.NewsTicker;
	import kabam.rotmg.packages.services.PackageModel;
	import kabam.rotmg.promotions.model.BeginnersPackageModel;
	import kabam.rotmg.promotions.signals.ShowBeginnersPackageSignal;
	import kabam.rotmg.promotions.view.SpecialOfferButton;
	import kabam.rotmg.protip.signals.ShowProTipSignal;
	import kabam.rotmg.servers.api.Server;
	import kabam.rotmg.stage3D.Renderer;
	import kabam.rotmg.ui.UIUtils;
	import kabam.rotmg.ui.signals.ShowHideKeyUISignal;
	import kabam.rotmg.ui.view.HUDView;

	import org.osflash.signals.Signal;

	import robotlegs.bender.framework.api.ILogger;

	public class GameSprite extends AGameSprite {

		public static const NON_COMBAT_MAPS:Vector.<String> = new <String>[Map.NEXUS, Map.VAULT, Map.GUILD_HALL, Map.CLOTH_BAZAAR, Map.NEXUS_EXPLANATION, Map.DAILY_QUEST_ROOM];

		public static const DISPLAY_AREA_Y_SPACE:int = 32;

		protected static const PAUSED_FILTER:ColorMatrixFilter = new ColorMatrixFilter(MoreColorUtil.greyscaleFilterMatrix);


		public const monitor:Signal = new Signal(String, int);

		public const modelInitialized:Signal = new Signal();

		public const drawCharacterWindow:Signal = new Signal(Player);

		public var chatBox_:Chat;

		public var isNexus_:Boolean = false;

		public var idleWatcher_:IdleWatcher;

		public var rankText_:RankText;

		public var guildText_:GuildText;

		public var shopDisplay:ShopDisplay;

		public var creditDisplay_:CreditDisplay;

		public var giftStatusDisplay:GiftStatusDisplay;

		public var newsModalButton:NewsModalButton;

		public var newsTicker:NewsTicker;

		public var arenaTimer:ArenaTimer;

		public var arenaWaveCounter:ArenaWaveCounter;

		public var mapModel:MapModel;

		public var beginnersPackageModel:BeginnersPackageModel;

		public var dialogsModel:DialogsModel;

		public var showBeginnersPackage:ShowBeginnersPackageSignal;

		public var openDailyCalendarPopupSignal:ShowDailyCalendarPopupSignal;

		public var openDialog:OpenDialogSignal;

		public var showPackage:Signal;

		public var packageModel:PackageModel;

		public var addToQueueSignal:AddPopupToStartupQueueSignal;

		public var flushQueueSignal:FlushPopupStartupQueueSignal;

		public var showHideKeyUISignal:ShowHideKeyUISignal;

		public var chatPlayerMenu:PlayerMenu;

		private var focus:GameObject;

		private var frameTimeSum_:int = 0;

		private var frameTimeCount_:int = 0;

		private var isGameStarted:Boolean;

		private var displaysPosY:uint = 4;

		private var currentPackage:DisplayObject;

		private var packageY:Number;

		private var googleAnalytics:GoogleAnalytics;

		private var specialOfferButton:SpecialOfferButton;

		public function GameSprite(param1:Server, param2:int, param3:Boolean, param4:int, param5:int, param6:ByteArray, param7:PlayerModel, param8:String, param9:Boolean) {
			this.showPackage = new Signal();
			this.currentPackage = new Sprite();
			super();
			this.model = param7;
			map = new Map(this);
			addChild(map);
			gsc_ = new GameServerConnectionConcrete(this, param1, param2, param3, param4, param5, param6, param8, param9);
			mui_ = new MapUserInput(this);
			this.chatBox_ = new Chat();
			this.chatBox_.list.addEventListener(MouseEvent.MOUSE_DOWN, this.onChatDown);
			this.chatBox_.list.addEventListener(MouseEvent.MOUSE_UP, this.onChatUp);
			addChild(this.chatBox_);
			this.idleWatcher_ = new IdleWatcher();
		}

		public static function dispatchMapLoaded(param1:MapInfo):void {
			var loc2:MapLoadedSignal = StaticInjectorContext.getInjector().getInstance(MapLoadedSignal);
			loc2 && loc2.dispatch(param1);
		}

		private static function hidePreloader():void {
			var loc1:HideMapLoadingSignal = StaticInjectorContext.getInjector().getInstance(HideMapLoadingSignal);
			loc1 && loc1.dispatch();
		}

		public function onChatDown(param1:MouseEvent):void {
			if (this.chatPlayerMenu != null) {
				this.removeChatPlayerMenu();
			}
			mui_.onMouseDown(param1);
		}

		public function onChatUp(param1:MouseEvent):void {
			mui_.onMouseUp(param1);
		}

		override public function setFocus(param1:GameObject):void {
			param1 = param1 || map.player_;
			this.focus = param1;
		}

		public function addChatPlayerMenu(param1:Player, param2:Number, param3:Number, param4:String = null, param5:Boolean = false, param6:Boolean = false):void {
			this.removeChatPlayerMenu();
			this.chatPlayerMenu = new PlayerMenu();
			if (param4 == null) {
				this.chatPlayerMenu.init(this, param1);
			} else if (param6) {
				this.chatPlayerMenu.initDifferentServer(this, param4, param5, param6);
			} else {
				if (param4.length > 0 && (param4.charAt(0) == "#" || param4.charAt(0) == "*" || param4.charAt(0) == "@")) {
					return;
				}
				this.chatPlayerMenu.initDifferentServer(this, param4, param5);
			}
			addChild(this.chatPlayerMenu);
			this.chatPlayerMenu.x = param2;
			this.chatPlayerMenu.y = param3 - this.chatPlayerMenu.height;
		}

		public function removeChatPlayerMenu():void {
			if (this.chatPlayerMenu != null && this.chatPlayerMenu.parent != null) {
				removeChild(this.chatPlayerMenu);
				this.chatPlayerMenu = null;
			}
		}

		override public function applyMapInfo(param1:MapInfo):void {
			map.setProps(param1.width_, param1.height_, param1.name_, param1.background_, param1.allowPlayerTeleport_, param1.showDisplays_);
			dispatchMapLoaded(param1);
		}

		public function hudModelInitialized():void {
			hudView = new HUDView();
			hudView.x = 600;
			addChild(hudView);
		}

		override public function initialize():void {
			var loc1:Account = null;
			var loc4:ShowProTipSignal = null;
			map.initialize();
			this.modelInitialized.dispatch();
			if (this.evalIsNotInCombatMapArea()) {
				this.showSafeAreaDisplays();
			}
			this.showHideKeyUISignal.dispatch(map.name_ == "Davy Jones\' Locker");
			if (map.name_ == "Arena") {
				this.showTimer();
				this.showWaveCounter();
			}
			loc1 = StaticInjectorContext.getInjector().getInstance(Account);
			this.googleAnalytics = StaticInjectorContext.getInjector().getInstance(GoogleAnalytics);
			this.isNexus_ = map.name_ == Map.NEXUS;
			if (this.isNexus_) {
				this.addToQueueSignal.dispatch(PopupNamesConfig.DAILY_LOGIN_POPUP, this.openDailyCalendarPopupSignal, -1, null);
				if (this.beginnersPackageModel.status == BeginnersPackageModel.STATUS_CAN_BUY_SHOW_POP_UP) {
					this.addToQueueSignal.dispatch(PopupNamesConfig.BEGINNERS_OFFER_POPUP, this.showBeginnersPackage, 1, null);
				} else {
					this.addToQueueSignal.dispatch(PopupNamesConfig.PACKAGES_OFFER_POPUP, this.showPackage, 1, null);
				}
				this.flushQueueSignal.dispatch();
			}
			if (this.isNexus_ || map.name_ == Map.DAILY_QUEST_ROOM) {
				this.creditDisplay_ = new CreditDisplay(this, true, true);
			} else {
				this.creditDisplay_ = new CreditDisplay(this);
			}
			this.creditDisplay_.x = 594;
			this.creditDisplay_.y = 0;
			addChild(this.creditDisplay_);
			var loc2:AppEngineClient = StaticInjectorContext.getInjector().getInstance(AppEngineClient);
			var loc3:Object = {
				"game_net_user_id": loc1.gameNetworkUserId(),
				"game_net": loc1.gameNetwork(),
				"play_platform": loc1.playPlatform()
			};
			MoreObjectUtil.addToObject(loc3, loc1.getCredentials());
			if (map.name_ != "Kitchen" && map.name_ != "Tutorial" && map.name_ != "Nexus Explanation" && Parameters.data_.watchForTutorialExit == true) {
				Parameters.data_.watchForTutorialExit = false;
				this.callTracking("rotmg.Marketing.track(\"tutorialComplete\")");
				loc3["fteStepCompleted"] = 9900;
				loc2.sendRequest("/log/logFteStep", loc3);
			}
			if (map.name_ == "Kitchen") {
				loc3["fteStepCompleted"] = 200;
				loc2.sendRequest("/log/logFteStep", loc3);
			}
			if (map.name_ == "Tutorial") {
				if (Parameters.data_.needsTutorial == true) {
					Parameters.data_.watchForTutorialExit = true;
					this.callTracking("rotmg.Marketing.track(\"install\")");
					loc3["fteStepCompleted"] = 100;
					loc2.sendRequest("/log/logFteStep", loc3);
				}
				this.startTutorial();
			} else if (map.name_ != "Arena" && map.name_ != "Kitchen" && map.name_ != "Nexus Explanation" && map.name_ != "Vault Explanation" && map.name_ != "Guild Explanation" && !this.evalIsNotInCombatMapArea() && Parameters.data_.showProtips) {
				loc4 = StaticInjectorContext.getInjector().getInstance(ShowProTipSignal);
				loc4 && loc4.dispatch();
			}
			if (map.name_ == Map.DAILY_QUEST_ROOM) {
				gsc_.questFetch();
			}
			map.setHitAreaProps(map.width, map.height);
			Parameters.save();
			hidePreloader();
		}

		private function showSafeAreaDisplays():void {
			this.showRankText();
			this.showGuildText();
			this.showShopDisplay();
			this.showGiftStatusDisplay();
			this.showNewsUpdate();
			this.showNewsTicker();
		}

		private function setDisplayPosY(param1:Number):void {
			var loc2:Number = UIUtils.NOTIFICATION_SPACE * param1;
			if (param1 != 0) {
				this.displaysPosY = 4 + loc2;
			} else {
				this.displaysPosY = 2;
			}
		}

		public function positionDynamicDisplays():void {
			var loc1:NewsModel = StaticInjectorContext.getInjector().getInstance(NewsModel);
			var loc2:int = 66;
			if (this.giftStatusDisplay && this.giftStatusDisplay.isOpen) {
				this.giftStatusDisplay.y = loc2;
				loc2 = loc2 + DISPLAY_AREA_Y_SPACE;
			}
			if (this.newsModalButton && (NewsModalButton.showsHasUpdate || loc1.hasValidModalNews())) {
				this.newsModalButton.y = loc2;
				loc2 = loc2 + DISPLAY_AREA_Y_SPACE;
			}
			if (this.specialOfferButton && this.specialOfferButton.isSpecialOfferAvailable) {
				this.specialOfferButton.y = loc2;
			}
			if (this.newsTicker && this.newsTicker.visible) {
				this.newsTicker.y = loc2;
			}
		}

		private function showTimer():void {
			this.arenaTimer = new ArenaTimer();
			this.arenaTimer.y = 5;
			addChild(this.arenaTimer);
		}

		private function showWaveCounter():void {
			this.arenaWaveCounter = new ArenaWaveCounter();
			this.arenaWaveCounter.y = 5;
			this.arenaWaveCounter.x = 5;
			addChild(this.arenaWaveCounter);
		}

		private function showNewsTicker():void {
			this.newsTicker = new NewsTicker();
			this.newsTicker.x = 300 - this.newsTicker.width / 2;
			addChild(this.newsTicker);
			this.positionDynamicDisplays();
		}

		private function showGiftStatusDisplay():void {
			this.giftStatusDisplay = new GiftStatusDisplay();
			this.giftStatusDisplay.x = 6;
			addChild(this.giftStatusDisplay);
			this.positionDynamicDisplays();
		}

		private function showShopDisplay():void {
			this.shopDisplay = new ShopDisplay(map.name_ == Map.NEXUS);
			this.shopDisplay.x = 6;
			this.shopDisplay.y = 34;
			addChild(this.shopDisplay);
		}

		private function showNewsUpdate(param1:Boolean = true):void {
			var loc4:NewsModalButton = null;
			var loc2:ILogger = StaticInjectorContext.getInjector().getInstance(ILogger);
			var loc3:NewsModel = StaticInjectorContext.getInjector().getInstance(NewsModel);
			loc2.debug("NEWS UPDATE -- making button");
			if (loc3.hasValidModalNews()) {
				loc2.debug("NEWS UPDATE -- making button - ok");
				loc4 = new NewsModalButton();
				if (this.newsModalButton != null) {
					removeChild(this.newsModalButton);
				}
				loc4.x = 6;
				this.newsModalButton = loc4;
				addChild(this.newsModalButton);
				this.positionDynamicDisplays();
			}
		}

		public function refreshNewsUpdateButton():void {
			var loc1:ILogger = StaticInjectorContext.getInjector().getInstance(ILogger);
			loc1.debug("NEWS UPDATE -- refreshing button, update noticed");
			this.showNewsUpdate(false);
		}

		private function setYAndPositionPackage():void {
			this.packageY = this.displaysPosY + 2;
			this.displaysPosY = this.displaysPosY + UIUtils.NOTIFICATION_SPACE;
			this.positionPackage();
		}

		public function showSpecialOfferIfSafe(param1:Boolean):void {
			if (this.evalIsNotInCombatMapArea()) {
				this.specialOfferButton = new SpecialOfferButton(param1);
				this.specialOfferButton.x = 6;
				addChild(this.specialOfferButton);
				this.positionDynamicDisplays();
			}
		}

		public function showPackageButtonIfSafe():void {
			if (!this.evalIsNotInCombatMapArea()) {
			}
		}

		private function addAndPositionPackage(param1:DisplayObject):void {
			this.currentPackage = param1;
			addChild(this.currentPackage);
			this.positionPackage();
		}

		private function positionPackage():void {
			this.currentPackage.x = 80;
			this.setDisplayPosY(1);
			this.currentPackage.y = this.displaysPosY;
		}

		private function showGuildText():void {
			this.guildText_ = new GuildText("", -1);
			this.guildText_.x = 64;
			this.guildText_.y = 2;
			addChild(this.guildText_);
		}

		private function showRankText():void {
			this.rankText_ = new RankText(-1, true, false);
			this.rankText_.x = 8;
			this.rankText_.y = 2;
			addChild(this.rankText_);
		}

		private function callTracking(param1:String):void {
			if (ExternalInterface.available == false) {
				return;
			}
			try {
				ExternalInterface.call(param1);
				return;
			}
			catch (err:Error) {
				return;
			}
		}

		private function startTutorial():void {
			tutorial_ = new Tutorial(this);
			addChild(tutorial_);
		}

		private function updateNearestInteractive():void {
			var loc4:Number = NaN;
			var loc7:GameObject = null;
			var loc8:IInteractiveObject = null;
			if (!map || !map.player_) {
				return;
			}
			var loc1:Player = map.player_;
			var loc2:Number = GeneralConstants.MAXIMUM_INTERACTION_DISTANCE;
			var loc3:IInteractiveObject = null;
			var loc5:Number = loc1.x_;
			var loc6:Number = loc1.y_;
			for each(loc7 in map.goDict_) {
				loc8 = loc7 as IInteractiveObject;
				if (loc8 && (!(loc8 is Pet) || this.map.isPetYard)) {
					if (Math.abs(loc5 - loc7.x_) < GeneralConstants.MAXIMUM_INTERACTION_DISTANCE || Math.abs(loc6 - loc7.y_) < GeneralConstants.MAXIMUM_INTERACTION_DISTANCE) {
						loc4 = PointUtil.distanceXY(loc7.x_, loc7.y_, loc5, loc6);
						if (loc4 < GeneralConstants.MAXIMUM_INTERACTION_DISTANCE && loc4 < loc2) {
							loc2 = loc4;
							loc3 = loc8;
						}
					}
				}
			}
			this.mapModel.currentInteractiveTarget = loc3;
		}

		private function isPetMap():Boolean {
			return true;
		}

		public function connect():void {
			if (!this.isGameStarted) {
				this.isGameStarted = true;
				Renderer.inGame = true;
				gsc_.connect();
				this.idleWatcher_.start(this);
				lastUpdate_ = getTimer();
				stage.addEventListener(MoneyChangedEvent.MONEY_CHANGED, this.onMoneyChanged);
				stage.addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
				LoopedProcess.addProcess(new LoopedCallback(100, this.updateNearestInteractive));
			}
		}

		public function disconnect():void {
			if (this.isGameStarted) {
				this.isGameStarted = false;
				Renderer.inGame = false;
				this.idleWatcher_.stop();
				stage.removeEventListener(MoneyChangedEvent.MONEY_CHANGED, this.onMoneyChanged);
				stage.removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
				LoopedProcess.destroyAll();
				contains(map) && removeChild(map);
				map.dispose();
				CachingColorTransformer.clear();
				TextureRedrawer.clearCache();
				Projectile.dispose();
				gsc_.disconnect();
			}
		}

		private function onMoneyChanged(param1:Event):void {
			gsc_.checkCredits();
		}

		override public function evalIsNotInCombatMapArea():Boolean {
			return NON_COMBAT_MAPS.indexOf(map.name_) != -1;
		}

		private function onEnterFrame(param1:Event):void {
			var loc7:Number = NaN;
			var loc2:int = getTimer();
			var loc3:int = loc2 - lastUpdate_;
			if (this.idleWatcher_.update(loc3)) {
				closed.dispatch();
				return;
			}
			LoopedProcess.runProcesses(loc2);
			this.frameTimeSum_ = this.frameTimeSum_ + loc3;
			this.frameTimeCount_ = this.frameTimeCount_ + 1;
			if (this.frameTimeSum_ > 300000) {
				loc7 = int(Math.round(1000 * this.frameTimeCount_ / this.frameTimeSum_));
				this.frameTimeCount_ = 0;
				this.frameTimeSum_ = 0;
			}
			var loc4:int = getTimer();
			map.update(loc2, loc3);
			this.monitor.dispatch("Map.update", getTimer() - loc4);
			camera_.update(loc3);
			var loc5:Player = map.player_;
			if (this.focus) {
				camera_.configureCamera(this.focus, !!loc5 ? Boolean(loc5.isHallucinating()) : false);
				map.draw(camera_, loc2);
			}
			if (loc5 != null) {
				this.creditDisplay_.draw(loc5.credits_, loc5.fame_, loc5.tokens_);
				this.drawCharacterWindow.dispatch(loc5);
				if (this.evalIsNotInCombatMapArea()) {
					this.rankText_.draw(loc5.numStars_);
					this.guildText_.draw(loc5.guildName_, loc5.guildRank_);
				}
				if (loc5.isPaused()) {
					map.filters = [PAUSED_FILTER];
					hudView.filters = [PAUSED_FILTER];
					map.mouseEnabled = false;
					map.mouseChildren = false;
					hudView.mouseEnabled = false;
					hudView.mouseChildren = false;
				} else if (map.filters.length > 0) {
					map.filters = [];
					hudView.filters = [];
					map.mouseEnabled = true;
					map.mouseChildren = true;
					hudView.mouseEnabled = true;
					hudView.mouseChildren = true;
				}
				moveRecords_.addRecord(loc2, loc5.x_, loc5.y_);
			}
			lastUpdate_ = loc2;
			var loc6:int = getTimer() - loc2;
			this.monitor.dispatch("GameSprite.loop", loc6);
		}

		public function showPetToolTip(param1:Boolean):void {
		}
	}
}
