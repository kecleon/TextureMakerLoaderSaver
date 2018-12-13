 
package kabam.rotmg.minimap.view {
	import com.company.assembleegameclient.map.AbstractMap;
	import com.company.assembleegameclient.map.GroundLibrary;
	import com.company.assembleegameclient.objects.Character;
	import com.company.assembleegameclient.objects.GameObject;
	import com.company.assembleegameclient.objects.GuildHallPortal;
	import com.company.assembleegameclient.objects.Player;
	import com.company.assembleegameclient.objects.Portal;
	import com.company.assembleegameclient.parameters.Parameters;
	import com.company.assembleegameclient.ui.menu.PlayerGroupMenu;
	import com.company.assembleegameclient.ui.tooltip.PlayerGroupToolTip;
	import com.company.util.AssetLibrary;
	import com.company.util.PointUtil;
	import com.company.util.RectangleUtil;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	public class MiniMapImp extends MiniMap {
		
		public static const MOUSE_DIST_SQ:int = 5 * 5;
		
		private static var objectTypeColorDict_:Dictionary = new Dictionary();
		 
		
		public var _width:int;
		
		public var _height:int;
		
		public var zoomIndex:int = 0;
		
		public var windowRect_:Rectangle;
		
		public var active:Boolean = true;
		
		public var maxWH_:Point;
		
		public var miniMapData_:BitmapData;
		
		public var zoomLevels:Vector.<Number>;
		
		public var blueArrow_:BitmapData;
		
		public var groundLayer_:Shape;
		
		public var characterLayer_:Shape;
		
		public var enemyLayer_:Shape;
		
		private var focus:GameObject;
		
		private var zoomButtons:MiniMapZoomButtons;
		
		private var isMouseOver:Boolean = false;
		
		private var tooltip:PlayerGroupToolTip = null;
		
		private var menu:PlayerGroupMenu = null;
		
		private var mapMatrix_:Matrix;
		
		private var arrowMatrix_:Matrix;
		
		private var players_:Vector.<Player>;
		
		private var tempPoint:Point;
		
		private var _rotateEnableFlag:Boolean;
		
		public function MiniMapImp(param1:int, param2:int) {
			this.zoomLevels = new Vector.<Number>();
			this.mapMatrix_ = new Matrix();
			this.arrowMatrix_ = new Matrix();
			this.players_ = new Vector.<Player>();
			this.tempPoint = new Point();
			super();
			this._width = param1;
			this._height = param2;
			this._rotateEnableFlag = Parameters.data_.allowMiniMapRotation;
			this.makeVisualLayers();
			this.addMouseListeners();
		}
		
		public static function gameObjectToColor(param1:GameObject) : uint {
			var loc2:* = param1.objectType_;
			if(!objectTypeColorDict_.hasOwnProperty(loc2)) {
				objectTypeColorDict_[loc2] = param1.getColor();
			}
			return objectTypeColorDict_[loc2];
		}
		
		override public function setMap(param1:AbstractMap) : void {
			this.map = param1;
			this.makeViewModel();
		}
		
		override public function setFocus(param1:GameObject) : void {
			this.focus = param1;
		}
		
		private function makeViewModel() : void {
			this.windowRect_ = new Rectangle(-this._width / 2,-this._height / 2,this._width,this._height);
			this.maxWH_ = new Point(map.width_,map.height_);
			this.miniMapData_ = new BitmapDataSpy(this.maxWH_.x,this.maxWH_.y,false,0);
			var loc1:Number = Math.max(this._width / this.maxWH_.x,this._height / this.maxWH_.y);
			var loc2:Number = 4;
			while(loc2 > loc1) {
				this.zoomLevels.push(loc2);
				loc2 = loc2 / 2;
			}
			this.zoomLevels.push(loc1);
			this.zoomButtons && this.zoomButtons.setZoomLevels(this.zoomLevels.length);
		}
		
		private function makeVisualLayers() : void {
			this.blueArrow_ = AssetLibrary.getImageFromSet("lofiInterface",54).clone();
			this.blueArrow_.colorTransform(this.blueArrow_.rect,new ColorTransform(0,0,1));
			graphics.clear();
			graphics.beginFill(1776411);
			graphics.drawRect(0,0,this._width,this._height);
			graphics.endFill();
			this.groundLayer_ = new Shape();
			this.groundLayer_.x = this._width / 2;
			this.groundLayer_.y = this._height / 2;
			addChild(this.groundLayer_);
			this.characterLayer_ = new Shape();
			this.characterLayer_.x = this._width / 2;
			this.characterLayer_.y = this._height / 2;
			addChild(this.characterLayer_);
			this.enemyLayer_ = new Shape();
			this.enemyLayer_.x = this._width / 2;
			this.enemyLayer_.y = this._height / 2;
			addChild(this.enemyLayer_);
			this.zoomButtons = new MiniMapZoomButtons();
			this.zoomButtons.x = this._width - 20;
			this.zoomButtons.zoom.add(this.onZoomChanged);
			this.zoomButtons.setZoomLevels(this.zoomLevels.length);
			addChild(this.zoomButtons);
		}
		
		private function addMouseListeners() : void {
			addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
			addEventListener(MouseEvent.RIGHT_CLICK,this.onMapRightClick);
			addEventListener(MouseEvent.CLICK,this.onMapClick);
			addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
		}
		
		private function onRemovedFromStage(param1:Event) : void {
			this.active = false;
			this.removeDecorations();
		}
		
		public function dispose() : void {
			this.miniMapData_.dispose();
			this.miniMapData_ = null;
			this.removeDecorations();
		}
		
		private function onZoomChanged(param1:int) : void {
			this.zoomIndex = param1;
		}
		
		private function onMouseOver(param1:MouseEvent) : void {
			this.isMouseOver = true;
		}
		
		private function onMouseOut(param1:MouseEvent) : void {
			this.isMouseOver = false;
		}
		
		private function onMapRightClick(param1:MouseEvent) : void {
			this._rotateEnableFlag = !this._rotateEnableFlag && Parameters.data_.allowMiniMapRotation;
		}
		
		private function onMapClick(param1:MouseEvent) : void {
			if(this.tooltip == null || this.tooltip.parent == null || this.tooltip.players_ == null || this.tooltip.players_.length == 0) {
				return;
			}
			this.removeMenu();
			this.addMenu();
			this.removeTooltip();
		}
		
		private function addMenu() : void {
			this.menu = new PlayerGroupMenu(map,this.tooltip.players_);
			this.menu.x = this.tooltip.x + 12;
			this.menu.y = this.tooltip.y;
			menuLayer.addChild(this.menu);
		}
		
		override public function setGroundTile(param1:int, param2:int, param3:uint) : void {
			var loc4:uint = GroundLibrary.getColor(param3);
			this.miniMapData_.setPixel(param1,param2,loc4);
		}
		
		override public function setGameObjectTile(param1:int, param2:int, param3:GameObject) : void {
			var loc4:uint = gameObjectToColor(param3);
			this.miniMapData_.setPixel(param1,param2,loc4);
		}
		
		private function removeDecorations() : void {
			this.removeTooltip();
			this.removeMenu();
		}
		
		private function removeTooltip() : void {
			if(this.tooltip != null) {
				if(this.tooltip.parent != null) {
					this.tooltip.parent.removeChild(this.tooltip);
				}
				this.tooltip = null;
			}
		}
		
		private function removeMenu() : void {
			if(this.menu != null) {
				if(this.menu.parent != null) {
					this.menu.parent.removeChild(this.menu);
				}
				this.menu = null;
			}
		}
		
		override public function draw() : void {
			var loc7:Graphics = null;
			var loc8:Graphics = null;
			var loc11:GameObject = null;
			var loc16:uint = 0;
			var loc17:Player = null;
			var loc18:Number = NaN;
			var loc19:Number = NaN;
			var loc20:Number = NaN;
			var loc21:Number = NaN;
			var loc22:Number = NaN;
			this._rotateEnableFlag = this._rotateEnableFlag && Parameters.data_.allowMiniMapRotation;
			this.groundLayer_.graphics.clear();
			this.characterLayer_.graphics.clear();
			this.enemyLayer_.graphics.clear();
			if(!this.focus) {
				return;
			}
			if(!this.active) {
				return;
			}
			var loc1:Number = this.zoomLevels[this.zoomIndex];
			this.mapMatrix_.identity();
			this.mapMatrix_.translate(-this.focus.x_,-this.focus.y_);
			this.mapMatrix_.scale(loc1,loc1);
			var loc2:Point = this.mapMatrix_.transformPoint(PointUtil.ORIGIN);
			var loc3:Point = this.mapMatrix_.transformPoint(this.maxWH_);
			var loc4:Number = 0;
			if(loc2.x > this.windowRect_.left) {
				loc4 = this.windowRect_.left - loc2.x;
			} else if(loc3.x < this.windowRect_.right) {
				loc4 = this.windowRect_.right - loc3.x;
			}
			var loc5:Number = 0;
			if(loc2.y > this.windowRect_.top) {
				loc5 = this.windowRect_.top - loc2.y;
			} else if(loc3.y < this.windowRect_.bottom) {
				loc5 = this.windowRect_.bottom - loc3.y;
			}
			this.mapMatrix_.translate(loc4,loc5);
			loc2 = this.mapMatrix_.transformPoint(PointUtil.ORIGIN);
			if(loc1 >= 1 && this._rotateEnableFlag) {
				this.mapMatrix_.rotate(-Parameters.data_.cameraAngle);
			}
			var loc6:Rectangle = new Rectangle();
			loc6.x = Math.max(this.windowRect_.x,loc2.x);
			loc6.y = Math.max(this.windowRect_.y,loc2.y);
			loc6.right = Math.min(this.windowRect_.right,loc2.x + this.maxWH_.x * loc1);
			loc6.bottom = Math.min(this.windowRect_.bottom,loc2.y + this.maxWH_.y * loc1);
			loc7 = this.groundLayer_.graphics;
			loc7.beginBitmapFill(this.miniMapData_,this.mapMatrix_,false);
			loc7.drawRect(loc6.x,loc6.y,loc6.width,loc6.height);
			loc7.endFill();
			loc7 = this.characterLayer_.graphics;
			loc8 = this.enemyLayer_.graphics;
			var loc9:Number = mouseX - this._width / 2;
			var loc10:Number = mouseY - this._height / 2;
			this.players_.length = 0;
			for each(loc11 in map.goDict_) {
				if(!(loc11.props_.noMiniMap_ || loc11 == this.focus)) {
					loc17 = loc11 as Player;
					if(loc17 != null) {
						if(loc17.isPaused()) {
							loc16 = 8355711;
						} else if(Parameters.data_.newMiniMapColors && loc17.isFellowGuild_ && !loc17.starred_) {
							loc16 = 52992;
						} else if(loc17.isFellowGuild_) {
							loc16 = 65280;
						} else if(Parameters.data_.newMiniMapColors && !loc17.nameChosen_ && loc17.starred_) {
							loc16 = 16777215;
						} else if(Parameters.data_.newMiniMapColors && !loc17.nameChosen_) {
							loc16 = 13619151;
						} else if(Parameters.data_.newMiniMapColors && !loc17.starred_) {
							loc16 = 13618944;
						} else {
							loc16 = 16776960;
						}
					} else if(loc11 is Character) {
						if(loc11.props_.isEnemy_) {
							if(loc11.props_.color_ != -1) {
								loc16 = loc11.props_.color_;
							} else {
								loc16 = 16711680;
							}
						} else {
							loc16 = gameObjectToColor(loc11);
						}
					} else if(loc11 is Portal || loc11 is GuildHallPortal) {
						loc16 = 255;
					} else {
						continue;
					}
					loc18 = this.mapMatrix_.a * loc11.x_ + this.mapMatrix_.c * loc11.y_ + this.mapMatrix_.tx;
					loc19 = this.mapMatrix_.b * loc11.x_ + this.mapMatrix_.d * loc11.y_ + this.mapMatrix_.ty;
					if(loc18 <= -this._width / 2 || loc18 >= this._width / 2 || loc19 <= -this._height / 2 || loc19 >= this._height / 2) {
						RectangleUtil.lineSegmentIntersectXY(this.windowRect_,0,0,loc18,loc19,this.tempPoint);
						loc18 = this.tempPoint.x;
						loc19 = this.tempPoint.y;
					}
					if(loc17 != null && this.isMouseOver && (this.menu == null || this.menu.parent == null)) {
						loc20 = loc9 - loc18;
						loc21 = loc10 - loc19;
						loc22 = loc20 * loc20 + loc21 * loc21;
						if(loc22 < MOUSE_DIST_SQ) {
							this.players_.push(loc17);
						}
					}
					if(loc11 is Character && loc11.props_.isEnemy_) {
						loc8.beginFill(loc16);
						loc8.drawRect(loc18 - 2,loc19 - 2,4,4);
						loc8.endFill();
					} else {
						loc7.beginFill(loc16);
						loc7.drawRect(loc18 - 2,loc19 - 2,4,4);
						loc7.endFill();
					}
				}
			}
			if(this.players_.length != 0) {
				if(this.tooltip == null) {
					this.tooltip = new PlayerGroupToolTip(this.players_);
					menuLayer.addChild(this.tooltip);
				} else if(!this.areSamePlayers(this.tooltip.players_,this.players_)) {
					this.tooltip.setPlayers(this.players_);
				}
			} else if(this.tooltip != null) {
				if(this.tooltip.parent != null) {
					this.tooltip.parent.removeChild(this.tooltip);
				}
				this.tooltip = null;
			}
			var loc12:Number = this.focus.x_;
			var loc13:Number = this.focus.y_;
			var loc14:Number = this.mapMatrix_.a * loc12 + this.mapMatrix_.c * loc13 + this.mapMatrix_.tx;
			var loc15:Number = this.mapMatrix_.b * loc12 + this.mapMatrix_.d * loc13 + this.mapMatrix_.ty;
			this.arrowMatrix_.identity();
			this.arrowMatrix_.translate(-4,-5);
			this.arrowMatrix_.scale(8 / this.blueArrow_.width,32 / this.blueArrow_.height);
			if(!(loc1 >= 1 && this._rotateEnableFlag)) {
				this.arrowMatrix_.rotate(Parameters.data_.cameraAngle);
			}
			this.arrowMatrix_.translate(loc14,loc15);
			loc7.beginBitmapFill(this.blueArrow_,this.arrowMatrix_,false);
			loc7.drawRect(loc14 - 16,loc15 - 16,32,32);
			loc7.endFill();
		}
		
		private function areSamePlayers(param1:Vector.<Player>, param2:Vector.<Player>) : Boolean {
			var loc3:int = param1.length;
			if(loc3 != param2.length) {
				return false;
			}
			var loc4:int = 0;
			while(loc4 < loc3) {
				if(param1[loc4] != param2[loc4]) {
					return false;
				}
				loc4++;
			}
			return true;
		}
		
		override public function zoomIn() : void {
			this.zoomIndex = this.zoomButtons.setZoomLevel(this.zoomIndex - 1);
		}
		
		override public function zoomOut() : void {
			this.zoomIndex = this.zoomButtons.setZoomLevel(this.zoomIndex + 1);
		}
		
		override public function deactivate() : void {
		}
	}
}
