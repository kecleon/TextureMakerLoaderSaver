 
package com.company.assembleegameclient.util {
	import com.company.assembleegameclient.map.GroundLibrary;
	import com.company.assembleegameclient.map.GroundProperties;
	import com.company.assembleegameclient.map.Map;
	import com.company.assembleegameclient.map.Square;
	import com.company.assembleegameclient.parameters.Parameters;
	import com.company.util.AssetLibrary;
	import com.company.util.BitmapUtil;
	import com.company.util.ImageSet;
	import com.company.util.PointUtil;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class TileRedrawer {
		
		private static const rect0:Rectangle = new Rectangle(0,0,4,4);
		
		private static const p0:Point = new Point(0,0);
		
		private static const rect1:Rectangle = new Rectangle(4,0,4,4);
		
		private static const p1:Point = new Point(4,0);
		
		private static const rect2:Rectangle = new Rectangle(0,4,4,4);
		
		private static const p2:Point = new Point(0,4);
		
		private static const rect3:Rectangle = new Rectangle(4,4,4,4);
		
		private static const p3:Point = new Point(4,4);
		
		private static const INNER:int = 0;
		
		private static const SIDE0:int = 1;
		
		private static const SIDE1:int = 2;
		
		private static const OUTER:int = 3;
		
		private static const INNERP1:int = 4;
		
		private static const INNERP2:int = 5;
		
		private static const mlist_:Vector.<Vector.<ImageSet>> = getMasks();
		
		private static var cache_:Vector.<Object> = new <Object>[null,new Object()];
		
		private static const RECT01:Rectangle = new Rectangle(0,0,8,4);
		
		private static const RECT13:Rectangle = new Rectangle(4,0,4,8);
		
		private static const RECT23:Rectangle = new Rectangle(0,4,8,4);
		
		private static const RECT02:Rectangle = new Rectangle(0,0,4,8);
		
		private static const RECT0:Rectangle = new Rectangle(0,0,4,4);
		
		private static const RECT1:Rectangle = new Rectangle(4,0,4,4);
		
		private static const RECT2:Rectangle = new Rectangle(0,4,4,4);
		
		private static const RECT3:Rectangle = new Rectangle(4,4,4,4);
		
		private static const POINT0:Point = new Point(0,0);
		
		private static const POINT1:Point = new Point(4,0);
		
		private static const POINT2:Point = new Point(0,4);
		
		private static const POINT3:Point = new Point(4,4);
		 
		
		public function TileRedrawer() {
			super();
		}
		
		public static function redraw(param1:Square, param2:Boolean) : BitmapData {
			var loc3:Array = null;
			var loc5:BitmapData = null;
			if(Parameters.blendType_ == 0) {
				return null;
			}
			if(param1.tileType_ == 253) {
				loc3 = getCompositeSig(param1);
			} else if(param1.props_.hasEdge_) {
				loc3 = getEdgeSig(param1);
			} else {
				loc3 = getSig(param1);
			}
			if(loc3 == null) {
				return null;
			}
			var loc4:Object = cache_[Parameters.blendType_];
			if(loc4.hasOwnProperty(loc3)) {
				return loc4[loc3];
			}
			if(param1.tileType_ == 253) {
				loc5 = buildComposite(loc3);
				loc4[loc3] = loc5;
				return loc5;
			}
			if(param1.props_.hasEdge_) {
				loc5 = drawEdges(loc3);
				loc4[loc3] = loc5;
				return loc5;
			}
			var loc6:Boolean = false;
			var loc7:Boolean = false;
			var loc8:Boolean = false;
			var loc9:Boolean = false;
			if(loc3[1] != loc3[4]) {
				loc6 = true;
				loc7 = true;
			}
			if(loc3[3] != loc3[4]) {
				loc6 = true;
				loc8 = true;
			}
			if(loc3[5] != loc3[4]) {
				loc7 = true;
				loc9 = true;
			}
			if(loc3[7] != loc3[4]) {
				loc8 = true;
				loc9 = true;
			}
			if(!loc6 && loc3[0] != loc3[4]) {
				loc6 = true;
			}
			if(!loc7 && loc3[2] != loc3[4]) {
				loc7 = true;
			}
			if(!loc8 && loc3[6] != loc3[4]) {
				loc8 = true;
			}
			if(!loc9 && loc3[8] != loc3[4]) {
				loc9 = true;
			}
			if(!loc6 && !loc7 && !loc8 && !loc9) {
				loc4[loc3] = null;
				return null;
			}
			var loc10:BitmapData = GroundLibrary.getBitmapData(param1.tileType_);
			if(param2) {
				loc5 = loc10.clone();
			} else {
				loc5 = new BitmapDataSpy(loc10.width,loc10.height,true,0);
			}
			if(loc6) {
				redrawRect(loc5,rect0,p0,mlist_[0],loc3[4],loc3[3],loc3[0],loc3[1]);
			}
			if(loc7) {
				redrawRect(loc5,rect1,p1,mlist_[1],loc3[4],loc3[1],loc3[2],loc3[5]);
			}
			if(loc8) {
				redrawRect(loc5,rect2,p2,mlist_[2],loc3[4],loc3[7],loc3[6],loc3[3]);
			}
			if(loc9) {
				redrawRect(loc5,rect3,p3,mlist_[3],loc3[4],loc3[5],loc3[8],loc3[7]);
			}
			loc4[loc3] = loc5;
			return loc5;
		}
		
		private static function redrawRect(param1:BitmapData, param2:Rectangle, param3:Point, param4:Vector.<ImageSet>, param5:uint, param6:uint, param7:uint, param8:uint) : void {
			var loc9:BitmapData = null;
			var loc10:BitmapData = null;
			if(param5 == param6 && param5 == param8) {
				loc10 = param4[OUTER].random();
				loc9 = GroundLibrary.getBitmapData(param7);
			} else if(param5 != param6 && param5 != param8) {
				if(param6 != param8) {
					param1.copyPixels(GroundLibrary.getBitmapData(param6),param2,param3,param4[INNERP1].random(),p0,true);
					param1.copyPixels(GroundLibrary.getBitmapData(param8),param2,param3,param4[INNERP2].random(),p0,true);
					return;
				}
				loc10 = param4[INNER].random();
				loc9 = GroundLibrary.getBitmapData(param6);
			} else if(param5 != param6) {
				loc10 = param4[SIDE0].random();
				loc9 = GroundLibrary.getBitmapData(param6);
			} else {
				loc10 = param4[SIDE1].random();
				loc9 = GroundLibrary.getBitmapData(param8);
			}
			param1.copyPixels(loc9,param2,param3,loc10,p0,true);
		}
		
		private static function getSig(param1:Square) : Array {
			var loc6:int = 0;
			var loc7:Square = null;
			var loc2:Array = new Array();
			var loc3:Map = param1.map_;
			var loc4:uint = param1.tileType_;
			var loc5:int = param1.y_ - 1;
			while(loc5 <= param1.y_ + 1) {
				loc6 = param1.x_ - 1;
				while(loc6 <= param1.x_ + 1) {
					if(loc6 < 0 || loc6 >= loc3.width_ || loc5 < 0 || loc5 >= loc3.height_ || loc6 == param1.x_ && loc5 == param1.y_) {
						loc2.push(loc4);
					} else {
						loc7 = loc3.squares_[loc6 + loc5 * loc3.width_];
						if(loc7 == null || loc7.props_.blendPriority_ <= param1.props_.blendPriority_) {
							loc2.push(loc4);
						} else {
							loc2.push(loc7.tileType_);
						}
					}
					loc6++;
				}
				loc5++;
			}
			return loc2;
		}
		
		private static function getMasks() : Vector.<Vector.<ImageSet>> {
			var loc1:Vector.<Vector.<ImageSet>> = new Vector.<Vector.<ImageSet>>();
			addMasks(loc1,AssetLibrary.getImageSet("inner_mask"),AssetLibrary.getImageSet("sides_mask"),AssetLibrary.getImageSet("outer_mask"),AssetLibrary.getImageSet("innerP1_mask"),AssetLibrary.getImageSet("innerP2_mask"));
			return loc1;
		}
		
		private static function addMasks(param1:Vector.<Vector.<ImageSet>>, param2:ImageSet, param3:ImageSet, param4:ImageSet, param5:ImageSet, param6:ImageSet) : void {
			var loc7:int = 0;
			for each(loc7 in [-1,0,2,1]) {
				param1.push(new <ImageSet>[rotateImageSet(param2,loc7),rotateImageSet(param3,loc7 - 1),rotateImageSet(param3,loc7),rotateImageSet(param4,loc7),rotateImageSet(param5,loc7),rotateImageSet(param6,loc7)]);
			}
		}
		
		private static function rotateImageSet(param1:ImageSet, param2:int) : ImageSet {
			var loc4:BitmapData = null;
			var loc3:ImageSet = new ImageSet();
			for each(loc4 in param1.images_) {
				loc3.add(BitmapUtil.rotateBitmapData(loc4,param2));
			}
			return loc3;
		}
		
		private static function getCompositeSig(param1:Square) : Array {
			var loc14:Square = null;
			var loc15:Square = null;
			var loc16:Square = null;
			var loc17:Square = null;
			var loc2:Array = new Array();
			loc2.length = 4;
			var loc3:Map = param1.map_;
			var loc4:int = param1.x_;
			var loc5:int = param1.y_;
			var loc6:Square = loc3.lookupSquare(loc4,loc5 - 1);
			var loc7:Square = loc3.lookupSquare(loc4 - 1,loc5);
			var loc8:Square = loc3.lookupSquare(loc4 + 1,loc5);
			var loc9:Square = loc3.lookupSquare(loc4,loc5 + 1);
			var loc10:int = loc6 != null?int(loc6.props_.compositePriority_):-1;
			var loc11:int = loc7 != null?int(loc7.props_.compositePriority_):-1;
			var loc12:int = loc8 != null?int(loc8.props_.compositePriority_):-1;
			var loc13:int = loc9 != null?int(loc9.props_.compositePriority_):-1;
			if(loc10 < 0 && loc11 < 0) {
				loc14 = loc3.lookupSquare(loc4 - 1,loc5 - 1);
				loc2[0] = loc14 == null || loc14.props_.compositePriority_ < 0?255:loc14.tileType_;
			} else if(loc10 < loc11) {
				loc2[0] = loc7.tileType_;
			} else {
				loc2[0] = loc6.tileType_;
			}
			if(loc10 < 0 && loc12 < 0) {
				loc15 = loc3.lookupSquare(loc4 + 1,loc5 - 1);
				loc2[1] = loc15 == null || loc15.props_.compositePriority_ < 0?255:loc15.tileType_;
			} else if(loc10 < loc12) {
				loc2[1] = loc8.tileType_;
			} else {
				loc2[1] = loc6.tileType_;
			}
			if(loc11 < 0 && loc13 < 0) {
				loc16 = loc3.lookupSquare(loc4 - 1,loc5 + 1);
				loc2[2] = loc16 == null || loc16.props_.compositePriority_ < 0?255:loc16.tileType_;
			} else if(loc11 < loc13) {
				loc2[2] = loc9.tileType_;
			} else {
				loc2[2] = loc7.tileType_;
			}
			if(loc12 < 0 && loc13 < 0) {
				loc17 = loc3.lookupSquare(loc4 + 1,loc5 + 1);
				loc2[3] = loc17 == null || loc17.props_.compositePriority_ < 0?255:loc17.tileType_;
			} else if(loc12 < loc13) {
				loc2[3] = loc9.tileType_;
			} else {
				loc2[3] = loc8.tileType_;
			}
			return loc2;
		}
		
		private static function buildComposite(param1:Array) : BitmapData {
			var loc3:BitmapData = null;
			var loc2:BitmapData = new BitmapDataSpy(8,8,false,0);
			if(param1[0] != 255) {
				loc3 = GroundLibrary.getBitmapData(param1[0]);
				loc2.copyPixels(loc3,RECT0,POINT0);
			}
			if(param1[1] != 255) {
				loc3 = GroundLibrary.getBitmapData(param1[1]);
				loc2.copyPixels(loc3,RECT1,POINT1);
			}
			if(param1[2] != 255) {
				loc3 = GroundLibrary.getBitmapData(param1[2]);
				loc2.copyPixels(loc3,RECT2,POINT2);
			}
			if(param1[3] != 255) {
				loc3 = GroundLibrary.getBitmapData(param1[3]);
				loc2.copyPixels(loc3,RECT3,POINT3);
			}
			return loc2;
		}
		
		private static function getEdgeSig(param1:Square) : Array {
			var loc7:int = 0;
			var loc8:Square = null;
			var loc9:Boolean = false;
			var loc2:Array = new Array();
			var loc3:Map = param1.map_;
			var loc4:Boolean = false;
			var loc5:Boolean = param1.props_.sameTypeEdgeMode_;
			var loc6:int = param1.y_ - 1;
			while(loc6 <= param1.y_ + 1) {
				loc7 = param1.x_ - 1;
				while(loc7 <= param1.x_ + 1) {
					loc8 = loc3.lookupSquare(loc7,loc6);
					if(loc7 == param1.x_ && loc6 == param1.y_) {
						loc2.push(loc8.tileType_);
					} else {
						if(loc5) {
							loc9 = loc8 == null || loc8.tileType_ == param1.tileType_;
						} else {
							loc9 = loc8 == null || loc8.tileType_ != 255;
						}
						loc2.push(loc9);
						loc4 = loc4 || !loc9;
					}
					loc7++;
				}
				loc6++;
			}
			return !!loc4?loc2:null;
		}
		
		private static function drawEdges(param1:Array) : BitmapData {
			var loc2:BitmapData = GroundLibrary.getBitmapData(param1[4]);
			var loc3:BitmapData = loc2.clone();
			var loc4:GroundProperties = GroundLibrary.propsLibrary_[param1[4]];
			var loc5:Vector.<BitmapData> = loc4.getEdges();
			var loc6:Vector.<BitmapData> = loc4.getInnerCorners();
			var loc7:int = 1;
			while(loc7 < 8) {
				if(!param1[loc7]) {
					loc3.copyPixels(loc5[loc7],loc5[loc7].rect,PointUtil.ORIGIN,null,null,true);
				}
				loc7 = loc7 + 2;
			}
			if(loc5[0] != null) {
				if(param1[3] && param1[1] && !param1[0]) {
					loc3.copyPixels(loc5[0],loc5[0].rect,PointUtil.ORIGIN,null,null,true);
				}
				if(param1[1] && param1[5] && !param1[2]) {
					loc3.copyPixels(loc5[2],loc5[2].rect,PointUtil.ORIGIN,null,null,true);
				}
				if(param1[5] && param1[7] && !param1[8]) {
					loc3.copyPixels(loc5[8],loc5[8].rect,PointUtil.ORIGIN,null,null,true);
				}
				if(param1[3] && param1[7] && !param1[6]) {
					loc3.copyPixels(loc5[6],loc5[6].rect,PointUtil.ORIGIN,null,null,true);
				}
			}
			if(loc6 != null) {
				if(!param1[3] && !param1[1]) {
					loc3.copyPixels(loc6[0],loc6[0].rect,PointUtil.ORIGIN,null,null,true);
				}
				if(!param1[1] && !param1[5]) {
					loc3.copyPixels(loc6[2],loc6[2].rect,PointUtil.ORIGIN,null,null,true);
				}
				if(!param1[5] && !param1[7]) {
					loc3.copyPixels(loc6[8],loc6[8].rect,PointUtil.ORIGIN,null,null,true);
				}
				if(!param1[3] && !param1[7]) {
					loc3.copyPixels(loc6[6],loc6[6].rect,PointUtil.ORIGIN,null,null,true);
				}
			}
			return loc3;
		}
	}
}
