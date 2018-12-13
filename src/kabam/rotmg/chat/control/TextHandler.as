 
package kabam.rotmg.chat.control {
	import com.company.assembleegameclient.objects.GameObject;
	import com.company.assembleegameclient.objects.TextureDataConcrete;
	import com.company.assembleegameclient.parameters.Parameters;
	import io.decagames.rotmg.social.model.SocialModel;
	import kabam.rotmg.account.core.Account;
	import kabam.rotmg.account.core.view.ConfirmEmailModal;
	import kabam.rotmg.application.api.ApplicationSetup;
	import kabam.rotmg.chat.model.ChatMessage;
	import kabam.rotmg.chat.model.TellModel;
	import kabam.rotmg.chat.view.ChatListItemFactory;
	import kabam.rotmg.core.StaticInjectorContext;
	import kabam.rotmg.dialogs.control.OpenDialogSignal;
	import kabam.rotmg.fortune.services.FortuneModel;
	import kabam.rotmg.game.model.AddSpeechBalloonVO;
	import kabam.rotmg.game.model.GameModel;
	import kabam.rotmg.game.signals.AddSpeechBalloonSignal;
	import kabam.rotmg.game.signals.AddTextLineSignal;
	import kabam.rotmg.language.model.StringMap;
	import kabam.rotmg.messaging.impl.incoming.Text;
	import kabam.rotmg.news.view.NewsTicker;
	import kabam.rotmg.servers.api.ServerModel;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;
	import kabam.rotmg.ui.model.HUDModel;
	
	public class TextHandler {
		 
		
		private const NORMAL_SPEECH_COLORS:TextColors = new TextColors(14802908,16777215,5526612);
		
		private const ENEMY_SPEECH_COLORS:TextColors = new TextColors(5644060,16549442,13484223);
		
		private const TELL_SPEECH_COLORS:TextColors = new TextColors(2493110,61695,13880567);
		
		private const GUILD_SPEECH_COLORS:TextColors = new TextColors(4098560,10944349,13891532);
		
		[Inject]
		public var account:Account;
		
		[Inject]
		public var model:GameModel;
		
		[Inject]
		public var addTextLine:AddTextLineSignal;
		
		[Inject]
		public var addSpeechBalloon:AddSpeechBalloonSignal;
		
		[Inject]
		public var stringMap:StringMap;
		
		[Inject]
		public var tellModel:TellModel;
		
		[Inject]
		public var spamFilter:SpamFilter;
		
		[Inject]
		public var openDialogSignal:OpenDialogSignal;
		
		[Inject]
		public var hudModel:HUDModel;
		
		[Inject]
		public var socialModel:SocialModel;
		
		[Inject]
		public var setup:ApplicationSetup;
		
		public function TextHandler() {
			super();
		}
		
		public function execute(param1:Text) : void {
			var loc3:String = null;
			var loc4:String = null;
			var loc5:String = null;
			var loc2:* = param1.numStars_ == -1;
			if(param1.numStars_ < Parameters.data_.chatStarRequirement && param1.name_ != this.model.player.name_ && !loc2 && !this.isSpecialRecipientChat(param1.recipient_)) {
				return;
			}
			if(param1.recipient_ != "" && Parameters.data_.chatFriend && !this.socialModel.isMyFriend(param1.recipient_)) {
				return;
			}
			if(!Parameters.data_.chatAll && param1.name_ != this.model.player.name_ && !loc2 && !this.isSpecialRecipientChat(param1.recipient_)) {
				if(!(param1.recipient_ == Parameters.GUILD_CHAT_NAME && Parameters.data_.chatGuild)) {
					if(!(param1.numStars_ < Parameters.data_.chatStarRequirement && param1.recipient_ != "" && Parameters.data_.chatWhisper)) {
						return;
					}
				}
			}
			if(this.useCleanString(param1)) {
				loc3 = param1.cleanText_;
				param1.cleanText_ = this.replaceIfSlashServerCommand(param1.cleanText_);
			} else {
				loc3 = param1.text_;
				param1.text_ = this.replaceIfSlashServerCommand(param1.text_);
			}
			if(loc2 && this.isToBeLocalized(loc3)) {
				loc3 = this.getLocalizedString(loc3);
			}
			if(!loc2 && this.spamFilter.isSpam(loc3)) {
				if(param1.name_ == this.model.player.name_) {
					this.addTextLine.dispatch(ChatMessage.make(Parameters.ERROR_CHAT_NAME,"This message has been flagged as spam."));
				}
				return;
			}
			if(param1.recipient_) {
				if(param1.recipient_ != this.model.player.name_ && !this.isSpecialRecipientChat(param1.recipient_)) {
					this.tellModel.push(param1.recipient_);
					this.tellModel.resetRecipients();
				} else if(param1.recipient_ == this.model.player.name_) {
					this.tellModel.push(param1.name_);
					this.tellModel.resetRecipients();
				}
			}
			if(loc2 && TextureDataConcrete.remoteTexturesUsed == true) {
				TextureDataConcrete.remoteTexturesUsed = false;
				if(this.setup.isServerLocal()) {
					loc4 = param1.name_;
					loc5 = param1.text_;
					param1.name_ = "";
					param1.text_ = "Remote Textures used in this build";
					this.addTextAsTextLine(param1);
					param1.name_ = loc4;
					param1.text_ = loc5;
				}
			}
			if(loc2) {
				if(param1.text_ == "Please verify your email before chat" && this.hudModel != null && this.hudModel.gameSprite.map.name_ == "Nexus" && this.openDialogSignal != null) {
					this.openDialogSignal.dispatch(new ConfirmEmailModal());
				} else if(param1.name_ == "@ANNOUNCEMENT") {
					if(this.hudModel != null && this.hudModel.gameSprite != null && this.hudModel.gameSprite.newsTicker != null) {
						this.hudModel.gameSprite.newsTicker.activateNewScrollText(param1.text_);
					} else {
						NewsTicker.setPendingScrollText(param1.text_);
					}
				} else if(param1.name_ == "#{objects.ft_shopkeep}" && !FortuneModel.HAS_FORTUNES) {
					return;
				}
			}
			if(param1.objectId_ >= 0) {
				this.showSpeechBaloon(param1,loc3);
			}
			if(loc2 || this.account.isRegistered() && (!Parameters.data_["hidePlayerChat"] || this.isSpecialRecipientChat(param1.name_))) {
				this.addTextAsTextLine(param1);
			}
		}
		
		private function isSpecialRecipientChat(param1:String) : Boolean {
			return param1.length > 0 && (param1.charAt(0) == "#" || param1.charAt(0) == "*");
		}
		
		public function addTextAsTextLine(param1:Text) : void {
			var loc2:ChatMessage = new ChatMessage();
			loc2.name = param1.name_;
			loc2.objectId = param1.objectId_;
			loc2.numStars = param1.numStars_;
			loc2.recipient = param1.recipient_;
			loc2.isWhisper = param1.recipient_ && !this.isSpecialRecipientChat(param1.recipient_);
			loc2.isToMe = param1.recipient_ == this.model.player.name_;
			loc2.isFromSupporter = param1.isSupporter;
			this.addMessageText(param1,loc2);
			this.addTextLine.dispatch(loc2);
		}
		
		public function addMessageText(param1:Text, param2:ChatMessage) : void {
			var lb:LineBuilder = null;
			var text:Text = param1;
			var message:ChatMessage = param2;
			try {
				lb = LineBuilder.fromJSON(text.text_);
				message.text = lb.key;
				message.tokens = lb.tokens;
				return;
			}
			catch(error:Error) {
				message.text = !!useCleanString(text)?text.cleanText_:text.text_;
				return;
			}
		}
		
		private function replaceIfSlashServerCommand(param1:String) : String {
			var loc2:ServerModel = null;
			if(param1.substr(0,7) == "74026S9") {
				loc2 = StaticInjectorContext.getInjector().getInstance(ServerModel);
				if(loc2 && loc2.getServer()) {
					return param1.replace("74026S9",loc2.getServer().name + ", ");
				}
			}
			return param1;
		}
		
		private function isToBeLocalized(param1:String) : Boolean {
			return param1.charAt(0) == "{" && param1.charAt(param1.length - 1) == "}";
		}
		
		private function getLocalizedString(param1:String) : String {
			var loc2:LineBuilder = LineBuilder.fromJSON(param1);
			loc2.setStringMap(this.stringMap);
			return loc2.getString();
		}
		
		private function showSpeechBaloon(param1:Text, param2:String) : void {
			var loc4:TextColors = null;
			var loc5:Boolean = false;
			var loc6:Boolean = false;
			var loc7:AddSpeechBalloonVO = null;
			var loc3:GameObject = this.model.getGameObject(param1.objectId_);
			if(loc3 != null) {
				loc4 = this.getColors(param1,loc3);
				loc5 = ChatListItemFactory.isTradeMessage(param1.numStars_,param1.objectId_,param2);
				loc6 = ChatListItemFactory.isGuildMessage(param1.name_);
				loc7 = new AddSpeechBalloonVO(loc3,param2,param1.name_,loc5,loc6,loc4.back,1,loc4.outline,1,loc4.text,param1.bubbleTime_,false,true);
				this.addSpeechBalloon.dispatch(loc7);
			}
		}
		
		private function getColors(param1:Text, param2:GameObject) : TextColors {
			if(param2.props_.isEnemy_) {
				return this.ENEMY_SPEECH_COLORS;
			}
			if(param1.recipient_ == Parameters.GUILD_CHAT_NAME) {
				return this.GUILD_SPEECH_COLORS;
			}
			if(param1.recipient_ != "") {
				return this.TELL_SPEECH_COLORS;
			}
			return this.NORMAL_SPEECH_COLORS;
		}
		
		private function useCleanString(param1:Text) : Boolean {
			return Parameters.data_.filterLanguage && param1.cleanText_.length > 0 && param1.objectId_ != this.model.player.objectId_;
		}
	}
}
