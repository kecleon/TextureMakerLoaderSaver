 
package kabam.rotmg.game.view {
	import com.company.assembleegameclient.parameters.Parameters;
	import com.company.assembleegameclient.ui.tooltip.TextToolTip;
	import flash.events.MouseEvent;
	import kabam.rotmg.core.signals.HideTooltipsSignal;
	import kabam.rotmg.core.signals.ShowTooltipSignal;
	import kabam.rotmg.packages.model.PackageInfo;
	import kabam.rotmg.packages.services.PackageModel;
	import kabam.rotmg.tooltips.HoverTooltipDelegate;
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	public class ShopDisplayMediator extends Mediator {
		 
		
		[Inject]
		public var view:ShopDisplay;
		
		[Inject]
		public var packageBoxModel:PackageModel;
		
		[Inject]
		public var showTooltipSignal:ShowTooltipSignal;
		
		[Inject]
		public var hideTooltipSignal:HideTooltipsSignal;
		
		private var toolTip:TextToolTip = null;
		
		private var hoverTooltipDelegate:HoverTooltipDelegate;
		
		public function ShopDisplayMediator() {
			super();
		}
		
		override public function initialize() : void {
			var loc3:PackageInfo = null;
			if(this.view.shopButton && this.view.isOnNexus) {
				this.view.shopButton.addEventListener(MouseEvent.CLICK,this.view.onShopClick);
				this.toolTip = new TextToolTip(3552822,10197915,null,"Click to open!",95);
				this.hoverTooltipDelegate = new HoverTooltipDelegate();
				this.hoverTooltipDelegate.setShowToolTipSignal(this.showTooltipSignal);
				this.hoverTooltipDelegate.setHideToolTipsSignal(this.hideTooltipSignal);
				this.hoverTooltipDelegate.setDisplayObject(this.view.shopButton);
				this.hoverTooltipDelegate.tooltip = this.toolTip;
			}
			var loc1:Vector.<PackageInfo> = this.packageBoxModel.getBoxesForGrid();
			var loc2:Date = new Date();
			loc2.setTime(Parameters.data_["packages_indicator"]);
			for each(loc3 in loc1) {
				if(loc3 != null && (!loc3.endTime || loc3.getSecondsToEnd() > 0)) {
					if(loc3.isNew() && (loc3.startTime.getTime() > loc2.getTime() || !Parameters.data_["packages_indicator"])) {
						this.view.newIndicator(true);
					}
				}
			}
		}
	}
}
