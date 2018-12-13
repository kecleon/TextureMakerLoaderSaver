package com.company.assembleegameclient.screens {
	import com.company.assembleegameclient.ui.Scrollbar;

	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;

	import kabam.rotmg.core.StaticInjectorContext;
	import kabam.rotmg.core.service.GoogleAnalytics;
	import kabam.rotmg.servers.api.Server;
	import kabam.rotmg.text.model.TextKey;
	import kabam.rotmg.text.view.TextFieldDisplayConcrete;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;
	import kabam.rotmg.ui.view.ButtonFactory;
	import kabam.rotmg.ui.view.components.MenuOptionsBar;
	import kabam.rotmg.ui.view.components.ScreenBase;

	import org.osflash.signals.Signal;

	public class ServersScreen extends Sprite {


		private var selectServerText_:TextFieldDisplayConcrete;

		private var lines_:Shape;

		private var content_:Sprite;

		private var serverBoxes_:ServerBoxes;

		private var scrollBar_:Scrollbar;

		private var servers:Vector.<Server>;

		public var gotoTitle:Signal;

		public function ServersScreen() {
			super();
			addChild(new ScreenBase());
			this.gotoTitle = new Signal();
			addChild(new ScreenBase());
			addChild(new AccountScreen());
		}

		private function onScrollBarChange(param1:Event):void {
			this.serverBoxes_.y = 8 - this.scrollBar_.pos() * (this.serverBoxes_.height - 400);
		}

		public function initialize(param1:Vector.<Server>):void {
			this.servers = param1;
			this.makeSelectServerText();
			this.makeLines();
			this.makeContainer();
			this.makeServerBoxes();
			this.serverBoxes_.height > 400 && this.makeScrollbar();
			this.makeMenuBar();
			var loc2:GoogleAnalytics = StaticInjectorContext.getInjector().getInstance(GoogleAnalytics);
			if (loc2) {
				loc2.trackPageView("/serversScreen");
			}
		}

		private function makeMenuBar():void {
			var loc1:MenuOptionsBar = new MenuOptionsBar();
			var loc2:TitleMenuOption = ButtonFactory.getDoneButton();
			loc1.addButton(loc2, MenuOptionsBar.CENTER);
			loc2.clicked.add(this.onDone);
			addChild(loc1);
		}

		private function makeScrollbar():void {
			this.scrollBar_ = new Scrollbar(16, 400);
			this.scrollBar_.x = 800 - this.scrollBar_.width - 4;
			this.scrollBar_.y = 104;
			this.scrollBar_.setIndicatorSize(400, this.serverBoxes_.height);
			this.scrollBar_.addEventListener(Event.CHANGE, this.onScrollBarChange);
			addChild(this.scrollBar_);
		}

		private function makeServerBoxes():void {
			this.serverBoxes_ = new ServerBoxes(this.servers);
			this.serverBoxes_.y = 8;
			this.serverBoxes_.addEventListener(Event.COMPLETE, this.onDone);
			this.content_.addChild(this.serverBoxes_);
		}

		private function makeContainer():void {
			this.content_ = new Sprite();
			this.content_.x = 4;
			this.content_.y = 100;
			var loc1:Shape = new Shape();
			loc1.graphics.beginFill(16777215);
			loc1.graphics.drawRect(0, 0, 776, 430);
			loc1.graphics.endFill();
			this.content_.addChild(loc1);
			this.content_.mask = loc1;
			addChild(this.content_);
		}

		private function makeLines():void {
			this.lines_ = new Shape();
			var loc1:Graphics = this.lines_.graphics;
			loc1.clear();
			loc1.lineStyle(2, 5526612);
			loc1.moveTo(0, 100);
			loc1.lineTo(stage.stageWidth, 100);
			loc1.lineStyle();
			addChild(this.lines_);
		}

		private function makeSelectServerText():void {
			this.selectServerText_ = new TextFieldDisplayConcrete().setSize(18).setColor(11776947).setBold(true);
			this.selectServerText_.setStringBuilder(new LineBuilder().setParams(TextKey.SERVERS_SELECT));
			this.selectServerText_.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
			this.selectServerText_.x = 18;
			this.selectServerText_.y = 72;
			addChild(this.selectServerText_);
		}

		private function onDone():void {
			this.gotoTitle.dispatch();
		}
	}
}
