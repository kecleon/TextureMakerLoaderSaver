package io.decagames.rotmg.pets.data.skin {
	import com.company.assembleegameclient.objects.ObjectLibrary;
	import com.company.assembleegameclient.util.AnimatedChar;
	import com.company.assembleegameclient.util.AnimatedChars;
	import com.company.assembleegameclient.util.MaskedImage;
	import com.company.assembleegameclient.util.TextureRedrawer;
	import com.company.assembleegameclient.util.redrawers.GlowRedrawer;

	import flash.display.Bitmap;
	import flash.display.BitmapData;

	public class PetSkinRenderer {


		protected var _skinType:int;

		protected var skin:AnimatedChar;

		public function PetSkinRenderer() {
			super();
		}

		public function getSkinBitmap():Bitmap {
			this.makeSkin();
			if (this.skin == null) {
				return null;
			}
			var loc1:MaskedImage = this.skin.imageFromAngle(0, AnimatedChar.STAND, 0);
			var loc2:int = this.skin.getHeight() == 16 ? 40 : 80;
			var loc3:BitmapData = TextureRedrawer.resize(loc1.image_, loc1.mask_, loc2, true, 0, 0);
			loc3 = GlowRedrawer.outlineGlow(loc3, 0);
			return new Bitmap(loc3);
		}

		protected function makeSkin():void {
			var loc1:XML = ObjectLibrary.getXMLfromId(ObjectLibrary.getIdFromType(this._skinType));
			if (loc1 == null) {
				return;
			}
			var loc2:String = loc1.AnimatedTexture.File;
			var loc3:int = loc1.AnimatedTexture.Index;
			this.skin = AnimatedChars.getAnimatedChar(loc2, loc3);
		}

		public function getSkinMaskedImage():MaskedImage {
			this.makeSkin();
			return !!this.skin ? this.skin.imageFromAngle(0, AnimatedChar.STAND, 0) : null;
		}
	}
}
