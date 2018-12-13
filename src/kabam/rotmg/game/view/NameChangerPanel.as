 
package kabam.rotmg.game.view {
	import com.company.assembleegameclient.game.GameSprite;
	import com.company.assembleegameclient.objects.Player;
	import com.company.assembleegameclient.parameters.Parameters;
	import com.company.assembleegameclient.ui.DeprecatedTextButton;
	import com.company.assembleegameclient.ui.RankText;
	import com.company.assembleegameclient.ui.panels.Panel;
	import com.company.assembleegameclient.util.Currency;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextFormatAlign;
	import kabam.rotmg.text.model.TextKey;
	import kabam.rotmg.text.view.TextFieldDisplayConcrete;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;
	import kabam.rotmg.text.view.stringBuilder.StringBuilder;
	import kabam.rotmg.util.components.LegacyBuyButton;
	import org.osflash.signals.Signal;
	
	public class NameChangerPanel extends Panel {
		 
		
		public var chooseName:Signal;
		
		public var buy_:Boolean;
		
		private var title_:TextFieldDisplayConcrete;
		
		private var button_:Sprite;
		
		public function NameChangerPanel(param1:GameSprite, param2:int) {
			var loc3:Player = null;
			var loc4:String = null;
			this.chooseName = new Signal();
			super(param1);
			if(this.hasMapAndPlayer()) {
				loc3 = gs_.map.player_;
				this.buy_ = loc3.nameChosen_;
				loc4 = this.createNameText();
				if(this.buy_) {
					this.handleAlreadyHasName(loc4);
				} else if(loc3.numStars_ < param2) {
					this.handleInsufficientRank(param2);
				} else {
					this.handleNoName();
				}
			}
			addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
		}
		
		private function onAddedToStage(param1:Event) : void {
			if(this.button_) {
				stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
			}
			addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
		}
		
		private function hasMapAndPlayer() : Boolean {
			return gs_.map && gs_.map.player_;
		}
		
		private function createNameText() : String {
			var loc1:String = null;
			loc1 = gs_.model.getName();
			this.title_ = new TextFieldDisplayConcrete().setSize(18).setColor(16777215).setTextWidth(WIDTH);
			this.title_.setBold(true).setWordWrap(true).setMultiLine(true).setHorizontalAlign(TextFormatAlign.CENTER);
			this.title_.filters = [new DropShadowFilter(0,0,0)];
			return loc1;
		}
		
		private function handleAlreadyHasName(param1:String) : void {
			this.title_.setStringBuilder(this.makeNameText(param1));
			this.title_.y = 0;
			addChild(this.title_);
			var loc2:LegacyBuyButton = new LegacyBuyButton(TextKey.NAME_CHANGER_CHANGE,16,Parameters.NAME_CHANGE_PRICE,Currency.GOLD);
			loc2.readyForPlacement.addOnce(this.positionButton);
			this.button_ = loc2;
			var loc3:* = Parameters.NAME_CHANGE_PRICE <= gs_.map.player_.credits_;
			if(!loc3) {
				(this.button_ as LegacyBuyButton).setEnabled(loc3);
			} else {
				this.addListeners();
			}
			addChild(this.button_);
		}
		
		private function positionButton() : void {
			this.button_.x = WIDTH / 2 - this.button_.width / 2;
			this.button_.y = HEIGHT - this.button_.height / 2 - 17;
		}
		
		private function handleNoName() : void {
			this.title_.setStringBuilder(new LineBuilder().setParams(TextKey.NAME_CHANGER_TEXT));
			this.title_.y = 6;
			addChild(this.title_);
			var loc1:DeprecatedTextButton = new DeprecatedTextButton(16,TextKey.NAME_CHANGER_CHOOSE);
			loc1.textChanged.addOnce(this.positionTextButton);
			this.button_ = loc1;
			addChild(this.button_);
			this.addListeners();
		}
		
		private function positionTextButton() : void {
			this.button_.x = WIDTH / 2 - this.button_.width / 2;
			this.button_.y = HEIGHT - this.button_.height - 4;
		}
		
		private function addListeners() : void {
			this.button_.addEventListener(MouseEvent.CLICK,this.onButtonClick);
		}
		
		private function handleInsufficientRank(param1:int) : void {
			var loc2:Sprite = null;
			var loc3:TextFieldDisplayConcrete = null;
			var loc4:Sprite = null;
			this.title_.setStringBuilder(new LineBuilder().setParams(TextKey.NAME_CHANGER_TEXT));
			addChild(this.title_);
			loc2 = new Sprite();
			loc3 = new TextFieldDisplayConcrete().setSize(16).setColor(16777215);
			loc3.setBold(true);
			loc3.setStringBuilder(new LineBuilder().setParams(TextKey.NAME_CHANGER_REQUIRE_RANK));
			loc3.filters = [new DropShadowFilter(0,0,0)];
			loc2.addChild(loc3);
			loc4 = new RankText(param1,false,false);
			loc4.x = loc3.width + 4;
			loc4.y = loc3.height / 2 - loc4.height / 2;
			loc2.addChild(loc4);
			loc2.x = WIDTH / 2 - loc2.width / 2;
			loc2.y = HEIGHT - loc2.height / 2 - 20;
			addChild(loc2);
		}
		
		private function onRemovedFromStage(param1:Event) : void {
			stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
		}
		
		private function makeNameText(param1:String) : StringBuilder {
			return new LineBuilder().setParams(TextKey.NAME_CHANGER_NAME_IS,{"name":param1});
		}
		
		private function onKeyDown(param1:KeyboardEvent) : void {
			if(param1.keyCode == Parameters.data_.interact && stage.focus == null) {
				this.performAction();
			}
		}
		
		private function onButtonClick(param1:MouseEvent) : void {
			this.performAction();
		}
		
		private function performAction() : void {
			this.chooseName.dispatch();
		}
		
		public function updateName(param1:String) : void {
			this.title_.setStringBuilder(this.makeNameText(param1));
			this.title_.y = 0;
		}
	}
}
