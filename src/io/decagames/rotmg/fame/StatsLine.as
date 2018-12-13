package io.decagames.rotmg.fame {
	import com.company.assembleegameclient.util.TextureRedrawer;
	import com.company.util.AssetLibrary;
	import com.company.util.GraphicsUtil;

	import flash.display.Bitmap;
	import flash.display.GraphicsPath;
	import flash.display.GraphicsSolidFill;
	import flash.display.IGraphicsData;
	import flash.display.Sprite;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	import io.decagames.rotmg.ui.labels.UILabel;
	import io.decagames.rotmg.utils.colors.Tint;

	import kabam.rotmg.text.model.FontModel;

	public class StatsLine extends Sprite {

		public static const TYPE_BONUS:int = 0;

		public static const TYPE_STAT:int = 1;

		public static const TYPE_TITLE:int = 2;


		private var backgroundFill_:GraphicsSolidFill;

		private var path_:GraphicsPath;

		private var lineWidth:int = 306;

		protected var lineHeight:int;

		private var _tooltipText:String;

		private var _lineType:int;

		private var isLocked:Boolean;

		protected var fameValue:UILabel;

		protected var label:UILabel;

		protected var lock:Bitmap;

		private var _labelText:String;

		public function StatsLine(param1:String, param2:String, param3:String, param4:int, param5:Boolean = false) {
			var loc8:int = 0;
			this.backgroundFill_ = new GraphicsSolidFill(1973790);
			this.path_ = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());
			this.fameValue = new UILabel();
			super();
			var loc6:TextFormat = new TextFormat();
			loc6.color = 9079434;
			loc6.font = FontModel.DEFAULT_FONT_NAME;
			loc6.size = 13;
			loc6.bold = true;
			loc6.align = TextFormatAlign.LEFT;
			this.isLocked = param5;
			this._lineType = param4;
			this._labelText = param1;
			if (param4 == TYPE_TITLE) {
				loc6.size = 15;
				loc6.color = 16777215;
			}
			var loc7:TextFormat = new TextFormat();
			if (param4 == TYPE_BONUS) {
				loc7.color = 16762880;
			} else {
				loc7.color = 5544494;
			}
			loc7.font = FontModel.DEFAULT_FONT_NAME;
			loc7.size = 13;
			loc7.bold = true;
			loc7.align = TextFormatAlign.LEFT;
			this.label = new UILabel();
			this.label.defaultTextFormat = loc6;
			addChild(this.label);
			this.label.text = param1;
			if (!param5) {
				this.fameValue = new UILabel();
				this.fameValue.defaultTextFormat = loc7;
				if (param2 == "0" || param2 == "0.00%") {
					this.fameValue.defaultTextFormat = loc6;
				}
				if (param4 == TYPE_BONUS) {
					this.fameValue.text = "+" + param2;
				} else {
					this.fameValue.text = param2;
				}
				this.fameValue.x = this.lineWidth - 4 - this.fameValue.textWidth;
				addChild(this.fameValue);
				this.fameValue.y = 2;
			} else {
				loc8 = 36;
				this.lock = new Bitmap(TextureRedrawer.resize(AssetLibrary.getImageFromSet("lofiInterface2", 5), null, loc8, true, 0, 0));
				Tint.add(this.lock, 9971490, 1);
				addChild(this.lock);
				this.lock.x = this.lineWidth - loc8 + 5;
				this.lock.y = -8;
			}
			this.setLabelsPosition();
			this._tooltipText = param3;
		}

		protected function setLabelsPosition():void {
			this.label.y = 2;
			this.label.x = 2;
			this.lineHeight = 20;
		}

		public function clean():void {
			if (this.lock) {
				removeChild(this.lock);
				this.lock.bitmapData.dispose();
			}
		}

		public function drawBrightBackground():void {
			var loc1:Vector.<IGraphicsData> = new <IGraphicsData>[this.backgroundFill_, this.path_, GraphicsUtil.END_FILL];
			GraphicsUtil.drawCutEdgeRect(0, 0, this.lineWidth, this.lineHeight, 5, [1, 1, 1, 1], this.path_);
			graphics.drawGraphicsData(loc1);
		}

		public function get tooltipText():String {
			return this._tooltipText;
		}

		public function get lineType():int {
			return this._lineType;
		}

		public function get labelText():String {
			return this._labelText;
		}
	}
}
