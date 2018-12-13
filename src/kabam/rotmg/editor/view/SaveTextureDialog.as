 
package kabam.rotmg.editor.view {
	import com.company.ui.BaseSimpleText;
	import com.company.util.GraphicsUtil;
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
	import kabam.rotmg.editor.model.TextureData;
	import kabam.rotmg.editor.view.components.savedialog.NameInputField;
	import kabam.rotmg.editor.view.components.savedialog.TagsInputField;
	import kabam.rotmg.editor.view.components.savedialog.TypeInputField;
	import kabam.rotmg.text.model.TextKey;
	import org.osflash.signals.Signal;
	
	public class SaveTextureDialog extends Sprite {
		
		private static const WIDTH:int = 400;
		
		private static const outlineFill:GraphicsSolidFill = new GraphicsSolidFill(16777215,1);
		
		private static const lineStyle:GraphicsStroke = new GraphicsStroke(1,false,LineScaleMode.NORMAL,CapsStyle.NONE,JointStyle.ROUND,3,outlineFill);
		
		private static const backgroundFill:GraphicsSolidFill = new GraphicsSolidFill(3552822,1);
		
		private static const path:GraphicsPath = new GraphicsPath(new Vector.<int>(),new Vector.<Number>());
		
		private static var graphicsData:Vector.<IGraphicsData>;

		public const saveTexture:Signal = new Signal(TextureData);

		public const cancel:Signal = new Signal();

		private var data:TextureData;

		private var darkBox:Shape;

		private var box:Sprite;

		private var rect_:Shape;

		private var titleText_:BaseSimpleText = null;

		private var nameText_:NameInputField = null;

		private var typeInput_:TypeInputField = null;

		private var tagsInput_:TagsInputField = null;

		private var saveButton_:StaticTextButton = null;

		private var cancelButton_:StaticTextButton = null;

		private var errorText_:BaseSimpleText;

		public function SaveTextureDialog(param1:TextureData) {
			this.box = new Sprite();

			graphicsData = new <IGraphicsData>[lineStyle,backgroundFill,path,GraphicsUtil.END_FILL,GraphicsUtil.END_STROKE];
			super();
			this.data = param1;
			this.box = new Sprite();
			this.titleText_ = new BaseSimpleText(22,5746018,false,WIDTH,0);
			this.titleText_.setBold(true);
			this.titleText_.htmlText = "<p align=\"center\">Save</p>";
			this.titleText_.updateMetrics();
			this.titleText_.filters = [new DropShadowFilter(0,0,0,1,8,8,1)];
			this.titleText_.y = 4;
			this.box.addChild(this.titleText_);
			this.nameText_ = new NameInputField(param1.name);
			this.nameText_.x = 20;
			this.nameText_.y = 50;
			this.box.addChild(this.nameText_);
			this.tagsInput_ = new TagsInputField(param1.tags);
			this.tagsInput_.x = 20;
			this.tagsInput_.y = 180;
			this.box.addChild(this.tagsInput_);
			this.saveButton_ = new StaticTextButton(16,TextKey.SAVETEXTUREDIALOG_SAVE,120);
			this.saveButton_.x = WIDTH - this.saveButton_.width - 20;
			this.saveButton_.y = 330;
			this.saveButton_.addEventListener(MouseEvent.CLICK,this.onSaveClick);
			this.box.addChild(this.saveButton_);
			this.cancelButton_ = new StaticTextButton(16,TextKey.SAVETEXTUREDIALOG_CANCEL,120);
			this.cancelButton_.x = WIDTH - this.saveButton_.width - this.cancelButton_.width - 40;
			this.cancelButton_.y = 330;
			this.cancelButton_.addEventListener(MouseEvent.CLICK,this.onCancelClick);
			this.box.addChild(this.cancelButton_);
			this.errorText_ = new BaseSimpleText(14,16549442,false,0,0);
			this.errorText_.text = "";
			this.errorText_.updateMetrics();
			this.errorText_.x = WIDTH / 2 - this.errorText_.width / 2;
			this.errorText_.y = 290;
			this.errorText_.filters = [new DropShadowFilter(0,0,0)];
			this.box.addChild(this.errorText_);
			this.typeInput_ = new TypeInputField(param1.types,param1.type);
			this.typeInput_.x = 20;
			this.typeInput_.y = 110;
			this.box.addChild(this.typeInput_);
			addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
		}
		
		private function setError(param1:String) : void {
			this.errorText_.text = param1;
			this.errorText_.updateMetrics();
			this.errorText_.x = WIDTH / 2 - this.errorText_.width / 2;
		}
		
		private function onCancelClick(param1:MouseEvent) : void {
			this.cancel.dispatch();
		}
		
		private function onSaveClick(param1:MouseEvent) : void {
			if(this.isNameValid() && this.isTypeValid()) {
				this.cancelButton_.setEnabled(false);
				this.saveButton_.setEnabled(false);
				this.data.name = this.nameText_.text();
				this.data.type = this.typeInput_.getType();
				this.data.tags = this.tagsInput_.text();
				this.saveTexture.dispatch(this.data);
			}
		}
		
		private function isNameValid() : Boolean {
			var loc1:* = this.nameText_.text() != "";
			if(!loc1) {
				this.setError("You must set a name");
			}
			return loc1;
		}
		
		private function isTypeValid() : Boolean {
			var loc1:* = this.typeInput_.getType() != 0;
			if(!loc1) {
				this.setError("You must select a type");
			}
			return loc1;
		}
		
		private function onAddedToStage(param1:Event) : void {
			var loc2:Graphics = null;
			GraphicsUtil.clearPath(path);
			GraphicsUtil.drawCutEdgeRect(0,0,WIDTH,this.box.height + 20,4,[1,1,1,1],path);
			this.rect_ = new Shape();
			loc2 = this.rect_.graphics;
			loc2.drawGraphicsData(graphicsData);
			this.box.addChildAt(this.rect_,0);
			this.box.x = stage.stageWidth / 2 - this.box.width / 2;
			this.box.y = stage.stageHeight / 2 - this.box.height / 2;
			this.box.filters = [new DropShadowFilter(0,0,0,1,16,16,1)];
			addChild(this.box);
			this.darkBox = new Shape();
			loc2 = this.darkBox.graphics;
			loc2.clear();
			loc2.beginFill(0,0.8);
			loc2.drawRect(0,0,stage.stageWidth,stage.stageHeight);
			loc2.endFill();
			addChildAt(this.darkBox,0);
		}
	}
}
