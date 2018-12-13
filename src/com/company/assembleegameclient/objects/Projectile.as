package com.company.assembleegameclient.objects {
	import com.company.assembleegameclient.engine3d.Point3D;
	import com.company.assembleegameclient.map.Camera;
	import com.company.assembleegameclient.map.Map;
	import com.company.assembleegameclient.map.Square;
	import com.company.assembleegameclient.objects.particles.HitEffect;
	import com.company.assembleegameclient.objects.particles.SparkParticle;
	import com.company.assembleegameclient.parameters.Parameters;
	import com.company.assembleegameclient.tutorial.Tutorial;
	import com.company.assembleegameclient.tutorial.doneAction;
	import com.company.assembleegameclient.util.BloodComposition;
	import com.company.assembleegameclient.util.FreeList;
	import com.company.assembleegameclient.util.RandomUtil;
	import com.company.assembleegameclient.util.TextureRedrawer;
	import com.company.util.GraphicsUtil;
	import com.company.util.Trig;

	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.GraphicsGradientFill;
	import flash.display.GraphicsPath;
	import flash.display.IGraphicsData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;

	public class Projectile extends BasicObject {

		private static var objBullIdToObjId_:Dictionary = new Dictionary();


		public var props_:ObjectProperties;

		public var containerProps_:ObjectProperties;

		public var projProps_:ProjectileProperties;

		public var texture_:BitmapData;

		public var bulletId_:uint;

		public var ownerId_:int;

		public var containerType_:int;

		public var bulletType_:uint;

		public var damagesEnemies_:Boolean;

		public var damagesPlayers_:Boolean;

		public var damage_:int;

		public var sound_:String;

		public var startX_:Number;

		public var startY_:Number;

		public var startTime_:int;

		public var angle_:Number = 0;

		public var multiHitDict_:Dictionary;

		public var p_:Point3D;

		private var staticPoint_:Point;

		private var staticVector3D_:Vector3D;

		protected var shadowGradientFill_:GraphicsGradientFill;

		protected var shadowPath_:GraphicsPath;

		public function Projectile() {
			this.p_ = new Point3D(100);
			this.staticPoint_ = new Point();
			this.staticVector3D_ = new Vector3D();
			this.shadowGradientFill_ = new GraphicsGradientFill(GradientType.RADIAL, [0, 0], [0.5, 0], null, new Matrix());
			this.shadowPath_ = new GraphicsPath(GraphicsUtil.QUAD_COMMANDS, new Vector.<Number>());
			super();
		}

		public static function findObjId(param1:int, param2:uint):int {
			return objBullIdToObjId_[param2 << 24 | param1];
		}

		public static function getNewObjId(param1:int, param2:uint):int {
			var loc3:int = getNextFakeObjectId();
			objBullIdToObjId_[param2 << 24 | param1] = loc3;
			return loc3;
		}

		public static function removeObjId(param1:int, param2:uint):void {
			delete objBullIdToObjId_[param2 << 24 | param1];
		}

		public static function dispose():void {
			objBullIdToObjId_ = new Dictionary();
		}

		public function reset(param1:int, param2:int, param3:int, param4:int, param5:Number, param6:int, param7:String = "", param8:String = ""):void {
			var loc11:Number = NaN;
			clear();
			this.containerType_ = param1;
			this.bulletType_ = param2;
			this.ownerId_ = param3;
			this.bulletId_ = param4;
			this.angle_ = Trig.boundToPI(param5);
			this.startTime_ = param6;
			objectId_ = getNewObjId(this.ownerId_, this.bulletId_);
			z_ = 0.5;
			this.containerProps_ = ObjectLibrary.propsLibrary_[this.containerType_];
			this.projProps_ = this.containerProps_.projectiles_[param2];
			var loc9:String = param7 != "" && this.projProps_.objectId_ == param8 ? param7 : this.projProps_.objectId_;
			this.props_ = ObjectLibrary.getPropsFromId(loc9);
			hasShadow_ = this.props_.shadowSize_ > 0;
			var loc10:TextureData = ObjectLibrary.typeToTextureData_[this.props_.type_];
			this.texture_ = loc10.getTexture(objectId_);
			this.damagesPlayers_ = this.containerProps_.isEnemy_;
			this.damagesEnemies_ = !this.damagesPlayers_;
			this.sound_ = this.containerProps_.oldSound_;
			this.multiHitDict_ = !!this.projProps_.multiHit_ ? new Dictionary() : null;
			if (this.projProps_.size_ >= 0) {
				loc11 = this.projProps_.size_;
			} else {
				loc11 = ObjectLibrary.getSizeFromType(this.containerType_);
			}
			this.p_.setSize(8 * (loc11 / 100));
			this.damage_ = 0;
		}

		public function setDamage(param1:int):void {
			this.damage_ = param1;
		}

		override public function addTo(param1:Map, param2:Number, param3:Number):Boolean {
			var loc4:Player = null;
			this.startX_ = param2;
			this.startY_ = param3;
			if (!super.addTo(param1, param2, param3)) {
				return false;
			}
			if (!this.containerProps_.flying_ && square_.sink_) {
				z_ = 0.1;
			} else {
				loc4 = param1.goDict_[this.ownerId_] as Player;
				if (loc4 != null && loc4.sinkLevel_ > 0) {
					z_ = 0.5 - 0.4 * (loc4.sinkLevel_ / Parameters.MAX_SINK_LEVEL);
				}
			}
			return true;
		}

		public function moveTo(param1:Number, param2:Number):Boolean {
			var loc3:Square = map_.getSquare(param1, param2);
			if (loc3 == null) {
				return false;
			}
			x_ = param1;
			y_ = param2;
			square_ = loc3;
			return true;
		}

		override public function removeFromMap():void {
			super.removeFromMap();
			removeObjId(this.ownerId_, this.bulletId_);
			this.multiHitDict_ = null;
			FreeList.deleteObject(this);
		}

		private function positionAt(param1:int, param2:Point):void {
			var loc5:Number = NaN;
			var loc6:Number = NaN;
			var loc7:Number = NaN;
			var loc8:Number = NaN;
			var loc9:Number = NaN;
			var loc10:Number = NaN;
			var loc11:Number = NaN;
			var loc12:Number = NaN;
			var loc13:Number = NaN;
			var loc14:Number = NaN;
			param2.x = this.startX_;
			param2.y = this.startY_;
			var loc3:Number = param1 * (this.projProps_.speed_ / 10000);
			var loc4:Number = this.bulletId_ % 2 == 0 ? Number(0) : Number(Math.PI);
			if (this.projProps_.wavy_) {
				loc5 = 6 * Math.PI;
				loc6 = Math.PI / 64;
				loc7 = this.angle_ + loc6 * Math.sin(loc4 + loc5 * param1 / 1000);
				param2.x = param2.x + loc3 * Math.cos(loc7);
				param2.y = param2.y + loc3 * Math.sin(loc7);
			} else if (this.projProps_.parametric_) {
				loc8 = param1 / this.projProps_.lifetime_ * 2 * Math.PI;
				loc9 = Math.sin(loc8) * (!!(this.bulletId_ % 2) ? 1 : -1);
				loc10 = Math.sin(2 * loc8) * (this.bulletId_ % 4 < 2 ? 1 : -1);
				loc11 = Math.sin(this.angle_);
				loc12 = Math.cos(this.angle_);
				param2.x = param2.x + (loc9 * loc12 - loc10 * loc11) * this.projProps_.magnitude_;
				param2.y = param2.y + (loc9 * loc11 + loc10 * loc12) * this.projProps_.magnitude_;
			} else {
				if (this.projProps_.boomerang_) {
					loc13 = this.projProps_.lifetime_ * (this.projProps_.speed_ / 10000) / 2;
					if (loc3 > loc13) {
						loc3 = loc13 - (loc3 - loc13);
					}
				}
				param2.x = param2.x + loc3 * Math.cos(this.angle_);
				param2.y = param2.y + loc3 * Math.sin(this.angle_);
				if (this.projProps_.amplitude_ != 0) {
					loc14 = this.projProps_.amplitude_ * Math.sin(loc4 + param1 / this.projProps_.lifetime_ * this.projProps_.frequency_ * 2 * Math.PI);
					param2.x = param2.x + loc14 * Math.cos(this.angle_ + Math.PI / 2);
					param2.y = param2.y + loc14 * Math.sin(this.angle_ + Math.PI / 2);
				}
			}
		}

		override public function update(param1:int, param2:int):Boolean {
			var loc5:Vector.<uint> = null;
			var loc7:Player = null;
			var loc8:* = false;
			var loc9:Boolean = false;
			var loc10:Boolean = false;
			var loc11:int = 0;
			var loc12:Boolean = false;
			var loc3:int = param1 - this.startTime_;
			if (loc3 > this.projProps_.lifetime_) {
				return false;
			}
			var loc4:Point = this.staticPoint_;
			this.positionAt(loc3, loc4);
			if (!this.moveTo(loc4.x, loc4.y) || square_.tileType_ == 65535) {
				if (this.damagesPlayers_) {
					map_.gs_.gsc_.squareHit(param1, this.bulletId_, this.ownerId_);
				} else if (square_.obj_ != null) {
					if (!Parameters.data_.noParticlesMaster) {
						loc5 = BloodComposition.getColors(this.texture_);
						map_.addObj(new HitEffect(loc5, 100, 3, this.angle_, this.projProps_.speed_), loc4.x, loc4.y);
					}
				}
				return false;
			}
			if (square_.obj_ != null && (!square_.obj_.props_.isEnemy_ || !this.damagesEnemies_) && (square_.obj_.props_.enemyOccupySquare_ || !this.projProps_.passesCover_ && square_.obj_.props_.occupySquare_)) {
				if (this.damagesPlayers_) {
					map_.gs_.gsc_.otherHit(param1, this.bulletId_, this.ownerId_, square_.obj_.objectId_);
				} else if (!Parameters.data_.noParticlesMaster) {
					loc5 = BloodComposition.getColors(this.texture_);
					map_.addObj(new HitEffect(loc5, 100, 3, this.angle_, this.projProps_.speed_), loc4.x, loc4.y);
				}
				return false;
			}
			var loc6:GameObject = this.getHit(loc4.x, loc4.y);
			if (loc6 != null) {
				loc7 = map_.player_;
				loc8 = loc7 != null;
				loc9 = loc6.props_.isEnemy_;
				loc10 = loc8 && !loc7.isPaused() && (this.damagesPlayers_ || loc9 && this.ownerId_ == loc7.objectId_);
				if (loc10) {
					loc11 = GameObject.damageWithDefense(this.damage_, loc6.defense_, this.projProps_.armorPiercing_, loc6.condition_);
					loc12 = false;
					if (loc6.hp_ <= loc11) {
						loc12 = true;
						if (loc6.props_.isEnemy_) {
							doneAction(map_.gs_, Tutorial.KILL_ACTION);
						}
					}
					if (loc6 == loc7) {
						map_.gs_.gsc_.playerHit(this.bulletId_, this.ownerId_);
						loc6.damage(true, loc11, this.projProps_.effects_, false, this);
					} else if (loc6.props_.isEnemy_) {
						map_.gs_.gsc_.enemyHit(param1, this.bulletId_, loc6.objectId_, loc12);
						loc6.damage(true, loc11, this.projProps_.effects_, loc12, this);
					} else if (!this.projProps_.multiHit_) {
						map_.gs_.gsc_.otherHit(param1, this.bulletId_, this.ownerId_, loc6.objectId_);
					}
				}
				if (this.projProps_.multiHit_) {
					this.multiHitDict_[loc6] = true;
				} else {
					return false;
				}
			}
			return true;
		}

		public function getHit(param1:Number, param2:Number):GameObject {
			var loc5:GameObject = null;
			var loc6:Number = NaN;
			var loc7:Number = NaN;
			var loc8:Number = NaN;
			var loc9:Number = NaN;
			var loc3:Number = Number.MAX_VALUE;
			var loc4:GameObject = null;
			for each(loc5 in map_.goDict_) {
				if (!loc5.isInvincible()) {
					if (!loc5.isStasis()) {
						if (this.damagesEnemies_ && loc5.props_.isEnemy_ || this.damagesPlayers_ && loc5.props_.isPlayer_) {
							if (!(loc5.dead_ || loc5.isPaused())) {
								loc6 = loc5.x_ > param1 ? Number(loc5.x_ - param1) : Number(param1 - loc5.x_);
								loc7 = loc5.y_ > param2 ? Number(loc5.y_ - param2) : Number(param2 - loc5.y_);
								if (!(loc6 > loc5.radius_ || loc7 > loc5.radius_)) {
									if (!(this.projProps_.multiHit_ && this.multiHitDict_[loc5] != null)) {
										if (loc5 == map_.player_) {
											return loc5;
										}
										loc8 = Math.sqrt(loc6 * loc6 + loc7 * loc7);
										loc9 = loc6 * loc6 + loc7 * loc7;
										if (loc9 < loc3) {
											loc3 = loc9;
											loc4 = loc5;
										}
									}
								}
							}
						}
					}
				}
			}
			return loc4;
		}

		override public function draw(param1:Vector.<IGraphicsData>, param2:Camera, param3:int):void {
			var loc8:uint = 0;
			var loc9:uint = 0;
			var loc10:int = 0;
			var loc11:int = 0;
			if (!Parameters.drawProj_) {
				return;
			}
			var loc4:BitmapData = this.texture_;
			if (Parameters.projColorType_ != 0) {
				switch (Parameters.projColorType_) {
					case 1:
						loc8 = 16777100;
						loc9 = 16777215;
						break;
					case 2:
						loc8 = 16777100;
						loc9 = 16777100;
						break;
					case 3:
						loc8 = 16711680;
						loc9 = 16711680;
						break;
					case 4:
						loc8 = 255;
						loc9 = 255;
						break;
					case 5:
						loc8 = 16777215;
						loc9 = 16777215;
						break;
					case 6:
						loc8 = 0;
						loc9 = 0;
				}
				loc4 = TextureRedrawer.redraw(loc4, 120, true, loc9);
			}
			var loc5:Number = this.props_.rotation_ == 0 ? Number(0) : Number(param3 / this.props_.rotation_);
			this.staticVector3D_.x = x_;
			this.staticVector3D_.y = y_;
			this.staticVector3D_.z = z_;
			var loc6:Number = !!this.projProps_.faceDir_ ? Number(this.getDirectionAngle(param3)) : Number(this.angle_);
			var loc7:Number = !!this.projProps_.noRotation_ ? Number(param2.angleRad_ + this.props_.angleCorrection_) : Number(loc6 - param2.angleRad_ + this.props_.angleCorrection_ + loc5);
			this.p_.draw(param1, this.staticVector3D_, loc7, param2.wToS_, param2, loc4);
			if (!Parameters.data_.noParticlesMaster && this.projProps_.particleTrail_) {
				loc10 = this.projProps_.particleTrailLifetimeMS != -1 ? int(this.projProps_.particleTrailLifetimeMS) : 600;
				loc11 = 0;
				for (; loc11 < 3; loc11++) {
					if (map_ != null && map_.player_.objectId_ != this.ownerId_) {
						if (this.projProps_.particleTrailIntensity_ == -1 && Math.random() * 100 > this.projProps_.particleTrailIntensity_) {
							continue;
						}
					}
					map_.addObj(new SparkParticle(100, this.projProps_.particleTrailColor_, loc10, 0.5, RandomUtil.plusMinus(3), RandomUtil.plusMinus(3)), x_, y_);
				}
			}
		}

		private function getDirectionAngle(param1:Number):Number {
			var loc2:int = param1 - this.startTime_;
			var loc3:Point = new Point();
			this.positionAt(loc2 + 16, loc3);
			var loc4:Number = loc3.x - x_;
			var loc5:Number = loc3.y - y_;
			return Math.atan2(loc5, loc4);
		}

		override public function drawShadow(param1:Vector.<IGraphicsData>, param2:Camera, param3:int):void {
			if (!Parameters.drawProj_) {
				return;
			}
			var loc4:Number = this.props_.shadowSize_ / 400;
			var loc5:Number = 30 * loc4;
			var loc6:Number = 15 * loc4;
			this.shadowGradientFill_.matrix.createGradientBox(loc5 * 2, loc6 * 2, 0, posS_[0] - loc5, posS_[1] - loc6);
			param1.push(this.shadowGradientFill_);
			this.shadowPath_.data.length = 0;
			Vector.<Number>(this.shadowPath_.data).push(posS_[0] - loc5, posS_[1] - loc6, posS_[0] + loc5, posS_[1] - loc6, posS_[0] + loc5, posS_[1] + loc6, posS_[0] - loc5, posS_[1] + loc6);
			param1.push(this.shadowPath_);
			param1.push(GraphicsUtil.END_FILL);
		}
	}
}
