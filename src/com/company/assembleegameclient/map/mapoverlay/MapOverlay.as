 
package com.company.assembleegameclient.map.mapoverlay {
	import com.company.assembleegameclient.map.Camera;
	import com.company.assembleegameclient.map.Map;
	import com.company.assembleegameclient.parameters.Parameters;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import kabam.rotmg.game.view.components.QueuedStatusText;
	import kabam.rotmg.game.view.components.QueuedStatusTextList;
	
	public class MapOverlay extends Sprite {
		 
		
		private const speechBalloons:Object = {};
		
		private const queuedText:Object = {};
		
		public function MapOverlay() {
			super();
			mouseEnabled = true;
			mouseChildren = true;
			addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown,false,0,true);
		}
		
		private function onMouseDown(param1:MouseEvent) : void {
			if(Parameters.isGpuRender()) {
				(parent as Map).mapHitArea.dispatchEvent(param1);
			}
		}
		
		public function addSpeechBalloon(param1:SpeechBalloon) : void {
			var loc2:int = param1.go_.objectId_;
			var loc3:SpeechBalloon = this.speechBalloons[loc2];
			if(loc3 && contains(loc3)) {
				removeChild(loc3);
			}
			this.speechBalloons[loc2] = param1;
			addChild(param1);
		}
		
		public function addStatusText(param1:CharacterStatusText) : void {
			addChild(param1);
		}
		
		public function addQueuedText(param1:QueuedStatusText) : void {
			var loc2:int = param1.go_.objectId_;
			var loc3:QueuedStatusTextList = this.queuedText[loc2] = this.queuedText[loc2] || this.makeQueuedStatusTextList();
			loc3.append(param1);
		}
		
		private function makeQueuedStatusTextList() : QueuedStatusTextList {
			var loc1:QueuedStatusTextList = new QueuedStatusTextList();
			loc1.target = this;
			return loc1;
		}
		
		public function draw(param1:Camera, param2:int) : void {
			var loc4:IMapOverlayElement = null;
			var loc3:int = 0;
			while(loc3 < numChildren) {
				loc4 = getChildAt(loc3) as IMapOverlayElement;
				if(!loc4 || loc4.draw(param1,param2)) {
					loc3++;
				} else {
					loc4.dispose();
				}
			}
		}
	}
}
