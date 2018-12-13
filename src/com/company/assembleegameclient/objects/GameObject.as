 
package com.company.assembleegameclient.objects {
	import com.company.assembleegameclient.engine3d.Model3D;
	import com.company.assembleegameclient.engine3d.Object3D;
	import com.company.assembleegameclient.map.Camera;
	import com.company.assembleegameclient.map.Map;
	import com.company.assembleegameclient.map.Square;
	import com.company.assembleegameclient.map.mapoverlay.CharacterStatusText;
	import com.company.assembleegameclient.objects.animation.Animations;
	import com.company.assembleegameclient.objects.animation.AnimationsData;
	import com.company.assembleegameclient.objects.particles.ExplosionEffect;
	import com.company.assembleegameclient.objects.particles.HitEffect;
	import com.company.assembleegameclient.objects.particles.ParticleEffect;
	import com.company.assembleegameclient.objects.particles.ShockerEffect;
	import com.company.assembleegameclient.parameters.Parameters;
	import com.company.assembleegameclient.sound.SoundEffectLibrary;
	import com.company.assembleegameclient.util.AnimatedChar;
	import com.company.assembleegameclient.util.BloodComposition;
	import com.company.assembleegameclient.util.ConditionEffect;
	import com.company.assembleegameclient.util.MaskedImage;
	import com.company.assembleegameclient.util.TextureRedrawer;
	import com.company.assembleegameclient.util.redrawers.GlowRedrawer;
	import com.company.util.AssetLibrary;
	import com.company.util.BitmapUtil;
	import com.company.util.CachingColorTransformer;
	import com.company.util.ConversionUtil;
	import com.company.util.GraphicsUtil;
	import com.company.util.MoreColorUtil;
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.GraphicsBitmapFill;
	import flash.display.GraphicsGradientFill;
	import flash.display.GraphicsPath;
	import flash.display.GraphicsSolidFill;
	import flash.display.IGraphicsData;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	import io.decagames.rotmg.pets.data.PetsModel;
	import io.decagames.rotmg.pets.data.vo.PetVO;
	import kabam.rotmg.core.StaticInjectorContext;
	import kabam.rotmg.messaging.impl.data.WorldPosData;
	import kabam.rotmg.stage3D.GraphicsFillExtra;
	import kabam.rotmg.stage3D.Object3D.Object3DStage3D;
	import kabam.rotmg.text.model.TextKey;
	import kabam.rotmg.text.view.BitmapTextFactory;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;
	import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
	import kabam.rotmg.text.view.stringBuilder.StringBuilder;
	
	public class GameObject extends BasicObject {
		
		protected static const PAUSED_FILTER:ColorMatrixFilter = new ColorMatrixFilter(MoreColorUtil.greyscaleFilterMatrix);
		
		protected static const CURSED_FILTER:ColorMatrixFilter = new ColorMatrixFilter(MoreColorUtil.redFilterMatrix);
		
		protected static const IDENTITY_MATRIX:Matrix = new Matrix();
		
		private static const ZERO_LIMIT:Number = 0.00001;
		
		private static const NEGATIVE_ZERO_LIMIT:Number = -ZERO_LIMIT;
		
		public static const ATTACK_PERIOD:int = 300;
		
		private static const DEFAULT_HP_BAR_Y_OFFSET:int = 6;
		 
		
		public var nameBitmapData_:BitmapData = null;
		
		private var nameFill_:GraphicsBitmapFill = null;
		
		private var namePath_:GraphicsPath = null;
		
		public var shockEffect:ShockerEffect;
		
		private var isShocked:Boolean;
		
		private var isShockedTransformSet:Boolean = false;
		
		private var isCharging:Boolean;
		
		private var isChargingTransformSet:Boolean = false;
		
		public var props_:ObjectProperties;
		
		public var name_:String;
		
		public var radius_:Number = 0.5;
		
		public var facing_:Number = 0;
		
		public var flying_:Boolean = false;
		
		public var attackAngle_:Number = 0;
		
		public var attackStart_:int = 0;
		
		public var animatedChar_:AnimatedChar = null;
		
		public var texture_:BitmapData = null;
		
		public var mask_:BitmapData = null;
		
		public var randomTextureData_:Vector.<TextureData> = null;
		
		public var obj3D_:Object3D = null;
		
		public var object3d_:Object3DStage3D = null;
		
		public var effect_:ParticleEffect = null;
		
		public var animations_:Animations = null;
		
		public var dead_:Boolean = false;
		
		public var deadCounter_:uint = 0;
		
		protected var portrait_:BitmapData = null;
		
		protected var texturingCache_:Dictionary = null;
		
		public var maxHP_:int = 200;
		
		public var hp_:int = 200;
		
		public var size_:int = 100;
		
		public var level_:int = -1;
		
		public var defense_:int = 0;
		
		public var slotTypes_:Vector.<int> = null;
		
		public var equipment_:Vector.<int> = null;
		
		public var lockedSlot:Vector.<int> = null;
		
		public var condition_:Vector.<uint>;
		
		public var supporterPoints:int = 0;
		
		protected var tex1Id_:int = 0;
		
		protected var tex2Id_:int = 0;
		
		public var isInteractive_:Boolean = false;
		
		public var objectType_:int;
		
		private var nextBulletId_:uint = 1;
		
		private var sizeMult_:Number = 1;
		
		public var sinkLevel_:int = 0;
		
		public var hallucinatingTexture_:BitmapData = null;
		
		public var flash_:FlashDescription = null;
		
		public var connectType_:int = -1;
		
		private var isStunImmune_:Boolean = false;
		
		private var isParalyzeImmune_:Boolean = false;
		
		private var isDazedImmune_:Boolean = false;
		
		private var isStasisImmune_:Boolean = false;
		
		private var isInvincible_:Boolean = false;
		
		private var ishpScaleSet:Boolean = false;
		
		protected var lastTickUpdateTime_:int = 0;
		
		protected var myLastTickId_:int = -1;
		
		protected var posAtTick_:Point;
		
		protected var tickPosition_:Point;
		
		protected var moveVec_:Vector3D;
		
		protected var bitmapFill_:GraphicsBitmapFill;
		
		protected var path_:GraphicsPath;
		
		protected var vS_:Vector.<Number>;
		
		protected var uvt_:Vector.<Number>;
		
		protected var fillMatrix_:Matrix;
		
		private var hpbarBackFill_:GraphicsSolidFill = null;
		
		private var hpbarBackPath_:GraphicsPath = null;
		
		private var hpbarFill_:GraphicsSolidFill = null;
		
		private var hpbarPath_:GraphicsPath = null;
		
		private var icons_:Vector.<BitmapData> = null;
		
		private var iconFills_:Vector.<GraphicsBitmapFill> = null;
		
		private var iconPaths_:Vector.<GraphicsPath> = null;
		
		protected var shadowGradientFill_:GraphicsGradientFill = null;
		
		protected var shadowPath_:GraphicsPath = null;
		
		public function GameObject(param1:XML) {
			var loc4:int = 0;
			this.props_ = ObjectLibrary.defaultProps_;
			this.condition_ = new <uint>[0,0];
			this.posAtTick_ = new Point();
			this.tickPosition_ = new Point();
			this.moveVec_ = new Vector3D();
			this.bitmapFill_ = new GraphicsBitmapFill(null,null,false,false);
			this.path_ = new GraphicsPath(GraphicsUtil.QUAD_COMMANDS,null);
			this.vS_ = new Vector.<Number>();
			this.uvt_ = new Vector.<Number>();
			this.fillMatrix_ = new Matrix();
			super();
			if(param1 == null) {
				return;
			}
			this.objectType_ = int(param1.@type);
			this.props_ = ObjectLibrary.propsLibrary_[this.objectType_];
			hasShadow_ = this.props_.shadowSize_ > 0;
			var loc2:TextureData = ObjectLibrary.typeToTextureData_[this.objectType_];
			this.texture_ = loc2.texture_;
			this.mask_ = loc2.mask_;
			this.animatedChar_ = loc2.animatedChar_;
			this.randomTextureData_ = loc2.randomTextureData_;
			if(loc2.effectProps_ != null) {
				this.effect_ = ParticleEffect.fromProps(loc2.effectProps_,this);
			}
			if(this.texture_ != null) {
				this.sizeMult_ = this.texture_.height / 8;
			}
			if(param1.hasOwnProperty("Model")) {
				this.obj3D_ = Model3D.getObject3D(String(param1.Model));
				this.object3d_ = Model3D.getStage3dObject3D(String(param1.Model));
				if(this.texture_ != null) {
					this.object3d_.setBitMapData(this.texture_);
				}
			}
			var loc3:AnimationsData = ObjectLibrary.typeToAnimationsData_[this.objectType_];
			if(loc3 != null) {
				this.animations_ = new Animations(loc3);
			}
			z_ = this.props_.z_;
			this.flying_ = this.props_.flying_;
			if(param1.hasOwnProperty("MaxHitPoints")) {
				this.hp_ = this.maxHP_ = int(param1.MaxHitPoints);
			}
			if(param1.hasOwnProperty("Defense")) {
				this.defense_ = int(param1.Defense);
			}
			if(param1.hasOwnProperty("SlotTypes")) {
				this.slotTypes_ = ConversionUtil.toIntVector(param1.SlotTypes);
				this.equipment_ = new Vector.<int>(this.slotTypes_.length);
				loc4 = 0;
				while(loc4 < this.equipment_.length) {
					this.equipment_[loc4] = -1;
					loc4++;
				}
				this.lockedSlot = new Vector.<int>(this.slotTypes_.length);
			}
			if(param1.hasOwnProperty("Tex1")) {
				this.tex1Id_ = int(param1.Tex1);
			}
			if(param1.hasOwnProperty("Tex2")) {
				this.tex2Id_ = int(param1.Tex2);
			}
			if(param1.hasOwnProperty("StunImmune")) {
				this.isStunImmune_ = true;
			}
			if(param1.hasOwnProperty("ParalyzeImmune")) {
				this.isParalyzeImmune_ = true;
			}
			if(param1.hasOwnProperty("DazedImmune")) {
				this.isDazedImmune_ = true;
			}
			if(param1.hasOwnProperty("StasisImmune")) {
				this.isStasisImmune_ = true;
			}
			if(param1.hasOwnProperty("Invincible")) {
				this.isInvincible_ = true;
			}
			this.props_.loadSounds();
		}
		
		public static function damageWithDefense(param1:int, param2:int, param3:Boolean, param4:Vector.<uint>) : int {
			var loc5:int = param2;
			if(param3 || (param4[ConditionEffect.CE_FIRST_BATCH] & ConditionEffect.ARMORBROKEN_BIT) != 0) {
				loc5 = 0;
			} else if((param4[ConditionEffect.CE_FIRST_BATCH] & ConditionEffect.ARMORED_BIT) != 0) {
				loc5 = loc5 * 2;
			}
			if((param4[ConditionEffect.CE_SECOND_BATCH] & ConditionEffect.EXPOSED_BIT) != 0) {
				loc5 = loc5 - 20;
			}
			var loc6:int = param1 * 3 / 20;
			var loc7:int = Math.max(loc6,param1 - loc5);
			if((param4[ConditionEffect.CE_FIRST_BATCH] & ConditionEffect.INVULNERABLE_BIT) != 0) {
				loc7 = 0;
			}
			if((param4[ConditionEffect.CE_SECOND_BATCH] & ConditionEffect.PETRIFIED_BIT) != 0) {
				loc7 = loc7 * 0.9;
			}
			if((param4[ConditionEffect.CE_SECOND_BATCH] & ConditionEffect.CURSE_BIT) != 0) {
				loc7 = loc7 * 1.2;
			}
			return loc7;
		}
		
		public function setObjectId(param1:int) : void {
			var loc2:TextureData = null;
			objectId_ = param1;
			if(this.randomTextureData_ != null) {
				loc2 = this.randomTextureData_[objectId_ % this.randomTextureData_.length];
				this.texture_ = loc2.texture_;
				this.mask_ = loc2.mask_;
				this.animatedChar_ = loc2.animatedChar_;
				if(this.object3d_ != null) {
					this.object3d_.setBitMapData(this.texture_);
				}
			}
		}
		
		public function setTexture(param1:int) : void {
			var loc2:TextureData = ObjectLibrary.typeToTextureData_[param1];
			this.texture_ = loc2.texture_;
			this.mask_ = loc2.mask_;
			this.animatedChar_ = loc2.animatedChar_;
		}
		
		public function setAltTexture(param1:int) : void {
			var loc3:TextureData = null;
			var loc2:TextureData = ObjectLibrary.typeToTextureData_[this.objectType_];
			if(param1 == 0) {
				loc3 = loc2;
			} else {
				loc3 = loc2.getAltTextureData(param1);
				if(loc3 == null) {
					return;
				}
			}
			this.texture_ = loc3.texture_;
			this.mask_ = loc3.mask_;
			this.animatedChar_ = loc3.animatedChar_;
			if(this.effect_ != null) {
				map_.removeObj(this.effect_.objectId_);
				this.effect_ = null;
			}
			if(!Parameters.data_.noParticlesMaster && loc3.effectProps_ != null) {
				this.effect_ = ParticleEffect.fromProps(loc3.effectProps_,this);
				if(map_ != null) {
					map_.addObj(this.effect_,x_,y_);
				}
			}
		}
		
		public function setTex1(param1:int) : void {
			if(param1 == this.tex1Id_) {
				return;
			}
			this.tex1Id_ = param1;
			this.texturingCache_ = new Dictionary();
			this.portrait_ = null;
		}
		
		public function setTex2(param1:int) : void {
			if(param1 == this.tex2Id_) {
				return;
			}
			this.tex2Id_ = param1;
			this.texturingCache_ = new Dictionary();
			this.portrait_ = null;
		}
		
		public function playSound(param1:int) : void {
			SoundEffectLibrary.play(this.props_.sounds_[param1]);
		}
		
		override public function dispose() : void {
			super.dispose();
			this.texture_ = null;
			if(this.portrait_ != null) {
				this.portrait_.dispose();
				this.portrait_ = null;
			}
			this.clearTextureCache();
			this.texturingCache_ = null;
			if(this.obj3D_ != null) {
				this.obj3D_.dispose();
				this.obj3D_ = null;
			}
			if(this.object3d_ != null) {
				this.object3d_.dispose();
				this.object3d_ = null;
			}
			this.slotTypes_ = null;
			this.equipment_ = null;
			this.lockedSlot = null;
			if(this.nameBitmapData_ != null) {
				this.nameBitmapData_.dispose();
				this.nameBitmapData_ = null;
			}
			this.nameFill_ = null;
			this.namePath_ = null;
			this.bitmapFill_ = null;
			this.path_.commands = null;
			this.path_.data = null;
			this.vS_ = null;
			this.uvt_ = null;
			this.fillMatrix_ = null;
			this.icons_ = null;
			this.iconFills_ = null;
			this.iconPaths_ = null;
			this.shadowGradientFill_ = null;
			if(this.shadowPath_ != null) {
				this.shadowPath_.commands = null;
				this.shadowPath_.data = null;
				this.shadowPath_ = null;
			}
		}
		
		public function isQuiet() : Boolean {
			return (this.condition_[ConditionEffect.CE_FIRST_BATCH] & ConditionEffect.QUIET_BIT) != 0;
		}
		
		public function isWeak() : Boolean {
			return (this.condition_[ConditionEffect.CE_FIRST_BATCH] & ConditionEffect.WEAK_BIT) != 0;
		}
		
		public function isSlowed() : Boolean {
			return (this.condition_[ConditionEffect.CE_FIRST_BATCH] & ConditionEffect.SLOWED_BIT) != 0;
		}
		
		public function isSick() : Boolean {
			return (this.condition_[ConditionEffect.CE_FIRST_BATCH] & ConditionEffect.SICK_BIT) != 0;
		}
		
		public function isDazed() : Boolean {
			return (this.condition_[ConditionEffect.CE_FIRST_BATCH] & ConditionEffect.DAZED_BIT) != 0;
		}
		
		public function isStunned() : Boolean {
			return (this.condition_[ConditionEffect.CE_FIRST_BATCH] & ConditionEffect.STUNNED_BIT) != 0;
		}
		
		public function isBlind() : Boolean {
			return (this.condition_[ConditionEffect.CE_FIRST_BATCH] & ConditionEffect.BLIND_BIT) != 0;
		}
		
		public function isDrunk() : Boolean {
			return (this.condition_[ConditionEffect.CE_FIRST_BATCH] & ConditionEffect.DRUNK_BIT) != 0;
		}
		
		public function isConfused() : Boolean {
			return (this.condition_[ConditionEffect.CE_FIRST_BATCH] & ConditionEffect.CONFUSED_BIT) != 0;
		}
		
		public function isStunImmune() : Boolean {
			return (this.condition_[ConditionEffect.CE_FIRST_BATCH] & ConditionEffect.STUN_IMMUNE_BIT) != 0 || this.isStunImmune_;
		}
		
		public function isInvisible() : Boolean {
			return (this.condition_[ConditionEffect.CE_FIRST_BATCH] & ConditionEffect.INVISIBLE_BIT) != 0;
		}
		
		public function isParalyzed() : Boolean {
			return (this.condition_[ConditionEffect.CE_FIRST_BATCH] & ConditionEffect.PARALYZED_BIT) != 0;
		}
		
		public function isSpeedy() : Boolean {
			return (this.condition_[ConditionEffect.CE_FIRST_BATCH] & ConditionEffect.SPEEDY_BIT) != 0;
		}
		
		public function isNinjaSpeedy() : Boolean {
			return (this.condition_[ConditionEffect.CE_FIRST_BATCH] & ConditionEffect.NINJA_SPEEDY_BIT) != 0;
		}
		
		public function isHallucinating() : Boolean {
			return (this.condition_[ConditionEffect.CE_FIRST_BATCH] & ConditionEffect.HALLUCINATING_BIT) != 0;
		}
		
		public function isHealing() : Boolean {
			return (this.condition_[ConditionEffect.CE_FIRST_BATCH] & ConditionEffect.HEALING_BIT) != 0;
		}
		
		public function isDamaging() : Boolean {
			return (this.condition_[ConditionEffect.CE_FIRST_BATCH] & ConditionEffect.DAMAGING_BIT) != 0;
		}
		
		public function isBerserk() : Boolean {
			return (this.condition_[ConditionEffect.CE_FIRST_BATCH] & ConditionEffect.BERSERK_BIT) != 0;
		}
		
		public function isPaused() : Boolean {
			return (this.condition_[ConditionEffect.CE_FIRST_BATCH] & ConditionEffect.PAUSED_BIT) != 0;
		}
		
		public function isStasis() : Boolean {
			return (this.condition_[ConditionEffect.CE_FIRST_BATCH] & ConditionEffect.STASIS_BIT) != 0;
		}
		
		public function isStasisImmune() : Boolean {
			return this.isStasisImmune_ || (this.condition_[ConditionEffect.CE_FIRST_BATCH] & ConditionEffect.STASIS_IMMUNE_BIT) != 0;
		}
		
		public function isInvincible() : Boolean {
			return this.isInvincible_ || (this.condition_[ConditionEffect.CE_FIRST_BATCH] & ConditionEffect.INVINCIBLE_BIT) != 0;
		}
		
		public function isInvulnerable() : Boolean {
			return (this.condition_[ConditionEffect.CE_FIRST_BATCH] & ConditionEffect.INVULNERABLE_BIT) != 0;
		}
		
		public function isArmored() : Boolean {
			return (this.condition_[ConditionEffect.CE_FIRST_BATCH] & ConditionEffect.ARMORED_BIT) != 0;
		}
		
		public function isArmorBroken() : Boolean {
			return (this.condition_[ConditionEffect.CE_FIRST_BATCH] & ConditionEffect.ARMORBROKEN_BIT) != 0;
		}
		
		public function isArmorBrokenImmune() : Boolean {
			return (this.condition_[ConditionEffect.CE_FIRST_BATCH] & ConditionEffect.ARMORBROKEN_IMMUNE_BIT) != 0;
		}
		
		public function isSlowedImmune() : Boolean {
			return (this.condition_[ConditionEffect.CE_SECOND_BATCH] & ConditionEffect.SLOWED_IMMUNE_BIT) != 0;
		}
		
		public function isUnstable() : Boolean {
			return (this.condition_[ConditionEffect.CE_FIRST_BATCH] & ConditionEffect.UNSTABLE_BIT) != 0;
		}
		
		public function isShowPetEffectIcon() : Boolean {
			return (this.condition_[ConditionEffect.CE_SECOND_BATCH] & ConditionEffect.PET_EFFECT_ICON) != 0;
		}
		
		public function isDarkness() : Boolean {
			return (this.condition_[ConditionEffect.CE_FIRST_BATCH] & ConditionEffect.DARKNESS_BIT) != 0;
		}
		
		public function isParalyzeImmune() : Boolean {
			return this.isParalyzeImmune_ || (this.condition_[ConditionEffect.CE_SECOND_BATCH] & ConditionEffect.PARALYZED_IMMUNE_BIT) != 0;
		}
		
		public function isDazedImmune() : Boolean {
			return this.isDazedImmune_ || (this.condition_[ConditionEffect.CE_SECOND_BATCH] & ConditionEffect.DAZED_IMMUNE_BIT) != 0;
		}
		
		public function isPetrified() : Boolean {
			return (this.condition_[ConditionEffect.CE_SECOND_BATCH] & ConditionEffect.PETRIFIED_BIT) != 0;
		}
		
		public function isPetrifiedImmune() : Boolean {
			return (this.condition_[ConditionEffect.CE_SECOND_BATCH] & ConditionEffect.PETRIFIED_IMMUNE_BIT) != 0;
		}
		
		public function isCursed() : Boolean {
			return (this.condition_[ConditionEffect.CE_SECOND_BATCH] & ConditionEffect.CURSE_BIT) != 0;
		}
		
		public function isCursedImmune() : Boolean {
			return (this.condition_[ConditionEffect.CE_SECOND_BATCH] & ConditionEffect.CURSE_IMMUNE_BIT) != 0;
		}
		
		public function isSilenced() : Boolean {
			return (this.condition_[ConditionEffect.CE_SECOND_BATCH] & ConditionEffect.SILENCED_BIT) != 0;
		}
		
		public function isExposed() : Boolean {
			return (this.condition_[ConditionEffect.CE_SECOND_BATCH] & ConditionEffect.EXPOSED_BIT) != 0;
		}
		
		public function isSafe(param1:int = 20) : Boolean {
			var loc2:GameObject = null;
			var loc3:int = 0;
			var loc4:int = 0;
			for each(loc2 in map_.goDict_) {
				if(loc2 is Character && loc2.props_.isEnemy_) {
					loc3 = x_ > loc2.x_?int(x_ - loc2.x_):int(loc2.x_ - x_);
					loc4 = y_ > loc2.y_?int(y_ - loc2.y_):int(loc2.y_ - y_);
					if(loc3 < param1 && loc4 < param1) {
						return false;
					}
				}
			}
			return true;
		}
		
		public function getName() : String {
			return this.name_ == null || this.name_ == ""?ObjectLibrary.typeToDisplayId_[this.objectType_]:this.name_;
		}
		
		public function getColor() : uint {
			if(this.props_.color_ != -1) {
				return this.props_.color_;
			}
			return BitmapUtil.mostCommonColor(this.texture_);
		}
		
		public function getBulletId() : uint {
			var loc1:uint = this.nextBulletId_;
			this.nextBulletId_ = (this.nextBulletId_ + 1) % 128;
			return loc1;
		}
		
		public function distTo(param1:WorldPosData) : Number {
			var loc2:Number = param1.x_ - x_;
			var loc3:Number = param1.y_ - y_;
			return Math.sqrt(loc2 * loc2 + loc3 * loc3);
		}
		
		public function toggleShockEffect(param1:Boolean) : void {
			if(param1) {
				this.isShocked = true;
			} else {
				this.isShocked = false;
				this.isShockedTransformSet = false;
			}
		}
		
		public function toggleChargingEffect(param1:Boolean) : void {
			if(param1) {
				this.isCharging = true;
			} else {
				this.isCharging = false;
				this.isChargingTransformSet = false;
			}
		}
		
		override public function addTo(param1:Map, param2:Number, param3:Number) : Boolean {
			map_ = param1;
			this.posAtTick_.x = this.tickPosition_.x = param2;
			this.posAtTick_.y = this.tickPosition_.y = param3;
			if(!this.moveTo(param2,param3)) {
				map_ = null;
				return false;
			}
			if(this.effect_ != null) {
				map_.addObj(this.effect_,param2,param3);
			}
			return true;
		}
		
		override public function removeFromMap() : void {
			if(this.props_.static_ && square_ != null) {
				if(square_.obj_ == this) {
					square_.obj_ = null;
				}
				square_ = null;
			}
			if(this.effect_ != null) {
				map_.removeObj(this.effect_.objectId_);
			}
			super.removeFromMap();
			this.dispose();
		}
		
		public function moveTo(param1:Number, param2:Number) : Boolean {
			var loc3:Square = map_.getSquare(param1,param2);
			if(loc3 == null) {
				return false;
			}
			x_ = param1;
			y_ = param2;
			if(this.props_.static_) {
				if(square_ != null) {
					square_.obj_ = null;
				}
				loc3.obj_ = this;
			}
			square_ = loc3;
			if(this.obj3D_ != null) {
				this.obj3D_.setPosition(x_,y_,0,this.props_.rotation_);
			}
			if(this.object3d_ != null) {
				this.object3d_.setPosition(x_,y_,0,this.props_.rotation_);
			}
			return true;
		}
		
		override public function update(param1:int, param2:int) : Boolean {
			var loc4:int = 0;
			var loc5:Number = NaN;
			var loc6:Number = NaN;
			var loc3:Boolean = false;
			if(!(this.moveVec_.x == 0 && this.moveVec_.y == 0)) {
				if(this.myLastTickId_ < map_.gs_.gsc_.lastTickId_) {
					this.moveVec_.x = 0;
					this.moveVec_.y = 0;
					this.moveTo(this.tickPosition_.x,this.tickPosition_.y);
				} else {
					loc4 = param1 - this.lastTickUpdateTime_;
					loc5 = this.posAtTick_.x + loc4 * this.moveVec_.x;
					loc6 = this.posAtTick_.y + loc4 * this.moveVec_.y;
					this.moveTo(loc5,loc6);
					loc3 = true;
				}
			}
			if(this.props_.whileMoving_ != null) {
				if(!loc3) {
					z_ = this.props_.z_;
					this.flying_ = this.props_.flying_;
				} else {
					z_ = this.props_.whileMoving_.z_;
					this.flying_ = this.props_.whileMoving_.flying_;
				}
			}
			return true;
		}
		
		public function onGoto(param1:Number, param2:Number, param3:int) : void {
			this.moveTo(param1,param2);
			this.lastTickUpdateTime_ = param3;
			this.tickPosition_.x = param1;
			this.tickPosition_.y = param2;
			this.posAtTick_.x = param1;
			this.posAtTick_.y = param2;
			this.moveVec_.x = 0;
			this.moveVec_.y = 0;
		}
		
		public function onTickPos(param1:Number, param2:Number, param3:int, param4:int) : void {
			if(this.myLastTickId_ < map_.gs_.gsc_.lastTickId_) {
				this.moveTo(this.tickPosition_.x,this.tickPosition_.y);
			}
			this.lastTickUpdateTime_ = map_.gs_.lastUpdate_;
			this.tickPosition_.x = param1;
			this.tickPosition_.y = param2;
			this.posAtTick_.x = x_;
			this.posAtTick_.y = y_;
			this.moveVec_.x = (this.tickPosition_.x - this.posAtTick_.x) / param3;
			this.moveVec_.y = (this.tickPosition_.y - this.posAtTick_.y) / param3;
			this.myLastTickId_ = param4;
		}
		
		public function damage(param1:Boolean, param2:int, param3:Vector.<uint>, param4:Boolean, param5:Projectile, param6:Boolean = false) : void {
			var loc8:int = 0;
			var loc9:uint = 0;
			var loc10:ConditionEffect = null;
			var loc11:CharacterStatusText = null;
			var loc12:PetsModel = null;
			var loc13:PetVO = null;
			var loc14:String = null;
			var loc15:Vector.<uint> = null;
			var loc16:Boolean = false;
			var loc7:Boolean = false;
			if(param4) {
				this.dead_ = true;
			} else if(param3 != null) {
				loc8 = 0;
				for each(loc9 in param3) {
					loc10 = null;
					if(param5 != null && param5.projProps_.isPetEffect_ && param5.projProps_.isPetEffect_[loc9]) {
						loc12 = StaticInjectorContext.getInjector().getInstance(PetsModel);
						loc13 = loc12.getActivePet();
						if(loc13 != null) {
							loc10 = ConditionEffect.effects_[loc9];
							this.showConditionEffectPet(loc8,loc10.name_);
							loc8 = loc8 + 500;
						}
					} else {
						switch(loc9) {
							case ConditionEffect.NOTHING:
								break;
							case ConditionEffect.WEAK:
							case ConditionEffect.SICK:
							case ConditionEffect.BLIND:
							case ConditionEffect.HALLUCINATING:
							case ConditionEffect.DRUNK:
							case ConditionEffect.CONFUSED:
							case ConditionEffect.STUN_IMMUNE:
							case ConditionEffect.INVISIBLE:
							case ConditionEffect.SPEEDY:
							case ConditionEffect.BLEEDING:
							case ConditionEffect.STASIS_IMMUNE:
							case ConditionEffect.NINJA_SPEEDY:
							case ConditionEffect.UNSTABLE:
							case ConditionEffect.DARKNESS:
							case ConditionEffect.PETRIFIED_IMMUNE:
							case ConditionEffect.SILENCED:
								loc10 = ConditionEffect.effects_[loc9];
								break;
							case ConditionEffect.QUIET:
								if(map_.player_ == this) {
									map_.player_.mp_ = 0;
								}
								loc10 = ConditionEffect.effects_[loc9];
								break;
							case ConditionEffect.STASIS:
								if(this.isStasisImmune()) {
									loc11 = new CharacterStatusText(this,16711680,3000);
									loc11.setStringBuilder(new LineBuilder().setParams(TextKey.GAMEOBJECT_IMMUNE));
									map_.mapOverlay_.addStatusText(loc11);
								} else {
									loc10 = ConditionEffect.effects_[loc9];
								}
								break;
							case ConditionEffect.SLOWED:
								if(this.isSlowedImmune()) {
									loc11 = new CharacterStatusText(this,16711680,3000);
									loc11.setStringBuilder(new LineBuilder().setParams(TextKey.GAMEOBJECT_IMMUNE));
									map_.mapOverlay_.addStatusText(loc11);
								} else {
									loc10 = ConditionEffect.effects_[loc9];
								}
								break;
							case ConditionEffect.ARMORBROKEN:
								if(this.isArmorBrokenImmune()) {
									loc11 = new CharacterStatusText(this,16711680,3000);
									loc11.setStringBuilder(new LineBuilder().setParams(TextKey.GAMEOBJECT_IMMUNE));
									map_.mapOverlay_.addStatusText(loc11);
								} else {
									loc10 = ConditionEffect.effects_[loc9];
								}
								break;
							case ConditionEffect.STUNNED:
								if(this.isStunImmune()) {
									loc11 = new CharacterStatusText(this,16711680,3000);
									loc11.setStringBuilder(new LineBuilder().setParams(TextKey.GAMEOBJECT_IMMUNE));
									map_.mapOverlay_.addStatusText(loc11);
								} else {
									loc10 = ConditionEffect.effects_[loc9];
								}
								break;
							case ConditionEffect.DAZED:
								if(this.isDazedImmune()) {
									loc11 = new CharacterStatusText(this,16711680,3000);
									loc11.setStringBuilder(new LineBuilder().setParams(TextKey.GAMEOBJECT_IMMUNE));
									map_.mapOverlay_.addStatusText(loc11);
								} else {
									loc10 = ConditionEffect.effects_[loc9];
								}
								break;
							case ConditionEffect.PARALYZED:
								if(this.isParalyzeImmune()) {
									loc11 = new CharacterStatusText(this,16711680,3000);
									loc11.setStringBuilder(new LineBuilder().setParams(TextKey.GAMEOBJECT_IMMUNE));
									map_.mapOverlay_.addStatusText(loc11);
								} else {
									loc10 = ConditionEffect.effects_[loc9];
								}
								break;
							case ConditionEffect.PETRIFIED:
								if(this.isPetrifiedImmune()) {
									loc11 = new CharacterStatusText(this,16711680,3000);
									loc11.setStringBuilder(new LineBuilder().setParams(TextKey.GAMEOBJECT_IMMUNE));
									map_.mapOverlay_.addStatusText(loc11);
								} else {
									loc10 = ConditionEffect.effects_[loc9];
								}
								break;
							case ConditionEffect.CURSE:
								if(this.isCursedImmune()) {
									loc11 = new CharacterStatusText(this,16711680,3000);
									loc11.setStringBuilder(new LineBuilder().setParams(TextKey.GAMEOBJECT_IMMUNE));
									map_.mapOverlay_.addStatusText(loc11);
								} else {
									loc10 = ConditionEffect.effects_[loc9];
								}
								break;
							case ConditionEffect.GROUND_DAMAGE:
								loc7 = true;
						}
						if(loc10 != null) {
							if(loc9 < ConditionEffect.NEW_CON_THREASHOLD) {
								if((this.condition_[ConditionEffect.CE_FIRST_BATCH] | loc10.bit_) == this.condition_[ConditionEffect.CE_FIRST_BATCH]) {
									continue;
								}
								this.condition_[ConditionEffect.CE_FIRST_BATCH] = this.condition_[ConditionEffect.CE_FIRST_BATCH] | loc10.bit_;
							} else {
								if((this.condition_[ConditionEffect.CE_SECOND_BATCH] | loc10.bit_) == this.condition_[ConditionEffect.CE_SECOND_BATCH]) {
									continue;
								}
								this.condition_[ConditionEffect.CE_SECOND_BATCH] = this.condition_[ConditionEffect.CE_SECOND_BATCH] | loc10.bit_;
							}
							loc14 = loc10.localizationKey_;
							this.showConditionEffect(loc8,loc14);
							loc8 = loc8 + 500;
						}
					}
				}
			}
			if(!(this.props_.isEnemy_ && Parameters.data_.disableEnemyParticles) && !(!this.props_.isEnemy_ && Parameters.data_.disablePlayersHitParticles)) {
				loc15 = BloodComposition.getBloodComposition(this.objectType_,this.texture_,this.props_.bloodProb_,this.props_.bloodColor_);
				if(this.dead_) {
					map_.addObj(new ExplosionEffect(loc15,this.size_,30),x_,y_);
				} else if(param5 != null) {
					map_.addObj(new HitEffect(loc15,this.size_,10,param5.angle_,param5.projProps_.speed_),x_,y_);
				} else {
					map_.addObj(new ExplosionEffect(loc15,this.size_,10),x_,y_);
				}
			}
			if(!param1 && (Parameters.data_.noEnemyDamage && this.props_.isEnemy_ || Parameters.data_.noAllyDamage && this.props_.isPlayer_)) {
				return;
			}
			if(param2 > 0) {
				loc16 = this.isArmorBroken() || param5 != null && param5.projProps_.armorPiercing_ || loc7 || param6;
				this.showDamageText(param2,loc16);
			}
		}
		
		public function showConditionEffect(param1:int, param2:String) : void {
			var loc3:CharacterStatusText = new CharacterStatusText(this,16711680,3000,param1);
			loc3.setStringBuilder(new LineBuilder().setParams(param2));
			map_.mapOverlay_.addStatusText(loc3);
		}
		
		public function showConditionEffectPet(param1:int, param2:String) : void {
			var loc3:CharacterStatusText = new CharacterStatusText(this,16711680,3000,param1);
			loc3.setStringBuilder(new StaticStringBuilder("Pet " + param2));
			map_.mapOverlay_.addStatusText(loc3);
		}
		
		public function showDamageText(param1:int, param2:Boolean) : void {
			var loc3:String = "-" + param1;
			var loc4:CharacterStatusText = new CharacterStatusText(this,!!param2?uint(9437439):uint(16711680),1000);
			loc4.setStringBuilder(new StaticStringBuilder(loc3));
			map_.mapOverlay_.addStatusText(loc4);
		}
		
		protected function makeNameBitmapData() : BitmapData {
			var loc1:StringBuilder = new StaticStringBuilder(this.name_);
			var loc2:BitmapTextFactory = StaticInjectorContext.getInjector().getInstance(BitmapTextFactory);
			return loc2.make(loc1,16,16777215,true,IDENTITY_MATRIX,true);
		}
		
		public function drawName(param1:Vector.<IGraphicsData>, param2:Camera) : void {
			if(this.nameBitmapData_ == null) {
				this.nameBitmapData_ = this.makeNameBitmapData();
				this.nameFill_ = new GraphicsBitmapFill(null,new Matrix(),false,false);
				this.namePath_ = new GraphicsPath(GraphicsUtil.QUAD_COMMANDS,new Vector.<Number>());
			}
			var loc3:int = this.nameBitmapData_.width / 2 + 1;
			var loc4:int = 30;
			var loc5:Vector.<Number> = this.namePath_.data;
			loc5.length = 0;
			loc5.push(posS_[0] - loc3,posS_[1],posS_[0] + loc3,posS_[1],posS_[0] + loc3,posS_[1] + loc4,posS_[0] - loc3,posS_[1] + loc4);
			this.nameFill_.bitmapData = this.nameBitmapData_;
			var loc6:Matrix = this.nameFill_.matrix;
			loc6.identity();
			loc6.translate(loc5[0],loc5[1]);
			param1.push(this.nameFill_);
			param1.push(this.namePath_);
			param1.push(GraphicsUtil.END_FILL);
		}
		
		protected function getHallucinatingTexture() : BitmapData {
			if(this.hallucinatingTexture_ == null) {
				this.hallucinatingTexture_ = AssetLibrary.getImageFromSet("lofiChar8x8",int(Math.random() * 239));
			}
			return this.hallucinatingTexture_;
		}
		
		protected function getTexture(param1:Camera, param2:int) : BitmapData {
			var loc6:Pet = null;
			var loc7:Number = NaN;
			var loc8:int = 0;
			var loc9:MaskedImage = null;
			var loc10:int = 0;
			var loc11:BitmapData = null;
			var loc12:int = 0;
			var loc13:BitmapData = null;
			if(this is Pet) {
				loc6 = Pet(this);
				if(this.condition_[ConditionEffect.CE_FIRST_BATCH] != 0 && !this.isPaused()) {
					if(loc6.skinId != 32912) {
						loc6.setSkin(32912);
					}
				} else if(!loc6.isDefaultAnimatedChar) {
					loc6.setDefaultSkin();
				}
			}
			var loc3:BitmapData = this.texture_;
			var loc4:int = this.size_;
			var loc5:BitmapData = null;
			if(this.animatedChar_ != null) {
				loc7 = 0;
				loc8 = AnimatedChar.STAND;
				if(param2 < this.attackStart_ + ATTACK_PERIOD) {
					if(!this.props_.dontFaceAttacks_) {
						this.facing_ = this.attackAngle_;
					}
					loc7 = (param2 - this.attackStart_) % ATTACK_PERIOD / ATTACK_PERIOD;
					loc8 = AnimatedChar.ATTACK;
				} else if(this.moveVec_.x != 0 || this.moveVec_.y != 0) {
					loc10 = 0.5 / this.moveVec_.length;
					loc10 = loc10 + (400 - loc10 % 400);
					if(this.moveVec_.x > ZERO_LIMIT || this.moveVec_.x < NEGATIVE_ZERO_LIMIT || this.moveVec_.y > ZERO_LIMIT || this.moveVec_.y < NEGATIVE_ZERO_LIMIT) {
						if(!this.props_.dontFaceMovement_) {
							this.facing_ = Math.atan2(this.moveVec_.y,this.moveVec_.x);
						}
						loc8 = AnimatedChar.WALK;
					} else {
						loc8 = AnimatedChar.STAND;
					}
					loc7 = param2 % loc10 / loc10;
				}
				loc9 = this.animatedChar_.imageFromFacing(this.facing_,param1,loc8,loc7);
				loc3 = loc9.image_;
				loc5 = loc9.mask_;
			} else if(this.animations_ != null) {
				loc11 = this.animations_.getTexture(param2);
				if(loc11 != null) {
					loc3 = loc11;
				}
			}
			if(this.props_.drawOnGround_ || this.obj3D_ != null) {
				return loc3;
			}
			if(param1.isHallucinating_) {
				loc12 = loc3 == null?8:int(loc3.width);
				loc3 = this.getHallucinatingTexture();
				loc5 = null;
				loc4 = this.size_ * Math.min(1.5,loc12 / loc3.width);
			}
			if(!(this is Pet)) {
				if(this.isStasis() || this.isPetrified()) {
					loc3 = CachingColorTransformer.filterBitmapData(loc3,PAUSED_FILTER);
				}
			}
			if(this.tex1Id_ == 0 && this.tex2Id_ == 0) {
				if(this.isCursed() && Parameters.data_.curseIndication) {
					loc3 = TextureRedrawer.redraw(loc3,loc4,false,16711680);
				} else {
					loc3 = TextureRedrawer.redraw(loc3,loc4,false,0);
				}
			} else {
				loc13 = null;
				if(this.texturingCache_ == null) {
					this.texturingCache_ = new Dictionary();
				} else {
					loc13 = this.texturingCache_[loc3];
				}
				if(loc13 == null) {
					loc13 = TextureRedrawer.resize(loc3,loc5,loc4,false,this.tex1Id_,this.tex2Id_);
					loc13 = GlowRedrawer.outlineGlow(loc13,0);
					this.texturingCache_[loc3] = loc13;
				}
				loc3 = loc13;
			}
			return loc3;
		}
		
		public function useAltTexture(param1:String, param2:int) : void {
			this.texture_ = AssetLibrary.getImageFromSet(param1,param2);
			this.sizeMult_ = this.texture_.height / 8;
		}
		
		public function getPortrait() : BitmapData {
			var loc1:BitmapData = null;
			var loc2:int = 0;
			if(this.portrait_ == null) {
				loc1 = this.props_.portrait_ != null?this.props_.portrait_.getTexture():this.texture_;
				loc2 = 4 / loc1.width * 100;
				this.portrait_ = TextureRedrawer.resize(loc1,this.mask_,loc2,true,this.tex1Id_,this.tex2Id_);
				this.portrait_ = GlowRedrawer.outlineGlow(this.portrait_,0);
			}
			return this.portrait_;
		}
		
		public function setAttack(param1:int, param2:Number) : void {
			this.attackAngle_ = param2;
			this.attackStart_ = getTimer();
		}
		
		override public function draw3d(param1:Vector.<Object3DStage3D>) : void {
			if(this.object3d_ != null) {
				param1.push(this.object3d_);
			}
		}
		
		protected function drawHpBar(param1:Vector.<IGraphicsData>, param2:int = 6) : void {
			var loc6:Number = NaN;
			var loc7:Number = NaN;
			if(this.hpbarPath_ == null) {
				this.hpbarBackFill_ = new GraphicsSolidFill();
				this.hpbarBackPath_ = new GraphicsPath(GraphicsUtil.QUAD_COMMANDS,new Vector.<Number>());
				this.hpbarFill_ = new GraphicsSolidFill();
				this.hpbarPath_ = new GraphicsPath(GraphicsUtil.QUAD_COMMANDS,new Vector.<Number>());
			}
			if(this.hp_ > this.maxHP_) {
				this.maxHP_ = this.hp_;
			}
			this.hpbarBackFill_.color = 1118481;
			var loc3:int = 20;
			var loc4:int = 5;
			this.hpbarBackPath_.data.length = 0;
			var loc5:Number = 1.2;
			(this.hpbarBackPath_.data as Vector.<Number>).push(posS_[0] - loc3 - loc5,posS_[1] + param2 - loc5,posS_[0] + loc3 + loc5,posS_[1] + param2 - loc5,posS_[0] + loc3 + loc5,posS_[1] + param2 + loc4 + loc5,posS_[0] - loc3 - loc5,posS_[1] + param2 + loc4 + loc5);
			param1.push(this.hpbarBackFill_);
			param1.push(this.hpbarBackPath_);
			param1.push(GraphicsUtil.END_FILL);
			if(this.hp_ > 0) {
				loc6 = this.hp_ / this.maxHP_;
				loc7 = loc6 * 2 * loc3;
				this.hpbarPath_.data.length = 0;
				(this.hpbarPath_.data as Vector.<Number>).push(posS_[0] - loc3,posS_[1] + param2,posS_[0] - loc3 + loc7,posS_[1] + param2,posS_[0] - loc3 + loc7,posS_[1] + param2 + loc4,posS_[0] - loc3,posS_[1] + param2 + loc4);
				this.hpbarFill_.color = loc6 < 0.5?loc6 < 0.2?uint(14684176):uint(16744464):uint(1113856);
				param1.push(this.hpbarFill_);
				param1.push(this.hpbarPath_);
				param1.push(GraphicsUtil.END_FILL);
			}
			GraphicsFillExtra.setSoftwareDrawSolid(this.hpbarFill_,true);
			GraphicsFillExtra.setSoftwareDrawSolid(this.hpbarBackFill_,true);
		}
		
		override public function draw(param1:Vector.<IGraphicsData>, param2:Camera, param3:int) : void {
			var loc9:BitmapData = null;
			var loc10:uint = 0;
			var loc11:uint = 0;
			var loc12:int = 0;
			var loc4:BitmapData = this.getTexture(param2,param3);
			if(this.props_.drawOnGround_) {
				if(square_.faces_.length == 0) {
					return;
				}
				this.path_.data = square_.faces_[0].face_.vout_;
				this.bitmapFill_.bitmapData = loc4;
				square_.baseTexMatrix_.calculateTextureMatrix(this.path_.data);
				this.bitmapFill_.matrix = square_.baseTexMatrix_.tToS_;
				param1.push(this.bitmapFill_);
				param1.push(this.path_);
				param1.push(GraphicsUtil.END_FILL);
				return;
			}
			var loc5:Boolean = this.props_ && (this.props_.isEnemy_ || this.props_.isPlayer_) && !this.isInvincible() && (this.props_.isPlayer_ || !this.isInvulnerable()) && !this.props_.noMiniMap_;
			if(this.obj3D_ != null) {
				if(loc5 && this.bHPBarParamCheck() && this.props_.healthBar_) {
					this.drawHpBar(param1,this.props_.healthBar_);
				}
				if(!Parameters.isGpuRender()) {
					this.obj3D_.draw(param1,param2,this.props_.color_,loc4);
					return;
				}
				if(Parameters.isGpuRender()) {
					param1.push(null);
					return;
				}
			}
			var loc6:int = loc4.width;
			var loc7:int = loc4.height;
			var loc8:int = square_.sink_ + this.sinkLevel_;
			if(loc8 > 0 && (this.flying_ || square_.obj_ != null && square_.obj_.props_.protectFromSink_)) {
				loc8 = 0;
			}
			if(Parameters.isGpuRender()) {
				if(loc8 != 0) {
					GraphicsFillExtra.setSinkLevel(this.bitmapFill_,Math.max(loc8 / loc7 * 1.65 - 0.02,0));
					loc8 = -loc8 + 0.02;
				} else if(loc8 == 0 && GraphicsFillExtra.getSinkLevel(this.bitmapFill_) != 0) {
					GraphicsFillExtra.clearSink(this.bitmapFill_);
				}
			}
			this.vS_.length = 0;
			this.vS_.push(posS_[3] - loc6 / 2,posS_[4] - loc7 + loc8,posS_[3] + loc6 / 2,posS_[4] - loc7 + loc8,posS_[3] + loc6 / 2,posS_[4],posS_[3] - loc6 / 2,posS_[4]);
			this.path_.data = this.vS_;
			if(this.flash_ != null) {
				if(!this.flash_.doneAt(param3)) {
					if(Parameters.isGpuRender()) {
						this.flash_.applyGPUTextureColorTransform(loc4,param3);
					} else {
						loc4 = this.flash_.apply(loc4,param3);
					}
				} else {
					this.flash_ = null;
				}
			}
			if(this.isShocked && !this.isShockedTransformSet) {
				if(Parameters.isGpuRender()) {
					GraphicsFillExtra.setColorTransform(loc4,new ColorTransform(-1,-1,-1,1,255,255,255,0));
				} else {
					loc9 = loc4.clone();
					loc9.colorTransform(loc9.rect,new ColorTransform(-1,-1,-1,1,255,255,255,0));
					loc9 = CachingColorTransformer.filterBitmapData(loc9,new ColorMatrixFilter(MoreColorUtil.greyscaleFilterMatrix));
					loc4 = loc9;
				}
				this.isShockedTransformSet = true;
			}
			if(this.isCharging && !this.isChargingTransformSet) {
				if(Parameters.isGpuRender()) {
					GraphicsFillExtra.setColorTransform(loc4,new ColorTransform(1,1,1,1,255,255,255,0));
				} else {
					loc9 = loc4.clone();
					loc9.colorTransform(loc9.rect,new ColorTransform(1,1,1,1,255,255,255,0));
					loc4 = loc9;
				}
				this.isChargingTransformSet = true;
			}
			this.bitmapFill_.bitmapData = loc4;
			this.fillMatrix_.identity();
			this.fillMatrix_.translate(this.vS_[0],this.vS_[1]);
			this.bitmapFill_.matrix = this.fillMatrix_;
			param1.push(this.bitmapFill_);
			param1.push(this.path_);
			param1.push(GraphicsUtil.END_FILL);
			if(!this.isPaused() && (this.condition_[ConditionEffect.CE_FIRST_BATCH] || this.condition_[ConditionEffect.CE_SECOND_BATCH]) && !Parameters.screenShotMode_ && !(this is Pet)) {
				this.drawConditionIcons(param1,param2,param3);
			}
			if(this.props_.showName_ && this.name_ != null && this.name_.length != 0) {
				this.drawName(param1,param2);
			}
			if(loc5) {
				loc10 = loc4.getPixel32(loc4.width / 4,loc4.height / 4) | loc4.getPixel32(loc4.width / 2,loc4.height / 2) | loc4.getPixel32(loc4.width * 3 / 4,loc4.height * 3 / 4);
				loc11 = loc10 >> 24;
				if(loc11 != 0) {
					hasShadow_ = true;
					loc12 = this.props_.isPlayer_ && this != map_.player_?12:0;
					if(this.bHPBarParamCheck() && this.props_.healthBar_ != -1) {
						this.drawHpBar(param1,!!this.props_.healthBar_?int(this.props_.healthBar_):int(loc12 + DEFAULT_HP_BAR_Y_OFFSET));
					}
				} else {
					hasShadow_ = false;
				}
			}
		}
		
		private function bHPBarParamCheck() : Boolean {
			return Parameters.data_.HPBar && (Parameters.data_.HPBar == 1 || Parameters.data_.HPBar == 2 && this.props_.isEnemy_ || Parameters.data_.HPBar == 3 && (this == map_.player_ || this.props_.isEnemy_) || Parameters.data_.HPBar == 4 && this == map_.player_ || Parameters.data_.HPBar == 5 && this.props_.isPlayer_);
		}
		
		public function drawConditionIcons(param1:Vector.<IGraphicsData>, param2:Camera, param3:int) : void {
			var loc9:BitmapData = null;
			var loc10:GraphicsBitmapFill = null;
			var loc11:GraphicsPath = null;
			var loc12:Number = NaN;
			var loc13:Number = NaN;
			var loc14:Matrix = null;
			if(this.icons_ == null) {
				this.icons_ = new Vector.<BitmapData>();
				this.iconFills_ = new Vector.<GraphicsBitmapFill>();
				this.iconPaths_ = new Vector.<GraphicsPath>();
			}
			this.icons_.length = 0;
			var loc4:int = param3 / 500;
			ConditionEffect.getConditionEffectIcons(this.condition_[ConditionEffect.CE_FIRST_BATCH],this.icons_,loc4);
			ConditionEffect.getConditionEffectIcons2(this.condition_[ConditionEffect.CE_SECOND_BATCH],this.icons_,loc4);
			var loc5:Number = posS_[3];
			var loc6:Number = this.vS_[1];
			var loc7:int = this.icons_.length;
			var loc8:int = 0;
			while(loc8 < loc7) {
				loc9 = this.icons_[loc8];
				if(loc8 >= this.iconFills_.length) {
					this.iconFills_.push(new GraphicsBitmapFill(null,new Matrix(),false,false));
					this.iconPaths_.push(new GraphicsPath(GraphicsUtil.QUAD_COMMANDS,new Vector.<Number>()));
				}
				loc10 = this.iconFills_[loc8];
				loc11 = this.iconPaths_[loc8];
				loc10.bitmapData = loc9;
				loc12 = loc5 - loc9.width * loc7 / 2 + loc8 * loc9.width;
				loc13 = loc6 - loc9.height / 2;
				loc11.data.length = 0;
				(loc11.data as Vector.<Number>).push(loc12,loc13,loc12 + loc9.width,loc13,loc12 + loc9.width,loc13 + loc9.height,loc12,loc13 + loc9.height);
				loc14 = loc10.matrix;
				loc14.identity();
				loc14.translate(loc12,loc13);
				param1.push(loc10);
				param1.push(loc11);
				param1.push(GraphicsUtil.END_FILL);
				loc8++;
			}
		}
		
		override public function drawShadow(param1:Vector.<IGraphicsData>, param2:Camera, param3:int) : void {
			if(this.shadowGradientFill_ == null) {
				this.shadowGradientFill_ = new GraphicsGradientFill(GradientType.RADIAL,[this.props_.shadowColor_,this.props_.shadowColor_],[0.5,0],null,new Matrix());
				this.shadowPath_ = new GraphicsPath(GraphicsUtil.QUAD_COMMANDS,new Vector.<Number>());
			}
			var loc4:Number = this.size_ / 100 * (this.props_.shadowSize_ / 100) * this.sizeMult_;
			var loc5:Number = 30 * loc4;
			var loc6:Number = 15 * loc4;
			this.shadowGradientFill_.matrix.createGradientBox(loc5 * 2,loc6 * 2,0,posS_[0] - loc5,posS_[1] - loc6);
			param1.push(this.shadowGradientFill_);
			this.shadowPath_.data.length = 0;
			(this.shadowPath_.data as Vector.<Number>).push(posS_[0] - loc5,posS_[1] - loc6,posS_[0] + loc5,posS_[1] - loc6,posS_[0] + loc5,posS_[1] + loc6,posS_[0] - loc5,posS_[1] + loc6);
			param1.push(this.shadowPath_);
			param1.push(GraphicsUtil.END_FILL);
		}
		
		public function clearTextureCache() : void {
			var loc1:Object = null;
			var loc2:BitmapData = null;
			var loc3:Dictionary = null;
			var loc4:Object = null;
			var loc5:BitmapData = null;
			if(this.texturingCache_ != null) {
				for each(loc1 in this.texturingCache_) {
					loc2 = loc1 as BitmapData;
					if(loc2 != null) {
						loc2.dispose();
					} else {
						loc3 = loc1 as Dictionary;
						for each(loc4 in loc3) {
							loc5 = loc4 as BitmapData;
							if(loc5 != null) {
								loc5.dispose();
							}
						}
					}
				}
			}
			this.texturingCache_ = new Dictionary();
		}
		
		public function toString() : String {
			return "[" + getQualifiedClassName(this) + " id: " + objectId_ + " type: " + ObjectLibrary.typeToDisplayId_[this.objectType_] + " pos: " + x_ + ", " + y_ + "]";
		}
	}
}
