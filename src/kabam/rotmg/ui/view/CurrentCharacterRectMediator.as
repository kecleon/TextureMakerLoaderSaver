 
package kabam.rotmg.ui.view {
	import com.company.assembleegameclient.appengine.SavedCharacter;
	import com.company.assembleegameclient.screens.charrects.CurrentCharacterRect;
	import flash.display.Sprite;
	import kabam.rotmg.characters.deletion.view.ConfirmDeleteCharacterDialog;
	import kabam.rotmg.characters.model.CharacterModel;
	import kabam.rotmg.classes.model.CharacterClass;
	import kabam.rotmg.classes.model.ClassesModel;
	import kabam.rotmg.core.service.TrackingData;
	import kabam.rotmg.core.signals.HideTooltipsSignal;
	import kabam.rotmg.core.signals.ShowTooltipSignal;
	import kabam.rotmg.core.signals.TrackEventSignal;
	import kabam.rotmg.dialogs.control.OpenDialogSignal;
	import kabam.rotmg.game.model.GameInitData;
	import kabam.rotmg.game.signals.PlayGameSignal;
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	public class CurrentCharacterRectMediator extends Mediator {
		 
		
		[Inject]
		public var view:CurrentCharacterRect;
		
		[Inject]
		public var track:TrackEventSignal;
		
		[Inject]
		public var playGame:PlayGameSignal;
		
		[Inject]
		public var model:CharacterModel;
		
		[Inject]
		public var classesModel:ClassesModel;
		
		[Inject]
		public var openDialog:OpenDialogSignal;
		
		[Inject]
		public var showTooltip:ShowTooltipSignal;
		
		[Inject]
		public var hideTooltips:HideTooltipsSignal;
		
		public function CurrentCharacterRectMediator() {
			super();
		}
		
		override public function initialize() : void {
			this.view.selected.add(this.onSelected);
			this.view.deleteCharacter.add(this.onDeleteCharacter);
			this.view.showToolTip.add(this.onShow);
			this.view.hideTooltip.add(this.onHide);
		}
		
		private function onShow(param1:Sprite) : void {
			this.showTooltip.dispatch(param1);
		}
		
		private function onHide() : void {
			this.hideTooltips.dispatch();
		}
		
		override public function destroy() : void {
			this.view.hideTooltip.remove(this.onHide);
			this.view.showToolTip.remove(this.onShow);
			this.view.selected.remove(this.onSelected);
			this.view.deleteCharacter.remove(this.onDeleteCharacter);
		}
		
		private function onSelected(param1:SavedCharacter) : void {
			var loc2:CharacterClass = this.classesModel.getCharacterClass(param1.objectType());
			loc2.setIsSelected(true);
			loc2.skins.getSkin(param1.skinType()).setIsSelected(true);
			this.trackCharacterSelection(param1);
			this.launchGame(param1);
		}
		
		private function trackCharacterSelection(param1:SavedCharacter) : void {
			var loc2:TrackingData = new TrackingData();
			loc2.category = "character";
			loc2.action = "select";
			loc2.label = param1.displayId();
			loc2.value = param1.level();
		}
		
		private function launchGame(param1:SavedCharacter) : void {
			var loc2:GameInitData = new GameInitData();
			loc2.createCharacter = false;
			loc2.charId = param1.charId();
			loc2.isNewGame = true;
			this.playGame.dispatch(loc2);
		}
		
		private function onDeleteCharacter(param1:SavedCharacter) : void {
			this.model.select(param1);
			this.openDialog.dispatch(new ConfirmDeleteCharacterDialog());
		}
	}
}
