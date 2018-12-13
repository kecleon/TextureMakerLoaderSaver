package com.company.assembleegameclient.engine3d {
	import com.company.util.ConversionUtil;

	import flash.display3D.Context3D;
	import flash.utils.ByteArray;

	import kabam.rotmg.stage3D.Object3D.Model3D_stage3d;
	import kabam.rotmg.stage3D.Object3D.Object3DStage3D;

	public class Model3D {

		private static var modelLib_:Object = new Object();

		private static var models:Object = new Object();


		public var vL_:Vector.<Number>;

		public var uvts_:Vector.<Number>;

		public var faces_:Vector.<ModelFace3D>;

		public function Model3D() {
			this.vL_ = new Vector.<Number>();
			this.uvts_ = new Vector.<Number>();
			this.faces_ = new Vector.<ModelFace3D>();
			super();
		}

		public static function parse3DOBJ(param1:String, param2:ByteArray):void {
			var loc3:Model3D_stage3d = new Model3D_stage3d();
			loc3.readBytes(param2);
			models[param1] = loc3;
		}

		public static function Create3dBuffer(param1:Context3D):void {
			var loc2:Model3D_stage3d = null;
			for each(loc2 in models) {
				loc2.CreatBuffer(param1);
			}
		}

		public static function parseFromOBJ(param1:String, param2:String):void {
			var loc11:String = null;
			var loc12:Model3D = null;
			var loc13:String = null;
			var loc14:int = 0;
			var loc15:Array = null;
			var loc16:String = null;
			var loc17:String = null;
			var loc18:Array = null;
			var loc19:Array = null;
			var loc20:String = null;
			var loc21:Vector.<int> = null;
			var loc22:int = 0;
			var loc3:Array = param2.split(/\s*\n\s*/);
			var loc4:Array = [];
			var loc5:Array = [];
			var loc6:Array = [];
			var loc7:Object = {};
			var loc8:Array = [];
			var loc9:String = null;
			var loc10:Array = [];
			for each(loc11 in loc3) {
				if (loc11.charAt(0) == "#" || loc11.length == 0) {
					continue;
				}
				loc15 = loc11.split(/\s+/);
				if (loc15.length == 0) {
					continue;
				}
				loc16 = loc15.shift();
				if (loc16.length == 0) {
					continue;
				}
				switch (loc16) {
					case "v":
						if (loc15.length != 3) {
							return;
						}
						loc4.push(loc15);
						continue;
					case "vt":
						if (loc15.length != 2) {
							return;
						}
						loc5.push(loc15);
						continue;
					case "f":
						if (loc15.length < 3) {
							return;
						}
						loc8.push(loc15);
						loc10.push(loc9);
						for each(loc17 in loc15) {
							if (!loc7.hasOwnProperty(loc17)) {
								loc7[loc17] = loc6.length;
								loc6.push(loc17);
							}
						}
						continue;
					case "usemtl":
						if (loc15.length != 1) {
							return;
						}
						loc9 = loc15[0];
						continue;
					default:
						continue;
				}
			}
			loc12 = new Model3D();
			for each(loc13 in loc6) {
				loc18 = loc13.split("/");
				ConversionUtil.addToNumberVector(loc4[int(loc18[0]) - 1], loc12.vL_);
				if (loc18.length > 1 && loc18[1].length > 0) {
					ConversionUtil.addToNumberVector(loc5[int(loc18[1]) - 1], loc12.uvts_);
					loc12.uvts_.push(0);
				} else {
					loc12.uvts_.push(0, 0, 0);
				}
			}
			loc14 = 0;
			while (loc14 < loc8.length) {
				loc19 = loc8[loc14];
				loc20 = loc10[loc14];
				loc21 = new Vector.<int>();
				loc22 = 0;
				while (loc22 < loc19.length) {
					loc21.push(loc7[loc19[loc22]]);
					loc22++;
				}
				loc12.faces_.push(new ModelFace3D(loc12, loc21, loc20 == null || loc20.substr(0, 5) != "Solid"));
				loc14++;
			}
			loc12.orderFaces();
			modelLib_[param1] = loc12;
		}

		public static function getModel(param1:String):Model3D {
			return modelLib_[param1];
		}

		public static function getObject3D(param1:String):Object3D {
			var loc2:Model3D = modelLib_[param1];
			if (loc2 == null) {
				return null;
			}
			return new Object3D(loc2);
		}

		public static function getStage3dObject3D(param1:String):Object3DStage3D {
			var loc2:Model3D_stage3d = models[param1];
			if (loc2 == null) {
				return null;
			}
			return new Object3DStage3D(loc2);
		}

		public function toString():String {
			var loc1:String = "";
			loc1 = loc1 + ("vL(" + this.vL_.length + "): " + this.vL_.join() + "\n");
			loc1 = loc1 + ("uvts(" + this.uvts_.length + "): " + this.uvts_.join() + "\n");
			loc1 = loc1 + ("faces_(" + this.faces_.length + "): " + this.faces_.join() + "\n");
			return loc1;
		}

		public function orderFaces():void {
			this.faces_.sort(ModelFace3D.compare);
		}
	}
}
