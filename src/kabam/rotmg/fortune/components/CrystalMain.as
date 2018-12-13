package kabam.rotmg.fortune.components {
	import com.company.assembleegameclient.util.TextureRedrawer;
	import com.company.util.AssetLibrary;
	import com.company.util.MoreColorUtil;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.ColorMatrixFilter;

	public class CrystalMain extends Sprite {

		public static const ANIMATION_STAGE_PULSE:int = 0;

		public static const ANIMATION_STAGE_BUZZING:int = 1;

		public static const ANIMATION_STAGE_INNERROTATION:int = 2;

		public static const ANIMATION_STAGE_FLASH:int = 3;

		public static const ANIMATION_STAGE_WAITING:int = 4;

		public static const GLOW_COLOR:int = 0;


		public var bigCrystal:Bitmap;

		private var crystalFrames:Vector.<Bitmap>;

		private const STARTING_FRAME_INDEX:Number = 176;

		private var animationDuration_:Number = 210;

		private var startFrame_:Number = 0;

		private var numFramesofLoop_:Number;

		public var size_:int = 150;

		public function CrystalMain() {
			var loc1:BitmapData = null;
			var loc2:uint = 0;
			var loc3:Bitmap = null;
			super();
			this.crystalFrames = new Vector.<Bitmap>();
			loc2 = 0;
			while (loc2 < 3) {
				loc1 = AssetLibrary.getImageFromSet("lofiCharBig", this.STARTING_FRAME_INDEX + loc2);
				loc1 = TextureRedrawer.redraw(loc1, this.size_, true, GLOW_COLOR, false);
				loc3 = new Bitmap(loc1);
				loc3.filters = [new ColorMatrixFilter(MoreColorUtil.greyscaleFilterMatrix)];
				this.crystalFrames.push(loc3);
				loc2++;
			}
			loc2 = 0;
			while (loc2 < 3) {
				loc1 = AssetLibrary.getImageFromSet("lofiCharBig", this.STARTING_FRAME_INDEX + 16 + loc2);
				loc1 = TextureRedrawer.redraw(loc1, this.size_, true, GLOW_COLOR, false);
				this.crystalFrames.push(new Bitmap(loc1));
				loc2++;
			}
			loc2 = 0;
			while (loc2 < 7) {
				loc1 = AssetLibrary.getImageFromSet("lofiCharBig", this.STARTING_FRAME_INDEX + 32 + loc2);
				loc1 = TextureRedrawer.redraw(loc1, this.size_, true, GLOW_COLOR, false);
				this.crystalFrames.push(new Bitmap(loc1));
				loc2++;
			}
			loc2 = 0;
			while (loc2 < 7) {
				loc1 = AssetLibrary.getImageFromSet("lofiCharBig", this.STARTING_FRAME_INDEX + 48 + loc2);
				loc1 = TextureRedrawer.redraw(loc1, this.size_, true, GLOW_COLOR, false);
				this.crystalFrames.push(new Bitmap(loc1));
				loc2++;
			}
			loc2 = 0;
			while (loc2 < 5) {
				loc1 = AssetLibrary.getImageFromSet("lofiCharBig", this.STARTING_FRAME_INDEX + 64 + loc2);
				loc1 = TextureRedrawer.redraw(loc1, this.size_, true, GLOW_COLOR, false);
				this.crystalFrames.push(new Bitmap(loc1));
				loc2++;
			}
			loc2 = 0;
			while (loc2 < 8) {
				loc1 = AssetLibrary.getImageFromSet("lofiCharBig", this.STARTING_FRAME_INDEX + 80 + loc2);
				loc1 = TextureRedrawer.redraw(loc1, this.size_, true, GLOW_COLOR, false);
				this.crystalFrames.push(new Bitmap(loc1));
				loc2++;
			}
			this.reset();
			loc1 = AssetLibrary.getImageFromSet("lofiCharBig", 32);
			loc1 = TextureRedrawer.redraw(loc1, this.size_, true, GLOW_COLOR, false);
			this.bigCrystal = new Bitmap(loc1);
			addChild(this.bigCrystal);
			addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
		}

		public function reset():void {
			this.setAnimationStage(ANIMATION_STAGE_FLASH);
		}

		public function setXPos(param1:Number):void {
			this.x = param1 - this.width / 2;
		}

		public function setYPos(param1:Number):void {
			this.y = param1 - this.height / 2;
		}

		public function getCenterX():Number {
			return this.x + this.width / 2;
		}

		public function getCenterY():Number {
			return this.y + this.height / 2;
		}

		public function drawAnimation(param1:int, param2:int):void {
			removeChild(this.bigCrystal);
			this.bigCrystal = this.crystalFrames[this.startFrame_ + uint(param1 / this.animationDuration_ % this.numFramesofLoop_)];
			addChild(this.bigCrystal);
		}

		public function setAnimationDuration(param1:Number):void {
			this.animationDuration_ = param1;
		}

		public function setAnimation(param1:Number, param2:Number):void {
			this.startFrame_ = param1;
			this.numFramesofLoop_ = param2;
		}

		public function setAnimationStage(param1:int):void {
			switch (param1) {
				case ANIMATION_STAGE_PULSE:
					this.setAnimation(0, 0);
					this.setAnimationDuration(250);
					break;
				case ANIMATION_STAGE_BUZZING:
					this.setAnimation(3, 3);
					this.setAnimationDuration(10);
					break;
				case ANIMATION_STAGE_INNERROTATION:
					this.setAnimation(6, 7);
					this.setAnimationDuration(80);
					break;
				case ANIMATION_STAGE_FLASH:
					this.setAnimation(13, 7);
					this.setAnimationDuration(210);
					break;
				case ANIMATION_STAGE_WAITING:
					this.setAnimation(20, 13);
					this.setAnimationDuration(120);
					break;
				default:
					this.setAnimation(13, 7);
			}
		}

		private function onRemovedFromStage(param1:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
			this.bigCrystal = null;
			this.crystalFrames = null;
		}
	}
}
