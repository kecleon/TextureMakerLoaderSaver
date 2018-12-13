package com.company.assembleegameclient.map {
	import com.company.assembleegameclient.background.Background;
	import com.company.assembleegameclient.game.AGameSprite;
	import com.company.assembleegameclient.map.mapoverlay.MapOverlay;
	import com.company.assembleegameclient.map.partyoverlay.PartyOverlay;
	import com.company.assembleegameclient.objects.BasicObject;
	import com.company.assembleegameclient.objects.GameObject;
	import com.company.assembleegameclient.objects.Party;
	import com.company.assembleegameclient.objects.particles.ParticleEffect;
	import com.company.assembleegameclient.parameters.Parameters;
	import com.company.assembleegameclient.util.ConditionEffect;

	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.GraphicsBitmapFill;
	import flash.display.GraphicsSolidFill;
	import flash.display.IGraphicsData;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	import kabam.rotmg.assets.EmbeddedAssets;
	import kabam.rotmg.core.StaticInjectorContext;
	import kabam.rotmg.game.logging.RollingMeanLoopMonitor;
	import kabam.rotmg.game.model.GameModel;
	import kabam.rotmg.stage3D.GraphicsFillExtra;
	import kabam.rotmg.stage3D.Object3D.Object3DStage3D;
	import kabam.rotmg.stage3D.Render3D;
	import kabam.rotmg.stage3D.Renderer;
	import kabam.rotmg.stage3D.graphic3D.Program3DFactory;
	import kabam.rotmg.stage3D.graphic3D.TextureFactory;

	public class Map extends AbstractMap {

		public static const CLOTH_BAZAAR:String = "Cloth Bazaar";

		public static const NEXUS:String = "Nexus";

		public static const DAILY_QUEST_ROOM:String = "Daily Quest Room";

		public static const DAILY_LOGIN_ROOM:String = "Daily Login Room";

		public static const PET_YARD_1:String = "Pet Yard";

		public static const PET_YARD_2:String = "Pet Yard 2";

		public static const PET_YARD_3:String = "Pet Yard 3";

		public static const PET_YARD_4:String = "Pet Yard 4";

		public static const PET_YARD_5:String = "Pet Yard 5";

		public static const GUILD_HALL:String = "Guild Hall";

		public static const NEXUS_EXPLANATION:String = "Nexus_Explanation";

		public static const VAULT:String = "Vault";

		public static var forceSoftwareRender:Boolean = false;

		private static const VISIBLE_SORT_FIELDS:Array = ["sortVal_", "objectId_"];

		private static const VISIBLE_SORT_PARAMS:Array = [Array.NUMERIC, Array.NUMERIC];

		protected static const BLIND_FILTER:ColorMatrixFilter = new ColorMatrixFilter([0.05, 0.05, 0.05, 0, 0, 0.05, 0.05, 0.05, 0, 0, 0.05, 0.05, 0.05, 0, 0, 0.05, 0.05, 0.05, 1, 0]);

		protected static var BREATH_CT:ColorTransform = new ColorTransform(255 / 255, 55 / 255, 0 / 255, 0);

		public static var texture:BitmapData;


		public var ifDrawEffectFlag:Boolean = true;

		private var loopMonitor:RollingMeanLoopMonitor;

		private var inUpdate_:Boolean = false;

		private var objsToAdd_:Vector.<BasicObject>;

		private var idsToRemove_:Vector.<int>;

		private var forceSoftwareMap:Dictionary;

		private var lastSoftwareClear:Boolean = false;

		private var darkness:DisplayObject;

		private var bgCont:Sprite;

		private var graphicsData_:Vector.<IGraphicsData>;

		private var graphicsDataStageSoftware_:Vector.<IGraphicsData>;

		private var graphicsData3d_:Vector.<Object3DStage3D>;

		public var visible_:Array;

		public var visibleUnder_:Array;

		public var visibleSquares_:Vector.<Square>;

		public var topSquares_:Vector.<Square>;

		public function Map(param1:AGameSprite) {
			this.objsToAdd_ = new Vector.<BasicObject>();
			this.idsToRemove_ = new Vector.<int>();
			this.forceSoftwareMap = new Dictionary();
			this.darkness = new EmbeddedAssets.DarknessBackground();
			this.bgCont = new Sprite();
			this.graphicsData_ = new Vector.<IGraphicsData>();
			this.graphicsDataStageSoftware_ = new Vector.<IGraphicsData>();
			this.graphicsData3d_ = new Vector.<Object3DStage3D>();
			this.visible_ = new Array();
			this.visibleUnder_ = new Array();
			this.visibleSquares_ = new Vector.<Square>();
			this.topSquares_ = new Vector.<Square>();
			super();
			gs_ = param1;
			mapHitArea = new Sprite();
			hurtOverlay_ = new HurtOverlay();
			gradientOverlay_ = new GradientOverlay();
			mapOverlay_ = new MapOverlay();
			partyOverlay_ = new PartyOverlay(this);
			party_ = new Party(this);
			quest_ = new Quest(this);
			this.loopMonitor = StaticInjectorContext.getInjector().getInstance(RollingMeanLoopMonitor);
			StaticInjectorContext.getInjector().getInstance(GameModel).gameObjects = goDict_;
			this.forceSoftwareMap[PET_YARD_1] = true;
			this.forceSoftwareMap[PET_YARD_2] = true;
			this.forceSoftwareMap[PET_YARD_3] = true;
			this.forceSoftwareMap[PET_YARD_4] = true;
			this.forceSoftwareMap[PET_YARD_5] = true;
			this.forceSoftwareMap["Nexus"] = true;
			this.forceSoftwareMap["Tomb of the Ancients"] = true;
			this.forceSoftwareMap["Tomb of the Ancients (Heroic)"] = true;
			this.forceSoftwareMap["Mad Lab"] = true;
			this.forceSoftwareMap["Guild Hall"] = true;
			this.forceSoftwareMap["Guild Hall 2"] = true;
			this.forceSoftwareMap["Guild Hall 3"] = true;
			this.forceSoftwareMap["Guild Hall 4"] = true;
			this.forceSoftwareMap["Cloth Bazaar"] = true;
			this.forceSoftwareMap["Santa Workshop"] = true;
			wasLastFrameGpu = Parameters.isGpuRender();
		}

		override public function setProps(param1:int, param2:int, param3:String, param4:int, param5:Boolean, param6:Boolean):void {
			width_ = param1;
			height_ = param2;
			name_ = param3;
			back_ = param4;
			allowPlayerTeleport_ = param5;
			showDisplays_ = param6;
			this.forceSoftwareRenderCheck(name_);
		}

		override public function setHitAreaProps(param1:int, param2:int):void {
			mapHitArea.graphics.beginFill(16711680, 0);
			mapHitArea.graphics.drawRect(-param1 / 2, -param2 / 2 - 20, param1, param2);
		}

		private function forceSoftwareRenderCheck(param1:String):void {
			forceSoftwareRender = this.forceSoftwareMap[param1] != null || WebMain.STAGE != null && WebMain.STAGE.stage3Ds[0].context3D == null;
		}

		override public function initialize():void {
			squares_.length = width_ * height_;
			addChild(this.bgCont);
			background_ = Background.getBackground(back_);
			if (!Parameters.isGpuRender()) {
				if (background_ != null) {
					this.bgCont.addChild(background_);
				}
			}
			addChild(map_);
			addChild(mapHitArea);
			addChild(hurtOverlay_);
			addChild(gradientOverlay_);
			addChild(mapOverlay_);
			addChild(partyOverlay_);
			isPetYard = name_.substr(0, 8) == "Pet Yard";
		}

		override public function dispose():void {
			var loc1:Square = null;
			var loc2:GameObject = null;
			var loc3:BasicObject = null;
			gs_ = null;
			background_ = null;
			map_ = null;
			mapHitArea.graphics.clear();
			mapHitArea = null;
			hurtOverlay_ = null;
			gradientOverlay_ = null;
			mapOverlay_ = null;
			partyOverlay_ = null;
			for each(loc1 in squareList_) {
				loc1.dispose();
			}
			squareList_.length = 0;
			squareList_ = null;
			squares_.length = 0;
			squares_ = null;
			for each(loc2 in goDict_) {
				loc2.dispose();
			}
			goDict_ = null;
			for each(loc3 in boDict_) {
				loc3.dispose();
			}
			boDict_ = null;
			merchLookup_ = null;
			player_ = null;
			party_ = null;
			quest_ = null;
			this.objsToAdd_ = null;
			this.idsToRemove_ = null;
			TextureFactory.disposeTextures();
			GraphicsFillExtra.dispose();
			Program3DFactory.getInstance().dispose();
		}

		override public function update(param1:int, param2:int):void {
			var loc3:BasicObject = null;
			var loc4:int = 0;
			this.inUpdate_ = true;
			for each(loc3 in goDict_) {
				if (!loc3.update(param1, param2)) {
					this.idsToRemove_.push(loc3.objectId_);
				}
			}
			for each(loc3 in boDict_) {
				if (!loc3.update(param1, param2)) {
					this.idsToRemove_.push(loc3.objectId_);
				}
			}
			this.inUpdate_ = false;
			for each(loc3 in this.objsToAdd_) {
				this.internalAddObj(loc3);
			}
			this.objsToAdd_.length = 0;
			for each(loc4 in this.idsToRemove_) {
				this.internalRemoveObj(loc4);
			}
			this.idsToRemove_.length = 0;
			party_.update(param1, param2);
		}

		override public function pSTopW(param1:Number, param2:Number):Point {
			var loc3:Square = null;
			for each(loc3 in this.visibleSquares_) {
				if (loc3.faces_.length != 0 && loc3.faces_[0].face_.contains(param1, param2)) {
					return new Point(loc3.center_.x, loc3.center_.y);
				}
			}
			return null;
		}

		override public function setGroundTile(param1:int, param2:int, param3:uint):void {
			var loc8:int = 0;
			var loc9:int = 0;
			var loc10:Square = null;
			var loc4:Square = this.getSquare(param1, param2);
			loc4.setTileType(param3);
			var loc5:int = param1 < width_ - 1 ? int(param1 + 1) : int(param1);
			var loc6:int = param2 < height_ - 1 ? int(param2 + 1) : int(param2);
			var loc7:int = param1 > 0 ? int(param1 - 1) : int(param1);
			while (loc7 <= loc5) {
				loc8 = param2 > 0 ? int(param2 - 1) : int(param2);
				while (loc8 <= loc6) {
					loc9 = loc7 + loc8 * width_;
					loc10 = squares_[loc9];
					if (loc10 != null && (loc10.props_.hasEdge_ || loc10.tileType_ != param3)) {
						loc10.faces_.length = 0;
					}
					loc8++;
				}
				loc7++;
			}
		}

		override public function addObj(param1:BasicObject, param2:Number, param3:Number):void {
			param1.x_ = param2;
			param1.y_ = param3;
			if (param1 is ParticleEffect) {
				(param1 as ParticleEffect).reducedDrawEnabled = !Parameters.data_.particleEffect;
			}
			if (this.inUpdate_) {
				this.objsToAdd_.push(param1);
			} else {
				this.internalAddObj(param1);
			}
		}

		public function internalAddObj(param1:BasicObject):void {
			if (!param1.addTo(this, param1.x_, param1.y_)) {
				return;
			}
			var loc2:Dictionary = param1 is GameObject ? goDict_ : boDict_;
			if (loc2[param1.objectId_] != null) {
				if (!isPetYard) {
					return;
				}
			}
			loc2[param1.objectId_] = param1;
		}

		override public function removeObj(param1:int):void {
			if (this.inUpdate_) {
				this.idsToRemove_.push(param1);
			} else {
				this.internalRemoveObj(param1);
			}
		}

		public function internalRemoveObj(param1:int):void {
			var loc2:Dictionary = goDict_;
			var loc3:BasicObject = loc2[param1];
			if (loc3 == null) {
				loc2 = boDict_;
				loc3 = loc2[param1];
				if (loc3 == null) {
					return;
				}
			}
			loc3.removeFromMap();
			delete loc2[param1];
		}

		public function getSquare(param1:Number, param2:Number):Square {
			if (param1 < 0 || param1 >= width_ || param2 < 0 || param2 >= height_) {
				return null;
			}
			var loc3:int = int(param1) + int(param2) * width_;
			var loc4:Square = squares_[loc3];
			if (loc4 == null) {
				loc4 = new Square(this, int(param1), int(param2));
				squares_[loc3] = loc4;
				squareList_.push(loc4);
			}
			return loc4;
		}

		public function lookupSquare(param1:int, param2:int):Square {
			if (param1 < 0 || param1 >= width_ || param2 < 0 || param2 >= height_) {
				return null;
			}
			return squares_[param1 + param2 * width_];
		}

		override public function draw(param1:Camera, param2:int):void {
			var loc6:Square = null;
			var loc13:GameObject = null;
			var loc14:BasicObject = null;
			var loc15:int = 0;
			var loc16:Number = NaN;
			var loc17:Number = NaN;
			var loc18:Number = NaN;
			var loc19:Number = NaN;
			var loc20:Number = NaN;
			var loc21:uint = 0;
			var loc22:Render3D = null;
			var loc23:int = 0;
			var loc24:Array = null;
			var loc25:Number = NaN;
			if (wasLastFrameGpu != Parameters.isGpuRender()) {
				if (wasLastFrameGpu == true && WebMain.STAGE.stage3Ds[0].context3D != null && !(WebMain.STAGE.stage3Ds[0].context3D != null && WebMain.STAGE.stage3Ds[0].context3D.driverInfo.toLowerCase().indexOf("disposed") != -1)) {
					WebMain.STAGE.stage3Ds[0].context3D.clear();
					WebMain.STAGE.stage3Ds[0].context3D.present();
				} else {
					map_.graphics.clear();
				}
				signalRenderSwitch.dispatch(wasLastFrameGpu);
				wasLastFrameGpu = Parameters.isGpuRender();
				if (Parameters.isGpuRender()) {
					if (background_ != null && this.bgCont.contains(background_)) {
						this.bgCont.removeChild(background_);
					}
				} else if (background_ != null && !this.bgCont.contains(background_)) {
					this.bgCont.addChild(background_);
				}
			}
			var loc3:Rectangle = param1.clipRect_;
			x = -loc3.x;
			y = -loc3.y;
			var loc4:Number = (-loc3.y - loc3.height / 2) / 50;
			var loc5:Point = new Point(param1.x_ + loc4 * Math.cos(param1.angleRad_ - Math.PI / 2), param1.y_ + loc4 * Math.sin(param1.angleRad_ - Math.PI / 2));
			if (background_ != null && this.bgCont.contains(background_)) {
				background_.draw(param1, param2);
			}
			this.visible_.length = 0;
			this.visibleUnder_.length = 0;
			this.visibleSquares_.length = 0;
			this.topSquares_.length = 0;
			var loc7:int = param1.maxDist_;
			var loc8:int = Math.max(0, loc5.x - loc7);
			var loc9:int = Math.min(width_ - 1, loc5.x + loc7);
			var loc10:int = Math.max(0, loc5.y - loc7);
			var loc11:int = Math.min(height_ - 1, loc5.y + loc7);
			this.graphicsData_.length = 0;
			this.graphicsDataStageSoftware_.length = 0;
			this.graphicsData3d_.length = 0;
			var loc12:int = loc8;
			while (loc12 <= loc9) {
				loc15 = loc10;
				while (loc15 <= loc11) {
					loc6 = squares_[loc12 + loc15 * width_];
					if (loc6 != null) {
						loc16 = loc5.x - loc6.center_.x;
						loc17 = loc5.y - loc6.center_.y;
						loc18 = loc16 * loc16 + loc17 * loc17;
						if (loc18 <= param1.maxDistSq_) {
							loc6.lastVisible_ = param2;
							loc6.draw(this.graphicsData_, param1, param2);
							this.visibleSquares_.push(loc6);
							if (loc6.topFace_ != null) {
								this.topSquares_.push(loc6);
							}
						}
					}
					loc15++;
				}
				loc12++;
			}
			for each(loc13 in goDict_) {
				loc13.drawn_ = false;
				if (!(loc13.dead_ || loc13.size_ == 0)) {
					loc6 = loc13.square_;
					if (!(loc6 == null || loc6.lastVisible_ != param2)) {
						loc13.drawn_ = true;
						loc13.computeSortVal(param1);
						if (loc13.props_.drawUnder_) {
							if (loc13.props_.drawOnGround_) {
								loc13.draw(this.graphicsData_, param1, param2);
							} else {
								this.visibleUnder_.push(loc13);
							}
						} else {
							this.visible_.push(loc13);
						}
					}
				}
			}
			for each(loc14 in boDict_) {
				loc14.drawn_ = false;
				loc6 = loc14.square_;
				if (!(loc6 == null || loc6.lastVisible_ != param2)) {
					loc14.drawn_ = true;
					loc14.computeSortVal(param1);
					this.visible_.push(loc14);
				}
			}
			if (this.visibleUnder_.length > 0) {
				this.visibleUnder_.sortOn(VISIBLE_SORT_FIELDS, VISIBLE_SORT_PARAMS);
				for each(loc14 in this.visibleUnder_) {
					loc14.draw(this.graphicsData_, param1, param2);
				}
			}
			this.visible_.sortOn(VISIBLE_SORT_FIELDS, VISIBLE_SORT_PARAMS);
			if (Parameters.data_.drawShadows) {
				for each(loc14 in this.visible_) {
					if (loc14.hasShadow_) {
						loc14.drawShadow(this.graphicsData_, param1, param2);
					}
				}
			}
			for each(loc14 in this.visible_) {
				loc14.draw(this.graphicsData_, param1, param2);
				if (Parameters.isGpuRender()) {
					loc14.draw3d(this.graphicsData3d_);
				}
			}
			if (this.topSquares_.length > 0) {
				for each(loc6 in this.topSquares_) {
					loc6.drawTop(this.graphicsData_, param1, param2);
				}
			}
			if (player_ != null && player_.breath_ >= 0 && player_.breath_ < Parameters.BREATH_THRESH) {
				loc19 = (Parameters.BREATH_THRESH - player_.breath_) / Parameters.BREATH_THRESH;
				loc20 = Math.abs(Math.sin(param2 / 300)) * 0.75;
				BREATH_CT.alphaMultiplier = loc19 * loc20;
				hurtOverlay_.transform.colorTransform = BREATH_CT;
				hurtOverlay_.visible = true;
				hurtOverlay_.x = loc3.left;
				hurtOverlay_.y = loc3.top;
			} else {
				hurtOverlay_.visible = false;
			}
			if (player_ != null && !Parameters.screenShotMode_) {
				gradientOverlay_.visible = true;
				gradientOverlay_.x = loc3.right - 10;
				gradientOverlay_.y = loc3.top;
			} else {
				gradientOverlay_.visible = false;
			}
			if (Parameters.isGpuRender() && Renderer.inGame) {
				loc21 = this.getFilterIndex();
				loc22 = StaticInjectorContext.getInjector().getInstance(Render3D);
				loc22.dispatch(this.graphicsData_, this.graphicsData3d_, width_, height_, param1, loc21);
				loc23 = 0;
				while (loc23 < this.graphicsData_.length) {
					if (this.graphicsData_[loc23] is GraphicsBitmapFill && GraphicsFillExtra.isSoftwareDraw(GraphicsBitmapFill(this.graphicsData_[loc23]))) {
						this.graphicsDataStageSoftware_.push(this.graphicsData_[loc23]);
						this.graphicsDataStageSoftware_.push(this.graphicsData_[loc23 + 1]);
						this.graphicsDataStageSoftware_.push(this.graphicsData_[loc23 + 2]);
					} else if (this.graphicsData_[loc23] is GraphicsSolidFill && GraphicsFillExtra.isSoftwareDrawSolid(GraphicsSolidFill(this.graphicsData_[loc23]))) {
						this.graphicsDataStageSoftware_.push(this.graphicsData_[loc23]);
						this.graphicsDataStageSoftware_.push(this.graphicsData_[loc23 + 1]);
						this.graphicsDataStageSoftware_.push(this.graphicsData_[loc23 + 2]);
					}
					loc23++;
				}
				if (this.graphicsDataStageSoftware_.length > 0) {
					map_.graphics.clear();
					map_.graphics.drawGraphicsData(this.graphicsDataStageSoftware_);
					if (this.lastSoftwareClear) {
						this.lastSoftwareClear = false;
					}
				} else if (!this.lastSoftwareClear) {
					map_.graphics.clear();
					this.lastSoftwareClear = true;
				}
				if (param2 % 149 == 0) {
					GraphicsFillExtra.manageSize();
				}
			} else {
				map_.graphics.clear();
				map_.graphics.drawGraphicsData(this.graphicsData_);
			}
			map_.filters.length = 0;
			if (player_ != null && (player_.condition_[ConditionEffect.CE_FIRST_BATCH] & ConditionEffect.MAP_FILTER_BITMASK) != 0) {
				loc24 = [];
				if (player_.isDrunk()) {
					loc25 = 20 + 10 * Math.sin(param2 / 1000);
					loc24.push(new BlurFilter(loc25, loc25));
				}
				if (player_.isBlind()) {
					loc24.push(BLIND_FILTER);
				}
				map_.filters = loc24;
			} else if (map_.filters.length > 0) {
				map_.filters = [];
			}
			mapOverlay_.draw(param1, param2);
			partyOverlay_.draw(param1, param2);
			if (player_ && player_.isDarkness()) {
				this.darkness.x = -300;
				this.darkness.y = !!Parameters.data_.centerOnPlayer ? Number(-525) : Number(-515);
				this.darkness.alpha = 0.95;
				addChild(this.darkness);
			} else if (contains(this.darkness)) {
				removeChild(this.darkness);
			}
		}

		private function getFilterIndex():uint {
			var loc1:uint = 0;
			if (player_ != null && (player_.condition_[ConditionEffect.CE_FIRST_BATCH] & ConditionEffect.MAP_FILTER_BITMASK) != 0) {
				if (player_.isPaused()) {
					loc1 = Renderer.STAGE3D_FILTER_PAUSE;
				} else if (player_.isBlind()) {
					loc1 = Renderer.STAGE3D_FILTER_BLIND;
				} else if (player_.isDrunk()) {
					loc1 = Renderer.STAGE3D_FILTER_DRUNK;
				}
			}
			return loc1;
		}
	}
}
