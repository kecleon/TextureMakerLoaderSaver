 
package kabam.rotmg.game.view.components {
	import com.company.assembleegameclient.parameters.Parameters;
	import com.company.assembleegameclient.ui.tooltip.TextToolTip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextFieldAutoSize;
	import kabam.rotmg.text.view.TextFieldDisplayConcrete;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;
	import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeSignal;
	
	public class StatView extends Sprite {
		
		public static var toMaxTextSignal:Signal = new Signal(Boolean);
		 
		
		public var fullName_:String;
		
		public var description_:String;
		
		public var nameText_:TextFieldDisplayConcrete;
		
		public var valText_:TextFieldDisplayConcrete;
		
		public var redOnZero_:Boolean;
		
		public var val_:int = -1;
		
		public var boost_:int = -1;
		
		public var max_:int = -1;
		
		public var valColor_:uint = 11776947;
		
		public var level_:int = 0;
		
		public var toolTip_:TextToolTip;
		
		public var mouseOver:NativeSignal;
		
		public var mouseOut:NativeSignal;
		
		public function StatView(param1:String, param2:String, param3:String, param4:Boolean) {
			this.toolTip_ = new TextToolTip(3552822,10197915,"","",200);
			super();
			this.fullName_ = param2;
			this.description_ = param3;
			this.nameText_ = new TextFieldDisplayConcrete().setSize(13).setColor(11776947);
			this.nameText_.setStringBuilder(new LineBuilder().setParams(param1));
			this.configureTextAndAdd(this.nameText_);
			this.valText_ = new TextFieldDisplayConcrete().setSize(13).setColor(this.valColor_).setBold(true);
			this.valText_.setStringBuilder(new StaticStringBuilder("-"));
			this.configureTextAndAdd(this.valText_);
			this.redOnZero_ = param4;
			this.mouseOver = new NativeSignal(this,MouseEvent.MOUSE_OVER,MouseEvent);
			this.mouseOut = new NativeSignal(this,MouseEvent.MOUSE_OUT,MouseEvent);
			toMaxTextSignal.add(this.setNewText);
		}
		
		public function configureTextAndAdd(param1:TextFieldDisplayConcrete) : void {
			param1.setAutoSize(TextFieldAutoSize.LEFT);
			param1.filters = [new DropShadowFilter(0,0,0)];
			addChild(param1);
		}
		
		public function addTooltip() : void {
			this.toolTip_.setTitle(new LineBuilder().setParams(this.fullName_));
			this.toolTip_.setText(new LineBuilder().setParams(this.description_));
			if(!stage.contains(this.toolTip_)) {
				stage.addChild(this.toolTip_);
			}
		}
		
		public function removeTooltip() : void {
			if(this.toolTip_.parent != null) {
				this.toolTip_.parent.removeChild(this.toolTip_);
			}
		}
		
		public function draw(param1:int, param2:int, param3:int, param4:int = 0) : void {
			var loc5:uint = 0;
			if(param4 == this.level_ && param1 == this.val_ && param2 == this.boost_) {
				return;
			}
			this.val_ = param1;
			this.boost_ = param2;
			this.max_ = param3;
			this.level_ = param4;
			if(param1 - param2 >= param3) {
				loc5 = 16572160;
			} else if(this.redOnZero_ && this.val_ <= 0 || this.boost_ < 0) {
				loc5 = 16726072;
			} else if(this.boost_ > 0) {
				loc5 = 6206769;
			} else {
				loc5 = 11776947;
			}
			if(this.valColor_ != loc5) {
				this.valColor_ = loc5;
				this.valText_.setColor(this.valColor_);
			}
			this.setNewText(Parameters.data_.toggleToMaxText);
		}
		
		public function setNewText(param1:Boolean) : void {
			var loc3:int = 0;
			var loc2:String = this.val_.toString();
			if(param1) {
				loc3 = this.max_ - (this.val_ - this.boost_);
				if(this.level_ >= 20 && loc3 > 0) {
					loc2 = loc2 + ("|" + loc3.toString());
				}
			}
			if(this.boost_ != 0) {
				loc2 = loc2 + (" (" + (this.boost_ > 0?"+":"") + this.boost_.toString() + ")");
			}
			this.valText_.setStringBuilder(new StaticStringBuilder(loc2));
			this.valText_.x = 24;
		}
	}
}
