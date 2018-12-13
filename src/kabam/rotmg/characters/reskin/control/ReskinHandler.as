package kabam.rotmg.characters.reskin.control {
	import com.company.assembleegameclient.objects.Player;

	import kabam.rotmg.assets.services.CharacterFactory;
	import kabam.rotmg.classes.model.CharacterClass;
	import kabam.rotmg.classes.model.CharacterSkin;
	import kabam.rotmg.classes.model.ClassesModel;
	import kabam.rotmg.game.model.GameModel;
	import kabam.rotmg.messaging.impl.outgoing.Reskin;

	public class ReskinHandler {


		[Inject]
		public var model:GameModel;

		[Inject]
		public var classes:ClassesModel;

		[Inject]
		public var factory:CharacterFactory;

		public function ReskinHandler() {
			super();
		}

		public function execute(param1:Reskin):void {
			var loc2:Player = null;
			var loc3:int = 0;
			var loc4:CharacterClass = null;
			var loc5:CharacterClass = null;
			loc2 = param1.player || this.model.player;
			loc3 = param1.skinID;
			loc4 = this.classes.getCharacterClass(loc2.objectType_);
			loc5 = this.classes.getCharacterClass(65535);
			var loc6:CharacterSkin = loc5.skins.getSkin(loc3) || loc4.skins.getSkin(loc3);
			loc2.skinId = loc3;
			loc2.skin = this.factory.makeCharacter(loc6.template);
			loc2.isDefaultAnimatedChar = false;
		}
	}
}
