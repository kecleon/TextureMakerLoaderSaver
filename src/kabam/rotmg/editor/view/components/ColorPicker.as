 
package kabam.rotmg.editor.view.components {
	import com.company.color.HSV;
	import com.company.color.RGB;
	import com.company.ui.BaseSimpleText;
	import com.company.util.MoreColorUtil;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	
	public class ColorPicker extends Sprite {
		
		private static var paletteselectEmbed_:Class = ColorPicker_paletteselectEmbed_;
		
		private static var hsselectEmbed_:Class = ColorPicker_hsselectEmbed_;
		
		private static var vselectEmbed_:Class = ColorPicker_vselectEmbed_;
		
		private static const PALETTE_WIDTH:int = 6;
		
		private static const PALETTE_HEIGHT:int = 2;
		
		private static const PALETTE_BOX_SIZE:int = 19;
		
		private static const GAP_SIZE:int = 8;
		
		private static const PALETTE_BOX_COLORS:Vector.<uint> = new <uint>[16245355,0,16777215,7291927,10839330,12461619,3389995,5777425,7113244,9961473,4013116,12873770,15436081,8805672,15597568,7368395,3252978,10735143,16383286,13982555,6969880,12566461,2534694,7573493];
		 
		
		private var paletteBoxes_:Vector.<PaletteBox>;
		
		private var selected_:PaletteBox = null;
		
		private var paletteSelect_:Bitmap;
		
		private var gradientPalette_:GradientPalette;
		
		private var HSBD_:BitmapData;
		
		private var HSBox_:Sprite;
		
		private var HSSelect_:Bitmap;
		
		private var VBD_:BitmapData;
		
		private var VBox_:Sprite;
		
		private var VSelect_:Bitmap;
		
		private var colorText_:BaseSimpleText;
		
		private var dragSprite_:Sprite = null;
		
		public function ColorPicker() {
			var loc1:Bitmap = null;
			var loc3:int = 0;
			var loc4:int = 0;
			var loc5:RGB = null;
			var loc6:PaletteBox = null;
			this.paletteBoxes_ = new Vector.<PaletteBox>();
			super();
			var loc2:int = 0;
			while(loc2 < PALETTE_WIDTH) {
				loc3 = 0;
				while(loc3 < PALETTE_HEIGHT) {
					loc4 = loc3 * PALETTE_WIDTH + loc2;
					loc5 = RGB.fromColor(PALETTE_BOX_COLORS[loc4]);
					loc6 = new PaletteBox(PALETTE_BOX_SIZE,loc5.toHSV(),false);
					loc6.x = loc2 * (PALETTE_BOX_SIZE + GAP_SIZE);
					loc6.y = loc3 * (PALETTE_BOX_SIZE + GAP_SIZE);
					addChild(loc6);
					loc6.addEventListener(MouseEvent.MOUSE_DOWN,this.onPaletteBoxDown);
					this.paletteBoxes_.push(loc6);
					loc3++;
				}
				loc2++;
			}
			this.paletteSelect_ = new paletteselectEmbed_();
			addChild(this.paletteSelect_);
			this.gradientPalette_ = new GradientPalette();
			this.gradientPalette_.x = 172;
			this.gradientPalette_.y = 2;
			this.gradientPalette_.addEventListener(ColorEvent.COLOR_EVENT,this.onColorEvent);
			addChild(this.gradientPalette_);
			this.HSBD_ = new BitmapDataSpy(360,100,false,16711680);
			loc1 = new Bitmap(this.HSBD_);
			this.HSBox_ = new Sprite();
			this.HSBox_.addChild(loc1);
			this.HSBox_.x = 380;
			addChild(this.HSBox_);
			this.HSBox_.addEventListener(MouseEvent.MOUSE_DOWN,this.onHSMouseDown);
			this.HSSelect_ = new hsselectEmbed_();
			this.HSBox_.addChild(this.HSSelect_);
			this.VBD_ = new BitmapDataSpy(1,100,false,65280);
			loc1 = new Bitmap(this.VBD_);
			loc1.width = 20;
			this.VBox_ = new Sprite();
			this.VBox_.addChild(loc1);
			this.VBox_.x = 750;
			addChild(this.VBox_);
			this.VBox_.addEventListener(MouseEvent.MOUSE_DOWN,this.onVMouseDown);
			this.VSelect_ = new vselectEmbed_();
			this.VSelect_.x = -3;
			this.VBox_.addChild(this.VSelect_);
			this.colorText_ = new BaseSimpleText(18,16777215,true,100,26);
			this.colorText_.text = "FFFFFF";
			this.colorText_.restrict = "0123456789aAbBcCdDeEfF";
			this.colorText_.maxChars = 6;
			this.colorText_.useTextDimensions();
			this.colorText_.filters = [new DropShadowFilter(0,0,0)];
			this.colorText_.y = 60;
			this.colorText_.x = 154 / 2 - this.colorText_.width / 2;
			this.colorText_.addEventListener(Event.CHANGE,this.onColorChange);
			addChild(this.colorText_);
			this.setSelected(this.paletteBoxes_[0]);
		}
		
		public function getColor() : HSV {
			return this.selected_.hsv_;
		}
		
		public function setColor(param1:HSV) : void {
			this.setColorHSV(param1.h_,param1.s_,param1.v_);
		}
		
		private function setSelected(param1:PaletteBox) : void {
			this.selected_ = param1;
			this.paletteSelect_.x = this.selected_.x - 1;
			this.paletteSelect_.y = this.selected_.y - 1;
			this.redrawHSBD();
			this.redrawVBD();
			this.moveIndicators();
			this.updateColorText();
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function setColorHSV(param1:Number, param2:Number, param3:Number) : void {
			var loc4:HSV = new HSV(param1,param2,param3);
			var loc5:Boolean = loc4.h_ != this.selected_.hsv_.h_ || loc4.s_ != this.selected_.hsv_.s_;
			var loc6:* = loc4.v_ != this.selected_.hsv_.v_;
			this.selected_.setColor(loc4);
			if(loc6) {
				this.redrawHSBD();
			}
			if(loc5) {
				this.redrawVBD();
			}
			this.moveIndicators();
			this.updateColorText();
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function updateColorText() : void {
			if(stage != null && stage.focus == this.colorText_) {
				return;
			}
			this.colorText_.text = this.selected_.hsv_.toRGB().toString();
		}
		
		private function redrawHSBD() : void {
			var loc2:int = 0;
			var loc3:uint = 0;
			var loc1:int = 0;
			while(loc1 < this.HSBD_.width) {
				loc2 = 0;
				while(loc2 < this.HSBD_.height) {
					loc3 = MoreColorUtil.hsvToRgb(loc1,(this.HSBD_.height - loc2) / this.HSBD_.height,this.selected_.hsv_.v_);
					this.HSBD_.setPixel(loc1,loc2,loc3);
					loc2++;
				}
				loc1++;
			}
		}
		
		private function redrawVBD() : void {
			var loc2:uint = 0;
			var loc1:int = 0;
			while(loc1 < this.VBD_.height) {
				loc2 = MoreColorUtil.hsvToRgb(this.selected_.hsv_.h_,this.selected_.hsv_.s_,(this.VBD_.height - loc1) / this.VBD_.height);
				this.VBD_.setPixel(0,loc1,loc2);
				loc1++;
			}
		}
		
		private function moveIndicators() : void {
			this.HSSelect_.x = this.selected_.hsv_.h_ - int(this.HSSelect_.width / 2);
			this.HSSelect_.y = (1 - this.selected_.hsv_.s_) * this.HSBD_.height - int(this.HSSelect_.height / 2);
			this.VSelect_.y = (1 - this.selected_.hsv_.v_) * this.VBD_.height - int(this.VSelect_.height / 2);
		}
		
		private function onColorEvent(param1:ColorEvent) : void {
			this.setColor(param1.hsv_);
		}
		
		private function onPaletteBoxDown(param1:MouseEvent) : void {
			var loc2:PaletteBox = param1.target as PaletteBox;
			this.setSelected(loc2);
			var loc3:PaletteBox = new PaletteBox(PALETTE_BOX_SIZE / 2,loc2.hsv_,true);
			loc3.x = -loc3.width / 2;
			loc3.y = -loc3.height / 2;
			this.dragSprite_ = new Sprite();
			this.dragSprite_.addChild(loc3);
			stage.addEventListener(MouseEvent.MOUSE_UP,this.onStopDrag);
			stage.addChild(this.dragSprite_);
			this.dragSprite_.startDrag(true,null);
		}
		
		private function onStopDrag(param1:MouseEvent) : void {
			this.dragSprite_.stopDrag();
			this.dragSprite_.parent.removeChild(this.dragSprite_);
			stage.removeEventListener(MouseEvent.MOUSE_UP,this.onStopDrag);
			var loc2:PaletteBox = this.dragSprite_.dropTarget as PaletteBox;
			this.dragSprite_ = null;
			var loc3:PaletteBox = param1.target as PaletteBox;
			if(loc2 == null || loc3 == null) {
				return;
			}
			loc2.setColor(loc3.hsv_);
		}
		
		private function onColorChange(param1:Event) : void {
			this.setColor(RGB.fromColor(uint("0x" + this.colorText_.text)).toHSV());
		}
		
		private function onHSMouseDown(param1:MouseEvent) : void {
			this.setColorHSV(this.HSBox_.mouseX,(this.HSBox_.height - this.HSBox_.mouseY) / 100,this.selected_.hsv_.v_);
			stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onHSMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,this.onHSMouseUp);
		}
		
		private function onHSMouseMove(param1:MouseEvent) : void {
			this.setColorHSV(this.HSBox_.mouseX,(this.HSBox_.height - this.HSBox_.mouseY) / 100,this.selected_.hsv_.v_);
		}
		
		private function onHSMouseUp(param1:MouseEvent) : void {
			this.setColorHSV(this.HSBox_.mouseX,(this.HSBox_.height - this.HSBox_.mouseY) / 100,this.selected_.hsv_.v_);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onHSMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,this.onHSMouseUp);
		}
		
		private function onVMouseDown(param1:MouseEvent) : void {
			this.setColorHSV(this.selected_.hsv_.h_,this.selected_.hsv_.s_,(this.VBox_.height - this.VBox_.mouseY) / 100);
			stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onVMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,this.onVMouseUp);
		}
		
		private function onVMouseMove(param1:MouseEvent) : void {
			this.setColorHSV(this.selected_.hsv_.h_,this.selected_.hsv_.s_,(this.VBox_.height - this.VBox_.mouseY) / 100);
		}
		
		private function onVMouseUp(param1:MouseEvent) : void {
			this.setColorHSV(this.selected_.hsv_.h_,this.selected_.hsv_.s_,(this.VBox_.height - this.VBox_.mouseY) / 100);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onVMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,this.onVMouseUp);
		}
	}
}
