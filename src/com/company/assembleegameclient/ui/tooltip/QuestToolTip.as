package com.company.assembleegameclient.ui.tooltip {
	import com.company.assembleegameclient.objects.GameObject;
	import com.company.assembleegameclient.ui.GameObjectListItem;

	import flash.filters.DropShadowFilter;

	import kabam.rotmg.text.view.TextFieldDisplayConcrete;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;

	public class QuestToolTip extends ToolTip {


		private var gameObject:GameObject;

		public var enemyGOLI_:GameObjectListItem;

		public function QuestToolTip(param1:GameObject) {
			super(6036765, 1, 16549442, 1, false);
			this.gameObject = param1;
			this.init();
		}

		private function init():void {
			var loc1:TextFieldDisplayConcrete = null;
			loc1 = new TextFieldDisplayConcrete().setSize(22).setColor(16549442).setBold(true);
			loc1.setStringBuilder(new LineBuilder().setParams("Bounty!"));
			loc1.filters = [new DropShadowFilter(0, 0, 0)];
			loc1.x = 0;
			loc1.y = 0;
			waiter.push(loc1.textChanged);
			addChild(loc1);
			this.enemyGOLI_ = new GameObjectListItem(16777215, true, this.gameObject);
			this.enemyGOLI_.x = 0;
			this.enemyGOLI_.y = 32;
			waiter.push(this.enemyGOLI_.textReady);
			addChild(this.enemyGOLI_);
			filters = [];
		}
	}
}
