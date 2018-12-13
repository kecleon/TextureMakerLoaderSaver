 
package com.company.assembleegameclient.screens {
	import com.company.assembleegameclient.appengine.SavedCharactersList;
	import com.company.assembleegameclient.constants.ScreenTypes;
	import com.company.assembleegameclient.objects.ObjectLibrary;
	import com.company.rotmg.graphics.ScreenGraphic;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import kabam.rotmg.core.StaticInjectorContext;
	import kabam.rotmg.core.model.PlayerModel;
	import kabam.rotmg.core.service.GoogleAnalytics;
	import kabam.rotmg.game.view.CreditDisplay;
	import kabam.rotmg.text.view.TextFieldDisplayConcrete;
	import kabam.rotmg.ui.view.components.ScreenBase;
	import org.osflash.signals.Signal;
	
	public class NewCharacterScreen extends Sprite {
		 
		
		public var tooltip:Signal;
		
		public var close:Signal;
		
		public var selected:Signal;
		
		private var backButton_:TitleMenuOption;
		
		private var creditDisplay_:CreditDisplay;
		
		private var boxes_:Object;
		
		private var isInitialized:Boolean = false;
		
		public function NewCharacterScreen() {
			this.boxes_ = {};
			super();
			this.tooltip = new Signal(Sprite);
			this.selected = new Signal(int);
			this.close = new Signal();
			addChild(new ScreenBase());
			addChild(new AccountScreen());
			addChild(new ScreenGraphic());
		}
		
		public function initialize(param1:PlayerModel) : void {
			var loc2:int = 0;
			var loc4:XML = null;
			var loc5:int = 0;
			var loc6:String = null;
			var loc7:Boolean = false;
			var loc8:CharacterBox = null;
			if(this.isInitialized) {
				return;
			}
			this.isInitialized = true;
			this.backButton_ = new TitleMenuOption(ScreenTypes.BACK,36,false);
			this.backButton_.addEventListener(MouseEvent.CLICK,this.onBackClick);
			this.backButton_.setVerticalAlign(TextFieldDisplayConcrete.MIDDLE);
			addChild(this.backButton_);
			this.creditDisplay_ = new CreditDisplay();
			this.creditDisplay_.draw(param1.getCredits(),param1.getFame());
			addChild(this.creditDisplay_);
			loc2 = 0;
			while(loc2 < ObjectLibrary.playerChars_.length) {
				loc4 = ObjectLibrary.playerChars_[loc2];
				loc5 = int(loc4.@type);
				loc6 = loc4.@id;
				if(!param1.isClassAvailability(loc6,SavedCharactersList.UNAVAILABLE)) {
					loc7 = param1.isClassAvailability(loc6,SavedCharactersList.UNRESTRICTED);
					loc8 = new CharacterBox(loc4,param1.getCharStats()[loc5],param1,loc7);
					loc8.x = 50 + 140 * int(loc2 % 5) + 70 - loc8.width / 2;
					loc8.y = 88 + 140 * int(loc2 / 5);
					this.boxes_[loc5] = loc8;
					loc8.addEventListener(MouseEvent.ROLL_OVER,this.onCharBoxOver);
					loc8.addEventListener(MouseEvent.ROLL_OUT,this.onCharBoxOut);
					loc8.characterSelectClicked_.add(this.onCharBoxClick);
					addChild(loc8);
				}
				loc2++;
			}
			this.backButton_.x = stage.stageWidth / 2 - this.backButton_.width / 2;
			this.backButton_.y = 550;
			this.creditDisplay_.x = stage.stageWidth;
			this.creditDisplay_.y = 20;
			var loc3:GoogleAnalytics = StaticInjectorContext.getInjector().getInstance(GoogleAnalytics);
			if(loc3) {
				loc3.trackPageView("/newCharScreen");
			}
		}
		
		private function onBackClick(param1:Event) : void {
			this.close.dispatch();
		}
		
		private function onCharBoxOver(param1:MouseEvent) : void {
			var loc2:CharacterBox = param1.currentTarget as CharacterBox;
			loc2.setOver(true);
			this.tooltip.dispatch(loc2.getTooltip());
		}
		
		private function onCharBoxOut(param1:MouseEvent) : void {
			var loc2:CharacterBox = param1.currentTarget as CharacterBox;
			loc2.setOver(false);
			this.tooltip.dispatch(null);
		}
		
		private function onCharBoxClick(param1:MouseEvent) : void {
			this.tooltip.dispatch(null);
			var loc2:CharacterBox = param1.currentTarget.parent as CharacterBox;
			if(!loc2.available_) {
				return;
			}
			var loc3:int = loc2.objectType();
			var loc4:String = ObjectLibrary.typeToDisplayId_[loc3];
			var loc5:GoogleAnalytics = StaticInjectorContext.getInjector().getInstance(GoogleAnalytics);
			if(!loc5) {
			}
			this.selected.dispatch(loc3);
		}
		
		public function updateCreditsAndFame(param1:int, param2:int) : void {
			this.creditDisplay_.draw(param1,param2);
		}
		
		public function update(param1:PlayerModel) : void {
			var loc3:XML = null;
			var loc4:int = 0;
			var loc5:String = null;
			var loc6:Boolean = false;
			var loc7:CharacterBox = null;
			var loc2:int = 0;
			while(loc2 < ObjectLibrary.playerChars_.length) {
				loc3 = ObjectLibrary.playerChars_[loc2];
				loc4 = int(loc3.@type);
				loc5 = String(loc3.@id);
				if(!param1.isClassAvailability(loc5,SavedCharactersList.UNAVAILABLE)) {
					loc6 = param1.isClassAvailability(loc5,SavedCharactersList.UNRESTRICTED);
					loc7 = this.boxes_[loc4];
					if(loc7) {
						if(loc6 || param1.isLevelRequirementsMet(loc4)) {
							loc7.unlock();
						}
					}
				}
				loc2++;
			}
		}
	}
}
