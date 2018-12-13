package com.company.assembleegameclient.tutorial {
	import com.company.assembleegameclient.game.GameSprite;
	import com.company.assembleegameclient.objects.GameObject;
	import com.company.assembleegameclient.objects.Player;
	import com.company.assembleegameclient.parameters.Parameters;
	import com.company.util.PointUtil;

	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.utils.getTimer;

	import kabam.rotmg.assets.EmbeddedData;
	import kabam.rotmg.core.StaticInjectorContext;
	import kabam.rotmg.core.service.GoogleAnalytics;

	public class Tutorial extends Sprite {

		public static const NEXT_ACTION:String = "Next";

		public static const MOVE_FORWARD_ACTION:String = "MoveForward";

		public static const MOVE_BACKWARD_ACTION:String = "MoveBackward";

		public static const ROTATE_LEFT_ACTION:String = "RotateLeft";

		public static const ROTATE_RIGHT_ACTION:String = "RotateRight";

		public static const MOVE_LEFT_ACTION:String = "MoveLeft";

		public static const MOVE_RIGHT_ACTION:String = "MoveRight";

		public static const UPDATE_ACTION:String = "Update";

		public static const ATTACK_ACTION:String = "Attack";

		public static const DAMAGE_ACTION:String = "Damage";

		public static const KILL_ACTION:String = "Kill";

		public static const SHOW_LOOT_ACTION:String = "ShowLoot";

		public static const TEXT_ACTION:String = "Text";

		public static const SHOW_PORTAL_ACTION:String = "ShowPortal";

		public static const ENTER_PORTAL_ACTION:String = "EnterPortal";

		public static const NEAR_REQUIREMENT:String = "Near";

		public static const EQUIP_REQUIREMENT:String = "Equip";


		public var gs_:GameSprite;

		public var steps_:Vector.<Step>;

		public var currStepId_:int = 0;

		private var darkBox_:Sprite;

		private var boxesBack_:Shape;

		private var boxes_:Shape;

		private var tutorialMessage_:TutorialMessage = null;

		private var tracker:GoogleAnalytics;

		private var trackingStep:int = -1;

		private var lastTrackingStepTimestamp:uint;

		public function Tutorial(param1:GameSprite) {
			var loc2:XML = null;
			var loc3:Graphics = null;
			this.steps_ = new Vector.<Step>();
			this.darkBox_ = new Sprite();
			this.boxesBack_ = new Shape();
			this.boxes_ = new Shape();
			super();
			this.gs_ = param1;
			this.lastTrackingStepTimestamp = getTimer();
			for each(loc2 in EmbeddedData.tutorialXML.Step) {
				this.steps_.push(new Step(loc2));
			}
			this.tracker = StaticInjectorContext.getInjector().getInstance(GoogleAnalytics);
			this.tracker.trackEvent("tutorial", "started");
			addChild(this.boxesBack_);
			addChild(this.boxes_);
			loc3 = this.darkBox_.graphics;
			loc3.clear();
			loc3.beginFill(0, 0.1);
			loc3.drawRect(0, 0, 800, 600);
			loc3.endFill();
			Parameters.data_.needsTutorial = false;
			Parameters.save();
			addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
		}

		private function onAddedToStage(param1:Event):void {
			addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
			this.draw();
		}

		private function onRemovedFromStage(param1:Event):void {
			removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
		}

		private function onEnterFrame(param1:Event):void {
			var loc4:Step = null;
			var loc5:Boolean = false;
			var loc6:Requirement = null;
			var loc7:int = 0;
			var loc8:UIDrawBox = null;
			var loc9:UIDrawArrow = null;
			var loc10:Player = null;
			var loc11:Boolean = false;
			var loc12:GameObject = null;
			var loc13:Number = NaN;
			var loc2:Number = Math.abs(Math.sin(getTimer() / 300));
			this.boxesBack_.filters = [new BlurFilter(5 + loc2 * 5, 5 + loc2 * 5)];
			this.boxes_.graphics.clear();
			this.boxesBack_.graphics.clear();
			var loc3:int = 0;
			while (loc3 < this.steps_.length) {
				loc4 = this.steps_[loc3];
				loc5 = true;
				for each(loc6 in loc4.reqs_) {
					loc10 = this.gs_.map.player_;
					switch (loc6.type_) {
						case NEAR_REQUIREMENT:
							loc11 = false;
							for each(loc12 in this.gs_.map.goDict_) {
								if (!(loc12.objectType_ != loc6.objectType_ || loc6.objectName_ != "" && loc12.name_ != loc6.objectName_)) {
									loc13 = PointUtil.distanceXY(loc12.x_, loc12.y_, loc10.x_, loc10.y_);
									if (loc13 <= loc6.radius_) {
										loc11 = true;
										break;
									}
								}
							}
							if (!loc11) {
								loc5 = false;
							}
							continue;
						default:
							continue;
					}
				}
				if (!loc5) {
					loc4.satisfiedSince_ = 0;
				} else {
					if (loc4.satisfiedSince_ == 0) {
						loc4.satisfiedSince_ = getTimer();
						if (this.trackingStep != loc3) {
							if (!loc4.trackingSent) {
								this.tracker.trackEvent("tutorial", "step", loc3.toString(), loc4.satisfiedSince_ - this.lastTrackingStepTimestamp);
								this.lastTrackingStepTimestamp = getTimer();
							}
							this.trackingStep = loc3;
						}
					}
					loc7 = getTimer() - loc4.satisfiedSince_;
					for each(loc8 in loc4.uiDrawBoxes_) {
						loc8.draw(5 * loc2, this.boxes_.graphics, loc7);
						loc8.draw(6 * loc2, this.boxesBack_.graphics, loc7);
					}
					for each(loc9 in loc4.uiDrawArrows_) {
						loc9.draw(5 * loc2, this.boxes_.graphics, loc7);
						loc9.draw(6 * loc2, this.boxesBack_.graphics, loc7);
					}
				}
				loc3++;
			}
		}

		function doneAction(param1:String):void {
			var loc3:Requirement = null;
			var loc4:Player = null;
			var loc5:Boolean = false;
			var loc6:GameObject = null;
			var loc7:Number = NaN;
			if (this.currStepId_ >= this.steps_.length) {
				return;
			}
			var loc2:Step = this.steps_[this.currStepId_];
			if (param1 != loc2.action_) {
				return;
			}
			while (true) {
				loop0:
						for each(loc3 in loc2.reqs_) {
							loc4 = this.gs_.map.player_;
							switch (loc3.type_) {
								case NEAR_REQUIREMENT:
									loc5 = false;
									for each(loc6 in this.gs_.map.goDict_) {
										if (loc6.objectType_ == loc3.objectType_) {
											loc7 = PointUtil.distanceXY(loc6.x_, loc6.y_, loc4.x_, loc4.y_);
											if (loc7 <= loc3.radius_) {
												loc5 = true;
												break;
											}
										}
									}
									if (!loc5) {
										break loop0;
									}
									continue;
								case EQUIP_REQUIREMENT:
									if (loc4.equipment_[loc3.slot_] != loc3.objectType_) {
										return;
									}
									continue;
								default:
									continue;
							}
						}
				var loc8:* = this;
				this.currStepId_++;
				this.draw();
				return;
			}
		}

		private function draw():void {
			var loc3:UIDrawBox = null;
		}
	}
}
