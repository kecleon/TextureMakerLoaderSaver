 
package com.company.assembleegameclient.objects {
	import com.company.assembleegameclient.map.Camera;
	import com.company.assembleegameclient.map.Square;
	import com.company.assembleegameclient.map.mapoverlay.CharacterStatusText;
	import com.company.assembleegameclient.objects.particles.HealingEffect;
	import com.company.assembleegameclient.objects.particles.LevelUpEffect;
	import com.company.assembleegameclient.parameters.Parameters;
	import com.company.assembleegameclient.sound.SoundEffectLibrary;
	import com.company.assembleegameclient.tutorial.Tutorial;
	import com.company.assembleegameclient.tutorial.doneAction;
	import com.company.assembleegameclient.util.AnimatedChar;
	import com.company.assembleegameclient.util.ConditionEffect;
	import com.company.assembleegameclient.util.FameUtil;
	import com.company.assembleegameclient.util.FreeList;
	import com.company.assembleegameclient.util.MaskedImage;
	import com.company.assembleegameclient.util.MathUtil;
	import com.company.assembleegameclient.util.PlayerUtil;
	import com.company.assembleegameclient.util.TextureRedrawer;
	import com.company.assembleegameclient.util.redrawers.GlowRedrawer;
	import com.company.util.CachingColorTransformer;
	import com.company.util.ConversionUtil;
	import com.company.util.GraphicsUtil;
	import com.company.util.IntPoint;
	import com.company.util.MoreColorUtil;
	import com.company.util.PointUtil;
	import com.company.util.Trig;
	import flash.display.BitmapData;
	import flash.display.GraphicsPath;
	import flash.display.GraphicsSolidFill;
	import flash.display.IGraphicsData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	import io.decagames.rotmg.supportCampaign.data.SupporterCampaignModel;
	import io.decagames.rotmg.supportCampaign.data.SupporterFeatures;
	import kabam.rotmg.assets.services.CharacterFactory;
	import kabam.rotmg.chat.model.ChatMessage;
	import kabam.rotmg.constants.ActivationType;
	import kabam.rotmg.constants.GeneralConstants;
	import kabam.rotmg.constants.UseType;
	import kabam.rotmg.core.StaticInjectorContext;
	import kabam.rotmg.game.model.PotionInventoryModel;
	import kabam.rotmg.game.signals.AddTextLineSignal;
	import kabam.rotmg.messaging.impl.data.StatData;
	import kabam.rotmg.stage3D.GraphicsFillExtra;
	import kabam.rotmg.text.model.TextKey;
	import kabam.rotmg.text.view.BitmapTextFactory;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;
	import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
	import kabam.rotmg.text.view.stringBuilder.StringBuilder;
	import kabam.rotmg.ui.model.TabStripModel;
	import org.osflash.signals.Signal;
	import org.swiftsuspenders.Injector;
	
	public class Player extends Character {
		
		public static const MS_BETWEEN_TELEPORT:int = 10000;
		
		public static const MS_REALM_TELEPORT:int = 120000;
		
		private static const MOVE_THRESHOLD:Number = 0.4;
		
		public static var isAdmin:Boolean = false;
		
		public static var isMod:Boolean = false;
		
		private static const NEARBY:Vector.<Point> = new <Point>[new Point(0,0),new Point(1,0),new Point(0,1),new Point(1,1)];
		
		private static var newP:Point = new Point();
		
		private static const RANK_OFFSET_MATRIX:Matrix = new Matrix(1,0,0,1,2,2);
		
		private static const NAME_OFFSET_MATRIX:Matrix = new Matrix(1,0,0,1,20,1);
		
		private static const MIN_MOVE_SPEED:Number = 0.004;
		
		private static const MAX_MOVE_SPEED:Number = 0.0096;
		
		private static const MIN_ATTACK_FREQ:Number = 0.0015;
		
		private static const MAX_ATTACK_FREQ:Number = 0.008;
		
		private static const MIN_ATTACK_MULT:Number = 0.5;
		
		private static const MAX_ATTACK_MULT:Number = 2;
		 
		
		public var xpTimer:int;
		
		public var skinId:int;
		
		public var skin:AnimatedChar;
		
		public var isShooting:Boolean;
		
		public var creditsWereChanged:Signal;
		
		public var fameWasChanged:Signal;
		
		public var supporterFlagWasChanged:Signal;
		
		private var famePortrait_:BitmapData = null;
		
		public var lastSwap_:int = -1;
		
		public var accountId_:String = "";
		
		public var credits_:int = 0;
		
		public var tokens_:int = 0;
		
		public var numStars_:int = 0;
		
		public var fame_:int = 0;
		
		public var nameChosen_:Boolean = false;
		
		public var currFame_:int = -1;
		
		public var nextClassQuestFame_:int = -1;
		
		public var legendaryRank_:int = -1;
		
		public var guildName_:String = null;
		
		public var guildRank_:int = -1;
		
		public var isFellowGuild_:Boolean = false;
		
		public var breath_:int = -1;
		
		public var maxMP_:int = 200;
		
		public var mp_:Number = 0;
		
		public var nextLevelExp_:int = 1000;
		
		public var exp_:int = 0;
		
		public var attack_:int = 0;
		
		public var speed_:int = 0;
		
		public var dexterity_:int = 0;
		
		public var vitality_:int = 0;
		
		public var wisdom_:int = 0;
		
		public var maxHPBoost_:int = 0;
		
		public var maxMPBoost_:int = 0;
		
		public var attackBoost_:int = 0;
		
		public var defenseBoost_:int = 0;
		
		public var speedBoost_:int = 0;
		
		public var vitalityBoost_:int = 0;
		
		public var wisdomBoost_:int = 0;
		
		public var dexterityBoost_:int = 0;
		
		public var xpBoost_:int = 0;
		
		public var healthPotionCount_:int = 0;
		
		public var magicPotionCount_:int = 0;
		
		public var attackMax_:int = 0;
		
		public var defenseMax_:int = 0;
		
		public var speedMax_:int = 0;
		
		public var dexterityMax_:int = 0;
		
		public var vitalityMax_:int = 0;
		
		public var wisdomMax_:int = 0;
		
		public var maxHPMax_:int = 0;
		
		public var maxMPMax_:int = 0;
		
		public var supporterFlag:int = 0;
		
		public var hasBackpack_:Boolean = false;
		
		public var starred_:Boolean = false;
		
		public var ignored_:Boolean = false;
		
		public var distSqFromThisPlayer_:Number = 0;
		
		protected var rotate_:Number = 0;
		
		protected var relMoveVec_:Point = null;
		
		protected var moveMultiplier_:Number = 1;
		
		public var attackPeriod_:int = 0;
		
		public var nextAltAttack_:int = 0;
		
		public var nextTeleportAt_:int = 0;
		
		public var dropBoost:int = 0;
		
		public var tierBoost:int = 0;
		
		protected var healingEffect_:HealingEffect = null;
		
		protected var nearestMerchant_:Merchant = null;
		
		public var isDefaultAnimatedChar:Boolean = true;
		
		public var projectileIdSetOverrideNew:String = "";
		
		public var projectileIdSetOverrideOld:String = "";
		
		private var addTextLine:AddTextLineSignal;
		
		private var factory:CharacterFactory;
		
		private var supportCampaignModel:SupporterCampaignModel;
		
		private var ip_:IntPoint;
		
		private var breathBackFill_:GraphicsSolidFill = null;
		
		private var breathBackPath_:GraphicsPath = null;
		
		private var breathFill_:GraphicsSolidFill = null;
		
		private var breathPath_:GraphicsPath = null;
		
		public function Player(param1:XML) {
			this.creditsWereChanged = new Signal();
			this.fameWasChanged = new Signal();
			this.supporterFlagWasChanged = new Signal();
			this.ip_ = new IntPoint();
			var loc2:Injector = StaticInjectorContext.getInjector();
			this.addTextLine = loc2.getInstance(AddTextLineSignal);
			this.factory = loc2.getInstance(CharacterFactory);
			this.supportCampaignModel = loc2.getInstance(SupporterCampaignModel);
			super(param1);
			this.attackMax_ = int(param1.Attack.@max);
			this.defenseMax_ = int(param1.Defense.@max);
			this.speedMax_ = int(param1.Speed.@max);
			this.dexterityMax_ = int(param1.Dexterity.@max);
			this.vitalityMax_ = int(param1.HpRegen.@max);
			this.wisdomMax_ = int(param1.MpRegen.@max);
			this.maxHPMax_ = int(param1.MaxHitPoints.@max);
			this.maxMPMax_ = int(param1.MaxMagicPoints.@max);
			texturingCache_ = new Dictionary();
		}
		
		public static function fromPlayerXML(param1:String, param2:XML) : Player {
			var loc3:int = int(param2.ObjectType);
			var loc4:XML = ObjectLibrary.xmlLibrary_[loc3];
			var loc5:Player = new Player(loc4);
			loc5.name_ = param1;
			loc5.level_ = int(param2.Level);
			loc5.exp_ = int(param2.Exp);
			loc5.equipment_ = ConversionUtil.toIntVector(param2.Equipment);
			loc5.calculateStatBoosts();
			loc5.lockedSlot = new Vector.<int>(loc5.equipment_.length);
			loc5.maxHP_ = loc5.maxHPBoost_ + int(param2.MaxHitPoints);
			loc5.hp_ = int(param2.HitPoints);
			loc5.maxMP_ = loc5.maxMPBoost_ + int(param2.MaxMagicPoints);
			loc5.mp_ = int(param2.MagicPoints);
			loc5.attack_ = loc5.attackBoost_ + int(param2.Attack);
			loc5.defense_ = loc5.defenseBoost_ + int(param2.Defense);
			loc5.speed_ = loc5.speedBoost_ + int(param2.Speed);
			loc5.dexterity_ = loc5.dexterityBoost_ + int(param2.Dexterity);
			loc5.vitality_ = loc5.vitalityBoost_ + int(param2.HpRegen);
			loc5.wisdom_ = loc5.wisdomBoost_ + int(param2.MpRegen);
			loc5.tex1Id_ = int(param2.Tex1);
			loc5.tex2Id_ = int(param2.Tex2);
			loc5.hasBackpack_ = param2.HasBackpack == "1";
			return loc5;
		}
		
		public function getFameBonus() : int {
			var loc3:int = 0;
			var loc4:XML = null;
			var loc1:int = 0;
			var loc2:uint = 0;
			while(loc2 < GeneralConstants.NUM_EQUIPMENT_SLOTS) {
				if(equipment_ && equipment_.length > loc2) {
					loc3 = equipment_[loc2];
					if(loc3 != -1) {
						loc4 = ObjectLibrary.xmlLibrary_[loc3];
						if(loc4 != null && loc4.hasOwnProperty("FameBonus")) {
							loc1 = loc1 + int(loc4.FameBonus);
						}
					}
				}
				loc2++;
			}
			return loc1;
		}
		
		public function calculateStatBoosts() : void {
			var loc2:int = 0;
			var loc3:XML = null;
			var loc4:XML = null;
			var loc5:int = 0;
			var loc6:int = 0;
			this.maxHPBoost_ = 0;
			this.maxMPBoost_ = 0;
			this.attackBoost_ = 0;
			this.defenseBoost_ = 0;
			this.speedBoost_ = 0;
			this.vitalityBoost_ = 0;
			this.wisdomBoost_ = 0;
			this.dexterityBoost_ = 0;
			var loc1:uint = 0;
			while(loc1 < GeneralConstants.NUM_EQUIPMENT_SLOTS) {
				if(equipment_ && equipment_.length > loc1) {
					loc2 = equipment_[loc1];
					if(loc2 != -1) {
						loc3 = ObjectLibrary.xmlLibrary_[loc2];
						if(loc3 != null && loc3.hasOwnProperty("ActivateOnEquip")) {
							for each(loc4 in loc3.ActivateOnEquip) {
								if(loc4.toString() == "IncrementStat") {
									loc5 = int(loc4.@stat);
									loc6 = int(loc4.@amount);
									switch(loc5) {
										case StatData.MAX_HP_STAT:
											this.maxHPBoost_ = this.maxHPBoost_ + loc6;
											continue;
										case StatData.MAX_MP_STAT:
											this.maxMPBoost_ = this.maxMPBoost_ + loc6;
											continue;
										case StatData.ATTACK_STAT:
											this.attackBoost_ = this.attackBoost_ + loc6;
											continue;
										case StatData.DEFENSE_STAT:
											this.defenseBoost_ = this.defenseBoost_ + loc6;
											continue;
										case StatData.SPEED_STAT:
											this.speedBoost_ = this.speedBoost_ + loc6;
											continue;
										case StatData.VITALITY_STAT:
											this.vitalityBoost_ = this.vitalityBoost_ + loc6;
											continue;
										case StatData.WISDOM_STAT:
											this.wisdomBoost_ = this.wisdomBoost_ + loc6;
											continue;
										case StatData.DEXTERITY_STAT:
											this.dexterityBoost_ = this.dexterityBoost_ + loc6;
											continue;
										default:
											continue;
									}
								} else {
									continue;
								}
							}
						}
					}
				}
				loc1++;
			}
		}
		
		public function setRelativeMovement(param1:Number, param2:Number, param3:Number) : void {
			var loc4:Number = NaN;
			if(this.relMoveVec_ == null) {
				this.relMoveVec_ = new Point();
			}
			this.rotate_ = param1;
			this.relMoveVec_.x = param2;
			this.relMoveVec_.y = param3;
			if(isConfused()) {
				loc4 = this.relMoveVec_.x;
				this.relMoveVec_.x = -this.relMoveVec_.y;
				this.relMoveVec_.y = -loc4;
				this.rotate_ = -this.rotate_;
			}
		}
		
		public function setCredits(param1:int) : void {
			this.credits_ = param1;
			this.creditsWereChanged.dispatch();
		}
		
		public function setFame(param1:int) : void {
			this.fame_ = param1;
			this.fameWasChanged.dispatch();
		}
		
		public function setSupporterFlag(param1:int) : void {
			this.supporterFlag = param1;
			this.supporterFlagWasChanged.dispatch();
		}
		
		public function hasSupporterFeature(param1:int) : Boolean {
			return (this.supporterFlag & param1) == param1;
		}
		
		public function setTokens(param1:int) : void {
			this.tokens_ = param1;
		}
		
		public function setGuildName(param1:String) : void {
			var loc3:GameObject = null;
			var loc4:Player = null;
			var loc5:Boolean = false;
			this.guildName_ = param1;
			var loc2:Player = map_.player_;
			if(loc2 == this) {
				for each(loc3 in map_.goDict_) {
					loc4 = loc3 as Player;
					if(loc4 != null && loc4 != this) {
						loc4.setGuildName(loc4.guildName_);
					}
				}
			} else {
				loc5 = loc2 != null && loc2.guildName_ != null && loc2.guildName_ != "" && loc2.guildName_ == this.guildName_;
				if(loc5 != this.isFellowGuild_) {
					this.isFellowGuild_ = loc5;
					nameBitmapData_ = null;
				}
			}
		}
		
		public function isTeleportEligible(param1:Player) : Boolean {
			return !(param1.dead_ || param1.isPaused() || param1.isInvisible());
		}
		
		public function msUtilTeleport() : int {
			var loc1:int = getTimer();
			return Math.max(0,this.nextTeleportAt_ - loc1);
		}
		
		public function teleportTo(param1:Player) : Boolean {
			if(isPaused()) {
				this.addTextLine.dispatch(this.makeErrorMessage(TextKey.PLAYER_NOTELEPORTWHILEPAUSED));
				return false;
			}
			var loc2:int = this.msUtilTeleport();
			if(loc2 > 0) {
				if(!(loc2 > MS_BETWEEN_TELEPORT && param1.isFellowGuild_)) {
					this.addTextLine.dispatch(this.makeErrorMessage(TextKey.PLAYER_TELEPORT_COOLDOWN,{"seconds":int(loc2 / 1000 + 1)}));
					return false;
				}
			}
			if(!this.isTeleportEligible(param1)) {
				if(param1.isInvisible()) {
					this.addTextLine.dispatch(this.makeErrorMessage(TextKey.TELEPORT_INVISIBLE_PLAYER,{"player":param1.name_}));
				} else {
					this.addTextLine.dispatch(this.makeErrorMessage(TextKey.PLAYER_TELEPORT_TO_PLAYER,{"player":param1.name_}));
				}
				return false;
			}
			map_.gs_.gsc_.teleport(param1.objectId_);
			this.nextTeleportAt_ = getTimer() + MS_BETWEEN_TELEPORT;
			return true;
		}
		
		private function makeErrorMessage(param1:String, param2:Object = null) : ChatMessage {
			return ChatMessage.make(Parameters.ERROR_CHAT_NAME,param1,-1,-1,"",false,param2);
		}
		
		public function levelUpEffect(param1:String, param2:Boolean = true) : void {
			if(!Parameters.data_.noParticlesMaster && param2) {
				this.levelUpParticleEffect();
			}
			var loc3:CharacterStatusText = new CharacterStatusText(this,65280,2000);
			loc3.setStringBuilder(new LineBuilder().setParams(param1));
			map_.mapOverlay_.addStatusText(loc3);
		}
		
		public function handleLevelUp(param1:Boolean) : void {
			SoundEffectLibrary.play("level_up");
			if(param1) {
				this.levelUpEffect(TextKey.PLAYER_NEWCLASSUNLOCKED,false);
				this.levelUpEffect(TextKey.PLAYER_LEVELUP);
			} else {
				this.levelUpEffect(TextKey.PLAYER_LEVELUP);
			}
		}
		
		public function levelUpParticleEffect(param1:uint = 4.27825536E9) : void {
			map_.addObj(new LevelUpEffect(this,param1,20),x_,y_);
		}
		
		public function handleExpUp(param1:int) : void {
			if(level_ == 20 && !this.bForceExp()) {
				return;
			}
			var loc2:CharacterStatusText = new CharacterStatusText(this,65280,1000);
			loc2.setStringBuilder(new LineBuilder().setParams("+{exp} EXP",{"exp":param1}));
			map_.mapOverlay_.addStatusText(loc2);
		}
		
		private function bForceExp() : Boolean {
			return Parameters.data_.forceEXP && (Parameters.data_.forceEXP == 1 || Parameters.data_.forceEXP == 2 && map_.player_ == this);
		}
		
		public function updateFame(param1:int) : void {
			var loc2:CharacterStatusText = new CharacterStatusText(this,14835456,2000);
			loc2.setStringBuilder(new LineBuilder().setParams("+{fame} Fame",{"fame":param1}));
			map_.mapOverlay_.addStatusText(loc2);
		}
		
		private function getNearbyMerchant() : Merchant {
			var loc3:Point = null;
			var loc4:Merchant = null;
			var loc1:int = x_ - int(x_) > 0.5?1:-1;
			var loc2:int = y_ - int(y_) > 0.5?1:-1;
			for each(loc3 in NEARBY) {
				this.ip_.x_ = x_ + loc1 * loc3.x;
				this.ip_.y_ = y_ + loc2 * loc3.y;
				loc4 = map_.merchLookup_[this.ip_];
				if(loc4 != null) {
					return PointUtil.distanceSquaredXY(loc4.x_,loc4.y_,x_,y_) < 1?loc4:null;
				}
			}
			return null;
		}
		
		public function walkTo(param1:Number, param2:Number) : Boolean {
			this.modifyMove(param1,param2,newP);
			return this.moveTo(newP.x,newP.y);
		}
		
		override public function moveTo(param1:Number, param2:Number) : Boolean {
			var loc3:Boolean = super.moveTo(param1,param2);
			if(map_.gs_.evalIsNotInCombatMapArea()) {
				this.nearestMerchant_ = this.getNearbyMerchant();
			}
			return loc3;
		}
		
		public function modifyMove(param1:Number, param2:Number, param3:Point) : void {
			if(isParalyzed() || isPetrified()) {
				param3.x = x_;
				param3.y = y_;
				return;
			}
			var loc4:Number = param1 - x_;
			var loc5:Number = param2 - y_;
			if(loc4 < MOVE_THRESHOLD && loc4 > -MOVE_THRESHOLD && loc5 < MOVE_THRESHOLD && loc5 > -MOVE_THRESHOLD) {
				this.modifyStep(param1,param2,param3);
				return;
			}
			var loc6:Number = MOVE_THRESHOLD / Math.max(Math.abs(loc4),Math.abs(loc5));
			var loc7:Number = 0;
			param3.x = x_;
			param3.y = y_;
			var loc8:Boolean = false;
			while(!loc8) {
				if(loc7 + loc6 >= 1) {
					loc6 = 1 - loc7;
					loc8 = true;
				}
				this.modifyStep(param3.x + loc4 * loc6,param3.y + loc5 * loc6,param3);
				loc7 = loc7 + loc6;
			}
		}
		
		public function modifyStep(param1:Number, param2:Number, param3:Point) : void {
			var loc6:Number = NaN;
			var loc7:Number = NaN;
			var loc4:Boolean = x_ % 0.5 == 0 && param1 != x_ || int(x_ / 0.5) != int(param1 / 0.5);
			var loc5:Boolean = y_ % 0.5 == 0 && param2 != y_ || int(y_ / 0.5) != int(param2 / 0.5);
			if(!loc4 && !loc5 || this.isValidPosition(param1,param2)) {
				param3.x = param1;
				param3.y = param2;
				return;
			}
			if(loc4) {
				loc6 = param1 > x_?Number(int(param1 * 2) / 2):Number(int(x_ * 2) / 2);
				if(int(loc6) > int(x_)) {
					loc6 = loc6 - 0.01;
				}
			}
			if(loc5) {
				loc7 = param2 > y_?Number(int(param2 * 2) / 2):Number(int(y_ * 2) / 2);
				if(int(loc7) > int(y_)) {
					loc7 = loc7 - 0.01;
				}
			}
			if(!loc4) {
				param3.x = param1;
				param3.y = loc7;
				if(square_ != null && square_.props_.slideAmount_ != 0) {
					this.resetMoveVector(false);
				}
				return;
			}
			if(!loc5) {
				param3.x = loc6;
				param3.y = param2;
				if(square_ != null && square_.props_.slideAmount_ != 0) {
					this.resetMoveVector(true);
				}
				return;
			}
			var loc8:Number = param1 > x_?Number(param1 - loc6):Number(loc6 - param1);
			var loc9:Number = param2 > y_?Number(param2 - loc7):Number(loc7 - param2);
			if(loc8 > loc9) {
				if(this.isValidPosition(param1,loc7)) {
					param3.x = param1;
					param3.y = loc7;
					return;
				}
				if(this.isValidPosition(loc6,param2)) {
					param3.x = loc6;
					param3.y = param2;
					return;
				}
			} else {
				if(this.isValidPosition(loc6,param2)) {
					param3.x = loc6;
					param3.y = param2;
					return;
				}
				if(this.isValidPosition(param1,loc7)) {
					param3.x = param1;
					param3.y = loc7;
					return;
				}
			}
			param3.x = loc6;
			param3.y = loc7;
		}
		
		private function resetMoveVector(param1:Boolean) : void {
			moveVec_.scaleBy(-0.5);
			if(param1) {
				moveVec_.y = moveVec_.y * -1;
			} else {
				moveVec_.x = moveVec_.x * -1;
			}
		}
		
		public function isValidPosition(param1:Number, param2:Number) : Boolean {
			var loc3:Square = map_.getSquare(param1,param2);
			if(square_ != loc3 && (loc3 == null || !loc3.isWalkable())) {
				return false;
			}
			var loc4:Number = param1 - int(param1);
			var loc5:Number = param2 - int(param2);
			if(loc4 < 0.5) {
				if(this.isFullOccupy(param1 - 1,param2)) {
					return false;
				}
				if(loc5 < 0.5) {
					if(this.isFullOccupy(param1,param2 - 1) || this.isFullOccupy(param1 - 1,param2 - 1)) {
						return false;
					}
				} else if(loc5 > 0.5) {
					if(this.isFullOccupy(param1,param2 + 1) || this.isFullOccupy(param1 - 1,param2 + 1)) {
						return false;
					}
				}
			} else if(loc4 > 0.5) {
				if(this.isFullOccupy(param1 + 1,param2)) {
					return false;
				}
				if(loc5 < 0.5) {
					if(this.isFullOccupy(param1,param2 - 1) || this.isFullOccupy(param1 + 1,param2 - 1)) {
						return false;
					}
				} else if(loc5 > 0.5) {
					if(this.isFullOccupy(param1,param2 + 1) || this.isFullOccupy(param1 + 1,param2 + 1)) {
						return false;
					}
				}
			} else if(loc5 < 0.5) {
				if(this.isFullOccupy(param1,param2 - 1)) {
					return false;
				}
			} else if(loc5 > 0.5) {
				if(this.isFullOccupy(param1,param2 + 1)) {
					return false;
				}
			}
			return true;
		}
		
		public function isFullOccupy(param1:Number, param2:Number) : Boolean {
			var loc3:Square = map_.lookupSquare(param1,param2);
			return loc3 == null || loc3.tileType_ == 255 || loc3.obj_ != null && loc3.obj_.props_.fullOccupy_;
		}
		
		override public function update(param1:int, param2:int) : Boolean {
			var loc3:Number = NaN;
			var loc4:Number = NaN;
			var loc5:Number = NaN;
			var loc6:Vector3D = null;
			var loc7:Number = NaN;
			var loc8:int = 0;
			var loc9:Vector.<uint> = null;
			if(this.tierBoost && !isPaused()) {
				this.tierBoost = this.tierBoost - param2;
				if(this.tierBoost < 0) {
					this.tierBoost = 0;
				}
			}
			if(this.dropBoost && !isPaused()) {
				this.dropBoost = this.dropBoost - param2;
				if(this.dropBoost < 0) {
					this.dropBoost = 0;
				}
			}
			if(this.xpTimer && !isPaused()) {
				this.xpTimer = this.xpTimer - param2;
				if(this.xpTimer < 0) {
					this.xpTimer = 0;
				}
			}
			if(isHealing() && !isPaused()) {
				if(!Parameters.data_.noParticlesMaster && this.healingEffect_ == null) {
					this.healingEffect_ = new HealingEffect(this);
					map_.addObj(this.healingEffect_,x_,y_);
				}
			} else if(this.healingEffect_ != null) {
				map_.removeObj(this.healingEffect_.objectId_);
				this.healingEffect_ = null;
			}
			if(map_.player_ == this && isPaused()) {
				return true;
			}
			if(this.relMoveVec_ != null) {
				loc3 = Parameters.data_.cameraAngle;
				if(this.rotate_ != 0) {
					loc3 = loc3 + param2 * Parameters.PLAYER_ROTATE_SPEED * this.rotate_;
					Parameters.data_.cameraAngle = loc3;
				}
				if(this.relMoveVec_.x != 0 || this.relMoveVec_.y != 0) {
					loc4 = this.getMoveSpeed();
					loc5 = Math.atan2(this.relMoveVec_.y,this.relMoveVec_.x);
					if(square_.props_.slideAmount_ > 0) {
						loc6 = new Vector3D();
						loc6.x = loc4 * Math.cos(loc3 + loc5);
						loc6.y = loc4 * Math.sin(loc3 + loc5);
						loc6.z = 0;
						loc7 = loc6.length;
						loc6.scaleBy(-1 * (square_.props_.slideAmount_ - 1));
						moveVec_.scaleBy(square_.props_.slideAmount_);
						if(moveVec_.length < loc7) {
							moveVec_ = moveVec_.add(loc6);
						}
					} else {
						moveVec_.x = loc4 * Math.cos(loc3 + loc5);
						moveVec_.y = loc4 * Math.sin(loc3 + loc5);
					}
				} else if(moveVec_.length > 0.00012 && square_.props_.slideAmount_ > 0) {
					moveVec_.scaleBy(square_.props_.slideAmount_);
				} else {
					moveVec_.x = 0;
					moveVec_.y = 0;
				}
				if(square_ != null && square_.props_.push_) {
					moveVec_.x = moveVec_.x - square_.props_.animate_.dx_ / 1000;
					moveVec_.y = moveVec_.y - square_.props_.animate_.dy_ / 1000;
				}
				this.walkTo(x_ + param2 * moveVec_.x,y_ + param2 * moveVec_.y);
			} else if(!super.update(param1,param2)) {
				return false;
			}
			if(map_.player_ == this && square_.props_.maxDamage_ > 0 && square_.lastDamage_ + 500 < param1 && !isInvincible() && (square_.obj_ == null || !square_.obj_.props_.protectFromGroundDamage_)) {
				loc8 = map_.gs_.gsc_.getNextDamage(square_.props_.minDamage_,square_.props_.maxDamage_);
				loc9 = new Vector.<uint>();
				loc9.push(ConditionEffect.GROUND_DAMAGE);
				damage(true,loc8,loc9,hp_ <= loc8,null);
				map_.gs_.gsc_.groundDamage(param1,x_,y_);
				square_.lastDamage_ = param1;
			}
			return true;
		}
		
		public function onMove() : void {
			if(map_ == null) {
				return;
			}
			var loc1:Square = map_.getSquare(x_,y_);
			if(loc1.props_.sinking_) {
				sinkLevel_ = Math.min(sinkLevel_ + 1,Parameters.MAX_SINK_LEVEL);
				this.moveMultiplier_ = 0.1 + (1 - sinkLevel_ / Parameters.MAX_SINK_LEVEL) * (loc1.props_.speed_ - 0.1);
			} else {
				sinkLevel_ = 0;
				this.moveMultiplier_ = loc1.props_.speed_;
			}
		}
		
		override protected function makeNameBitmapData() : BitmapData {
			var loc1:StringBuilder = new StaticStringBuilder(name_);
			var loc2:BitmapTextFactory = StaticInjectorContext.getInjector().getInstance(BitmapTextFactory);
			var loc3:BitmapData = loc2.make(loc1,16,this.getNameColor(),true,NAME_OFFSET_MATRIX,true);
			loc3.draw(FameUtil.numStarsToIcon(this.numStars_),RANK_OFFSET_MATRIX);
			return loc3;
		}
		
		private function getNameColor() : uint {
			return PlayerUtil.getPlayerNameColor(this);
		}
		
		protected function drawBreathBar(param1:Vector.<IGraphicsData>, param2:int) : void {
			var loc8:Number = NaN;
			var loc9:Number = NaN;
			if(this.breathPath_ == null) {
				this.breathBackFill_ = new GraphicsSolidFill();
				this.breathBackPath_ = new GraphicsPath(GraphicsUtil.QUAD_COMMANDS,new Vector.<Number>());
				this.breathFill_ = new GraphicsSolidFill(2542335);
				this.breathPath_ = new GraphicsPath(GraphicsUtil.QUAD_COMMANDS,new Vector.<Number>());
			}
			if(this.breath_ <= Parameters.BREATH_THRESH) {
				loc8 = (Parameters.BREATH_THRESH - this.breath_) / Parameters.BREATH_THRESH;
				this.breathBackFill_.color = MoreColorUtil.lerpColor(1118481,16711680,Math.abs(Math.sin(param2 / 300)) * loc8);
			} else {
				this.breathBackFill_.color = 1118481;
			}
			var loc3:int = 20;
			var loc4:int = 12;
			var loc5:int = 5;
			var loc6:Vector.<Number> = this.breathBackPath_.data as Vector.<Number>;
			loc6.length = 0;
			var loc7:Number = 1.2;
			loc6.push(posS_[0] - loc3 - loc7,posS_[1] + loc4,posS_[0] + loc3 + loc7,posS_[1] + loc4,posS_[0] + loc3 + loc7,posS_[1] + loc4 + loc5 + loc7,posS_[0] - loc3 - loc7,posS_[1] + loc4 + loc5 + loc7);
			param1.push(this.breathBackFill_);
			param1.push(this.breathBackPath_);
			param1.push(GraphicsUtil.END_FILL);
			if(this.breath_ > 0) {
				loc9 = this.breath_ / 100 * 2 * loc3;
				this.breathPath_.data.length = 0;
				loc6 = this.breathPath_.data as Vector.<Number>;
				loc6.length = 0;
				loc6.push(posS_[0] - loc3,posS_[1] + loc4,posS_[0] - loc3 + loc9,posS_[1] + loc4,posS_[0] - loc3 + loc9,posS_[1] + loc4 + loc5,posS_[0] - loc3,posS_[1] + loc4 + loc5);
				param1.push(this.breathFill_);
				param1.push(this.breathPath_);
				param1.push(GraphicsUtil.END_FILL);
			}
			GraphicsFillExtra.setSoftwareDrawSolid(this.breathFill_,true);
			GraphicsFillExtra.setSoftwareDrawSolid(this.breathBackFill_,true);
		}
		
		override public function draw(param1:Vector.<IGraphicsData>, param2:Camera, param3:int) : void {
			super.draw(param1,param2,param3);
			if(this != map_.player_) {
				if(!Parameters.screenShotMode_) {
					drawName(param1,param2);
				}
			} else if(this.breath_ >= 0) {
				this.drawBreathBar(param1,param3);
			}
		}
		
		private function getMoveSpeed() : Number {
			if(isSlowed()) {
				return MIN_MOVE_SPEED * this.moveMultiplier_;
			}
			var loc1:Number = MIN_MOVE_SPEED + this.speed_ / 75 * (MAX_MOVE_SPEED - MIN_MOVE_SPEED);
			if(isSpeedy() || isNinjaSpeedy()) {
				loc1 = loc1 * 1.5;
			}
			loc1 = loc1 * this.moveMultiplier_;
			return loc1;
		}
		
		public function attackFrequency() : Number {
			if(isDazed()) {
				return MIN_ATTACK_FREQ;
			}
			var loc1:Number = MIN_ATTACK_FREQ + this.dexterity_ / 75 * (MAX_ATTACK_FREQ - MIN_ATTACK_FREQ);
			if(isBerserk()) {
				loc1 = loc1 * 1.5;
			}
			return loc1;
		}
		
		private function attackMultiplier() : Number {
			if(isWeak()) {
				return MIN_ATTACK_MULT;
			}
			var loc1:Number = MIN_ATTACK_MULT + this.attack_ / 75 * (MAX_ATTACK_MULT - MIN_ATTACK_MULT);
			if(isDamaging()) {
				loc1 = loc1 * 1.5;
			}
			return loc1;
		}
		
		private function makeSkinTexture() : void {
			var loc1:MaskedImage = this.skin.imageFromAngle(0,AnimatedChar.STAND,0);
			animatedChar_ = this.skin;
			texture_ = loc1.image_;
			mask_ = loc1.mask_;
			this.isDefaultAnimatedChar = true;
		}
		
		private function setToRandomAnimatedCharacter() : void {
			var loc1:Vector.<XML> = ObjectLibrary.hexTransforms_;
			var loc2:uint = Math.floor(Math.random() * loc1.length);
			var loc3:int = loc1[loc2].@type;
			var loc4:TextureData = ObjectLibrary.typeToTextureData_[loc3];
			texture_ = loc4.texture_;
			mask_ = loc4.mask_;
			animatedChar_ = loc4.animatedChar_;
			this.isDefaultAnimatedChar = false;
		}
		
		override protected function getTexture(param1:Camera, param2:int) : BitmapData {
			var loc5:MaskedImage = null;
			var loc10:int = 0;
			var loc11:Dictionary = null;
			var loc12:Number = NaN;
			var loc13:int = 0;
			var loc14:ColorTransform = null;
			var loc3:Number = 0;
			var loc4:int = AnimatedChar.STAND;
			if(this.isShooting || param2 < attackStart_ + this.attackPeriod_) {
				facing_ = attackAngle_;
				loc3 = (param2 - attackStart_) % this.attackPeriod_ / this.attackPeriod_;
				loc4 = AnimatedChar.ATTACK;
			} else if(moveVec_.x != 0 || moveVec_.y != 0) {
				loc10 = 3.5 / this.getMoveSpeed();
				if(moveVec_.y != 0 || moveVec_.x != 0) {
					facing_ = Math.atan2(moveVec_.y,moveVec_.x);
				}
				loc3 = param2 % loc10 / loc10;
				loc4 = AnimatedChar.WALK;
			}
			if(this.isHexed()) {
				this.isDefaultAnimatedChar && this.setToRandomAnimatedCharacter();
			} else if(!this.isDefaultAnimatedChar) {
				this.makeSkinTexture();
			}
			if(param1.isHallucinating_) {
				loc5 = new MaskedImage(getHallucinatingTexture(),null);
			} else {
				loc5 = animatedChar_.imageFromFacing(facing_,param1,loc4,loc3);
			}
			var loc6:int = tex1Id_;
			var loc7:int = tex2Id_;
			var loc8:BitmapData = null;
			if(this.nearestMerchant_) {
				loc11 = texturingCache_[this.nearestMerchant_];
				if(loc11 == null) {
					texturingCache_[this.nearestMerchant_] = new Dictionary();
				} else {
					loc8 = loc11[loc5];
				}
				loc6 = this.nearestMerchant_.getTex1Id(tex1Id_);
				loc7 = this.nearestMerchant_.getTex2Id(tex2Id_);
			} else {
				loc8 = texturingCache_[loc5];
			}
			if(loc8 == null) {
				loc8 = TextureRedrawer.resize(loc5.image_,loc5.mask_,size_,false,loc6,loc7);
				if(this.nearestMerchant_ != null) {
					texturingCache_[this.nearestMerchant_][loc5] = loc8;
				} else {
					texturingCache_[loc5] = loc8;
				}
			}
			if(hp_ < maxHP_ * 0.2) {
				loc12 = int(Math.abs(Math.sin(param2 / 200)) * 10) / 10;
				loc13 = 128;
				loc14 = new ColorTransform(1,1,1,1,loc12 * loc13,-loc12 * loc13,-loc12 * loc13);
				loc8 = CachingColorTransformer.transformBitmapData(loc8,loc14);
			}
			var loc9:BitmapData = texturingCache_[loc8];
			if(loc9 == null) {
				if(this.hasSupporterFeature(SupporterFeatures.GLOW)) {
					loc9 = GlowRedrawer.outlineGlow(loc8,SupporterCampaignModel.SUPPORT_COLOR,1.4,false,0,true);
				} else {
					loc9 = GlowRedrawer.outlineGlow(loc8,this.legendaryRank_ == -1?uint(0):uint(16711680));
				}
				texturingCache_[loc8] = loc9;
			}
			if(isPaused() || isStasis() || isPetrified()) {
				loc9 = CachingColorTransformer.filterBitmapData(loc9,PAUSED_FILTER);
			} else if(isInvisible()) {
				loc9 = CachingColorTransformer.alphaBitmapData(loc9,0.4);
			}
			return loc9;
		}
		
		override public function getPortrait() : BitmapData {
			var loc1:MaskedImage = null;
			var loc2:int = 0;
			if(portrait_ == null) {
				loc1 = animatedChar_.imageFromDir(AnimatedChar.RIGHT,AnimatedChar.STAND,0);
				loc2 = 4 / loc1.image_.width * 100;
				portrait_ = TextureRedrawer.resize(loc1.image_,loc1.mask_,loc2,true,tex1Id_,tex2Id_);
				portrait_ = GlowRedrawer.outlineGlow(portrait_,0);
			}
			return portrait_;
		}
		
		public function getFamePortrait(param1:int) : BitmapData {
			var loc2:MaskedImage = null;
			if(this.famePortrait_ == null) {
				loc2 = animatedChar_.imageFromDir(AnimatedChar.RIGHT,AnimatedChar.STAND,0);
				param1 = 4 / loc2.image_.width * param1;
				this.famePortrait_ = TextureRedrawer.resize(loc2.image_,loc2.mask_,param1,true,tex1Id_,tex2Id_);
				this.famePortrait_ = GlowRedrawer.outlineGlow(this.famePortrait_,0);
			}
			return this.famePortrait_;
		}
		
		public function useAltWeapon(param1:Number, param2:Number, param3:int) : Boolean {
			var loc7:Point = null;
			var loc12:int = 0;
			var loc13:XML = null;
			var loc14:String = null;
			var loc15:Number = NaN;
			var loc16:Point = null;
			var loc17:Number = NaN;
			var loc18:Number = NaN;
			var loc19:Point = null;
			var loc20:ProjectileProperties = null;
			var loc21:Number = NaN;
			var loc22:Number = NaN;
			var loc23:Point = null;
			var loc24:Number = NaN;
			var loc25:int = 0;
			if(map_ == null || isPaused()) {
				return false;
			}
			var loc4:int = equipment_[1];
			if(loc4 == -1) {
				return false;
			}
			var loc5:XML = ObjectLibrary.xmlLibrary_[loc4];
			if(loc5 == null || !loc5.hasOwnProperty("Usable")) {
				return false;
			}
			if(isSilenced()) {
				SoundEffectLibrary.play("error");
				return false;
			}
			var loc6:Number = Parameters.data_.cameraAngle + Math.atan2(param2,param1);
			var loc8:Boolean = false;
			var loc9:Boolean = false;
			var loc10:Boolean = false;
			if(param3 == UseType.START_USE) {
				for each(loc13 in loc5.Activate) {
					loc14 = loc13.toString();
					if(loc14 == ActivationType.TELEPORT_LIMIT) {
						loc15 = loc13.@maxDistance;
						loc16 = new Point(x_ + loc15 * Math.cos(loc6),y_ + loc15 * Math.sin(loc6));
						if(!this.isValidPosition(loc16.x,loc16.y)) {
							SoundEffectLibrary.play("error");
							return false;
						}
					}
					if(loc14 == ActivationType.TELEPORT || loc14 == ActivationType.OBJECT_TOSS) {
						loc8 = true;
						loc10 = true;
					}
					if(loc14 == ActivationType.BULLET_NOVA || loc14 == ActivationType.POISON_GRENADE || loc14 == ActivationType.VAMPIRE_BLAST || loc14 == ActivationType.TRAP || loc14 == ActivationType.STASIS_BLAST) {
						loc8 = true;
					}
					if(loc14 == ActivationType.SHOOT) {
						loc9 = true;
					}
					if(loc14 == ActivationType.BULLET_CREATE) {
						loc17 = Math.sqrt(param1 * param1 + param2 * param2) / 50;
						loc18 = Math.max(this.getAttribute(loc13,"minDistance",0),Math.min(this.getAttribute(loc13,"maxDistance",4.4),loc17));
						loc19 = new Point(x_ + loc18 * Math.cos(loc6),y_ + loc18 * Math.sin(loc6));
						loc20 = ObjectLibrary.propsLibrary_[loc4].projectiles_[0];
						loc21 = loc20.speed_ * loc20.lifetime_ / 20000;
						loc22 = loc6 + this.getAttribute(loc13,"offsetAngle",90) * MathUtil.TO_RAD;
						loc23 = new Point(loc19.x + loc21 * Math.cos(loc22 + Math.PI),loc19.y + loc21 * Math.sin(loc22 + Math.PI));
						if(this.isFullOccupy(loc23.x + 0.5,loc23.y + 0.5)) {
							SoundEffectLibrary.play("error");
							return false;
						}
					}
				}
			}
			if(loc8) {
				loc7 = map_.pSTopW(param1,param2);
				if(loc7 == null || loc10 && !this.isValidPosition(loc7.x,loc7.y)) {
					SoundEffectLibrary.play("error");
					return false;
				}
			} else {
				loc24 = Math.sqrt(param1 * param1 + param2 * param2) / 50;
				loc7 = new Point(x_ + loc24 * Math.cos(loc6),y_ + loc24 * Math.sin(loc6));
			}
			var loc11:int = getTimer();
			if(param3 == UseType.START_USE) {
				if(loc11 < this.nextAltAttack_) {
					SoundEffectLibrary.play("error");
					return false;
				}
				loc12 = int(loc5.MpCost);
				if(loc12 > this.mp_) {
					SoundEffectLibrary.play("no_mana");
					return false;
				}
				loc25 = 500;
				if(loc5.hasOwnProperty("Cooldown")) {
					loc25 = Number(loc5.Cooldown) * 1000;
				}
				this.nextAltAttack_ = loc11 + loc25;
				map_.gs_.gsc_.useItem(loc11,objectId_,1,loc4,loc7.x,loc7.y,param3);
				if(loc9) {
					this.doShoot(loc11,loc4,loc5,loc6,false);
				}
			} else if(loc5.hasOwnProperty("MultiPhase")) {
				map_.gs_.gsc_.useItem(loc11,objectId_,1,loc4,loc7.x,loc7.y,param3);
				loc12 = int(loc5.MpEndCost);
				if(loc12 <= this.mp_) {
					this.doShoot(loc11,loc4,loc5,loc6,false);
				}
			}
			return true;
		}
		
		public function getAttribute(param1:XML, param2:String, param3:Number = 0) : Number {
			return !!param1.hasOwnProperty("@" + param2)?Number(param1[param2]):Number(param3);
		}
		
		public function attemptAttackAngle(param1:Number) : void {
			this.shoot(Parameters.data_.cameraAngle + param1);
		}
		
		override public function setAttack(param1:int, param2:Number) : void {
			var loc3:XML = ObjectLibrary.xmlLibrary_[param1];
			if(loc3 == null || !loc3.hasOwnProperty("RateOfFire")) {
				return;
			}
			var loc4:Number = Number(loc3.RateOfFire);
			this.attackPeriod_ = 1 / this.attackFrequency() * (1 / loc4);
			super.setAttack(param1,param2);
		}
		
		private function shoot(param1:Number) : void {
			if(map_ == null || isStunned() || isPaused() || isPetrified()) {
				return;
			}
			var loc2:int = equipment_[0];
			if(loc2 == -1) {
				this.addTextLine.dispatch(ChatMessage.make(Parameters.ERROR_CHAT_NAME,TextKey.PLAYER_NO_WEAPON_EQUIPPED));
				return;
			}
			var loc3:XML = ObjectLibrary.xmlLibrary_[loc2];
			var loc4:int = getTimer();
			var loc5:Number = Number(loc3.RateOfFire);
			this.attackPeriod_ = 1 / this.attackFrequency() * (1 / loc5);
			if(loc4 < attackStart_ + this.attackPeriod_) {
				return;
			}
			doneAction(map_.gs_,Tutorial.ATTACK_ACTION);
			attackAngle_ = param1;
			attackStart_ = loc4;
			this.doShoot(attackStart_,loc2,loc3,attackAngle_,true);
		}
		
		private function doShoot(param1:int, param2:int, param3:XML, param4:Number, param5:Boolean) : void {
			var loc11:uint = 0;
			var loc12:Projectile = null;
			var loc13:int = 0;
			var loc14:int = 0;
			var loc15:Number = NaN;
			var loc16:int = 0;
			var loc6:int = !!param3.hasOwnProperty("NumProjectiles")?int(int(param3.NumProjectiles)):1;
			var loc7:Number = (!!param3.hasOwnProperty("ArcGap")?Number(param3.ArcGap):11.25) * Trig.toRadians;
			var loc8:Number = loc7 * (loc6 - 1);
			var loc9:Number = param4 - loc8 / 2;
			this.isShooting = param5;
			var loc10:int = 0;
			while(loc10 < loc6) {
				loc11 = getBulletId();
				loc12 = FreeList.newObject(Projectile) as Projectile;
				if(param5 && this.projectileIdSetOverrideNew != "") {
					loc12.reset(param2,0,objectId_,loc11,loc9,param1,this.projectileIdSetOverrideNew,this.projectileIdSetOverrideOld);
				} else {
					loc12.reset(param2,0,objectId_,loc11,loc9,param1);
				}
				loc13 = int(loc12.projProps_.minDamage_);
				loc14 = int(loc12.projProps_.maxDamage_);
				loc15 = !!param5?Number(this.attackMultiplier()):Number(1);
				loc16 = map_.gs_.gsc_.getNextDamage(loc13,loc14) * loc15;
				if(param1 > map_.gs_.moveRecords_.lastClearTime_ + 600) {
					loc16 = 0;
				}
				loc12.setDamage(loc16);
				if(loc10 == 0 && loc12.sound_ != null) {
					SoundEffectLibrary.play(loc12.sound_,0.75,false);
				}
				map_.addObj(loc12,x_ + Math.cos(param4) * 0.3,y_ + Math.sin(param4) * 0.3);
				map_.gs_.gsc_.playerShoot(param1,loc12);
				loc9 = loc9 + loc7;
				loc10++;
			}
		}
		
		public function isHexed() : Boolean {
			return (condition_[ConditionEffect.CE_FIRST_BATCH] & ConditionEffect.HEXED_BIT) != 0;
		}
		
		public function isInventoryFull() : Boolean {
			if(equipment_ == null) {
				return false;
			}
			var loc1:int = equipment_.length;
			var loc2:uint = 4;
			while(loc2 < loc1) {
				if(equipment_[loc2] <= 0) {
					return false;
				}
				loc2++;
			}
			return true;
		}
		
		public function nextAvailableInventorySlot() : int {
			var loc1:int = !!this.hasBackpack_?int(equipment_.length):int(equipment_.length - GeneralConstants.NUM_INVENTORY_SLOTS);
			var loc2:uint = 4;
			while(loc2 < loc1) {
				if(equipment_[loc2] <= 0) {
					return loc2;
				}
				loc2++;
			}
			return -1;
		}
		
		public function numberOfAvailableSlots() : int {
			var loc1:int = !!this.hasBackpack_?int(equipment_.length):int(equipment_.length - GeneralConstants.NUM_INVENTORY_SLOTS);
			var loc2:int = 0;
			var loc3:uint = 4;
			while(loc3 < loc1) {
				if(equipment_[loc3] <= 0) {
					loc2++;
				}
				loc3++;
			}
			return loc2;
		}
		
		public function swapInventoryIndex(param1:String) : int {
			var loc2:int = 0;
			var loc3:int = 0;
			if(!this.hasBackpack_) {
				return -1;
			}
			if(param1 == TabStripModel.BACKPACK) {
				loc2 = GeneralConstants.NUM_EQUIPMENT_SLOTS;
				loc3 = GeneralConstants.NUM_EQUIPMENT_SLOTS + GeneralConstants.NUM_INVENTORY_SLOTS;
			} else {
				loc2 = GeneralConstants.NUM_EQUIPMENT_SLOTS + GeneralConstants.NUM_INVENTORY_SLOTS;
				loc3 = equipment_.length;
			}
			var loc4:uint = loc2;
			while(loc4 < loc3) {
				if(equipment_[loc4] <= 0) {
					return loc4;
				}
				loc4++;
			}
			return -1;
		}
		
		public function getPotionCount(param1:int) : int {
			switch(param1) {
				case PotionInventoryModel.HEALTH_POTION_ID:
					return this.healthPotionCount_;
				case PotionInventoryModel.MAGIC_POTION_ID:
					return this.magicPotionCount_;
				default:
					return 0;
			}
		}
		
		public function getTex1() : int {
			return tex1Id_;
		}
		
		public function getTex2() : int {
			return tex2Id_;
		}
	}
}
