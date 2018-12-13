package com.company.assembleegameclient.ui {
	import com.company.assembleegameclient.objects.Player;
	import com.company.assembleegameclient.util.TextureRedrawer;
	import com.company.util.AssetLibrary;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class BoostPanelButton extends Sprite {

		public static const IMAGE_SET_NAME:String = "lofiInterfaceBig";

		public static const IMAGE_ID:int = 22;


		private var boostPanel:BoostPanel;

		private var player:Player;

		public function BoostPanelButton(param1:Player) {
			super();
			this.player = param1;
			var loc2:BitmapData = AssetLibrary.getImageFromSet(IMAGE_SET_NAME, IMAGE_ID);
			var loc3:BitmapData = TextureRedrawer.redraw(loc2, 20, true, 0);
			var loc4:Bitmap = new Bitmap(loc3);
			loc4.x = -7;
			loc4.y = -10;
			addChild(loc4);
			addEventListener(MouseEvent.MOUSE_OVER, this.onButtonOver);
			addEventListener(MouseEvent.MOUSE_OUT, this.onButtonOut);
		}

		private function onButtonOver(param1:Event):void {
			addChild(this.boostPanel = new BoostPanel(this.player));
			this.boostPanel.resized.add(this.positionBoostPanel);
			this.positionBoostPanel();
		}

		private function positionBoostPanel():void {
			this.boostPanel.x = -this.boostPanel.width;
			this.boostPanel.y = -this.boostPanel.height;
		}

		private function onButtonOut(param1:Event):void {
			if (this.boostPanel) {
				removeChild(this.boostPanel);
			}
		}
	}
}
