 
package com.company.assembleegameclient.background {
	import com.company.assembleegameclient.map.Camera;
	import com.company.util.GraphicsUtil;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.GraphicsBitmapFill;
	import flash.display.GraphicsPath;
	import flash.display.IGraphicsData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class NexusBackground extends Background {
		
		public static const MOVEMENT:Point = new Point(0.01,0.01);
		 
		
		private var water_:BitmapData;
		
		private var islands_:Vector.<Island>;
		
		protected var graphicsData_:Vector.<IGraphicsData>;
		
		private var bitmapFill_:GraphicsBitmapFill;
		
		private var path_:GraphicsPath;
		
		public function NexusBackground() {
			this.islands_ = new Vector.<Island>();
			this.graphicsData_ = new Vector.<IGraphicsData>();
			this.bitmapFill_ = new GraphicsBitmapFill(null,new Matrix(),true,false);
			this.path_ = new GraphicsPath(GraphicsUtil.QUAD_COMMANDS,new Vector.<Number>());
			super();
			visible = true;
			this.water_ = new BitmapDataSpy(1024,1024,false,0);
			this.water_.perlinNoise(1024,1024,8,Math.random(),true,true,BitmapDataChannel.BLUE,false,null);
		}
		
		override public function draw(param1:Camera, param2:int) : void {
			this.graphicsData_.length = 0;
			var loc3:Matrix = this.bitmapFill_.matrix;
			loc3.identity();
			loc3.translate(param2 * MOVEMENT.x,param2 * MOVEMENT.y);
			loc3.rotate(-param1.angleRad_);
			this.bitmapFill_.bitmapData = this.water_;
			this.graphicsData_.push(this.bitmapFill_);
			this.path_.data.length = 0;
			var loc4:Rectangle = param1.clipRect_;
			this.path_.data.push(loc4.left,loc4.top,loc4.right,loc4.top,loc4.right,loc4.bottom,loc4.left,loc4.bottom);
			this.graphicsData_.push(this.path_);
			this.graphicsData_.push(GraphicsUtil.END_FILL);
			this.drawIslands(param1,param2);
			graphics.clear();
			graphics.drawGraphicsData(this.graphicsData_);
		}
		
		private function drawIslands(param1:Camera, param2:int) : void {
			var loc4:Island = null;
			var loc3:int = 0;
			while(loc3 < this.islands_.length) {
				loc4 = this.islands_[loc3];
				loc4.draw(param1,param2,this.graphicsData_);
				loc3++;
			}
		}
	}
}

import com.company.assembleegameclient.background.NexusBackground;
import com.company.assembleegameclient.map.Camera;
import com.company.util.AssetLibrary;
import com.company.util.GraphicsUtil;
import flash.display.BitmapData;
import flash.display.GraphicsBitmapFill;
import flash.display.GraphicsPath;
import flash.display.IGraphicsData;
import flash.geom.Matrix;
import flash.geom.Point;

class Island {
	 
	
	public var center_:Point;
	
	public var startTime_:int;
	
	public var bitmapData_:BitmapData;
	
	private var bitmapFill_:GraphicsBitmapFill;
	
	private var path_:GraphicsPath;
	
	function Island(param1:Number, param2:Number, param3:int) {
		this.bitmapFill_ = new GraphicsBitmapFill(null,new Matrix(),true,false);
		this.path_ = new GraphicsPath(GraphicsUtil.QUAD_COMMANDS,new Vector.<Number>());
		super();
		this.center_ = new Point(param1,param2);
		this.startTime_ = param3;
		this.bitmapData_ = AssetLibrary.getImage("stars");
	}
	
	public function draw(param1:Camera, param2:int, param3:Vector.<IGraphicsData>) : void {
		var loc4:int = param2 - this.startTime_;
		var loc5:Number = this.center_.x + loc4 * NexusBackground.MOVEMENT.x;
		var loc6:Number = this.center_.y + loc4 * NexusBackground.MOVEMENT.y;
		var loc7:Matrix = this.bitmapFill_.matrix;
		loc7.identity();
		loc7.translate(loc5,loc6);
		loc7.rotate(-param1.angleRad_);
		this.bitmapFill_.bitmapData = this.bitmapData_;
		param3.push(this.bitmapFill_);
		this.path_.data.length = 0;
		var loc8:Point = loc7.transformPoint(new Point(loc5,loc6));
		var loc9:Point = loc7.transformPoint(new Point(loc5 + this.bitmapData_.width,loc6 + this.bitmapData_.height));
		this.path_.data.push(loc8.x,loc8.y,loc9.x,loc8.y,loc9.x,loc9.y,loc8.x,loc9.y);
		param3.push(this.path_);
		param3.push(GraphicsUtil.END_FILL);
	}
}
