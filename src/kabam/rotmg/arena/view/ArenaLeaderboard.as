 
package kabam.rotmg.arena.view {
	import com.company.assembleegameclient.screens.TitleMenuOption;
	import com.company.assembleegameclient.util.TextureRedrawer;
	import com.company.rotmg.graphics.ScreenGraphic;
	import com.company.util.AssetLibrary;
	import com.company.util.BitmapUtil;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextFieldAutoSize;
	import kabam.rotmg.arena.component.LeaderboardWeeklyResetTimer;
	import kabam.rotmg.arena.model.ArenaLeaderboardEntry;
	import kabam.rotmg.arena.model.ArenaLeaderboardFilter;
	import kabam.rotmg.arena.model.ArenaLeaderboardModel;
	import kabam.rotmg.text.model.TextKey;
	import kabam.rotmg.text.view.StaticTextDisplay;
	import kabam.rotmg.text.view.TextFieldDisplayConcrete;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;
	import kabam.rotmg.ui.view.SignalWaiter;
	import org.osflash.signals.Signal;
	
	public class ArenaLeaderboard extends Sprite {
		 
		
		public const requestData:Signal = new Signal(ArenaLeaderboardFilter);
		
		public const close:Signal = new Signal();
		
		private var list:ArenaLeaderboardList;
		
		private var title:StaticTextDisplay;
		
		private var leftSword:Bitmap;
		
		private var rightSword:Bitmap;
		
		private var tabs:Vector.<ArenaLeaderboardTab>;
		
		private var selected:ArenaLeaderboardTab;
		
		private var closeButton:TitleMenuOption;
		
		private var weeklyCountdownClock:LeaderboardWeeklyResetTimer;
		
		public function ArenaLeaderboard() {
			this.list = this.makeList();
			this.title = this.makeTitle();
			this.leftSword = this.makeSword(false);
			this.rightSword = this.makeSword(true);
			this.tabs = this.makeTabs();
			this.weeklyCountdownClock = this.makeResetTimer();
			super();
			addChild(this.list);
			addChild(new ScreenGraphic());
			addChild(this.leftSword);
			addChild(this.rightSword);
			addChild(this.title);
			this.makeCloseButton();
			this.makeLines();
			addChild(this.weeklyCountdownClock);
		}
		
		public function init() : void {
			var loc1:ArenaLeaderboardTab = this.tabs[0];
			this.selected = loc1;
			loc1.setSelected(true);
			loc1.selected.dispatch(loc1);
		}
		
		public function destroy() : void {
			var loc1:ArenaLeaderboardTab = null;
			for each(loc1 in this.tabs) {
				loc1.selected.remove(this.onSelected);
				loc1.destroy();
			}
		}
		
		public function reloadList() : void {
			this.setList(this.selected.getFilter().getEntries());
		}
		
		private function onCloseClick(param1:MouseEvent) : void {
			this.close.dispatch();
		}
		
		private function onSelected(param1:ArenaLeaderboardTab) : void {
			this.selected.setSelected(false);
			this.selected = param1;
			this.selected.setSelected(true);
			this.weeklyCountdownClock.visible = param1.getFilter().getKey() == "weekly";
			if(param1.getFilter().hasEntries()) {
				this.list.setItems(param1.getFilter().getEntries(),true);
			} else {
				this.requestData.dispatch(param1.getFilter());
			}
		}
		
		public function setList(param1:Vector.<ArenaLeaderboardEntry>) : void {
			this.list.setItems(param1,true);
		}
		
		private function makeTabs() : Vector.<ArenaLeaderboardTab> {
			var loc3:ArenaLeaderboardFilter = null;
			var loc4:ArenaLeaderboardTab = null;
			var loc1:SignalWaiter = new SignalWaiter();
			var loc2:Vector.<ArenaLeaderboardTab> = new Vector.<ArenaLeaderboardTab>();
			for each(loc3 in ArenaLeaderboardModel.FILTERS) {
				loc4 = new ArenaLeaderboardTab(loc3);
				loc4.y = 70;
				loc4.selected.add(this.onSelected);
				loc2.push(loc4);
				loc1.push(loc4.readyToAlign);
				addChild(loc4);
			}
			loc1.complete.addOnce(this.alignTabs);
			return loc2;
		}
		
		private function makeSword(param1:Boolean) : Bitmap {
			var loc2:BitmapData = TextureRedrawer.redraw(AssetLibrary.getImageFromSet("lofiInterface2",8),64,true,0,true);
			if(param1) {
				loc2 = BitmapUtil.mirror(loc2);
			}
			return new Bitmap(loc2);
		}
		
		private function makeTitle() : StaticTextDisplay {
			var loc1:StaticTextDisplay = null;
			loc1 = new StaticTextDisplay();
			loc1.setBold(true).setColor(11776947).setSize(32);
			loc1.filters = [new DropShadowFilter(0,0,0,1,8,8)];
			loc1.setStringBuilder(new LineBuilder().setParams(TextKey.ARENA_LEADERBOARD_TITLE));
			loc1.setAutoSize(TextFieldAutoSize.CENTER);
			loc1.y = 25;
			loc1.textChanged.addOnce(this.onAlignTitle);
			return loc1;
		}
		
		private function makeCloseButton() : void {
			this.closeButton = new TitleMenuOption(TextKey.DONE_TEXT,36,false);
			this.closeButton.setAutoSize(TextFieldAutoSize.CENTER);
			this.closeButton.setVerticalAlign(TextFieldDisplayConcrete.MIDDLE);
			this.closeButton.x = 400;
			this.closeButton.y = 553;
			addChild(this.closeButton);
			this.closeButton.addEventListener(MouseEvent.CLICK,this.onCloseClick);
		}
		
		private function makeLines() : void {
			var loc1:Shape = new Shape();
			addChild(loc1);
			var loc2:Graphics = loc1.graphics;
			loc2.lineStyle(2,5526612);
			loc2.moveTo(0,100);
			loc2.lineTo(800,100);
		}
		
		private function makeList() : ArenaLeaderboardList {
			var loc1:ArenaLeaderboardList = null;
			loc1 = new ArenaLeaderboardList();
			loc1.x = 15;
			loc1.y = 115;
			return loc1;
		}
		
		private function alignTabs() : void {
			var loc2:ArenaLeaderboardTab = null;
			var loc1:int = 20;
			for each(loc2 in this.tabs) {
				loc2.x = loc1;
				loc1 = loc1 + (loc2.width + 20);
			}
		}
		
		private function makeResetTimer() : LeaderboardWeeklyResetTimer {
			var loc1:LeaderboardWeeklyResetTimer = null;
			loc1 = new LeaderboardWeeklyResetTimer();
			loc1.y = 72;
			loc1.x = 440;
			return loc1;
		}
		
		private function onAlignTitle() : void {
			this.title.x = stage.stageWidth / 2;
			this.leftSword.x = stage.stageWidth / 2 - this.title.width / 2 - this.leftSword.width + 10;
			this.leftSword.y = 15;
			this.rightSword.x = stage.stageWidth / 2 + this.title.width / 2 - 10;
			this.rightSword.y = 15;
		}
	}
}
