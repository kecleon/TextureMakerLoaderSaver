 
package com.company.assembleegameclient.objects.particles {
	import com.company.assembleegameclient.objects.GameObject;
	import flash.geom.Point;
	import kabam.rotmg.messaging.impl.data.WorldPosData;
	
	public class CollapseEffect extends ParticleEffect {
		 
		
		public var center_:Point;
		
		public var edgePoint_:Point;
		
		public var color_:int;
		
		public function CollapseEffect(param1:GameObject, param2:WorldPosData, param3:WorldPosData, param4:int) {
			super();
			this.center_ = new Point(param2.x_,param2.y_);
			this.edgePoint_ = new Point(param3.x_,param3.y_);
			this.color_ = param4;
		}
		
		override public function runNormalRendering(param1:int, param2:int) : Boolean {
			var loc8:Number = NaN;
			var loc9:Point = null;
			var loc10:Particle = null;
			x_ = this.center_.x;
			y_ = this.center_.y;
			var loc3:Number = Point.distance(this.center_,this.edgePoint_);
			var loc4:int = 300;
			var loc5:int = 200;
			var loc6:int = 24;
			var loc7:int = 0;
			while(loc7 < loc6) {
				loc8 = loc7 * 2 * Math.PI / loc6;
				loc9 = new Point(this.center_.x + loc3 * Math.cos(loc8),this.center_.y + loc3 * Math.sin(loc8));
				loc10 = new SparkerParticle(loc4,this.color_,loc5,loc9,this.center_);
				map_.addObj(loc10,x_,y_);
				loc7++;
			}
			return false;
		}
		
		override public function runEasyRendering(param1:int, param2:int) : Boolean {
			var loc8:Number = NaN;
			var loc9:Point = null;
			var loc10:Particle = null;
			x_ = this.center_.x;
			y_ = this.center_.y;
			var loc3:Number = Point.distance(this.center_,this.edgePoint_);
			var loc4:int = 50;
			var loc5:int = 150;
			var loc6:int = 8;
			var loc7:int = 0;
			while(loc7 < loc6) {
				loc8 = loc7 * 2 * Math.PI / loc6;
				loc9 = new Point(this.center_.x + loc3 * Math.cos(loc8),this.center_.y + loc3 * Math.sin(loc8));
				loc10 = new SparkerParticle(loc4,this.color_,loc5,loc9,this.center_);
				map_.addObj(loc10,x_,y_);
				loc7++;
			}
			return false;
		}
	}
}
