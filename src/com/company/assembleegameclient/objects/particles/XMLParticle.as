package com.company.assembleegameclient.objects.particles {
	import com.company.assembleegameclient.map.Camera;
	import com.company.assembleegameclient.map.Square;
	import com.company.assembleegameclient.objects.BasicObject;
	import com.company.assembleegameclient.objects.animation.Animations;
	import com.company.assembleegameclient.util.TextureRedrawer;
	import com.company.util.GraphicsUtil;

	import flash.display.BitmapData;
	import flash.display.GraphicsBitmapFill;
	import flash.display.GraphicsPath;
	import flash.display.IGraphicsData;
	import flash.geom.Matrix;
	import flash.geom.Vector3D;

	public class XMLParticle extends BasicObject {


		public var texture_:BitmapData = null;

		public var animations_:Animations = null;

		public var size_:int;

		public var durationLeft_:Number;

		public var moveVec_:Vector3D;

		protected var bitmapFill_:GraphicsBitmapFill;

		protected var path_:GraphicsPath;

		protected var vS_:Vector.<Number>;

		protected var uvt_:Vector.<Number>;

		protected var fillMatrix_:Matrix;

		public function XMLParticle(param1:ParticleProperties) {
			this.bitmapFill_ = new GraphicsBitmapFill(null, null, false, false);
			this.path_ = new GraphicsPath(GraphicsUtil.QUAD_COMMANDS, null);
			this.vS_ = new Vector.<Number>();
			this.uvt_ = new Vector.<Number>();
			this.fillMatrix_ = new Matrix();
			super();
			objectId_ = getNextFakeObjectId();
			this.size_ = param1.size_;
			z_ = param1.z_;
			this.durationLeft_ = param1.duration_;
			this.texture_ = param1.textureData_.getTexture(objectId_);
			if (param1.animationsData_ != null) {
				this.animations_ = new Animations(param1.animationsData_);
			}
			this.moveVec_ = new Vector3D();
			var loc2:Number = Math.PI * 2 * Math.random();
			this.moveVec_.x = Math.cos(loc2) * 0.1 * 5;
			this.moveVec_.y = Math.sin(loc2) * 0.1 * 5;
		}

		public function moveTo(param1:Number, param2:Number):Boolean {
			var loc3:Square = map_.getSquare(param1, param2);
			if (loc3 == null) {
				return false;
			}
			x_ = param1;
			y_ = param2;
			square_ = loc3;
			return true;
		}

		override public function update(param1:int, param2:int):Boolean {
			var loc3:Number = NaN;
			loc3 = param2 / 1000;
			this.durationLeft_ = this.durationLeft_ - loc3;
			if (this.durationLeft_ <= 0) {
				return false;
			}
			x_ = x_ + this.moveVec_.x * loc3;
			y_ = y_ + this.moveVec_.y * loc3;
			return true;
		}

		override public function draw(param1:Vector.<IGraphicsData>, param2:Camera, param3:int):void {
			var loc7:BitmapData = null;
			var loc4:BitmapData = this.texture_;
			if (this.animations_ != null) {
				loc7 = this.animations_.getTexture(param3);
				if (loc7 != null) {
					loc4 = loc7;
				}
			}
			loc4 = TextureRedrawer.redraw(loc4, this.size_, true, 0);
			var loc5:int = loc4.width;
			var loc6:int = loc4.height;
			this.vS_.length = 0;
			this.vS_.push(posS_[3] - loc5 / 2, posS_[4] - loc6, posS_[3] + loc5 / 2, posS_[4] - loc6, posS_[3] + loc5 / 2, posS_[4], posS_[3] - loc5 / 2, posS_[4]);
			this.path_.data = this.vS_;
			this.bitmapFill_.bitmapData = loc4;
			this.fillMatrix_.identity();
			this.fillMatrix_.translate(this.vS_[0], this.vS_[1]);
			this.bitmapFill_.matrix = this.fillMatrix_;
			param1.push(this.bitmapFill_);
			param1.push(this.path_);
			param1.push(GraphicsUtil.END_FILL);
		}
	}
}
