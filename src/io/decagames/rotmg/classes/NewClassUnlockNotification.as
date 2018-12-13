 
package io.decagames.rotmg.classes {
	import com.company.assembleegameclient.appengine.SavedCharacter;
	import com.company.assembleegameclient.objects.ObjectLibrary;
	import com.company.assembleegameclient.util.AnimatedChar;
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Expo;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flashx.textLayout.formats.TextAlign;
	import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
	import io.decagames.rotmg.ui.labels.UILabel;
	import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
	import io.decagames.rotmg.ui.texture.TextureParser;
	
	public class NewClassUnlockNotification extends Sprite {
		 
		
		private const WIDTH:int = 192;
		
		private const HEIGHT:int = 192;
		
		private const NEW_CLASS_UNLOCKED:String = "New Class Unlocked!";
		
		private var _contentContainer:Sprite;
		
		private var _whiteSplash:Shape;
		
		private var _newClass:Bitmap;
		
		private var _objectTypes:Array;
		
		private var _timeLineMax:TimelineMax;
		
		private var _characterName:UILabel;
		
		public function NewClassUnlockNotification() {
			super();
			this.init();
		}
		
		public function playNotification(param1:Array = null) : void {
			this._objectTypes = param1;
			this.createCharacter();
			this.playAnimation();
		}
		
		private function playAnimation() : void {
			if(!this._timeLineMax) {
				this._timeLineMax = new TimelineMax();
				this._timeLineMax.add(TweenMax.to(this._whiteSplash,0.1,{
					"autoAlpha":1,
					"transformAroundCenter":{
						"scaleX":1,
						"scaleY":1
					},
					"ease":Bounce.easeOut
				}));
				this._timeLineMax.add(TweenMax.to(this._whiteSplash,0.1,{
					"alpha":0.4,
					"tint":0,
					"ease":Expo.easeOut
				}));
				this._timeLineMax.add(TweenMax.to(this._contentContainer,0.2,{
					"autoAlpha":1,
					"transformAroundCenter":{
						"scaleX":1,
						"scaleY":1
					},
					"ease":Bounce.easeOut
				}));
				this._timeLineMax.add(TweenMax.to(this._contentContainer,2,{"onComplete":this.resetAnimation}));
			} else {
				this._timeLineMax.play(0);
			}
		}
		
		private function resetAnimation() : void {
			if(this._objectTypes.length > 0) {
				this.createCharacter();
				this.playAnimation();
			} else {
				this._timeLineMax.reverse();
			}
		}
		
		private function createCharacter() : void {
			var loc3:XML = null;
			var loc5:int = 0;
			if(this._newClass) {
				this._contentContainer.removeChild(this._newClass);
				this._newClass.bitmapData.dispose();
				this._newClass = null;
			}
			var loc1:int = ObjectLibrary.playerChars_.length;
			var loc2:int = this._objectTypes.shift();
			var loc4:int = 0;
			while(loc4 < loc1) {
				loc3 = ObjectLibrary.playerChars_[loc4];
				loc5 = int(loc3.@type);
				if(loc2 == loc5) {
					this._newClass = new Bitmap(this.getImageBitmapData(loc3));
					break;
				}
				loc4++;
			}
			if(this._newClass) {
				this._newClass.x = (this.WIDTH - this._newClass.width) / 2;
				this._newClass.y = (this.HEIGHT - this._newClass.height) / 2 - 20;
				this._contentContainer.addChild(this._newClass);
				if(!this._characterName) {
					this.createCharacterName();
				}
				this._characterName.text = loc3.@id;
				this._characterName.x = (this.WIDTH - this._characterName.width) / 2;
				this._characterName.y = (this.HEIGHT - this._characterName.height) / 2 + 20;
			}
		}
		
		private function createCharacterName() : void {
			this._characterName = new UILabel();
			DefaultLabelFormat.notificationLabel(this._characterName,14,16777215,TextAlign.CENTER,true);
			this._contentContainer.addChild(this._characterName);
		}
		
		private function createCharacterBackground() : void {
			var loc1:Shape = null;
			var loc2:SliceScalingBitmap = null;
			loc1 = new Shape();
			loc1.graphics.beginFill(5526612);
			loc1.graphics.drawRect(0,0,105,105);
			loc1.x = (this.WIDTH - loc1.width) / 2;
			loc1.y = (this.HEIGHT - loc1.height) / 2 - 6;
			this._contentContainer.addChild(loc1);
			loc2 = TextureParser.instance.getSliceScalingBitmap("UI","popup_background_decoration");
			loc2.width = 105;
			loc2.height = 105;
			loc2.x = loc1.x;
			loc2.y = loc1.y;
			this._contentContainer.addChild(loc2);
		}
		
		private function getImageBitmapData(param1:XML) : BitmapData {
			var loc2:BitmapData = SavedCharacter.getImage(null,param1,AnimatedChar.DOWN,AnimatedChar.STAND,0,true,false);
			return loc2;
		}
		
		private function init() : void {
			this.createWhiteSplash();
			this.createContainers();
			this.createCharacterBackground();
			this.createClassUnlockLabel();
		}
		
		private function createClassUnlockLabel() : void {
			var loc1:UILabel = null;
			loc1 = new UILabel();
			loc1.text = this.NEW_CLASS_UNLOCKED;
			DefaultLabelFormat.notificationLabel(loc1,18,65280,TextAlign.CENTER,true);
			loc1.width = this.WIDTH;
			loc1.x = (this.WIDTH - loc1.width) / 2;
			loc1.y = this.HEIGHT - loc1.height - 12;
			this._contentContainer.addChild(loc1);
		}
		
		private function createWhiteSplash() : void {
			this._whiteSplash = new Shape();
			var loc1:Graphics = this._whiteSplash.graphics;
			loc1.beginFill(16777215);
			loc1.drawRect(0,0,this.WIDTH,this.HEIGHT);
			this._whiteSplash.x = this._whiteSplash.width / 2;
			this._whiteSplash.y = this._whiteSplash.height / 2;
			this._whiteSplash.alpha = 0;
			this._whiteSplash.visible = false;
			this._whiteSplash.scaleX = this._whiteSplash.scaleY = 0;
			addChild(this._whiteSplash);
		}
		
		private function createContainers() : void {
			this._contentContainer = new Sprite();
			this._contentContainer.alpha = 0;
			this._contentContainer.visible = false;
			addChild(this._contentContainer);
		}
	}
}
