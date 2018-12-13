 
package com.company.assembleegameclient.objects.particles {
	import com.company.assembleegameclient.objects.GameObject;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	public class ShockeeEffect extends ParticleEffect {
		 
		
		public var start_:Point;
		
		public var go:GameObject;
		
		private var isShocked:Boolean;
		
		public function ShockeeEffect(param1:GameObject) {
			super();
			this.go = param1;
		}
		
		override public function update(param1:int, param2:int) : Boolean {
			var loc3:Timer = new Timer(50,12);
			loc3.addEventListener(TimerEvent.TIMER,this.onTimer);
			loc3.start();
			return false;
		}
		
		private function onTimer(param1:TimerEvent) : void {
			this.isShocked = !this.isShocked;
			this.go.toggleShockEffect(this.isShocked);
		}
	}
}
