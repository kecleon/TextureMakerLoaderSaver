 
package com.company.assembleegameclient.objects.particles {
	import com.company.assembleegameclient.objects.GameObject;
	import com.company.assembleegameclient.util.RandomUtil;
	import flash.geom.Point;
	import kabam.rotmg.messaging.impl.data.WorldPosData;
	
	public class LineEffect extends ParticleEffect {
		 
		
		public var start_:Point;
		
		public var end_:Point;
		
		public var color_:int;
		
		public function LineEffect(param1:GameObject, param2:WorldPosData, param3:int) {
			super();
			this.start_ = new Point(param1.x_,param1.y_);
			this.end_ = new Point(param2.x_,param2.y_);
			this.color_ = param3;
		}
		
		override public function runNormalRendering(param1:int, param2:int) : Boolean {
			var loc5:Point = null;
			var loc6:Particle = null;
			x_ = this.start_.x;
			y_ = this.start_.y;
			var loc3:int = 30;
			var loc4:int = 0;
			while(loc4 < loc3) {
				loc5 = Point.interpolate(this.start_,this.end_,loc4 / loc3);
				loc6 = new SparkParticle(100,this.color_,700,0.5,RandomUtil.plusMinus(1),RandomUtil.plusMinus(1));
				map_.addObj(loc6,loc5.x,loc5.y);
				loc4++;
			}
			return false;
		}
		
		override public function runEasyRendering(param1:int, param2:int) : Boolean {
			var loc5:Point = null;
			var loc6:Particle = null;
			x_ = this.start_.x;
			y_ = this.start_.y;
			var loc3:int = 5;
			var loc4:int = 0;
			while(loc4 < loc3) {
				loc5 = Point.interpolate(this.start_,this.end_,loc4 / loc3);
				loc6 = new SparkParticle(100,this.color_,200,0.5,RandomUtil.plusMinus(1),RandomUtil.plusMinus(1));
				map_.addObj(loc6,loc5.x,loc5.y);
				loc4++;
			}
			return false;
		}
	}
}
