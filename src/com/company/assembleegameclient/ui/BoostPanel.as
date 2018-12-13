 
package com.company.assembleegameclient.ui {
	import com.company.assembleegameclient.objects.Player;
	import com.company.assembleegameclient.util.TextureRedrawer;
	import com.company.util.AssetLibrary;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.filters.DropShadowFilter;
	import flash.utils.Timer;
	import kabam.rotmg.text.model.TextKey;
	import kabam.rotmg.text.view.TextFieldDisplayConcrete;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;
	import kabam.rotmg.text.view.stringBuilder.StringBuilder;
	import kabam.rotmg.ui.view.SignalWaiter;
	import org.osflash.signals.Signal;
	
	public class BoostPanel extends Sprite {
		 
		
		public const resized:Signal = new Signal();
		
		private const SPACE:uint = 40;
		
		private var timer:Timer;
		
		private var player:Player;
		
		private var tierBoostTimer:BoostTimer;
		
		private var dropBoostTimer:BoostTimer;
		
		private var posY:int;
		
		public function BoostPanel(param1:Player) {
			super();
			this.player = param1;
			this.createHeader();
			this.createBoostTimers();
			this.createTimer();
		}
		
		private function createTimer() : void {
			this.timer = new Timer(1000);
			this.timer.addEventListener(TimerEvent.TIMER,this.update);
			this.timer.start();
		}
		
		private function update(param1:TimerEvent) : void {
			this.updateTimer(this.tierBoostTimer,this.player.tierBoost);
			this.updateTimer(this.dropBoostTimer,this.player.dropBoost);
		}
		
		private function updateTimer(param1:BoostTimer, param2:int) : void {
			if(param1) {
				if(param2) {
					param1.setTime(param2);
				} else {
					this.destroyBoostTimers();
					this.createBoostTimers();
				}
			}
		}
		
		private function createHeader() : void {
			var loc3:TextFieldDisplayConcrete = null;
			var loc1:BitmapData = TextureRedrawer.redraw(AssetLibrary.getImageFromSet("lofiInterfaceBig",22),20,true,0);
			var loc2:Bitmap = new Bitmap(loc1);
			loc2.x = -3;
			loc2.y = -1;
			addChild(loc2);
			loc3 = new TextFieldDisplayConcrete().setSize(16).setColor(65280);
			loc3.setBold(true);
			loc3.setStringBuilder(new LineBuilder().setParams(TextKey.BOOSTPANEL_ACTIVEBOOSTS));
			loc3.setMultiLine(true);
			loc3.mouseEnabled = true;
			loc3.filters = [new DropShadowFilter(0,0,0)];
			loc3.x = 20;
			loc3.y = 4;
			addChild(loc3);
		}
		
		private function createBackground() : void {
			graphics.clear();
			graphics.lineStyle(2,16777215);
			graphics.beginFill(3355443);
			graphics.drawRoundRect(0,0,150,height + 5,10);
			this.resized.dispatch();
		}
		
		private function createBoostTimers() : void {
			this.posY = 25;
			var loc1:SignalWaiter = new SignalWaiter();
			this.addDropTimerIfAble(loc1);
			this.addTierBoostIfAble(loc1);
			if(loc1.isEmpty()) {
				this.createBackground();
			} else {
				loc1.complete.addOnce(this.createBackground);
			}
		}
		
		private function addTierBoostIfAble(param1:SignalWaiter) : void {
			if(this.player.tierBoost) {
				this.tierBoostTimer = this.returnBoostTimer(new LineBuilder().setParams(TextKey.BOOSTPANEL_TIERLEVELINCREASED),this.player.tierBoost);
				this.addTimer(param1,this.tierBoostTimer);
			}
		}
		
		private function addDropTimerIfAble(param1:SignalWaiter) : void {
			var loc2:String = null;
			if(this.player.dropBoost) {
				loc2 = "1.5x";
				this.dropBoostTimer = this.returnBoostTimer(new LineBuilder().setParams(TextKey.BOOSTPANEL_DROPRATE,{"rate":loc2}),this.player.dropBoost);
				this.addTimer(param1,this.dropBoostTimer);
			}
		}
		
		private function addTimer(param1:SignalWaiter, param2:BoostTimer) : void {
			param1.push(param2.textChanged);
			addChild(param2);
			param2.y = this.posY;
			param2.x = 10;
			this.posY = this.posY + this.SPACE;
		}
		
		private function destroyBoostTimers() : void {
			if(this.tierBoostTimer && this.tierBoostTimer.parent) {
				removeChild(this.tierBoostTimer);
			}
			if(this.dropBoostTimer && this.dropBoostTimer.parent) {
				removeChild(this.dropBoostTimer);
			}
			this.tierBoostTimer = null;
			this.dropBoostTimer = null;
		}
		
		private function returnBoostTimer(param1:StringBuilder, param2:int) : BoostTimer {
			var loc3:BoostTimer = new BoostTimer();
			loc3.setLabelBuilder(param1);
			loc3.setTime(param2);
			return loc3;
		}
	}
}
