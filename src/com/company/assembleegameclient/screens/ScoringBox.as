package com.company.assembleegameclient.screens {
	import com.company.assembleegameclient.ui.Scrollbar;
	import com.company.assembleegameclient.util.FameUtil;
	import com.company.util.BitmapUtil;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;

	import kabam.rotmg.text.model.TextKey;

	public class ScoringBox extends Sprite {


		private var rect_:Rectangle;

		private var mask_:Shape;

		private var linesSprite_:Sprite;

		private var scoreTextLines_:Vector.<ScoreTextLine>;

		private var scrollbar_:Scrollbar;

		private var startTime_:int;

		public function ScoringBox(param1:Rectangle, param2:XML) {
			var loc4:XML = null;
			this.mask_ = new Shape();
			this.linesSprite_ = new Sprite();
			this.scoreTextLines_ = new Vector.<ScoreTextLine>();
			super();
			this.rect_ = param1;
			graphics.lineStyle(1, 4802889, 2);
			graphics.drawRect(this.rect_.x + 1, this.rect_.y + 1, this.rect_.width - 2, this.rect_.height - 2);
			graphics.lineStyle();
			this.scrollbar_ = new Scrollbar(16, this.rect_.height);
			this.scrollbar_.addEventListener(Event.CHANGE, this.onScroll);
			this.mask_.graphics.beginFill(16777215, 1);
			this.mask_.graphics.drawRect(this.rect_.x, this.rect_.y, this.rect_.width, this.rect_.height);
			this.mask_.graphics.endFill();
			addChild(this.mask_);
			mask = this.mask_;
			addChild(this.linesSprite_);
			this.addLine(TextKey.FAMEVIEW_SHOTS, null, 0, param2.Shots, false, 5746018);
			if (int(param2.Shots) != 0) {
				this.addLine(TextKey.FAMEVIEW_ACCURACY, null, 0, 100 * Number(param2.ShotsThatDamage) / Number(param2.Shots), true, 5746018, "", "%");
			}
			this.addLine(TextKey.FAMEVIEW_TILES_SEEN, null, 0, param2.TilesUncovered, false, 5746018);
			this.addLine(TextKey.FAMEVIEW_MONSTERKILLS, null, 0, param2.MonsterKills, false, 5746018);
			this.addLine(TextKey.FAMEVIEW_GODKILLS, null, 0, param2.GodKills, false, 5746018);
			this.addLine(TextKey.FAMEVIEW_ORYXKILLS, null, 0, param2.OryxKills, false, 5746018);
			this.addLine(TextKey.FAMEVIEW_QUESTSCOMPLETED, null, 0, param2.QuestsCompleted, false, 5746018);
			this.addLine(TextKey.FAMEVIEW_DUNGEONSCOMPLETED, null, 0, int(param2.PirateCavesCompleted) + int(param2.UndeadLairsCompleted) + int(param2.AbyssOfDemonsCompleted) + int(param2.SnakePitsCompleted) + int(param2.SpiderDensCompleted) + int(param2.SpriteWorldsCompleted) + int(param2.TombsCompleted) + int(param2.TrenchesCompleted) + int(param2.JunglesCompleted) + int(param2.ManorsCompleted) + int(param2.ForestMazeCompleted) + int(param2.LairOfDraconisCompleted) + int(param2.CandyLandCompleted) + int(param2.HauntedCemeteryCompleted) + int(param2.CaveOfAThousandTreasuresCompleted) + int(param2.MadLabCompleted) + int(param2.DavyJonesCompleted) + int(param2.TombHeroicCompleted) + int(param2.DreamscapeCompleted) + int(param2.IceCaveCompleted) + int(param2.DeadWaterDocksCompleted) + int(param2.CrawlingDepthCompleted) + int(param2.WoodLandCompleted) + int(param2.BattleNexusCompleted) + int(param2.TheShattersCompleted) + int(param2.BelladonnaCompleted) + int(param2.PuppetMasterCompleted) + int(param2.ToxicSewersCompleted) + int(param2.TheHiveCompleted) + int(param2.MountainTempleCompleted) + int(param2.TheNestCompleted) + int(param2.LairOfDraconisHmCompleted) + int(param2.LostHallsCompleted) + int(param2.CultistHideoutCompleted) + int(param2.TheVoidCompleted) + int(param2.PuppetEncoreCompleted) + int(param2.LairOfShaitanCompleted) + int(param2.ParasiteChambersCompleted), false, 5746018);
			this.addLine(TextKey.FAMEVIEW_PARTYMEMBERLEVELUPS, null, 0, param2.LevelUpAssists, false, 5746018);
			var loc3:BitmapData = FameUtil.getFameIcon();
			loc3 = BitmapUtil.cropToBitmapData(loc3, 6, 6, loc3.width - 12, loc3.height - 12);
			this.addLine(TextKey.FAMEVIEW_BASEFAMEEARNED, null, 0, param2.BaseFame, true, 16762880, "", "", new Bitmap(loc3));
			for each(loc4 in param2.Bonus) {
				this.addLine(loc4.@id, loc4.@desc, loc4.@level, int(loc4), true, 16762880, "+", "", new Bitmap(loc3));
			}
		}

		public function showScore():void {
			var loc1:ScoreTextLine = null;
			this.animateScore();
			this.startTime_ = -int.MAX_VALUE;
			for each(loc1 in this.scoreTextLines_) {
				loc1.skip();
			}
		}

		public function animateScore():void {
			this.startTime_ = getTimer();
			addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
		}

		private function onScroll(param1:Event):void {
			var loc2:Number = this.scrollbar_.pos();
			this.linesSprite_.y = loc2 * (this.rect_.height - this.linesSprite_.height - 15) + 5;
		}

		private function addLine(param1:String, param2:String, param3:int, param4:int, param5:Boolean, param6:uint, param7:String = "", param8:String = "", param9:DisplayObject = null):void {
			if (param4 == 0 && !param5) {
				return;
			}
			this.scoreTextLines_.push(new ScoreTextLine(20, 11776947, param6, param1, param2, param3, param4, param7, param8, param9));
		}

		private function onEnterFrame(param1:Event):void {
			var loc3:Number = NaN;
			var loc6:ScoreTextLine = null;
			var loc2:Number = this.startTime_ + 2000 * (this.scoreTextLines_.length - 1) / 2;
			loc3 = getTimer();
			var loc4:int = Math.min(this.scoreTextLines_.length, 2 * (getTimer() - this.startTime_) / 2000 + 1);
			var loc5:int = 0;
			while (loc5 < loc4) {
				loc6 = this.scoreTextLines_[loc5];
				loc6.y = 28 * loc5;
				this.linesSprite_.addChild(loc6);
				loc5++;
			}
			this.linesSprite_.y = this.rect_.height - this.linesSprite_.height - 10;
			if (loc3 > loc2 + 1000) {
				this.addScrollbar();
				dispatchEvent(new Event(Event.COMPLETE));
				removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
			}
		}

		private function addScrollbar():void {
			graphics.clear();
			graphics.lineStyle(1, 4802889, 2);
			graphics.drawRect(this.rect_.x + 1, this.rect_.y + 1, this.rect_.width - 26, this.rect_.height - 2);
			graphics.lineStyle();
			this.scrollbar_.x = this.rect_.width - 16;
			this.scrollbar_.setIndicatorSize(this.mask_.height, this.linesSprite_.height);
			this.scrollbar_.setPos(1);
			addChild(this.scrollbar_);
		}
	}
}
