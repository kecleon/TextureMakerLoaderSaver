package kabam.rotmg.fame.view {
	import com.company.assembleegameclient.map.GroundLibrary;
	import com.company.assembleegameclient.objects.ObjectLibrary;
	import com.company.assembleegameclient.screens.ScoreTextLine;
	import com.company.assembleegameclient.screens.ScoringBox;
	import com.company.assembleegameclient.screens.TitleMenuOption;
	import com.company.assembleegameclient.sound.SoundEffectLibrary;
	import com.company.assembleegameclient.util.FameUtil;
	import com.company.rotmg.graphics.FameIconBackgroundDesign;
	import com.company.rotmg.graphics.ScreenGraphic;
	import com.company.util.BitmapUtil;
	import com.gskinner.motion.GTween;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextFieldAutoSize;

	import kabam.rotmg.text.model.TextKey;
	import kabam.rotmg.text.view.TextFieldDisplayConcrete;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;
	import kabam.rotmg.ui.view.components.ScreenBase;

	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeMappedSignal;

	public class FameView extends Sprite {


		public var closed:Signal;

		private var infoContainer:DisplayObjectContainer;

		private var overlayContainer:Bitmap;

		private var title:TextFieldDisplayConcrete;

		private var date:TextFieldDisplayConcrete;

		private var scoringBox:ScoringBox;

		private var finalLine:ScoreTextLine;

		private var continueBtn:TitleMenuOption;

		private var isAnimation:Boolean;

		private var isFadeComplete:Boolean;

		private var isDataPopulated:Boolean;

		public function FameView() {
			super();
			addChild(new ScreenBase());
			addChild(this.infoContainer = new Sprite());
			addChild(this.overlayContainer = new Bitmap());
			this.continueBtn = new TitleMenuOption(TextKey.OPTIONS_CONTINUE_BUTTON, 36, false);
			this.continueBtn.setAutoSize(TextFieldAutoSize.CENTER);
			this.continueBtn.setVerticalAlign(TextFieldDisplayConcrete.MIDDLE);
			this.closed = new NativeMappedSignal(this.continueBtn, MouseEvent.CLICK);
		}

		public function setIsAnimation(param1:Boolean):void {
			this.isAnimation = param1;
		}

		public function setBackground(param1:BitmapData):void {
			this.overlayContainer.bitmapData = param1;
			var loc2:GTween = new GTween(this.overlayContainer, 2, {"alpha": 0});
			loc2.onComplete = this.onFadeComplete;
			SoundEffectLibrary.play("death_screen");
		}

		public function clearBackground():void {
			this.overlayContainer.bitmapData = null;
		}

		private function onFadeComplete(param1:GTween):void {
			removeChild(this.overlayContainer);
			this.isFadeComplete = true;
			if (this.isDataPopulated) {
				this.makeContinueButton();
			}
		}

		public function setCharacterInfo(param1:String, param2:int, param3:int):void {
			this.title = new TextFieldDisplayConcrete().setSize(38).setColor(13421772);
			this.title.setBold(true).setAutoSize(TextFieldAutoSize.CENTER);
			this.title.filters = [new DropShadowFilter(0, 0, 0, 0.5, 12, 12)];
			var loc4:String = ObjectLibrary.typeToDisplayId_[param3];
			this.title.setStringBuilder(new LineBuilder().setParams(TextKey.CHARACTER_INFO, {
				"name": param1,
				"level": param2,
				"type": loc4
			}));
			this.title.x = stage.stageWidth / 2;
			this.title.y = 225;
			this.infoContainer.addChild(this.title);
		}

		public function setDeathInfo(param1:String, param2:String):void {
			this.date = new TextFieldDisplayConcrete().setSize(24).setColor(13421772);
			this.date.setBold(true).setAutoSize(TextFieldAutoSize.CENTER);
			this.date.filters = [new DropShadowFilter(0, 0, 0, 0.5, 12, 12)];
			var loc3:LineBuilder = new LineBuilder();
			if (param2) {
				loc3.setParams(TextKey.DEATH_INFO_LONG, {
					"date": param1,
					"killer": this.convertKillerString(param2)
				});
			} else {
				loc3.setParams(TextKey.DEATH_INFO_SHORT, {"date": param1});
			}
			this.date.setStringBuilder(loc3);
			this.date.x = stage.stageWidth / 2;
			this.date.y = 272;
			this.infoContainer.addChild(this.date);
		}

		private function convertKillerString(param1:String):String {
			var loc2:Array = param1.split(".");
			var loc3:String = loc2[0];
			var loc4:String = loc2[1];
			if (loc4 == null) {
				loc4 = loc3;
				switch (loc4) {
					case "lava":
						loc4 = "Lava";
						break;
					case "lava blend":
						loc4 = "Lava Blend";
						break;
					case "liquid evil":
						loc4 = "Liquid Evil";
						break;
					case "evil water":
						loc4 = "Evil Water";
						break;
					case "puke water":
						loc4 = "Puke Water";
						break;
					case "hot lava":
						loc4 = "Hot Lava";
						break;
					case "pure evil":
						loc4 = "Pure Evil";
						break;
					case "lod red tile":
						loc4 = "lod Red Tile";
						break;
					case "lod purple tile":
						loc4 = "lod Purple Tile";
						break;
					case "lod blue tile":
						loc4 = "lod Blue Tile";
						break;
					case "lod green tile":
						loc4 = "lod Green Tile";
						break;
					case "lod cream tile":
						loc4 = "lod Cream Tile";
				}
			} else {
				loc4 = loc4.substr(0, loc4.length - 1);
				loc4 = loc4.replace(/_/g, " ");
				loc4 = loc4.replace(/APOS/g, "\'");
				loc4 = loc4.replace(/BANG/g, "!");
			}
			if (ObjectLibrary.getPropsFromId(loc4) != null) {
				loc4 = ObjectLibrary.getPropsFromId(loc4).displayId_;
			} else if (GroundLibrary.getPropsFromId(loc4) != null) {
				loc4 = GroundLibrary.getPropsFromId(loc4).displayId_;
			}
			return loc4;
		}

		public function setIcon(param1:BitmapData):void {
			var loc2:Sprite = null;
			loc2 = new Sprite();
			var loc3:Sprite = new FameIconBackgroundDesign();
			loc3.filters = [new DropShadowFilter(0, 0, 0, 0.5, 12, 12)];
			loc2.addChild(loc3);
			var loc4:Bitmap = new Bitmap(param1);
			loc4.x = loc2.width / 2 - loc4.width / 2;
			loc4.y = loc2.height / 2 - loc4.height / 2;
			loc2.addChild(loc4);
			loc2.y = 20;
			loc2.x = stage.stageWidth / 2 - loc2.width / 2;
			this.infoContainer.addChild(loc2);
		}

		public function setScore(param1:int, param2:XML):void {
			this.scoringBox = new ScoringBox(new Rectangle(0, 0, 784, 150), param2);
			this.scoringBox.x = 8;
			this.scoringBox.y = 316;
			addChild(this.scoringBox);
			this.infoContainer.addChild(this.scoringBox);
			var loc3:BitmapData = FameUtil.getFameIcon();
			loc3 = BitmapUtil.cropToBitmapData(loc3, 6, 6, loc3.width - 12, loc3.height - 12);
			this.finalLine = new ScoreTextLine(24, 13421772, 16762880, TextKey.FAMEVIEW_TOTAL_FAME_EARNED, null, 0, param1, "", "", new Bitmap(loc3));
			this.finalLine.x = 10;
			this.finalLine.y = 470;
			this.infoContainer.addChild(this.finalLine);
			this.isDataPopulated = true;
			if (!this.isAnimation || this.isFadeComplete) {
				this.makeContinueButton();
			}
		}

		private function makeContinueButton():void {
			this.infoContainer.addChild(new ScreenGraphic());
			this.continueBtn.x = stage.stageWidth / 2;
			this.continueBtn.y = 550;
			this.infoContainer.addChild(this.continueBtn);
			if (this.isAnimation) {
				this.scoringBox.animateScore();
			} else {
				this.scoringBox.showScore();
			}
		}
	}
}
