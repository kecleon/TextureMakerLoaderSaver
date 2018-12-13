 
package com.company.assembleegameclient.ui.tooltip {
	import com.company.assembleegameclient.appengine.CharacterStats;
	import com.company.assembleegameclient.appengine.SavedCharactersList;
	import com.company.assembleegameclient.objects.ObjectLibrary;
	import com.company.assembleegameclient.ui.LineBreakDesign;
	import com.company.assembleegameclient.util.AnimatedChar;
	import com.company.assembleegameclient.util.AnimatedChars;
	import com.company.assembleegameclient.util.EquipmentUtil;
	import com.company.assembleegameclient.util.FameUtil;
	import com.company.assembleegameclient.util.FilterUtil;
	import com.company.assembleegameclient.util.MaskedImage;
	import com.company.assembleegameclient.util.TextureRedrawer;
	import com.company.rotmg.graphics.StarGraphic;
	import com.company.util.AssetLibrary;
	import com.company.util.CachingColorTransformer;
	import com.company.util.ConversionUtil;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	import flash.geom.ColorTransform;
	import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
	import io.decagames.rotmg.ui.labels.UILabel;
	import kabam.rotmg.core.model.PlayerModel;
	import kabam.rotmg.text.model.TextKey;
	import kabam.rotmg.text.view.TextFieldDisplayConcrete;
	import kabam.rotmg.text.view.stringBuilder.AppendingLineBuilder;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;
	
	public class ClassToolTip extends ToolTip {
		
		public static const CLASS_TOOL_TIP_WIDTH:int = 210;
		
		public static const FULL_STAR:ColorTransform = new ColorTransform(0.8,0.8,0.8);
		
		public static const EMPTY_STAR:ColorTransform = new ColorTransform(0.1,0.1,0.1);
		 
		
		private var portrait_:Bitmap;
		
		private var nameText_:TextFieldDisplayConcrete;
		
		private var classQuestText_:TextFieldDisplayConcrete;
		
		private var classUnlockText_:TextFieldDisplayConcrete;
		
		private var descriptionText_:TextFieldDisplayConcrete;
		
		private var lineBreakOne:LineBreakDesign;
		
		private var lineBreakTwo:LineBreakDesign;
		
		private var toUnlockText_:TextFieldDisplayConcrete;
		
		private var unlockText_:TextFieldDisplayConcrete;
		
		private var nextClassQuest_:TextFieldDisplayConcrete;
		
		private var showUnlockRequirements:Boolean;
		
		private var _playerXML:XML;
		
		private var _playerModel:PlayerModel;
		
		private var _charStats:CharacterStats;
		
		private var _equipmentContainer:Sprite;
		
		private var _progressContainer:Sprite;
		
		private var _bestContainer:Sprite;
		
		private var _classUnlockContainer:Sprite;
		
		private var _numberOfStars:int;
		
		private var _backgroundColor:Number;
		
		private var _borderColor:Number;
		
		private var _lineColor:Number;
		
		private var _nextStarFame:int;
		
		public function ClassToolTip(param1:XML, param2:PlayerModel, param3:CharacterStats) {
			this._playerXML = param1;
			this._playerModel = param2;
			this._charStats = param3;
			this.showUnlockRequirements = this.shouldShowUnlockRequirements(this._playerModel,this._playerXML);
			if(this.showUnlockRequirements) {
				this._backgroundColor = 1842204;
				this._lineColor = this._borderColor = 3552822;
			} else {
				this._backgroundColor = 3552822;
				this._borderColor = 16777215;
				this._lineColor = 1842204;
			}
			super(this._backgroundColor,1,this._borderColor,1);
			this.init();
		}
		
		public static function getDisplayId(param1:XML) : String {
			return param1.DisplayId == undefined?param1.@id:param1.DisplayId;
		}
		
		private function init() : void {
			this._numberOfStars = this._charStats == null?0:int(this._charStats.numStars());
			this.createCharacter();
			this.createEquipmentTypes();
			this.createCharacterName();
			this.lineBreakOne = new LineBreakDesign(CLASS_TOOL_TIP_WIDTH - 6,this._lineColor);
			addChild(this.lineBreakOne);
			if(this.showUnlockRequirements) {
				this.createUnlockRequirements();
			} else {
				this.createClassQuest();
				this.createQuestText();
				this.createStarProgress();
				this.createBestLevelAndFame();
				this.createClassUnlockTitle();
				this.createClassUnlocks();
				if(this._classUnlockContainer.numChildren > 0) {
					this.lineBreakTwo = new LineBreakDesign(CLASS_TOOL_TIP_WIDTH - 6,this._lineColor);
					addChild(this.lineBreakTwo);
				}
			}
		}
		
		private function createCharacter() : void {
			var loc1:AnimatedChar = AnimatedChars.getAnimatedChar(String(this._playerXML.AnimatedTexture.File),int(this._playerXML.AnimatedTexture.Index));
			var loc2:MaskedImage = loc1.imageFromDir(AnimatedChar.RIGHT,AnimatedChar.STAND,0);
			var loc3:int = 4 / loc2.width() * 100;
			var loc4:BitmapData = TextureRedrawer.redraw(loc2.image_,loc3,true,0);
			if(this.showUnlockRequirements) {
				loc4 = CachingColorTransformer.transformBitmapData(loc4,new ColorTransform(0,0,0,0.5,0,0,0,0));
			}
			this.portrait_ = new Bitmap();
			this.portrait_.bitmapData = loc4;
			this.portrait_.x = -4;
			this.portrait_.y = -4;
			addChild(this.portrait_);
		}
		
		private function createEquipmentTypes() : void {
			var loc4:int = 0;
			var loc5:BitmapData = null;
			var loc6:Bitmap = null;
			var loc7:Bitmap = null;
			this._equipmentContainer = new Sprite();
			addChild(this._equipmentContainer);
			var loc1:Vector.<int> = ConversionUtil.toIntVector(this._playerXML.SlotTypes);
			var loc2:Vector.<int> = ConversionUtil.toIntVector(this._playerXML.Equipment);
			var loc3:int = 0;
			while(loc3 < EquipmentUtil.NUM_SLOTS) {
				loc4 = loc2[loc3];
				if(loc4 > -1) {
					loc5 = ObjectLibrary.getRedrawnTextureFromType(loc4,40,true);
					loc6 = new Bitmap(loc5);
					loc6.x = loc3 * 22;
					loc6.y = -12;
					this._equipmentContainer.addChild(loc6);
				} else {
					loc7 = EquipmentUtil.getEquipmentBackground(loc1[loc3],2);
					if(loc7) {
						loc7.x = 12 + loc3 * 22;
						loc7.filters = FilterUtil.getDarkGreyColorFilter();
						this._equipmentContainer.addChild(loc7);
					}
				}
				loc3++;
			}
		}
		
		private function createCharacterName() : void {
			this.nameText_ = new TextFieldDisplayConcrete().setSize(13).setColor(16777215);
			this.nameText_.setBold(true);
			this.nameText_.setStringBuilder(new LineBuilder().setParams(getDisplayId(this._playerXML)));
			this.nameText_.filters = [new DropShadowFilter(0,0,0)];
			waiter.push(this.nameText_.textChanged);
			addChild(this.nameText_);
			this.descriptionText_ = new TextFieldDisplayConcrete().setSize(13).setColor(11776947).setWordWrap(true).setMultiLine(true).setTextWidth(174);
			this.descriptionText_.setStringBuilder(new LineBuilder().setParams(this._playerXML.Description));
			this.descriptionText_.filters = [new DropShadowFilter(0,0,0)];
			waiter.push(this.descriptionText_.textChanged);
			addChild(this.descriptionText_);
		}
		
		private function createClassQuest() : void {
			this.classQuestText_ = new TextFieldDisplayConcrete().setSize(13).setColor(16777215);
			this.classQuestText_.setBold(true);
			this.classQuestText_.setStringBuilder(new LineBuilder().setParams("Class Quest"));
			this.classQuestText_.filters = [new DropShadowFilter(0,0,0)];
			waiter.push(this.classQuestText_.textChanged);
			addChild(this.classQuestText_);
		}
		
		private function createQuestText() : void {
			this._nextStarFame = FameUtil.nextStarFame(this._charStats == null?0:int(this._charStats.bestFame()),0);
			if(this._nextStarFame > 0) {
				this.nextClassQuest_ = new TextFieldDisplayConcrete().setSize(13).setColor(16549442).setTextWidth(160).setMultiLine(true).setWordWrap(true);
				if(this._numberOfStars > 0) {
					this.nextClassQuest_.setStringBuilder(new LineBuilder().setParams("Earn {nextStarFame} Fame with {typeToDisplay} to unlock the next Star",{
						"nextStarFame":this._nextStarFame,
						"typeToDisplay":getDisplayId(this._playerXML)
					}));
				} else {
					this.nextClassQuest_.setStringBuilder(new LineBuilder().setParams("Earn 20 Fame with {typeToDisplay} to unlock the first star",{"typeToDisplay":getDisplayId(this._playerXML)}));
				}
				this.nextClassQuest_.filters = [new DropShadowFilter(0,0,0)];
				waiter.push(this.nextClassQuest_.textChanged);
				addChild(this.nextClassQuest_);
			}
		}
		
		private function createStarProgress() : void {
			var loc1:Graphics = null;
			var loc6:int = 0;
			var loc7:int = 0;
			var loc8:Number = NaN;
			var loc9:* = false;
			var loc10:int = 0;
			var loc11:Sprite = null;
			var loc12:UILabel = null;
			var loc13:int = 0;
			this._progressContainer = new Sprite();
			loc1 = this._progressContainer.graphics;
			addChild(this._progressContainer);
			var loc2:int = 0;
			var loc3:Vector.<int> = FameUtil.STARS;
			var loc4:int = loc3.length;
			var loc5:int = 0;
			while(loc5 < loc4) {
				loc6 = loc3[loc5];
				loc7 = this._charStats != null?int(this._charStats.bestFame()):0;
				loc8 = loc7 >= loc6?Number(65280):Number(16549442);
				loc9 = loc5 < this._numberOfStars;
				loc10 = 20 + loc5 * 10;
				loc11 = new StarGraphic();
				loc11.x = loc2 + (loc10 - loc11.width) / 2;
				loc11.transform.colorTransform = !!loc9?FULL_STAR:EMPTY_STAR;
				this._progressContainer.addChild(loc11);
				loc12 = new UILabel();
				loc12.text = loc6.toString();
				DefaultLabelFormat.characterToolTipLabel(loc12,loc8);
				loc12.x = loc2 + (loc10 - loc12.width) / 2;
				loc12.y = 14;
				this._progressContainer.addChild(loc12);
				loc1.beginFill(1842204);
				loc1.drawRect(loc2,31,loc10,4);
				if(loc7 > 0) {
					loc1.beginFill(loc8);
					if(loc7 >= loc6) {
						loc1.drawRect(loc2,31,loc10,4);
					} else if(loc5 == 0) {
						loc13 = loc7 / loc6 * loc10;
						loc1.drawRect(loc2,31,loc13,4);
					} else if(loc7 > loc3[loc5 - 1]) {
						loc13 = (loc7 - loc3[loc5 - 1]) / (loc6 - loc3[loc5 - 1]) * loc10;
						loc1.drawRect(loc2,31,loc13,4);
					}
				}
				loc2 = loc2 + (1 + loc10);
				loc5++;
			}
		}
		
		private function createBestLevelAndFame() : void {
			var loc3:UILabel = null;
			this._bestContainer = new Sprite();
			addChild(this._bestContainer);
			var loc1:UILabel = new UILabel();
			loc1.text = "Best Level";
			DefaultLabelFormat.characterToolTipLabel(loc1,16777215);
			this._bestContainer.addChild(loc1);
			var loc2:UILabel = new UILabel();
			loc2.text = (this._charStats != null?this._charStats.bestLevel():0).toString();
			DefaultLabelFormat.characterToolTipLabel(loc2,16777215);
			loc2.x = CLASS_TOOL_TIP_WIDTH - 24;
			this._bestContainer.addChild(loc2);
			loc3 = new UILabel();
			loc3.text = "Best Fame";
			DefaultLabelFormat.characterToolTipLabel(loc3,16777215);
			loc3.y = 18;
			this._bestContainer.addChild(loc3);
			var loc4:BitmapData = AssetLibrary.getImageFromSet("lofiObj3",224);
			loc4 = TextureRedrawer.redraw(loc4,40,true,0);
			var loc5:Bitmap = new Bitmap(loc4);
			loc5.x = CLASS_TOOL_TIP_WIDTH - 36;
			loc5.y = loc3.y - 10;
			this._bestContainer.addChild(loc5);
			var loc6:UILabel = new UILabel();
			loc6.text = (this._charStats != null?this._charStats.bestFame():0).toString();
			DefaultLabelFormat.characterToolTipLabel(loc6,16777215);
			loc6.x = loc5.x - loc6.width;
			loc6.y = loc3.y;
			this._bestContainer.addChild(loc6);
		}
		
		private function createClassUnlockTitle() : void {
			this.classUnlockText_ = new TextFieldDisplayConcrete().setSize(13).setColor(16777215);
			this.classUnlockText_.setBold(true);
			this.classUnlockText_.setStringBuilder(new LineBuilder().setParams("Class Unlocks"));
			this.classUnlockText_.filters = [new DropShadowFilter(0,0,0)];
			waiter.push(this.classUnlockText_.textChanged);
			this.classUnlockText_.visible = false;
			addChild(this.classUnlockText_);
		}
		
		private function createClassUnlocks() : void {
			var loc7:XML = null;
			var loc8:String = null;
			var loc9:XML = null;
			var loc10:int = 0;
			var loc11:Number = NaN;
			var loc12:UILabel = null;
			this._classUnlockContainer = new Sprite();
			var loc1:int = ObjectLibrary.playerChars_.length;
			var loc2:Vector.<XML> = ObjectLibrary.playerChars_;
			var loc3:String = this._playerXML.@id;
			var loc4:int = this._charStats != null?int(this._charStats.bestLevel()):0;
			var loc5:int = 0;
			var loc6:int = 0;
			while(loc6 < loc1) {
				loc7 = loc2[loc6];
				loc8 = loc7.@id;
				if(loc3 != loc8 && loc7.UnlockLevel) {
					for each(loc9 in loc7.UnlockLevel) {
						if(loc3 == loc9.toString()) {
							loc10 = int(loc9.@level);
							loc11 = loc4 >= loc10?Number(65280):Number(16711680);
							loc12 = new UILabel();
							loc12.text = "Reach level " + loc10.toString() + " to unlock " + loc8;
							DefaultLabelFormat.characterToolTipLabel(loc12,loc11);
							loc12.y = loc5;
							this._classUnlockContainer.addChild(loc12);
							loc5 = loc5 + 14;
						}
					}
				}
				loc6++;
			}
			addChild(this._classUnlockContainer);
		}
		
		private function createUnlockRequirements() : void {
			var loc2:XML = null;
			var loc3:int = 0;
			var loc4:int = 0;
			this.toUnlockText_ = new TextFieldDisplayConcrete().setSize(13).setColor(11776947).setTextWidth(174).setBold(true);
			this.toUnlockText_.setStringBuilder(new LineBuilder().setParams(TextKey.TO_UNLOCK));
			this.toUnlockText_.filters = [new DropShadowFilter(0,0,0)];
			waiter.push(this.toUnlockText_.textChanged);
			addChild(this.toUnlockText_);
			this.unlockText_ = new TextFieldDisplayConcrete().setSize(13).setColor(16549442).setTextWidth(174).setWordWrap(false).setMultiLine(true);
			var loc1:AppendingLineBuilder = new AppendingLineBuilder();
			for each(loc2 in this._playerXML.UnlockLevel) {
				loc3 = ObjectLibrary.idToType_[loc2.toString()];
				loc4 = int(loc2.@level);
				if(this._playerModel.getBestLevel(loc3) < int(loc2.@level)) {
					loc1.pushParams(TextKey.TO_UNLOCK_REACH_LEVEL,{
						"unlockLevel":loc4,
						"typeToDisplay":ObjectLibrary.typeToDisplayId_[loc3]
					});
				}
			}
			this.unlockText_.setStringBuilder(loc1);
			this.unlockText_.filters = [new DropShadowFilter(0,0,0)];
			waiter.push(this.unlockText_.textChanged);
			addChild(this.unlockText_);
		}
		
		override protected function alignUI() : void {
			this.nameText_.x = 32;
			this.nameText_.y = 6;
			this.descriptionText_.x = 8;
			this.descriptionText_.y = 40;
			this.lineBreakOne.x = 6;
			this.lineBreakOne.y = height;
			if(this.showUnlockRequirements) {
				this.toUnlockText_.x = 8;
				this.toUnlockText_.y = height - 2;
				this.unlockText_.x = 12;
				this.unlockText_.y = height - 4;
			} else {
				this.classQuestText_.x = 6;
				this.classQuestText_.y = height - 2;
				if(this._nextStarFame > 0) {
					this.nextClassQuest_.x = 8;
					this.nextClassQuest_.y = height - 4;
				}
				this._progressContainer.x = 10;
				this._progressContainer.y = height - 2;
				this._bestContainer.x = 6;
				this._bestContainer.y = height;
				if(this.lineBreakTwo) {
					this.lineBreakTwo.x = 6;
					this.lineBreakTwo.y = height - 10;
					this.classUnlockText_.visible = true;
					this.classUnlockText_.x = 6;
					this.classUnlockText_.y = height;
					this._classUnlockContainer.x = 6;
					this._classUnlockContainer.y = height - 6;
				}
			}
			this.draw();
			position();
		}
		
		private function shouldShowUnlockRequirements(param1:PlayerModel, param2:XML) : Boolean {
			var loc3:Boolean = param1.isClassAvailability(String(param2.@id),SavedCharactersList.UNRESTRICTED);
			var loc4:Boolean = param1.isLevelRequirementsMet(int(param2.@type));
			return !loc3 && !loc4;
		}
		
		override public function draw() : void {
			this.lineBreakOne.setWidthColor(CLASS_TOOL_TIP_WIDTH,this._lineColor);
			this.lineBreakTwo && this.lineBreakTwo.setWidthColor(CLASS_TOOL_TIP_WIDTH,this._lineColor);
			this._equipmentContainer.x = CLASS_TOOL_TIP_WIDTH - this._equipmentContainer.width + 10;
			this._equipmentContainer.y = 6;
			super.draw();
		}
	}
}
