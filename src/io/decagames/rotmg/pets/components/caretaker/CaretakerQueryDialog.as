 
package io.decagames.rotmg.pets.components.caretaker {
	import com.company.assembleegameclient.ui.DeprecatedTextButton;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	import io.decagames.rotmg.pets.utils.PetsViewAssetFactory;
	import kabam.rotmg.pets.view.components.PopupWindowBackground;
	import kabam.rotmg.text.view.TextFieldDisplayConcrete;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;
	import kabam.rotmg.ui.view.SignalWaiter;
	import kabam.rotmg.util.graphics.ButtonLayoutHelper;
	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeMappedSignal;
	
	public class CaretakerQueryDialog extends Sprite {
		
		public static const WIDTH:int = 480;
		
		public static const HEIGHT:int = 428;
		
		public static const TITLE:String = "CaretakerQueryDialog.title";
		
		public static const QUERY:String = "CaretakerQueryDialog.query";
		
		public static const CLOSE:String = "Close.text";
		
		public static const BACK:String = "Screens.back";
		
		public static const CATEGORIES:Array = [{
			"category":"CaretakerQueryDialog.category_petYard",
			"info":"CaretakerQueryDialog.info_petYard"
		},{
			"category":"CaretakerQueryDialog.category_pets",
			"info":"CaretakerQueryDialog.info_pets"
		},{
			"category":"CaretakerQueryDialog.category_abilities",
			"info":"CaretakerQueryDialog.info_abilities"
		},{
			"category":"CaretakerQueryDialog.category_feedingPets",
			"info":"CaretakerQueryDialog.info_feedingPets"
		},{
			"category":"CaretakerQueryDialog.category_fusingPets",
			"info":"CaretakerQueryDialog.info_fusingPets"
		},{
			"category":"CaretakerQueryDialog.category_evolution",
			"info":"CaretakerQueryDialog.info_evolution"
		}];
		 
		
		private const layoutWaiter:SignalWaiter = this.makeDeferredLayout();
		
		private const container:DisplayObjectContainer = this.makeContainer();
		
		private const background:PopupWindowBackground = this.makeBackground();
		
		private const caretaker:CaretakerQueryDialogCaretaker = this.makeCaretaker();
		
		private const title:TextFieldDisplayConcrete = this.makeTitle();
		
		private const categories:CaretakerQueryDialogCategoryList = this.makeCategoryList();
		
		private const backButton:DeprecatedTextButton = this.makeBackButton();
		
		private const closeButton:DeprecatedTextButton = this.makeCloseButton();
		
		public const closed:Signal = new NativeMappedSignal(this.closeButton,MouseEvent.CLICK);
		
		public function CaretakerQueryDialog() {
			super();
		}
		
		private function makeDeferredLayout() : SignalWaiter {
			var loc1:SignalWaiter = new SignalWaiter();
			loc1.complete.addOnce(this.onLayout);
			return loc1;
		}
		
		private function onLayout() : void {
			var loc1:ButtonLayoutHelper = new ButtonLayoutHelper();
			loc1.layout(WIDTH,this.closeButton);
			loc1.layout(WIDTH,this.backButton);
		}
		
		private function makeContainer() : DisplayObjectContainer {
			var loc1:Sprite = null;
			loc1 = new Sprite();
			loc1.x = (800 - WIDTH) / 2;
			loc1.y = (600 - HEIGHT) / 2;
			addChild(loc1);
			return loc1;
		}
		
		private function makeBackground() : PopupWindowBackground {
			var loc1:PopupWindowBackground = new PopupWindowBackground();
			loc1.draw(WIDTH,HEIGHT);
			loc1.divide(PopupWindowBackground.HORIZONTAL_DIVISION,34);
			this.container.addChild(loc1);
			return loc1;
		}
		
		private function makeCaretaker() : CaretakerQueryDialogCaretaker {
			var loc1:CaretakerQueryDialogCaretaker = null;
			loc1 = new CaretakerQueryDialogCaretaker();
			loc1.x = 20;
			loc1.y = 50;
			this.container.addChild(loc1);
			return loc1;
		}
		
		private function makeTitle() : TextFieldDisplayConcrete {
			var loc1:TextFieldDisplayConcrete = null;
			loc1 = PetsViewAssetFactory.returnTextfield(16777215,18,true);
			loc1.setStringBuilder(new LineBuilder().setParams(TITLE));
			loc1.setAutoSize(TextFieldAutoSize.CENTER);
			loc1.x = WIDTH / 2;
			loc1.y = 24;
			this.container.addChild(loc1);
			return loc1;
		}
		
		private function makeBackButton() : DeprecatedTextButton {
			var loc1:DeprecatedTextButton = null;
			loc1 = new DeprecatedTextButton(16,BACK,80);
			loc1.y = 382;
			loc1.visible = false;
			loc1.addEventListener(MouseEvent.CLICK,this.onBack);
			this.container.addChild(loc1);
			this.layoutWaiter.push(loc1.textChanged);
			return loc1;
		}
		
		private function onBack(param1:MouseEvent) : void {
			this.caretaker.showSpeech();
			this.categories.visible = true;
			this.closeButton.visible = true;
			this.backButton.visible = false;
		}
		
		private function makeCloseButton() : DeprecatedTextButton {
			var loc1:DeprecatedTextButton = new DeprecatedTextButton(16,CLOSE,110);
			loc1.y = 382;
			this.container.addChild(loc1);
			this.layoutWaiter.push(loc1.textChanged);
			return loc1;
		}
		
		private function makeCategoryList() : CaretakerQueryDialogCategoryList {
			var loc1:CaretakerQueryDialogCategoryList = new CaretakerQueryDialogCategoryList(CATEGORIES);
			loc1.x = 20;
			loc1.y = 110;
			loc1.selected.add(this.onCategorySelected);
			this.container.addChild(loc1);
			this.layoutWaiter.push(loc1.ready);
			return loc1;
		}
		
		private function onCategorySelected(param1:String) : void {
			this.categories.visible = false;
			this.closeButton.visible = false;
			this.backButton.visible = true;
			this.caretaker.showDetail(param1);
		}
		
		public function setCaretakerIcon(param1:BitmapData) : void {
			this.caretaker.setCaretakerIcon(param1);
		}
	}
}
