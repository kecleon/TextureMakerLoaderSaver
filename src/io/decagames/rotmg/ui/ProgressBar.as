package io.decagames.rotmg.ui {
	import com.greensock.TweenLite;

	import flash.display.Shape;
	import flash.text.TextFormat;

	import io.decagames.rotmg.ui.gird.UIGridElement;
	import io.decagames.rotmg.ui.labels.UILabel;

	public class ProgressBar extends UIGridElement {

		public static const DYNAMIC_LABEL_TOKEN:String = "{X}";

		public static const MAX_VALUE_TOKEN:String = "{M}";


		private var componentWidth:int;

		private var componentHeight:int;

		private var _staticLabel:UILabel;

		private var _dynamicLabel:UILabel;

		private var _maxLabel:UILabel;

		private var _dynamicLabelString:String;

		private var _maxValue:int;

		private var _minValue:int;

		private var backgroundColor:uint;

		private var progressBarColor:uint;

		private var backgroundShape:Shape;

		private var progressShape:Shape;

		private var _value:int;

		private var _simulatedValue:int;

		private var simulationColor:uint;

		private var _shouldAnimate:Boolean;

		private var _showMaxLabel:Boolean;

		private var _simulatedValueTextFormat:TextFormat;

		private var _maxColor:uint;

		private var useMaxColor:Boolean;

		public function ProgressBar(param1:int, param2:int, param3:String, param4:String, param5:int, param6:int, param7:int, param8:uint, param9:uint, param10:uint = 0) {
			super();
			this.componentWidth = param1;
			this.componentHeight = param2;
			this._staticLabel = new UILabel();
			this._staticLabel.text = param3;
			this._dynamicLabel = new UILabel();
			this._maxLabel = new UILabel();
			this._dynamicLabelString = param4;
			this._maxValue = param6;
			this._minValue = param5;
			this.backgroundColor = param8;
			this.progressBarColor = param9;
			this.simulationColor = param10;
			addChild(this._dynamicLabel);
			addChild(this._staticLabel);
			this.backgroundShape = new Shape();
			addChild(this.backgroundShape);
			this.progressShape = new Shape();
			addChild(this.progressShape);
			this.value = param7;
			this._shouldAnimate = true;
		}

		public function set value(param1:int):void {
			this.render(this._value, this._value, false);
			this._value = param1;
			this._simulatedValue = param1;
			this.render(this._value, this._simulatedValue, this._shouldAnimate);
		}

		public function set simulatedValue(param1:int):void {
			this._simulatedValue = param1;
			this.render(this._value, this._simulatedValue, false);
		}

		override public function resize(param1:int, param2:int = -1):void {
			this.componentWidth = param1;
			this.render(this._value, this._simulatedValue, false);
		}

		private function render(param1:int, param2:int, param3:Boolean):void {
			var loc7:int = 0;
			var loc4:* = param2 != param1;
			this.backgroundShape.graphics.clear();
			this.backgroundShape.graphics.beginFill(this.backgroundColor, 1);
			this.backgroundShape.graphics.drawRect(0, 0, this.componentWidth, this.componentHeight);
			var loc5:Number = this.componentWidth * param1 / (this._maxValue - this._minValue);
			if (isNaN(loc5)) {
				loc5 = 0;
			}
			if (param3) {
				TweenLite.to(this.progressShape, 1, {
					"width": loc5,
					"onComplete": this.onAnimationComplete
				});
			} else {
				this.progressShape.graphics.clear();
				this.progressShape.graphics.beginFill(this.useMaxColor && param1 >= this._maxValue - this._minValue ? uint(this._maxColor) : uint(this.progressBarColor), 1);
				this.progressShape.graphics.drawRect(0, 0, loc5, this.componentHeight);
				this.progressShape.width = loc5;
			}
			if (loc4) {
				this.progressShape.graphics.beginFill(this.useMaxColor && this._maxValue - this._minValue == param2 ? uint(this._maxColor) : uint(this.simulationColor), 1);
				this.progressShape.graphics.drawRect(loc5, 0, this.componentWidth * param2 / (this._maxValue - this._minValue) - loc5, this.componentHeight);
			}
			var loc6:String = this._dynamicLabelString.replace(DYNAMIC_LABEL_TOKEN, !!loc4 ? param2 : param1);
			this._dynamicLabel.text = loc6.replace(MAX_VALUE_TOKEN, this._maxValue);
			this._maxLabel.text = "";
			if (loc4 && this._simulatedValueTextFormat) {
				loc7 = this._dynamicLabel.text.indexOf(param2.toString());
				this._dynamicLabel.setTextFormat(this._simulatedValueTextFormat, loc7, loc7 + param2.toString().length);
				if (this._showMaxLabel && this._maxValue == param2) {
					this._maxLabel.text = "MAX";
				}
			}
			this._dynamicLabel.x = this.componentWidth - this._dynamicLabel.width + 2;
			this._maxLabel.x = this._dynamicLabel.x + this._dynamicLabel.width;
			this._staticLabel.x = -2;
			this.backgroundShape.y = this._staticLabel.height;
			this.progressShape.y = this._staticLabel.height;
		}

		private function onAnimationComplete():void {
			this.render(this._value, this._value, false);
		}

		public function get staticLabel():UILabel {
			return this._staticLabel;
		}

		public function get dynamicLabel():UILabel {
			return this._dynamicLabel;
		}

		public function get value():int {
			return this._value;
		}

		public function get dynamicLabelString():String {
			return this._dynamicLabelString;
		}

		public function set dynamicLabelString(param1:String):void {
			this._dynamicLabelString = param1;
		}

		public function get maxValue():int {
			return this._maxValue;
		}

		public function get minValue():int {
			return this._minValue;
		}

		public function set maxValue(param1:int):void {
			this._maxValue = param1;
		}

		public function set simulatedValueTextFormat(param1:TextFormat):void {
			this._simulatedValueTextFormat = param1;
		}

		public function get showMaxLabel():Boolean {
			return this._showMaxLabel;
		}

		public function set showMaxLabel(param1:Boolean):void {
			if (param1 && !this._maxLabel.parent) {
				addChild(this._maxLabel);
			}
			if (!param1 && this._maxLabel.parent) {
				removeChild(this._maxLabel);
			}
			this._showMaxLabel = param1;
		}

		public function get maxLabel():UILabel {
			return this._maxLabel;
		}

		public function get maxColor():uint {
			return this._maxColor;
		}

		public function set maxColor(param1:uint):void {
			this.useMaxColor = true;
			this._maxColor = param1;
			this.render(this._value, this._simulatedValue, false);
		}

		public function get shouldAnimate():Boolean {
			return this._shouldAnimate;
		}

		public function set shouldAnimate(param1:Boolean):void {
			this._shouldAnimate = param1;
		}
	}
}
