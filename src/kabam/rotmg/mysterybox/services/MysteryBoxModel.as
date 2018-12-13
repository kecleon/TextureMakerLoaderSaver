package kabam.rotmg.mysterybox.services {
	import kabam.rotmg.mysterybox.model.MysteryBoxInfo;

	import org.osflash.signals.Signal;

	public class MysteryBoxModel {


		private var models:Object;

		private var initialized:Boolean = false;

		private var _isNew:Boolean = false;

		private var maxSlots:int = 18;

		public const updateSignal:Signal = new Signal();

		public function MysteryBoxModel() {
			super();
		}

		public function getBoxesOrderByWeight():Object {
			return this.models;
		}

		public function getBoxesForGrid():Vector.<MysteryBoxInfo> {
			var loc2:MysteryBoxInfo = null;
			var loc1:Vector.<MysteryBoxInfo> = new Vector.<MysteryBoxInfo>(this.maxSlots);
			for each(loc2 in this.models) {
				if (loc2.slot != 0) {
					loc1[loc2.slot - 1] = loc2;
				}
			}
			return loc1;
		}

		public function getBoxById(param1:String):MysteryBoxInfo {
			var loc2:MysteryBoxInfo = null;
			for each(loc2 in this.models) {
				if (loc2.id == param1) {
					return loc2;
				}
			}
			return null;
		}

		public function setMysetryBoxes(param1:Array):void {
			var loc2:MysteryBoxInfo = null;
			this.models = {};
			for each(loc2 in param1) {
				this.models[loc2.id] = loc2;
			}
			this.updateSignal.dispatch();
			this.initialized = true;
		}

		public function isInitialized():Boolean {
			return this.initialized;
		}

		public function setInitialized(param1:Boolean):void {
			this.initialized = param1;
		}

		public function get isNew():Boolean {
			return this._isNew;
		}

		public function set isNew(param1:Boolean):void {
			this._isNew = param1;
		}
	}
}
