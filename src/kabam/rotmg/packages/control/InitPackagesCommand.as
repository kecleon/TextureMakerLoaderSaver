 
package kabam.rotmg.packages.control {
	import kabam.rotmg.packages.services.PackageModel;
	import kabam.rotmg.promotions.model.BeginnersPackageModel;
	
	public class InitPackagesCommand {
		 
		
		[Inject]
		public var beginnersPackageModel:BeginnersPackageModel;
		
		[Inject]
		public var packageModel:PackageModel;
		
		[Inject]
		public var beginnersPackageAvailable:BeginnersPackageAvailableSignal;
		
		[Inject]
		public var packageAvailable:PackageAvailableSignal;
		
		public function InitPackagesCommand() {
			super();
		}
		
		public function execute() : void {
			var loc1:Boolean = this.beginnersPackageModel.status == 0 && this.packageModel.startupPackage() != null;
			if(this.beginnersPackageModel.isBeginnerAvailable() || loc1) {
				this.beginnersPackageAvailable.dispatch(loc1);
			} else if(this.packageModel.hasPackages()) {
				this.packageAvailable.dispatch();
			}
		}
	}
}
