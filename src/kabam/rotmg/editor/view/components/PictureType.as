package kabam.rotmg.editor.view.components {
	public class PictureType {

		public static const INVALID:int = 0;

		public static const CHARACTER:int = 1;

		public static const ITEM:int = 2;

		public static const ENVIRONMENT:int = 3;

		public static const PROJECTILE:int = 4;

		public static const TEXTILE:int = 5;

		public static const INTERFACE:int = 6;

		public static const MISCELLANEOUS:int = 7;

		public static const TYPES:Vector.<PictureType> = new <PictureType>[new PictureType("Any Type", ""), new PictureType("Character", "(e.g. humans, orcs, slimes, etc.)"), new PictureType("Item", "(e.g. swords, armor, rings, etc.)"), new PictureType("Environment", "(e.g. trees, rocks, portals, etc.)"), new PictureType("Projectile", "(e.g. arrows, magic bolts, etc.)"), new PictureType("Textile", "(clothing for players)"), new PictureType("Interface", "(e.g. icons, etc.)"), new PictureType("Miscellaneous", "(anything else)")];


		public var name_:String;

		public var examples_:String;

		public function PictureType(param1:String, param2:String) {
			super();
			this.name_ = param1;
			this.examples_ = param2;
		}

		public static function nameToType(param1:String):int {
			var loc2:int = 0;
			while (loc2 < TYPES.length) {
				if (TYPES[loc2].name_ == param1) {
					return loc2;
				}
				loc2++;
			}
			return INVALID;
		}
	}
}
