 
package com.company.assembleegameclient.account.ui {
	import com.company.assembleegameclient.account.ui.components.Selectable;
	import com.company.assembleegameclient.account.ui.components.SelectionGroup;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import kabam.lib.ui.api.Layout;
	import kabam.lib.ui.impl.HorizontalLayout;
	import kabam.rotmg.ui.view.SignalWaiter;
	
	public class PaymentMethodRadioButtons extends Sprite {
		 
		
		private var labels:Vector.<String>;
		
		private var boxes:Vector.<PaymentMethodRadioButton>;
		
		private var group:SelectionGroup;
		
		private const waiter:SignalWaiter = new SignalWaiter();
		
		public function PaymentMethodRadioButtons(param1:Vector.<String>) {
			super();
			this.labels = param1;
			this.waiter.complete.add(this.alignRadioButtons);
			this.makeRadioButtons();
			this.alignRadioButtons();
			this.makeSelectionGroup();
		}
		
		public function setSelected(param1:String) : void {
			this.group.setSelected(param1);
		}
		
		public function getSelected() : String {
			return this.group.getSelected().getValue();
		}
		
		private function makeRadioButtons() : void {
			var loc1:int = this.labels.length;
			this.boxes = new Vector.<PaymentMethodRadioButton>(loc1,true);
			var loc2:int = 0;
			while(loc2 < loc1) {
				this.boxes[loc2] = this.makeRadioButton(this.labels[loc2]);
				loc2++;
			}
		}
		
		private function makeRadioButton(param1:String) : PaymentMethodRadioButton {
			var loc2:PaymentMethodRadioButton = new PaymentMethodRadioButton(param1);
			loc2.addEventListener(MouseEvent.CLICK,this.onSelected);
			this.waiter.push(loc2.textSet);
			addChild(loc2);
			return loc2;
		}
		
		private function onSelected(param1:Event) : void {
			var loc2:Selectable = param1.currentTarget as Selectable;
			this.group.setSelected(loc2.getValue());
		}
		
		private function alignRadioButtons() : void {
			var loc1:Vector.<DisplayObject> = this.castBoxesToDisplayObjects();
			var loc2:Layout = new HorizontalLayout();
			loc2.setPadding(20);
			loc2.layout(loc1);
		}
		
		private function castBoxesToDisplayObjects() : Vector.<DisplayObject> {
			var loc1:int = this.boxes.length;
			var loc2:Vector.<DisplayObject> = new Vector.<DisplayObject>(0);
			var loc3:int = 0;
			while(loc3 < loc1) {
				loc2[loc3] = this.boxes[loc3];
				loc3++;
			}
			return loc2;
		}
		
		private function makeSelectionGroup() : void {
			var loc1:Vector.<Selectable> = this.castBoxesToSelectables();
			this.group = new SelectionGroup(loc1);
			this.group.setSelected(this.boxes[0].getValue());
		}
		
		private function castBoxesToSelectables() : Vector.<Selectable> {
			var loc1:int = this.boxes.length;
			var loc2:Vector.<Selectable> = new Vector.<Selectable>(0);
			var loc3:int = 0;
			while(loc3 < loc1) {
				loc2[loc3] = this.boxes[loc3];
				loc3++;
			}
			return loc2;
		}
	}
}
