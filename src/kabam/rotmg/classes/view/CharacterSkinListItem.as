 
package kabam.rotmg.classes.view {
	import com.company.assembleegameclient.util.Currency;
	import com.company.util.MoreColorUtil;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.DropShadowFilter;
	import flash.geom.ColorTransform;
	import flash.text.TextFieldAutoSize;
	import kabam.rotmg.classes.model.CharacterSkin;
	import kabam.rotmg.classes.model.CharacterSkinState;
	import kabam.rotmg.text.model.TextKey;
	import kabam.rotmg.text.view.TextFieldDisplayConcrete;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;
	import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
	import kabam.rotmg.text.view.stringBuilder.StringBuilder;
	import kabam.rotmg.util.components.RadioButton;
	import kabam.rotmg.util.components.api.BuyButton;
	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeMappedSignal;
	
	public class CharacterSkinListItem extends Sprite {
		
		public static const WIDTH:int = 420;
		
		public static const PADDING:int = 16;
		
		public static const HEIGHT:int = 60;
		
		private static const HIGHLIGHTED_COLOR:uint = 8092539;
		
		private static const AVAILABLE_COLOR:uint = 5921370;
		
		private static const LOCKED_COLOR:uint = 2631720;
		 
		
		private const grayscaleMatrix:ColorMatrixFilter = new ColorMatrixFilter(MoreColorUtil.greyscaleFilterMatrix);
		
		private const background:Shape = this.makeBackground();
		
		private const skinContainer:Sprite = this.makeSkinContainer();
		
		private const nameText:TextFieldDisplayConcrete = this.makeNameText();
		
		private const selectionButton:RadioButton = this.makeSelectionButton();
		
		private const lock:Bitmap = this.makeLock();
		
		private const lockText:TextFieldDisplayConcrete = this.makeLockText();
		
		private const buyButtonContainer:Sprite = this.makeBuyButtonContainer();
		
		private const limitedBanner:CharacterSkinLimitedBanner = this.makeLimitedBanner();
		
		public const buy:Signal = new NativeMappedSignal(this.buyButtonContainer,MouseEvent.CLICK);
		
		public const over:Signal = new Signal();
		
		public const out:Signal = new Signal();
		
		public const selected:Signal = this.selectionButton.changed;
		
		private var model:CharacterSkin;
		
		private var state:CharacterSkinState;
		
		private var isSelected:Boolean = false;
		
		private var skinIcon:Bitmap;
		
		private var buyButton:BuyButton;
		
		private var isOver:Boolean;
		
		public function CharacterSkinListItem() {
			this.state = CharacterSkinState.NULL;
			super();
		}
		
		private function makeBackground() : Shape {
			var loc1:Shape = new Shape();
			this.drawBackground(loc1.graphics,WIDTH);
			addChild(loc1);
			return loc1;
		}
		
		private function makeSkinContainer() : Sprite {
			var loc1:Sprite = null;
			loc1 = new Sprite();
			loc1.x = 4;
			loc1.y = 4;
			addChild(loc1);
			return loc1;
		}
		
		private function makeNameText() : TextFieldDisplayConcrete {
			var loc1:TextFieldDisplayConcrete = null;
			loc1 = new TextFieldDisplayConcrete().setSize(18).setColor(16777215).setBold(true);
			loc1.x = 60;
			loc1.setTextWidth(140);
			loc1.setWordWrap(true);
			loc1.setMultiLine(true);
			loc1.setAutoSize(TextFieldAutoSize.LEFT);
			loc1.filters = [new DropShadowFilter(0,0,0,1,8,8)];
			addChild(loc1);
			return loc1;
		}
		
		private function makeLockText() : TextFieldDisplayConcrete {
			var loc1:TextFieldDisplayConcrete = new TextFieldDisplayConcrete().setSize(14).setColor(16777215);
			loc1.setTextWidth(190);
			loc1.setWordWrap(true);
			loc1.setMultiLine(true);
			loc1.setAutoSize(TextFieldAutoSize.LEFT);
			addChild(loc1);
			return loc1;
		}
		
		private function makeSelectionButton() : RadioButton {
			var loc1:RadioButton = null;
			loc1 = new RadioButton();
			loc1.setSelected(false);
			loc1.x = 1 + WIDTH - loc1.width - 15;
			loc1.y = 1 + HEIGHT / 2 - loc1.height / 2;
			addChild(loc1);
			return loc1;
		}
		
		private function makeLock() : Bitmap {
			var loc1:Bitmap = new Bitmap();
			loc1.scaleX = 2;
			loc1.scaleY = 2;
			loc1.visible = false;
			addChild(loc1);
			return loc1;
		}
		
		public function setLockIcon(param1:BitmapData) : void {
			this.lock.bitmapData = param1;
			this.lock.x = this.lockText.x - this.lock.width - 5;
			this.lock.y = HEIGHT / 2 - this.lock.height * 0.5;
		}
		
		private function makeBuyButtonContainer() : Sprite {
			var loc1:Sprite = new Sprite();
			loc1.x = WIDTH - PADDING;
			loc1.y = PADDING;
			addChild(loc1);
			return loc1;
		}
		
		private function makeLimitedBanner() : CharacterSkinLimitedBanner {
			var loc1:CharacterSkinLimitedBanner = null;
			loc1 = new CharacterSkinLimitedBanner();
			loc1.readyForPositioning.addOnce(this.setLimitedBannerVisibility);
			loc1.y = -1;
			loc1.visible = false;
			addChild(loc1);
			return loc1;
		}
		
		public function setBuyButton(param1:BuyButton) : void {
			this.buyButton = param1;
			param1.readyForPlacement.add(this.onReadyForPlacement);
			this.model && this.setCost();
			this.buyButtonContainer.addChild(param1);
			param1.x = -param1.width;
			this.buyButtonContainer.visible = this.state == CharacterSkinState.PURCHASABLE;
			this.setLimitedBannerVisibility();
		}
		
		private function onReadyForPlacement() : void {
			this.buyButton.x = -this.buyButton.width;
		}
		
		public function setSkin(param1:Bitmap) : void {
			this.skinIcon && this.skinContainer.removeChild(this.skinIcon);
			this.skinIcon = param1;
			this.skinIcon && this.skinContainer.addChild(this.skinIcon);
		}
		
		public function getModel() : CharacterSkin {
			return this.model;
		}
		
		public function setModel(param1:CharacterSkin) : void {
			this.model && this.model.changed.remove(this.onModelChanged);
			this.model = param1;
			this.model && this.model.changed.add(this.onModelChanged);
			this.onModelChanged(this.model);
			addEventListener(MouseEvent.MOUSE_OVER,this.onOver);
			addEventListener(MouseEvent.MOUSE_OUT,this.onOut);
		}
		
		private function onModelChanged(param1:CharacterSkin) : void {
			this.state = !!this.model?this.model.getState():CharacterSkinState.NULL;
			this.updateName();
			this.updateState();
			this.buyButton && this.setCost();
			this.updateUnlockText();
			this.setLimitedBannerVisibility();
			this.setIsSelected(this.model && this.model.getIsSelected());
		}
		
		public function getState() : CharacterSkinState {
			return this.state;
		}
		
		private function updateName() : void {
			this.nameText.setStringBuilder(new LineBuilder().setParams(!!this.model?this.model.name:""));
			this.nameText.textChanged.addOnce(this.alignName);
		}
		
		private function alignName() : void {
			this.nameText.y = HEIGHT / 2 - this.nameText.height / 2;
		}
		
		private function updateState() : void {
			this.setButtonVisibilities();
			this.updateBackground();
			this.setEventListeners();
			this.updateGrayFilter();
		}
		
		private function setLimitedBannerVisibility() : void {
			this.limitedBanner.visible = this.model && this.model.limited && this.state != CharacterSkinState.OWNED && this.state != CharacterSkinState.PURCHASING;
			this.limitedBanner.x = (this.state == CharacterSkinState.LOCKED || !this.buyButton?this.lock.x - 5:this.buyButtonContainer.x + this.buyButton.x - 15) - this.limitedBanner.width;
		}
		
		private function setButtonVisibilities() : void {
			var loc1:* = this.state == CharacterSkinState.OWNED;
			var loc2:* = this.state == CharacterSkinState.PURCHASABLE;
			var loc3:* = this.state == CharacterSkinState.PURCHASING;
			var loc4:* = this.state == CharacterSkinState.LOCKED;
			this.selectionButton.visible = loc1;
			this.buyButtonContainer && (this.buyButtonContainer.visible = loc2);
			this.lock.visible = loc4;
			this.lockText.visible = loc4 || loc3;
		}
		
		private function setEventListeners() : void {
			if(this.state == CharacterSkinState.OWNED) {
				this.addEventListeners();
			} else {
				this.removeEventListeners();
			}
		}
		
		private function setCost() : void {
			var loc1:int = !!this.model?int(this.model.cost):0;
			this.buyButton.setPrice(loc1,Currency.GOLD);
		}
		
		public function getIsSelected() : Boolean {
			return this.isSelected;
		}
		
		public function setIsSelected(param1:Boolean) : void {
			this.isSelected = param1 && this.state == CharacterSkinState.OWNED;
			this.selectionButton.setSelected(param1);
			this.updateBackground();
		}
		
		private function updateUnlockText() : void {
			if(this.model != null && this.model.unlockSpecial != null) {
				this.lockText.setStringBuilder(new StaticStringBuilder(this.model.unlockSpecial));
			} else {
				this.lockText.setStringBuilder(this.state == CharacterSkinState.PURCHASING?new LineBuilder().setParams(TextKey.PURCHASING_SKIN):this.makeUnlockTextStringBuilder());
			}
			this.lockText.textChanged.addOnce(this.alignText);
		}
		
		private function alignText() : void {
			this.lockText.y = HEIGHT / 2 - this.lockText.height / 2;
			this.setTextPosition(WIDTH);
		}
		
		private function makeUnlockTextStringBuilder() : StringBuilder {
			var loc1:LineBuilder = new LineBuilder();
			var loc2:String = !!this.model?this.model.unlockLevel.toString():"";
			return loc1.setParams(TextKey.UNLOCK_LEVEL_SKIN,{"level":loc2});
		}
		
		private function addEventListeners() : void {
			addEventListener(MouseEvent.CLICK,this.onClick);
		}
		
		function removeEventListeners() : void {
			removeEventListener(MouseEvent.CLICK,this.onClick);
		}
		
		private function onClick(param1:MouseEvent) : void {
			this.setIsSelected(true);
		}
		
		private function onOver(param1:MouseEvent) : void {
			this.isOver = true;
			this.updateBackground();
			this.over.dispatch();
		}
		
		private function onOut(param1:MouseEvent) : void {
			this.isOver = false;
			this.updateBackground();
			this.out.dispatch();
		}
		
		private function updateBackground() : void {
			var loc1:ColorTransform = this.background.transform.colorTransform;
			loc1.color = this.getColor();
			this.background.transform.colorTransform = loc1;
		}
		
		private function getColor() : uint {
			if(this.state.isDisabled()) {
				return LOCKED_COLOR;
			}
			if(this.isSelected || this.isOver) {
				return HIGHLIGHTED_COLOR;
			}
			return AVAILABLE_COLOR;
		}
		
		private function updateGrayFilter() : void {
			filters = this.state == CharacterSkinState.PURCHASING?[this.grayscaleMatrix]:[];
		}
		
		public function setWidth(param1:int) : void {
			this.buyButtonContainer.x = param1 - PADDING;
			this.setTextPosition(param1);
			this.selectionButton.x = param1 - this.selectionButton.width - 15;
			this.setLimitedBannerVisibility();
			this.drawBackground(this.background.graphics,param1);
		}
		
		private function setTextPosition(param1:int) : void {
			this.lockText.x = param1 - this.lockText.width - 4;
			this.lock.x = this.lockText.x - this.lock.width - 4;
		}
		
		private function drawBackground(param1:Graphics, param2:int) : void {
			param1.clear();
			param1.beginFill(AVAILABLE_COLOR);
			param1.drawRect(0,0,param2,HEIGHT);
			param1.endFill();
		}
	}
}
