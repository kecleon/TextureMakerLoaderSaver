 
package com.company.assembleegameclient.objects {
	import com.company.assembleegameclient.constants.InventoryOwnerTypes;
	import com.company.assembleegameclient.map.Camera;
	import com.company.assembleegameclient.map.Map;
	import com.company.assembleegameclient.ui.tooltip.EquipmentToolTip;
	import com.company.assembleegameclient.ui.tooltip.ToolTip;
	import com.company.ui.BaseSimpleText;
	import com.company.util.IntPoint;
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.easing.Sine;
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import kabam.rotmg.core.StaticInjectorContext;
	import kabam.rotmg.game.model.AddSpeechBalloonVO;
	import kabam.rotmg.game.signals.AddSpeechBalloonSignal;
	import kabam.rotmg.language.model.StringMap;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;
	
	public class Merchant extends SellableObject implements IInteractiveObject {
		
		private static const NONE_MESSAGE:int = 0;
		
		private static const NEW_MESSAGE:int = 1;
		
		private static const MINS_LEFT_MESSAGE:int = 2;
		
		private static const ITEMS_LEFT_MESSAGE:int = 3;
		
		private static const DISCOUNT_MESSAGE:int = 4;
		
		private static const T:Number = 1;
		
		private static const DOSE_MATRIX:Matrix = function():Matrix {
			var loc1:* = new Matrix();
			loc1.translate(10,5);
			return loc1;
		}();
		 
		
		public var merchandiseType_:int = -1;
		
		public var count_:int = -1;
		
		public var minsLeft_:int = -1;
		
		public var discount_:int = 0;
		
		public var merchandiseTexture_:BitmapData = null;
		
		public var untilNextMessage_:int = 0;
		
		public var alpha_:Number = 1.0;
		
		private var addSpeechBalloon:AddSpeechBalloonSignal;
		
		private var stringMap:StringMap;
		
		private var firstUpdate_:Boolean = true;
		
		private var messageIndex_:int = 0;
		
		private var ct_:ColorTransform;
		
		public function Merchant(param1:XML) {
			this.ct_ = new ColorTransform(1,1,1,1);
			this.addSpeechBalloon = StaticInjectorContext.getInjector().getInstance(AddSpeechBalloonSignal);
			this.stringMap = StaticInjectorContext.getInjector().getInstance(StringMap);
			super(param1);
			isInteractive_ = true;
		}
		
		override public function setPrice(param1:int) : void {
			super.setPrice(param1);
			this.untilNextMessage_ = 0;
		}
		
		override public function setRankReq(param1:int) : void {
			super.setRankReq(param1);
			this.untilNextMessage_ = 0;
		}
		
		override public function addTo(param1:Map, param2:Number, param3:Number) : Boolean {
			if(!super.addTo(param1,param2,param3)) {
				return false;
			}
			param1.merchLookup_[new IntPoint(x_,y_)] = this;
			return true;
		}
		
		override public function removeFromMap() : void {
			var loc1:IntPoint = new IntPoint(x_,y_);
			if(map_.merchLookup_[loc1] == this) {
				map_.merchLookup_[loc1] = null;
			}
			super.removeFromMap();
		}
		
		public function getSpeechBalloon(param1:int) : AddSpeechBalloonVO {
			var loc2:LineBuilder = null;
			var loc3:uint = 0;
			var loc4:uint = 0;
			var loc5:uint = 0;
			switch(param1) {
				case NEW_MESSAGE:
					loc2 = new LineBuilder().setParams("Merchant.new");
					loc3 = 15132390;
					loc4 = 16777215;
					loc5 = 5931045;
					break;
				case MINS_LEFT_MESSAGE:
					if(this.minsLeft_ == 0) {
						loc2 = new LineBuilder().setParams("Merchant.goingSoon");
					} else if(this.minsLeft_ == 1) {
						loc2 = new LineBuilder().setParams("Merchant.goingInOneMinute");
					} else {
						loc2 = new LineBuilder().setParams("Merchant.goingInNMinutes",{"minutes":this.minsLeft_});
					}
					loc3 = 5973542;
					loc4 = 16549442;
					loc5 = 16549442;
					break;
				case ITEMS_LEFT_MESSAGE:
					loc2 = new LineBuilder().setParams("Merchant.limitedStock",{"count":this.count_});
					loc3 = 5973542;
					loc4 = 16549442;
					loc5 = 16549442;
					break;
				case DISCOUNT_MESSAGE:
					loc2 = new LineBuilder().setParams("Merchant.discount",{"discount":this.discount_});
					loc3 = 6324275;
					loc4 = 16777103;
					loc5 = 16777103;
					break;
				default:
					return null;
			}
			loc2.setStringMap(this.stringMap);
			return new AddSpeechBalloonVO(this,loc2.getString(),"",false,false,loc3,1,loc4,1,loc5,6,true,false);
		}
		
		override public function update(param1:int, param2:int) : Boolean {
			var loc5:GTween = null;
			super.update(param1,param2);
			if(this.firstUpdate_) {
				if(this.minsLeft_ == 2147483647) {
					loc5 = new GTween(this,0.5 * T,{"size_":150},{"ease":Sine.easeOut});
					loc5.nextTween = new GTween(this,0.5 * T,{"size_":100},{"ease":Sine.easeIn});
					loc5.nextTween.paused = true;
				}
				this.firstUpdate_ = false;
			}
			this.untilNextMessage_ = this.untilNextMessage_ - param2;
			if(this.untilNextMessage_ > 0) {
				return true;
			}
			this.untilNextMessage_ = 5000;
			var loc3:Vector.<int> = new Vector.<int>();
			if(this.minsLeft_ == 2147483647) {
				loc3.push(NEW_MESSAGE);
			} else if(this.minsLeft_ >= 0 && this.minsLeft_ <= 5) {
				loc3.push(MINS_LEFT_MESSAGE);
			}
			if(this.count_ >= 1 && this.count_ <= 2) {
				loc3.push(ITEMS_LEFT_MESSAGE);
			}
			if(this.discount_ > 0) {
				loc3.push(DISCOUNT_MESSAGE);
			}
			if(loc3.length == 0) {
				return true;
			}
			this.messageIndex_ = ++this.messageIndex_ % loc3.length;
			var loc4:int = loc3[this.messageIndex_];
			this.addSpeechBalloon.dispatch(this.getSpeechBalloon(loc4));
			return true;
		}
		
		override public function soldObjectName() : String {
			return ObjectLibrary.typeToDisplayId_[this.merchandiseType_];
		}
		
		override public function soldObjectInternalName() : String {
			var loc1:XML = ObjectLibrary.xmlLibrary_[this.merchandiseType_];
			return loc1.@id.toString();
		}
		
		override public function getTooltip() : ToolTip {
			var loc1:ToolTip = new EquipmentToolTip(this.merchandiseType_,map_.player_,-1,InventoryOwnerTypes.NPC);
			return loc1;
		}
		
		override public function getSellableType() : int {
			return this.merchandiseType_;
		}
		
		override public function getIcon() : BitmapData {
			var loc3:BaseSimpleText = null;
			var loc4:BaseSimpleText = null;
			var loc1:BitmapData = ObjectLibrary.getRedrawnTextureFromType(this.merchandiseType_,80,true);
			var loc2:XML = ObjectLibrary.xmlLibrary_[this.merchandiseType_];
			if(loc2.hasOwnProperty("Doses")) {
				loc1 = loc1.clone();
				loc3 = new BaseSimpleText(12,16777215,false,0,0);
				loc3.text = String(loc2.Doses);
				loc3.updateMetrics();
				loc1.draw(loc3,DOSE_MATRIX);
			}
			if(loc2.hasOwnProperty("Quantity")) {
				loc1 = loc1.clone();
				loc4 = new BaseSimpleText(12,16777215,false,0,0);
				loc4.text = String(loc2.Quantity);
				loc4.updateMetrics();
				loc1.draw(loc4,DOSE_MATRIX);
			}
			return loc1;
		}
		
		public function getTex1Id(param1:int) : int {
			var loc2:XML = ObjectLibrary.xmlLibrary_[this.merchandiseType_];
			if(loc2 == null) {
				return param1;
			}
			if(loc2.Activate == "Dye" && loc2.hasOwnProperty("Tex1")) {
				return int(loc2.Tex1);
			}
			return param1;
		}
		
		public function getTex2Id(param1:int) : int {
			var loc2:XML = ObjectLibrary.xmlLibrary_[this.merchandiseType_];
			if(loc2 == null) {
				return param1;
			}
			if(loc2.Activate == "Dye" && loc2.hasOwnProperty("Tex2")) {
				return int(loc2.Tex2);
			}
			return param1;
		}
		
		override protected function getTexture(param1:Camera, param2:int) : BitmapData {
			if(this.alpha_ == 1 && size_ == 100) {
				return this.merchandiseTexture_;
			}
			var loc3:BitmapData = ObjectLibrary.getRedrawnTextureFromType(this.merchandiseType_,size_,false,false);
			if(this.alpha_ != 1) {
				this.ct_.alphaMultiplier = this.alpha_;
				loc3.colorTransform(loc3.rect,this.ct_);
			}
			return loc3;
		}
		
		public function setMerchandiseType(param1:int) : void {
			this.merchandiseType_ = param1;
			this.merchandiseTexture_ = ObjectLibrary.getRedrawnTextureFromType(this.merchandiseType_,100,false);
		}
	}
}
