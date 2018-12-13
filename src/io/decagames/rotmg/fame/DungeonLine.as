package io.decagames.rotmg.fame {
	import com.company.assembleegameclient.objects.ObjectLibrary;
	import com.company.assembleegameclient.objects.TextureDataConcrete;
	import com.company.assembleegameclient.util.TextureRedrawer;

	import flash.display.Bitmap;
	import flash.display.BitmapData;

	public class DungeonLine extends StatsLine {


		private var dungeonTextureName:String;

		private var dungeonBitmap:Bitmap;

		public function DungeonLine(param1:String, param2:String, param3:String) {
			this.dungeonTextureName = param2;
			super(param1, param3, "", StatsLine.TYPE_STAT);
		}

		override protected function setLabelsPosition():void {
			var loc2:BitmapData = null;
			var loc1:TextureDataConcrete = ObjectLibrary.dungeonToPortalTextureData_[this.dungeonTextureName];
			if (loc1) {
				loc2 = loc1.getTexture();
				loc2 = TextureRedrawer.redraw(loc2, 40, true, 0, false);
				this.dungeonBitmap = new Bitmap(loc2);
				this.dungeonBitmap.x = -Math.round(loc2.width / 2) + 13;
				this.dungeonBitmap.y = -Math.round(loc2.height / 2) + 11;
				addChild(this.dungeonBitmap);
			}
			label.y = 4;
			label.x = 24;
			lineHeight = 25;
			if (fameValue) {
				fameValue.y = 4;
			}
			if (lock) {
				lock.y = -6;
			}
		}

		override public function clean():void {
			super.clean();
			if (this.dungeonBitmap) {
				this.dungeonBitmap.bitmapData.dispose();
			}
		}
	}
}
