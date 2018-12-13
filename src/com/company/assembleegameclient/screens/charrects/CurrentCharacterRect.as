 
package com.company.assembleegameclient.screens.charrects {
	import com.company.assembleegameclient.appengine.CharacterStats;
	import com.company.assembleegameclient.appengine.SavedCharacter;
	import com.company.assembleegameclient.screens.events.DeleteCharacterEvent;
	import com.company.assembleegameclient.ui.tooltip.MyPlayerToolTip;
	import com.company.assembleegameclient.ui.tooltip.TextToolTip;
	import com.company.assembleegameclient.util.FameUtil;
	import com.company.rotmg.graphics.DeleteXGraphic;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import io.decagames.rotmg.fame.FameContentPopup;
	import io.decagames.rotmg.pets.data.vo.PetVO;
	import io.decagames.rotmg.ui.popups.signals.ShowPopupSignal;
	import kabam.rotmg.assets.services.IconFactory;
	import kabam.rotmg.classes.model.CharacterClass;
	import kabam.rotmg.core.StaticInjectorContext;
	import kabam.rotmg.text.model.TextKey;
	import kabam.rotmg.text.view.TextFieldDisplayConcrete;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;
	import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
	import org.osflash.signals.Signal;
	import org.swiftsuspenders.Injector;
	
	public class CurrentCharacterRect extends CharacterRect {
		
		private static var toolTip_:MyPlayerToolTip = null;
		
		private static var fameToolTip:TextToolTip = null;
		 
		
		public const selected:Signal = new Signal();
		
		public const deleteCharacter:Signal = new Signal();
		
		public const showToolTip:Signal = new Signal(Sprite);
		
		public const hideTooltip:Signal = new Signal();
		
		public var charName:String;
		
		public var charStats:CharacterStats;
		
		public var char:SavedCharacter;
		
		public var myPlayerToolTipFactory:MyPlayerToolTipFactory;
		
		private var charType:CharacterClass;
		
		private var deleteButton:Sprite;
		
		private var icon:DisplayObject;
		
		private var petIcon:Bitmap;
		
		private var fameBitmap:Bitmap;
		
		private var fameBitmapContainer:Sprite;
		
		protected var statsMaxedText:TextFieldDisplayConcrete;
		
		public function CurrentCharacterRect(param1:String, param2:CharacterClass, param3:SavedCharacter, param4:CharacterStats) {
			this.myPlayerToolTipFactory = new MyPlayerToolTipFactory();
			super();
			this.charName = param1;
			this.charType = param2;
			this.char = param3;
			this.charStats = param4;
			var loc5:String = param2.name;
			var loc6:int = param3.charXML_.Level;
			super.className = new LineBuilder().setParams(TextKey.CURRENT_CHARACTER_DESCRIPTION,{
				"className":loc5,
				"level":loc6
			});
			super.color = 6052956;
			super.overColor = 8355711;
			super.init();
			this.makeTagline();
			this.makeDeleteButton();
			this.makePetIcon();
			this.makeStatsMaxedText();
			this.makeFameUIIcon();
			this.addEventListeners();
		}
		
		private function addEventListeners() : void {
			addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
			selectContainer.addEventListener(MouseEvent.CLICK,this.onSelect);
			this.fameBitmapContainer.addEventListener(MouseEvent.CLICK,this.onFameClick);
			this.deleteButton.addEventListener(MouseEvent.CLICK,this.onDelete);
		}
		
		private function onSelect(param1:MouseEvent) : void {
			this.selected.dispatch(this.char);
		}
		
		private function onFameClick(param1:MouseEvent) : void {
			var loc2:Injector = StaticInjectorContext.getInjector();
			var loc3:ShowPopupSignal = loc2.getInstance(ShowPopupSignal);
			loc3.dispatch(new FameContentPopup(this.char.charId()));
		}
		
		private function onDelete(param1:MouseEvent) : void {
			this.deleteCharacter.dispatch(this.char);
		}
		
		public function setIcon(param1:DisplayObject) : void {
			this.icon && selectContainer.removeChild(this.icon);
			this.icon = param1;
			this.icon.x = CharacterRectConstants.ICON_POS_X;
			this.icon.y = CharacterRectConstants.ICON_POS_Y;
			this.icon && selectContainer.addChild(this.icon);
		}
		
		private function makePetIcon() : void {
			var loc1:PetVO = this.char.getPetVO();
			if(loc1) {
				this.petIcon = loc1.getSkinBitmap();
				if(this.petIcon == null) {
					return;
				}
				this.petIcon.x = CharacterRectConstants.PET_ICON_POS_X;
				this.petIcon.y = CharacterRectConstants.PET_ICON_POS_Y;
				selectContainer.addChild(this.petIcon);
			}
		}
		
		private function makeTagline() : void {
			if(this.getNextStarFame() > 0) {
				super.makeTaglineIcon();
				super.makeTaglineText(new LineBuilder().setParams(TextKey.CURRENT_CHARACTER_TAGLINE,{
					"fame":this.char.fame(),
					"nextStarFame":this.getNextStarFame()
				}));
				taglineText.x = taglineText.x + taglineIcon.width;
			} else {
				super.makeTaglineIcon();
				super.makeTaglineText(new LineBuilder().setParams(TextKey.CURRENT_CHARACTER_TAGLINE_NOQUEST,{"fame":this.char.fame()}));
				taglineText.x = taglineText.x + taglineIcon.width;
			}
		}
		
		private function getNextStarFame() : int {
			return FameUtil.nextStarFame(this.charStats == null?0:int(this.charStats.bestFame()),this.char.fame());
		}
		
		private function makeDeleteButton() : void {
			this.deleteButton = new DeleteXGraphic();
			this.deleteButton.addEventListener(MouseEvent.MOUSE_DOWN,this.onDeleteDown);
			this.deleteButton.x = WIDTH - 30;
			this.deleteButton.y = (HEIGHT - this.deleteButton.height) * 0.5;
			addChild(this.deleteButton);
		}
		
		private function makeStatsMaxedText() : void {
			var loc1:int = this.getMaxedStats();
			var loc2:uint = 11776947;
			if(loc1 >= 8) {
				loc2 = 16572160;
			}
			this.statsMaxedText = new TextFieldDisplayConcrete().setSize(18).setColor(16777215);
			this.statsMaxedText.setBold(true);
			this.statsMaxedText.setColor(loc2);
			this.statsMaxedText.setStringBuilder(new StaticStringBuilder(loc1 + "/8"));
			this.statsMaxedText.filters = makeDropShadowFilter();
			this.statsMaxedText.x = CharacterRectConstants.STATS_MAXED_POS_X;
			this.statsMaxedText.y = CharacterRectConstants.STATS_MAXED_POS_Y;
			selectContainer.addChild(this.statsMaxedText);
		}
		
		private function makeFameUIIcon() : void {
			var loc1:BitmapData = IconFactory.makeFame();
			this.fameBitmap = new Bitmap(loc1);
			this.fameBitmapContainer = new Sprite();
			this.fameBitmapContainer.name = "fame_ui";
			this.fameBitmapContainer.addChild(this.fameBitmap);
			this.fameBitmapContainer.x = CharacterRectConstants.FAME_UI_POS_X;
			this.fameBitmapContainer.y = CharacterRectConstants.FAME_UI_POS_Y;
			addChild(this.fameBitmapContainer);
		}
		
		private function getMaxedStats() : int {
			var loc1:int = 0;
			if(this.char.hp() == this.charType.hp.max) {
				loc1++;
			}
			if(this.char.mp() == this.charType.mp.max) {
				loc1++;
			}
			if(this.char.att() == this.charType.attack.max) {
				loc1++;
			}
			if(this.char.def() == this.charType.defense.max) {
				loc1++;
			}
			if(this.char.spd() == this.charType.speed.max) {
				loc1++;
			}
			if(this.char.dex() == this.charType.dexterity.max) {
				loc1++;
			}
			if(this.char.vit() == this.charType.hpRegeneration.max) {
				loc1++;
			}
			if(this.char.wis() == this.charType.mpRegeneration.max) {
				loc1++;
			}
			return loc1;
		}
		
		override protected function onMouseOver(param1:MouseEvent) : void {
			super.onMouseOver(param1);
			this.removeToolTip();
			if(param1.target.name == "fame_ui") {
				fameToolTip = new TextToolTip(3552822,10197915,"Fame","Click to get an Overview!",225);
				this.showToolTip.dispatch(fameToolTip);
			} else {
				toolTip_ = this.myPlayerToolTipFactory.create(this.charName,this.char.charXML_,this.charStats);
				toolTip_.createUI();
				this.showToolTip.dispatch(toolTip_);
			}
		}
		
		override protected function onRollOut(param1:MouseEvent) : void {
			super.onRollOut(param1);
			this.removeToolTip();
		}
		
		private function onRemovedFromStage(param1:Event) : void {
			this.removeToolTip();
			selectContainer.removeEventListener(MouseEvent.CLICK,this.onSelect);
			this.fameBitmapContainer.removeEventListener(MouseEvent.CLICK,this.onFameClick);
			this.deleteButton.removeEventListener(MouseEvent.CLICK,this.onDelete);
		}
		
		private function removeToolTip() : void {
			this.hideTooltip.dispatch();
		}
		
		private function onDeleteDown(param1:MouseEvent) : void {
			param1.stopImmediatePropagation();
			dispatchEvent(new DeleteCharacterEvent(this.char));
		}
	}
}
