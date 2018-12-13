 
package com.company.assembleegameclient.ui {
	import com.company.assembleegameclient.objects.GameObject;
	import com.company.assembleegameclient.objects.ObjectLibrary;
	import com.company.assembleegameclient.objects.Player;
	import com.company.assembleegameclient.util.PlayerUtil;
	import com.company.util.MoreColorUtil;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	import flash.geom.ColorTransform;
	import kabam.rotmg.text.view.TextFieldDisplayConcrete;
	import kabam.rotmg.text.view.stringBuilder.TemplateBuilder;
	import org.osflash.signals.Signal;
	
	public class GameObjectListItem extends Sprite {
		 
		
		public var portrait:Bitmap;
		
		private var text:TextFieldDisplayConcrete;
		
		private var builder:TemplateBuilder;
		
		private var color:uint;
		
		public var isLongVersion:Boolean;
		
		public var go:GameObject;
		
		public var textReady:Signal;
		
		private var objname:String;
		
		private var type:int;
		
		private var level:int;
		
		private var positionClassBelow:Boolean;
		
		public function GameObjectListItem(param1:uint, param2:Boolean, param3:GameObject, param4:Boolean = false) {
			super();
			this.positionClassBelow = param4;
			this.isLongVersion = param2;
			this.color = param1;
			this.portrait = new Bitmap();
			this.portrait.x = -4;
			this.portrait.y = !!param4?Number(-1):Number(-4);
			addChild(this.portrait);
			this.text = new TextFieldDisplayConcrete().setSize(13).setColor(param1).setHTML(param2);
			if(!param2) {
				this.text.setTextWidth(66).setTextHeight(20).setBold(true);
			}
			this.text.x = 32;
			this.text.y = 6;
			this.text.filters = [new DropShadowFilter(0,0,0)];
			addChild(this.text);
			this.textReady = this.text.textChanged;
			this.draw(param3);
		}
		
		public function draw(param1:GameObject, param2:ColorTransform = null) : void {
			var loc3:Boolean = false;
			loc3 = this.isClear();
			this.go = param1;
			visible = param1 != null;
			if(visible && (this.hasChanged() || loc3)) {
				this.redraw();
				transform.colorTransform = param2 || MoreColorUtil.identity;
			}
		}
		
		public function clear() : void {
			this.go = null;
			visible = false;
		}
		
		public function isClear() : Boolean {
			return this.go == null && visible == false;
		}
		
		private function hasChanged() : Boolean {
			var loc1:Boolean = this.go.name_ != this.objname || this.go.level_ != this.level || this.go.objectType_ != this.type;
			loc1 && this.updateData();
			return loc1;
		}
		
		private function updateData() : void {
			this.objname = this.go.name_;
			this.level = this.go.level_;
			this.type = this.go.objectType_;
		}
		
		private function redraw() : void {
			this.portrait.bitmapData = this.go.getPortrait();
			this.text.setStringBuilder(this.prepareText());
			this.text.setColor(this.getDrawColor());
			this.text.update();
		}
		
		private function prepareText() : TemplateBuilder {
			this.builder = this.builder || new TemplateBuilder();
			if(this.isLongVersion) {
				this.applyLongTextToBuilder();
			} else if(this.isNameDefined()) {
				this.builder.setTemplate(this.objname);
			} else {
				this.builder.setTemplate(ObjectLibrary.typeToDisplayId_[this.type]);
			}
			return this.builder;
		}
		
		private function applyLongTextToBuilder() : void {
			var loc1:String = null;
			var loc2:Object = {};
			if(this.isNameDefined()) {
				if(this.positionClassBelow) {
					loc1 = "<b>{name}</b>\n({type}{level})";
				} else {
					loc1 = "<b>{name}</b> ({type}{level})";
				}
				loc2.name = this.go.name_;
				loc2.type = ObjectLibrary.typeToDisplayId_[this.type];
				loc2.level = this.level < 1?"":" " + this.level;
			} else {
				loc1 = "<b>{name}</b>";
				loc2.name = ObjectLibrary.typeToDisplayId_[this.type];
			}
			this.builder.setTemplate(loc1,loc2);
		}
		
		private function isNameDefined() : Boolean {
			return this.go.name_ != null && this.go.name_ != "";
		}
		
		private function getDrawColor() : int {
			var loc1:Player = this.go as Player;
			if(loc1) {
				return PlayerUtil.getPlayerNameColor(loc1);
			}
			return this.color;
		}
	}
}
