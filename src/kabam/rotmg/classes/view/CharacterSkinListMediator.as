package kabam.rotmg.classes.view {
	import flash.display.DisplayObject;

	import kabam.rotmg.classes.model.CharacterClass;
	import kabam.rotmg.classes.model.ClassesModel;

	import robotlegs.bender.bundles.mvcs.Mediator;

	public class CharacterSkinListMediator extends Mediator {


		[Inject]
		public var view:CharacterSkinListView;

		[Inject]
		public var model:ClassesModel;

		[Inject]
		public var factory:CharacterSkinListItemFactory;

		public function CharacterSkinListMediator() {
			super();
		}

		override public function initialize():void {
			this.model.selected.add(this.setSkins);
			this.setSkins(this.model.getSelected());
		}

		override public function destroy():void {
			this.model.selected.remove(this.setSkins);
		}

		private function setSkins(param1:CharacterClass):void {
			var loc2:Vector.<DisplayObject> = this.factory.make(param1.skins);
			this.view.setItems(loc2);
		}
	}
}
