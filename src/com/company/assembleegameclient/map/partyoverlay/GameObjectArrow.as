package com.company.assembleegameclient.map.partyoverlay {
	import com.company.assembleegameclient.map.Camera;
	import com.company.assembleegameclient.map.Map;
	import com.company.assembleegameclient.objects.GameObject;
	import com.company.assembleegameclient.parameters.Parameters;
	import com.company.assembleegameclient.ui.menu.Menu;
	import com.company.assembleegameclient.ui.tooltip.ToolTip;
	import com.company.util.RectangleUtil;
	import com.company.util.Trig;

	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class GameObjectArrow extends Sprite {

		public static const SMALL_SIZE:int = 8;

		public static const BIG_SIZE:int = 11;

		public static const DIST:int = 3;

		private static var menu_:Menu = null;


		public var menuLayer:DisplayObjectContainer;

		public var lineColor_:uint;

		public var fillColor_:uint;

		public var go_:GameObject = null;

		public var extraGOs_:Vector.<GameObject>;

		public var map_:Map;

		public var mouseOver_:Boolean = false;

		private var big_:Boolean;

		private var arrow_:Shape;

		protected var tooltip_:ToolTip = null;

		private var tempPoint:Point;

		public function GameObjectArrow(param1:uint, param2:uint, param3:Boolean) {
			this.extraGOs_ = new Vector.<GameObject>();
			this.arrow_ = new Shape();
			this.tempPoint = new Point();
			super();
			this.lineColor_ = param1;
			this.fillColor_ = param2;
			this.big_ = param3;
			addChild(this.arrow_);
			this.drawArrow();
			addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
			addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
			filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
			visible = false;
		}

		public static function removeMenu():void {
			if (menu_ != null) {
				if (menu_.parent != null) {
					menu_.parent.removeChild(menu_);
				}
				menu_ = null;
			}
		}

		protected function onMouseOver(param1:MouseEvent):void {
			this.mouseOver_ = true;
			this.drawArrow();
		}

		protected function onMouseOut(param1:MouseEvent):void {
			this.mouseOver_ = false;
			this.drawArrow();
		}

		protected function onMouseDown(param1:MouseEvent):void {
			if (Parameters.isGpuRender()) {
				this.map_.mapHitArea.dispatchEvent(param1);
			}
		}

		protected function setToolTip(param1:ToolTip):void {
			this.removeTooltip();
			this.tooltip_ = param1;
			if (this.tooltip_ != null) {
				addChild(this.tooltip_);
				this.positionTooltip(this.tooltip_);
			}
		}

		protected function removeTooltip():void {
			if (this.tooltip_ != null) {
				if (this.tooltip_.parent != null) {
					this.tooltip_.parent.removeChild(this.tooltip_);
				}
				this.tooltip_ = null;
			}
		}

		protected function setMenu(param1:Menu):void {
			this.removeTooltip();
			menu_ = param1;
			this.menuLayer.addChild(menu_);
		}

		public function setGameObject(param1:GameObject):void {
			if (this.go_ != param1) {
				this.go_ = param1;
			}
			this.extraGOs_.length = 0;
			if (this.go_ == null) {
				visible = false;
			}
		}

		public function addGameObject(param1:GameObject):void {
			this.extraGOs_.push(param1);
		}

		public function draw(param1:int, param2:Camera):void {
			var loc3:Rectangle = null;
			var loc4:Number = NaN;
			var loc5:Number = NaN;
			if (this.go_ == null) {
				visible = false;
				return;
			}
			this.go_.computeSortVal(param2);
			loc3 = param2.clipRect_;
			loc4 = this.go_.posS_[0];
			loc5 = this.go_.posS_[1];
			if (!RectangleUtil.lineSegmentIntersectXY(param2.clipRect_, 0, 0, loc4, loc5, this.tempPoint)) {
				this.go_ = null;
				visible = false;
				return;
			}
			x = this.tempPoint.x;
			y = this.tempPoint.y;
			var loc6:Number = Trig.boundTo180(270 - Trig.toDegrees * Math.atan2(loc4, loc5));
			if (this.tempPoint.x < loc3.left + 5) {
				if (loc6 > 45) {
					loc6 = 45;
				}
				if (loc6 < -45) {
					loc6 = -45;
				}
			} else if (this.tempPoint.x > loc3.right - 5) {
				if (loc6 > 0) {
					if (loc6 < 135) {
						loc6 = 135;
					}
				} else if (loc6 > -135) {
					loc6 = -135;
				}
			}
			if (this.tempPoint.y < loc3.top + 5) {
				if (loc6 < 45) {
					loc6 = 45;
				}
				if (loc6 > 135) {
					loc6 = 135;
				}
			} else if (this.tempPoint.y > loc3.bottom - 5) {
				if (loc6 > -45) {
					loc6 = -45;
				}
				if (loc6 < -135) {
					loc6 = -135;
				}
			}
			this.arrow_.rotation = loc6;
			if (this.tooltip_ != null) {
				this.positionTooltip(this.tooltip_);
			}
			visible = true;
		}

		private function positionTooltip(param1:ToolTip):void {
			var loc5:Number = NaN;
			var loc8:Number = NaN;
			var loc9:Number = NaN;
			var loc2:Number = this.arrow_.rotation;
			var loc3:int = DIST + BIG_SIZE + 12;
			var loc4:Number = loc3 * Math.cos(loc2 * Trig.toRadians);
			loc5 = loc3 * Math.sin(loc2 * Trig.toRadians);
			var loc6:Number = param1.contentWidth_;
			var loc7:Number = param1.contentHeight_;
			if (loc2 >= 45 && loc2 <= 135) {
				loc8 = loc4 + loc6 / Math.tan(loc2 * Trig.toRadians);
				param1.x = (loc4 + loc8) / 2 - loc6 / 2;
				param1.y = loc5;
			} else if (loc2 <= -45 && loc2 >= -135) {
				loc8 = loc4 - loc6 / Math.tan(loc2 * Trig.toRadians);
				param1.x = (loc4 + loc8) / 2 - loc6 / 2;
				param1.y = loc5 - loc7;
			} else if (loc2 < 45 && loc2 > -45) {
				param1.x = loc4;
				loc9 = loc5 + loc7 * Math.tan(loc2 * Trig.toRadians);
				param1.y = (loc5 + loc9) / 2 - loc7 / 2;
			} else {
				param1.x = loc4 - loc6;
				loc9 = loc5 - loc7 * Math.tan(loc2 * Trig.toRadians);
				param1.y = (loc5 + loc9) / 2 - loc7 / 2;
			}
		}

		private function drawArrow():void {
			var loc1:Graphics = this.arrow_.graphics;
			loc1.clear();
			var loc2:int = this.big_ || this.mouseOver_ ? int(BIG_SIZE) : int(SMALL_SIZE);
			loc1.lineStyle(1, this.lineColor_);
			loc1.beginFill(this.fillColor_);
			loc1.moveTo(DIST, 0);
			loc1.lineTo(loc2 + DIST, loc2);
			loc1.lineTo(loc2 + DIST, -loc2);
			loc1.lineTo(DIST, 0);
			loc1.endFill();
			loc1.lineStyle();
		}
	}
}
