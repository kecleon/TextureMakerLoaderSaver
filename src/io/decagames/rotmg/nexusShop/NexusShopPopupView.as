 
package io.decagames.rotmg.nexusShop {
	import com.company.assembleegameclient.objects.SellableObject;
	import com.company.assembleegameclient.util.FilterUtil;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFieldAutoSize;
	import io.decagames.rotmg.shop.ShopBuyButton;
	import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
	import io.decagames.rotmg.ui.labels.UILabel;
	import io.decagames.rotmg.ui.popups.modal.ModalPopup;
	import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
	import io.decagames.rotmg.ui.spinner.FixedNumbersSpinner;
	import io.decagames.rotmg.ui.texture.TextureParser;
	import kabam.rotmg.fortune.components.ItemWithTooltip;
	import kabam.rotmg.text.view.TextFieldDisplayConcrete;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;
	import org.osflash.signals.Signal;
	
	public class NexusShopPopupView extends ModalPopup {
		
		public static const TITLE:String = "Purchase";
		
		public static const WIDTH:int = 300;
		
		public static const HEIGHT:int = 170;
		 
		
		private var availableInventoryNumber:int;
		
		private var owner_:SellableObject;
		
		public var buyItem:Signal;
		
		public var buttonWidth:int;
		
		public var descriptionLabel:UILabel;
		
		private var nameText_:TextFieldDisplayConcrete;
		
		public var itemLabel:UILabel;
		
		private var quantity_:int = 1;
		
		private var buySectionContainer:Sprite;
		
		public var buyButton:ShopBuyButton;
		
		public var spinner:FixedNumbersSpinner;
		
		private var buyButtonBackground:SliceScalingBitmap;
		
		public function NexusShopPopupView(param1:Signal, param2:SellableObject, param3:Number, param4:int) {
			super(WIDTH,HEIGHT,TITLE,DefaultLabelFormat.defaultSmallPopupTitle,new Rectangle(0,0,525,230),0);
			this.buyItem = param1;
			this.owner_ = param2;
			this.buttonWidth = param3;
			this.availableInventoryNumber = param4;
			this.descriptionLabel = new UILabel();
			DefaultLabelFormat.infoTooltipText(this.descriptionLabel,10066329);
			this.descriptionLabel.text = "Are you sure that you want to buy this item?";
			addChild(this.descriptionLabel);
			this.descriptionLabel.x = WIDTH / 2 - this.descriptionLabel.width / 2;
			this.descriptionLabel.y = 10;
			this.addItemContainer();
			this.addBuyButton();
			this.filters = FilterUtil.getStandardDropShadowFilter();
		}
		
		private function addItemContainer() : void {
			var loc2:ItemWithTooltip = null;
			if(this.owner_.getSellableType() != -1) {
				loc2 = new ItemWithTooltip(this.owner_.getSellableType(),80);
			}
			loc2.x = WIDTH / 2 - loc2.width / 2;
			loc2.y = HEIGHT / 2 - loc2.height + 5;
			addChild(loc2);
			var loc1:String = this.owner_.soldObjectName();
			this.nameText_ = new TextFieldDisplayConcrete().setSize(14).setColor(16777215);
			this.nameText_.setBold(true);
			this.nameText_.setStringBuilder(new LineBuilder().setParams(loc1));
			this.nameText_.setAutoSize(TextFieldAutoSize.CENTER);
			addChild(this.nameText_);
			this.nameText_.x = WIDTH / 2 - this.nameText_.width / 2;
			this.nameText_.y = loc2.y + 55;
		}
		
		private function addBuyButton() : void {
			var loc2:int = 0;
			this.buySectionContainer = new Sprite();
			this.buySectionContainer.alpha = 1;
			this.buyButton = new ShopBuyButton(this.owner_.price_,this.owner_.currency_);
			this.buyButton.showCampaignTooltip = true;
			this.buyButton.width = 95;
			this.buyButtonBackground = TextureParser.instance.getSliceScalingBitmap("UI","buy_button_background",this.buyButton.width + 60);
			var loc1:Vector.<int> = new Vector.<int>();
			if(this.availableInventoryNumber != 0) {
				loc2 = 1;
				while(loc2 <= this.availableInventoryNumber) {
					loc1.push(loc2);
					loc2++;
				}
			} else {
				loc1.push(1);
				this.buyButton.disabled = true;
			}
			this.spinner = new FixedNumbersSpinner(TextureParser.instance.getSliceScalingBitmap("UI","spinner_up_arrow"),0,loc1,"x");
			this.buySectionContainer.addChild(this.buyButtonBackground);
			this.buySectionContainer.addChild(this.spinner);
			this.buySectionContainer.addChild(this.buyButton);
			this.buySectionContainer.x = 100;
			this.buySectionContainer.y = HEIGHT - 45;
			this.buyButton.x = this.buyButtonBackground.width - this.buyButton.width - 6;
			this.buyButton.y = 4;
			this.spinner.y = -2;
			this.spinner.x = 32;
			addChild(this.buySectionContainer);
			this.buySectionContainer.x = Math.round((WIDTH - this.buySectionContainer.width) / 2);
			this.spinner.upArrow.addEventListener(MouseEvent.CLICK,this.countUp);
			this.spinner.downArrow.addEventListener(MouseEvent.CLICK,this.countDown);
			this.refreshArrowDisable();
		}
		
		private function refreshArrowDisable() : void {
			this.spinner.downArrow.alpha = this.quantity_ == 1?Number(0.5):Number(1);
			if(this.availableInventoryNumber != 0) {
				this.spinner.upArrow.alpha = this.quantity_ == this.availableInventoryNumber?Number(0.5):Number(1);
			} else {
				this.spinner.upArrow.alpha = 0.5;
			}
		}
		
		private function countUp(param1:MouseEvent) : void {
			if(this.quantity_ < this.availableInventoryNumber) {
				this.quantity_ = this.quantity_ + 1;
			}
			this.refreshValues();
		}
		
		private function countDown(param1:MouseEvent) : void {
			if(this.quantity_ > 1) {
				this.quantity_ = this.quantity_ - 1;
			}
			this.refreshValues();
		}
		
		private function refreshValues() : void {
			this.refreshArrowDisable();
			this.buyButton.price = this.owner_.price_ * this.quantity_;
		}
		
		public function get getBuyButton() : ShopBuyButton {
			return this.buyButton;
		}
		
		public function get getBuyItem() : Signal {
			return this.buyItem;
		}
		
		public function get getOwner() : SellableObject {
			return this.owner_;
		}
		
		public function get getQuantity() : int {
			return this.quantity_;
		}
	}
}
