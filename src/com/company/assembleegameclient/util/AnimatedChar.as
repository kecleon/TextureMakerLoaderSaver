 
package com.company.assembleegameclient.util {
	import com.company.assembleegameclient.map.Camera;
	import com.company.util.Trig;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	public class AnimatedChar {
		
		public static const RIGHT:int = 0;
		
		public static const LEFT:int = 1;
		
		public static const DOWN:int = 2;
		
		public static const UP:int = 3;
		
		public static const NUM_DIR:int = 4;
		
		public static const STAND:int = 0;
		
		public static const WALK:int = 1;
		
		public static const ATTACK:int = 2;
		
		public static const NUM_ACTION:int = 3;
		
		private static const SEC_TO_DIRS:Vector.<Vector.<int>> = new <Vector.<int>>[new <int>[LEFT,UP,DOWN],new <int>[UP,LEFT,DOWN],new <int>[UP,RIGHT,DOWN],new <int>[RIGHT,UP,DOWN],new <int>[RIGHT,DOWN],new <int>[DOWN,RIGHT],new <int>[DOWN,LEFT],new <int>[LEFT,DOWN]];
		
		private static const PIOVER4:Number = Math.PI / 4;
		 
		
		public var origImage_:MaskedImage;
		
		private var width_:int;
		
		private var height_:int;
		
		private var firstDir_:int;
		
		private var dict_:Dictionary;
		
		public function AnimatedChar(param1:MaskedImage, param2:int, param3:int, param4:int) {
			this.dict_ = new Dictionary();
			super();
			this.origImage_ = param1;
			this.width_ = param2;
			this.height_ = param3;
			this.firstDir_ = param4;
			var loc5:Dictionary = new Dictionary();
			var loc6:MaskedImageSet = new MaskedImageSet();
			loc6.addFromMaskedImage(param1,param2,param3);
			if(param4 == RIGHT) {
				this.dict_[RIGHT] = this.loadDir(0,false,false,loc6);
				this.dict_[LEFT] = this.loadDir(0,true,false,loc6);
				if(loc6.images_.length >= 14) {
					this.dict_[DOWN] = this.loadDir(7,false,true,loc6);
					if(loc6.images_.length >= 21) {
						this.dict_[UP] = this.loadDir(14,false,true,loc6);
					}
				}
			} else if(param4 == DOWN) {
				this.dict_[DOWN] = this.loadDir(0,false,true,loc6);
				if(loc6.images_.length >= 14) {
					this.dict_[RIGHT] = this.loadDir(7,false,false,loc6);
					this.dict_[LEFT] = this.loadDir(7,true,false,loc6);
					if(loc6.images_.length >= 21) {
						this.dict_[UP] = this.loadDir(14,false,true,loc6);
					}
				}
			}
		}
		
		public function getFirstDirImage() : BitmapData {
			var loc1:BitmapData = new BitmapDataSpy(this.width_ * 7,this.height_,true,0);
			var loc2:Dictionary = this.dict_[this.firstDir_];
			var loc3:Vector.<MaskedImage> = loc2[STAND];
			if(loc3.length > 0) {
				loc1.copyPixels(loc3[0].image_,loc3[0].image_.rect,new Point(0,0));
			}
			loc3 = loc2[WALK];
			if(loc3.length > 0) {
				loc1.copyPixels(loc3[0].image_,loc3[0].image_.rect,new Point(this.width_,0));
			}
			if(loc3.length > 1) {
				loc1.copyPixels(loc3[1].image_,loc3[1].image_.rect,new Point(this.width_ * 2,0));
			}
			loc3 = loc2[ATTACK];
			if(loc3.length > 0) {
				loc1.copyPixels(loc3[0].image_,loc3[0].image_.rect,new Point(this.width_ * 4,0));
			}
			if(loc3.length > 1) {
				loc1.copyPixels(loc3[1].image_,new Rectangle(this.width_,0,this.width_ * 2,this.height_),new Point(this.width_ * 5,0));
			}
			return loc1;
		}
		
		public function imageVec(param1:int, param2:int) : Vector.<MaskedImage> {
			return this.dict_[param1][param2];
		}
		
		public function imageFromDir(param1:int, param2:int, param3:Number) : MaskedImage {
			var loc4:Vector.<MaskedImage> = this.dict_[param1][param2];
			param3 = Math.max(0,Math.min(0.99999,param3));
			var loc5:int = param3 * loc4.length;
			return loc4[loc5];
		}
		
		public function imageFromAngle(param1:Number, param2:int, param3:Number) : MaskedImage {
			var loc4:int = int(param1 / PIOVER4 + 4) % 8;
			var loc5:Vector.<int> = SEC_TO_DIRS[loc4];
			var loc6:Dictionary = this.dict_[loc5[0]];
			if(loc6 == null) {
				loc6 = this.dict_[loc5[1]];
				if(loc6 == null) {
					loc6 = this.dict_[loc5[2]];
				}
			}
			var loc7:Vector.<MaskedImage> = loc6[param2];
			param3 = Math.max(0,Math.min(0.99999,param3));
			var loc8:int = param3 * loc7.length;
			return loc7[loc8];
		}
		
		public function imageFromFacing(param1:Number, param2:Camera, param3:int, param4:Number) : MaskedImage {
			var loc5:Number = Trig.boundToPI(param1 - param2.angleRad_);
			var loc6:int = int(loc5 / PIOVER4 + 4) % 8;
			var loc7:Vector.<int> = SEC_TO_DIRS[loc6];
			var loc8:Dictionary = this.dict_[loc7[0]];
			if(loc8 == null) {
				loc8 = this.dict_[loc7[1]];
				if(loc8 == null) {
					loc8 = this.dict_[loc7[2]];
				}
			}
			var loc9:Vector.<MaskedImage> = loc8[param3];
			param4 = Math.max(0,Math.min(0.99999,param4));
			var loc10:int = param4 * loc9.length;
			return loc9[loc10];
		}
		
		private function loadDir(param1:int, param2:Boolean, param3:Boolean, param4:MaskedImageSet) : Dictionary {
			var loc14:Vector.<MaskedImage> = null;
			var loc15:BitmapData = null;
			var loc16:BitmapData = null;
			var loc5:Dictionary = new Dictionary();
			var loc6:MaskedImage = param4.images_[param1 + 0];
			var loc7:MaskedImage = param4.images_[param1 + 1];
			var loc8:MaskedImage = param4.images_[param1 + 2];
			if(loc8.amountTransparent() == 1) {
				loc8 = null;
			}
			var loc9:MaskedImage = param4.images_[param1 + 4];
			var loc10:MaskedImage = param4.images_[param1 + 5];
			if(loc9.amountTransparent() == 1) {
				loc9 = null;
			}
			if(loc10.amountTransparent() == 1) {
				loc10 = null;
			}
			var loc11:MaskedImage = param4.images_[param1 + 6];
			if(loc10 != null && loc11.amountTransparent() != 1) {
				loc15 = new BitmapDataSpy(this.width_ * 3,this.height_,true,0);
				loc15.copyPixels(loc10.image_,new Rectangle(0,0,this.width_,this.height_),new Point(this.width_,0));
				loc15.copyPixels(loc11.image_,new Rectangle(0,0,this.width_,this.height_),new Point(this.width_ * 2,0));
				loc16 = null;
				if(loc10.mask_ != null || loc11.mask_ != null) {
					loc16 = new BitmapDataSpy(this.width_ * 3,this.height_,true,0);
				}
				if(loc10.mask_ != null) {
					loc16.copyPixels(loc10.mask_,new Rectangle(0,0,this.width_,this.height_),new Point(this.width_,0));
				}
				if(loc11.mask_ != null) {
					loc16.copyPixels(loc11.mask_,new Rectangle(0,0,this.width_,this.height_),new Point(this.width_ * 2,0));
				}
				loc10 = new MaskedImage(loc15,loc16);
			}
			var loc12:Vector.<MaskedImage> = new Vector.<MaskedImage>();
			loc12.push(!!param2?loc6.mirror():loc6);
			loc5[STAND] = loc12;
			var loc13:Vector.<MaskedImage> = new Vector.<MaskedImage>();
			loc13.push(!!param2?loc7.mirror():loc7);
			if(loc8 != null) {
				loc13.push(!!param2?loc8.mirror():loc8);
			} else if(param3) {
				loc13.push(!param2?loc7.mirror(7):loc7);
			} else {
				loc13.push(!!param2?loc6.mirror():loc6);
			}
			loc5[WALK] = loc13;
			if(loc9 == null && loc10 == null) {
				loc14 = loc13;
			} else {
				loc14 = new Vector.<MaskedImage>();
				if(loc9 != null) {
					loc14.push(!!param2?loc9.mirror():loc9);
				}
				if(loc10 != null) {
					loc14.push(!!param2?loc10.mirror():loc10);
				}
			}
			loc5[ATTACK] = loc14;
			return loc5;
		}
		
		public function getHeight() : int {
			return this.height_;
		}
	}
}
