package com.company.assembleegameclient.map.partyoverlay {
	import com.company.assembleegameclient.map.Camera;
	import com.company.assembleegameclient.map.Map;
	import com.company.assembleegameclient.map.Quest;
	import com.company.assembleegameclient.objects.GameObject;
	import com.company.assembleegameclient.parameters.Parameters;
	import com.company.assembleegameclient.ui.tooltip.PortraitToolTip;
	import com.company.assembleegameclient.ui.tooltip.QuestToolTip;
	import com.company.assembleegameclient.ui.tooltip.ToolTip;
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;

	import flash.events.MouseEvent;
	import flash.utils.getTimer;

	public class QuestArrow extends GameObjectArrow {


		private var questArrowTween:TimelineMax;

		public function QuestArrow(param1:Map) {
			super(16352321, 12919330, true);
			map_ = param1;
		}

		public function refreshToolTip():void {
			if (this.questArrowTween.isActive()) {
				this.questArrowTween.pause(0);
				this.scaleX = 1;
				this.scaleY = 1;
			}
			setToolTip(this.getToolTip(go_, getTimer()));
		}

		override protected function onMouseOver(param1:MouseEvent):void {
			super.onMouseOver(param1);
			this.refreshToolTip();
		}

		override protected function onMouseOut(param1:MouseEvent):void {
			super.onMouseOut(param1);
			this.refreshToolTip();
		}

		private function getToolTip(param1:GameObject, param2:int):ToolTip {
			if (param1 == null || param1.texture_ == null) {
				return null;
			}
			if (this.shouldShowFullQuest(param2)) {
				return new QuestToolTip(go_);
			}
			if (Parameters.data_.showQuestPortraits) {
				return new PortraitToolTip(param1);
			}
			return null;
		}

		private function shouldShowFullQuest(param1:int):Boolean {
			var loc2:Quest = map_.quest_;
			return mouseOver_ || loc2.isNew(param1);
		}

		override public function draw(param1:int, param2:Camera):void {
			var loc4:* = false;
			var loc5:Boolean = false;
			var loc3:GameObject = map_.quest_.getObject(param1);
			if (loc3 != go_) {
				setGameObject(loc3);
				setToolTip(this.getToolTip(loc3, param1));
				if (!this.questArrowTween) {
					this.questArrowTween = new TimelineMax();
					this.questArrowTween.add(TweenMax.to(this, 0.15, {
						"scaleX": 1.6,
						"scaleY": 1.6
					}));
					this.questArrowTween.add(TweenMax.to(this, 0.05, {
						"scaleX": 1.8,
						"scaleY": 1.8
					}));
					this.questArrowTween.add(TweenMax.to(this, 0.3, {
						"scaleX": 1,
						"scaleY": 1,
						"ease": Expo.easeOut
					}));
				} else {
					this.questArrowTween.play(0);
				}
			} else if (go_ != null) {
				loc4 = tooltip_ is QuestToolTip;
				loc5 = this.shouldShowFullQuest(param1);
				if (loc4 != loc5) {
					setToolTip(this.getToolTip(loc3, param1));
				}
			}
			super.draw(param1, param2);
		}
	}
}
