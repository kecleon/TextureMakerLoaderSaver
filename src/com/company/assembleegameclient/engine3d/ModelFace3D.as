package com.company.assembleegameclient.engine3d {
	public class ModelFace3D {


		public var model_:Model3D;

		public var indicies_:Vector.<int>;

		public var useTexture_:Boolean;

		public function ModelFace3D(param1:Model3D, param2:Vector.<int>, param3:Boolean) {
			super();
			this.model_ = param1;
			this.indicies_ = param2;
			this.useTexture_ = param3;
		}

		public static function compare(param1:ModelFace3D, param2:ModelFace3D):Number {
			var loc3:Number = NaN;
			var loc4:int = 0;
			var loc5:Number = Number.MAX_VALUE;
			var loc6:Number = Number.MIN_VALUE;
			loc4 = 0;
			while (loc4 < param1.indicies_.length) {
				loc3 = param2.model_.vL_[param1.indicies_[loc4] * 3 + 2];
				loc5 = loc3 < loc5 ? Number(loc3) : Number(loc5);
				loc6 = loc3 > loc6 ? Number(loc3) : Number(loc6);
				loc4++;
			}
			var loc7:Number = Number.MAX_VALUE;
			var loc8:Number = Number.MIN_VALUE;
			loc4 = 0;
			while (loc4 < param2.indicies_.length) {
				loc3 = param2.model_.vL_[param2.indicies_[loc4] * 3 + 2];
				loc7 = loc3 < loc7 ? Number(loc3) : Number(loc7);
				loc8 = loc3 > loc8 ? Number(loc3) : Number(loc8);
				loc4++;
			}
			if (loc7 > loc5) {
				return -1;
			}
			if (loc7 < loc5) {
				return 1;
			}
			if (loc8 > loc6) {
				return -1;
			}
			if (loc8 < loc6) {
				return 1;
			}
			return 0;
		}
	}
}
