 
package com.company.assembleegameclient.account.ui {
	import com.company.assembleegameclient.account.ui.components.Selectable;
	import com.company.assembleegameclient.account.ui.components.SelectionGroup;
	import com.company.assembleegameclient.util.offer.Offer;
	import com.company.assembleegameclient.util.offer.Offers;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import kabam.lib.ui.api.Layout;
	import kabam.lib.ui.impl.VerticalLayout;
	import kabam.rotmg.account.core.model.MoneyConfig;
	
	public class OfferRadioButtons extends Sprite {
		 
		
		private var offers:Offers;
		
		private var config:MoneyConfig;
		
		private var choices:Vector.<OfferRadioButton>;
		
		private var group:SelectionGroup;
		
		public function OfferRadioButtons(param1:Offers, param2:MoneyConfig) {
			super();
			this.offers = param1;
			this.config = param2;
			this.makeGoldChoices();
			this.alignGoldChoices();
			this.makeSelectionGroup();
		}
		
		public function getChoice() : OfferRadioButton {
			return this.group.getSelected() as OfferRadioButton;
		}
		
		private function makeGoldChoices() : void {
			var loc1:int = this.offers.offerList.length;
			this.choices = new Vector.<OfferRadioButton>(loc1,true);
			var loc2:int = 0;
			while(loc2 < loc1) {
				this.choices[loc2] = this.makeGoldChoice(this.offers.offerList[loc2]);
				loc2++;
			}
		}
		
		private function makeGoldChoice(param1:Offer) : OfferRadioButton {
			var loc2:OfferRadioButton = new OfferRadioButton(param1,this.config);
			loc2.addEventListener(MouseEvent.CLICK,this.onSelected);
			addChild(loc2);
			return loc2;
		}
		
		private function onSelected(param1:MouseEvent) : void {
			var loc2:Selectable = param1.currentTarget as Selectable;
			this.group.setSelected(loc2.getValue());
		}
		
		private function alignGoldChoices() : void {
			var loc1:Vector.<DisplayObject> = this.castChoicesToDisplayList();
			var loc2:Layout = new VerticalLayout();
			loc2.setPadding(5);
			loc2.layout(loc1);
		}
		
		private function castChoicesToDisplayList() : Vector.<DisplayObject> {
			var loc1:int = this.choices.length;
			var loc2:Vector.<DisplayObject> = new Vector.<DisplayObject>(0);
			var loc3:int = 0;
			while(loc3 < loc1) {
				loc2[loc3] = this.choices[loc3];
				loc3++;
			}
			return loc2;
		}
		
		private function makeSelectionGroup() : void {
			var loc1:Vector.<Selectable> = this.castBoxesToSelectables();
			this.group = new SelectionGroup(loc1);
			this.group.setSelected(this.choices[0].getValue());
		}
		
		private function castBoxesToSelectables() : Vector.<Selectable> {
			var loc1:int = this.choices.length;
			var loc2:Vector.<Selectable> = new Vector.<Selectable>(0);
			var loc3:int = 0;
			while(loc3 < loc1) {
				loc2[loc3] = this.choices[loc3];
				loc3++;
			}
			return loc2;
		}
		
		public function showBonuses(param1:Boolean) : void {
			var loc2:int = this.choices.length;
			while(loc2--) {
				this.choices[loc2].showBonus(param1);
			}
		}
	}
}
