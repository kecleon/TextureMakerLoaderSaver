 
package com.company.assembleegameclient.map {
	import com.company.assembleegameclient.engine3d.TextureMatrix;
	import com.company.assembleegameclient.objects.GameObject;
	import com.company.assembleegameclient.util.TileRedrawer;
	import flash.display.BitmapData;
	import flash.display.IGraphicsData;
	import flash.geom.Vector3D;
	
	public class Square{
		
		public static const UVT:Vector.<Number> = new <Number>[0,0,0,1,0,0,1,1,0,0,1,0];
		
		private static const LOOKUP:Vector.<int> = new <int>[26171,44789,20333,70429,98257,59393,33961];
		 
		
		public var map_:Map;
		
		public var x_:int;
		
		public var y_:int;
		
		public var tileType_:uint = 255;
		
		public var center_:Vector3D;
		
		public var vin_:Vector.<Number>;
		
		public var obj_:GameObject = null;
		
		public var props_:GroundProperties;
		
		public var texture_:BitmapData = null;
		
		public var sink_:int = 0;
		
		public var lastDamage_:int = 0;
		
		public var faces_:Vector.<SquareFace>;
		
		public var topFace_:SquareFace = null;
		
		public var baseTexMatrix_:TextureMatrix = null;
		
		public var lastVisible_:int;
		
		public function Square(param1:Map, param2:int, param3:int) {
			this.props_ = GroundLibrary.defaultProps_;
			this.faces_ = new Vector.<SquareFace>();
			super();
			this.map_ = param1;
			this.x_ = param2;
			this.y_ = param3;
			this.center_ = new Vector3D(this.x_ + 0.5,this.y_ + 0.5,0);
			this.vin_ = new <Number>[this.x_,this.y_,0,this.x_ + 1,this.y_,0,this.x_ + 1,this.y_ + 1,0,this.x_,this.y_ + 1,0];
		}
		
		private static function hash(param1:int, param2:int) : int {
			var loc3:int = LOOKUP[(param1 + param2) % 7];
			var loc4:* = (param1 << 16 | param2) ^ 81397550;
			loc4 = int(loc4 * loc3 % 65535);
			return loc4;
		}
		
		public function dispose() : void {
			var loc1:SquareFace = null;
			this.map_ = null;
			this.center_ = null;
			this.vin_ = null;
			this.obj_ = null;
			this.texture_ = null;
			for each(loc1 in this.faces_) {
				loc1.dispose();
			}
			this.faces_.length = 0;
			if(this.topFace_ != null) {
				this.topFace_.dispose();
				this.topFace_ = null;
			}
			this.faces_ = null;
			this.baseTexMatrix_ = null;
		}
		
		public function setTileType(param1:uint) : void {
			this.tileType_ = param1;
			this.props_ = GroundLibrary.propsLibrary_[this.tileType_];
			this.texture_ = GroundLibrary.getBitmapData(this.tileType_,hash(this.x_,this.y_));
			this.baseTexMatrix_ = new TextureMatrix(this.texture_,UVT);
			this.faces_.length = 0;
		}
		
		public function isWalkable() : Boolean {
			return !this.props_.noWalk_ && (this.obj_ == null || !this.obj_.props_.occupySquare_);
		}
		
		public function draw(param1:Vector.<IGraphicsData>, param2:Camera, param3:int) : void {
			var loc4:SquareFace = null;
			if(this.texture_ == null) {
				return;
			}
			if(this.faces_.length == 0) {
				this.rebuild3D();
			}
			for each(loc4 in this.faces_) {
				if(!loc4.draw(param1,param2,param3)) {
					if(loc4.face_.vout_[1] < param2.clipRect_.bottom) {
						this.lastVisible_ = 0;
					}
					return;
				}
			}
		}
		
		public function drawTop(param1:Vector.<IGraphicsData>, param2:Camera, param3:int) : void {
			this.topFace_.draw(param1,param2,param3);
		}
		
		private function rebuild3D() : void {
			var loc2:Number = NaN;
			var loc3:Number = NaN;
			var loc4:BitmapData = null;
			var loc5:Vector.<Number> = null;
			var loc6:uint = 0;
			this.faces_.length = 0;
			this.topFace_ = null;
			var loc1:BitmapData = null;
			if(this.props_.animate_.type_ != AnimateProperties.NO_ANIMATE) {
				this.faces_.push(new SquareFace(this.texture_,this.vin_,this.props_.xOffset_,this.props_.yOffset_,this.props_.animate_.type_,this.props_.animate_.dx_,this.props_.animate_.dy_));
				loc1 = TileRedrawer.redraw(this,false);
				if(loc1 != null) {
					this.faces_.push(new SquareFace(loc1,this.vin_,0,0,AnimateProperties.NO_ANIMATE,0,0));
				}
			} else {
				loc1 = TileRedrawer.redraw(this,true);
				loc2 = 0;
				loc3 = 0;
				if(loc1 == null) {
					if(this.props_.randomOffset_) {
						loc2 = int(this.texture_.width * Math.random()) / this.texture_.width;
						loc3 = int(this.texture_.height * Math.random()) / this.texture_.height;
					} else {
						loc2 = this.props_.xOffset_;
						loc3 = this.props_.yOffset_;
					}
				}
				this.faces_.push(new SquareFace(loc1 != null?loc1:this.texture_,this.vin_,loc2,loc3,AnimateProperties.NO_ANIMATE,0,0));
			}
			if(this.props_.sink_) {
				this.sink_ = loc1 == null?12:6;
			} else {
				this.sink_ = 0;
			}
			if(this.props_.topTD_) {
				loc4 = this.props_.topTD_.getTexture();
				loc5 = this.vin_.concat();
				loc6 = 2;
				while(loc6 < loc5.length) {
					loc5[loc6] = 1;
					loc6 = loc6 + 3;
				}
				this.topFace_ = new SquareFace(loc4,loc5,0,0,this.props_.topAnimate_.type_,this.props_.topAnimate_.dx_,this.props_.topAnimate_.dy_);
			}
		}
	}
}
