 
package com.company.assembleegameclient.screens.charrects {
	import com.company.assembleegameclient.appengine.SavedCharacter;
	import com.company.assembleegameclient.objects.ObjectLibrary;
	import com.company.assembleegameclient.util.AnimatedChar;
	import com.company.assembleegameclient.util.FameUtil;
	import com.company.util.BitmapUtil;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import kabam.rotmg.core.model.PlayerModel;
	import kabam.rotmg.text.model.TextKey;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;
	
	public class CreateNewCharacterRect extends CharacterRect {
		 
		
		private var bitmap_:Bitmap;
		
		public function CreateNewCharacterRect(param1:PlayerModel) {
			var loc2:int = 0;
			super();
			super.className = new LineBuilder().setParams(TextKey.CREATE_NEW_CHARACTER_RECT_NEW_CHARACTER);
			super.color = 5526612;
			super.overColor = 7829367;
			super.init();
			this.makeBitmap();
			if(param1.getNumStars() != FameUtil.maxStars()) {
				loc2 = FameUtil.maxStars() - param1.getNumStars();
				super.makeTaglineIcon();
				super.makeTaglineText(new LineBuilder().setParams(TextKey.CREATE_NEW_CHARACTER_RECT_TAGLINE,{"remainingStars":loc2}));
				taglineText.x = taglineText.x + taglineIcon.width;
			}
		}
		
		public function makeBitmap() : void {
			var loc1:XML = ObjectLibrary.playerChars_[int(ObjectLibrary.playerChars_.length * Math.random())];
			var loc2:BitmapData = SavedCharacter.getImage(null,loc1,AnimatedChar.RIGHT,AnimatedChar.STAND,0,false,false);
			loc2 = BitmapUtil.cropToBitmapData(loc2,6,6,loc2.width - 12,loc2.height - 6);
			this.bitmap_ = new Bitmap();
			this.bitmap_.bitmapData = loc2;
			this.bitmap_.x = CharacterRectConstants.ICON_POS_X;
			this.bitmap_.y = CharacterRectConstants.ICON_POS_Y;
			selectContainer.addChild(this.bitmap_);
		}
	}
}
