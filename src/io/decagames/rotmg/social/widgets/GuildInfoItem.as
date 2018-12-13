package io.decagames.rotmg.social.widgets {
	import com.company.assembleegameclient.util.TextureRedrawer;
	import com.company.util.AssetLibrary;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;

	import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
	import io.decagames.rotmg.ui.labels.UILabel;

	public class GuildInfoItem extends BaseInfoItem {


		private var _gName:String;

		private var _gFame:int;

		public function GuildInfoItem(param1:String, param2:int) {
			super(332, 70);
			this._gName = param1;
			this._gFame = param2;
			this.init();
		}

		private function init():void {
			this.createGuildName();
			this.createGuildFame();
		}

		private function createGuildName():void {
			var loc1:UILabel = null;
			loc1 = new UILabel();
			loc1.text = this._gName;
			DefaultLabelFormat.guildInfoLabel(loc1, 24);
			loc1.x = (_width - loc1.width) / 2;
			loc1.y = 12;
			addChild(loc1);
		}

		private function createGuildFame():void {
			var loc1:Sprite = null;
			var loc3:Bitmap = null;
			var loc4:UILabel = null;
			loc1 = new Sprite();
			addChild(loc1);
			var loc2:BitmapData = AssetLibrary.getImageFromSet("lofiObj3", 226);
			loc2 = TextureRedrawer.redraw(loc2, 40, true, 0);
			loc3 = new Bitmap(loc2);
			loc3.y = -6;
			loc1.addChild(loc3);
			loc4 = new UILabel();
			loc4.text = this._gFame.toString();
			DefaultLabelFormat.guildInfoLabel(loc4);
			loc4.x = loc3.width;
			loc4.y = 5;
			loc1.addChild(loc4);
			loc1.x = (_width - loc1.width) / 2;
			loc1.y = 36;
		}
	}
}
