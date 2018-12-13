package com.company.assembleegameclient.ui {
	import com.company.assembleegameclient.ui.components.TimerDisplay;

	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;

	import kabam.rotmg.text.view.TextFieldDisplayConcrete;
	import kabam.rotmg.text.view.stringBuilder.StringBuilder;

	import org.osflash.signals.Signal;

	public class BoostTimer extends Sprite {


		private var labelTextField:TextFieldDisplayConcrete;

		private var timerDisplay:TimerDisplay;

		public var textChanged:Signal;

		public function BoostTimer() {
			super();
			this.createLabelTextField();
			this.textChanged = this.labelTextField.textChanged;
			this.labelTextField.x = 0;
			this.labelTextField.y = 0;
			var loc1:TextFieldDisplayConcrete = this.returnTimerTextField();
			this.timerDisplay = new TimerDisplay(loc1);
			this.timerDisplay.x = 0;
			this.timerDisplay.y = 20;
			addChild(this.timerDisplay);
			addChild(this.labelTextField);
		}

		private function returnTimerTextField():TextFieldDisplayConcrete {
			var loc1:TextFieldDisplayConcrete = null;
			loc1 = new TextFieldDisplayConcrete().setSize(16).setColor(16777103);
			loc1.setBold(true);
			loc1.setMultiLine(true);
			loc1.mouseEnabled = true;
			loc1.filters = [new DropShadowFilter(0, 0, 0)];
			return loc1;
		}

		private function createLabelTextField():void {
			this.labelTextField = new TextFieldDisplayConcrete().setSize(16).setColor(16777215);
			this.labelTextField.setMultiLine(true);
			this.labelTextField.mouseEnabled = true;
			this.labelTextField.filters = [new DropShadowFilter(0, 0, 0)];
		}

		public function setLabelBuilder(param1:StringBuilder):void {
			this.labelTextField.setStringBuilder(param1);
		}

		public function setTime(param1:Number):void {
			this.timerDisplay.update(param1);
		}
	}
}
