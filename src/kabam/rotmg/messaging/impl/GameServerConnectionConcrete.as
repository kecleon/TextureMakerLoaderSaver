 
package kabam.rotmg.messaging.impl {
	import com.company.assembleegameclient.game.AGameSprite;
	import com.company.assembleegameclient.game.events.GuildResultEvent;
	import com.company.assembleegameclient.game.events.KeyInfoResponseSignal;
	import com.company.assembleegameclient.game.events.NameResultEvent;
	import com.company.assembleegameclient.game.events.ReconnectEvent;
	import com.company.assembleegameclient.map.AbstractMap;
	import com.company.assembleegameclient.map.GroundLibrary;
	import com.company.assembleegameclient.map.mapoverlay.CharacterStatusText;
	import com.company.assembleegameclient.objects.Container;
	import com.company.assembleegameclient.objects.FlashDescription;
	import com.company.assembleegameclient.objects.GameObject;
	import com.company.assembleegameclient.objects.Merchant;
	import com.company.assembleegameclient.objects.NameChanger;
	import com.company.assembleegameclient.objects.ObjectLibrary;
	import com.company.assembleegameclient.objects.ObjectProperties;
	import com.company.assembleegameclient.objects.Pet;
	import com.company.assembleegameclient.objects.Player;
	import com.company.assembleegameclient.objects.Portal;
	import com.company.assembleegameclient.objects.Projectile;
	import com.company.assembleegameclient.objects.ProjectileProperties;
	import com.company.assembleegameclient.objects.SellableObject;
	import com.company.assembleegameclient.objects.particles.AOEEffect;
	import com.company.assembleegameclient.objects.particles.BurstEffect;
	import com.company.assembleegameclient.objects.particles.CollapseEffect;
	import com.company.assembleegameclient.objects.particles.ConeBlastEffect;
	import com.company.assembleegameclient.objects.particles.FlowEffect;
	import com.company.assembleegameclient.objects.particles.HealEffect;
	import com.company.assembleegameclient.objects.particles.LightningEffect;
	import com.company.assembleegameclient.objects.particles.LineEffect;
	import com.company.assembleegameclient.objects.particles.NovaEffect;
	import com.company.assembleegameclient.objects.particles.ParticleEffect;
	import com.company.assembleegameclient.objects.particles.PoisonEffect;
	import com.company.assembleegameclient.objects.particles.RingEffect;
	import com.company.assembleegameclient.objects.particles.RisingFuryEffect;
	import com.company.assembleegameclient.objects.particles.ShockeeEffect;
	import com.company.assembleegameclient.objects.particles.ShockerEffect;
	import com.company.assembleegameclient.objects.particles.StreamEffect;
	import com.company.assembleegameclient.objects.particles.TeleportEffect;
	import com.company.assembleegameclient.objects.particles.ThrowEffect;
	import com.company.assembleegameclient.objects.thrown.ThrowProjectileEffect;
	import com.company.assembleegameclient.parameters.Parameters;
	import com.company.assembleegameclient.sound.SoundEffectLibrary;
	import com.company.assembleegameclient.ui.PicView;
	import com.company.assembleegameclient.ui.dialogs.Dialog;
	import com.company.assembleegameclient.ui.dialogs.NotEnoughFameDialog;
	import com.company.assembleegameclient.ui.panels.GuildInvitePanel;
	import com.company.assembleegameclient.ui.panels.TradeRequestPanel;
	import com.company.assembleegameclient.util.ConditionEffect;
	import com.company.assembleegameclient.util.Currency;
	import com.company.assembleegameclient.util.FreeList;
	import com.company.util.MoreStringUtil;
	import com.company.util.Random;
	import com.hurlant.crypto.Crypto;
	import com.hurlant.crypto.rsa.RSAKey;
	import com.hurlant.crypto.symmetric.ICipher;
	import com.hurlant.util.Base64;
	import com.hurlant.util.der.PEM;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import io.decagames.rotmg.characterMetrics.tracker.CharactersMetricsTracker;
	import io.decagames.rotmg.classes.NewClassUnlockSignal;
	import io.decagames.rotmg.dailyQuests.messages.incoming.QuestFetchResponse;
	import io.decagames.rotmg.dailyQuests.signal.QuestFetchCompleteSignal;
	import io.decagames.rotmg.dailyQuests.signal.QuestRedeemCompleteSignal;
	import io.decagames.rotmg.pets.data.PetsModel;
	import io.decagames.rotmg.pets.data.vo.HatchPetVO;
	import io.decagames.rotmg.pets.signals.DeletePetSignal;
	import io.decagames.rotmg.pets.signals.HatchPetSignal;
	import io.decagames.rotmg.pets.signals.NewAbilitySignal;
	import io.decagames.rotmg.pets.signals.PetFeedResultSignal;
	import io.decagames.rotmg.pets.signals.UpdateActivePet;
	import io.decagames.rotmg.pets.signals.UpdatePetYardSignal;
	import io.decagames.rotmg.social.model.SocialModel;
	import io.decagames.rotmg.supportCampaign.data.SupporterCampaignModel;
	import kabam.lib.net.api.MessageMap;
	import kabam.lib.net.api.MessageProvider;
	import kabam.lib.net.impl.Message;
	import kabam.lib.net.impl.SocketServer;
	import kabam.rotmg.account.core.Account;
	import kabam.rotmg.account.core.view.PurchaseConfirmationDialog;
	import kabam.rotmg.arena.control.ArenaDeathSignal;
	import kabam.rotmg.arena.control.ImminentArenaWaveSignal;
	import kabam.rotmg.arena.model.CurrentArenaRunModel;
	import kabam.rotmg.arena.view.BattleSummaryDialog;
	import kabam.rotmg.arena.view.ContinueOrQuitDialog;
	import kabam.rotmg.chat.model.ChatMessage;
	import kabam.rotmg.classes.model.CharacterClass;
	import kabam.rotmg.classes.model.CharacterSkin;
	import kabam.rotmg.classes.model.CharacterSkinState;
	import kabam.rotmg.classes.model.ClassesModel;
	import kabam.rotmg.constants.GeneralConstants;
	import kabam.rotmg.constants.ItemConstants;
	import kabam.rotmg.core.StaticInjectorContext;
	import kabam.rotmg.core.service.GoogleAnalytics;
	import kabam.rotmg.dailyLogin.message.ClaimDailyRewardMessage;
	import kabam.rotmg.dailyLogin.message.ClaimDailyRewardResponse;
	import kabam.rotmg.dailyLogin.signal.ClaimDailyRewardResponseSignal;
	import kabam.rotmg.death.control.HandleDeathSignal;
	import kabam.rotmg.death.control.ZombifySignal;
	import kabam.rotmg.dialogs.control.CloseDialogsSignal;
	import kabam.rotmg.dialogs.control.OpenDialogSignal;
	import kabam.rotmg.game.focus.control.SetGameFocusSignal;
	import kabam.rotmg.game.model.GameModel;
	import kabam.rotmg.game.model.PotionInventoryModel;
	import kabam.rotmg.game.signals.AddSpeechBalloonSignal;
	import kabam.rotmg.game.signals.AddTextLineSignal;
	import kabam.rotmg.game.signals.GiftStatusUpdateSignal;
	import kabam.rotmg.maploading.signals.ChangeMapSignal;
	import kabam.rotmg.maploading.signals.HideMapLoadingSignal;
	import kabam.rotmg.messaging.impl.data.GroundTileData;
	import kabam.rotmg.messaging.impl.data.ObjectData;
	import kabam.rotmg.messaging.impl.data.ObjectStatusData;
	import kabam.rotmg.messaging.impl.data.SlotObjectData;
	import kabam.rotmg.messaging.impl.data.StatData;
	import kabam.rotmg.messaging.impl.incoming.AccountList;
	import kabam.rotmg.messaging.impl.incoming.AllyShoot;
	import kabam.rotmg.messaging.impl.incoming.Aoe;
	import kabam.rotmg.messaging.impl.incoming.BuyResult;
	import kabam.rotmg.messaging.impl.incoming.ClientStat;
	import kabam.rotmg.messaging.impl.incoming.CreateSuccess;
	import kabam.rotmg.messaging.impl.incoming.Damage;
	import kabam.rotmg.messaging.impl.incoming.Death;
	import kabam.rotmg.messaging.impl.incoming.EnemyShoot;
	import kabam.rotmg.messaging.impl.incoming.EvolvedMessageHandler;
	import kabam.rotmg.messaging.impl.incoming.EvolvedPetMessage;
	import kabam.rotmg.messaging.impl.incoming.Failure;
	import kabam.rotmg.messaging.impl.incoming.File;
	import kabam.rotmg.messaging.impl.incoming.GlobalNotification;
	import kabam.rotmg.messaging.impl.incoming.Goto;
	import kabam.rotmg.messaging.impl.incoming.GuildResult;
	import kabam.rotmg.messaging.impl.incoming.InvResult;
	import kabam.rotmg.messaging.impl.incoming.InvitedToGuild;
	import kabam.rotmg.messaging.impl.incoming.KeyInfoResponse;
	import kabam.rotmg.messaging.impl.incoming.MapInfo;
	import kabam.rotmg.messaging.impl.incoming.NameResult;
	import kabam.rotmg.messaging.impl.incoming.NewAbilityMessage;
	import kabam.rotmg.messaging.impl.incoming.NewTick;
	import kabam.rotmg.messaging.impl.incoming.Notification;
	import kabam.rotmg.messaging.impl.incoming.PasswordPrompt;
	import kabam.rotmg.messaging.impl.incoming.Pic;
	import kabam.rotmg.messaging.impl.incoming.Ping;
	import kabam.rotmg.messaging.impl.incoming.PlaySound;
	import kabam.rotmg.messaging.impl.incoming.QuestObjId;
	import kabam.rotmg.messaging.impl.incoming.QuestRedeemResponse;
	import kabam.rotmg.messaging.impl.incoming.Reconnect;
	import kabam.rotmg.messaging.impl.incoming.ReskinUnlock;
	import kabam.rotmg.messaging.impl.incoming.ServerPlayerShoot;
	import kabam.rotmg.messaging.impl.incoming.ShowEffect;
	import kabam.rotmg.messaging.impl.incoming.TradeAccepted;
	import kabam.rotmg.messaging.impl.incoming.TradeChanged;
	import kabam.rotmg.messaging.impl.incoming.TradeDone;
	import kabam.rotmg.messaging.impl.incoming.TradeRequested;
	import kabam.rotmg.messaging.impl.incoming.TradeStart;
	import kabam.rotmg.messaging.impl.incoming.Update;
	import kabam.rotmg.messaging.impl.incoming.VerifyEmail;
	import kabam.rotmg.messaging.impl.incoming.arena.ArenaDeath;
	import kabam.rotmg.messaging.impl.incoming.arena.ImminentArenaWave;
	import kabam.rotmg.messaging.impl.incoming.pets.DeletePetMessage;
	import kabam.rotmg.messaging.impl.incoming.pets.HatchPetMessage;
	import kabam.rotmg.messaging.impl.outgoing.AcceptTrade;
	import kabam.rotmg.messaging.impl.outgoing.ActivePetUpdateRequest;
	import kabam.rotmg.messaging.impl.outgoing.AoeAck;
	import kabam.rotmg.messaging.impl.outgoing.Buy;
	import kabam.rotmg.messaging.impl.outgoing.CancelTrade;
	import kabam.rotmg.messaging.impl.outgoing.ChangeGuildRank;
	import kabam.rotmg.messaging.impl.outgoing.ChangePetSkin;
	import kabam.rotmg.messaging.impl.outgoing.ChangeTrade;
	import kabam.rotmg.messaging.impl.outgoing.CheckCredits;
	import kabam.rotmg.messaging.impl.outgoing.ChooseName;
	import kabam.rotmg.messaging.impl.outgoing.Create;
	import kabam.rotmg.messaging.impl.outgoing.CreateGuild;
	import kabam.rotmg.messaging.impl.outgoing.EditAccountList;
	import kabam.rotmg.messaging.impl.outgoing.EnemyHit;
	import kabam.rotmg.messaging.impl.outgoing.Escape;
	import kabam.rotmg.messaging.impl.outgoing.GoToQuestRoom;
	import kabam.rotmg.messaging.impl.outgoing.GotoAck;
	import kabam.rotmg.messaging.impl.outgoing.GroundDamage;
	import kabam.rotmg.messaging.impl.outgoing.GuildInvite;
	import kabam.rotmg.messaging.impl.outgoing.GuildRemove;
	import kabam.rotmg.messaging.impl.outgoing.Hello;
	import kabam.rotmg.messaging.impl.outgoing.InvDrop;
	import kabam.rotmg.messaging.impl.outgoing.InvSwap;
	import kabam.rotmg.messaging.impl.outgoing.JoinGuild;
	import kabam.rotmg.messaging.impl.outgoing.KeyInfoRequest;
	import kabam.rotmg.messaging.impl.outgoing.Load;
	import kabam.rotmg.messaging.impl.outgoing.Move;
	import kabam.rotmg.messaging.impl.outgoing.OtherHit;
	import kabam.rotmg.messaging.impl.outgoing.OutgoingMessage;
	import kabam.rotmg.messaging.impl.outgoing.PlayerHit;
	import kabam.rotmg.messaging.impl.outgoing.PlayerShoot;
	import kabam.rotmg.messaging.impl.outgoing.PlayerText;
	import kabam.rotmg.messaging.impl.outgoing.Pong;
	import kabam.rotmg.messaging.impl.outgoing.RequestTrade;
	import kabam.rotmg.messaging.impl.outgoing.Reskin;
	import kabam.rotmg.messaging.impl.outgoing.SetCondition;
	import kabam.rotmg.messaging.impl.outgoing.ShootAck;
	import kabam.rotmg.messaging.impl.outgoing.SquareHit;
	import kabam.rotmg.messaging.impl.outgoing.Teleport;
	import kabam.rotmg.messaging.impl.outgoing.UseItem;
	import kabam.rotmg.messaging.impl.outgoing.UsePortal;
	import kabam.rotmg.messaging.impl.outgoing.arena.EnterArena;
	import kabam.rotmg.messaging.impl.outgoing.arena.QuestRedeem;
	import kabam.rotmg.minimap.control.UpdateGameObjectTileSignal;
	import kabam.rotmg.minimap.control.UpdateGroundTileSignal;
	import kabam.rotmg.minimap.model.UpdateGroundTileVO;
	import kabam.rotmg.servers.api.Server;
	import kabam.rotmg.text.model.TextKey;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;
	import kabam.rotmg.ui.model.HUDModel;
	import kabam.rotmg.ui.model.Key;
	import kabam.rotmg.ui.model.UpdateGameObjectTileVO;
	import kabam.rotmg.ui.signals.ShowHideKeyUISignal;
	import kabam.rotmg.ui.signals.ShowKeySignal;
	import kabam.rotmg.ui.signals.UpdateBackpackTabSignal;
	import kabam.rotmg.ui.view.NotEnoughGoldDialog;
	import kabam.rotmg.ui.view.TitleView;
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.framework.api.ILogger;
	
	public class GameServerConnectionConcrete extends GameServerConnection {
		
		private static const TO_MILLISECONDS:int = 1000;
		 
		
		private var petUpdater:PetUpdater;
		
		private var messages:MessageProvider;
		
		private var playerId_:int = -1;
		
		private var player:Player;
		
		private var retryConnection_:Boolean = true;
		
		private var rand_:Random = null;
		
		private var giftChestUpdateSignal:GiftStatusUpdateSignal;
		
		private var death:Death;
		
		private var retryTimer_:Timer;
		
		private var delayBeforeReconnect:int = 2;
		
		private var addTextLine:AddTextLineSignal;
		
		private var addSpeechBalloon:AddSpeechBalloonSignal;
		
		private var updateGroundTileSignal:UpdateGroundTileSignal;
		
		private var updateGameObjectTileSignal:UpdateGameObjectTileSignal;
		
		private var logger:ILogger;
		
		private var handleDeath:HandleDeathSignal;
		
		private var zombify:ZombifySignal;
		
		private var setGameFocus:SetGameFocusSignal;
		
		private var updateBackpackTab:UpdateBackpackTabSignal;
		
		private var petFeedResult:PetFeedResultSignal;
		
		private var closeDialogs:CloseDialogsSignal;
		
		private var openDialog:OpenDialogSignal;
		
		private var arenaDeath:ArenaDeathSignal;
		
		private var imminentWave:ImminentArenaWaveSignal;
		
		private var questFetchComplete:QuestFetchCompleteSignal;
		
		private var questRedeemComplete:QuestRedeemCompleteSignal;
		
		private var keyInfoResponse:KeyInfoResponseSignal;
		
		private var claimDailyRewardResponse:ClaimDailyRewardResponseSignal;
		
		private var newClassUnlockSignal:NewClassUnlockSignal;
		
		private var showHideKeyUISignal:ShowHideKeyUISignal;
		
		private var currentArenaRun:CurrentArenaRunModel;
		
		private var classesModel:ClassesModel;
		
		private var injector:Injector;
		
		private var model:GameModel;
		
		private var hudModel:HUDModel;
		
		private var updateActivePet:UpdateActivePet;
		
		private var petsModel:PetsModel;
		
		private var socialModel:SocialModel;
		
		private var statsTracker:CharactersMetricsTracker;
		
		public function GameServerConnectionConcrete(param1:AGameSprite, param2:Server, param3:int, param4:Boolean, param5:int, param6:int, param7:ByteArray, param8:String, param9:Boolean) {
			super();
			this.injector = StaticInjectorContext.getInjector();
			this.giftChestUpdateSignal = this.injector.getInstance(GiftStatusUpdateSignal);
			this.addTextLine = this.injector.getInstance(AddTextLineSignal);
			this.addSpeechBalloon = this.injector.getInstance(AddSpeechBalloonSignal);
			this.updateGroundTileSignal = this.injector.getInstance(UpdateGroundTileSignal);
			this.updateGameObjectTileSignal = this.injector.getInstance(UpdateGameObjectTileSignal);
			this.petFeedResult = this.injector.getInstance(PetFeedResultSignal);
			this.updateBackpackTab = StaticInjectorContext.getInjector().getInstance(UpdateBackpackTabSignal);
			this.updateActivePet = this.injector.getInstance(UpdateActivePet);
			this.petsModel = this.injector.getInstance(PetsModel);
			this.socialModel = this.injector.getInstance(SocialModel);
			this.closeDialogs = this.injector.getInstance(CloseDialogsSignal);
			changeMapSignal = this.injector.getInstance(ChangeMapSignal);
			this.openDialog = this.injector.getInstance(OpenDialogSignal);
			this.arenaDeath = this.injector.getInstance(ArenaDeathSignal);
			this.imminentWave = this.injector.getInstance(ImminentArenaWaveSignal);
			this.questFetchComplete = this.injector.getInstance(QuestFetchCompleteSignal);
			this.questRedeemComplete = this.injector.getInstance(QuestRedeemCompleteSignal);
			this.keyInfoResponse = this.injector.getInstance(KeyInfoResponseSignal);
			this.claimDailyRewardResponse = this.injector.getInstance(ClaimDailyRewardResponseSignal);
			this.newClassUnlockSignal = this.injector.getInstance(NewClassUnlockSignal);
			this.showHideKeyUISignal = this.injector.getInstance(ShowHideKeyUISignal);
			this.statsTracker = this.injector.getInstance(CharactersMetricsTracker);
			this.logger = this.injector.getInstance(ILogger);
			this.handleDeath = this.injector.getInstance(HandleDeathSignal);
			this.zombify = this.injector.getInstance(ZombifySignal);
			this.setGameFocus = this.injector.getInstance(SetGameFocusSignal);
			this.classesModel = this.injector.getInstance(ClassesModel);
			serverConnection = this.injector.getInstance(SocketServer);
			this.messages = this.injector.getInstance(MessageProvider);
			this.model = this.injector.getInstance(GameModel);
			this.hudModel = this.injector.getInstance(HUDModel);
			this.currentArenaRun = this.injector.getInstance(CurrentArenaRunModel);
			gs_ = param1;
			server_ = param2;
			gameId_ = param3;
			createCharacter_ = param4;
			charId_ = param5;
			keyTime_ = param6;
			key_ = param7;
			mapJSON_ = param8;
			isFromArena_ = param9;
			this.socialModel.loadInvitations();
			this.socialModel.setCurrentServer(server_);
			this.getPetUpdater();
			instance = this;
		}
		
		private static function isStatPotion(param1:int) : Boolean {
			return param1 == 2591 || param1 == 5465 || param1 == 9064 || (param1 == 2592 || param1 == 5466 || param1 == 9065) || (param1 == 2593 || param1 == 5467 || param1 == 9066) || (param1 == 2612 || param1 == 5468 || param1 == 9067) || (param1 == 2613 || param1 == 5469 || param1 == 9068) || (param1 == 2636 || param1 == 5470 || param1 == 9069) || (param1 == 2793 || param1 == 5471 || param1 == 9070) || (param1 == 2794 || param1 == 5472 || param1 == 9071) || (param1 == 9724 || param1 == 9725 || param1 == 9726 || param1 == 9727 || param1 == 9728 || param1 == 9729 || param1 == 9730 || param1 == 9731);
		}
		
		private function getPetUpdater() : void {
			this.injector.map(AGameSprite).toValue(gs_);
			this.petUpdater = this.injector.getInstance(PetUpdater);
			this.injector.unmap(AGameSprite);
		}
		
		override public function disconnect() : void {
			this.removeServerConnectionListeners();
			this.unmapMessages();
			serverConnection.disconnect();
		}
		
		private function removeServerConnectionListeners() : void {
			serverConnection.connected.remove(this.onConnected);
			serverConnection.closed.remove(this.onClosed);
			serverConnection.error.remove(this.onError);
		}
		
		override public function connect() : void {
			this.addServerConnectionListeners();
			this.mapMessages();
			var loc1:ChatMessage = new ChatMessage();
			loc1.name = Parameters.CLIENT_CHAT_NAME;
			loc1.text = TextKey.CHAT_CONNECTING_TO;
			var loc2:String = server_.name;
			if(loc2 == "{\"text\":\"server.vault\"}") {
				loc2 = "server.vault";
			}
			loc2 = LineBuilder.getLocalizedStringFromKey(loc2);
			loc1.tokens = {"serverName":loc2};
			this.addTextLine.dispatch(loc1);
			serverConnection.connect(server_.address,server_.port);
		}
		
		public function addServerConnectionListeners() : void {
			serverConnection.connected.add(this.onConnected);
			serverConnection.closed.add(this.onClosed);
			serverConnection.error.add(this.onError);
		}
		
		public function mapMessages() : void {
			var loc1:MessageMap = this.injector.getInstance(MessageMap);
			loc1.map(CREATE).toMessage(Create);
			loc1.map(PLAYERSHOOT).toMessage(PlayerShoot);
			loc1.map(MOVE).toMessage(Move);
			loc1.map(PLAYERTEXT).toMessage(PlayerText);
			loc1.map(UPDATEACK).toMessage(Message);
			loc1.map(INVSWAP).toMessage(InvSwap);
			loc1.map(USEITEM).toMessage(UseItem);
			loc1.map(HELLO).toMessage(Hello);
			loc1.map(INVDROP).toMessage(InvDrop);
			loc1.map(PONG).toMessage(Pong);
			loc1.map(LOAD).toMessage(Load);
			loc1.map(SETCONDITION).toMessage(SetCondition);
			loc1.map(TELEPORT).toMessage(Teleport);
			loc1.map(USEPORTAL).toMessage(UsePortal);
			loc1.map(BUY).toMessage(Buy);
			loc1.map(PLAYERHIT).toMessage(PlayerHit);
			loc1.map(ENEMYHIT).toMessage(EnemyHit);
			loc1.map(AOEACK).toMessage(AoeAck);
			loc1.map(SHOOTACK).toMessage(ShootAck);
			loc1.map(OTHERHIT).toMessage(OtherHit);
			loc1.map(SQUAREHIT).toMessage(SquareHit);
			loc1.map(GOTOACK).toMessage(GotoAck);
			loc1.map(GROUNDDAMAGE).toMessage(GroundDamage);
			loc1.map(CHOOSENAME).toMessage(ChooseName);
			loc1.map(CREATEGUILD).toMessage(CreateGuild);
			loc1.map(GUILDREMOVE).toMessage(GuildRemove);
			loc1.map(GUILDINVITE).toMessage(GuildInvite);
			loc1.map(REQUESTTRADE).toMessage(RequestTrade);
			loc1.map(CHANGETRADE).toMessage(ChangeTrade);
			loc1.map(ACCEPTTRADE).toMessage(AcceptTrade);
			loc1.map(CANCELTRADE).toMessage(CancelTrade);
			loc1.map(CHECKCREDITS).toMessage(CheckCredits);
			loc1.map(ESCAPE).toMessage(Escape);
			loc1.map(QUEST_ROOM_MSG).toMessage(GoToQuestRoom);
			loc1.map(JOINGUILD).toMessage(JoinGuild);
			loc1.map(CHANGEGUILDRANK).toMessage(ChangeGuildRank);
			loc1.map(EDITACCOUNTLIST).toMessage(EditAccountList);
			loc1.map(ACTIVE_PET_UPDATE_REQUEST).toMessage(ActivePetUpdateRequest);
			loc1.map(PETUPGRADEREQUEST).toMessage(PetUpgradeRequest);
			loc1.map(ENTER_ARENA).toMessage(EnterArena);
			loc1.map(ACCEPT_ARENA_DEATH).toMessage(OutgoingMessage);
			loc1.map(QUEST_FETCH_ASK).toMessage(OutgoingMessage);
			loc1.map(QUEST_REDEEM).toMessage(QuestRedeem);
			loc1.map(KEY_INFO_REQUEST).toMessage(KeyInfoRequest);
			loc1.map(PET_CHANGE_FORM_MSG).toMessage(ReskinPet);
			loc1.map(CLAIM_LOGIN_REWARD_MSG).toMessage(ClaimDailyRewardMessage);
			loc1.map(PET_CHANGE_SKIN_MSG).toMessage(ChangePetSkin);
			loc1.map(FAILURE).toMessage(Failure).toMethod(this.onFailure);
			loc1.map(CREATE_SUCCESS).toMessage(CreateSuccess).toMethod(this.onCreateSuccess);
			loc1.map(SERVERPLAYERSHOOT).toMessage(ServerPlayerShoot).toMethod(this.onServerPlayerShoot);
			loc1.map(DAMAGE).toMessage(Damage).toMethod(this.onDamage);
			loc1.map(UPDATE).toMessage(Update).toMethod(this.onUpdate);
			loc1.map(NOTIFICATION).toMessage(Notification).toMethod(this.onNotification);
			loc1.map(GLOBAL_NOTIFICATION).toMessage(GlobalNotification).toMethod(this.onGlobalNotification);
			loc1.map(NEWTICK).toMessage(NewTick).toMethod(this.onNewTick);
			loc1.map(SHOWEFFECT).toMessage(ShowEffect).toMethod(this.onShowEffect);
			loc1.map(GOTO).toMessage(Goto).toMethod(this.onGoto);
			loc1.map(INVRESULT).toMessage(InvResult).toMethod(this.onInvResult);
			loc1.map(RECONNECT).toMessage(Reconnect).toMethod(this.onReconnect);
			loc1.map(PING).toMessage(Ping).toMethod(this.onPing);
			loc1.map(MAPINFO).toMessage(MapInfo).toMethod(this.onMapInfo);
			loc1.map(PIC).toMessage(Pic).toMethod(this.onPic);
			loc1.map(DEATH).toMessage(Death).toMethod(this.onDeath);
			loc1.map(BUYRESULT).toMessage(BuyResult).toMethod(this.onBuyResult);
			loc1.map(AOE).toMessage(Aoe).toMethod(this.onAoe);
			loc1.map(ACCOUNTLIST).toMessage(AccountList).toMethod(this.onAccountList);
			loc1.map(QUESTOBJID).toMessage(QuestObjId).toMethod(this.onQuestObjId);
			loc1.map(NAMERESULT).toMessage(NameResult).toMethod(this.onNameResult);
			loc1.map(GUILDRESULT).toMessage(GuildResult).toMethod(this.onGuildResult);
			loc1.map(ALLYSHOOT).toMessage(AllyShoot).toMethod(this.onAllyShoot);
			loc1.map(ENEMYSHOOT).toMessage(EnemyShoot).toMethod(this.onEnemyShoot);
			loc1.map(TRADEREQUESTED).toMessage(TradeRequested).toMethod(this.onTradeRequested);
			loc1.map(TRADESTART).toMessage(TradeStart).toMethod(this.onTradeStart);
			loc1.map(TRADECHANGED).toMessage(TradeChanged).toMethod(this.onTradeChanged);
			loc1.map(TRADEDONE).toMessage(TradeDone).toMethod(this.onTradeDone);
			loc1.map(TRADEACCEPTED).toMessage(TradeAccepted).toMethod(this.onTradeAccepted);
			loc1.map(CLIENTSTAT).toMessage(ClientStat).toMethod(this.onClientStat);
			loc1.map(FILE).toMessage(File).toMethod(this.onFile);
			loc1.map(INVITEDTOGUILD).toMessage(InvitedToGuild).toMethod(this.onInvitedToGuild);
			loc1.map(PLAYSOUND).toMessage(PlaySound).toMethod(this.onPlaySound);
			loc1.map(ACTIVEPETUPDATE).toMessage(ActivePet).toMethod(this.onActivePetUpdate);
			loc1.map(NEW_ABILITY).toMessage(NewAbilityMessage).toMethod(this.onNewAbility);
			loc1.map(PETYARDUPDATE).toMessage(PetYard).toMethod(this.onPetYardUpdate);
			loc1.map(EVOLVE_PET).toMessage(EvolvedPetMessage).toMethod(this.onEvolvedPet);
			loc1.map(DELETE_PET).toMessage(DeletePetMessage).toMethod(this.onDeletePet);
			loc1.map(HATCH_PET).toMessage(HatchPetMessage).toMethod(this.onHatchPet);
			loc1.map(IMMINENT_ARENA_WAVE).toMessage(ImminentArenaWave).toMethod(this.onImminentArenaWave);
			loc1.map(ARENA_DEATH).toMessage(ArenaDeath).toMethod(this.onArenaDeath);
			loc1.map(VERIFY_EMAIL).toMessage(VerifyEmail).toMethod(this.onVerifyEmail);
			loc1.map(RESKIN_UNLOCK).toMessage(ReskinUnlock).toMethod(this.onReskinUnlock);
			loc1.map(PASSWORD_PROMPT).toMessage(PasswordPrompt).toMethod(this.onPasswordPrompt);
			loc1.map(QUEST_FETCH_RESPONSE).toMessage(QuestFetchResponse).toMethod(this.onQuestFetchResponse);
			loc1.map(QUEST_REDEEM_RESPONSE).toMessage(QuestRedeemResponse).toMethod(this.onQuestRedeemResponse);
			loc1.map(KEY_INFO_RESPONSE).toMessage(KeyInfoResponse).toMethod(this.onKeyInfoResponse);
			loc1.map(LOGIN_REWARD_MSG).toMessage(ClaimDailyRewardResponse).toMethod(this.onLoginRewardResponse);
		}
		
		private function onHatchPet(param1:HatchPetMessage) : void {
			var loc2:HatchPetSignal = this.injector.getInstance(HatchPetSignal);
			var loc3:HatchPetVO = new HatchPetVO();
			loc3.itemType = param1.itemType;
			loc3.petSkin = param1.petSkin;
			loc3.petName = param1.petName;
			loc2.dispatch(loc3);
		}
		
		private function onDeletePet(param1:DeletePetMessage) : void {
			var loc2:DeletePetSignal = this.injector.getInstance(DeletePetSignal);
			this.injector.getInstance(PetsModel).deletePet(param1.petID);
			loc2.dispatch(param1.petID);
		}
		
		private function onNewAbility(param1:NewAbilityMessage) : void {
			var loc2:NewAbilitySignal = this.injector.getInstance(NewAbilitySignal);
			loc2.dispatch(param1.type);
		}
		
		private function onPetYardUpdate(param1:PetYard) : void {
			var loc2:UpdatePetYardSignal = StaticInjectorContext.getInjector().getInstance(UpdatePetYardSignal);
			loc2.dispatch(param1.type);
		}
		
		private function onEvolvedPet(param1:EvolvedPetMessage) : void {
			var loc2:EvolvedMessageHandler = this.injector.getInstance(EvolvedMessageHandler);
			loc2.handleMessage(param1);
		}
		
		private function onActivePetUpdate(param1:ActivePet) : void {
			this.updateActivePet.dispatch(param1.instanceID);
			var loc2:String = param1.instanceID > 0?this.petsModel.getPet(param1.instanceID).name:"";
			var loc3:String = param1.instanceID < 0?TextKey.PET_NOT_FOLLOWING:TextKey.PET_FOLLOWING;
			this.addTextLine.dispatch(ChatMessage.make(Parameters.SERVER_CHAT_NAME,loc3,-1,-1,"",false,{"petName":loc2}));
		}
		
		private function unmapMessages() : void {
			var loc1:MessageMap = this.injector.getInstance(MessageMap);
			loc1.unmap(CREATE);
			loc1.unmap(PLAYERSHOOT);
			loc1.unmap(MOVE);
			loc1.unmap(PLAYERTEXT);
			loc1.unmap(UPDATEACK);
			loc1.unmap(INVSWAP);
			loc1.unmap(USEITEM);
			loc1.unmap(HELLO);
			loc1.unmap(INVDROP);
			loc1.unmap(PONG);
			loc1.unmap(LOAD);
			loc1.unmap(SETCONDITION);
			loc1.unmap(TELEPORT);
			loc1.unmap(USEPORTAL);
			loc1.unmap(BUY);
			loc1.unmap(PLAYERHIT);
			loc1.unmap(ENEMYHIT);
			loc1.unmap(AOEACK);
			loc1.unmap(SHOOTACK);
			loc1.unmap(OTHERHIT);
			loc1.unmap(SQUAREHIT);
			loc1.unmap(GOTOACK);
			loc1.unmap(GROUNDDAMAGE);
			loc1.unmap(CHOOSENAME);
			loc1.unmap(CREATEGUILD);
			loc1.unmap(GUILDREMOVE);
			loc1.unmap(GUILDINVITE);
			loc1.unmap(REQUESTTRADE);
			loc1.unmap(CHANGETRADE);
			loc1.unmap(ACCEPTTRADE);
			loc1.unmap(CANCELTRADE);
			loc1.unmap(CHECKCREDITS);
			loc1.unmap(ESCAPE);
			loc1.unmap(QUEST_ROOM_MSG);
			loc1.unmap(JOINGUILD);
			loc1.unmap(CHANGEGUILDRANK);
			loc1.unmap(EDITACCOUNTLIST);
			loc1.unmap(FAILURE);
			loc1.unmap(CREATE_SUCCESS);
			loc1.unmap(SERVERPLAYERSHOOT);
			loc1.unmap(DAMAGE);
			loc1.unmap(UPDATE);
			loc1.unmap(NOTIFICATION);
			loc1.unmap(GLOBAL_NOTIFICATION);
			loc1.unmap(NEWTICK);
			loc1.unmap(SHOWEFFECT);
			loc1.unmap(GOTO);
			loc1.unmap(INVRESULT);
			loc1.unmap(RECONNECT);
			loc1.unmap(PING);
			loc1.unmap(MAPINFO);
			loc1.unmap(PIC);
			loc1.unmap(DEATH);
			loc1.unmap(BUYRESULT);
			loc1.unmap(AOE);
			loc1.unmap(ACCOUNTLIST);
			loc1.unmap(QUESTOBJID);
			loc1.unmap(NAMERESULT);
			loc1.unmap(GUILDRESULT);
			loc1.unmap(ALLYSHOOT);
			loc1.unmap(ENEMYSHOOT);
			loc1.unmap(TRADEREQUESTED);
			loc1.unmap(TRADESTART);
			loc1.unmap(TRADECHANGED);
			loc1.unmap(TRADEDONE);
			loc1.unmap(TRADEACCEPTED);
			loc1.unmap(CLIENTSTAT);
			loc1.unmap(FILE);
			loc1.unmap(INVITEDTOGUILD);
			loc1.unmap(PLAYSOUND);
		}
		
		private function encryptConnection() : void {
			var loc1:ICipher = null;
			var loc2:ICipher = null;
			if(Parameters.ENABLE_ENCRYPTION) {
				loc1 = Crypto.getCipher("rc4",MoreStringUtil.hexStringToByteArray("6a39570cc9de4ec71d64821894c79332b197f92ba85ed281a023".substring(0,26)));
				loc2 = Crypto.getCipher("rc4",MoreStringUtil.hexStringToByteArray("6a39570cc9de4ec71d64821894c79332b197f92ba85ed281a023".substring(26)));
				serverConnection.setOutgoingCipher(loc1);
				serverConnection.setIncomingCipher(loc2);
			}
		}
		
		override public function getNextDamage(param1:uint, param2:uint) : uint {
			return this.rand_.nextIntRange(param1,param2);
		}
		
		override public function enableJitterWatcher() : void {
			if(jitterWatcher_ == null) {
				jitterWatcher_ = new JitterWatcher();
			}
		}
		
		override public function disableJitterWatcher() : void {
			if(jitterWatcher_ != null) {
				jitterWatcher_ = null;
			}
		}
		
		private function create() : void {
			var loc1:CharacterClass = this.classesModel.getSelected();
			var loc2:Create = this.messages.require(CREATE) as Create;
			loc2.classType = loc1.id;
			loc2.skinType = loc1.skins.getSelectedSkin().id;
			serverConnection.sendMessage(loc2);
		}
		
		private function load() : void {
			var loc1:Load = this.messages.require(LOAD) as Load;
			loc1.charId_ = charId_;
			loc1.isFromArena_ = isFromArena_;
			serverConnection.sendMessage(loc1);
			if(isFromArena_) {
				this.openDialog.dispatch(new BattleSummaryDialog());
			}
		}
		
		override public function playerShoot(param1:int, param2:Projectile) : void {
			var loc3:PlayerShoot = this.messages.require(PLAYERSHOOT) as PlayerShoot;
			loc3.time_ = param1;
			loc3.bulletId_ = param2.bulletId_;
			loc3.containerType_ = param2.containerType_;
			loc3.startingPos_.x_ = param2.x_;
			loc3.startingPos_.y_ = param2.y_;
			loc3.angle_ = param2.angle_;
			serverConnection.sendMessage(loc3);
		}
		
		override public function playerHit(param1:int, param2:int) : void {
			var loc3:PlayerHit = this.messages.require(PLAYERHIT) as PlayerHit;
			loc3.bulletId_ = param1;
			loc3.objectId_ = param2;
			serverConnection.sendMessage(loc3);
		}
		
		override public function enemyHit(param1:int, param2:int, param3:int, param4:Boolean) : void {
			var loc5:EnemyHit = this.messages.require(ENEMYHIT) as EnemyHit;
			loc5.time_ = param1;
			loc5.bulletId_ = param2;
			loc5.targetId_ = param3;
			loc5.kill_ = param4;
			serverConnection.sendMessage(loc5);
		}
		
		override public function otherHit(param1:int, param2:int, param3:int, param4:int) : void {
			var loc5:OtherHit = this.messages.require(OTHERHIT) as OtherHit;
			loc5.time_ = param1;
			loc5.bulletId_ = param2;
			loc5.objectId_ = param3;
			loc5.targetId_ = param4;
			serverConnection.sendMessage(loc5);
		}
		
		override public function squareHit(param1:int, param2:int, param3:int) : void {
			var loc4:SquareHit = this.messages.require(SQUAREHIT) as SquareHit;
			loc4.time_ = param1;
			loc4.bulletId_ = param2;
			loc4.objectId_ = param3;
			serverConnection.sendMessage(loc4);
		}
		
		public function aoeAck(param1:int, param2:Number, param3:Number) : void {
			var loc4:AoeAck = this.messages.require(AOEACK) as AoeAck;
			loc4.time_ = param1;
			loc4.position_.x_ = param2;
			loc4.position_.y_ = param3;
			serverConnection.sendMessage(loc4);
		}
		
		override public function groundDamage(param1:int, param2:Number, param3:Number) : void {
			var loc4:GroundDamage = this.messages.require(GROUNDDAMAGE) as GroundDamage;
			loc4.time_ = param1;
			loc4.position_.x_ = param2;
			loc4.position_.y_ = param3;
			serverConnection.sendMessage(loc4);
		}
		
		public function shootAck(param1:int) : void {
			var loc2:ShootAck = this.messages.require(SHOOTACK) as ShootAck;
			loc2.time_ = param1;
			serverConnection.sendMessage(loc2);
		}
		
		override public function playerText(param1:String) : void {
			var loc2:PlayerText = this.messages.require(PLAYERTEXT) as PlayerText;
			loc2.text_ = param1;
			serverConnection.sendMessage(loc2);
		}
		
		override public function invSwap(param1:Player, param2:GameObject, param3:int, param4:int, param5:GameObject, param6:int, param7:int) : Boolean {
			if(!gs_) {
				return false;
			}
			var loc8:InvSwap = this.messages.require(INVSWAP) as InvSwap;
			loc8.time_ = gs_.lastUpdate_;
			loc8.position_.x_ = param1.x_;
			loc8.position_.y_ = param1.y_;
			loc8.slotObject1_.objectId_ = param2.objectId_;
			loc8.slotObject1_.slotId_ = param3;
			loc8.slotObject1_.objectType_ = param4;
			loc8.slotObject2_.objectId_ = param5.objectId_;
			loc8.slotObject2_.slotId_ = param6;
			loc8.slotObject2_.objectType_ = param7;
			serverConnection.sendMessage(loc8);
			var loc9:int = param2.equipment_[param3];
			param2.equipment_[param3] = param5.equipment_[param6];
			param5.equipment_[param6] = loc9;
			SoundEffectLibrary.play("inventory_move_item");
			return true;
		}
		
		override public function invSwapPotion(param1:Player, param2:GameObject, param3:int, param4:int, param5:GameObject, param6:int, param7:int) : Boolean {
			if(!gs_) {
				return false;
			}
			var loc8:InvSwap = this.messages.require(INVSWAP) as InvSwap;
			loc8.time_ = gs_.lastUpdate_;
			loc8.position_.x_ = param1.x_;
			loc8.position_.y_ = param1.y_;
			loc8.slotObject1_.objectId_ = param2.objectId_;
			loc8.slotObject1_.slotId_ = param3;
			loc8.slotObject1_.objectType_ = param4;
			loc8.slotObject2_.objectId_ = param5.objectId_;
			loc8.slotObject2_.slotId_ = param6;
			loc8.slotObject2_.objectType_ = param7;
			param2.equipment_[param3] = ItemConstants.NO_ITEM;
			if(param4 == PotionInventoryModel.HEALTH_POTION_ID) {
				param1.healthPotionCount_++;
			} else if(param4 == PotionInventoryModel.MAGIC_POTION_ID) {
				param1.magicPotionCount_++;
			}
			serverConnection.sendMessage(loc8);
			SoundEffectLibrary.play("inventory_move_item");
			return true;
		}
		
		override public function invDrop(param1:GameObject, param2:int, param3:int) : void {
			var loc4:InvDrop = this.messages.require(INVDROP) as InvDrop;
			loc4.slotObject_.objectId_ = param1.objectId_;
			loc4.slotObject_.slotId_ = param2;
			loc4.slotObject_.objectType_ = param3;
			serverConnection.sendMessage(loc4);
			if(param2 != PotionInventoryModel.HEALTH_POTION_SLOT && param2 != PotionInventoryModel.MAGIC_POTION_SLOT) {
				param1.equipment_[param2] = ItemConstants.NO_ITEM;
			}
		}
		
		override public function useItem(param1:int, param2:int, param3:int, param4:int, param5:Number, param6:Number, param7:int) : void {
			var loc8:UseItem = this.messages.require(USEITEM) as UseItem;
			loc8.time_ = param1;
			loc8.slotObject_.objectId_ = param2;
			loc8.slotObject_.slotId_ = param3;
			loc8.slotObject_.objectType_ = param4;
			loc8.itemUsePos_.x_ = param5;
			loc8.itemUsePos_.y_ = param6;
			loc8.useType_ = param7;
			serverConnection.sendMessage(loc8);
		}
		
		override public function useItem_new(param1:GameObject, param2:int) : Boolean {
			var loc4:XML = null;
			var loc3:int = param1.equipment_[param2];
			if(loc3 >= 36864 && loc3 < 61440) {
				loc4 = ObjectLibrary.xmlLibrary_[36863];
			} else {
				loc4 = ObjectLibrary.xmlLibrary_[loc3];
			}
			if(loc4 && !param1.isPaused() && (loc4.hasOwnProperty("Consumable") || loc4.hasOwnProperty("InvUse"))) {
				if(!this.validStatInc(loc3,param1)) {
					this.addTextLine.dispatch(ChatMessage.make("",loc4.attribute("id") + " not consumed. Already at Max."));
					return false;
				}
				if(isStatPotion(loc3)) {
					this.addTextLine.dispatch(ChatMessage.make("",loc4.attribute("id") + " Consumed ++"));
				}
				this.applyUseItem(param1,param2,loc3,loc4);
				SoundEffectLibrary.play("use_potion");
				return true;
			}
			SoundEffectLibrary.play("error");
			return false;
		}
		
		private function validStatInc(param1:int, param2:GameObject) : Boolean {
			var p:Player = null;
			var itemId:int = param1;
			var itemOwner:GameObject = param2;
			try {
				if(itemOwner is Player) {
					p = itemOwner as Player;
				} else {
					p = this.player;
				}
				if((itemId == 2591 || itemId == 5465 || itemId == 9064 || itemId == 9729) && p.attackMax_ == p.attack_ - p.attackBoost_ || (itemId == 2592 || itemId == 5466 || itemId == 9065 || itemId == 9727) && p.defenseMax_ == p.defense_ - p.defenseBoost_ || (itemId == 2593 || itemId == 5467 || itemId == 9066 || itemId == 9726) && p.speedMax_ == p.speed_ - p.speedBoost_ || (itemId == 2612 || itemId == 5468 || itemId == 9067 || itemId == 9724) && p.vitalityMax_ == p.vitality_ - p.vitalityBoost_ || (itemId == 2613 || itemId == 5469 || itemId == 9068 || itemId == 9725) && p.wisdomMax_ == p.wisdom_ - p.wisdomBoost_ || (itemId == 2636 || itemId == 5470 || itemId == 9069 || itemId == 9728) && p.dexterityMax_ == p.dexterity_ - p.dexterityBoost_ || (itemId == 2793 || itemId == 5471 || itemId == 9070 || itemId == 9731) && p.maxHPMax_ == p.maxHP_ - p.maxHPBoost_ || (itemId == 2794 || itemId == 5472 || itemId == 9071 || itemId == 9730) && p.maxMPMax_ == p.maxMP_ - p.maxMPBoost_) {
					return false;
				}
			}
			catch(err:Error) {
				logger.error("PROBLEM IN STAT INC " + err.getStackTrace());
			}
			return true;
		}
		
		private function applyUseItem(param1:GameObject, param2:int, param3:int, param4:XML) : void {
			var loc5:UseItem = this.messages.require(USEITEM) as UseItem;
			loc5.time_ = getTimer();
			loc5.slotObject_.objectId_ = param1.objectId_;
			loc5.slotObject_.slotId_ = param2;
			loc5.slotObject_.objectType_ = param3;
			loc5.itemUsePos_.x_ = 0;
			loc5.itemUsePos_.y_ = 0;
			serverConnection.sendMessage(loc5);
			if(param4.hasOwnProperty("Consumable")) {
				param1.equipment_[param2] = -1;
			}
		}
		
		override public function setCondition(param1:uint, param2:Number) : void {
			var loc3:SetCondition = this.messages.require(SETCONDITION) as SetCondition;
			loc3.conditionEffect_ = param1;
			loc3.conditionDuration_ = param2;
			serverConnection.sendMessage(loc3);
		}
		
		public function move(param1:int, param2:Player) : void {
			var loc7:int = 0;
			var loc8:int = 0;
			var loc3:Number = -1;
			var loc4:Number = -1;
			if(param2 && !param2.isPaused()) {
				loc3 = param2.x_;
				loc4 = param2.y_;
			}
			var loc5:Move = this.messages.require(MOVE) as Move;
			loc5.tickId_ = param1;
			loc5.time_ = gs_.lastUpdate_;
			loc5.newPosition_.x_ = loc3;
			loc5.newPosition_.y_ = loc4;
			var loc6:int = gs_.moveRecords_.lastClearTime_;
			loc5.records_.length = 0;
			if(loc6 >= 0 && loc5.time_ - loc6 > 125) {
				loc7 = Math.min(10,gs_.moveRecords_.records_.length);
				loc8 = 0;
				while(loc8 < loc7) {
					if(gs_.moveRecords_.records_[loc8].time_ >= loc5.time_ - 25) {
						break;
					}
					loc5.records_.push(gs_.moveRecords_.records_[loc8]);
					loc8++;
				}
			}
			gs_.moveRecords_.clear(loc5.time_);
			serverConnection.sendMessage(loc5);
			param2 && param2.onMove();
		}
		
		override public function teleport(param1:int) : void {
			var loc2:Teleport = this.messages.require(TELEPORT) as Teleport;
			loc2.objectId_ = param1;
			serverConnection.sendMessage(loc2);
		}
		
		override public function usePortal(param1:int) : void {
			var loc2:UsePortal = this.messages.require(USEPORTAL) as UsePortal;
			loc2.objectId_ = param1;
			serverConnection.sendMessage(loc2);
		}
		
		override public function buy(param1:int, param2:int) : void {
			var sObj:SellableObject = null;
			var converted:Boolean = false;
			var sellableObjectId:int = param1;
			var quantity:int = param2;
			if(outstandingBuy_ != null) {
				return;
			}
			sObj = gs_.map.goDict_[sellableObjectId];
			if(sObj == null) {
				return;
			}
			converted = false;
			if(sObj.currency_ == Currency.GOLD) {
				converted = gs_.model.getConverted() || this.player.credits_ > 100 || sObj.price_ > this.player.credits_;
			}
			if(sObj.soldObjectName() == TextKey.VAULT_CHEST) {
				this.openDialog.dispatch(new PurchaseConfirmationDialog(function():void {
					buyConfirmation(sObj,converted,sellableObjectId,quantity);
				}));
			} else {
				this.buyConfirmation(sObj,converted,sellableObjectId,quantity);
			}
		}
		
		private function buyConfirmation(param1:SellableObject, param2:Boolean, param3:int, param4:int) : void {
			outstandingBuy_ = new OutstandingBuy(param1.soldObjectInternalName(),param1.price_,param1.currency_,param2);
			var loc5:Buy = this.messages.require(BUY) as Buy;
			loc5.objectId_ = param3;
			loc5.quantity_ = param4;
			serverConnection.sendMessage(loc5);
		}
		
		public function gotoAck(param1:int) : void {
			var loc2:GotoAck = this.messages.require(GOTOACK) as GotoAck;
			loc2.time_ = param1;
			serverConnection.sendMessage(loc2);
		}
		
		override public function editAccountList(param1:int, param2:Boolean, param3:int) : void {
			var loc4:EditAccountList = this.messages.require(EDITACCOUNTLIST) as EditAccountList;
			loc4.accountListId_ = param1;
			loc4.add_ = param2;
			loc4.objectId_ = param3;
			serverConnection.sendMessage(loc4);
		}
		
		override public function chooseName(param1:String) : void {
			var loc2:ChooseName = this.messages.require(CHOOSENAME) as ChooseName;
			loc2.name_ = param1;
			serverConnection.sendMessage(loc2);
		}
		
		override public function createGuild(param1:String) : void {
			var loc2:CreateGuild = this.messages.require(CREATEGUILD) as CreateGuild;
			loc2.name_ = param1;
			serverConnection.sendMessage(loc2);
		}
		
		override public function guildRemove(param1:String) : void {
			var loc2:GuildRemove = this.messages.require(GUILDREMOVE) as GuildRemove;
			loc2.name_ = param1;
			serverConnection.sendMessage(loc2);
		}
		
		override public function guildInvite(param1:String) : void {
			var loc2:GuildInvite = this.messages.require(GUILDINVITE) as GuildInvite;
			loc2.name_ = param1;
			serverConnection.sendMessage(loc2);
		}
		
		override public function requestTrade(param1:String) : void {
			var loc2:RequestTrade = this.messages.require(REQUESTTRADE) as RequestTrade;
			loc2.name_ = param1;
			serverConnection.sendMessage(loc2);
		}
		
		override public function changeTrade(param1:Vector.<Boolean>) : void {
			var loc2:ChangeTrade = this.messages.require(CHANGETRADE) as ChangeTrade;
			loc2.offer_ = param1;
			serverConnection.sendMessage(loc2);
		}
		
		override public function acceptTrade(param1:Vector.<Boolean>, param2:Vector.<Boolean>) : void {
			var loc3:AcceptTrade = this.messages.require(ACCEPTTRADE) as AcceptTrade;
			loc3.myOffer_ = param1;
			loc3.yourOffer_ = param2;
			serverConnection.sendMessage(loc3);
		}
		
		override public function cancelTrade() : void {
			serverConnection.sendMessage(this.messages.require(CANCELTRADE));
		}
		
		override public function checkCredits() : void {
			serverConnection.sendMessage(this.messages.require(CHECKCREDITS));
		}
		
		override public function escape() : void {
			if(this.playerId_ == -1) {
				return;
			}
			if(gs_.map && gs_.map.name_ == "Arena") {
				serverConnection.sendMessage(this.messages.require(ACCEPT_ARENA_DEATH));
			} else {
				serverConnection.sendMessage(this.messages.require(ESCAPE));
				this.showHideKeyUISignal.dispatch(false);
			}
		}
		
		override public function gotoQuestRoom() : void {
			serverConnection.sendMessage(this.messages.require(QUEST_ROOM_MSG));
		}
		
		override public function joinGuild(param1:String) : void {
			var loc2:JoinGuild = this.messages.require(JOINGUILD) as JoinGuild;
			loc2.guildName_ = param1;
			serverConnection.sendMessage(loc2);
		}
		
		override public function changeGuildRank(param1:String, param2:int) : void {
			var loc3:ChangeGuildRank = this.messages.require(CHANGEGUILDRANK) as ChangeGuildRank;
			loc3.name_ = param1;
			loc3.guildRank_ = param2;
			serverConnection.sendMessage(loc3);
		}
		
		override public function changePetSkin(param1:int, param2:int, param3:int) : void {
			var loc4:ChangePetSkin = this.messages.require(PET_CHANGE_SKIN_MSG) as ChangePetSkin;
			loc4.petId = param1;
			loc4.skinType = param2;
			loc4.currency = param3;
			serverConnection.sendMessage(loc4);
		}
		
		private function rsaEncrypt(param1:String) : String {
			var loc2:RSAKey = PEM.readRSAPublicKey(Parameters.RSA_PUBLIC_KEY);
			var loc3:ByteArray = new ByteArray();
			loc3.writeUTFBytes(param1);
			var loc4:ByteArray = new ByteArray();
			loc2.encrypt(loc3,loc4,loc3.length);
			return Base64.encodeByteArray(loc4);
		}
		
		private function onConnected() : void {
			var loc1:Account = StaticInjectorContext.getInjector().getInstance(Account);
			this.addTextLine.dispatch(ChatMessage.make(Parameters.CLIENT_CHAT_NAME,TextKey.CHAT_CONNECTED));
			this.encryptConnection();
			var loc2:Hello = this.messages.require(HELLO) as Hello;
			loc2.buildVersion_ = Parameters.BUILD_VERSION + "." + Parameters.MINOR_VERSION;
			loc2.gameId_ = gameId_;
			loc2.guid_ = this.rsaEncrypt(loc1.getUserId());
			loc2.password_ = this.rsaEncrypt(loc1.getPassword());
			loc2.secret_ = this.rsaEncrypt(loc1.getSecret());
			loc2.keyTime_ = keyTime_;
			loc2.key_.length = 0;
			key_ != null && loc2.key_.writeBytes(key_);
			loc2.mapJSON_ = mapJSON_ == null?"":mapJSON_;
			loc2.entrytag_ = loc1.getEntryTag();
			loc2.gameNet = loc1.gameNetwork();
			loc2.gameNetUserId = loc1.gameNetworkUserId();
			loc2.playPlatform = loc1.playPlatform();
			loc2.platformToken = loc1.getPlatformToken();
			loc2.userToken = loc1.getToken();
			serverConnection.sendMessage(loc2);
		}
		
		private function onCreateSuccess(param1:CreateSuccess) : void {
			this.playerId_ = param1.objectId_;
			charId_ = param1.charId_;
			gs_.initialize();
			createCharacter_ = false;
		}
		
		private function onDamage(param1:Damage) : void {
			var loc5:int = 0;
			var loc6:* = false;
			var loc2:AbstractMap = gs_.map;
			var loc3:Projectile = null;
			if(param1.objectId_ >= 0 && param1.bulletId_ > 0) {
				loc5 = Projectile.findObjId(param1.objectId_,param1.bulletId_);
				loc3 = loc2.boDict_[loc5] as Projectile;
				if(loc3 != null && !loc3.projProps_.multiHit_) {
					loc2.removeObj(loc5);
				}
			}
			var loc4:GameObject = loc2.goDict_[param1.targetId_];
			if(loc4 != null) {
				loc6 = param1.objectId_ == this.player.objectId_;
				loc4.damage(loc6,param1.damageAmount_,param1.effects_,param1.kill_,loc3,param1.armorPierce_);
			}
		}
		
		private function onServerPlayerShoot(param1:ServerPlayerShoot) : void {
			var loc2:* = param1.ownerId_ == this.playerId_;
			var loc3:GameObject = gs_.map.goDict_[param1.ownerId_];
			if(loc3 == null || loc3.dead_) {
				if(loc2) {
					this.shootAck(-1);
				}
				return;
			}
			if(loc3.objectId_ != this.playerId_ && Parameters.data_.disableAllyShoot) {
				return;
			}
			var loc4:Projectile = FreeList.newObject(Projectile) as Projectile;
			var loc5:Player = loc3 as Player;
			if(loc5 != null) {
				loc4.reset(param1.containerType_,0,param1.ownerId_,param1.bulletId_,param1.angle_,gs_.lastUpdate_,loc5.projectileIdSetOverrideNew,loc5.projectileIdSetOverrideOld);
			} else {
				loc4.reset(param1.containerType_,0,param1.ownerId_,param1.bulletId_,param1.angle_,gs_.lastUpdate_);
			}
			loc4.setDamage(param1.damage_);
			gs_.map.addObj(loc4,param1.startingPos_.x_,param1.startingPos_.y_);
			if(loc2) {
				this.shootAck(gs_.lastUpdate_);
			}
		}
		
		private function onAllyShoot(param1:AllyShoot) : void {
			var loc2:GameObject = gs_.map.goDict_[param1.ownerId_];
			if(loc2 == null || loc2.dead_) {
				return;
			}
			if(Parameters.data_.disableAllyShoot == 1) {
				return;
			}
			loc2.setAttack(param1.containerType_,param1.angle_);
			if(Parameters.data_.disableAllyShoot == 2) {
				return;
			}
			var loc3:Projectile = FreeList.newObject(Projectile) as Projectile;
			var loc4:Player = loc2 as Player;
			if(loc4 != null) {
				loc3.reset(param1.containerType_,0,param1.ownerId_,param1.bulletId_,param1.angle_,gs_.lastUpdate_,loc4.projectileIdSetOverrideNew,loc4.projectileIdSetOverrideOld);
			} else {
				loc3.reset(param1.containerType_,0,param1.ownerId_,param1.bulletId_,param1.angle_,gs_.lastUpdate_);
			}
			gs_.map.addObj(loc3,loc2.x_,loc2.y_);
		}
		
		private function onReskinUnlock(param1:ReskinUnlock) : void {
			var loc2:* = null;
			var loc3:CharacterSkin = null;
			var loc4:PetsModel = null;
			if(param1.isPetSkin == 0) {
				for(loc2 in this.model.player.lockedSlot) {
					if(this.model.player.lockedSlot[loc2] == param1.skinID) {
						this.model.player.lockedSlot[loc2] = 0;
					}
				}
				loc3 = this.classesModel.getCharacterClass(this.model.player.objectType_).skins.getSkin(param1.skinID);
				loc3.setState(CharacterSkinState.OWNED);
			} else {
				loc4 = StaticInjectorContext.getInjector().getInstance(PetsModel);
				loc4.unlockSkin(param1.skinID);
			}
		}
		
		private function onEnemyShoot(param1:EnemyShoot) : void {
			var loc4:Projectile = null;
			var loc5:Number = NaN;
			var loc2:GameObject = gs_.map.goDict_[param1.ownerId_];
			if(loc2 == null || loc2.dead_) {
				this.shootAck(-1);
				return;
			}
			var loc3:int = 0;
			while(loc3 < param1.numShots_) {
				loc4 = FreeList.newObject(Projectile) as Projectile;
				loc5 = param1.angle_ + param1.angleInc_ * loc3;
				loc4.reset(loc2.objectType_,param1.bulletType_,param1.ownerId_,(param1.bulletId_ + loc3) % 256,loc5,gs_.lastUpdate_);
				loc4.setDamage(param1.damage_);
				gs_.map.addObj(loc4,param1.startingPos_.x_,param1.startingPos_.y_);
				loc3++;
			}
			this.shootAck(gs_.lastUpdate_);
			loc2.setAttack(loc2.objectType_,param1.angle_ + param1.angleInc_ * ((param1.numShots_ - 1) / 2));
		}
		
		private function onTradeRequested(param1:TradeRequested) : void {
			if(!Parameters.data_.chatTrade) {
				return;
			}
			if(Parameters.data_.tradeWithFriends && !this.socialModel.isMyFriend(param1.name_)) {
				return;
			}
			if(Parameters.data_.showTradePopup) {
				gs_.hudView.interactPanel.setOverride(new TradeRequestPanel(gs_,param1.name_));
			}
			this.addTextLine.dispatch(ChatMessage.make("",param1.name_ + " wants to " + "trade with you.  Type \"/trade " + param1.name_ + "\" to trade."));
		}
		
		private function onTradeStart(param1:TradeStart) : void {
			gs_.hudView.startTrade(gs_,param1);
		}
		
		private function onTradeChanged(param1:TradeChanged) : void {
			gs_.hudView.tradeChanged(param1);
		}
		
		private function onTradeDone(param1:TradeDone) : void {
			var loc3:Object = null;
			var loc4:Object = null;
			gs_.hudView.tradeDone();
			var loc2:String = "";
			try {
				loc4 = JSON.parse(param1.description_);
				loc2 = loc4.key;
				loc3 = loc4.tokens;
			}
			catch(e:Error) {
			}
			this.addTextLine.dispatch(ChatMessage.make(Parameters.SERVER_CHAT_NAME,loc2,-1,-1,"",false,loc3));
		}
		
		private function onTradeAccepted(param1:TradeAccepted) : void {
			gs_.hudView.tradeAccepted(param1);
		}
		
		private function addObject(param1:ObjectData) : void {
			var loc2:AbstractMap = gs_.map;
			var loc3:GameObject = ObjectLibrary.getObjectFromType(param1.objectType_);
			if(loc3 == null) {
				return;
			}
			var loc4:ObjectStatusData = param1.status_;
			loc3.setObjectId(loc4.objectId_);
			loc2.addObj(loc3,loc4.pos_.x_,loc4.pos_.y_);
			if(loc3 is Player) {
				this.handleNewPlayer(loc3 as Player,loc2);
			}
			this.processObjectStatus(loc4,0,-1);
			if(loc3.props_.static_ && loc3.props_.occupySquare_ && !loc3.props_.noMiniMap_) {
				this.updateGameObjectTileSignal.dispatch(new UpdateGameObjectTileVO(loc3.x_,loc3.y_,loc3));
			}
		}
		
		private function handleNewPlayer(param1:Player, param2:AbstractMap) : void {
			this.setPlayerSkinTemplate(param1,0);
			if(param1.objectId_ == this.playerId_) {
				this.player = param1;
				this.model.player = param1;
				param2.player_ = param1;
				gs_.setFocus(param1);
				this.setGameFocus.dispatch(this.playerId_.toString());
			}
		}
		
		private function onUpdate(param1:Update) : void {
			var loc3:int = 0;
			var loc4:GroundTileData = null;
			var loc2:Message = this.messages.require(UPDATEACK);
			serverConnection.sendMessage(loc2);
			loc3 = 0;
			while(loc3 < param1.tiles_.length) {
				loc4 = param1.tiles_[loc3];
				gs_.map.setGroundTile(loc4.x_,loc4.y_,loc4.type_);
				this.updateGroundTileSignal.dispatch(new UpdateGroundTileVO(loc4.x_,loc4.y_,loc4.type_));
				loc3++;
			}
			loc3 = 0;
			while(loc3 < param1.newObjs_.length) {
				this.addObject(param1.newObjs_[loc3]);
				loc3++;
			}
			loc3 = 0;
			while(loc3 < param1.drops_.length) {
				gs_.map.removeObj(param1.drops_[loc3]);
				loc3++;
			}
		}
		
		private function onNotification(param1:Notification) : void {
			var loc3:LineBuilder = null;
			var loc2:GameObject = gs_.map.goDict_[param1.objectId_];
			if(loc2 != null) {
				loc3 = LineBuilder.fromJSON(param1.message);
				if(loc2 == this.player) {
					if(loc3.key == "server.quest_complete") {
						gs_.map.quest_.completed();
					}
					this.makeNotification(loc3,loc2,param1.color_,1000);
				} else if(loc2.props_.isEnemy_ || !Parameters.data_.noAllyNotifications) {
					this.makeNotification(loc3,loc2,param1.color_,1000);
				}
			}
		}
		
		private function makeNotification(param1:LineBuilder, param2:GameObject, param3:uint, param4:int) : void {
			var loc5:CharacterStatusText = new CharacterStatusText(param2,param3,param4);
			loc5.setStringBuilder(param1);
			gs_.map.mapOverlay_.addStatusText(loc5);
		}
		
		private function onGlobalNotification(param1:GlobalNotification) : void {
			switch(param1.text) {
				case "yellow":
					ShowKeySignal.instance.dispatch(Key.YELLOW);
					break;
				case "red":
					ShowKeySignal.instance.dispatch(Key.RED);
					break;
				case "green":
					ShowKeySignal.instance.dispatch(Key.GREEN);
					break;
				case "purple":
					ShowKeySignal.instance.dispatch(Key.PURPLE);
					break;
				case "showKeyUI":
					this.showHideKeyUISignal.dispatch(false);
					break;
				case "giftChestOccupied":
					this.giftChestUpdateSignal.dispatch(GiftStatusUpdateSignal.HAS_GIFT);
					break;
				case "giftChestEmpty":
					this.giftChestUpdateSignal.dispatch(GiftStatusUpdateSignal.HAS_NO_GIFT);
					break;
				case "beginnersPackage":
			}
		}
		
		private function onNewTick(param1:NewTick) : void {
			var loc2:ObjectStatusData = null;
			if(jitterWatcher_ != null) {
				jitterWatcher_.record();
			}
			this.move(param1.tickId_,this.player);
			for each(loc2 in param1.statuses_) {
				this.processObjectStatus(loc2,param1.tickTime_,param1.tickId_);
			}
			lastTickId_ = param1.tickId_;
		}
		
		private function canShowEffect(param1:GameObject) : Boolean {
			if(param1 != null) {
				return true;
			}
			var loc2:* = param1.objectId_ == this.playerId_;
			if(!loc2 && param1.props_.isPlayer_ && Parameters.data_.disableAllyShoot) {
				return false;
			}
			return true;
		}
		
		private function onShowEffect(param1:ShowEffect) : void {
			var loc3:GameObject = null;
			var loc4:ParticleEffect = null;
			var loc5:Point = null;
			var loc6:uint = 0;
			if(Parameters.data_.noParticlesMaster && (param1.effectType_ == ShowEffect.HEAL_EFFECT_TYPE || param1.effectType_ == ShowEffect.TELEPORT_EFFECT_TYPE || param1.effectType_ == ShowEffect.STREAM_EFFECT_TYPE || param1.effectType_ == ShowEffect.POISON_EFFECT_TYPE || param1.effectType_ == ShowEffect.LINE_EFFECT_TYPE || param1.effectType_ == ShowEffect.FLOW_EFFECT_TYPE || param1.effectType_ == ShowEffect.COLLAPSE_EFFECT_TYPE || param1.effectType_ == ShowEffect.CONEBLAST_EFFECT_TYPE || param1.effectType_ == ShowEffect.NOVA_NO_AOE_EFFECT_TYPE)) {
				return;
			}
			var loc2:AbstractMap = gs_.map;
			switch(param1.effectType_) {
				case ShowEffect.HEAL_EFFECT_TYPE:
					loc3 = loc2.goDict_[param1.targetObjectId_];
					if(loc3 == null || !this.canShowEffect(loc3)) {
						break;
					}
					loc2.addObj(new HealEffect(loc3,param1.color_),loc3.x_,loc3.y_);
					break;
				case ShowEffect.TELEPORT_EFFECT_TYPE:
					loc2.addObj(new TeleportEffect(),param1.pos1_.x_,param1.pos1_.y_);
					break;
				case ShowEffect.STREAM_EFFECT_TYPE:
					loc4 = new StreamEffect(param1.pos1_,param1.pos2_,param1.color_);
					loc2.addObj(loc4,param1.pos1_.x_,param1.pos1_.y_);
					break;
				case ShowEffect.THROW_EFFECT_TYPE:
					loc3 = loc2.goDict_[param1.targetObjectId_];
					loc5 = loc3 != null?new Point(loc3.x_,loc3.y_):param1.pos2_.toPoint();
					if(loc3 != null && !this.canShowEffect(loc3)) {
						break;
					}
					loc4 = new ThrowEffect(loc5,param1.pos1_.toPoint(),param1.color_,param1.duration_ * 1000);
					loc2.addObj(loc4,loc5.x,loc5.y);
					break;
				case ShowEffect.NOVA_EFFECT_TYPE:
				case ShowEffect.NOVA_NO_AOE_EFFECT_TYPE:
					loc3 = loc2.goDict_[param1.targetObjectId_];
					if(loc3 == null || !this.canShowEffect(loc3)) {
						break;
					}
					loc4 = new NovaEffect(loc3,param1.pos1_.x_,param1.color_);
					loc2.addObj(loc4,loc3.x_,loc3.y_);
					break;
				case ShowEffect.POISON_EFFECT_TYPE:
					loc3 = loc2.goDict_[param1.targetObjectId_];
					if(loc3 == null || !this.canShowEffect(loc3)) {
						break;
					}
					loc4 = new PoisonEffect(loc3,param1.color_);
					loc2.addObj(loc4,loc3.x_,loc3.y_);
					break;
				case ShowEffect.LINE_EFFECT_TYPE:
					loc3 = loc2.goDict_[param1.targetObjectId_];
					if(loc3 == null || !this.canShowEffect(loc3)) {
						break;
					}
					loc4 = new LineEffect(loc3,param1.pos1_,param1.color_);
					loc2.addObj(loc4,param1.pos1_.x_,param1.pos1_.y_);
					break;
				case ShowEffect.BURST_EFFECT_TYPE:
					loc3 = loc2.goDict_[param1.targetObjectId_];
					if(loc3 == null || !this.canShowEffect(loc3)) {
						break;
					}
					loc4 = new BurstEffect(loc3,param1.pos1_,param1.pos2_,param1.color_);
					loc2.addObj(loc4,param1.pos1_.x_,param1.pos1_.y_);
					break;
				case ShowEffect.FLOW_EFFECT_TYPE:
					loc3 = loc2.goDict_[param1.targetObjectId_];
					if(loc3 == null || !this.canShowEffect(loc3)) {
						break;
					}
					loc4 = new FlowEffect(param1.pos1_,loc3,param1.color_);
					loc2.addObj(loc4,param1.pos1_.x_,param1.pos1_.y_);
					break;
				case ShowEffect.RING_EFFECT_TYPE:
					loc3 = loc2.goDict_[param1.targetObjectId_];
					if(loc3 == null || !this.canShowEffect(loc3)) {
						break;
					}
					loc4 = new RingEffect(loc3,param1.pos1_.x_,param1.color_);
					loc2.addObj(loc4,loc3.x_,loc3.y_);
					break;
				case ShowEffect.LIGHTNING_EFFECT_TYPE:
					loc3 = loc2.goDict_[param1.targetObjectId_];
					if(loc3 == null || !this.canShowEffect(loc3)) {
						break;
					}
					loc4 = new LightningEffect(loc3,param1.pos1_,param1.color_,param1.pos2_.x_);
					loc2.addObj(loc4,loc3.x_,loc3.y_);
					break;
				case ShowEffect.COLLAPSE_EFFECT_TYPE:
					loc3 = loc2.goDict_[param1.targetObjectId_];
					if(loc3 == null || !this.canShowEffect(loc3)) {
						break;
					}
					loc4 = new CollapseEffect(loc3,param1.pos1_,param1.pos2_,param1.color_);
					loc2.addObj(loc4,param1.pos1_.x_,param1.pos1_.y_);
					break;
				case ShowEffect.CONEBLAST_EFFECT_TYPE:
					loc3 = loc2.goDict_[param1.targetObjectId_];
					if(loc3 == null || !this.canShowEffect(loc3)) {
						break;
					}
					loc4 = new ConeBlastEffect(loc3,param1.pos1_,param1.pos2_.x_,param1.color_);
					loc2.addObj(loc4,loc3.x_,loc3.y_);
					break;
				case ShowEffect.JITTER_EFFECT_TYPE:
					gs_.camera_.startJitter();
					break;
				case ShowEffect.FLASH_EFFECT_TYPE:
					loc3 = loc2.goDict_[param1.targetObjectId_];
					if(loc3 == null || !this.canShowEffect(loc3)) {
						break;
					}
					loc3.flash_ = new FlashDescription(getTimer(),param1.color_,param1.pos1_.x_,param1.pos1_.y_);
					break;
				case ShowEffect.THROW_PROJECTILE_EFFECT_TYPE:
					loc5 = param1.pos1_.toPoint();
					if(loc3 != null && !this.canShowEffect(loc3)) {
						break;
					}
					loc4 = new ThrowProjectileEffect(param1.color_,param1.pos2_.toPoint(),param1.pos1_.toPoint(),param1.duration_ * 1000);
					loc2.addObj(loc4,loc5.x,loc5.y);
					break;
				case ShowEffect.SHOCKER_EFFECT_TYPE:
					loc3 = loc2.goDict_[param1.targetObjectId_];
					if(loc3 == null || !this.canShowEffect(loc3)) {
						break;
					}
					if(loc3 && loc3.shockEffect) {
						loc3.shockEffect.destroy();
					}
					loc4 = new ShockerEffect(loc3);
					loc3.shockEffect = ShockerEffect(loc4);
					gs_.map.addObj(loc4,loc3.x_,loc3.y_);
					break;
				case ShowEffect.SHOCKEE_EFFECT_TYPE:
					loc3 = loc2.goDict_[param1.targetObjectId_];
					if(loc3 == null || !this.canShowEffect(loc3)) {
						break;
					}
					loc4 = new ShockeeEffect(loc3);
					gs_.map.addObj(loc4,loc3.x_,loc3.y_);
					break;
				case ShowEffect.RISING_FURY_EFFECT_TYPE:
					loc3 = loc2.goDict_[param1.targetObjectId_];
					if(loc3 == null || !this.canShowEffect(loc3)) {
						break;
					}
					loc6 = param1.pos1_.x_ * 1000;
					loc4 = new RisingFuryEffect(loc3,loc6);
					gs_.map.addObj(loc4,loc3.x_,loc3.y_);
					break;
			}
		}
		
		private function onGoto(param1:Goto) : void {
			this.gotoAck(gs_.lastUpdate_);
			var loc2:GameObject = gs_.map.goDict_[param1.objectId_];
			if(loc2 == null) {
				return;
			}
			loc2.onGoto(param1.pos_.x_,param1.pos_.y_,gs_.lastUpdate_);
		}
		
		private function updateGameObject(param1:GameObject, param2:Vector.<StatData>, param3:Boolean) : void {
			var loc7:StatData = null;
			var loc8:int = 0;
			var loc9:int = 0;
			var loc10:int = 0;
			var loc4:Player = param1 as Player;
			var loc5:Merchant = param1 as Merchant;
			var loc6:Pet = param1 as Pet;
			if(loc6) {
				this.petUpdater.updatePet(loc6,param2);
				if(gs_.map.isPetYard) {
					this.petUpdater.updatePetVOs(loc6,param2);
				}
				return;
			}
			for each(loc7 in param2) {
				loc8 = loc7.statValue_;
				switch(loc7.statType_) {
					case StatData.MAX_HP_STAT:
						param1.maxHP_ = loc8;
						continue;
					case StatData.HP_STAT:
						param1.hp_ = loc8;
						if(param1.dead_ && loc8 > 1 && param1.props_.isEnemy_ && ++param1.deadCounter_ >= 2) {
							param1.dead_ = false;
						}
						continue;
					case StatData.SIZE_STAT:
						param1.size_ = loc8;
						continue;
					case StatData.MAX_MP_STAT:
						loc4.maxMP_ = loc8;
						continue;
					case StatData.MP_STAT:
						loc4.mp_ = loc8;
						continue;
					case StatData.NEXT_LEVEL_EXP_STAT:
						loc4.nextLevelExp_ = loc8;
						continue;
					case StatData.EXP_STAT:
						loc4.exp_ = loc8;
						continue;
					case StatData.LEVEL_STAT:
						param1.level_ = loc8;
						continue;
					case StatData.ATTACK_STAT:
						loc4.attack_ = loc8;
						continue;
					case StatData.DEFENSE_STAT:
						param1.defense_ = loc8;
						continue;
					case StatData.SPEED_STAT:
						loc4.speed_ = loc8;
						continue;
					case StatData.DEXTERITY_STAT:
						loc4.dexterity_ = loc8;
						continue;
					case StatData.VITALITY_STAT:
						loc4.vitality_ = loc8;
						continue;
					case StatData.WISDOM_STAT:
						loc4.wisdom_ = loc8;
						continue;
					case StatData.CONDITION_STAT:
						param1.condition_[ConditionEffect.CE_FIRST_BATCH] = loc8;
						continue;
					case StatData.INVENTORY_0_STAT:
					case StatData.INVENTORY_1_STAT:
					case StatData.INVENTORY_2_STAT:
					case StatData.INVENTORY_3_STAT:
					case StatData.INVENTORY_4_STAT:
					case StatData.INVENTORY_5_STAT:
					case StatData.INVENTORY_6_STAT:
					case StatData.INVENTORY_7_STAT:
					case StatData.INVENTORY_8_STAT:
					case StatData.INVENTORY_9_STAT:
					case StatData.INVENTORY_10_STAT:
					case StatData.INVENTORY_11_STAT:
						loc9 = loc7.statType_ - StatData.INVENTORY_0_STAT;
						if(loc8 != -1) {
							param1.lockedSlot[loc9] = 0;
						}
						param1.equipment_[loc9] = loc8;
						continue;
					case StatData.NUM_STARS_STAT:
						loc4.numStars_ = loc8;
						continue;
					case StatData.NAME_STAT:
						if(param1.name_ != loc7.strStatValue_) {
							param1.name_ = loc7.strStatValue_;
							param1.nameBitmapData_ = null;
						}
						continue;
					case StatData.TEX1_STAT:
						loc8 >= 0 && param1.setTex1(loc8);
						continue;
					case StatData.TEX2_STAT:
						loc8 >= 0 && param1.setTex2(loc8);
						continue;
					case StatData.MERCHANDISE_TYPE_STAT:
						loc5.setMerchandiseType(loc8);
						continue;
					case StatData.CREDITS_STAT:
						loc4.setCredits(loc8);
						continue;
					case StatData.MERCHANDISE_PRICE_STAT:
						(param1 as SellableObject).setPrice(loc8);
						continue;
					case StatData.ACTIVE_STAT:
						(param1 as Portal).active_ = loc8 != 0;
						continue;
					case StatData.ACCOUNT_ID_STAT:
						loc4.accountId_ = loc7.strStatValue_;
						continue;
					case StatData.FAME_STAT:
						loc4.setFame(loc8);
						continue;
					case StatData.FORTUNE_TOKEN_STAT:
						loc4.setTokens(loc8);
						continue;
					case StatData.SUPPORTER_POINTS_STAT:
						if(loc4 != null) {
							loc4.supporterPoints = loc8;
							loc4.clearTextureCache();
							if(loc4.objectId_ == this.playerId_) {
								StaticInjectorContext.getInjector().getInstance(SupporterCampaignModel).updatePoints(loc8);
							}
						}
						continue;
					case StatData.SUPPORTER_STAT:
						if(loc4 != null) {
							loc4.setSupporterFlag(loc8);
						}
						continue;
					case StatData.MERCHANDISE_CURRENCY_STAT:
						(param1 as SellableObject).setCurrency(loc8);
						continue;
					case StatData.CONNECT_STAT:
						param1.connectType_ = loc8;
						continue;
					case StatData.MERCHANDISE_COUNT_STAT:
						loc5.count_ = loc8;
						loc5.untilNextMessage_ = 0;
						continue;
					case StatData.MERCHANDISE_MINS_LEFT_STAT:
						loc5.minsLeft_ = loc8;
						loc5.untilNextMessage_ = 0;
						continue;
					case StatData.MERCHANDISE_DISCOUNT_STAT:
						loc5.discount_ = loc8;
						loc5.untilNextMessage_ = 0;
						continue;
					case StatData.MERCHANDISE_RANK_REQ_STAT:
						(param1 as SellableObject).setRankReq(loc8);
						continue;
					case StatData.MAX_HP_BOOST_STAT:
						loc4.maxHPBoost_ = loc8;
						continue;
					case StatData.MAX_MP_BOOST_STAT:
						loc4.maxMPBoost_ = loc8;
						continue;
					case StatData.ATTACK_BOOST_STAT:
						loc4.attackBoost_ = loc8;
						continue;
					case StatData.DEFENSE_BOOST_STAT:
						loc4.defenseBoost_ = loc8;
						continue;
					case StatData.SPEED_BOOST_STAT:
						loc4.speedBoost_ = loc8;
						continue;
					case StatData.VITALITY_BOOST_STAT:
						loc4.vitalityBoost_ = loc8;
						continue;
					case StatData.WISDOM_BOOST_STAT:
						loc4.wisdomBoost_ = loc8;
						continue;
					case StatData.DEXTERITY_BOOST_STAT:
						loc4.dexterityBoost_ = loc8;
						continue;
					case StatData.OWNER_ACCOUNT_ID_STAT:
						(param1 as Container).setOwnerId(loc7.strStatValue_);
						continue;
					case StatData.RANK_REQUIRED_STAT:
						(param1 as NameChanger).setRankRequired(loc8);
						continue;
					case StatData.NAME_CHOSEN_STAT:
						loc4.nameChosen_ = loc8 != 0;
						param1.nameBitmapData_ = null;
						continue;
					case StatData.CURR_FAME_STAT:
						loc4.currFame_ = loc8;
						continue;
					case StatData.NEXT_CLASS_QUEST_FAME_STAT:
						loc4.nextClassQuestFame_ = loc8;
						continue;
					case StatData.LEGENDARY_RANK_STAT:
						loc4.legendaryRank_ = loc8;
						continue;
					case StatData.SINK_LEVEL_STAT:
						if(!param3) {
							loc4.sinkLevel_ = loc8;
						}
						continue;
					case StatData.ALT_TEXTURE_STAT:
						param1.setAltTexture(loc8);
						continue;
					case StatData.GUILD_NAME_STAT:
						loc4.setGuildName(loc7.strStatValue_);
						continue;
					case StatData.GUILD_RANK_STAT:
						loc4.guildRank_ = loc8;
						continue;
					case StatData.BREATH_STAT:
						loc4.breath_ = loc8;
						continue;
					case StatData.XP_BOOSTED_STAT:
						loc4.xpBoost_ = loc8;
						continue;
					case StatData.XP_TIMER_STAT:
						loc4.xpTimer = loc8 * TO_MILLISECONDS;
						continue;
					case StatData.LD_TIMER_STAT:
						loc4.dropBoost = loc8 * TO_MILLISECONDS;
						continue;
					case StatData.LT_TIMER_STAT:
						loc4.tierBoost = loc8 * TO_MILLISECONDS;
						continue;
					case StatData.HEALTH_POTION_STACK_STAT:
						loc4.healthPotionCount_ = loc8;
						continue;
					case StatData.MAGIC_POTION_STACK_STAT:
						loc4.magicPotionCount_ = loc8;
						continue;
					case StatData.TEXTURE_STAT:
						if(loc4 != null) {
							loc4.skinId != loc8 && loc8 >= 0 && this.setPlayerSkinTemplate(loc4,loc8);
						} else if(param1.objectType_ == 1813 && loc8 > 0) {
							param1.setTexture(loc8);
						}
						continue;
					case StatData.HASBACKPACK_STAT:
						(param1 as Player).hasBackpack_ = Boolean(loc8);
						if(param3) {
							this.updateBackpackTab.dispatch(Boolean(loc8));
						}
						continue;
					case StatData.BACKPACK_0_STAT:
					case StatData.BACKPACK_1_STAT:
					case StatData.BACKPACK_2_STAT:
					case StatData.BACKPACK_3_STAT:
					case StatData.BACKPACK_4_STAT:
					case StatData.BACKPACK_5_STAT:
					case StatData.BACKPACK_6_STAT:
					case StatData.BACKPACK_7_STAT:
						loc10 = loc7.statType_ - StatData.BACKPACK_0_STAT + GeneralConstants.NUM_EQUIPMENT_SLOTS + GeneralConstants.NUM_INVENTORY_SLOTS;
						(param1 as Player).equipment_[loc10] = loc8;
						continue;
					case StatData.NEW_CON_STAT:
						param1.condition_[ConditionEffect.CE_SECOND_BATCH] = loc8;
						continue;
					default:
						continue;
				}
			}
		}
		
		private function setPlayerSkinTemplate(param1:Player, param2:int) : void {
			var loc3:Reskin = this.messages.require(RESKIN) as Reskin;
			loc3.skinID = param2;
			loc3.player = param1;
			loc3.consume();
		}
		
		private function processObjectStatus(param1:ObjectStatusData, param2:int, param3:int) : void {
			var loc8:int = 0;
			var loc9:int = 0;
			var loc10:int = 0;
			var loc11:int = 0;
			var loc12:CharacterClass = null;
			var loc13:XML = null;
			var loc14:String = null;
			var loc15:String = null;
			var loc16:int = 0;
			var loc17:ObjectProperties = null;
			var loc18:ProjectileProperties = null;
			var loc19:Array = null;
			var loc4:AbstractMap = gs_.map;
			var loc5:GameObject = loc4.goDict_[param1.objectId_];
			if(loc5 == null) {
				return;
			}
			var loc6:* = param1.objectId_ == this.playerId_;
			if(param2 != 0 && !loc6) {
				loc5.onTickPos(param1.pos_.x_,param1.pos_.y_,param2,param3);
			}
			var loc7:Player = loc5 as Player;
			if(loc7 != null) {
				loc8 = loc7.level_;
				loc9 = loc7.exp_;
				loc10 = loc7.skinId;
				loc11 = loc7.currFame_;
			}
			this.updateGameObject(loc5,param1.stats_,loc6);
			if(loc7) {
				if(loc6) {
					loc12 = this.classesModel.getCharacterClass(loc7.objectType_);
					if(loc12.getMaxLevelAchieved() < loc7.level_) {
						loc12.setMaxLevelAchieved(loc7.level_);
					}
				}
				if(loc7.skinId != loc10) {
					if(ObjectLibrary.skinSetXMLDataLibrary_[loc7.skinId] != null) {
						loc13 = ObjectLibrary.skinSetXMLDataLibrary_[loc7.skinId] as XML;
						loc14 = loc13.attribute("color");
						loc15 = loc13.attribute("bulletType");
						if(loc8 != -1 && loc14.length > 0) {
							loc7.levelUpParticleEffect(uint(loc14));
						}
						if(loc15.length > 0) {
							loc7.projectileIdSetOverrideNew = loc15;
							loc16 = loc7.equipment_[0];
							loc17 = ObjectLibrary.propsLibrary_[loc16];
							loc18 = loc17.projectiles_[0];
							loc7.projectileIdSetOverrideOld = loc18.objectId_;
						}
					} else if(ObjectLibrary.skinSetXMLDataLibrary_[loc7.skinId] == null) {
						loc7.projectileIdSetOverrideNew = "";
						loc7.projectileIdSetOverrideOld = "";
					}
				}
				if(loc8 != -1 && loc7.level_ > loc8) {
					if(loc6) {
						loc19 = gs_.model.getNewUnlocks(loc7.objectType_,loc7.level_);
						loc7.handleLevelUp(loc19.length != 0);
						if(loc19.length > 0) {
							this.newClassUnlockSignal.dispatch(loc19);
						}
					} else if(!Parameters.data_.noAllyNotifications) {
						loc7.levelUpEffect(TextKey.PLAYER_LEVELUP);
					}
				} else if(loc8 != -1 && loc7.exp_ > loc9) {
					if(loc6 || !Parameters.data_.noAllyNotifications) {
						loc7.handleExpUp(loc7.exp_ - loc9);
					}
				}
				if(Parameters.data_.showFameGain && loc11 != -1 && loc7.currFame_ > loc11) {
					if(loc6) {
						loc7.updateFame(loc7.currFame_ - loc11);
					}
				}
				this.socialModel.updateFriendVO(loc7.getName(),loc7);
			}
		}
		
		private function onInvResult(param1:InvResult) : void {
			if(param1.result_ != 0) {
				this.handleInvFailure();
			}
		}
		
		private function handleInvFailure() : void {
			SoundEffectLibrary.play("error");
			gs_.hudView.interactPanel.redraw();
		}
		
		private function onReconnect(param1:Reconnect) : void {
			var loc2:Server = new Server().setName(param1.name_).setAddress(param1.host_ != ""?param1.host_:server_.address).setPort(param1.host_ != ""?int(param1.port_):int(server_.port));
			var loc3:int = param1.gameId_;
			var loc4:Boolean = createCharacter_;
			var loc5:int = charId_;
			var loc6:int = param1.keyTime_;
			var loc7:ByteArray = param1.key_;
			isFromArena_ = param1.isFromArena_;
			if(param1.stats_) {
				this.statsTracker.setBinaryStringData(loc5,param1.stats_);
			}
			var loc8:ReconnectEvent = new ReconnectEvent(loc2,loc3,loc4,loc5,loc6,loc7,isFromArena_);
			gs_.dispatchEvent(loc8);
		}
		
		private function onPing(param1:Ping) : void {
			var loc2:Pong = this.messages.require(PONG) as Pong;
			loc2.serial_ = param1.serial_;
			loc2.time_ = getTimer();
			serverConnection.sendMessage(loc2);
		}
		
		private function parseXML(param1:String) : void {
			var loc2:XML = XML(param1);
			GroundLibrary.parseFromXML(loc2);
			ObjectLibrary.parseFromXML(loc2);
		}
		
		private function onMapInfo(param1:MapInfo) : void {
			var loc2:String = null;
			var loc3:String = null;
			for each(loc2 in param1.clientXML_) {
				this.parseXML(loc2);
			}
			for each(loc3 in param1.extraXML_) {
				this.parseXML(loc3);
			}
			changeMapSignal.dispatch();
			this.closeDialogs.dispatch();
			gs_.applyMapInfo(param1);
			this.rand_ = new Random(param1.fp_);
			if(createCharacter_) {
				this.create();
			} else {
				this.load();
			}
		}
		
		private function onPic(param1:Pic) : void {
			gs_.addChild(new PicView(param1.bitmapData_));
		}
		
		private function onDeath(param1:Death) : void {
			this.death = param1;
			var loc2:BitmapData = new BitmapDataSpy(gs_.stage.stageWidth,gs_.stage.stageHeight);
			loc2.draw(gs_);
			param1.background = loc2;
			if(!gs_.isEditor) {
				this.handleDeath.dispatch(param1);
			}
			if(gs_.map.name_ == "Davy Jones\' Locker") {
				this.showHideKeyUISignal.dispatch(false);
			}
		}
		
		private function onBuyResult(param1:BuyResult) : void {
			if(param1.result_ == BuyResult.SUCCESS_BRID) {
				if(outstandingBuy_ != null) {
					outstandingBuy_.record();
				}
			}
			outstandingBuy_ = null;
			this.handleBuyResultType(param1);
		}
		
		private function handleBuyResultType(param1:BuyResult) : void {
			var loc2:ChatMessage = null;
			switch(param1.result_) {
				case BuyResult.UNKNOWN_ERROR_BRID:
					loc2 = ChatMessage.make(Parameters.SERVER_CHAT_NAME,param1.resultString_);
					this.addTextLine.dispatch(loc2);
					break;
				case BuyResult.NOT_ENOUGH_GOLD_BRID:
					this.openDialog.dispatch(new NotEnoughGoldDialog());
					break;
				case BuyResult.NOT_ENOUGH_FAME_BRID:
					this.openDialog.dispatch(new NotEnoughFameDialog());
					break;
				default:
					this.handleDefaultResult(param1);
			}
		}
		
		private function handleDefaultResult(param1:BuyResult) : void {
			var loc2:LineBuilder = LineBuilder.fromJSON(param1.resultString_);
			var loc3:Boolean = param1.result_ == BuyResult.SUCCESS_BRID || param1.result_ == BuyResult.PET_FEED_SUCCESS_BRID;
			var loc4:ChatMessage = ChatMessage.make(!!loc3?Parameters.SERVER_CHAT_NAME:Parameters.ERROR_CHAT_NAME,loc2.key);
			loc4.tokens = loc2.tokens;
			this.addTextLine.dispatch(loc4);
		}
		
		private function onAccountList(param1:AccountList) : void {
			if(param1.accountListId_ == 0) {
				if(param1.lockAction_ != -1) {
					if(param1.lockAction_ == 1) {
						gs_.map.party_.setStars(param1);
					} else {
						gs_.map.party_.removeStars(param1);
					}
				} else {
					gs_.map.party_.setStars(param1);
				}
			} else if(param1.accountListId_ == 1) {
				gs_.map.party_.setIgnores(param1);
			}
		}
		
		private function onQuestObjId(param1:QuestObjId) : void {
			gs_.map.quest_.setObject(param1.objectId_);
		}
		
		private function onAoe(param1:Aoe) : void {
			var loc4:int = 0;
			var loc5:Vector.<uint> = null;
			if(this.player == null) {
				this.aoeAck(gs_.lastUpdate_,0,0);
				return;
			}
			var loc2:AOEEffect = new AOEEffect(param1.pos_.toPoint(),param1.radius_,param1.color_);
			gs_.map.addObj(loc2,param1.pos_.x_,param1.pos_.y_);
			if(this.player.isInvincible() || this.player.isPaused()) {
				this.aoeAck(gs_.lastUpdate_,this.player.x_,this.player.y_);
				return;
			}
			var loc3:* = this.player.distTo(param1.pos_) < param1.radius_;
			if(loc3) {
				loc4 = GameObject.damageWithDefense(param1.damage_,this.player.defense_,false,this.player.condition_);
				loc5 = null;
				if(param1.effect_ != 0) {
					loc5 = new Vector.<uint>();
					loc5.push(param1.effect_);
				}
				this.player.damage(true,loc4,loc5,false,null);
			}
			this.aoeAck(gs_.lastUpdate_,this.player.x_,this.player.y_);
		}
		
		private function onNameResult(param1:NameResult) : void {
			gs_.dispatchEvent(new NameResultEvent(param1));
		}
		
		private function onGuildResult(param1:GuildResult) : void {
			var loc2:LineBuilder = null;
			if(param1.lineBuilderJSON == "") {
				gs_.dispatchEvent(new GuildResultEvent(param1.success_,"",{}));
			} else {
				loc2 = LineBuilder.fromJSON(param1.lineBuilderJSON);
				this.addTextLine.dispatch(ChatMessage.make(Parameters.ERROR_CHAT_NAME,loc2.key,-1,-1,"",false,loc2.tokens));
				gs_.dispatchEvent(new GuildResultEvent(param1.success_,loc2.key,loc2.tokens));
			}
		}
		
		private function onClientStat(param1:ClientStat) : void {
			var loc2:Account = StaticInjectorContext.getInjector().getInstance(Account);
			loc2.reportIntStat(param1.name_,param1.value_);
		}
		
		private function onFile(param1:File) : void {
			new FileReference().save(param1.file_,param1.filename_);
		}
		
		private function onInvitedToGuild(param1:InvitedToGuild) : void {
			if(Parameters.data_.showGuildInvitePopup) {
				gs_.hudView.interactPanel.setOverride(new GuildInvitePanel(gs_,param1.name_,param1.guildName_));
			}
			this.addTextLine.dispatch(ChatMessage.make("","You have been invited by " + param1.name_ + " to join the guild " + param1.guildName_ + ".\n  If you wish to join type \"/join " + param1.guildName_ + "\""));
		}
		
		private function onPlaySound(param1:PlaySound) : void {
			var loc2:GameObject = gs_.map.goDict_[param1.ownerId_];
			loc2 && loc2.playSound(param1.soundId_);
		}
		
		private function onImminentArenaWave(param1:ImminentArenaWave) : void {
			this.imminentWave.dispatch(param1.currentRuntime);
		}
		
		private function onArenaDeath(param1:ArenaDeath) : void {
			this.currentArenaRun.costOfContinue = param1.cost;
			this.openDialog.dispatch(new ContinueOrQuitDialog(param1.cost,false));
			this.arenaDeath.dispatch();
		}
		
		private function onVerifyEmail(param1:VerifyEmail) : void {
			TitleView.queueEmailConfirmation = true;
			if(gs_ != null) {
				gs_.closed.dispatch();
			}
			var loc2:HideMapLoadingSignal = StaticInjectorContext.getInjector().getInstance(HideMapLoadingSignal);
			if(loc2 != null) {
				loc2.dispatch();
			}
		}
		
		private function onPasswordPrompt(param1:PasswordPrompt) : void {
			if(param1.cleanPasswordStatus == 3) {
				TitleView.queuePasswordPromptFull = true;
			} else if(param1.cleanPasswordStatus == 2) {
				TitleView.queuePasswordPrompt = true;
			} else if(param1.cleanPasswordStatus == 4) {
				TitleView.queueRegistrationPrompt = true;
			}
			if(gs_ != null) {
				gs_.closed.dispatch();
			}
			var loc2:HideMapLoadingSignal = StaticInjectorContext.getInjector().getInstance(HideMapLoadingSignal);
			if(loc2 != null) {
				loc2.dispatch();
			}
		}
		
		override public function questFetch() : void {
			serverConnection.sendMessage(this.messages.require(QUEST_FETCH_ASK));
		}
		
		private function onQuestFetchResponse(param1:QuestFetchResponse) : void {
			this.questFetchComplete.dispatch(param1);
		}
		
		private function onQuestRedeemResponse(param1:QuestRedeemResponse) : void {
			this.questRedeemComplete.dispatch(param1);
		}
		
		override public function questRedeem(param1:String, param2:Vector.<SlotObjectData>, param3:int = -1) : void {
			var loc4:QuestRedeem = this.messages.require(QUEST_REDEEM) as QuestRedeem;
			loc4.questID = param1;
			loc4.item = param3;
			loc4.slots = param2;
			serverConnection.sendMessage(loc4);
		}
		
		override public function keyInfoRequest(param1:int) : void {
			var loc2:KeyInfoRequest = this.messages.require(KEY_INFO_REQUEST) as KeyInfoRequest;
			loc2.itemType_ = param1;
			serverConnection.sendMessage(loc2);
		}
		
		private function onKeyInfoResponse(param1:KeyInfoResponse) : void {
			this.keyInfoResponse.dispatch(param1);
		}
		
		private function onLoginRewardResponse(param1:ClaimDailyRewardResponse) : void {
			this.claimDailyRewardResponse.dispatch(param1);
		}
		
		private function onClosed() : void {
			var loc1:GoogleAnalytics = null;
			var loc2:HideMapLoadingSignal = null;
			if(this.playerId_ != -1) {
				loc1 = StaticInjectorContext.getInjector().getInstance(GoogleAnalytics);
				loc1.trackEvent("error","disconnect",gs_.map.name_);
				gs_.closed.dispatch();
			} else if(this.retryConnection_) {
				if(this.delayBeforeReconnect < 10) {
					if(this.delayBeforeReconnect == 6) {
						loc2 = StaticInjectorContext.getInjector().getInstance(HideMapLoadingSignal);
						loc2.dispatch();
					}
					this.retry(this.delayBeforeReconnect++);
					this.addTextLine.dispatch(ChatMessage.make(Parameters.ERROR_CHAT_NAME,"Connection failed!  Retrying..."));
				} else {
					gs_.closed.dispatch();
				}
			}
		}
		
		private function retry(param1:int) : void {
			this.retryTimer_ = new Timer(param1 * 1000,1);
			this.retryTimer_.addEventListener(TimerEvent.TIMER_COMPLETE,this.onRetryTimer);
			this.retryTimer_.start();
		}
		
		private function onRetryTimer(param1:TimerEvent) : void {
			serverConnection.connect(server_.address,server_.port);
		}
		
		private function onError(param1:String) : void {
			this.addTextLine.dispatch(ChatMessage.make(Parameters.ERROR_CHAT_NAME,param1));
		}
		
		private function onFailure(param1:Failure) : void {
			switch(param1.errorId_) {
				case Failure.INCORRECT_VERSION:
					this.handleIncorrectVersionFailure(param1);
					break;
				case Failure.BAD_KEY:
					this.handleBadKeyFailure(param1);
					break;
				case Failure.INVALID_TELEPORT_TARGET:
					this.handleInvalidTeleportTarget(param1);
					break;
				case Failure.EMAIL_VERIFICATION_NEEDED:
					this.handleEmailVerificationNeeded(param1);
					break;
				case Failure.TELEPORT_REALM_BLOCK:
					this.handleRealmTeleportBlock(param1);
					break;
				default:
					this.handleDefaultFailure(param1);
			}
		}
		
		private function handleEmailVerificationNeeded(param1:Failure) : void {
			this.retryConnection_ = false;
			gs_.closed.dispatch();
		}
		
		private function handleRealmTeleportBlock(param1:Failure) : void {
			this.addTextLine.dispatch(ChatMessage.make(Parameters.SERVER_CHAT_NAME,"You need to wait at least " + param1.errorDescription_ + " seconds before a non guild member teleport."));
			this.player.nextTeleportAt_ = getTimer() + int(param1.errorDescription_) * 1000;
		}
		
		private function handleInvalidTeleportTarget(param1:Failure) : void {
			var loc2:String = LineBuilder.getLocalizedStringFromJSON(param1.errorDescription_);
			if(loc2 == "") {
				loc2 = param1.errorDescription_;
			}
			this.addTextLine.dispatch(ChatMessage.make(Parameters.ERROR_CHAT_NAME,loc2));
			this.player.nextTeleportAt_ = 0;
		}
		
		private function handleBadKeyFailure(param1:Failure) : void {
			var loc2:String = LineBuilder.getLocalizedStringFromJSON(param1.errorDescription_);
			if(loc2 == "") {
				loc2 = param1.errorDescription_;
			}
			this.addTextLine.dispatch(ChatMessage.make(Parameters.ERROR_CHAT_NAME,loc2));
			this.retryConnection_ = false;
			gs_.closed.dispatch();
		}
		
		private function handleIncorrectVersionFailure(param1:Failure) : void {
			var loc2:Dialog = new Dialog(TextKey.CLIENT_UPDATE_TITLE,"",TextKey.CLIENT_UPDATE_LEFT_BUTTON,null,"/clientUpdate");
			loc2.setTextParams(TextKey.CLIENT_UPDATE_DESCRIPTION,{
				"client":Parameters.BUILD_VERSION,
				"server":param1.errorDescription_
			});
			loc2.addEventListener(Dialog.LEFT_BUTTON,this.onDoClientUpdate);
			gs_.stage.addChild(loc2);
			this.retryConnection_ = false;
		}
		
		private function handleDefaultFailure(param1:Failure) : void {
			var loc2:String = LineBuilder.getLocalizedStringFromJSON(param1.errorDescription_);
			if(loc2 == "") {
				loc2 = param1.errorDescription_;
			}
			this.addTextLine.dispatch(ChatMessage.make(Parameters.ERROR_CHAT_NAME,loc2));
		}
		
		private function onDoClientUpdate(param1:Event) : void {
			var loc2:Dialog = param1.currentTarget as Dialog;
			loc2.parent.removeChild(loc2);
			gs_.closed.dispatch();
		}
		
		override public function isConnected() : Boolean {
			return serverConnection.isConnected();
		}
	}
}
