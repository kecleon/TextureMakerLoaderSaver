 
package com.company.assembleegameclient.objects.particles {
	import com.company.assembleegameclient.objects.GameObject;
	import flash.geom.Point;
	import kabam.rotmg.messaging.impl.data.WorldPosData;
	
	public class ConeBlastEffect extends ParticleEffect {
		 
		
		public var start_:Point;
		
		public var target_:WorldPosData;
		
		public var blastRadius_:Number;
		
		public var color_:int;
		
		public function ConeBlastEffect(param1:GameObject, param2:WorldPosData, param3:Number, param4:int) {
			super();
			this.start_ = new Point(param1.x_,param1.y_);
			this.target_ = param2;
			this.blastRadius_ = param3;
			this.color_ = param4;
		}
		
		override public function runNormalRendering(param1:int, param2:int) : Boolean {
			var loc9:Number = NaN;
			var loc10:Point = null;
			var loc11:Particle = null;
			x_ = this.start_.x;
			y_ = this.start_.y;
			var loc3:int = 200;
			var loc4:int = 100;
			var loc5:Number = Math.PI / 3;
			var loc6:int = 7;
			var loc7:Number = Math.atan2(this.target_.y_ - this.start_.y,this.target_.x_ - this.start_.x);
			var loc8:int = 0;
			while(loc8 < loc6) {
				loc9 = loc7 - loc5 / 2 + loc8 * loc5 / loc6;
				loc10 = new Point(this.start_.x + this.blastRadius_ * Math.cos(loc9),this.start_.y + this.blastRadius_ * Math.sin(loc9));
				loc11 = new SparkerParticle(loc3,this.color_,loc4,this.start_,loc10);
				map_.addObj(loc11,x_,y_);
				loc8++;
			}
			return false;
		}
		
		override public function runEasyRendering(param1:int, param2:int) : Boolean {
			var loc9:Number = NaN;
			var loc10:Point = null;
			var loc11:Particle = null;
			x_ = this.start_.x;
			y_ = this.start_.y;
			var loc3:int = 50;
			var loc4:int = 10;
			var loc5:Number = Math.PI / 3;
			var loc6:int = 5;
			var loc7:Number = Math.atan2(this.target_.y_ - this.start_.y,this.target_.x_ - this.start_.x);
			var loc8:int = 0;
			while(loc8 < loc6) {
				loc9 = loc7 - loc5 / 2 + loc8 * loc5 / loc6;
				loc10 = new Point(this.start_.x + this.blastRadius_ * Math.cos(loc9),this.start_.y + this.blastRadius_ * Math.sin(loc9));
				loc11 = new SparkerParticle(loc3,this.color_,loc4,this.start_,loc10);
				map_.addObj(loc11,x_,y_);
				loc8++;
			}
			return false;
		}
	}
}
