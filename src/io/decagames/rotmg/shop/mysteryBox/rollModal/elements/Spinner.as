 
package io.decagames.rotmg.shop.mysteryBox.rollModal.elements {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	import io.decagames.rotmg.utils.colors.RGB;
	import io.decagames.rotmg.utils.colors.RandomColorGenerator;
	import io.decagames.rotmg.utils.colors.Tint;
	import kabam.rotmg.assets.EmbeddedAssets;
	
	public class Spinner extends Sprite {
		 
		
		public const graphic:DisplayObject = new EmbeddedAssets.StarburstSpinner();
		
		private var _degreesPerSecond:int;
		
		private var secondsElapsed:Number;
		
		private var previousSeconds:Number;
		
		private var startColor:uint;
		
		private var endColor:uint;
		
		private var direction:Boolean;
		
		private var previousProgress:Number = 0;
		
		private var multicolor:Boolean;
		
		private var rStart:Number = -1;
		
		private var gStart:Number = -1;
		
		private var bStart:Number = -1;
		
		private var rFinal:Number = -1;
		
		private var gFinal:Number = -1;
		
		private var bFinal:Number = -1;
		
		public function Spinner(param1:int, param2:Boolean = false) {
			super();
			this._degreesPerSecond = param1;
			this.multicolor = param2;
			this.secondsElapsed = 0;
			this.setupStartAndFinalColors();
			this.addGraphic();
			this.applyColor(0);
			addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
			addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved);
		}
		
		private function addGraphic() : void {
			addChild(this.graphic);
			this.graphic.x = -1 * width / 2;
			this.graphic.y = -1 * height / 2;
		}
		
		private function onRemoved(param1:Event) : void {
			removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved);
			removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
		}
		
		public function pause() : void {
			removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
			this.previousSeconds = 0;
		}
		
		public function resume() : void {
			addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
		}
		
		private function onEnterFrame(param1:Event) : void {
			this.updateTimeElapsed();
			var loc2:Number = this._degreesPerSecond * this.secondsElapsed % 360;
			rotation = loc2;
			this.applyColor(loc2 / 360);
		}
		
		private function applyColor(param1:Number) : void {
			if(!this.multicolor) {
				return;
			}
			if(param1 < this.previousProgress) {
				this.direction = !this.direction;
			}
			this.previousProgress = param1;
			if(this.direction) {
				param1 = 1 - param1;
			}
			var loc2:uint = this.getColorByProgress(param1);
			Tint.add(this.graphic,loc2,1);
		}
		
		private function getColorByProgress(param1:Number) : uint {
			var loc2:Number = this.rStart + (this.rFinal - this.rStart) * param1;
			var loc3:Number = this.gStart + (this.gFinal - this.gStart) * param1;
			var loc4:Number = this.bStart + (this.bFinal - this.bStart) * param1;
			return RGB.fromRGB(loc2,loc3,loc4);
		}
		
		private function setupStartAndFinalColors() : void {
			var loc1:RandomColorGenerator = new RandomColorGenerator();
			var loc2:Array = loc1.randomColor();
			var loc3:Array = loc1.randomColor();
			this.rStart = loc2[0];
			this.gStart = loc2[1];
			this.bStart = loc2[2];
			this.rFinal = loc3[0];
			this.gFinal = loc3[1];
			this.bFinal = loc3[2];
		}
		
		private function updateTimeElapsed() : void {
			var loc1:Number = getTimer() / 1000;
			if(this.previousSeconds) {
				this.secondsElapsed = this.secondsElapsed + (loc1 - this.previousSeconds);
			}
			this.previousSeconds = loc1;
		}
		
		public function get degreesPerSecond() : int {
			return this._degreesPerSecond;
		}
	}
}
