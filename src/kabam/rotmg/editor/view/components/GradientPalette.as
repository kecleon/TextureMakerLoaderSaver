package kabam.rotmg.editor.view.components {
	import com.company.color.RGB;

	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class GradientPalette extends Sprite {

		public static const BOX_SIZE:int = 12;

		public static const COLORS1:Vector.<Vector.<uint>> = new <Vector.<uint>>[new <uint>[0, 2500134, 5066061, 7566195, 10066329, 12566463, 15132390, 16777215], new <uint>[7483, 15480, 23733, 30699, 2397439, 6534143, 11786751, 14413311], new <uint>[15156, 21578, 30826, 38019, 47267, 777926, 6553581, 12255223], new <uint>[15121, 21528, 30754, 37930, 47156, 777799, 6553487, 12189619], new <uint>[2636544, 3822592, 5404672, 6657024, 8304640, 10214923, 13565795, 15269816], new <uint>[3881216, 5525760, 7894016, 9735936, 12104192, 14604043, 16775779, 16776632], new <uint>[3877376, 5520384, 7886336, 9726464, 12092416, 14590475, 16765795, 16772024], new <uint>[3871232, 5511424, 7873536, 9710592, 12072704, 14567947, 16749155, 16764344]];

		public static const COLORS2:Vector.<Vector.<uint>> = new <Vector.<uint>>[new <uint>[3866624, 7864320, 11862016, 14556445, 16730698, 16745861, 16757683, 16767963], new <uint>[5177373, 7864384, 11862125, 14876782, 16730764, 16745905, 16757711, 16767976], new <uint>[5111887, 7798904, 11154347, 13847252, 14642912, 14656736, 15583981, 16767999], new <uint>[2228303, 3407992, 6763435, 8735444, 10448608, 12494048, 14273261, 15391743], new <uint>[65615, 131192, 3486635, 4999892, 7368416, 10855648, 13355757, 14474239], new <uint>[4413806, 5006200, 5139591, 6258588, 6918840, 7710420, 8368350, 10010595], new <uint>[4484675, 5011532, 5211982, 6331487, 6994025, 7722101, 8445567, 10085272], new <uint>[7223327, 7879971, 8863005, 10241571, 12080942, 13919027, 14581590, 14913903]];


		public function GradientPalette() {
			super();
			this.addBoxes(COLORS1, 0);
			this.addBoxes(COLORS2, BOX_SIZE * 8);
			addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
		}

		public function addBoxes(param1:Vector.<Vector.<uint>>, param2:int):void {
			var loc3:int = 0;
			var loc4:int = 0;
			var loc5:RGB = null;
			var loc6:PaletteBox = null;
			loc3 = 0;
			while (loc3 < param1.length) {
				loc4 = 0;
				while (loc4 < param1[loc3].length) {
					loc5 = RGB.fromColor(param1[loc3][loc4]);
					loc6 = new PaletteBox(BOX_SIZE, loc5.toHSV(), true);
					loc6.x = param2 + loc4 * BOX_SIZE;
					loc6.y = loc3 * BOX_SIZE;
					addChild(loc6);
					loc4++;
				}
				loc3++;
			}
		}

		public function onMouseDown(param1:MouseEvent):void {
			var loc2:PaletteBox = param1.target as PaletteBox;
			if (loc2 != null) {
				dispatchEvent(new ColorEvent(loc2.hsv_));
			}
			stage.addEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
		}

		private function onMouseMove(param1:MouseEvent):void {
			var loc2:PaletteBox = param1.target as PaletteBox;
			if (loc2 != null) {
				dispatchEvent(new ColorEvent(loc2.hsv_));
			}
		}

		private function onMouseUp(param1:MouseEvent):void {
			var loc2:PaletteBox = param1.target as PaletteBox;
			if (loc2 != null) {
				dispatchEvent(new ColorEvent(loc2.hsv_));
			}
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
		}
	}
}
