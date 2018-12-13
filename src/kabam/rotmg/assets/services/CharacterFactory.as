package kabam.rotmg.assets.services {
	import com.company.assembleegameclient.util.AnimatedChar;
	import com.company.assembleegameclient.util.AnimatedChars;
	import com.company.assembleegameclient.util.MaskedImage;
	import com.company.assembleegameclient.util.TextureRedrawer;
	import com.company.assembleegameclient.util.redrawers.GlowRedrawer;
	import com.company.util.BitmapUtil;

	import flash.display.BitmapData;

	import kabam.rotmg.assets.model.Animation;
	import kabam.rotmg.assets.model.CharacterTemplate;

	public class CharacterFactory {


		private var texture1:int;

		private var texture2:int;

		private var size:int;

		public function CharacterFactory() {
			super();
		}

		public function makeCharacter(param1:CharacterTemplate):AnimatedChar {
			return AnimatedChars.getAnimatedChar(param1.file, param1.index);
		}

		public function makeIcon(param1:CharacterTemplate, param2:int = 100, param3:int = 0, param4:int = 0, param5:Boolean = false):BitmapData {
			this.texture1 = param3;
			this.texture2 = param4;
			this.size = param2;
			var loc6:AnimatedChar = this.makeCharacter(param1);
			var loc7:BitmapData = this.makeFrame(loc6, AnimatedChar.STAND, 0);
			loc7 = GlowRedrawer.outlineGlow(loc7, !!param5 ? uint(16711680) : uint(0));
			loc7 = BitmapUtil.cropToBitmapData(loc7, 6, 6, loc7.width - 12, loc7.height - 6);
			return loc7;
		}

		public function makeWalkingIcon(param1:CharacterTemplate, param2:int = 100, param3:int = 0, param4:int = 0):Animation {
			this.texture1 = param3;
			this.texture2 = param4;
			this.size = param2;
			var loc5:AnimatedChar = this.makeCharacter(param1);
			var loc6:BitmapData = this.makeFrame(loc5, AnimatedChar.WALK, 0.5);
			loc6 = GlowRedrawer.outlineGlow(loc6, 0);
			var loc7:BitmapData = this.makeFrame(loc5, AnimatedChar.WALK, 0);
			loc7 = GlowRedrawer.outlineGlow(loc7, 0);
			var loc8:Animation = new Animation();
			loc8.setFrames(loc6, loc7);
			return loc8;
		}

		private function makeFrame(param1:AnimatedChar, param2:int, param3:Number):BitmapData {
			var loc4:MaskedImage = param1.imageFromDir(AnimatedChar.RIGHT, param2, param3);
			return TextureRedrawer.resize(loc4.image_, loc4.mask_, this.size, false, this.texture1, this.texture2);
		}
	}
}
