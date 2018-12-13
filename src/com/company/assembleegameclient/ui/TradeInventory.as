package com.company.assembleegameclient.ui {
	import com.company.assembleegameclient.game.AGameSprite;
	import com.company.ui.BaseSimpleText;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;

	import kabam.rotmg.constants.GeneralConstants;
	import kabam.rotmg.messaging.impl.data.TradeItem;
	import kabam.rotmg.text.model.TextKey;
	import kabam.rotmg.text.view.TextFieldDisplayConcrete;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;

	public class TradeInventory extends Sprite {

		private static const NO_CUT:Array = [0, 0, 0, 0];

		private static const cuts:Array = [[1, 0, 0, 1], NO_CUT, NO_CUT, [0, 1, 1, 0], [1, 0, 0, 0], NO_CUT, NO_CUT, [0, 1, 0, 0], [0, 0, 0, 1], NO_CUT, NO_CUT, [0, 0, 1, 0]];

		public static const CLICKITEMS_MESSAGE:int = 0;

		public static const NOTENOUGHSPACE_MESSAGE:int = 1;

		public static const TRADEACCEPTED_MESSAGE:int = 2;

		public static const TRADEWAITING_MESSAGE:int = 3;


		public var gs_:AGameSprite;

		public var playerName_:String;

		private var message_:int;

		private var nameText_:BaseSimpleText;

		private var taglineText_:TextFieldDisplayConcrete;

		public var slots_:Vector.<TradeSlot>;

		public function TradeInventory(param1:AGameSprite, param2:String, param3:Vector.<TradeItem>, param4:Boolean) {
			var loc6:TradeItem = null;
			var loc7:TradeSlot = null;
			this.slots_ = new Vector.<TradeSlot>();
			super();
			this.gs_ = param1;
			this.playerName_ = param2;
			this.nameText_ = new BaseSimpleText(20, 11776947, false, 0, 0);
			this.nameText_.setBold(true);
			this.nameText_.x = 0;
			this.nameText_.y = 0;
			this.nameText_.text = this.playerName_;
			this.nameText_.updateMetrics();
			this.nameText_.filters = [new DropShadowFilter(0, 0, 0)];
			addChild(this.nameText_);
			this.taglineText_ = new TextFieldDisplayConcrete().setSize(12).setColor(11776947);
			this.taglineText_.x = 0;
			this.taglineText_.y = 22;
			this.taglineText_.filters = [new DropShadowFilter(0, 0, 0)];
			addChild(this.taglineText_);
			var loc5:int = 0;
			while (loc5 < GeneralConstants.NUM_EQUIPMENT_SLOTS + GeneralConstants.NUM_INVENTORY_SLOTS) {
				loc6 = param3[loc5];
				loc7 = new TradeSlot(loc6.item_, loc6.tradeable_, loc6.included_, loc6.slotType_, loc5 - 3, cuts[loc5], loc5);
				loc7.setPlayer(this.gs_.map.player_);
				loc7.x = int(loc5 % 4) * (Slot.WIDTH + 4);
				loc7.y = int(loc5 / 4) * (Slot.HEIGHT + 4) + 46;
				if (param4 && loc6.tradeable_) {
					loc7.addEventListener(MouseEvent.MOUSE_DOWN, this.onSlotClick);
				}
				this.slots_.push(loc7);
				addChild(loc7);
				loc5++;
			}
		}

		public function getOffer():Vector.<Boolean> {
			var loc1:Vector.<Boolean> = new Vector.<Boolean>();
			var loc2:int = 0;
			while (loc2 < this.slots_.length) {
				loc1.push(this.slots_[loc2].included_);
				loc2++;
			}
			return loc1;
		}

		public function setOffer(param1:Vector.<Boolean>):void {
			var loc2:int = 0;
			while (loc2 < this.slots_.length) {
				this.slots_[loc2].setIncluded(param1[loc2]);
				loc2++;
			}
		}

		public function isOffer(param1:Vector.<Boolean>):Boolean {
			var loc2:int = 0;
			while (loc2 < this.slots_.length) {
				if (param1[loc2] != this.slots_[loc2].included_) {
					return false;
				}
				loc2++;
			}
			return true;
		}

		public function numIncluded():int {
			var loc1:int = 0;
			var loc2:int = 0;
			while (loc2 < this.slots_.length) {
				if (this.slots_[loc2].included_) {
					loc1++;
				}
				loc2++;
			}
			return loc1;
		}

		public function numEmpty():int {
			var loc1:int = 0;
			var loc2:int = 4;
			while (loc2 < this.slots_.length) {
				if (this.slots_[loc2].isEmpty()) {
					loc1++;
				}
				loc2++;
			}
			return loc1;
		}

		public function setMessage(param1:int):void {
			var loc2:String = "";
			switch (param1) {
				case CLICKITEMS_MESSAGE:
					this.nameText_.setColor(11776947);
					this.taglineText_.setColor(11776947);
					loc2 = TextKey.TRADEINVENTORY_CLICKITEMSTOTRADE;
					break;
				case NOTENOUGHSPACE_MESSAGE:
					this.nameText_.setColor(16711680);
					this.taglineText_.setColor(16711680);
					loc2 = TextKey.TRADEINVENTORY_NOTENOUGHSPACE;
					break;
				case TRADEACCEPTED_MESSAGE:
					this.nameText_.setColor(9022300);
					this.taglineText_.setColor(9022300);
					loc2 = TextKey.TRADEINVENTORY_TRADEACCEPTED;
					break;
				case TRADEWAITING_MESSAGE:
					this.nameText_.setColor(11776947);
					this.taglineText_.setColor(11776947);
					loc2 = TextKey.TRADEINVENTORY_PLAYERISSELECTINGITEMS;
			}
			this.taglineText_.setStringBuilder(new LineBuilder().setParams(loc2));
		}

		private function onSlotClick(param1:MouseEvent):void {
			var loc2:TradeSlot = param1.currentTarget as TradeSlot;
			loc2.setIncluded(!loc2.included_);
			dispatchEvent(new Event(Event.CHANGE));
		}
	}
}
