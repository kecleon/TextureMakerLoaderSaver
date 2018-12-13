 
package com.company.assembleegameclient.ui.panels {
	import com.company.assembleegameclient.game.GameSprite;
	import com.company.assembleegameclient.objects.Player;
	import com.company.assembleegameclient.parameters.Parameters;
	import com.company.assembleegameclient.ui.DeprecatedTextButton;
	import com.company.assembleegameclient.util.Currency;
	import com.company.assembleegameclient.util.GuildUtil;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextFieldAutoSize;
	import kabam.rotmg.text.model.TextKey;
	import kabam.rotmg.text.view.TextFieldDisplayConcrete;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;
	import kabam.rotmg.ui.view.SignalWaiter;
	import kabam.rotmg.util.components.LegacyBuyButton;
	import org.osflash.signals.Signal;
	
	public class GuildRegisterPanel extends Panel {
		 
		
		private var title_:TextFieldDisplayConcrete;
		
		private var button_:Sprite;
		
		public const openCreateGuildFrame:Signal = new Signal();
		
		public const waiter:SignalWaiter = new SignalWaiter();
		
		public const renounce:Signal = new Signal();
		
		public function GuildRegisterPanel(param1:GameSprite) {
			var loc2:Player = null;
			var loc3:String = null;
			var loc4:LegacyBuyButton = null;
			super(param1);
			if(gs_.map == null || gs_.map.player_ == null) {
				return;
			}
			loc2 = gs_.map.player_;
			this.title_ = new TextFieldDisplayConcrete().setSize(18).setColor(16777215).setTextWidth(WIDTH).setWordWrap(true).setMultiLine(true).setAutoSize(TextFieldAutoSize.CENTER).setHTML(true);
			this.title_.filters = [new DropShadowFilter(0,0,0)];
			if(loc2.guildName_ != null && loc2.guildName_.length > 0) {
				loc3 = GuildUtil.rankToString(loc2.guildRank_);
				this.title_.setStringBuilder(new LineBuilder().setParams(TextKey.GUILD_REGISTER_PANEL_RANK,{
					"rank":loc3,
					"guildName":loc2.guildName_
				}).setPrefix("<p align=\"center\">").setPostfix("</p>"));
				this.title_.y = 0;
				addChild(this.title_);
				this.button_ = new DeprecatedTextButton(16,TextKey.GUILD_REGISTER_PANEL_RENOUNCE);
				this.button_.addEventListener(MouseEvent.CLICK,this.onRenounceClick);
				this.waiter.push(DeprecatedTextButton(this.button_).textChanged);
				addChild(this.button_);
			} else {
				this.title_.setStringBuilder(new LineBuilder().setParams(TextKey.GUILD_REGISTER_PANEL_CREATE).setPrefix("<p align=\"center\">").setPostfix("</p>"));
				this.title_.y = 0;
				addChild(this.title_);
				loc4 = new LegacyBuyButton(TextKey.GUILD_REGISTER_PANEL_BUY,16,Parameters.GUILD_CREATION_PRICE,Currency.FAME);
				loc4.addEventListener(MouseEvent.CLICK,this.onCreateClick);
				this.waiter.push(loc4.readyForPlacement);
				addChild(loc4);
				this.button_ = loc4;
			}
			this.waiter.complete.addOnce(this.alignUI);
		}
		
		private function onRenounceClick(param1:MouseEvent) : void {
			this.renounce.dispatch();
		}
		
		private function alignUI() : void {
			this.button_.x = WIDTH / 2 - this.button_.width / 2;
			this.button_.y = this.button_ is LegacyBuyButton?Number(HEIGHT - this.button_.height / 2 - 31):Number(HEIGHT - this.button_.height - 4);
		}
		
		public function onCreateClick(param1:MouseEvent) : void {
			visible = false;
			this.openCreateGuildFrame.dispatch();
		}
	}
}
