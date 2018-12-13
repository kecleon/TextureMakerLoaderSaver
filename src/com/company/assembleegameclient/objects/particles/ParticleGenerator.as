 
package com.company.assembleegameclient.objects.particles {
	import com.company.assembleegameclient.objects.GameObject;
	import com.company.assembleegameclient.util.TextureRedrawer;
	import com.company.util.AssetLibrary;
	import flash.display.BitmapData;
	
	public class ParticleGenerator extends ParticleEffect {
		 
		
		private var particlePool:Vector.<BaseParticle>;
		
		private var liveParticles:Vector.<BaseParticle>;
		
		private var targetGO:GameObject;
		
		private var generatedParticles:Number = 0;
		
		private var totalTime:Number = 0;
		
		private var effectProps:EffectProperties;
		
		private var bitmapData:BitmapData;
		
		private var friction:Number;
		
		public function ParticleGenerator(param1:EffectProperties, param2:GameObject) {
			super();
			this.targetGO = param2;
			this.particlePool = new Vector.<BaseParticle>();
			this.liveParticles = new Vector.<BaseParticle>();
			this.effectProps = param1;
			if(this.effectProps.bitmapFile) {
				this.bitmapData = AssetLibrary.getImageFromSet(this.effectProps.bitmapFile,this.effectProps.bitmapIndex);
				this.bitmapData = TextureRedrawer.redraw(this.bitmapData,this.effectProps.size,true,0);
			} else {
				this.bitmapData = TextureRedrawer.redrawSolidSquare(this.effectProps.color,this.effectProps.size);
			}
		}
		
		public static function attachParticleGenerator(param1:EffectProperties, param2:GameObject) : ParticleGenerator {
			return new ParticleGenerator(param1,param2);
		}
		
		override public function update(param1:int, param2:int) : Boolean {
			var loc4:Number = NaN;
			var loc9:BaseParticle = null;
			var loc10:BaseParticle = null;
			var loc3:Number = param1 / 1000;
			loc4 = param2 / 1000;
			if(this.targetGO.map_ == null) {
				return false;
			}
			x_ = this.targetGO.x_;
			y_ = this.targetGO.y_;
			z_ = this.targetGO.z_ + this.effectProps.zOffset;
			this.totalTime = this.totalTime + loc4;
			var loc5:Number = this.effectProps.rate * this.totalTime;
			var loc6:int = loc5 - this.generatedParticles;
			var loc7:int = 0;
			while(loc7 < loc6) {
				if(this.particlePool.length) {
					loc9 = this.particlePool.pop();
				} else {
					loc9 = new BaseParticle(this.bitmapData);
				}
				loc9.initialize(this.effectProps.life + this.effectProps.lifeVariance * (2 * Math.random() - 1),this.effectProps.speed + this.effectProps.speedVariance * (2 * Math.random() - 1),this.effectProps.speed + this.effectProps.speedVariance * (2 * Math.random() - 1),this.effectProps.rise + this.effectProps.riseVariance * (2 * Math.random() - 1),z_);
				map_.addObj(loc9,x_ + this.effectProps.rangeX * (2 * Math.random() - 1),y_ + this.effectProps.rangeY * (2 * Math.random() - 1));
				this.liveParticles.push(loc9);
				loc7++;
			}
			this.generatedParticles = this.generatedParticles + loc6;
			var loc8:int = 0;
			while(loc8 < this.liveParticles.length) {
				loc10 = this.liveParticles[loc8];
				loc10.timeLeft = loc10.timeLeft - loc4;
				if(loc10.timeLeft <= 0) {
					this.liveParticles.splice(loc8,1);
					map_.removeObj(loc10.objectId_);
					loc8--;
					this.particlePool.push(loc10);
				} else {
					loc10.spdZ = loc10.spdZ + this.effectProps.riseAcc * loc4;
					loc10.x_ = loc10.x_ + loc10.spdX * loc4;
					loc10.y_ = loc10.y_ + loc10.spdY * loc4;
					loc10.z_ = loc10.z_ + loc10.spdZ * loc4;
				}
				loc8++;
			}
			return true;
		}
		
		override public function removeFromMap() : void {
			var loc1:BaseParticle = null;
			for each(loc1 in this.liveParticles) {
				map_.removeObj(loc1.objectId_);
			}
			this.liveParticles = null;
			this.particlePool = null;
			super.removeFromMap();
		}
	}
}
