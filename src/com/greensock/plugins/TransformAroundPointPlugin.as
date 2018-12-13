package com.greensock.plugins {
	import com.greensock.TweenLite;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;

	public class TransformAroundPointPlugin extends TweenPlugin {

		private static var _classInitted:Boolean;

		private static var _isFlex:Boolean;

		public static const API:Number = 2;


		protected var _yRound:Boolean;

		protected var _useAddElement:Boolean;

		protected var _local:Point;

		protected var _proxy:DisplayObject;

		protected var _target:DisplayObject;

		protected var _point:Point;

		protected var _xRound:Boolean;

		protected var _pointIsLocal:Boolean;

		protected var _proxySizeData:Object;

		protected var _shortRotation:ShortRotationPlugin;

		public function TransformAroundPointPlugin() {
			super("transformAroundPoint,transformAroundCenter,x,y", -1);
		}

		private static function _applyMatrix(p:Point, m:Matrix):Point {
			var dec:Number = NaN;
			var x:Number = p.x * m.a + p.y * m.c + m.tx;
			var y:Number = p.x * m.b + p.y * m.d + m.ty;
			x = Boolean(dec = Number(x - (x = Number(x | 0)))) ? Number((dec < 0.3 ? 0 : dec < 0.7 ? 0.5 : 1) + x) : Number(x);
			y = Boolean(dec = Number(y - (y = Number(y | 0)))) ? Number((dec < 0.3 ? 0 : dec < 0.7 ? 0.5 : 1) + y) : Number(y);
			return new Point(x, y);
		}

		override public function _kill(lookup:Object):Boolean {
			if (_shortRotation != null) {
				_shortRotation._kill(lookup);
				if (_shortRotation._overwriteProps.length == 0) {
					lookup.shortRotation = true;
				}
			}
			return super._kill(lookup);
		}

		override public function setRatio(v:Number):void {
			var p:Point = null;
			var m:Matrix = null;
			var x:Number = NaN;
			var y:Number = NaN;
			var val:Number = NaN;
			var r:Number = NaN;
			if (_proxy != null && _proxy.parent != null) {
				if (_useAddElement) {
					Object(_proxy.parent).addElement(_target.parent);
				} else {
					_proxy.parent.addChild(_target.parent);
				}
			}
			if (_pointIsLocal) {
				p = _applyMatrix(_local, _target.transform.matrix);
				if (Math.abs(p.x - _point.x) > 0.5 || Math.abs(p.y - _point.y) > 0.5) {
					_point = p;
				}
			}
			super.setRatio(v);
			m = _target.transform.matrix;
			x = _local.x * m.a + _local.y * m.c + m.tx;
			y = _local.x * m.b + _local.y * m.d + m.ty;
			_target.x = !_xRound ? Number(_target.x + _point.x - x) : (val = Number(_target.x + _point.x - x)) > 0 ? Number(val + 0.5 >> 0) : Number(val - 0.5 >> 0);
			_target.y = !_yRound ? Number(_target.y + _point.y - y) : (val = Number(_target.y + _point.y - y)) > 0 ? Number(val + 0.5 >> 0) : Number(val - 0.5 >> 0);
			if (_proxy != null) {
				r = _target.rotation;
				_proxy.rotation = _target.rotation = 0;
				if (_proxySizeData.width != null) {
					_proxy.width = _target.width = _proxySizeData.width;
				}
				if (_proxySizeData.height != null) {
					_proxy.height = _target.height = _proxySizeData.height;
				}
				_proxy.rotation = _target.rotation = r;
				m = _target.transform.matrix;
				x = _local.x * m.a + _local.y * m.c + m.tx;
				y = _local.x * m.b + _local.y * m.d + m.ty;
				_proxy.x = !_xRound ? Number(_target.x + _point.x - x) : (val = Number(_target.x + _point.x - x)) > 0 ? Number(val + 0.5 >> 0) : Number(val - 0.5 >> 0);
				_proxy.y = !_yRound ? Number(_target.y + _point.y - y) : (val = Number(_target.y + _point.y - y)) > 0 ? Number(val + 0.5 >> 0) : Number(val - 0.5 >> 0);
				if (_proxy.parent != null) {
					if (_useAddElement) {
						Object(_proxy.parent).removeElement(_target.parent);
					} else {
						_proxy.parent.removeChild(_target.parent);
					}
				}
			}
		}

		override public function _roundProps(lookup:Object, value:Boolean = true):void {
			if ("transformAroundPoint" in lookup) {
				_xRound = _yRound = value;
			} else if ("x" in lookup) {
				_xRound = value;
			} else if ("y" in lookup) {
				_yRound = value;
			}
		}

		override public function _onInitTween(target:Object, value:*, tween:TweenLite):Boolean {
			var matrixCopy:Matrix = null;
			var p:String = null;
			var short:ShortRotationPlugin = null;
			var sp:String = null;
			var point:Point = null;
			var b:Rectangle = null;
			var s:Sprite = null;
			var container:Sprite = null;
			var enumerables:Object = null;
			var endX:Number = NaN;
			var endY:Number = NaN;
			if (!(value.point is Point)) {
				return false;
			}
			_target = target as DisplayObject;
			var m:Matrix = _target.transform.matrix;
			if (value.pointIsLocal == true) {
				_pointIsLocal = true;
				_local = value.point.clone();
				_point = _applyMatrix(_local, m);
			} else {
				_point = value.point.clone();
				matrixCopy = m.clone();
				matrixCopy.invert();
				_local = _applyMatrix(_point, matrixCopy);
			}
			if (!_classInitted) {
				try {
					_isFlex = Boolean(getDefinitionByName("mx.managers.SystemManager"));
				}
				catch (e:Error) {
					_isFlex = false;
				}
				_classInitted = true;
			}
			if ((!isNaN(value.width) || !isNaN(value.height)) && _target.parent != null) {
				point = _target.parent.globalToLocal(_target.localToGlobal(new Point(100, 100)));
				_target.width = _target.width * 2;
				if (point.x == _target.parent.globalToLocal(_target.localToGlobal(new Point(100, 100))).x) {
					_proxy = _target;
					_target.rotation = 0;
					_proxySizeData = {};
					if (!isNaN(value.width)) {
						_addTween(_proxySizeData, "width", _target.width / 2, value.width, "width");
					}
					if (!isNaN(value.height)) {
						_addTween(_proxySizeData, "height", _target.height, value.height, "height");
					}
					b = _target.getBounds(_target);
					s = new Sprite();
					container = !!_isFlex ? new getDefinitionByName("mx.core.UIComponent")() : new Sprite();
					container.addChild(s);
					container.visible = false;
					_useAddElement = Boolean(_isFlex && _proxy.parent.hasOwnProperty("addElement"));
					if (_useAddElement) {
						Object(_proxy.parent).addElement(container);
					} else {
						_proxy.parent.addChild(container);
					}
					_target = s;
					s.graphics.beginFill(255, 0.4);
					s.graphics.drawRect(b.x, b.y, b.width, b.height);
					s.graphics.endFill();
					_proxy.width = _proxy.width / 2;
					s.transform.matrix = _target.transform.matrix = m;
				} else {
					_target.width = _target.width / 2;
					_target.transform.matrix = m;
				}
			}
			for (p in value) {
				if (!(p == "point" || p == "pointIsLocal")) {
					if (p == "shortRotation") {
						_shortRotation = new ShortRotationPlugin();
						_shortRotation._onInitTween(_target, value[p], tween);
						_addTween(_shortRotation, "setRatio", 0, 1, "shortRotation");
						for (sp in value[p]) {
							_overwriteProps[_overwriteProps.length] = sp;
						}
					} else if (p == "x" || p == "y") {
						_addTween(_point, p, _point[p], value[p], p);
					} else if (p == "scale") {
						_addTween(_target, "scaleX", _target.scaleX, value.scale, "scaleX");
						_addTween(_target, "scaleY", _target.scaleY, value.scale, "scaleY");
						_overwriteProps[_overwriteProps.length] = "scaleX";
						_overwriteProps[_overwriteProps.length] = "scaleY";
					} else if (!((p == "width" || p == "height") && _proxy != null)) {
						_addTween(_target, p, _target[p], value[p], p);
						_overwriteProps[_overwriteProps.length] = p;
					}
				}
			}
			if (tween != null) {
				enumerables = tween.vars;
				if ("x" in enumerables || "y" in enumerables) {
					if ("x" in enumerables) {
						endX = typeof enumerables.x == "number" ? Number(enumerables.x) : Number(_target.x + Number(enumerables.x.split("=").join("")));
					}
					if ("y" in enumerables) {
						endY = typeof enumerables.y == "number" ? Number(enumerables.y) : Number(_target.y + Number(enumerables.y.split("=").join("")));
					}
					tween._kill({
						"x": true,
						"y": true,
						"_tempKill": true
					}, _target);
					this.setRatio(1);
					if (!isNaN(endX)) {
						_addTween(_point, "x", _point.x, _point.x + (endX - _target.x), "x");
					}
					if (!isNaN(endY)) {
						_addTween(_point, "y", _point.y, _point.y + (endY - _target.y), "y");
					}
					this.setRatio(0);
				}
			}
			return true;
		}
	}
}
