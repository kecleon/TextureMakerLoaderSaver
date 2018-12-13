 
package com.company.assembleegameclient.objects.particles {
	import com.company.assembleegameclient.map.Camera;
	import com.company.assembleegameclient.map.Square;
	import com.company.assembleegameclient.objects.BasicObject;
	import com.company.assembleegameclient.util.TextureRedrawer;
	import com.company.util.GraphicsUtil;
	import flash.display.BitmapData;
	import flash.display.GraphicsBitmapFill;
	import flash.display.GraphicsPath;
	import flash.display.IGraphicsData;
	import flash.geom.Matrix;
	
	public class Particle extends BasicObject {
		 
		
		public var size_:int;
		
		public var color_:uint;
		
		protected var bitmapFill_:GraphicsBitmapFill;
		
		protected var path_:GraphicsPath;
		
		protected var vS_:Vector.<Number>;
		
		protected var fillMatrix_:Matrix;
		
		public function Particle(param1:uint, param2:Number, param3:int) {
			this.bitmapFill_ = new GraphicsBitmapFill(null,null,false,false);
			this.path_ = new GraphicsPath(GraphicsUtil.QUAD_COMMANDS,null);
			this.vS_ = new Vector.<Number>();
			this.fillMatrix_ = new Matrix();
			super();
			objectId_ = getNextFakeObjectId();
			this.setZ(param2);
			this.setColor(param1);
			this.setSize(param3);
		}
		
		public function moveTo(param1:Number, param2:Number) : Boolean {
			var loc3:Square = null;
			loc3 = map_.getSquare(param1,param2);
			if(loc3 == null) {
				return false;
			}
			x_ = param1;
			y_ = param2;
			square_ = loc3;
			return true;
		}
		
		public function moveToInModal(param1:Number, param2:Number) : Boolean {
			x_ = param1;
			y_ = param2;
			return true;
		}
		
		public function setColor(param1:uint) : void {
			this.color_ = param1;
		}
		
		public function setZ(param1:Number) : void {
			z_ = param1;
		}
		
		public function setSize(param1:int) : void {
			this.size_ = param1 / 100 * 5;
		}
		
		override public function draw(param1:Vector.<IGraphicsData>, param2:Camera, param3:int) : void {
			var loc4:BitmapData = TextureRedrawer.redrawSolidSquare(this.color_,this.size_);
			var loc5:int = loc4.width;
			var loc6:int = loc4.height;
			this.vS_.length = 0;
			this.vS_.push(posS_[3] - loc5 / 2,posS_[4] - loc6 / 2,posS_[3] + loc5 / 2,posS_[4] - loc6 / 2,posS_[3] + loc5 / 2,posS_[4] + loc6 / 2,posS_[3] - loc5 / 2,posS_[4] + loc6 / 2);
			this.path_.data = this.vS_;
			this.bitmapFill_.bitmapData = loc4;
			this.fillMatrix_.identity();
			this.fillMatrix_.translate(this.vS_[0],this.vS_[1]);
			this.bitmapFill_.matrix = this.fillMatrix_;
			param1.push(this.bitmapFill_);
			param1.push(this.path_);
			param1.push(GraphicsUtil.END_FILL);
		}
	}
}
