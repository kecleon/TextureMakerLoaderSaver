 
package kabam.rotmg.classes.view {
	import com.company.assembleegameclient.util.FameUtil;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import kabam.rotmg.assets.model.Animation;
	import kabam.rotmg.assets.services.CharacterFactory;
	import kabam.rotmg.classes.control.FocusCharacterSkinSignal;
	import kabam.rotmg.classes.model.CharacterClass;
	import kabam.rotmg.classes.model.CharacterSkin;
	import kabam.rotmg.classes.model.ClassesModel;
	import kabam.rotmg.core.model.PlayerModel;
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	public class ClassDetailMediator extends Mediator {
		 
		
		[Inject]
		public var view:ClassDetailView;
		
		[Inject]
		public var classesModel:ClassesModel;
		
		[Inject]
		public var playerModel:PlayerModel;
		
		[Inject]
		public var focusSet:FocusCharacterSkinSignal;
		
		[Inject]
		public var factory:CharacterFactory;
		
		private const skins:Object = new Object();
		
		private var character:CharacterClass;
		
		private var nextSkin:CharacterSkin;
		
		private const nextSkinTimer:Timer = new Timer(250,1);
		
		public function ClassDetailMediator() {
			super();
		}
		
		override public function initialize() : void {
			this.character = this.classesModel.getSelected();
			this.nextSkinTimer.addEventListener(TimerEvent.TIMER,this.delayedFocusSet);
			this.focusSet.add(this.onFocusSet);
			this.setCharacterData();
			this.onFocusSet();
		}
		
		override public function destroy() : void {
			this.focusSet.remove(this.onFocusSet);
			this.nextSkinTimer.removeEventListener(TimerEvent.TIMER,this.delayedFocusSet);
			this.view.setWalkingAnimation(null);
			this.disposeAnimations();
		}
		
		private function setCharacterData() : void {
			var loc1:int = this.playerModel.charList.bestFame(this.character.id);
			var loc2:int = FameUtil.numStars(loc1);
			this.view.setData(this.character.name,this.character.description,loc2,this.playerModel.charList.bestLevel(this.character.id),loc1);
			var loc3:int = FameUtil.nextStarFame(loc1,0);
			this.view.setNextGoal(this.character.name,loc3);
		}
		
		private function onFocusSet(param1:CharacterSkin = null) : void {
			this.nextSkin = param1 = param1 || this.character.skins.getSelectedSkin();
			this.nextSkinTimer.start();
		}
		
		private function delayedFocusSet(param1:TimerEvent) : void {
			var loc2:Animation = this.skins[this.nextSkin.id] = this.skins[this.nextSkin.id] || this.factory.makeWalkingIcon(this.nextSkin.template,!!this.nextSkin.is16x16?100:200);
			this.view.setWalkingAnimation(loc2);
		}
		
		private function disposeAnimations() : void {
			var loc1:* = null;
			var loc2:Animation = null;
			for(loc1 in this.skins) {
				loc2 = this.skins[loc1];
				loc2.dispose();
				delete this.skins[loc1];
			}
		}
	}
}
