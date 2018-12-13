 
package com.company.assembleegameclient.ui.panels {
	import com.company.assembleegameclient.game.GameSprite;
	import com.company.assembleegameclient.objects.Party;
	import com.company.assembleegameclient.objects.Player;
	import com.company.assembleegameclient.ui.GameObjectListItem;
	import com.company.assembleegameclient.ui.PlayerGameObjectListItem;
	import com.company.assembleegameclient.ui.menu.PlayerMenu;
	import com.company.util.MoreColorUtil;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.utils.getTimer;
	
	public class PartyPanel extends Panel {
		 
		
		public var menuLayer:DisplayObjectContainer;
		
		public var memberPanels:Vector.<PlayerGameObjectListItem>;
		
		public var mouseOver_:Boolean;
		
		public var menu:PlayerMenu;
		
		public function PartyPanel(param1:GameSprite) {
			this.memberPanels = new Vector.<PlayerGameObjectListItem>(Party.NUM_MEMBERS,true);
			super(param1);
			this.memberPanels[0] = this.createPartyMemberPanel(0,0);
			this.memberPanels[1] = this.createPartyMemberPanel(100,0);
			this.memberPanels[2] = this.createPartyMemberPanel(0,32);
			this.memberPanels[3] = this.createPartyMemberPanel(100,32);
			this.memberPanels[4] = this.createPartyMemberPanel(0,64);
			this.memberPanels[5] = this.createPartyMemberPanel(100,64);
			addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
		}
		
		private function createPartyMemberPanel(param1:int, param2:int) : PlayerGameObjectListItem {
			var loc3:PlayerGameObjectListItem = null;
			loc3 = new PlayerGameObjectListItem(16777215,false,null);
			addChild(loc3);
			loc3.x = param1 - 5;
			loc3.y = param2 - 8;
			return loc3;
		}
		
		private function onAddedToStage(param1:Event) : void {
			var loc2:PlayerGameObjectListItem = null;
			for each(loc2 in this.memberPanels) {
				loc2.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
				loc2.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
				loc2.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
			}
		}
		
		private function onRemovedFromStage(param1:Event) : void {
			var loc2:PlayerGameObjectListItem = null;
			this.removeMenu();
			for each(loc2 in this.memberPanels) {
				loc2.removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
				loc2.removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
				loc2.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
			}
		}
		
		private function onMouseOver(param1:MouseEvent) : void {
			if(this.menu != null && this.menu.parent != null) {
				return;
			}
			var loc2:PlayerGameObjectListItem = param1.currentTarget as PlayerGameObjectListItem;
			var loc3:Player = loc2.go as Player;
			if(loc3 == null || loc3.texture_ == null) {
				return;
			}
			this.mouseOver_ = true;
		}
		
		private function onMouseOut(param1:MouseEvent) : void {
			this.mouseOver_ = false;
		}
		
		private function onMouseDown(param1:MouseEvent) : void {
			this.removeMenu();
			var loc2:PlayerGameObjectListItem = param1.currentTarget as PlayerGameObjectListItem;
			loc2.setEnabled(false);
			this.menu = new PlayerMenu();
			this.menu.init(gs_,loc2.go as Player);
			this.menuLayer.addChild(this.menu);
			this.menu.addEventListener(Event.REMOVED_FROM_STAGE,this.onMenuRemoved);
		}
		
		private function onMenuRemoved(param1:Event) : void {
			var loc2:GameObjectListItem = null;
			var loc3:PlayerGameObjectListItem = null;
			for each(loc2 in this.memberPanels) {
				loc3 = loc2 as PlayerGameObjectListItem;
				if(loc3) {
					loc3.setEnabled(true);
				}
			}
			param1.currentTarget.removeEventListener(Event.REMOVED_FROM_STAGE,this.onMenuRemoved);
		}
		
		private function removeMenu() : void {
			if(this.menu != null) {
				this.menu.remove();
				this.menu = null;
			}
		}
		
		override public function draw() : void {
			var loc4:GameObjectListItem = null;
			var loc5:Player = null;
			var loc6:ColorTransform = null;
			var loc7:Number = NaN;
			var loc8:int = 0;
			var loc1:Party = gs_.map.party_;
			if(loc1 == null) {
				for each(loc4 in this.memberPanels) {
					loc4.clear();
				}
				return;
			}
			var loc2:int = 0;
			var loc3:int = 0;
			while(loc3 < Party.NUM_MEMBERS) {
				if(this.mouseOver_ || this.menu != null && this.menu.parent != null) {
					loc5 = this.memberPanels[loc3].go as Player;
				} else {
					loc5 = loc1.members_[loc3];
				}
				if(loc5 != null && loc5.map_ == null) {
					loc5 = null;
				}
				loc6 = null;
				if(loc5 != null) {
					if(loc5.hp_ < loc5.maxHP_ * 0.2) {
						if(loc2 == 0) {
							loc2 = getTimer();
						}
						loc7 = int(Math.abs(Math.sin(loc2 / 200)) * 10) / 10;
						loc8 = 128;
						loc6 = new ColorTransform(1,1,1,1,loc7 * loc8,-loc7 * loc8,-loc7 * loc8);
					}
					if(!loc5.starred_) {
						if(loc6 != null) {
							loc6.concat(MoreColorUtil.darkCT);
						} else {
							loc6 = MoreColorUtil.darkCT;
						}
					}
				}
				this.memberPanels[loc3].draw(loc5,loc6);
				loc3++;
			}
		}
	}
}
