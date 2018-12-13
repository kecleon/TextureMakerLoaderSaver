 
package kabam.rotmg.mysterybox.components {
	import com.company.assembleegameclient.ui.dialogs.Dialog;
	import com.company.assembleegameclient.util.Currency;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	import flash.utils.getTimer;
	import kabam.rotmg.core.StaticInjectorContext;
	import kabam.rotmg.dialogs.control.OpenDialogSignal;
	import kabam.rotmg.mysterybox.model.MysteryBoxInfo;
	import kabam.rotmg.pets.view.components.PopupWindowBackground;
	import kabam.rotmg.text.view.TextFieldDisplayConcrete;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;
	import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
	import kabam.rotmg.util.components.LegacyBuyButton;
	import kabam.rotmg.util.components.UIAssetsHelper;
	
	public class MysteryBoxSelectEntry extends Sprite {
		
		public static var redBarEmbed:Class = MysteryBoxSelectEntry_redBarEmbed;
		 
		
		public var mbi:MysteryBoxInfo;
		
		private var buyButton:LegacyBuyButton;
		
		private var leftNavSprite:Sprite;
		
		private var rightNavSprite:Sprite;
		
		private var iconImage:DisplayObject;
		
		private var infoImageBorder:PopupWindowBackground;
		
		private var infoImage:DisplayObject;
		
		private var newText:TextFieldDisplayConcrete;
		
		private var sale:TextFieldDisplayConcrete;
		
		private var left:TextFieldDisplayConcrete;
		
		private var hoverState:Boolean = false;
		
		private var descriptionShowing:Boolean = false;
		
		private var redbar:DisplayObject;
		
		private const newString:String = "MysteryBoxSelectEntry.newString";
		
		private const onSaleString:String = "MysteryBoxSelectEntry.onSaleString";
		
		private const saleEndString:String = "MysteryBoxSelectEntry.saleEndString";
		
		private var soldOut:Boolean;
		
		private var _quantity:int;
		
		private var title:TextFieldDisplayConcrete;
		
		public function MysteryBoxSelectEntry(param1:MysteryBoxInfo) {
			var loc2:DisplayObject = null;
			super();
			this.redbar = new redBarEmbed();
			this.redbar.y = -5;
			this.redbar.width = MysteryBoxSelectModal.modalWidth - 5;
			this.redbar.height = MysteryBoxSelectModal.aMysteryBoxHeight - 8;
			addChild(this.redbar);
			loc2 = new redBarEmbed();
			loc2.y = 0;
			loc2.width = MysteryBoxSelectModal.modalWidth - 5;
			loc2.height = MysteryBoxSelectModal.aMysteryBoxHeight - 8 + 5;
			loc2.alpha = 0;
			addChild(loc2);
			this.mbi = param1;
			this._quantity = 1;
			this.title = this.getText(this.mbi.title,74,20,18,true);
			this.title.textChanged.addOnce(this.updateTextPosition);
			addChild(this.title);
			this.addNewText();
			this.buyButton = new LegacyBuyButton("",16,0,Currency.INVALID,false,this.mbi.isOnSale());
			if(this.mbi.unitsLeft == 0) {
				this.buyButton.setText(LineBuilder.getLocalizedStringFromKey("MysteryBoxError.soldOutButton"));
			} else if(this.mbi.isOnSale()) {
				this.buyButton.setPrice(this.mbi.saleAmount,this.mbi.saleCurrency);
			} else {
				this.buyButton.setPrice(this.mbi.priceAmount,this.mbi.priceCurrency);
			}
			this.buyButton.x = MysteryBoxSelectModal.modalWidth - 120;
			this.buyButton.y = 16;
			this.buyButton._width = 70;
			this.addSaleText();
			if(this.mbi.unitsLeft > 0 || this.mbi.unitsLeft == -1) {
				this.buyButton.addEventListener(MouseEvent.CLICK,this.onBoxBuy);
			}
			addChild(this.buyButton);
			this.iconImage = this.mbi.iconImage;
			this.infoImage = this.mbi.infoImage;
			if(this.iconImage == null) {
				this.mbi.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onImageLoadComplete);
			} else {
				this.addIconImageChild();
			}
			if(this.infoImage == null) {
				this.mbi.infoImageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onInfoLoadComplete);
			} else {
				this.addInfoImageChild();
			}
			this.mbi.quantity = this._quantity;
			if(this.mbi.unitsLeft > 0 || this.mbi.unitsLeft == -1) {
				this.leftNavSprite = UIAssetsHelper.createLeftNevigatorIcon(UIAssetsHelper.LEFT_NEVIGATOR,3);
				this.leftNavSprite.x = this.buyButton.x + this.buyButton.width + 45;
				this.leftNavSprite.y = this.buyButton.y + this.buyButton.height / 2 - 2;
				this.leftNavSprite.addEventListener(MouseEvent.CLICK,this.onClick);
				addChild(this.leftNavSprite);
				this.rightNavSprite = UIAssetsHelper.createLeftNevigatorIcon(UIAssetsHelper.RIGHT_NEVIGATOR,3);
				this.rightNavSprite.x = this.buyButton.x + this.buyButton.width + 45;
				this.rightNavSprite.y = this.buyButton.y + this.buyButton.height / 2 - 16;
				this.rightNavSprite.addEventListener(MouseEvent.CLICK,this.onClick);
				addChild(this.rightNavSprite);
			}
			this.addUnitsLeftText();
			addEventListener(MouseEvent.ROLL_OVER,this.onHover);
			addEventListener(MouseEvent.ROLL_OUT,this.onRemoveHover);
			addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
		}
		
		private function updateTextPosition() : void {
			this.title.y = Math.round((this.redbar.height - (this.title.getTextHeight() + (this.title.textField.numLines == 1?8:10))) / 2);
			if((this.mbi.isNew() || this.mbi.isOnSale()) && this.title.textField.numLines == 2) {
				this.title.y = this.title.y + 6;
			}
		}
		
		public function updateContent() : void {
			if(this.left) {
				this.left.setStringBuilder(new LineBuilder().setParams(this.mbi.unitsLeft + " " + LineBuilder.getLocalizedStringFromKey("MysteryBoxSelectEntry.left")));
			}
		}
		
		private function addUnitsLeftText() : void {
			var loc1:uint = 0;
			var loc2:int = 0;
			if(this.mbi.unitsLeft >= 0) {
				loc2 = this.mbi.unitsLeft / this.mbi.totalUnits;
				if(loc2 <= 0.1) {
					loc1 = 16711680;
				} else if(loc2 <= 0.5) {
					loc1 = 16754944;
				} else {
					loc1 = 65280;
				}
				this.left = this.getText(this.mbi.unitsLeft + " left",20,46,11).setColor(loc1);
				addChild(this.left);
			}
		}
		
		private function markAsSold() : void {
			this.buyButton.setPrice(0,Currency.INVALID);
			this.buyButton.setText(LineBuilder.getLocalizedStringFromKey("MysteryBoxError.soldOutButton"));
			if(this.leftNavSprite && this.leftNavSprite.parent == this) {
				removeChild(this.leftNavSprite);
				this.leftNavSprite.removeEventListener(MouseEvent.CLICK,this.onClick);
			}
			if(this.rightNavSprite && this.rightNavSprite.parent == this) {
				removeChild(this.rightNavSprite);
				this.rightNavSprite.removeEventListener(MouseEvent.CLICK,this.onClick);
			}
		}
		
		private function onHover(param1:MouseEvent) : void {
			this.hoverState = true;
			this.addInfoImageChild();
		}
		
		private function onRemoveHover(param1:MouseEvent) : void {
			this.hoverState = false;
			this.removeInfoImageChild();
		}
		
		private function onClick(param1:MouseEvent) : void {
			switch(param1.currentTarget) {
				case this.rightNavSprite:
					if(this._quantity == 1) {
						this._quantity = this._quantity + 4;
					} else if(this._quantity < 10) {
						this._quantity = this._quantity + 5;
					}
					break;
				case this.leftNavSprite:
					if(this._quantity == 10) {
						this._quantity = this._quantity - 5;
					} else if(this._quantity > 1) {
						this._quantity = this._quantity - 4;
					}
			}
			this.mbi.quantity = this._quantity;
			if(this.mbi.isOnSale()) {
				this.buyButton.setPrice(this.mbi.saleAmount * this._quantity,this.mbi.saleCurrency);
			} else {
				this.buyButton.setPrice(this.mbi.priceAmount * this._quantity,this.mbi.priceCurrency);
			}
		}
		
		private function addNewText() : void {
			if(this.mbi.isNew() && !this.mbi.isOnSale()) {
				this.newText = this.getText(this.newString,74,0).setColor(16768512);
				addChild(this.newText);
			}
		}
		
		private function onEnterFrame(param1:Event) : void {
			var loc2:Number = 1.05 + 0.05 * Math.sin(getTimer() / 200);
			if(this.sale) {
				this.sale.scaleX = loc2;
				this.sale.scaleY = loc2;
			}
			if(this.newText) {
				this.newText.scaleX = loc2;
				this.newText.scaleY = loc2;
			}
			if(this.mbi.unitsLeft == 0 && !this.soldOut) {
				this.soldOut = true;
				this.markAsSold();
			}
		}
		
		private function addSaleText() : void {
			var loc1:LineBuilder = null;
			var loc2:TextFieldDisplayConcrete = null;
			var loc3:TextFieldDisplayConcrete = null;
			if(this.mbi.isOnSale()) {
				this.sale = this.getText(this.onSaleString,74,0).setColor(65280);
				addChild(this.sale);
				loc1 = this.mbi.getSaleTimeLeftStringBuilder();
				loc2 = this.getText("",this.buyButton.x,this.buyButton.y + this.buyButton.height + 10,10).setColor(16711680);
				loc2.setStringBuilder(loc1);
				addChild(loc2);
				loc3 = this.getText(LineBuilder.getLocalizedStringFromKey("MysteryBoxSelectEntry.was") + " " + this.mbi.priceAmount + " " + this.mbi.currencyName,this.buyButton.x,this.buyButton.y - 14,10).setColor(16711680);
				addChild(loc3);
			}
		}
		
		private function onImageLoadComplete(param1:Event) : void {
			this.mbi.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onImageLoadComplete);
			this.iconImage = DisplayObject(this.mbi.loader);
			this.addIconImageChild();
		}
		
		private function onInfoLoadComplete(param1:Event) : void {
			this.mbi.infoImageLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onInfoLoadComplete);
			this.infoImage = DisplayObject(this.mbi.infoImageLoader);
			this.addInfoImageChild();
		}
		
		public function getText(param1:String, param2:int, param3:int, param4:int = 12, param5:Boolean = false) : TextFieldDisplayConcrete {
			var loc6:TextFieldDisplayConcrete = new TextFieldDisplayConcrete().setSize(param4).setColor(16777215).setTextWidth(MysteryBoxSelectModal.modalWidth - 185);
			loc6.setBold(true);
			if(param5) {
				loc6.setStringBuilder(new StaticStringBuilder(param1));
			} else {
				loc6.setStringBuilder(new LineBuilder().setParams(param1));
			}
			loc6.setWordWrap(true);
			loc6.setMultiLine(true);
			loc6.setAutoSize(TextFieldAutoSize.LEFT);
			loc6.setHorizontalAlign(TextFormatAlign.LEFT);
			loc6.filters = [new DropShadowFilter(0,0,0)];
			loc6.x = param2;
			loc6.y = param3;
			return loc6;
		}
		
		private function addIconImageChild() : void {
			if(this.iconImage == null) {
				return;
			}
			this.iconImage.width = 58;
			this.iconImage.height = 58;
			this.iconImage.x = 14;
			if(this.mbi.unitsLeft != -1) {
				this.iconImage.y = -6;
			} else {
				this.iconImage.y = 1;
			}
			addChild(this.iconImage);
		}
		
		private function addInfoImageChild() : void {
			var loc3:Array = null;
			var loc4:ColorMatrixFilter = null;
			if(this.infoImage == null) {
				return;
			}
			var loc1:int = 8;
			this.infoImage.width = 291 - loc1;
			this.infoImage.height = 598 - loc1 * 2 - 2;
			var loc2:Point = this.globalToLocal(new Point(MysteryBoxSelectModal.getRightBorderX() + 1 + 14,2 + loc1));
			this.infoImage.x = loc2.x;
			this.infoImage.y = loc2.y;
			if(this.hoverState && !this.descriptionShowing) {
				this.descriptionShowing = true;
				addChild(this.infoImage);
				this.infoImageBorder = new PopupWindowBackground();
				this.infoImageBorder.draw(this.infoImage.width,this.infoImage.height + 2,PopupWindowBackground.TYPE_TRANSPARENT_WITHOUT_HEADER);
				this.infoImageBorder.x = this.infoImage.x;
				this.infoImageBorder.y = this.infoImage.y - 1;
				addChild(this.infoImageBorder);
				loc3 = [3.0742,-1.8282,-0.246,0,50,-0.9258,2.1718,-0.246,0,50,-0.9258,-1.8282,3.754,0,50,0,0,0,1,0];
				loc4 = new ColorMatrixFilter(loc3);
				this.redbar.filters = [loc4];
			}
		}
		
		private function removeInfoImageChild() : void {
			if(this.descriptionShowing) {
				removeChild(this.infoImageBorder);
				removeChild(this.infoImage);
				this.descriptionShowing = false;
				this.redbar.filters = [];
			}
		}
		
		private function onBoxBuy(param1:MouseEvent) : void {
			var loc2:OpenDialogSignal = null;
			var loc3:String = null;
			var loc4:Dialog = null;
			var loc5:MysteryBoxRollModal = null;
			var loc6:Boolean = false;
			var loc7:OpenDialogSignal = null;
			if(this.mbi.unitsLeft != -1 && this._quantity > this.mbi.unitsLeft) {
				loc2 = StaticInjectorContext.getInjector().getInstance(OpenDialogSignal);
				loc3 = "";
				if(this.mbi.unitsLeft == 0) {
					loc3 = "MysteryBoxError.soldOutAll";
				} else {
					loc3 = LineBuilder.getLocalizedStringFromKey("MysteryBoxError.soldOutLeft",{
						"left":this.mbi.unitsLeft,
						"box":(this.mbi.unitsLeft == 1?LineBuilder.getLocalizedStringFromKey("MysteryBoxError.box"):LineBuilder.getLocalizedStringFromKey("MysteryBoxError.boxes"))
					});
				}
				loc4 = new Dialog("MysteryBoxRollModal.purchaseFailedString",loc3,"MysteryBoxRollModal.okString",null,null);
				loc4.addEventListener(Dialog.LEFT_BUTTON,this.onErrorOk);
				loc2.dispatch(loc4);
			} else {
				loc5 = new MysteryBoxRollModal(this.mbi,this._quantity);
				loc6 = loc5.moneyCheckPass();
				if(loc6) {
					loc5.parentSelectModal = MysteryBoxSelectModal(parent.parent);
					loc7 = StaticInjectorContext.getInjector().getInstance(OpenDialogSignal);
					loc7.dispatch(loc5);
				}
			}
		}
		
		private function onErrorOk(param1:Event) : void {
			var loc2:OpenDialogSignal = null;
			loc2 = StaticInjectorContext.getInjector().getInstance(OpenDialogSignal);
			loc2.dispatch(new MysteryBoxSelectModal());
		}
	}
}
