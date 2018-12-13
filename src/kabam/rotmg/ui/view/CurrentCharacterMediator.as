package kabam.rotmg.ui.view {
	import com.company.assembleegameclient.appengine.SavedCharacter;
	import com.company.assembleegameclient.parameters.Parameters;
	import com.company.assembleegameclient.screens.CharacterSelectionAndNewsScreen;
	import com.company.assembleegameclient.screens.NewCharacterScreen;
	import com.company.util.MoreDateUtil;

	import kabam.rotmg.account.securityQuestions.data.SecurityQuestionsModel;
	import kabam.rotmg.account.securityQuestions.view.SecurityQuestionsInfoDialog;
	import kabam.rotmg.classes.model.CharacterClass;
	import kabam.rotmg.classes.model.ClassesModel;
	import kabam.rotmg.core.model.PlayerModel;
	import kabam.rotmg.core.service.TrackingData;
	import kabam.rotmg.core.signals.SetScreenSignal;
	import kabam.rotmg.core.signals.TrackEventSignal;
	import kabam.rotmg.core.signals.TrackPageViewSignal;
	import kabam.rotmg.dialogs.control.OpenDialogSignal;
	import kabam.rotmg.game.model.GameInitData;
	import kabam.rotmg.game.signals.PlayGameSignal;
	import kabam.rotmg.packages.control.InitPackagesSignal;
	import kabam.rotmg.ui.signals.ChooseNameSignal;
	import kabam.rotmg.ui.signals.NameChangedSignal;

	import robotlegs.bender.bundles.mvcs.Mediator;

	public class CurrentCharacterMediator extends Mediator {


		[Inject]
		public var view:CharacterSelectionAndNewsScreen;

		[Inject]
		public var playerModel:PlayerModel;

		[Inject]
		public var classesModel:ClassesModel;

		[Inject]
		public var track:TrackEventSignal;

		[Inject]
		public var setScreen:SetScreenSignal;

		[Inject]
		public var playGame:PlayGameSignal;

		[Inject]
		public var chooseName:ChooseNameSignal;

		[Inject]
		public var nameChanged:NameChangedSignal;

		[Inject]
		public var trackPage:TrackPageViewSignal;

		[Inject]
		public var initPackages:InitPackagesSignal;

		[Inject]
		public var openDialog:OpenDialogSignal;

		[Inject]
		public var securityQuestionsModel:SecurityQuestionsModel;

		public function CurrentCharacterMediator() {
			super();
		}

		override public function initialize():void {
			this.trackSomething();
			this.view.initialize(this.playerModel);
			this.view.close.add(this.onClose);
			this.view.newCharacter.add(this.onNewCharacter);
			this.view.showClasses.add(this.onNewCharacter);
			this.view.chooseName.add(this.onChooseName);
			this.view.playGame.add(this.onPlayGame);
			this.trackPage.dispatch("/currentCharScreen");
			this.nameChanged.add(this.onNameChanged);
			this.initPackages.dispatch();
			if (this.securityQuestionsModel.showSecurityQuestionsOnStartup) {
				this.openDialog.dispatch(new SecurityQuestionsInfoDialog());
			}
		}

		override public function destroy():void {
			this.nameChanged.remove(this.onNameChanged);
			this.view.close.remove(this.onClose);
			this.view.newCharacter.remove(this.onNewCharacter);
			this.view.chooseName.remove(this.onChooseName);
			this.view.showClasses.remove(this.onNewCharacter);
			this.view.playGame.remove(this.onPlayGame);
		}

		private function onNameChanged(param1:String):void {
			this.view.setName(param1);
		}

		private function trackSomething():void {
			var loc2:TrackingData = null;
			var loc1:String = MoreDateUtil.getDayStringInPT();
			if (Parameters.data_.lastDailyAnalytics != loc1) {
				loc2 = new TrackingData();
				loc2.category = "joinDate";
				loc2.action = Parameters.data_.joinDate;
				Parameters.data_.lastDailyAnalytics = loc1;
				Parameters.save();
			}
		}

		private function onNewCharacter():void {
			this.setScreen.dispatch(new NewCharacterScreen());
		}

		private function onClose():void {
			this.setScreen.dispatch(new TitleView());
		}

		private function onChooseName():void {
			this.chooseName.dispatch();
		}

		private function onPlayGame():void {
			var loc1:SavedCharacter = this.playerModel.getCharacterByIndex(0);
			this.playerModel.currentCharId = loc1.charId();
			var loc2:CharacterClass = this.classesModel.getCharacterClass(loc1.objectType());
			loc2.setIsSelected(true);
			loc2.skins.getSkin(loc1.skinType()).setIsSelected(true);
			var loc3:TrackingData = new TrackingData();
			loc3.category = "character";
			loc3.action = "select";
			loc3.label = loc1.displayId();
			loc3.value = loc1.level();
			var loc4:GameInitData = new GameInitData();
			loc4.createCharacter = false;
			loc4.charId = loc1.charId();
			loc4.isNewGame = true;
			this.playGame.dispatch(loc4);
		}
	}
}
