 
package io.decagames.rotmg.social {
	import com.company.assembleegameclient.util.TextureRedrawer;
	import com.company.util.AssetLibrary;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	import io.decagames.rotmg.social.widgets.FriendListItem;
	import io.decagames.rotmg.social.widgets.GuildInfoItem;
	import io.decagames.rotmg.social.widgets.GuildListItem;
	import io.decagames.rotmg.ui.buttons.SliceScalingButton;
	import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
	import io.decagames.rotmg.ui.gird.UIGrid;
	import io.decagames.rotmg.ui.gird.UIGridElement;
	import io.decagames.rotmg.ui.labels.UILabel;
	import io.decagames.rotmg.ui.popups.modal.ModalPopup;
	import io.decagames.rotmg.ui.scroll.UIScrollbar;
	import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
	import io.decagames.rotmg.ui.tabs.TabButton;
	import io.decagames.rotmg.ui.tabs.UITab;
	import io.decagames.rotmg.ui.tabs.UITabs;
	import io.decagames.rotmg.ui.textField.InputTextField;
	import io.decagames.rotmg.ui.texture.TextureParser;
	
	public class SocialPopupView extends ModalPopup {
		
		public static const SOCIAL_LABEL:String = "Social";
		
		public static const FRIEND_TAB_LABEL:String = "Friends";
		
		public static const GUILD_TAB_LABEL:String = "Guild";
		
		public static const MAX_VISIBLE_INVITATIONS:int = 3;
		
		public static const DEFAULT_NO_GUILD_MESSAGE:String = "You have not yet joined a Guild,\n" + "join a Guild to find Players to play with or\n create your own Guild.";
		 
		
		public var search:InputTextField;
		
		public var addButton:SliceScalingButton;
		
		private var contentInset:SliceScalingBitmap;
		
		private var friendsGrid:UIGrid;
		
		private var guildsGrid:UIGrid;
		
		private var _tabs:UITabs;
		
		private var _tabContent:Sprite;
		
		public function SocialPopupView() {
			super(350,505,SOCIAL_LABEL,DefaultLabelFormat.defaultSmallPopupTitle,new Rectangle(0,0,350,565));
			this.init();
		}
		
		public function addFriendCategory(param1:String) : void {
			var loc3:UILabel = null;
			var loc2:UIGridElement = new UIGridElement();
			loc3 = new UILabel();
			loc3.text = param1;
			DefaultLabelFormat.defaultSmallPopupTitle(loc3);
			loc2.addChild(loc3);
			this.friendsGrid.addGridElement(loc2);
		}
		
		public function addFriend(param1:FriendListItem) : void {
			var loc2:UIGridElement = new UIGridElement();
			loc2.addChild(param1);
			this.friendsGrid.addGridElement(loc2);
		}
		
		public function addGuildInfo(param1:GuildInfoItem) : void {
			var loc2:UIGridElement = null;
			loc2 = new UIGridElement();
			loc2.addChild(param1);
			loc2.x = (_contentWidth - loc2.width) / 2;
			loc2.y = 10;
			this._tabContent.addChild(loc2);
		}
		
		public function addGuildCategory(param1:String) : void {
			var loc2:UIGridElement = new UIGridElement();
			var loc3:UILabel = new UILabel();
			loc3.text = param1;
			DefaultLabelFormat.defaultSmallPopupTitle(loc3);
			loc2.addChild(loc3);
			this.guildsGrid.addGridElement(loc2);
		}
		
		public function addGuildDefaultMessage(param1:String) : void {
			var loc2:UIGridElement = null;
			var loc3:UILabel = null;
			loc2 = new UIGridElement();
			loc3 = new UILabel();
			loc3.width = 300;
			loc3.multiline = true;
			loc3.wordWrap = true;
			loc3.text = param1;
			loc3.x = (350 - 300) / 2 - 20;
			DefaultLabelFormat.guildInfoLabel(loc3,14,11776947,TextFormatAlign.CENTER);
			loc2.addChild(loc3);
			this.guildsGrid.addGridElement(loc2);
		}
		
		public function addGuildMember(param1:GuildListItem) : void {
			var loc2:UIGridElement = new UIGridElement();
			loc2.addChild(param1);
			this.guildsGrid.addGridElement(loc2);
		}
		
		public function addInvites(param1:FriendListItem) : void {
			var loc2:UIGridElement = new UIGridElement();
			loc2.addChild(param1);
			this.friendsGrid.addGridElement(loc2);
		}
		
		public function showInviteIndicator(param1:Boolean, param2:String) : void {
			var loc3:TabButton = this._tabs.getTabButtonByLabel(param2);
			if(loc3) {
				loc3.showIndicator = param1;
			}
		}
		
		public function clearFriendsList() : void {
			this.friendsGrid.clearGrid();
			this.showInviteIndicator(false,FRIEND_TAB_LABEL);
		}
		
		public function clearGuildList() : void {
			this.guildsGrid.clearGrid();
			this.showInviteIndicator(false,GUILD_TAB_LABEL);
		}
		
		private function init() : void {
			this.friendsGrid = new UIGrid(350,1,3);
			this.friendsGrid.x = 9;
			this.friendsGrid.y = 15;
			this.guildsGrid = new UIGrid(350,1,3);
			this.guildsGrid.x = 9;
			this.createContentInset();
			this.createContentTabs();
			this.addTabs();
		}
		
		private function addTabs() : void {
			this._tabs = new UITabs(350,true);
			var loc1:Sprite = new Sprite();
			this._tabs.addTab(this.createTab(FRIEND_TAB_LABEL,loc1,this.friendsGrid,true),true);
			var loc2:Sprite = new Sprite();
			this._tabs.addTab(this.createTab(GUILD_TAB_LABEL,loc2,this.guildsGrid),false);
			this._tabs.y = 6;
			this._tabs.x = 0;
			addChild(this._tabs);
		}
		
		private function createContentTabs() : void {
			var loc1:SliceScalingBitmap = TextureParser.instance.getSliceScalingBitmap("UI","tab_inset_content_background",350);
			loc1.height = 45;
			loc1.x = 0;
			loc1.y = 5;
			addChild(loc1);
		}
		
		private function createContentInset() : void {
			this.contentInset = TextureParser.instance.getSliceScalingBitmap("UI","popup_content_inset",350);
			this.contentInset.height = 465;
			this.contentInset.x = 0;
			this.contentInset.y = 40;
			addChild(this.contentInset);
		}
		
		private function createSearchInputField(param1:int) : InputTextField {
			var loc2:InputTextField = new InputTextField("Filter");
			DefaultLabelFormat.defaultSmallPopupTitle(loc2);
			loc2.width = param1;
			return loc2;
		}
		
		private function createSearchIcon() : Bitmap {
			var loc1:BitmapData = TextureRedrawer.redraw(AssetLibrary.getImageFromSet("lofiInterfaceBig",40),20,true,0);
			var loc2:Bitmap = new Bitmap(loc1);
			return loc2;
		}
		
		private function createAddButton() : SliceScalingButton {
			var loc1:SliceScalingButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI","add_button"));
			return loc1;
		}
		
		private function createSearchInset(param1:int) : SliceScalingBitmap {
			var loc2:SliceScalingBitmap = TextureParser.instance.getSliceScalingBitmap("UI","popup_content_inset",param1);
			loc2.height = 30;
			return loc2;
		}
		
		private function createTab(param1:String, param2:Sprite, param3:UIGrid, param4:Boolean = false) : UITab {
			var loc8:Sprite = null;
			var loc5:UITab = new UITab(param1,true);
			this._tabContent = new Sprite();
			param2.x = this.contentInset.x;
			this._tabContent.addChild(param2);
			if(param4) {
				this.createSearchAndAdd();
			}
			param2.y = !!param4?Number(50):Number(85);
			param2.addChild(param3);
			var loc6:int = !!param4?410:375;
			var loc7:UIScrollbar = new UIScrollbar(loc6);
			loc7.mouseRollSpeedFactor = 1;
			loc7.scrollObject = loc5;
			loc7.content = param2;
			loc7.x = this.contentInset.x + this.contentInset.width - 25;
			loc7.y = param2.y;
			this._tabContent.addChild(loc7);
			loc8 = new Sprite();
			loc8.graphics.beginFill(0);
			loc8.graphics.drawRect(0,0,350,loc6 - 5);
			loc8.x = param2.x;
			loc8.y = param2.y;
			param2.mask = loc8;
			this._tabContent.addChild(loc8);
			loc5.addContent(this._tabContent);
			return loc5;
		}
		
		private function createSearchAndAdd() : void {
			var loc2:Bitmap = null;
			this.addButton = this.createAddButton();
			this.addButton.x = 7;
			this.addButton.y = 6;
			this._tabContent.addChild(this.addButton);
			var loc1:SliceScalingBitmap = this.createSearchInset(296);
			loc1.x = this.addButton.x + this.addButton.width;
			loc1.y = 10;
			this._tabContent.addChild(loc1);
			loc2 = this.createSearchIcon();
			loc2.x = loc1.x;
			loc2.y = 5;
			this._tabContent.addChild(loc2);
			this.search = this.createSearchInputField(250);
			this.search.autoSize = TextFieldAutoSize.NONE;
			this.search.multiline = false;
			this.search.wordWrap = false;
			this.search.x = loc2.x + loc2.width - 5;
			this.search.y = loc1.y + 7;
			this._tabContent.addChild(this.search);
		}
		
		public function get tabs() : UITabs {
			return this._tabs;
		}
	}
}
