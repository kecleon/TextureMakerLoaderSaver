 
package com.company.assembleegameclient.objects.particles {
	import com.company.assembleegameclient.objects.GameObject;
	import flash.geom.Point;
	import kabam.rotmg.messaging.impl.data.WorldPosData;
	
	public class BurstEffect extends ParticleEffect {
		 
		
		public var center_:Point;
		
		public var edgePoint_:Point;
		
		public var color_:int;
		
		public function BurstEffect(param1:GameObject, param2:WorldPosData, param3:WorldPosData, param4:int) {
			super();
			this.center_ = new Point(param2.x_,param2.y_);
			this.edgePoint_ = new Point(param3.x_,param3.y_);
			this.color_ = param4;
		}
		
		override public function runNormalRendering(param1:int, param2:int) : Boolean {
			var loc7:Number = NaN;
			var loc8:Point = null;
			var loc9:Particle = null;
			x_ = this.center_.x;
			y_ = this.center_.y;
			var loc3:Number = Point.distance(this.center_,this.edgePoint_);
			var loc4:int = 100;
			var loc5:int = 24;
			var loc6:int = 0;
			while(loc6 < loc5) {
				loc7 = loc6 * 2 * Math.PI / loc5;
				loc8 = new Point(this.center_.x + loc3 * Math.cos(loc7),this.center_.y + loc3 * Math.sin(loc7));
				loc9 = new SparkerParticle(loc4,this.color_,100 + Math.random() * 200,this.center_,loc8);
				map_.addObj(loc9,x_,y_);
				loc6++;
			}
			return false;
		}
		
		override public function runEasyRendering(param1:int, param2:int) : Boolean {
			var loc7:Number = NaN;
			var loc8:Point = null;
			var loc9:Particle = null;
			x_ = this.center_.x;
			y_ = this.center_.y;
			var loc3:Number = Point.distance(this.center_,this.edgePoint_);
			var loc4:int = 10;
			var loc5:int = 10;
			var loc6:int = 0;
			while(loc6 < loc5) {
				loc7 = loc6 * 2 * Math.PI / loc5;
				loc8 = new Point(this.center_.x + loc3 * Math.cos(loc7),this.center_.y + loc3 * Math.sin(loc7));
				loc9 = new SparkerParticle(loc4,this.color_,50 + Math.random() * 20,this.center_,loc8);
				map_.addObj(loc9,x_,y_);
				loc6++;
			}
			return false;
		}
	}
}
