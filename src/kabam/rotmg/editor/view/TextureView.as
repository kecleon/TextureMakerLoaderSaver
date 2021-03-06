package kabam.rotmg.editor.view {
	import com.adobe.images.PNGEncoder;
	import com.company.assembleegameclient.editor.CommandEvent;
	import com.company.assembleegameclient.editor.CommandList;
	import com.company.assembleegameclient.editor.CommandQueue;
	import com.company.assembleegameclient.screens.AccountScreen;
	import com.company.util.IntPoint;

	import flash.display.BitmapData;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.FileReference;
	import flash.utils.ByteArray;

	import ion.utils.png.PNGDecoder;

	import kabam.rotmg.editor.model.TextureData;
	import kabam.rotmg.editor.view.components.ColorPicker;
	import kabam.rotmg.editor.view.components.ModeDropDown;
	import kabam.rotmg.editor.view.components.ObjectSizeDropDown;
	import kabam.rotmg.editor.view.components.PictureType;
	import kabam.rotmg.editor.view.components.SizeDropDown;
	import kabam.rotmg.editor.view.components.TMCommand;
	import kabam.rotmg.editor.view.components.TMCommandMenu;
	import kabam.rotmg.editor.view.components.TextileSizeDropDown;
	import kabam.rotmg.editor.view.components.drawer.AnimationDrawer;
	import kabam.rotmg.editor.view.components.drawer.ObjectDrawer;
	import kabam.rotmg.editor.view.components.drawer.PixelColor;
	import kabam.rotmg.editor.view.components.drawer.PixelDrawer;
	import kabam.rotmg.editor.view.components.drawer.PixelEvent;
	import kabam.rotmg.editor.view.components.drawer.SetPixelsEvent;
	import kabam.rotmg.editor.view.components.preview.AnimationPreview;
	import kabam.rotmg.editor.view.components.preview.ObjectPreview;
	import kabam.rotmg.editor.view.components.preview.Preview;
	import kabam.rotmg.editor.view.components.preview.TextilePreview;
	import kabam.rotmg.ui.view.components.ScreenBase;

	import org.osflash.signals.Signal;

	public class TextureView extends Sprite {

		private static const MODE_DROPDOWN_X:int = 240;

		private static const MODE_DROPDOWN_Y:int = 32;

		private static const FILTER:Array = [new FileFilter("Images", "*.png")];


		public const loadDialog:Signal = new Signal();

		public const saveDialog:Signal = new Signal(TextureData);

		private var commandMenu_:TMCommandMenu;

		private var commandQueue_:CommandQueue;

		private var colorPicker_:ColorPicker;

		private var modeDropDown_:ModeDropDown;

		private var sizeDropDown_:SizeDropDown;

		private var pixelDrawer_:PixelDrawer;

		private var preview_:Preview;

		private var loadDialog_:LoadTextureDialog;

		private var name_:String = "";

		private var type_:int = 0;

		private var tags_:String = "";

		private var tempEvent_:PixelEvent = null;

		private var file:FileReference;

		public function TextureView() {
			super();
			addChild(new ScreenBase());
			addChild(new AccountScreen());
			this.commandMenu_ = new TMCommandMenu();
			this.commandMenu_.x = 15;
			this.commandMenu_.y = 40;
			this.commandMenu_.addEventListener(CommandEvent.UNDO_COMMAND_EVENT, this.onUndo);
			this.commandMenu_.addEventListener(CommandEvent.REDO_COMMAND_EVENT, this.onRedo);
			this.commandMenu_.addEventListener(CommandEvent.CLEAR_COMMAND_EVENT, this.onClear);
			this.commandMenu_.addEventListener(CommandEvent.LOAD_COMMAND_EVENT, this.onLoad);
			this.commandMenu_.addEventListener(CommandEvent.SAVE_COMMAND_EVENT, this.onSave);
			this.commandMenu_.addEventListener(CommandEvent.SAVE_PREVIEW_COMMAND_EVENT, this.onSavePreview);
			addChild(this.commandMenu_);
			this.commandQueue_ = new CommandQueue();
			this.colorPicker_ = new ColorPicker();
			this.colorPicker_.x = 20;
			this.colorPicker_.y = 480;
			this.colorPicker_.addEventListener(Event.CHANGE, this.onColorChange);
			addChild(this.colorPicker_);
			this.modeDropDown_ = new ModeDropDown();
			this.modeDropDown_.x = MODE_DROPDOWN_X;
			this.modeDropDown_.y = MODE_DROPDOWN_Y;
			this.modeDropDown_.addEventListener(Event.CHANGE, this.onModeChange);
			addChild(this.modeDropDown_);
			this.resetSizeSelector();
			this.resetPixelDrawer();
			this.resetPreview();
		}

		protected function clearLoadedAttributes():void {
			this.name_ = "";
			this.type_ = 0;
			this.tags_ = "";
		}

		private function onColorChange(param1:Event):void {
			this.commandMenu_.setCommand(TMCommandMenu.DRAW_COMMAND);
		}

		private function onSizeChange(param1:Event):void {
			this.resetPixelDrawer();
		}

		private function onModeChange(param1:Event):void {
			this.resetSizeSelector();
			this.resetPixelDrawer();
			this.resetPreview();
		}

		private function resetSizeSelector():void {
			if (this.sizeDropDown_ != null) {
				removeChild(this.sizeDropDown_);
			}
			var loc1:String = this.modeDropDown_.getValue();
			switch (loc1) {
				case ModeDropDown.OBJECTS:
				case ModeDropDown.CHARACTERS:
					this.sizeDropDown_ = new ObjectSizeDropDown();
					break;
				case ModeDropDown.TEXTILES:
					this.sizeDropDown_ = new TextileSizeDropDown();
			}
			this.sizeDropDown_.x = MODE_DROPDOWN_X + 190;
			this.sizeDropDown_.y = MODE_DROPDOWN_Y;
			this.sizeDropDown_.addEventListener(Event.CHANGE, this.onSizeChange);
			addChild(this.sizeDropDown_);
		}

		private function resetPixelDrawer():void {
			this.clearLoadedAttributes();
			if (this.pixelDrawer_ != null) {
				removeChild(this.pixelDrawer_);
			}
			var loc1:String = this.modeDropDown_.getValue();
			var loc2:IntPoint = this.sizeDropDown_.getSize();
			switch (loc1) {
				case ModeDropDown.OBJECTS:
					this.pixelDrawer_ = new ObjectDrawer(360, 360, loc2.x_, loc2.y_, true);
					break;
				case ModeDropDown.CHARACTERS:
					this.pixelDrawer_ = new AnimationDrawer(360, 360, loc2.x_, loc2.y_);
					break;
				case ModeDropDown.TEXTILES:
					this.pixelDrawer_ = new ObjectDrawer(360, 360, loc2.x_, loc2.y_, false);
			}
			this.pixelDrawer_.x = 110;
			this.pixelDrawer_.y = 100;
			this.pixelDrawer_.addEventListener(PixelEvent.PIXEL_EVENT, this.onPixelEvent);
			this.pixelDrawer_.addEventListener(PixelEvent.TEMP_PIXEL_EVENT, this.onTempPixelEvent);
			this.pixelDrawer_.addEventListener(PixelEvent.UNDO_TEMP_EVENT, this.onUndoPixelEvent);
			this.pixelDrawer_.addEventListener(SetPixelsEvent.SET_PIXELS_EVENT, this.onSetPixelsEvent);
			this.pixelDrawer_.addEventListener(Event.CHANGE, this.onPixelDrawerChange);
			addChild(this.pixelDrawer_);
			if (this.preview_ != null) {
				this.preview_.setBitmapData(this.pixelDrawer_.getBitmapData());
			}
			this.commandQueue_.clear();
		}

		private function onPixelDrawerChange(param1:Event):void {
			this.preview_.setBitmapData(this.pixelDrawer_.getBitmapData());
		}

		private function resetPreview():void {
			if (this.preview_ != null) {
				removeChild(this.preview_);
			}
			var loc1:String = this.modeDropDown_.getValue();
			switch (loc1) {
				case ModeDropDown.OBJECTS:
					this.preview_ = new ObjectPreview(300, 360);
					break;
				case ModeDropDown.CHARACTERS:
					this.preview_ = new AnimationPreview(300, 360);
					break;
				case ModeDropDown.TEXTILES:
					this.preview_ = new TextilePreview(300, 360);
			}
			this.preview_.x = 485;
			this.preview_.y = 100;
			this.preview_.setBitmapData(this.pixelDrawer_.getBitmapData());
			addChild(this.preview_);
		}

		private function onPixelEvent(param1:PixelEvent):void {
			var loc2:CommandList = null;
			switch (this.commandMenu_.getCommand()) {
				case TMCommandMenu.DRAW_COMMAND:
					if (this.colorPicker_.getColor().equals(param1.pixel_.hsv_)) {
						return;
					}
					loc2 = new CommandList();
					loc2.addCommand(new TMCommand(param1.pixel_, param1.pixel_.hsv_, this.colorPicker_.getColor()));
					this.commandQueue_.addCommandList(loc2);
					break;
				case TMCommandMenu.ERASE_COMMAND:
					if (param1.pixel_.hsv_ == null) {
						return;
					}
					loc2 = new CommandList();
					loc2.addCommand(new TMCommand(param1.pixel_, param1.pixel_.hsv_, null));
					this.commandQueue_.addCommandList(loc2);
					break;
				case TMCommandMenu.SAMPLE_COMMAND:
					if (param1.pixel_.hsv_ == null) {
						return;
					}
					this.colorPicker_.setColor(param1.pixel_.hsv_);
					break;
			}
			this.preview_.setBitmapData(this.pixelDrawer_.getBitmapData());
		}

		private function onTempPixelEvent(param1:PixelEvent):void {
			switch (this.commandMenu_.getCommand()) {
				case TMCommandMenu.DRAW_COMMAND:
					if (this.colorPicker_.getColor().equals(param1.pixel_.hsv_)) {
						return;
					}
					param1.pixel_.setHSV(this.colorPicker_.getColor());
					break;
				case TMCommandMenu.ERASE_COMMAND:
					if (param1.pixel_.hsv_ == null) {
						return;
					}
					param1.pixel_.setHSV(null);
					break;
			}
			this.tempEvent_ = param1;
			this.preview_.setBitmapData(this.pixelDrawer_.getBitmapData());
		}

		private function onUndoPixelEvent(param1:PixelEvent):void {
			if (this.tempEvent_ == null) {
				return;
			}
			this.tempEvent_.pixel_.setHSV(this.tempEvent_.prevHSV_);
			this.preview_.setBitmapData(this.pixelDrawer_.getBitmapData());
			this.tempEvent_ = null;
		}

		private function onSetPixelsEvent(param1:SetPixelsEvent):void {
			var loc3:PixelColor = null;
			var loc2:CommandList = new CommandList();
			for each(loc3 in param1.pixelColors_) {
				loc2.addCommand(new TMCommand(loc3.pixel_, loc3.pixel_.hsv_, loc3.hsv_));
			}
			if (loc2.empty()) {
				return;
			}
			this.commandQueue_.addCommandList(loc2);
			this.preview_.setBitmapData(this.pixelDrawer_.getBitmapData());
		}

		private function onUndo(param1:CommandEvent):void {
			this.commandQueue_.undo();
			this.preview_.setBitmapData(this.pixelDrawer_.getBitmapData());
		}

		private function onRedo(param1:CommandEvent):void {
			this.commandQueue_.redo();
			this.preview_.setBitmapData(this.pixelDrawer_.getBitmapData());
		}

		private function onClear(param1:CommandEvent):void {
			this.pixelDrawer_.clear();
		}

		private function onLoad(param1:CommandEvent):void {
			file = new FileReference();
			file.addEventListener(Event.COMPLETE, this.onLoadComplete);
			file.addEventListener(Event.SELECT, this.onSelectFile);
			file.browse(FILTER);
		}

		private function onLoadComplete(event:Event):void {
			pixelDrawer_.loadBitmapData(PNGDecoder.decodeImage(file.data));
		}

		private function onSelectFile(event:Event):void {
			this.file.load();
		}

		private function onSave(param1:CommandEvent):void {
			new FileReference().save(PNGEncoder.encode(this.pixelDrawer_.getBitmapData()), this.name_ + ".png");
		}

		private function onSavePreview(param1:CommandEvent):void {
			new FileReference().save(PNGEncoder.encode(this.preview_.bitmap_.bitmapData), this.name_ + " Preview.png");
		}

		public function setTexture(param1:TextureData):void {
			switch (param1.type) {
				case PictureType.CHARACTER:
					this.modeDropDown_.setValue(ModeDropDown.CHARACTERS);
					break;
				case PictureType.TEXTILE:
					this.modeDropDown_.setValue(ModeDropDown.TEXTILES);
					break;
				default:
					this.modeDropDown_.setValue(ModeDropDown.OBJECTS);
			}
			var loc2:int = param1.bitmapData.width;
			if (loc2 > 16) {
				loc2 = loc2 / 7;
			}
			this.sizeDropDown_.setSize(loc2, param1.bitmapData.height);
			this.name_ = param1.name;
			this.type_ = param1.type;
			this.tags_ = param1.tags;
			this.pixelDrawer_.loadBitmapData(param1.bitmapData);
		}
	}
}
