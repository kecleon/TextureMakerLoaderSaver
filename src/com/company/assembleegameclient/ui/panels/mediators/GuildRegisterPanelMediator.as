 
package com.company.assembleegameclient.ui.panels.mediators {
	import com.company.assembleegameclient.account.ui.CreateGuildFrame;
	import com.company.assembleegameclient.game.GameSprite;
	import com.company.assembleegameclient.objects.Player;
	import com.company.assembleegameclient.ui.dialogs.Dialog;
	import com.company.assembleegameclient.ui.panels.GuildRegisterPanel;
	import flash.events.Event;
	import kabam.rotmg.dialogs.control.CloseDialogsSignal;
	import kabam.rotmg.dialogs.control.OpenDialogSignal;
	import kabam.rotmg.text.model.TextKey;
	import kabam.rotmg.ui.model.HUDModel;
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	public class GuildRegisterPanelMediator extends Mediator {
		 
		
		[Inject]
		public var view:GuildRegisterPanel;
		
		[Inject]
		public var openDialog:OpenDialogSignal;
		
		[Inject]
		public var closeDialog:CloseDialogsSignal;
		
		[Inject]
		public var hudModel:HUDModel;
		
		public function GuildRegisterPanelMediator() {
			super();
		}
		
		override public function initialize() : void {
			this.view.openCreateGuildFrame.add(this.onDispatchCreateGuildFrame);
			this.view.renounce.add(this.onRenounceClick);
		}
		
		override public function destroy() : void {
			this.view.openCreateGuildFrame.remove(this.onDispatchCreateGuildFrame);
			this.view.renounce.remove(this.onRenounceClick);
		}
		
		private function onDispatchCreateGuildFrame() : void {
			this.openDialog.dispatch(new CreateGuildFrame(this.hudModel.gameSprite));
		}
		
		public function onRenounceClick() : void {
			var loc1:GameSprite = this.hudModel.gameSprite;
			if(loc1.map == null || loc1.map.player_ == null) {
				return;
			}
			var loc2:Player = loc1.map.player_;
			var loc3:Dialog = new Dialog(TextKey.RENOUNCE_DIALOG_SUBTITLE,TextKey.RENOUNCE_DIALOG_TITLE,TextKey.RENOUNCE_DIALOG_CANCEL,TextKey.RENOUNCE_DIALOG_ACCEPT,"/renounceGuild");
			loc3.setTextParams(TextKey.RENOUNCE_DIALOG_TITLE,{"guildName":loc2.guildName_});
			loc3.addEventListener(Dialog.LEFT_BUTTON,this.onRenounce);
			loc3.addEventListener(Dialog.RIGHT_BUTTON,this.onCancel);
			this.openDialog.dispatch(loc3);
		}
		
		private function onCancel(param1:Event) : void {
			this.closeDialog.dispatch();
		}
		
		private function onRenounce(param1:Event) : void {
			var loc2:GameSprite = this.hudModel.gameSprite;
			if(loc2.map == null || loc2.map.player_ == null) {
				return;
			}
			var loc3:Player = loc2.map.player_;
			loc2.gsc_.guildRemove(loc3.name_);
			this.closeDialog.dispatch();
		}
	}
}
