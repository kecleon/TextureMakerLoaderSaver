package io.decagames.rotmg.dailyQuests.utils {
	import flash.display.Sprite;

	import io.decagames.rotmg.dailyQuests.data.DailyQuestItemSlotType;
	import io.decagames.rotmg.dailyQuests.view.slot.DailyQuestItemSlot;

	public class SlotsRendered {


		public function SlotsRendered() {
			super();
		}

		public static function renderSlots(param1:Vector.<int>, param2:Vector.<int>, param3:String, param4:Sprite, param5:int, param6:int, param7:int, param8:Vector.<DailyQuestItemSlot>, param9:Boolean = false):void {
			var loc11:int = 0;
			var loc17:Sprite = null;
			var loc18:Sprite = null;
			var loc19:int = 0;
			var loc20:int = 0;
			var loc21:int = 0;
			var loc22:int = 0;
			var loc23:DailyQuestItemSlot = null;
			var loc10:int = 0;
			loc11 = 4;
			var loc12:int = 0;
			var loc13:int = 0;
			var loc14:int = 0;
			var loc15:Boolean = false;
			var loc16:Sprite = new Sprite();
			loc17 = new Sprite();
			loc18 = loc16;
			param4.addChild(loc16);
			param4.addChild(loc17);
			loc17.y = DailyQuestItemSlot.SLOT_SIZE + param6;
			for each(loc19 in param1) {
				if (!loc15) {
					loc13++;
				} else {
					loc14++;
				}
				loc22 = param2.indexOf(loc19);
				if (loc22 >= 0) {
					param2.splice(loc22, 1);
				}
				loc23 = new DailyQuestItemSlot(loc19, param3, param3 == DailyQuestItemSlotType.REWARD ? false : loc22 >= 0, param9);
				loc23.x = loc10 * (DailyQuestItemSlot.SLOT_SIZE + param6);
				loc18.addChild(loc23);
				param8.push(loc23);
				loc10++;
				if (loc10 >= loc11) {
					loc18 = loc17;
					loc10 = 0;
					loc15 = true;
				}
			}
			loc20 = loc13 * DailyQuestItemSlot.SLOT_SIZE + (loc13 - 1) * param6;
			loc21 = loc14 * DailyQuestItemSlot.SLOT_SIZE + (loc14 - 1) * param6;
			param4.y = param5;
			if (!loc15) {
				param4.y = param4.y + Math.round(DailyQuestItemSlot.SLOT_SIZE / 2 + param6 / 2);
			}
			loc16.x = Math.round((param7 - loc20) / 2);
			loc17.x = Math.round((param7 - loc21) / 2);
		}
	}
}
