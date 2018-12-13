package kabam.rotmg.editor.view.components.preview {
	import com.company.assembleegameclient.util.AnimatedChar;
	import com.company.assembleegameclient.util.AnimatedChars;
	import com.company.assembleegameclient.util.MaskedImage;
	import com.company.assembleegameclient.util.TextureRedrawer;
	import com.company.assembleegameclient.util.redrawers.GlowRedrawer;
	import com.company.util.ImageSet;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.filters.ColorMatrixFilter;

	public class TextilePreview extends Preview {

		private static var textilepreviewiconsEmbed_:Class = TextilePreview_textilepreviewiconsEmbed_;

		private static var icons_:ImageSet = function ():ImageSet {
			var loc1:* = new ImageSet();
			loc1.addFromBitmapData(new textilepreviewiconsEmbed_().bitmapData, 16, 16);
			return loc1;
		}();

		private static const INDEXES:Vector.<int> = new <int>[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];


		private var useTex1_:Boolean = true;

		private var index_:int = 0;

		private var dir_:int = 0;

		private var nextClassIndex_:Sprite;

		private var prevClassIndex_:Sprite;

		private var upDir_:Sprite;

		private var rightDir_:Sprite;

		private var downDir_:Sprite;

		private var leftDir_:Sprite;

		private var clothingTex_:Sprite;

		private var accessoryTex_:Sprite;

		public function TextilePreview(param1:int, param2:int) {
			var w:int = param1;
			var h:int = param2;
			super(w, h);
			this.nextClassIndex_ = createIcon(new Bitmap(icons_.images_[1]), this.onNextClassDown);
			this.nextClassIndex_.x = w_ - this.nextClassIndex_.width - 5;
			this.nextClassIndex_.y = h_ - this.nextClassIndex_.height - 5;
			this.prevClassIndex_ = createIcon(new Bitmap(icons_.images_[0]), this.onPrevClassDown);
			this.prevClassIndex_.x = this.nextClassIndex_.x - this.prevClassIndex_.width - 5;
			this.prevClassIndex_.y = h_ - this.prevClassIndex_.height - 5;
			this.rightDir_ = createIcon(new Bitmap(icons_.images_[3]), function ():void {
				dir_ = AnimatedChar.RIGHT;
			});
			this.rightDir_.x = w_ - this.rightDir_.width - 100;
			this.rightDir_.y = h_ - this.rightDir_.height - 5;
			this.downDir_ = createIcon(new Bitmap(icons_.images_[4]), function ():void {
				dir_ = AnimatedChar.DOWN;
			});
			this.downDir_.x = this.rightDir_.x - this.downDir_.width - 5;
			this.downDir_.y = h_ - this.downDir_.height - 5;
			this.upDir_ = createIcon(new Bitmap(icons_.images_[2]), function ():void {
				dir_ = AnimatedChar.UP;
			});
			this.upDir_.x = this.downDir_.x;
			this.upDir_.y = this.downDir_.y - this.upDir_.height - 5;
			this.leftDir_ = createIcon(new Bitmap(icons_.images_[5]), function ():void {
				dir_ = AnimatedChar.LEFT;
			});
			this.leftDir_.x = this.downDir_.x - this.leftDir_.width - 5;
			this.leftDir_.y = h_ - this.leftDir_.height - 5;
			this.clothingTex_ = createIcon(new Bitmap(icons_.images_[6]), function ():void {
				useTex1_ = true;
			});
			this.clothingTex_.x = 5;
			this.clothingTex_.y = h_ - this.clothingTex_.height - 5;
			this.accessoryTex_ = createIcon(new Bitmap(icons_.images_[7]), function ():void {
				useTex1_ = false;
			});
			this.accessoryTex_.x = this.clothingTex_.x + this.clothingTex_.width + 5;
			this.accessoryTex_.y = h_ - this.accessoryTex_.height - 5;
		}

		private function onNextClassDown():void {
			if (this.index_ == INDEXES.length - 1) {
				return;
			}
			this.index_++;
		}

		private function onPrevClassDown():void {
			if (this.index_ == 0) {
				return;
			}
			this.index_--;
		}

		override public function redraw():void {
			super.redraw();
			this.nextClassIndex_.filters = this.index_ == INDEXES.length - 1 ? [new ColorMatrixFilter(GREY_MATRIX)] : [];
			this.prevClassIndex_.filters = this.index_ == 0 ? [new ColorMatrixFilter(GREY_MATRIX)] : [];
			this.rightDir_.filters = this.dir_ == AnimatedChar.RIGHT ? [new ColorMatrixFilter(GREY_MATRIX)] : [];
			this.downDir_.filters = this.dir_ == AnimatedChar.DOWN ? [new ColorMatrixFilter(GREY_MATRIX)] : [];
			this.upDir_.filters = this.dir_ == AnimatedChar.UP ? [new ColorMatrixFilter(GREY_MATRIX)] : [];
			this.leftDir_.filters = this.dir_ == AnimatedChar.LEFT ? [new ColorMatrixFilter(GREY_MATRIX)] : [];
			this.clothingTex_.filters = !!this.useTex1_ ? [new ColorMatrixFilter(GREY_MATRIX)] : [];
			this.accessoryTex_.filters = !this.useTex1_ ? [new ColorMatrixFilter(GREY_MATRIX)] : [];
			var loc1:AnimatedChar = AnimatedChars.getAnimatedChar("players", INDEXES[this.index_]);
			var loc2:MaskedImage = loc1.imageFromDir(this.dir_, AnimatedChar.STAND, 0);
			TextureRedrawer.sharedTexture_ = origBitmapData_;
			var loc3:int = origBitmapData_ != null ? int(4294967295) : 0;
			var loc4:BitmapData = TextureRedrawer.resize(loc2.image_, loc2.mask_, size_, true, !!this.useTex1_ ? int(loc3) : 0, !!this.useTex1_ ? 0 : int(loc3));
			loc4 = GlowRedrawer.outlineGlow(loc4, 0);
			bitmap_.bitmapData = loc4;
		}
	}
}
