package kabam.rotmg.account.web.commands {
	import com.company.assembleegameclient.game.GameSprite;
	import com.company.assembleegameclient.screens.CharacterSelectionAndNewsScreen;

	import flash.display.Sprite;

	import kabam.lib.tasks.BranchingTask;
	import kabam.lib.tasks.DispatchSignalTask;
	import kabam.lib.tasks.TaskMonitor;
	import kabam.lib.tasks.TaskSequence;
	import kabam.rotmg.account.core.services.LoginTask;
	import kabam.rotmg.account.core.signals.UpdateAccountInfoSignal;
	import kabam.rotmg.account.web.model.AccountData;
	import kabam.rotmg.core.model.ScreenModel;
	import kabam.rotmg.core.service.TrackingData;
	import kabam.rotmg.core.signals.InvalidateDataSignal;
	import kabam.rotmg.core.signals.SetScreenWithValidDataSignal;
	import kabam.rotmg.core.signals.TaskErrorSignal;
	import kabam.rotmg.core.signals.TrackEventSignal;
	import kabam.rotmg.dialogs.control.CloseDialogsSignal;
	import kabam.rotmg.mysterybox.services.GetMysteryBoxesTask;
	import kabam.rotmg.packages.services.GetPackagesTask;

	public class WebLoginCommand {


		[Inject]
		public var data:AccountData;

		[Inject]
		public var loginTask:LoginTask;

		[Inject]
		public var monitor:TaskMonitor;

		[Inject]
		public var closeDialogs:CloseDialogsSignal;

		[Inject]
		public var loginError:TaskErrorSignal;

		[Inject]
		public var updateLogin:UpdateAccountInfoSignal;

		[Inject]
		public var track:TrackEventSignal;

		[Inject]
		public var invalidate:InvalidateDataSignal;

		[Inject]
		public var setScreenWithValidData:SetScreenWithValidDataSignal;

		[Inject]
		public var screenModel:ScreenModel;

		[Inject]
		public var getPackageTask:GetPackagesTask;

		[Inject]
		public var mysteryBoxTask:GetMysteryBoxesTask;

		private var setScreenTask:DispatchSignalTask;

		public function WebLoginCommand() {
			super();
		}

		public function execute():void {
			this.setScreenTask = new DispatchSignalTask(this.setScreenWithValidData, this.getTargetScreen());
			var loc1:BranchingTask = new BranchingTask(this.loginTask, this.makeSuccessTask(), this.makeFailureTask());
			this.monitor.add(loc1);
			loc1.start();
		}

		private function makeSuccessTask():TaskSequence {
			var loc1:TaskSequence = new TaskSequence();
			loc1.add(new DispatchSignalTask(this.closeDialogs));
			loc1.add(new DispatchSignalTask(this.updateLogin));
			loc1.add(new DispatchSignalTask(this.invalidate));
			loc1.add(this.getPackageTask);
			loc1.add(this.mysteryBoxTask);
			loc1.add(this.setScreenTask);
			return loc1;
		}

		private function makeFailureTask():TaskSequence {
			var loc1:TaskSequence = new TaskSequence();
			loc1.add(new DispatchSignalTask(this.loginError, this.loginTask));
			loc1.add(this.setScreenTask);
			return loc1;
		}

		private function getTargetScreen():Sprite {
			var loc1:Class = this.screenModel.getCurrentScreenType();
			if (loc1 == null || loc1 == GameSprite) {
				loc1 = CharacterSelectionAndNewsScreen;
			}
			return new loc1();
		}

		private function getTrackingData():TrackingData {
			var loc1:TrackingData = new TrackingData();
			loc1.category = "account";
			loc1.action = "signedIn";
			return loc1;
		}
	}
}
