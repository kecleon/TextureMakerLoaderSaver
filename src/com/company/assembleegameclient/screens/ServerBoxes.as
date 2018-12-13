 
package com.company.assembleegameclient.screens {
	import com.company.assembleegameclient.parameters.Parameters;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import kabam.rotmg.servers.api.Server;
	
	public class ServerBoxes extends Sprite {
		 
		
		private var boxes_:Vector.<ServerBox>;
		
		public function ServerBoxes(param1:Vector.<Server>) {
			var loc2:ServerBox = null;
			var loc3:int = 0;
			var loc4:Server = null;
			this.boxes_ = new Vector.<ServerBox>();
			super();
			loc2 = new ServerBox(null);
			loc2.setSelected(true);
			loc2.x = ServerBox.WIDTH / 2 + 2;
			loc2.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
			addChild(loc2);
			this.boxes_.push(loc2);
			loc3 = 2;
			for each(loc4 in param1) {
				loc2 = new ServerBox(loc4);
				if(loc4.name == Parameters.data_.preferredServer) {
					this.setSelected(loc2);
				}
				loc2.x = loc3 % 2 * (ServerBox.WIDTH + 4);
				loc2.y = int(loc3 / 2) * (ServerBox.HEIGHT + 4);
				loc2.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
				addChild(loc2);
				this.boxes_.push(loc2);
				loc3++;
			}
		}
		
		private function onMouseDown(param1:MouseEvent) : void {
			var loc2:ServerBox = param1.currentTarget as ServerBox;
			if(loc2 == null) {
				return;
			}
			this.setSelected(loc2);
			Parameters.data_.preferredServer = loc2.value_;
			Parameters.save();
		}
		
		private function setSelected(param1:ServerBox) : void {
			var loc2:ServerBox = null;
			for each(loc2 in this.boxes_) {
				loc2.setSelected(false);
			}
			param1.setSelected(true);
		}
	}
}
