package com.company.assembleegameclient.mapeditor {
	import com.company.util.IntPoint;

	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;

	public class EditTileProperties extends Sprite {


		public var tiles_:Vector.<IntPoint>;

		private var darkBox_:Shape;

		private var frame_:EditTilePropertiesFrame;

		public function EditTileProperties(param1:Vector.<IntPoint>, param2:String) {
			super();
			this.tiles_ = param1;
			this.darkBox_ = new Shape();
			var loc3:Graphics = this.darkBox_.graphics;
			loc3.clear();
			loc3.beginFill(0, 0.8);
			loc3.drawRect(0, 0, 800, 600);
			loc3.endFill();
			addChild(this.darkBox_);
			this.frame_ = new EditTilePropertiesFrame(param2);
			this.frame_.addEventListener(Event.COMPLETE, this.onComplete);
			this.frame_.addEventListener(Event.CANCEL, this.onCancel);
			addChild(this.frame_);
		}

		public function getObjectName():String {
			if (this.frame_.objectName_.text() == "") {
				return null;
			}
			return this.frame_.objectName_.text();
		}

		public function onComplete(param1:Event):void {
			dispatchEvent(new Event(Event.COMPLETE));
			parent.removeChild(this);
		}

		public function onCancel(param1:Event):void {
			parent.removeChild(this);
		}
	}
}
