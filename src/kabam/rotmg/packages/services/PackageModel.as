package kabam.rotmg.packages.services {
	import kabam.rotmg.packages.model.*;

	import org.osflash.signals.Signal;

	public class PackageModel {


		public var numSpammed:int = 0;

		private var models:Object;

		private var initialized:Boolean;

		private var maxSlots:int = 18;

		public const updateSignal:Signal = new Signal();

		public function PackageModel() {
			super();
		}

		public function getBoxesForGrid():Vector.<PackageInfo> {
			var loc2:PackageInfo = null;
			var loc1:Vector.<PackageInfo> = new Vector.<PackageInfo>(this.maxSlots);
			for each(loc2 in this.models) {
				if (loc2.slot != 0) {
					loc1[loc2.slot - 1] = loc2;
				}
			}
			return loc1;
		}

		public function startupPackage():PackageInfo {
			var loc1:PackageInfo = null;
			for each(loc1 in this.models) {
				if (loc1.showOnLogin && loc1.popupImage != "") {
					return loc1;
				}
			}
			return null;
		}

		public function getInitialized():Boolean {
			return this.initialized;
		}

		public function getPackageById(param1:int):PackageInfo {
			return this.models[param1];
		}

		public function hasPackage(param1:int):Boolean {
			return param1 in this.models;
		}

		public function setPackages(param1:Array):void {
			var loc2:PackageInfo = null;
			this.models = {};
			for each(loc2 in param1) {
				this.models[loc2.id] = loc2;
			}
			this.updateSignal.dispatch();
			this.initialized = true;
		}

		public function canPurchasePackage(param1:int):Boolean {
			var loc2:PackageInfo = this.models[param1];
			return loc2 != null;
		}

		public function getPriorityPackage():PackageInfo {
			var loc1:PackageInfo = null;
			return loc1;
		}

		public function setInitialized(param1:Boolean):void {
			this.initialized = param1;
		}

		public function hasPackages():Boolean {
			var loc1:Object = null;
			for each(loc1 in this.models) {
				return true;
			}
			return false;
		}
	}
}
