 
package kabam.rotmg.packages.control {
	import io.decagames.rotmg.shop.packages.startupPackage.StartupPackage;
	import io.decagames.rotmg.ui.popups.signals.ShowPopupSignal;
	import kabam.rotmg.dialogs.control.OpenDialogSignal;
	import kabam.rotmg.packages.model.PackageInfo;
	import kabam.rotmg.packages.services.PackageModel;
	import robotlegs.bender.bundles.mvcs.Command;
	
	public class OpenPackageCommand extends Command {
		 
		
		[Inject]
		public var openDialogSignal:OpenDialogSignal;
		
		[Inject]
		public var packageModel:PackageModel;
		
		[Inject]
		public var packageId:int;
		
		[Inject]
		public var alreadyBoughtPackage:AlreadyBoughtPackageSignal;
		
		[Inject]
		public var showPopupSignal:ShowPopupSignal;
		
		public function OpenPackageCommand() {
			super();
		}
		
		override public function execute() : void {
			var loc1:PackageInfo = this.packageModel.getPackageById(this.packageId);
			if(loc1 && loc1.popupImage != "") {
				this.showPopupSignal.dispatch(new StartupPackage(loc1));
			}
		}
	}
}
