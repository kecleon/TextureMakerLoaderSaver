package kabam.rotmg.classes.view {
	import com.company.assembleegameclient.parameters.Parameters;
	import com.company.assembleegameclient.util.Currency;
	import com.company.util.AssetLibrary;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;

	import kabam.rotmg.assets.services.CharacterFactory;
	import kabam.rotmg.classes.model.CharacterSkin;
	import kabam.rotmg.classes.model.CharacterSkins;
	import kabam.rotmg.util.components.LegacyBuyButton;

	public class CharacterSkinListItemFactory {


		[Inject]
		public var characters:CharacterFactory;

		public function CharacterSkinListItemFactory() {
			super();
		}

		public function make(param1:CharacterSkins):Vector.<DisplayObject> {
			var loc2:Vector.<CharacterSkin> = null;
			var loc3:int = 0;
			loc2 = param1.getListedSkins();
			loc3 = loc2.length;
			var loc4:Vector.<DisplayObject> = new Vector.<DisplayObject>(loc3, true);
			var loc5:int = 0;
			while (loc5 < loc3) {
				loc4[loc5] = this.makeCharacterSkinTile(loc2[loc5]);
				loc5++;
			}
			return loc4;
		}

		private function makeCharacterSkinTile(param1:CharacterSkin):CharacterSkinListItem {
			var loc2:CharacterSkinListItem = new CharacterSkinListItem();
			loc2.setSkin(this.makeIcon(param1));
			loc2.setModel(param1);
			loc2.setLockIcon(AssetLibrary.getImageFromSet("lofiInterface2", 5));
			loc2.setBuyButton(this.makeBuyButton());
			return loc2;
		}

		private function makeBuyButton():LegacyBuyButton {
			return new LegacyBuyButton("", 16, 0, Currency.GOLD);
		}

		private function makeIcon(param1:CharacterSkin):Bitmap {
			var loc2:int = Parameters.skinTypes16.indexOf(param1.id) != -1 ? 50 : 100;
			var loc3:BitmapData = this.characters.makeIcon(param1.template, loc2);
			return new Bitmap(loc3);
		}
	}
}
