package com.company.assembleegameclient.mapeditor {
	public class RegionChooser extends Chooser {


		public function RegionChooser() {
			var loc1:XML = null;
			var loc2:RegionElement = null;
			super(Layer.REGION);
			for each(loc1 in GroupDivider.GROUPS["Regions"]) {
				loc2 = new RegionElement(loc1);
				addElement(loc2);
			}
			hasBeenLoaded = true;
		}
	}
}
