 
package kabam.rotmg.editor.view {
	import com.company.assembleegameclient.ui.StaticClickableText;
	import com.company.assembleegameclient.ui.dialogs.Dialog;
	import com.company.assembleegameclient.ui.dropdown.DropDown;
	import com.company.rotmg.graphics.DeleteXGraphic;
	import com.company.ui.BaseSimpleText;
	import com.company.util.GraphicsUtil;
	import com.company.util.MoreObjectUtil;
	import flash.display.CapsStyle;
	import flash.display.Graphics;
	import flash.display.GraphicsPath;
	import flash.display.GraphicsSolidFill;
	import flash.display.GraphicsStroke;
	import flash.display.IGraphicsData;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.net.FileReference;
	import flash.text.TextFieldAutoSize;
	import flash.utils.ByteArray;
	import kabam.rotmg.account.core.Account;
	import kabam.rotmg.appengine.api.AppEngineClient;
	import kabam.rotmg.core.StaticInjectorContext;
	import kabam.rotmg.core.service.GoogleAnalytics;
	import kabam.rotmg.editor.model.SearchData;
	import kabam.rotmg.editor.model.SearchModel;
	import kabam.rotmg.editor.model.TextureData;
	import kabam.rotmg.editor.view.components.PictureType;
	import kabam.rotmg.editor.view.components.loaddialog.DeletePictureDialog;
	import kabam.rotmg.editor.view.components.loaddialog.ResultsBoxes;
	import kabam.rotmg.editor.view.components.loaddialog.SpriteSheet;
	import kabam.rotmg.editor.view.components.loaddialog.TagSearchField;
	import kabam.rotmg.editor.view.components.loaddialog.events.AddPictureEvent;
	import kabam.rotmg.editor.view.components.loaddialog.events.DeletePictureEvent;
	import kabam.rotmg.text.model.TextKey;
	import kabam.rotmg.text.view.StaticTextDisplay;
	import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
	import org.osflash.signals.Signal;
	
	public class LoadTextureDialog extends Sprite {
		
		public static const MINE:String = "Mine";
		
		public static const WIDTH:int = 640;
		
		public static const HEIGHT:int = 540;
		
		public static const NUM_COLS:int = 6;
		
		public static const NUM_ROWS:int = 4;
		
		public static const TYPES:Vector.<int> = new <int>[PictureType.INVALID,PictureType.CHARACTER,PictureType.ITEM,PictureType.ENVIRONMENT,PictureType.PROJECTILE,PictureType.TEXTILE,PictureType.INTERFACE,PictureType.MISCELLANEOUS];
		 
		
		public const textureSelected:Signal = new Signal(TextureData);
		
		public const cancel:Signal = new Signal();
		
		public const search:Signal = new Signal(SearchData);
		
		public var accountDropDown_:DropDown;
		
		public var resultsBoxes_:ResultsBoxes;
		
		public var deletePictureDialog:DeletePictureDialog;
		
		protected var darkBox_:Shape;
		
		protected var box_:Sprite;
		
		protected var rect_:Shape;
		
		protected var titleText_:BaseSimpleText = null;
		
		protected var cancelButton_:DeleteXGraphic = null;
		
		protected var searchButton_:StaticTextButton;
		
		protected var prevButton_:StaticClickableText;
		
		protected var nextButton_:StaticClickableText;
		
		protected var tagSearchField_:TagSearchField;
		
		protected var typeDropDown_:DropDown;
		
		protected var spriteSheet_:SpriteSheet = null;
		
		protected var numBitmapsText_:StaticTextDisplay = null;
		
		protected var downloadButton_:StaticClickableText = null;
		
		protected var updateSpriteSheetText_:Sprite = null;
		
		private var data:String;
		
		private var outlineFill_:GraphicsSolidFill;
		
		private var lineStyle_:GraphicsStroke;
		
		private var backgroundFill_:GraphicsSolidFill;
		
		private var path_:GraphicsPath;
		
		private var graphicsData_:Vector.<IGraphicsData>;
		private var drawn_:Boolean = false;

		public function LoadTextureDialog(param1:SearchModel) {
			var loc3:int = 0;
			this.box_ = new Sprite();
			this.outlineFill_ = new GraphicsSolidFill(16777215,1);
			this.lineStyle_ = new GraphicsStroke(1,false,LineScaleMode.NORMAL,CapsStyle.NONE,JointStyle.ROUND,3,this.outlineFill_);
			this.backgroundFill_ = new GraphicsSolidFill(3552822,1);
			this.path_ = new GraphicsPath(new Vector.<int>(),new Vector.<Number>());

			graphicsData_ = new <IGraphicsData>[this.lineStyle_,this.backgroundFill_,this.path_,GraphicsUtil.END_FILL,GraphicsUtil.END_STROKE];
			super();
			this.titleText_ = new BaseSimpleText(22,5746018,false,WIDTH,0);
			this.titleText_.setBold(true);
			this.titleText_.htmlText = "<p align=\"center\">Load</p>";
			this.titleText_.updateMetrics();
			this.titleText_.filters = [new DropShadowFilter(0,0,0,1,8,8,1)];
			this.titleText_.y = 4;
			this.box_.addChild(this.titleText_);
			this.cancelButton_ = new DeleteXGraphic();
			this.cancelButton_.addEventListener(MouseEvent.CLICK,this.onCancelClick);
			this.cancelButton_.x = WIDTH - this.cancelButton_.width - 10;
			this.cancelButton_.y = 10;
			this.box_.addChild(this.cancelButton_);
			this.searchButton_ = new StaticTextButton(16,TextKey.EDITOR_SEARCH,120);
			this.searchButton_.x = WIDTH - this.searchButton_.width - 20;
			this.searchButton_.y = 40;
			this.searchButton_.addEventListener(MouseEvent.CLICK,this.onSearchClick);
			this.box_.addChild(this.searchButton_);
			this.prevButton_ = new StaticClickableText(16,true,TextKey.EDITOR_PREVIOUS);
			this.prevButton_.visible = false;
			this.prevButton_.x = 20;
			this.prevButton_.y = HEIGHT - 50;
			this.prevButton_.addEventListener(MouseEvent.CLICK,this.onPrevClick);
			this.box_.addChild(this.prevButton_);
			this.nextButton_ = new StaticClickableText(16,true,TextKey.EDITOR_NEXT);
			this.nextButton_.text_.setAutoSize(TextFieldAutoSize.RIGHT);
			this.nextButton_.visible = false;
			this.nextButton_.x = WIDTH - 20;
			this.nextButton_.y = HEIGHT - 50;
			this.nextButton_.addEventListener(MouseEvent.CLICK,this.onNextClick);
			this.box_.addChild(this.nextButton_);
			this.accountDropDown_ = new DropDown(new <String>[MINE,"All","Wild Shadow"],120,30);
			this.accountDropDown_.setValue(param1.searchData.scope);
			this.accountDropDown_.x = 20;
			this.accountDropDown_.y = 40;
			this.box_.addChild(this.accountDropDown_);
			var loc2:Vector.<String> = new Vector.<String>();
			for each(loc3 in TYPES) {
				loc2.push(PictureType.TYPES[loc3].name_);
			}
			this.typeDropDown_ = new DropDown(loc2,120,30);
			this.typeDropDown_.x = this.accountDropDown_.x + this.accountDropDown_.width + 10;
			this.typeDropDown_.y = 40;
			this.typeDropDown_.setValue(PictureType.TYPES[param1.searchData.type].name_);
			this.box_.addChild(this.typeDropDown_);
			this.tagSearchField_ = new TagSearchField();
			this.tagSearchField_.x = this.typeDropDown_.x + this.typeDropDown_.width + 10;
			this.tagSearchField_.y = 40;
			if(param1.searchData.tags) {
				this.tagSearchField_.setText(param1.searchData.tags);
			}
			this.box_.addChild(this.tagSearchField_);
			addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
		}
		
		private function onCancelClick(param1:MouseEvent) : void {
			this.cancel.dispatch();
		}
		
		private function onSearchClick(param1:MouseEvent) : void {
			var loc2:GoogleAnalytics = StaticInjectorContext.getInjector().getInstance(GoogleAnalytics);
			if(loc2) {
				loc2.trackEvent("texture","search",this.tagSearchField_.getText());
			}
			this.doSearch(0);
		}
		
		private function onPrevClick(param1:MouseEvent) : void {
			if(this.resultsBoxes_ == null || this.resultsBoxes_.offset_ <= 0) {
				return;
			}
			this.doSearch(Math.max(0,this.resultsBoxes_.offset_ - NUM_ROWS * NUM_COLS));
		}
		
		private function onNextClick(param1:MouseEvent) : void {
			if(this.resultsBoxes_ == null || this.resultsBoxes_.num_ < NUM_ROWS * NUM_COLS) {
				return;
			}
			this.doSearch(this.resultsBoxes_.offset_ + NUM_ROWS * NUM_COLS);
		}
		
		public function doSearch(param1:int) : void {
			this.searchButton_.setEnabled(false);
			var loc2:SearchData = new SearchData();
			loc2.scope = this.accountDropDown_.getValue();
			loc2.type = PictureType.nameToType(this.typeDropDown_.getValue());
			loc2.tags = this.tagSearchField_.getText();
			loc2.offset = param1;
			this.search.dispatch(loc2);
		}
		
		public function showSearchResults(param1:Boolean, param2:*) : void {
			if(param1) {
				this.makeResultBoxes(param2);
			} else {
				this.onSearchError(param2);
			}
		}
		
		private function makeResultBoxes(param1:String) : void {
			this.data = param1;
			if(this.resultsBoxes_ != null && this.box_.contains(this.resultsBoxes_)) {
				this.box_.removeChild(this.resultsBoxes_);
			}
			var loc2:XML = new XML(param1);
			this.resultsBoxes_ = new ResultsBoxes(loc2,NUM_COLS,NUM_ROWS);
			this.resultsBoxes_.selected.add(this.onTextureSelected);
			this.resultsBoxes_.x = 20;
			this.resultsBoxes_.y = 80;
			this.resultsBoxes_.addEventListener(DeletePictureEvent.DELETE_PICTURE_EVENT,this.onPictureDelete);
			this.resultsBoxes_.addEventListener(AddPictureEvent.ADD_PICTURE_EVENT,this.onPictureAdd);
			this.box_.addChildAt(this.resultsBoxes_,1);
			this.searchButton_.setEnabled(true);
			this.nextButton_.visible = this.resultsBoxes_.num_ >= NUM_ROWS * NUM_COLS;
			this.prevButton_.visible = this.resultsBoxes_.offset_ != 0;
		}
		
		private function onSearchError(param1:String) : void {
		}
		
		private function onTextureSelected(param1:TextureData) : void {
			this.textureSelected.dispatch(param1);
		}
		
		private function onPictureDelete(param1:DeletePictureEvent) : void {
			this.deletePictureDialog = new DeletePictureDialog(param1.name_,param1.id_);
			this.deletePictureDialog.addEventListener(Dialog.LEFT_BUTTON,this.onDeleteCancel);
			this.deletePictureDialog.addEventListener(Dialog.RIGHT_BUTTON,this.onDelete);
			addChild(this.deletePictureDialog);
		}
		
		private function onPictureAdd(param1:AddPictureEvent) : void {
			if(this.spriteSheet_ == null) {
				this.spriteSheet_ = new SpriteSheet();
			}
			this.spriteSheet_.addBitmapData(param1.bitmapData_);
			this.updateSpriteSheetText();
		}
		
		private function updateSpriteSheetText() : void {
			if(this.updateSpriteSheetText_ == null) {
				this.updateSpriteSheetText_ = new Sprite();
				this.numBitmapsText_ = new StaticTextDisplay();
				this.numBitmapsText_.setSize(16).setColor(11776947);
				this.numBitmapsText_.filters = [new DropShadowFilter(0,0,0,1,8,8,1)];
				this.numBitmapsText_.y = HEIGHT - 50;
				this.updateSpriteSheetText_.addChild(this.numBitmapsText_);
				this.downloadButton_ = new StaticClickableText(16,true,TextKey.EDITOR_DOWNLOAD);
				this.downloadButton_.y = HEIGHT - 50;
				this.downloadButton_.addEventListener(MouseEvent.CLICK,this.onDownloadClick);
				this.updateSpriteSheetText_.addChild(this.downloadButton_);
				this.box_.addChild(this.updateSpriteSheetText_);
			}
			this.numBitmapsText_.setStringBuilder(new StaticStringBuilder(this.spriteSheet_.bitmapDatas_.length.toString() + " bitmaps - "));
			this.numBitmapsText_.x = WIDTH / 2 - (this.numBitmapsText_.width + this.downloadButton_.width) / 2;
			this.downloadButton_.x = this.numBitmapsText_.x + this.numBitmapsText_.width;
		}
		
		private function onDownloadClick(param1:MouseEvent) : void {
			var loc2:ByteArray = this.spriteSheet_.generatePNG();
			var loc3:FileReference = new FileReference();
			loc3.save(loc2,"spritesheet.png");
			this.box_.removeChild(this.updateSpriteSheetText_);
			this.spriteSheet_ = null;
			this.updateSpriteSheetText_ = null;
			this.numBitmapsText_ = null;
			this.downloadButton_ = null;
		}
		
		private function onDeleteCancel(param1:Event) : void {
			var loc2:Dialog = param1.target as DeletePictureDialog;
			loc2.parent.removeChild(loc2);
		}
		
		private function onDelete(param1:Event) : void {
			var loc2:Account = StaticInjectorContext.getInjector().getInstance(Account);
			var loc3:DeletePictureDialog = param1.target as DeletePictureDialog;
			loc3.parent.removeChild(loc3);
			this.resultsBoxes_.visible = false;
			var loc4:AppEngineClient = StaticInjectorContext.getInjector().getInstance(AppEngineClient);
			loc4.setSendEncrypted(false);
			loc4.complete.addOnce(this.onDeleteComplete);
			loc4.sendRequest("/picture/delete",this.getDeleteParams(loc3,loc2));
		}
		
		private function getDeleteParams(param1:DeletePictureDialog, param2:Account) : Object {
			var loc3:Object = {"id":param1.id_.toString()};
			MoreObjectUtil.addToObject(loc3,param2.getCredentials());
			return loc3;
		}
		
		private function onDeleteComplete(param1:Boolean, param2:*) : void {
			this.doSearch(this.resultsBoxes_.offset_);
		}
		
		private function draw() : void {
			var loc1:Graphics = null;
			GraphicsUtil.clearPath(this.path_);
			GraphicsUtil.drawCutEdgeRect(0,0,WIDTH,HEIGHT,4,[1,1,1,1],this.path_);
			this.rect_ = new Shape();
			loc1 = this.rect_.graphics;
			loc1.drawGraphicsData(this.graphicsData_);
			this.box_.addChildAt(this.rect_,0);
			this.box_.x = stage.stageWidth / 2 - this.box_.width / 2;
			this.box_.y = stage.stageHeight / 2 - this.box_.height / 2;
			this.box_.filters = [new DropShadowFilter(0,0,0,1,16,16,1)];
			addChild(this.box_);
			this.darkBox_ = new Shape();
			loc1 = this.darkBox_.graphics;
			loc1.clear();
			loc1.beginFill(0,0.8);
			loc1.drawRect(0,0,stage.stageWidth,stage.stageHeight);
			loc1.endFill();
			addChildAt(this.darkBox_,0);
		}
		
		private function onAddedToStage(param1:Event) : void {
			if(!this.drawn_) {
				this.draw();
				this.drawn_ = true;
			}
			var loc2:GoogleAnalytics = StaticInjectorContext.getInjector().getInstance(GoogleAnalytics);
			if(loc2) {
				loc2.trackPageView("/loadDialog");
			}
		}
		
		public function getData() : String {
			return this.data;
		}
	}
}
