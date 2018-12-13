package com.company.assembleegameclient.ui.panels.mediators {
	import com.company.assembleegameclient.ui.dialogs.Dialog;
	import com.company.assembleegameclient.ui.panels.ArenaPortalPanel;
	import com.company.assembleegameclient.util.Currency;

	import flash.events.Event;

	import kabam.lib.net.api.MessageProvider;
	import kabam.lib.net.impl.SocketServer;
	import kabam.rotmg.account.core.Account;
	import kabam.rotmg.account.core.view.RegisterPromptDialog;
	import kabam.rotmg.arena.model.CurrentArenaRunModel;
	import kabam.rotmg.arena.service.GetBestArenaRunTask;
	import kabam.rotmg.dialogs.control.CloseDialogsSignal;
	import kabam.rotmg.dialogs.control.OpenDialogSignal;
	import kabam.rotmg.game.model.GameModel;
	import kabam.rotmg.game.signals.ExitGameSignal;
	import kabam.rotmg.messaging.impl.GameServerConnection;
	import kabam.rotmg.messaging.impl.outgoing.arena.EnterArena;
	import kabam.rotmg.text.model.TextKey;
	import kabam.rotmg.ui.view.NotEnoughGoldDialog;

	import org.swiftsuspenders.Injector;

	import robotlegs.bender.bundles.mvcs.Mediator;

	public class ArenaPortalPanelMediator extends Mediator {

		public static const TEXT:String = "SellableObjectPanelMediator.text";


		[Inject]
		public var view:ArenaPortalPanel;

		[Inject]
		public var socketServer:SocketServer;

		[Inject]
		public var messages:MessageProvider;

		[Inject]
		public var openDialog:OpenDialogSignal;

		[Inject]
		public var closeDialog:CloseDialogsSignal;

		[Inject]
		public var gameModel:GameModel;

		[Inject]
		public var currentRunModel:CurrentArenaRunModel;

		[Inject]
		public var injector:Injector;

		[Inject]
		public var exitSignal:ExitGameSignal;

		[Inject]
		public var account:Account;

		private var dialog:Dialog;

		public function ArenaPortalPanelMediator() {
			super();
		}

		override public function initialize():void {
			this.view.purchase.add(this.onPurchase);
		}

		private function onPurchase(param1:int):void {
			if (param1 == Currency.GOLD) {
				this.purchaseWithGold();
			} else {
				this.purchaseWithFame();
			}
		}

		private function purchaseWithFame():void {
			var loc1:GetBestArenaRunTask = null;
			var loc2:EnterArena = null;
			if (this.gameModel.player.nameChosen_) {
				this.currentRunModel.saveCurrentUserInfo();
				loc1 = this.injector.getInstance(GetBestArenaRunTask);
				loc1.start();
				loc2 = this.messages.require(GameServerConnection.ENTER_ARENA) as EnterArena;
				loc2.currency = Currency.FAME;
				this.socketServer.sendMessage(loc2);
				this.exitSignal.dispatch();
			} else {
				this.dialog = new Dialog(TextKey.MUST_BE_NAMED_TITLE, TextKey.MUST_BE_NAMED_DESC, TextKey.ERRORDIALOG_OK, null, null);
				this.dialog.addEventListener(Dialog.LEFT_BUTTON, this.onNoNameDialogClose);
				this.openDialog.dispatch(this.dialog);
			}
		}

		private function purchaseWithGold():void {
			var loc1:GetBestArenaRunTask = null;
			var loc2:EnterArena = null;
			if (!this.account.isRegistered()) {
				this.openDialog.dispatch(new RegisterPromptDialog(TEXT, {"type": Currency.typeToName(Currency.GOLD)}));
			} else if (!this.gameModel.player.nameChosen_) {
				this.dialog = new Dialog(TextKey.MUST_BE_NAMED_TITLE, TextKey.MUST_BE_NAMED_DESC, TextKey.ERRORDIALOG_OK, null, null);
				this.dialog.addEventListener(Dialog.LEFT_BUTTON, this.onNoNameDialogClose);
				this.openDialog.dispatch(this.dialog);
			} else if (this.gameModel.player.credits_ < 50) {
				this.openDialog.dispatch(new NotEnoughGoldDialog());
			} else {
				this.currentRunModel.saveCurrentUserInfo();
				loc1 = this.injector.getInstance(GetBestArenaRunTask);
				loc1.start();
				loc2 = this.messages.require(GameServerConnection.ENTER_ARENA) as EnterArena;
				loc2.currency = Currency.GOLD;
				this.socketServer.sendMessage(loc2);
				this.exitSignal.dispatch();
			}
		}

		private function onNoNameDialogClose(param1:Event):void {
			if (this.dialog && this.dialog.hasEventListener(Dialog.LEFT_BUTTON)) {
				this.dialog.removeEventListener(Dialog.LEFT_BUTTON, this.onNoNameDialogClose);
			}
			this.dialog = null;
			this.closeDialog.dispatch();
		}
	}
}
