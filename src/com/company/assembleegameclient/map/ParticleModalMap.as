 
package com.company.assembleegameclient.map {
	import com.company.assembleegameclient.objects.BasicObject;
	import com.company.assembleegameclient.objects.GameObject;
	import com.company.assembleegameclient.objects.particles.ConfettiEffect;
	import com.company.assembleegameclient.objects.particles.LightningEffect;
	import com.company.assembleegameclient.objects.particles.NovaEffect;
	import flash.display.IGraphicsData;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	import kabam.rotmg.messaging.impl.data.WorldPosData;
	
	public class ParticleModalMap extends Map {
		
		public static const MODE_SNOW:int = 1;
		
		public static const MODE_AUTO_UPDATE:int = 2;
		
		public static const PSCALE:Number = 16;
		 
		
		private var inUpdate_:Boolean = false;
		
		private var objsToAdd_:Vector.<BasicObject>;
		
		private var idsToRemove_:Vector.<int>;
		
		private var dt:uint = 0;
		
		private var dtBuildup:uint = 0;
		
		private var time:uint = 0;
		
		private var graphicsData_:Vector.<IGraphicsData>;
		
		public function ParticleModalMap(param1:int = -1) {
			this.objsToAdd_ = new Vector.<BasicObject>();
			this.idsToRemove_ = new Vector.<int>();
			this.graphicsData_ = new Vector.<IGraphicsData>();
			super(null);
			if(param1 == MODE_SNOW) {
				addEventListener(Event.ENTER_FRAME,this.activateModeSnow);
			}
			if(param1 == MODE_AUTO_UPDATE) {
				addEventListener(Event.ENTER_FRAME,this.updater);
			}
		}
		
		public static function getLocalPos(param1:Number) : Number {
			return param1 / PSCALE;
		}
		
		override public function addObj(param1:BasicObject, param2:Number, param3:Number) : void {
			param1.x_ = param2;
			param1.y_ = param3;
			if(this.inUpdate_) {
				this.objsToAdd_.push(param1);
			} else {
				this.internalAddObj(param1);
			}
		}
		
		override public function internalAddObj(param1:BasicObject) : void {
			var loc2:Dictionary = boDict_;
			if(loc2[param1.objectId_] != null) {
				return;
			}
			param1.map_ = this;
			loc2[param1.objectId_] = param1;
		}
		
		override public function internalRemoveObj(param1:int) : void {
			var loc2:Dictionary = boDict_;
			var loc3:BasicObject = loc2[param1];
			if(loc3 == null) {
				return;
			}
			loc3.removeFromMap();
			delete loc2[param1];
		}
		
		override public function update(param1:int, param2:int) : void {
			var loc3:BasicObject = null;
			var loc4:int = 0;
			this.inUpdate_ = true;
			for each(loc3 in boDict_) {
				if(!loc3.update(param1,param2)) {
					this.idsToRemove_.push(loc3.objectId_);
				}
			}
			this.inUpdate_ = false;
			for each(loc3 in this.objsToAdd_) {
				this.internalAddObj(loc3);
			}
			this.objsToAdd_.length = 0;
			for each(loc4 in this.idsToRemove_) {
				this.internalRemoveObj(loc4);
			}
			this.idsToRemove_.length = 0;
		}
		
		override public function draw(param1:Camera, param2:int) : void {
			var loc3:BasicObject = null;
			this.graphicsData_.length = 0;
			var loc4:int = 0;
			for each(loc3 in boDict_) {
				loc4++;
				loc3.computeSortValNoCamera(PSCALE);
				loc3.draw(this.graphicsData_,param1,param2);
			}
			graphics.clear();
			if(this.graphicsData_.length > 0) {
				graphics.drawGraphicsData(this.graphicsData_);
			}
		}
		
		private function activateModeSnow(param1:Event) : void {
			var loc2:int = 600;
			var loc3:int = 600;
			if(this.time != 0) {
				this.dt = getTimer() - this.time;
			}
			this.dtBuildup = this.dtBuildup + this.dt;
			this.time = getTimer();
			if(this.dtBuildup > 500) {
				this.dtBuildup = 0;
				this.doSnow(Math.random() * 600,-100);
			}
			this.update(this.time,this.dt);
			this.draw(null,this.time);
		}
		
		private function updater(param1:Event) : void {
			if(this.time != 0) {
				this.dt = getTimer() - this.time;
			}
			this.time = getTimer();
			this.update(this.time,this.dt);
			this.draw(null,this.time);
		}
		
		public function doNova(param1:Number, param2:Number, param3:int = 20, param4:int = 12447231) : void {
			var loc5:GameObject = new GameObject(null);
			loc5.x_ = getLocalPos(param1);
			loc5.y_ = getLocalPos(param2);
			var loc6:NovaEffect = new NovaEffect(loc5,param3,param4);
			this.addObj(loc6,loc5.x_,loc5.y_);
		}
		
		private function doSnow(param1:Number, param2:Number, param3:int = 20, param4:int = 12447231) : void {
			var loc5:WorldPosData = new WorldPosData();
			var loc6:WorldPosData = new WorldPosData();
			loc5.x_ = getLocalPos(param1);
			loc5.y_ = getLocalPos(param2);
			loc6.x_ = getLocalPos(param1);
			loc6.y_ = getLocalPos(600);
			var loc7:ConfettiEffect = new ConfettiEffect(loc5,loc6,param4,param3,true);
			this.addObj(loc7,loc5.x_,loc5.y_);
		}
		
		public function doLightning(param1:Number, param2:Number, param3:Number, param4:Number, param5:int = 200, param6:int = 12447231, param7:Number = 1) : void {
			var loc8:GameObject = new GameObject(null);
			loc8.x_ = getLocalPos(param1);
			loc8.y_ = getLocalPos(param2);
			var loc9:WorldPosData = new WorldPosData();
			loc9.x_ = getLocalPos(param3);
			loc9.y_ = getLocalPos(param4);
			var loc10:LightningEffect = new LightningEffect(loc8,loc9,param6,param5,param7);
			this.addObj(loc10,loc8.x_,loc8.y_);
		}
	}
}
