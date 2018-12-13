 
package com.company.assembleegameclient.ui.panels {
	import com.company.assembleegameclient.game.GameSprite;
	import com.company.assembleegameclient.objects.ObjectLibrary;
	import com.company.assembleegameclient.objects.Portal;
	import com.company.assembleegameclient.objects.PortalNameParser;
	import com.company.assembleegameclient.parameters.Parameters;
	import com.company.assembleegameclient.tutorial.Tutorial;
	import com.company.assembleegameclient.tutorial.doneAction;
	import com.company.assembleegameclient.ui.DeprecatedTextButton;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	import kabam.rotmg.core.service.GoogleAnalytics;
	import kabam.rotmg.text.model.TextKey;
	import kabam.rotmg.text.view.TextFieldDisplayConcrete;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;
	import kabam.rotmg.text.view.stringBuilder.StringBuilder;
	import kabam.rotmg.ui.view.SignalWaiter;
	import org.osflash.signals.Signal;
	
	public class PortalPanel extends Panel {
		 
		
		private const LOCKED:String = "Locked ";
		
		private const TEXT_PATTERN:RegExp = /\{"text":"(.+)"}/;
		
		public var owner_:Portal;
		
		private var nameText_:TextFieldDisplayConcrete;
		
		private var enterButton_:DeprecatedTextButton;
		
		private var fullText_:TextFieldDisplayConcrete;
		
		public const exitGameSignal:Signal = new Signal();
		
		private const waiter:SignalWaiter = new SignalWaiter();
		
		public var googleAnalytics:GoogleAnalytics;
		
		public function PortalPanel(param1:GameSprite, param2:Portal) {
			super(param1);
			this.owner_ = param2;
			this.nameText_ = new TextFieldDisplayConcrete().setSize(18).setColor(16777215).setBold(true).setTextWidth(WIDTH).setWordWrap(true).setHorizontalAlign(TextFormatAlign.CENTER);
			this.nameText_.filters = [new DropShadowFilter(0,0,0)];
			addChild(this.nameText_);
			this.waiter.push(this.nameText_.textChanged);
			this.enterButton_ = new DeprecatedTextButton(16,TextKey.PANEL_ENTER);
			addChild(this.enterButton_);
			this.waiter.push(this.enterButton_.textChanged);
			this.fullText_ = new TextFieldDisplayConcrete().setSize(18).setColor(16711680).setHTML(true).setBold(true).setAutoSize(TextFieldAutoSize.CENTER);
			var loc3:String = !!this.owner_.lockedPortal_?TextKey.PORTAL_PANEL_LOCKED:TextKey.PORTAL_PANEL_FULL;
			this.fullText_.setStringBuilder(new LineBuilder().setParams(loc3).setPrefix("<p align=\"center\">").setPostfix("</p>"));
			this.fullText_.filters = [new DropShadowFilter(0,0,0)];
			this.fullText_.textChanged.addOnce(this.alignUI);
			addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
			this.waiter.complete.addOnce(this.alignUI);
		}
		
		private function alignUI() : void {
			this.nameText_.y = 6;
			this.enterButton_.x = WIDTH / 2 - this.enterButton_.width / 2;
			this.enterButton_.y = HEIGHT - this.enterButton_.height - 4;
			this.fullText_.y = HEIGHT - 30;
			this.fullText_.x = WIDTH / 2;
		}
		
		private function onAddedToStage(param1:Event) : void {
			this.enterButton_.addEventListener(MouseEvent.CLICK,this.onEnterSpriteClick);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
		}
		
		private function onRemovedFromStage(param1:Event) : void {
			stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
		}
		
		private function onEnterSpriteClick(param1:MouseEvent) : void {
			this.enterPortal();
		}
		
		private function onKeyDown(param1:KeyboardEvent) : void {
			if(param1.keyCode == Parameters.data_.interact && stage.focus == null) {
				this.enterPortal();
			}
		}
		
		private function enterPortal() : void {
			var loc1:String = ObjectLibrary.typeToDisplayId_[this.owner_.objectType_];
			if(this.googleAnalytics && (loc1 == "Kitchen Portal" || loc1 == "Vault Explanation" || loc1 == "Guild Explanation" || loc1 == "Nexus Explanation")) {
				this.googleAnalytics.trackEvent("enterPortal",loc1);
			}
			doneAction(gs_,Tutorial.ENTER_PORTAL_ACTION);
			gs_.gsc_.usePortal(this.owner_.objectId_);
			this.exitGameSignal.dispatch();
		}
		
		override public function draw() : void {
			this.updateNameText();
			if(!this.owner_.lockedPortal_ && this.owner_.active_ && contains(this.fullText_)) {
				removeChild(this.fullText_);
				addChild(this.enterButton_);
			} else if((this.owner_.lockedPortal_ || !this.owner_.active_) && contains(this.enterButton_)) {
				removeChild(this.enterButton_);
				addChild(this.fullText_);
			}
		}
		
		private function updateNameText() : void {
			var loc1:String = this.getName();
			var loc2:StringBuilder = new PortalNameParser().makeBuilder(loc1);
			this.nameText_.setStringBuilder(loc2);
			this.nameText_.x = (WIDTH - this.nameText_.width) * 0.5;
			this.nameText_.y = this.nameText_.height > 30?Number(0):Number(6);
		}
		
		private function getName() : String {
			var loc1:String = this.owner_.getName();
			if(this.owner_.lockedPortal_ && loc1.indexOf(this.LOCKED) == 0) {
				return loc1.substr(this.LOCKED.length);
			}
			return this.parseJson(loc1);
		}
		
		private function parseJson(param1:String) : String {
			var loc2:Array = param1.match(this.TEXT_PATTERN);
			return !!loc2?loc2[1]:param1;
		}
	}
}
