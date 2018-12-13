 
package com.company.assembleegameclient.map.partyoverlay {
	import com.company.assembleegameclient.map.Camera;
	import com.company.assembleegameclient.map.Map;
	import com.company.assembleegameclient.objects.Party;
	import com.company.assembleegameclient.objects.Player;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class PartyOverlay extends Sprite {
		 
		
		public var map_:Map;
		
		public var partyMemberArrows_:Vector.<PlayerArrow> = null;
		
		public var questArrow_:QuestArrow;
		
		public function PartyOverlay(param1:Map) {
			var loc3:PlayerArrow = null;
			super();
			this.map_ = param1;
			this.partyMemberArrows_ = new Vector.<PlayerArrow>(Party.NUM_MEMBERS,true);
			var loc2:int = 0;
			while(loc2 < Party.NUM_MEMBERS) {
				loc3 = new PlayerArrow();
				this.partyMemberArrows_[loc2] = loc3;
				addChild(loc3);
				loc2++;
			}
			this.questArrow_ = new QuestArrow(this.map_);
			addChild(this.questArrow_);
			addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
		}
		
		private function onRemovedFromStage(param1:Event) : void {
			GameObjectArrow.removeMenu();
		}
		
		public function draw(param1:Camera, param2:int) : void {
			var loc6:PlayerArrow = null;
			var loc7:Player = null;
			var loc8:int = 0;
			var loc9:PlayerArrow = null;
			var loc10:Number = NaN;
			var loc11:Number = NaN;
			if(this.map_.player_ == null) {
				return;
			}
			var loc3:Party = this.map_.party_;
			var loc4:Player = this.map_.player_;
			var loc5:int = 0;
			while(loc5 < Party.NUM_MEMBERS) {
				loc6 = this.partyMemberArrows_[loc5];
				if(!loc6.mouseOver_) {
					if(loc5 >= loc3.members_.length) {
						loc6.setGameObject(null);
					} else {
						loc7 = loc3.members_[loc5];
						if(loc7.drawn_ || loc7.map_ == null || loc7.dead_) {
							loc6.setGameObject(null);
						} else {
							loc6.setGameObject(loc7);
							loc8 = 0;
							while(loc8 < loc5) {
								loc9 = this.partyMemberArrows_[loc8];
								loc10 = loc6.x - loc9.x;
								loc11 = loc6.y - loc9.y;
								if(loc10 * loc10 + loc11 * loc11 < 64) {
									if(!loc9.mouseOver_) {
										loc9.addGameObject(loc7);
									}
									loc6.setGameObject(null);
									break;
								}
								loc8++;
							}
							loc6.draw(param2,param1);
						}
					}
				}
				loc5++;
			}
			if(!this.questArrow_.mouseOver_) {
				this.questArrow_.draw(param2,param1);
			}
		}
	}
}
