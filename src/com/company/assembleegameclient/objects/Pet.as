 
package com.company.assembleegameclient.objects {
	import com.company.assembleegameclient.game.GameSprite;
	import com.company.assembleegameclient.ui.panels.Panel;
	import com.company.assembleegameclient.ui.tooltip.TextToolTip;
	import com.company.assembleegameclient.ui.tooltip.ToolTip;
	import com.company.assembleegameclient.util.AnimatedChar;
	import com.company.assembleegameclient.util.AnimatedChars;
	import com.company.assembleegameclient.util.MaskedImage;
	import io.decagames.rotmg.pets.data.PetsModel;
	import io.decagames.rotmg.pets.data.vo.PetVO;
	import io.decagames.rotmg.pets.panels.PetPanel;
	import kabam.rotmg.core.StaticInjectorContext;
	import kabam.rotmg.game.signals.TextPanelMessageUpdateSignal;
	import kabam.rotmg.text.model.TextKey;
	
	public class Pet extends GameObject implements IInteractiveObject {
		 
		
		private var textPanelUpdateSignal:TextPanelMessageUpdateSignal;
		
		public var vo:PetVO;
		
		public var skin:AnimatedChar;
		
		public var defaultSkin:AnimatedChar;
		
		public var skinId:int;
		
		public var isDefaultAnimatedChar:Boolean = false;
		
		private var petsModel:PetsModel;
		
		public function Pet(param1:XML) {
			super(param1);
			isInteractive_ = true;
			this.textPanelUpdateSignal = StaticInjectorContext.getInjector().getInstance(TextPanelMessageUpdateSignal);
			this.petsModel = StaticInjectorContext.getInjector().getInstance(PetsModel);
			this.petsModel.getActivePet();
		}
		
		public function getTooltip() : ToolTip {
			var loc1:ToolTip = new TextToolTip(3552822,10197915,TextKey.CLOSEDGIFTCHEST_TITLE,TextKey.TEXTPANEL_GIFTCHESTISEMPTY,200);
			return loc1;
		}
		
		public function getPanel(param1:GameSprite) : Panel {
			return new PetPanel(param1,this.vo);
		}
		
		public function setSkin(param1:int) : void {
			var loc5:MaskedImage = null;
			this.skinId = param1;
			var loc2:XML = ObjectLibrary.getXMLfromId(ObjectLibrary.getIdFromType(param1));
			var loc3:String = loc2.AnimatedTexture.File;
			var loc4:int = loc2.AnimatedTexture.Index;
			if(this.skin == null) {
				this.isDefaultAnimatedChar = true;
				this.skin = AnimatedChars.getAnimatedChar(loc3,loc4);
				this.defaultSkin = this.skin;
			} else {
				this.skin = AnimatedChars.getAnimatedChar(loc3,loc4);
			}
			this.isDefaultAnimatedChar = this.skin == this.defaultSkin;
			loc5 = this.skin.imageFromAngle(0,AnimatedChar.STAND,0);
			animatedChar_ = this.skin;
			texture_ = loc5.image_;
			mask_ = loc5.mask_;
			var loc6:ObjectProperties = ObjectLibrary.getPropsFromId(loc2.DisplayId);
			if(loc6) {
				props_.flying_ = loc6.flying_;
				props_.whileMoving_ = loc6.whileMoving_;
				flying_ = props_.flying_;
				z_ = props_.z_;
			}
		}
		
		public function setDefaultSkin() : void {
			var loc1:MaskedImage = null;
			this.skinId = -1;
			if(this.defaultSkin == null) {
				return;
			}
			loc1 = this.defaultSkin.imageFromAngle(0,AnimatedChar.STAND,0);
			this.isDefaultAnimatedChar = true;
			animatedChar_ = this.defaultSkin;
			texture_ = loc1.image_;
			mask_ = loc1.mask_;
		}
	}
}
