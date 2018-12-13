 
package com.company.assembleegameclient.background {
	import com.company.assembleegameclient.map.Camera;
	import com.company.util.AssetLibrary;
	import com.company.util.ImageSet;
	import com.company.util.PointUtil;
	import flash.display.IGraphicsData;
	
	public class StarBackground extends Background {
		 
		
		public var stars_:Vector.<Star>;
		
		protected var graphicsData_:Vector.<IGraphicsData>;
		
		public function StarBackground() {
			this.stars_ = new Vector.<Star>();
			this.graphicsData_ = new Vector.<IGraphicsData>();
			super();
			visible = true;
			var loc1:int = 0;
			while(loc1 < 100) {
				this.tryAddStar();
				loc1++;
			}
		}
		
		override public function draw(param1:Camera, param2:int) : void {
			var loc3:Star = null;
			this.graphicsData_.length = 0;
			for each(loc3 in this.stars_) {
				loc3.draw(this.graphicsData_,param1,param2);
			}
			graphics.clear();
			graphics.drawGraphicsData(this.graphicsData_);
		}
		
		private function tryAddStar() : void {
			var loc3:Star = null;
			var loc1:ImageSet = AssetLibrary.getImageSet("stars");
			var loc2:Star = new Star(Math.random() * 1000 - 500,Math.random() * 1000 - 500,4 * (0.5 + 0.5 * Math.random()),loc1.images_[int(loc1.images_.length * Math.random())]);
			for each(loc3 in this.stars_) {
				if(PointUtil.distanceXY(loc2.x_,loc2.y_,loc3.x_,loc3.y_) < 3) {
					return;
				}
			}
			this.stars_.push(loc2);
		}
	}
}

import com.company.assembleegameclient.map.Camera;
import flash.display.BitmapData;
import flash.display.GraphicsBitmapFill;
import flash.display.GraphicsEndFill;
import flash.display.GraphicsPath;
import flash.display.GraphicsPathCommand;
import flash.display.IGraphicsData;
import flash.geom.Matrix;

class Star {
	
	protected static const sqCommands:Vector.<int> = new <int>[GraphicsPathCommand.MOVE_TO,GraphicsPathCommand.LINE_TO,GraphicsPathCommand.LINE_TO,GraphicsPathCommand.LINE_TO];
	
	protected static const END_FILL:GraphicsEndFill = new GraphicsEndFill();
	 
	
	public var x_:Number;
	
	public var y_:Number;
	
	public var scale_:Number;
	
	public var bitmap_:BitmapData;
	
	private var w_:Number;
	
	private var h_:Number;
	
	protected var bitmapFill_:GraphicsBitmapFill;
	
	protected var path_:GraphicsPath;
	
	function Star(param1:Number, param2:Number, param3:Number, param4:BitmapData) {
		this.bitmapFill_ = new GraphicsBitmapFill(null,new Matrix(),false,false);
		this.path_ = new GraphicsPath(sqCommands,new Vector.<Number>());
		super();
		this.x_ = param1;
		this.y_ = param2;
		this.scale_ = param3;
		this.bitmap_ = param4;
		this.w_ = this.bitmap_.width * this.scale_;
		this.h_ = this.bitmap_.height * this.scale_;
	}
	
	public function draw(param1:Vector.<IGraphicsData>, param2:Camera, param3:int) : void {
		var loc4:Number = this.x_ * Math.cos(-param2.angleRad_) - this.y_ * Math.sin(-param2.angleRad_);
		var loc5:Number = this.x_ * Math.sin(-param2.angleRad_) + this.y_ * Math.cos(-param2.angleRad_);
		var loc6:Matrix = this.bitmapFill_.matrix;
		loc6.identity();
		loc6.translate(-this.bitmap_.width / 2,-this.bitmap_.height / 2);
		loc6.scale(this.scale_,this.scale_);
		loc6.translate(loc4,loc5);
		this.bitmapFill_.bitmapData = this.bitmap_;
		this.path_.data.length = 0;
		var loc7:Number = loc4 - this.w_ / 2;
		var loc8:Number = loc5 - this.h_ / 2;
		this.path_.data.push(loc7,loc8,loc7 + this.w_,loc8,loc7 + this.w_,loc8 + this.h_,loc7,loc8 + this.h_);
		param1.push(this.bitmapFill_);
		param1.push(this.path_);
		param1.push(END_FILL);
	}
}
