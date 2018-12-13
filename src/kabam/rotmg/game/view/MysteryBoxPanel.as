package kabam.rotmg.game.view {
	import com.company.assembleegameclient.game.GameSprite;
	import com.company.assembleegameclient.objects.SellableObject;
	import com.company.assembleegameclient.parameters.Parameters;
	import com.company.assembleegameclient.ui.DeprecatedTextButton;
	import com.company.assembleegameclient.ui.panels.Panel;
	import com.company.assembleegameclient.util.Currency;

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextFieldAutoSize;

	import io.decagames.rotmg.shop.ShopConfiguration;
	import io.decagames.rotmg.shop.ShopPopupView;
	import io.decagames.rotmg.ui.popups.signals.ShowPopupSignal;

	import kabam.rotmg.account.core.Account;
	import kabam.rotmg.account.core.view.RegisterPromptDialog;
	import kabam.rotmg.arena.util.ArenaViewAssetFactory;
	import kabam.rotmg.core.StaticInjectorContext;
	import kabam.rotmg.dialogs.control.OpenDialogSignal;
	import kabam.rotmg.mysterybox.components.MysteryBoxSelectModal;
	import kabam.rotmg.mysterybox.services.GetMysteryBoxesTask;
	import kabam.rotmg.mysterybox.services.MysteryBoxModel;
	import kabam.rotmg.text.model.TextKey;
	import kabam.rotmg.text.view.TextFieldDisplayConcrete;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;
	import kabam.rotmg.util.components.LegacyBuyButton;

	import org.osflash.signals.Signal;
	import org.swiftsuspenders.Injector;

	public class MysteryBoxPanel extends Panel {


		public var buyItem:Signal;

		private var owner_:SellableObject;

		private var nameText_:TextFieldDisplayConcrete;

		private var buyButton_:LegacyBuyButton;

		private var infoButton_:DeprecatedTextButton;

		private var icon_:Sprite;

		private var bitmap_:Bitmap;

		private const BUTTON_OFFSET:int = 17;

		public function MysteryBoxPanel(param1:GameSprite, param2:uint) {
			this.buyItem = new Signal(SellableObject);
			var loc3:Injector = StaticInjectorContext.getInjector();
			var loc4:GetMysteryBoxesTask = loc3.getInstance(GetMysteryBoxesTask);
			loc4.start();
			super(param1);
			this.nameText_ = new TextFieldDisplayConcrete().setSize(16).setColor(16777215).setTextWidth(WIDTH - 44);
			this.nameText_.setBold(true);
			this.nameText_.setStringBuilder(new LineBuilder().setParams(TextKey.SELLABLEOBJECTPANEL_TEXT));
			this.nameText_.setWordWrap(true);
			this.nameText_.setMultiLine(true);
			this.nameText_.setAutoSize(TextFieldAutoSize.CENTER);
			this.nameText_.filters = [new DropShadowFilter(0, 0, 0)];
			addChild(this.nameText_);
			this.icon_ = new Sprite();
			addChild(this.icon_);
			this.bitmap_ = new Bitmap(null);
			this.icon_.addChild(this.bitmap_);
			var loc5:String = "MysteryBoxPanel.open";
			var loc6:String = "MysteryBoxPanel.checkBackLater";
			var loc7:String = "MysteryBoxPanel.mysteryBoxShop";
			var loc8:MysteryBoxModel = loc3.getInstance(MysteryBoxModel);
			var loc9:Account = loc3.getInstance(Account);
			if (loc8.isInitialized() || !loc9.isRegistered()) {
				this.infoButton_ = new DeprecatedTextButton(16, loc5);
				this.infoButton_.addEventListener(MouseEvent.CLICK, this.onInfoButtonClick);
				addChild(this.infoButton_);
			} else {
				this.infoButton_ = new DeprecatedTextButton(16, loc6);
				addChild(this.infoButton_);
			}
			this.nameText_.setStringBuilder(new LineBuilder().setParams("Shop"));
			this.bitmap_.bitmapData = ArenaViewAssetFactory.returnHostBitmap(param2).bitmapData;
			addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
		}

		public function setOwner(param1:SellableObject):void {
			if (param1 == this.owner_) {
				return;
			}
			this.owner_ = param1;
			this.buyButton_.setPrice(this.owner_.price_, this.owner_.currency_);
			var loc2:String = this.owner_.soldObjectName();
			this.nameText_.setStringBuilder(new LineBuilder().setParams(loc2));
			this.bitmap_.bitmapData = this.owner_.getIcon();
		}

		private function onAddedToStage(param1:Event):void {
			stage.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
			this.icon_.x = -4;
			this.icon_.y = -8;
			this.nameText_.x = 44;
		}

		private function onRemovedFromStage(param1:Event):void {
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
			this.infoButton_.removeEventListener(MouseEvent.CLICK, this.onInfoButtonClick);
		}

		private function onInfoButtonClick(param1:MouseEvent):void {
			this.onInfoButton();
		}

		private function onInfoButton():void {
			var loc5:ShowPopupSignal = null;
			var loc1:Injector = StaticInjectorContext.getInjector();
			var loc2:MysteryBoxModel = loc1.getInstance(MysteryBoxModel);
			var loc3:Account = loc1.getInstance(Account);
			var loc4:OpenDialogSignal = loc1.getInstance(OpenDialogSignal);
			if (loc2.isInitialized() && loc3.isRegistered()) {
				if (ShopConfiguration.USE_NEW_SHOP) {
					loc5 = loc1.getInstance(ShowPopupSignal);
					loc5.dispatch(new ShopPopupView());
				} else {
					loc4.dispatch(new MysteryBoxSelectModal());
				}
			} else if (!loc3.isRegistered()) {
				loc4.dispatch(new RegisterPromptDialog("SellableObjectPanelMediator.text", {"type": Currency.typeToName(Currency.GOLD)}));
			}
		}

		private function onKeyDown(param1:KeyboardEvent):void {
			if (param1.keyCode == Parameters.data_.interact && stage.focus == null) {
				this.onInfoButton();
			}
		}

		override public function draw():void {
			this.nameText_.y = this.nameText_.height > 30 ? Number(0) : Number(12);
			this.infoButton_.x = WIDTH / 2 - this.infoButton_.width / 2;
			this.infoButton_.y = HEIGHT - this.infoButton_.height / 2 - this.BUTTON_OFFSET;
			if (!contains(this.infoButton_)) {
				addChild(this.infoButton_);
			}
		}
	}
}
