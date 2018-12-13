package com.company.assembleegameclient.objects {
	import com.company.assembleegameclient.engine3d.Object3D;
	import com.company.assembleegameclient.engine3d.ObjectFace3D;
	import com.company.assembleegameclient.map.Camera;
	import com.company.assembleegameclient.map.Square;

	import flash.display.BitmapData;
	import flash.display.IGraphicsData;
	import flash.geom.Utils3D;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;

	public class ConnectedObject extends GameObject {

		protected static const DOT_TYPE:int = 0;

		protected static const SHORT_LINE_TYPE:int = 1;

		protected static const L_TYPE:int = 2;

		protected static const LINE_TYPE:int = 3;

		protected static const T_TYPE:int = 4;

		protected static const CROSS_TYPE:int = 5;

		private static var dict_:Dictionary = null;

		protected static const N0:Vector3D = new Vector3D(-1, -1, 0);

		protected static const N1:Vector3D = new Vector3D(0, -1, 0);

		protected static const N2:Vector3D = new Vector3D(1, -1, 0);

		protected static const N3:Vector3D = new Vector3D(1, 0, 0);

		protected static const N4:Vector3D = new Vector3D(1, 1, 0);

		protected static const N5:Vector3D = new Vector3D(0, 1, 0);

		protected static const N6:Vector3D = new Vector3D(-1, 1, 0);

		protected static const N7:Vector3D = new Vector3D(-1, 0, 0);

		protected static const N8:Vector3D = new Vector3D(0, 0, 1);


		protected var rotation_:int = 0;

		public function ConnectedObject(param1:XML) {
			super(param1);
			hasShadow_ = false;
		}

		private static function init():void {
			dict_ = new Dictionary();
			initHelper(33686018, DOT_TYPE);
			initHelper(16908802, SHORT_LINE_TYPE);
			initHelper(16843266, L_TYPE);
			initHelper(16908546, LINE_TYPE);
			initHelper(16843265, T_TYPE);
			initHelper(16843009, CROSS_TYPE);
		}

		private static function getConnectedResults(param1:int):ConnectedResults {
			if (dict_ == null) {
				init();
			}
			var loc2:* = param1 & 252645135;
			return dict_[loc2];
		}

		private static function initHelper(param1:int, param2:int):void {
			var loc4:* = 0;
			var loc3:int = 0;
			while (loc3 < 4) {
				if (!dict_.hasOwnProperty(String(param1))) {
					dict_[param1] = new ConnectedResults(param2, loc3);
					loc4 = param1 & 255;
					param1 = param1 >> 8 | loc4 << 24;
				}
				loc3++;
			}
		}

		override public function draw(param1:Vector.<IGraphicsData>, param2:Camera, param3:int):void {
			var loc4:ObjectFace3D = null;
			var loc5:int = 0;
			var loc6:int = 0;
			var loc7:BitmapData = null;
			var loc8:Square = null;
			if (obj3D_ == null) {
				this.rebuild3D();
			}
			Utils3D.projectVectors(param2.wToS_, obj3D_.vW_, obj3D_.vS_, obj3D_.uvts_);
			for each(loc4 in obj3D_.faces_) {
				loc5 = loc4.normalW_.x > 0.4 ? 1 : loc4.normalW_.x < -0.4 ? -1 : 0;
				loc6 = loc4.normalW_.y > 0.4 ? 1 : loc4.normalW_.y < -0.4 ? -1 : 0;
				loc7 = loc4.texture_;
				if (loc5 != 0 || loc6 != 0) {
					loc8 = map_.lookupSquare(x_ + loc5, y_ + loc6);
					if (loc8 == null || loc8.texture_ == null) {
						loc7 = null;
					}
				}
				loc4.draw(param1, 0, loc7);
			}
		}

		public function rebuild3D():void {
			obj3D_ = new Object3D();
			var loc1:ConnectedResults = getConnectedResults(connectType_);
			if (loc1 == null) {
				obj3D_ = null;
				return;
			}
			this.rotation_ = loc1.rotation_;
			switch (loc1.type_) {
				case DOT_TYPE:
					this.buildDot();
					break;
				case SHORT_LINE_TYPE:
					this.buildShortLine();
					break;
				case L_TYPE:
					this.buildL();
					break;
				case LINE_TYPE:
					this.buildLine();
					break;
				case T_TYPE:
					this.buildT();
					break;
				case CROSS_TYPE:
					this.buildCross();
					break;
				default:
					obj3D_ = null;
					return;
			}
			obj3D_.setPosition(x_, y_, 0, this.rotation_ * 90);
		}

		protected function buildDot():void {
		}

		protected function buildShortLine():void {
		}

		protected function buildL():void {
		}

		protected function buildLine():void {
		}

		protected function buildT():void {
		}

		protected function buildCross():void {
		}
	}
}

class ConnectedResults {


	public var type_:int;

	public var rotation_:int;

	function ConnectedResults(param1:int, param2:int) {
		super();
		this.type_ = param1;
		this.rotation_ = param2;
	}
}
