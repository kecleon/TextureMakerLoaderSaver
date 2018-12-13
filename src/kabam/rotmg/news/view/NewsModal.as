 
package kabam.rotmg.news.view {
	import com.company.assembleegameclient.sound.SoundEffectLibrary;
	import com.company.util.AssetLibrary;
	import com.company.util.KeyCodes;
	import com.company.util.MoreColorUtil;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	import kabam.rotmg.account.core.view.EmptyFrame;
	import kabam.rotmg.core.StaticInjectorContext;
	import kabam.rotmg.dialogs.control.FlushPopupStartupQueueSignal;
	import kabam.rotmg.news.model.NewsModel;
	import kabam.rotmg.pets.view.components.PopupWindowBackground;
	import kabam.rotmg.text.model.FontModel;
	import kabam.rotmg.text.view.TextFieldDisplayConcrete;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;
	import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
	import kabam.rotmg.ui.model.HUDModel;
	
	public class NewsModal extends EmptyFrame {
		
		public static var backgroundImageEmbed:Class = NewsModal_backgroundImageEmbed;
		
		public static var foregroundImageEmbed:Class = NewsModal_foregroundImageEmbed;
		
		public static const MODAL_WIDTH:int = 440;
		
		public static const MODAL_HEIGHT:int = 400;
		
		public static var modalWidth:int = MODAL_WIDTH;
		
		public static var modalHeight:int = MODAL_HEIGHT;
		
		private static const OVER_COLOR_TRANSFORM:ColorTransform = new ColorTransform(1,220 / 255,133 / 255);
		
		private static const DROP_SHADOW_FILTER:DropShadowFilter = new DropShadowFilter(0,0,0);
		
		private static const GLOW_FILTER:GlowFilter = new GlowFilter(16711680,1,11,5);
		
		private static const filterWithGlow:Array = [DROP_SHADOW_FILTER,GLOW_FILTER];
		
		private static const filterNoGlow:Array = [DROP_SHADOW_FILTER];
		 
		
		private var currentPage:NewsModalPage;
		
		private var currentPageNum:int = -1;
		
		private var pageOneNav:TextField;
		
		private var pageTwoNav:TextField;
		
		private var pageThreeNav:TextField;
		
		private var pageFourNav:TextField;
		
		private var pageNavs:Vector.<TextField>;
		
		private var pageIndicator:TextField;
		
		private var fontModel:FontModel;
		
		private var leftNavSprite:Sprite;
		
		private var rightNavSprite:Sprite;
		
		private var newsModel:NewsModel;
		
		private var currentPageNumber:int = 1;
		
		private var triggeredOnStartup:Boolean;
		
		public function NewsModal(param1:Boolean = false) {
			this.triggeredOnStartup = param1;
			this.newsModel = StaticInjectorContext.getInjector().getInstance(NewsModel);
			this.fontModel = StaticInjectorContext.getInjector().getInstance(FontModel);
			modalWidth = MODAL_WIDTH;
			modalHeight = MODAL_HEIGHT;
			super(modalWidth,modalHeight);
			this.setCloseButton(true);
			this.pageIndicator = new TextField();
			this.initNavButtons();
			this.setPage(this.currentPageNumber);
			WebMain.STAGE.addEventListener(KeyboardEvent.KEY_DOWN,this.keyDownListener);
			addEventListener(Event.ADDED_TO_STAGE,this.onAdded);
			addEventListener(Event.REMOVED_FROM_STAGE,this.destroy);
			closeButton.clicked.add(this.onCloseButtonClicked);
		}
		
		public static function getText(param1:String, param2:int, param3:int, param4:Boolean) : TextFieldDisplayConcrete {
			var loc5:TextFieldDisplayConcrete = new TextFieldDisplayConcrete().setSize(18).setColor(16777215).setTextWidth(NewsModal.modalWidth - TEXT_MARGIN * 2 - 10);
			loc5.setBold(true);
			if(param4) {
				loc5.setStringBuilder(new StaticStringBuilder(param1));
			} else {
				loc5.setStringBuilder(new LineBuilder().setParams(param1));
			}
			loc5.setWordWrap(true);
			loc5.setMultiLine(true);
			loc5.setAutoSize(TextFieldAutoSize.CENTER);
			loc5.setHorizontalAlign(TextFormatAlign.CENTER);
			loc5.filters = [new DropShadowFilter(0,0,0)];
			loc5.x = param2;
			loc5.y = param3;
			return loc5;
		}
		
		public function onCloseButtonClicked() : void {
			var loc1:FlushPopupStartupQueueSignal = StaticInjectorContext.getInjector().getInstance(FlushPopupStartupQueueSignal);
			closeButton.clicked.remove(this.onCloseButtonClicked);
			if(this.triggeredOnStartup) {
				loc1.dispatch();
			}
		}
		
		private function onAdded(param1:Event) : void {
			this.newsModel.markAsRead();
			this.refreshNewsButton();
		}
		
		private function updateIndicator() : void {
			this.fontModel.apply(this.pageIndicator,24,16777215,true);
			this.pageIndicator.text = this.currentPageNumber + " / " + this.newsModel.numberOfNews;
			addChild(this.pageIndicator);
			this.pageIndicator.y = modalHeight - 33;
			this.pageIndicator.x = modalWidth / 2 - this.pageIndicator.textWidth / 2;
			this.pageIndicator.width = this.pageIndicator.textWidth + 4;
		}
		
		private function initNavButtons() : void {
			this.updateIndicator();
			this.leftNavSprite = this.makeLeftNav();
			this.rightNavSprite = this.makeRightNav();
			this.leftNavSprite.x = modalWidth * 4 / 11 - this.rightNavSprite.width / 2;
			this.leftNavSprite.y = modalHeight - 4;
			addChild(this.leftNavSprite);
			this.rightNavSprite.x = modalWidth * 7 / 11 - this.rightNavSprite.width / 2;
			this.rightNavSprite.y = modalHeight - 4;
			addChild(this.rightNavSprite);
		}
		
		public function onClick(param1:MouseEvent) : void {
			switch(param1.currentTarget) {
				case this.rightNavSprite:
					if(this.currentPageNumber + 1 <= this.newsModel.numberOfNews) {
						this.setPage(this.currentPageNumber + 1);
					}
					break;
				case this.leftNavSprite:
					if(this.currentPageNumber - 1 >= 1) {
						this.setPage(this.currentPageNumber - 1);
					}
			}
		}
		
		private function destroy(param1:Event) : void {
			removeEventListener(Event.ADDED_TO_STAGE,this.onAdded);
			WebMain.STAGE.removeEventListener(KeyboardEvent.KEY_DOWN,this.keyDownListener);
			removeEventListener(Event.REMOVED_FROM_STAGE,this.destroy);
			this.leftNavSprite.removeEventListener(MouseEvent.CLICK,this.onClick);
			this.leftNavSprite.removeEventListener(MouseEvent.MOUSE_OVER,this.onArrowHover);
			this.leftNavSprite.removeEventListener(MouseEvent.MOUSE_OUT,this.onArrowHoverOut);
			this.rightNavSprite.removeEventListener(MouseEvent.CLICK,this.onClick);
			this.rightNavSprite.removeEventListener(MouseEvent.MOUSE_OVER,this.onArrowHover);
			this.rightNavSprite.removeEventListener(MouseEvent.MOUSE_OUT,this.onArrowHoverOut);
		}
		
		private function setPage(param1:int) : void {
			this.currentPageNumber = param1;
			if(this.currentPage && this.currentPage.parent) {
				removeChild(this.currentPage);
			}
			this.currentPage = this.newsModel.getModalPage(param1);
			addChild(this.currentPage);
			this.updateIndicator();
		}
		
		private function refreshNewsButton() : void {
			var loc1:HUDModel = StaticInjectorContext.getInjector().getInstance(HUDModel);
			if(loc1 != null && loc1.gameSprite != null) {
				loc1.gameSprite.refreshNewsUpdateButton();
			}
		}
		
		override protected function makeModalBackground() : Sprite {
			var loc1:Sprite = new Sprite();
			var loc2:DisplayObject = new backgroundImageEmbed();
			loc2.width = modalWidth + 1;
			loc2.height = modalHeight - 25;
			loc2.y = 27;
			loc2.alpha = 0.95;
			var loc3:DisplayObject = new foregroundImageEmbed();
			loc3.width = modalWidth + 1;
			loc3.height = modalHeight - 67;
			loc3.y = 27;
			loc3.alpha = 1;
			var loc4:PopupWindowBackground = new PopupWindowBackground();
			loc4.draw(modalWidth,modalHeight,PopupWindowBackground.TYPE_TRANSPARENT_WITH_HEADER);
			loc1.addChild(loc2);
			loc1.addChild(loc3);
			loc1.addChild(loc4);
			return loc1;
		}
		
		private function keyDownListener(param1:KeyboardEvent) : void {
			if(param1.keyCode == KeyCodes.RIGHT) {
				if(this.currentPageNumber + 1 <= this.newsModel.numberOfNews) {
					this.setPage(this.currentPageNumber + 1);
				}
			} else if(param1.keyCode == KeyCodes.LEFT) {
				if(this.currentPageNumber - 1 >= 1) {
					this.setPage(this.currentPageNumber - 1);
				}
			}
		}
		
		private function makeLeftNav() : Sprite {
			var loc1:BitmapData = AssetLibrary.getImageFromSet("lofiInterface",54);
			var loc2:Bitmap = new Bitmap(loc1);
			loc2.scaleX = 4;
			loc2.scaleY = 4;
			loc2.rotation = -90;
			var loc3:Sprite = new Sprite();
			loc3.addChild(loc2);
			loc3.addEventListener(MouseEvent.MOUSE_OVER,this.onArrowHover);
			loc3.addEventListener(MouseEvent.MOUSE_OUT,this.onArrowHoverOut);
			loc3.addEventListener(MouseEvent.CLICK,this.onClick);
			return loc3;
		}
		
		private function makeRightNav() : Sprite {
			var loc1:BitmapData = AssetLibrary.getImageFromSet("lofiInterface",55);
			var loc2:Bitmap = new Bitmap(loc1);
			loc2.scaleX = 4;
			loc2.scaleY = 4;
			loc2.rotation = -90;
			var loc3:Sprite = new Sprite();
			loc3.addChild(loc2);
			loc3.addEventListener(MouseEvent.MOUSE_OVER,this.onArrowHover);
			loc3.addEventListener(MouseEvent.MOUSE_OUT,this.onArrowHoverOut);
			loc3.addEventListener(MouseEvent.CLICK,this.onClick);
			return loc3;
		}
		
		private function onArrowHover(param1:MouseEvent) : void {
			param1.currentTarget.transform.colorTransform = OVER_COLOR_TRANSFORM;
		}
		
		private function onArrowHoverOut(param1:MouseEvent) : void {
			param1.currentTarget.transform.colorTransform = MoreColorUtil.identity;
		}
		
		override public function onCloseClick(param1:MouseEvent) : void {
			SoundEffectLibrary.play("button_click");
		}
	}
}
