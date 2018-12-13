 
package com.company.assembleegameclient.ui.tooltip {
	import com.company.assembleegameclient.constants.InventoryOwnerTypes;
	import com.company.assembleegameclient.game.events.KeyInfoResponseSignal;
	import com.company.assembleegameclient.objects.ObjectLibrary;
	import com.company.assembleegameclient.objects.Player;
	import com.company.assembleegameclient.parameters.Parameters;
	import com.company.assembleegameclient.ui.LineBreakDesign;
	import com.company.assembleegameclient.util.FilterUtil;
	import com.company.assembleegameclient.util.MathUtil;
	import com.company.assembleegameclient.util.TierUtil;
	import com.company.util.BitmapUtil;
	import com.company.util.KeyCodes;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.Dictionary;
	import io.decagames.rotmg.ui.labels.UILabel;
	import kabam.rotmg.constants.ActivationType;
	import kabam.rotmg.core.StaticInjectorContext;
	import kabam.rotmg.messaging.impl.data.StatData;
	import kabam.rotmg.messaging.impl.incoming.KeyInfoResponse;
	import kabam.rotmg.text.model.TextKey;
	import kabam.rotmg.text.view.TextFieldDisplayConcrete;
	import kabam.rotmg.text.view.stringBuilder.AppendingLineBuilder;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;
	import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
	import kabam.rotmg.text.view.stringBuilder.StringBuilder;
	import kabam.rotmg.ui.model.HUDModel;
	
	public class EquipmentToolTip extends ToolTip {
		
		private static const MAX_WIDTH:int = 230;
		
		public static var keyInfo:Dictionary = new Dictionary();
		 
		
		private var icon:Bitmap;
		
		public var titleText:TextFieldDisplayConcrete;
		
		private var tierText:UILabel;
		
		private var descText:TextFieldDisplayConcrete;
		
		private var line1:LineBreakDesign;
		
		private var effectsText:TextFieldDisplayConcrete;
		
		private var line2:LineBreakDesign;
		
		private var line3:LineBreakDesign;
		
		private var restrictionsText:TextFieldDisplayConcrete;
		
		private var setInfoText:TextFieldDisplayConcrete;
		
		private var player:Player;
		
		private var isEquippable:Boolean = false;
		
		private var objectType:int;
		
		private var titleOverride:String;
		
		private var descriptionOverride:String;
		
		private var curItemXML:XML = null;
		
		private var objectXML:XML = null;
		
		private var slotTypeToTextBuilder:SlotComparisonFactory;
		
		private var restrictions:Vector.<Restriction>;
		
		private var setInfo:Vector.<Effect>;
		
		private var effects:Vector.<Effect>;
		
		private var uniqueEffects:Vector.<Effect>;
		
		private var itemSlotTypeId:int;
		
		private var invType:int;
		
		private var inventorySlotID:uint;
		
		private var inventoryOwnerType:String;
		
		private var isInventoryFull:Boolean;
		
		private var playerCanUse:Boolean;
		
		private var comparisonResults:SlotComparisonResult;
		
		private var powerText:TextFieldDisplayConcrete;
		
		private var supporterPointsText:TextFieldDisplayConcrete;
		
		private var keyInfoResponse:KeyInfoResponseSignal;
		
		private var originalObjectType:int;
		
		private var sameActivateEffect:Boolean;
		
		public function EquipmentToolTip(param1:int, param2:Player, param3:int, param4:String) {
			var loc8:HUDModel = null;
			this.uniqueEffects = new Vector.<Effect>();
			this.objectType = param1;
			this.originalObjectType = this.objectType;
			this.player = param2;
			this.invType = param3;
			this.inventoryOwnerType = param4;
			this.isInventoryFull = !!param2?Boolean(param2.isInventoryFull()):false;
			this.playerCanUse = !!param2?Boolean(ObjectLibrary.isUsableByPlayer(this.objectType,param2)):false;
			var loc5:uint = this.playerCanUse || this.player == null?uint(3552822):uint(6036765);
			var loc6:uint = this.playerCanUse || param2 == null?uint(10197915):uint(10965039);
			super(loc5,1,loc6,1,true);
			if(this.objectType >= 36864 && this.objectType <= 61440) {
				this.objectType = 36863;
			}
			var loc7:int = !!param2?int(ObjectLibrary.getMatchingSlotIndex(this.objectType,param2)):-1;
			this.slotTypeToTextBuilder = new SlotComparisonFactory();
			this.objectXML = ObjectLibrary.xmlLibrary_[this.objectType];
			this.isEquippable = loc7 != -1;
			this.setInfo = new Vector.<Effect>();
			this.effects = new Vector.<Effect>();
			this.itemSlotTypeId = int(this.objectXML.SlotType);
			if(this.player == null) {
				this.curItemXML = this.objectXML;
			} else if(this.isEquippable) {
				if(this.player.equipment_[loc7] != -1) {
					this.curItemXML = ObjectLibrary.xmlLibrary_[this.player.equipment_[loc7]];
				}
			}
			this.addIcon();
			if(this.originalObjectType >= 36864 && this.originalObjectType <= 61440) {
				if(keyInfo[this.originalObjectType] == null) {
					this.addTitle();
					this.addDescriptionText();
					this.keyInfoResponse = StaticInjectorContext.getInjector().getInstance(KeyInfoResponseSignal);
					this.keyInfoResponse.add(this.onKeyInfoResponse);
					loc8 = StaticInjectorContext.getInjector().getInstance(HUDModel);
					loc8.gameSprite.gsc_.keyInfoRequest(this.originalObjectType);
				} else {
					this.titleOverride = keyInfo[this.originalObjectType][0] + " Key";
					this.descriptionOverride = keyInfo[this.originalObjectType][1] + "\n" + "Created By: " + keyInfo[this.originalObjectType][2];
					this.addTitle();
					this.addDescriptionText();
				}
			} else {
				this.addTitle();
				this.addDescriptionText();
			}
			this.addTierText();
			this.handleWisMod();
			this.buildCategorySpecificText();
			this.addUniqueEffectsToList();
			this.sameActivateEffect = false;
			this.addActivateTagsToEffectsList();
			this.addNumProjectiles();
			this.addProjectileTagsToEffectsList();
			this.addRateOfFire();
			this.addActivateOnEquipTagsToEffectsList();
			this.addDoseTagsToEffectsList();
			this.addMpCostTagToEffectsList();
			this.addFameBonusTagToEffectsList();
			this.addCooldown();
			this.addSetInfo();
			this.makeSetInfoText();
			this.makeEffectsList();
			this.makeLineTwo();
			this.makeRestrictionList();
			this.makeRestrictionText();
			this.makeItemPowerText();
			this.makeSupporterPointsText();
		}
		
		private function addSetInfo() : void {
			if(!this.objectXML.hasOwnProperty("@setType")) {
				return;
			}
			var loc1:int = this.objectXML.attribute("setType");
			this.setInfo.push(new Effect("Part of {name}",{"name":"<b>" + this.objectXML.attribute("setName") + "</b>"}).setColor(TooltipHelper.SET_COLOR).setReplacementsColor(TooltipHelper.SET_COLOR));
			this.addSetActivateOnEquipTagsToEffectsList(loc1);
		}
		
		private function addSetActivateOnEquipTagsToEffectsList(param1:int) : void {
			var loc4:XML = null;
			var loc2:uint = 8805920;
			var loc3:XML = ObjectLibrary.getSetXMLFromType(param1);
			if(!loc3.hasOwnProperty("ActivateOnEquipAll")) {
				return;
			}
			for each(loc4 in loc3.ActivateOnEquipAll) {
				if(loc4.toString() == "ChangeSkin") {
					if(this.player != null && this.player.skinId == int(loc4.@skinType)) {
						loc2 = TooltipHelper.SET_COLOR;
					}
				}
				if(loc4.toString() == "IncrementStat") {
					this.setInfo.push(new Effect(TextKey.INCREMENT_STAT,this.getComparedStatText(loc4)).setColor(loc2).setReplacementsColor(loc2));
				}
			}
		}
		
		private function makeItemPowerText() : void {
			var loc1:int = 0;
			if(this.objectXML.hasOwnProperty("feedPower")) {
				loc1 = this.playerCanUse || this.player == null?16777215:16549442;
				this.powerText = new TextFieldDisplayConcrete().setSize(12).setColor(loc1).setBold(true).setTextWidth(MAX_WIDTH - this.icon.width - 4 - 30).setWordWrap(true);
				this.powerText.setStringBuilder(new StaticStringBuilder().setString("Feed Power: " + this.objectXML.feedPower));
				this.powerText.filters = FilterUtil.getStandardDropShadowFilter();
				waiter.push(this.powerText.textChanged);
				addChild(this.powerText);
			}
		}
		
		private function makeSupporterPointsText() : void {
			var loc1:XML = null;
			var loc2:String = null;
			for each(loc1 in this.objectXML.Activate) {
				loc2 = loc1.toString();
				if(loc2 == ActivationType.GRANT_SUPPORTER_POINTS) {
					this.supporterPointsText = new TextFieldDisplayConcrete().setSize(12).setColor(16777215).setBold(true).setTextWidth(MAX_WIDTH - this.icon.width - 4 - 30).setWordWrap(true);
					this.supporterPointsText.setStringBuilder(new StaticStringBuilder().setString("Supporter points: " + loc1.@amount));
					this.supporterPointsText.filters = FilterUtil.getStandardDropShadowFilter();
					waiter.push(this.supporterPointsText.textChanged);
					addChild(this.supporterPointsText);
				}
			}
		}
		
		private function onKeyInfoResponse(param1:KeyInfoResponse) : void {
			this.keyInfoResponse.remove(this.onKeyInfoResponse);
			this.removeTitle();
			this.removeDesc();
			this.titleOverride = param1.name;
			this.descriptionOverride = param1.description;
			keyInfo[this.originalObjectType] = [param1.name,param1.description,param1.creator];
			this.addTitle();
			this.addDescriptionText();
		}
		
		private function addUniqueEffectsToList() : void {
			var loc1:XMLList = null;
			var loc2:XML = null;
			var loc3:String = null;
			var loc4:String = null;
			var loc5:String = null;
			var loc6:AppendingLineBuilder = null;
			if(this.objectXML.hasOwnProperty("ExtraTooltipData")) {
				loc1 = this.objectXML.ExtraTooltipData.EffectInfo;
				for each(loc2 in loc1) {
					loc3 = loc2.attribute("name");
					loc4 = loc2.attribute("description");
					loc5 = loc3 && loc4?": ":"\n";
					loc6 = new AppendingLineBuilder();
					if(loc3) {
						loc6.pushParams(loc3);
					}
					if(loc4) {
						loc6.pushParams(loc4,{},TooltipHelper.getOpenTag(16777103),TooltipHelper.getCloseTag());
					}
					loc6.setDelimiter(loc5);
					this.uniqueEffects.push(new Effect(TextKey.BLANK,{"data":loc6}));
				}
			}
		}
		
		private function isEmptyEquipSlot() : Boolean {
			return this.isEquippable && this.curItemXML == null;
		}
		
		private function addIcon() : void {
			var loc1:XML = ObjectLibrary.xmlLibrary_[this.objectType];
			var loc2:int = 5;
			if(this.objectType == 4874 || this.objectType == 4618) {
				loc2 = 8;
			}
			if(loc1.hasOwnProperty("ScaleValue")) {
				loc2 = loc1.ScaleValue;
			}
			var loc3:BitmapData = ObjectLibrary.getRedrawnTextureFromType(this.objectType,60,true,true,loc2);
			loc3 = BitmapUtil.cropToBitmapData(loc3,4,4,loc3.width - 8,loc3.height - 8);
			this.icon = new Bitmap(loc3);
			addChild(this.icon);
		}
		
		private function addTierText() : void {
			this.tierText = TierUtil.getTierTag(this.objectXML,16);
			if(this.tierText) {
				addChild(this.tierText);
			}
		}
		
		private function removeTitle() : void {
			removeChild(this.titleText);
		}
		
		private function removeDesc() : void {
			removeChild(this.descText);
		}
		
		private function addTitle() : void {
			var loc1:int = this.playerCanUse || this.player == null?16777215:16549442;
			this.titleText = new TextFieldDisplayConcrete().setSize(16).setColor(loc1).setBold(true).setTextWidth(MAX_WIDTH - this.icon.width - 4 - 30).setWordWrap(true);
			if(this.titleOverride) {
				this.titleText.setStringBuilder(new StaticStringBuilder(this.titleOverride));
			} else {
				this.titleText.setStringBuilder(new LineBuilder().setParams(ObjectLibrary.typeToDisplayId_[this.objectType]));
			}
			this.titleText.filters = FilterUtil.getStandardDropShadowFilter();
			waiter.push(this.titleText.textChanged);
			addChild(this.titleText);
		}
		
		private function buildUniqueTooltipData() : String {
			var loc1:XMLList = null;
			var loc2:Vector.<Effect> = null;
			var loc3:XML = null;
			if(this.objectXML.hasOwnProperty("ExtraTooltipData")) {
				loc1 = this.objectXML.ExtraTooltipData.EffectInfo;
				loc2 = new Vector.<Effect>();
				for each(loc3 in loc1) {
					loc2.push(new Effect(loc3.attribute("name"),loc3.attribute("description")));
				}
			}
			return "";
		}
		
		private function makeEffectsList() : void {
			var loc1:AppendingLineBuilder = null;
			if(this.effects.length != 0 || this.comparisonResults.lineBuilder != null || this.objectXML.hasOwnProperty("ExtraTooltipData")) {
				this.line1 = new LineBreakDesign(MAX_WIDTH - 12,0);
				this.effectsText = new TextFieldDisplayConcrete().setSize(14).setColor(11776947).setTextWidth(MAX_WIDTH).setWordWrap(true).setHTML(true);
				loc1 = this.getEffectsStringBuilder();
				this.effectsText.setStringBuilder(loc1);
				this.effectsText.filters = FilterUtil.getStandardDropShadowFilter();
				if(loc1.hasLines()) {
					addChild(this.line1);
					addChild(this.effectsText);
					waiter.push(this.effectsText.textChanged);
				}
			}
		}
		
		private function getEffectsStringBuilder() : AppendingLineBuilder {
			var loc1:AppendingLineBuilder = new AppendingLineBuilder();
			this.appendEffects(this.uniqueEffects,loc1);
			if(this.comparisonResults.lineBuilder.hasLines()) {
				loc1.pushParams(TextKey.BLANK,{"data":this.comparisonResults.lineBuilder});
			}
			this.appendEffects(this.effects,loc1);
			return loc1;
		}
		
		private function appendEffects(param1:Vector.<Effect>, param2:AppendingLineBuilder) : void {
			var loc3:Effect = null;
			var loc4:* = null;
			var loc5:String = null;
			for each(loc3 in param1) {
				loc4 = "";
				loc5 = "";
				if(loc3.color_) {
					loc4 = "<font color=\"#" + loc3.color_.toString(16) + "\">";
					loc5 = "</font>";
				}
				param2.pushParams(loc3.name_,loc3.getValueReplacementsWithColor(),loc4,loc5);
			}
		}
		
		private function addFameBonusTagToEffectsList() : void {
			var loc1:int = 0;
			var loc2:uint = 0;
			var loc3:int = 0;
			if(this.objectXML.hasOwnProperty("FameBonus")) {
				loc1 = int(this.objectXML.FameBonus);
				loc2 = !!this.playerCanUse?uint(TooltipHelper.BETTER_COLOR):uint(TooltipHelper.NO_DIFF_COLOR);
				if(this.curItemXML != null && this.curItemXML.hasOwnProperty("FameBonus")) {
					loc3 = int(this.curItemXML.FameBonus.text());
					loc2 = TooltipHelper.getTextColor(loc1 - loc3);
				}
				this.effects.push(new Effect(TextKey.FAME_BONUS,{"percent":this.objectXML.FameBonus + "%"}).setReplacementsColor(loc2));
			}
		}
		
		private function addMpCostTagToEffectsList() : void {
			var loc1:int = 0;
			var loc2:int = 0;
			if(this.objectXML.hasOwnProperty("MpEndCost")) {
				loc1 = loc2 = this.objectXML.MpEndCost;
				if(this.curItemXML && this.curItemXML.hasOwnProperty("MpEndCost")) {
					loc2 = this.curItemXML.MpEndCost;
				}
				this.effects.push(new Effect(TextKey.MP_COST,{"cost":TooltipHelper.compare(loc1,loc2,false)}));
			} else if(this.objectXML.hasOwnProperty("MpCost")) {
				loc1 = loc2 = this.objectXML.MpCost;
				if(this.curItemXML && this.curItemXML.hasOwnProperty("MpCost")) {
					loc2 = this.curItemXML.MpCost;
				}
				this.effects.push(new Effect(TextKey.MP_COST,{"cost":TooltipHelper.compare(loc1,loc2,false)}));
			}
		}
		
		private function addDoseTagsToEffectsList() : void {
			if(this.objectXML.hasOwnProperty("Doses")) {
				this.effects.push(new Effect(TextKey.DOSES,{"dose":this.objectXML.Doses}));
			}
			if(this.objectXML.hasOwnProperty("Quantity")) {
				this.effects.push(new Effect("Quantity: {quantity}",{"quantity":this.objectXML.Quantity}));
			}
		}
		
		private function addNumProjectiles() : void {
			var loc1:ComPairTag = new ComPairTag(this.objectXML,this.curItemXML,"NumProjectiles",1);
			if(loc1.a != 1 || loc1.a != loc1.b) {
				this.effects.push(new Effect(TextKey.SHOTS,{"numShots":TooltipHelper.compare(loc1.a,loc1.b)}));
			}
		}
		
		private function addProjectileTagsToEffectsList() : void {
			var loc1:XML = null;
			if(this.objectXML.hasOwnProperty("Projectile")) {
				loc1 = this.curItemXML == null?null:this.curItemXML.Projectile[0];
				this.addProjectile(this.objectXML.Projectile[0],loc1);
			}
		}
		
		private function addProjectile(param1:XML, param2:XML = null) : void {
			var loc15:XML = null;
			var loc3:ComPairTag = new ComPairTag(param1,param2,"MinDamage");
			var loc4:ComPairTag = new ComPairTag(param1,param2,"MaxDamage");
			var loc5:ComPairTag = new ComPairTag(param1,param2,"Speed");
			var loc6:ComPairTag = new ComPairTag(param1,param2,"LifetimeMS");
			var loc7:ComPairTagBool = new ComPairTagBool(param1,param2,"Boomerang");
			var loc8:ComPairTagBool = new ComPairTagBool(param1,param2,"Parametric");
			var loc9:ComPairTag = new ComPairTag(param1,param2,"Magnitude",3);
			var loc10:Number = !!loc8.a?Number(loc9.a):Number(MathUtil.round(loc5.a * loc6.a / (int(loc7.a) + 1) / 10000,2));
			var loc11:Number = !!loc8.b?Number(loc9.b):Number(MathUtil.round(loc5.b * loc6.b / (int(loc7.b) + 1) / 10000,2));
			var loc12:Number = (loc4.a + loc3.a) / 2;
			var loc13:Number = (loc4.b + loc3.b) / 2;
			var loc14:String = (loc3.a == loc4.a?loc3.a:loc3.a + " - " + loc4.a).toString();
			this.effects.push(new Effect(TextKey.DAMAGE,{"damage":TooltipHelper.wrapInFontTag(loc14,"#" + TooltipHelper.getTextColor(loc12 - loc13).toString(16))}));
			this.effects.push(new Effect(TextKey.RANGE,{"range":TooltipHelper.compare(loc10,loc11)}));
			if(param1.hasOwnProperty("MultiHit")) {
				this.effects.push(new Effect(TextKey.MULTIHIT,{}).setColor(TooltipHelper.NO_DIFF_COLOR));
			}
			if(param1.hasOwnProperty("PassesCover")) {
				this.effects.push(new Effect(TextKey.PASSES_COVER,{}).setColor(TooltipHelper.NO_DIFF_COLOR));
			}
			if(param1.hasOwnProperty("ArmorPiercing")) {
				this.effects.push(new Effect(TextKey.ARMOR_PIERCING,{}).setColor(TooltipHelper.NO_DIFF_COLOR));
			}
			if(loc8.a) {
				this.effects.push(new Effect("Shots are parametric",{}).setColor(TooltipHelper.NO_DIFF_COLOR));
			} else if(loc7.a) {
				this.effects.push(new Effect("Shots boomerang",{}).setColor(TooltipHelper.NO_DIFF_COLOR));
			}
			if(param1.hasOwnProperty("ConditionEffect")) {
				this.effects.push(new Effect(TextKey.SHOT_EFFECT,{"effect":""}));
			}
			for each(loc15 in param1.ConditionEffect) {
				this.effects.push(new Effect(TextKey.EFFECT_FOR_DURATION,{
					"effect":loc15,
					"duration":loc15.@duration
				}).setColor(TooltipHelper.NO_DIFF_COLOR));
			}
		}
		
		private function addRateOfFire() : void {
			var loc2:String = null;
			var loc1:ComPairTag = new ComPairTag(this.objectXML,this.curItemXML,"RateOfFire",1);
			if(loc1.a != 1 || loc1.a != loc1.b) {
				loc1.a = MathUtil.round(loc1.a * 100,2);
				loc1.b = MathUtil.round(loc1.b * 100,2);
				loc2 = TooltipHelper.compare(loc1.a,loc1.b,true,"%");
				this.effects.push(new Effect(TextKey.RATE_OF_FIRE,{"data":loc2}));
			}
		}
		
		private function addCooldown() : void {
			var loc1:ComPairTag = new ComPairTag(this.objectXML,this.curItemXML,"Cooldown",0.5);
			if(loc1.a != 0.5 || loc1.a != loc1.b) {
				this.effects.push(new Effect("Cooldown: {cd}",{"cd":TooltipHelper.compareAndGetPlural(loc1.a,loc1.b,"second",false)}));
			}
		}
		
		private function addActivateTagsToEffectsList() : void {
			var activateXML:XML = null;
			var val:String = null;
			var stat:int = 0;
			var amt:int = 0;
			var test:String = null;
			var activationType:String = null;
			var compareXML:XML = null;
			var effectColor:uint = 0;
			var current:XML = null;
			var tokens:Object = null;
			var template:String = null;
			var effectColor2:uint = 0;
			var current2:XML = null;
			var statStr:String = null;
			var tokens2:Object = null;
			var template2:String = null;
			var replaceParams:Object = null;
			var rNew:Number = NaN;
			var rCurrent:Number = NaN;
			var dNew:Number = NaN;
			var dCurrent:Number = NaN;
			var comparer:Number = NaN;
			var rNew2:Number = NaN;
			var rCurrent2:Number = NaN;
			var dNew2:Number = NaN;
			var dCurrent2:Number = NaN;
			var aNew2:Number = NaN;
			var aCurrent2:Number = NaN;
			var comparer2:Number = NaN;
			var alb:AppendingLineBuilder = null;
			for each(activateXML in this.objectXML.Activate) {
				test = this.comparisonResults.processedTags[activateXML.toXMLString()];
				if(this.comparisonResults.processedTags[activateXML.toXMLString()] == true) {
					continue;
				}
				activationType = activateXML.toString();
				compareXML = this.curItemXML == null?null:this.curItemXML.Activate.(text() == activationType)[0];
				switch(activationType) {
					case ActivationType.COND_EFFECT_AURA:
						this.effects.push(new Effect(TextKey.PARTY_EFFECT,{"effect":new AppendingLineBuilder().pushParams(TextKey.WITHIN_SQRS,{"range":activateXML.@range},TooltipHelper.getOpenTag(TooltipHelper.NO_DIFF_COLOR),TooltipHelper.getCloseTag())}));
						this.effects.push(new Effect(TextKey.EFFECT_FOR_DURATION,{
							"effect":activateXML.@effect,
							"duration":activateXML.@duration
						}).setColor(TooltipHelper.NO_DIFF_COLOR));
						continue;
					case ActivationType.COND_EFFECT_SELF:
						this.effects.push(new Effect(TextKey.EFFECT_ON_SELF,{"effect":""}));
						this.effects.push(new Effect(TextKey.EFFECT_FOR_DURATION,{
							"effect":activateXML.@effect,
							"duration":activateXML.@duration
						}));
						continue;
					case ActivationType.STAT_BOOST_SELF:
						this.effects.push(new Effect("{amount} {stat} for {duration} ",{
							"amount":this.prefix(activateXML.@amount),
							"stat":new LineBuilder().setParams(StatData.statToName(int(activateXML.@stat))),
							"duration":TooltipHelper.getPlural(activateXML.@duration,"second")
						}));
						continue;
					case ActivationType.HEAL:
						this.effects.push(new Effect(TextKey.INCREMENT_STAT,{
							"statAmount":"+" + activateXML.@amount + " ",
							"statName":new LineBuilder().setParams(TextKey.STATUS_BAR_HEALTH_POINTS)
						}));
						continue;
					case ActivationType.HEAL_NOVA:
						if(activateXML.hasOwnProperty("@damage") && int(activateXML.@damage) > 0) {
							this.effects.push(new Effect("{damage} damage within {range} sqrs",{
								"damage":activateXML.@damage,
								"range":activateXML.@range
							}));
						}
						this.effects.push(new Effect(TextKey.PARTY_HEAL,{"effect":new AppendingLineBuilder().pushParams(TextKey.HP_WITHIN_SQRS,{
							"amount":activateXML.@amount,
							"range":activateXML.@range
						},TooltipHelper.getOpenTag(TooltipHelper.NO_DIFF_COLOR),TooltipHelper.getCloseTag())}));
						continue;
					case ActivationType.MAGIC:
						this.effects.push(new Effect(TextKey.INCREMENT_STAT,{
							"statAmount":"+" + activateXML.@amount + " ",
							"statName":new LineBuilder().setParams(TextKey.STATUS_BAR_MANA_POINTS)
						}));
						continue;
					case ActivationType.MAGIC_NOVA:
						this.effects.push(new Effect(TextKey.PARTY_FILL,{"effect":new AppendingLineBuilder().pushParams(TextKey.MP_WITHIN_SQRS,{
							"amount":activateXML.@amount,
							"range":activateXML.@range
						},TooltipHelper.getOpenTag(TooltipHelper.NO_DIFF_COLOR),TooltipHelper.getCloseTag())}));
						continue;
					case ActivationType.TELEPORT:
						this.effects.push(new Effect(TextKey.BLANK,{"data":new LineBuilder().setParams(TextKey.TELEPORT_TO_TARGET)}));
						continue;
					case ActivationType.BULLET_NOVA:
						this.getSpell(activateXML,compareXML);
						continue;
					case ActivationType.BULLET_CREATE:
						this.getBulletCreate(activateXML,compareXML);
						continue;
					case ActivationType.VAMPIRE_BLAST:
						this.getSkull(activateXML,compareXML);
						continue;
					case ActivationType.TRAP:
						this.getTrap(activateXML,compareXML);
						continue;
					case ActivationType.STASIS_BLAST:
						this.effects.push(new Effect(TextKey.STASIS_GROUP,{"stasis":new AppendingLineBuilder().pushParams(TextKey.SEC_COUNT,{"duration":activateXML.@duration},TooltipHelper.getOpenTag(TooltipHelper.NO_DIFF_COLOR),TooltipHelper.getCloseTag())}));
						continue;
					case ActivationType.DECOY:
						this.getDecoy(activateXML,compareXML);
						continue;
					case ActivationType.LIGHTNING:
						this.getLightning(activateXML,compareXML);
						continue;
					case ActivationType.POISON_GRENADE:
						this.getPoison(activateXML,compareXML);
						continue;
					case ActivationType.REMOVE_NEG_COND:
						this.effects.push(new Effect(TextKey.REMOVES_NEGATIVE,{}).setColor(TooltipHelper.NO_DIFF_COLOR));
						continue;
					case ActivationType.REMOVE_NEG_COND_SELF:
						this.effects.push(new Effect(TextKey.REMOVES_NEGATIVE,{}).setColor(TooltipHelper.NO_DIFF_COLOR));
						continue;
					case ActivationType.GENERIC_ACTIVATE:
						effectColor = 16777103;
						if(this.curItemXML != null) {
							current = this.getEffectTag(this.curItemXML,activateXML.@effect);
							if(current != null) {
								rNew = Number(activateXML.@range);
								rCurrent = Number(current.@range);
								dNew = Number(activateXML.@duration);
								dCurrent = Number(current.@duration);
								comparer = rNew - rCurrent + (dNew - dCurrent);
								if(comparer > 0) {
									effectColor = 65280;
								} else if(comparer < 0) {
									effectColor = 16711680;
								}
							}
						}
						tokens = {
							"range":activateXML.@range,
							"effect":activateXML.@effect,
							"duration":activateXML.@duration
						};
						template = "Within {range} sqrs {effect} for {duration} seconds";
						if(activateXML.@target != "enemy") {
							this.effects.push(new Effect(TextKey.PARTY_EFFECT,{"effect":LineBuilder.returnStringReplace(template,tokens)}).setReplacementsColor(effectColor));
						} else {
							this.effects.push(new Effect(TextKey.ENEMY_EFFECT,{"effect":LineBuilder.returnStringReplace(template,tokens)}).setReplacementsColor(effectColor));
						}
						continue;
					case ActivationType.STAT_BOOST_AURA:
						effectColor2 = 16777103;
						if(this.curItemXML != null) {
							current2 = this.getStatTag(this.curItemXML,activateXML.@stat);
							if(current2 != null) {
								rNew2 = Number(activateXML.@range);
								rCurrent2 = Number(current2.@range);
								dNew2 = Number(activateXML.@duration);
								dCurrent2 = Number(current2.@duration);
								aNew2 = Number(activateXML.@amount);
								aCurrent2 = Number(current2.@amount);
								comparer2 = rNew2 - rCurrent2 + (dNew2 - dCurrent2) + (aNew2 - aCurrent2);
								if(comparer2 > 0) {
									effectColor2 = 65280;
								} else if(comparer2 < 0) {
									effectColor2 = 16711680;
								}
							}
						}
						stat = int(activateXML.@stat);
						statStr = LineBuilder.getLocalizedString2(StatData.statToName(stat));
						tokens2 = {
							"range":activateXML.@range,
							"stat":statStr,
							"amount":activateXML.@amount,
							"duration":activateXML.@duration
						};
						template2 = "Within {range} sqrs increase {stat} by {amount} for {duration} seconds";
						this.effects.push(new Effect(TextKey.PARTY_EFFECT,{"effect":LineBuilder.returnStringReplace(template2,tokens2)}).setReplacementsColor(effectColor2));
						continue;
					case ActivationType.INCREMENT_STAT:
						stat = int(activateXML.@stat);
						amt = int(activateXML.@amount);
						replaceParams = {};
						if(stat != StatData.HP_STAT && stat != StatData.MP_STAT) {
							val = TextKey.PERMANENTLY_INCREASES;
							replaceParams["statName"] = new LineBuilder().setParams(StatData.statToName(stat));
							this.effects.push(new Effect(val,replaceParams).setColor(16777103));
						} else {
							val = TextKey.BLANK;
							alb = new AppendingLineBuilder().setDelimiter(" ");
							alb.pushParams(TextKey.BLANK,{"data":new StaticStringBuilder("+" + amt)});
							alb.pushParams(StatData.statToName(stat));
							replaceParams["data"] = alb;
							this.effects.push(new Effect(val,replaceParams));
						}
						continue;
					default:
						continue;
				}
			}
		}
		
		private function getSpell(param1:XML, param2:XML = null) : void {
			var loc3:ComPair = new ComPair(param1,param2,"numShots",20);
			var loc4:* = this.colorUntiered("Spell: ");
			loc4 = loc4 + "{numShots} Shots";
			this.effects.push(new Effect(loc4,{"numShots":TooltipHelper.compare(loc3.a,loc3.b)}));
		}
		
		private function getBulletCreate(param1:XML, param2:XML = null) : void {
			var loc3:ComPair = new ComPair(param1,param2,"numShots",3);
			var loc4:ComPair = new ComPair(param1,param2,"offsetAngle",90);
			var loc5:ComPair = new ComPair(param1,param2,"minDistance",0);
			var loc6:ComPair = new ComPair(param1,param2,"maxDistance",4.4);
			var loc7:* = this.colorUntiered("Wakizashi: ");
			loc7 = loc7 + "{numShots} shots at {angle}\n";
			if(loc5.a) {
				loc7 = loc7 + "Min Cast Range: {minDistance}\n";
			}
			loc7 = loc7 + "Max Cast Range: {maxDistance}";
			this.effects.push(new Effect(loc7,{
				"numShots":TooltipHelper.compare(loc3.a,loc3.b),
				"angle":TooltipHelper.getPlural(loc4.a,"degree"),
				"minDistance":TooltipHelper.compareAndGetPlural(loc5.a,loc5.b,"square",false),
				"maxDistance":TooltipHelper.compareAndGetPlural(loc6.a,loc6.b,"square")
			}));
		}
		
		private function getSkull(param1:XML, param2:XML = null) : void {
			var loc3:int = this.player != null?int(this.player.wisdom_):10;
			var loc4:int = this.GetIntArgument(param1,"wisPerRad",10);
			var loc5:Number = this.GetFloatArgument(param1,"incrRad",0.5);
			var loc6:int = this.GetIntArgument(param1,"wisDamageBase",0);
			var loc7:int = this.GetIntArgument(param1,"wisMin",50);
			var loc8:int = Math.max(0,loc3 - loc7);
			var loc9:int = loc6 / 10 * loc8;
			var loc10:Number = MathUtil.round(int(loc8 / loc4) * loc5,2);
			var loc11:ComPair = new ComPair(param1,param2,"totalDamage");
			loc11.add(loc9);
			var loc12:ComPair = new ComPair(param1,param2,"radius");
			var loc13:ComPair = new ComPair(param1,param2,"healRange",5);
			loc13.add(loc10);
			var loc14:ComPair = new ComPair(param1,param2,"heal");
			var loc15:ComPair = new ComPair(param1,param2,"ignoreDef",0);
			var loc16:* = this.colorUntiered("Skull: ");
			loc16 = loc16 + ("{damage}" + this.colorWisBonus(loc9) + " damage\n");
			loc16 = loc16 + "within {radius} squares\n";
			if(loc14.a) {
				loc16 = loc16 + "Steals {heal} HP";
			}
			if(loc14.a && loc15.a) {
				loc16 = loc16 + " and ignores {ignoreDef} defense";
			} else if(loc15.a) {
				loc16 = loc16 + "Ignores {ignoreDef} defense";
			}
			if(loc14.a) {
				loc16 = loc16 + ("\nHeals allies within {healRange}" + this.colorWisBonus(loc10) + " squares");
			}
			this.effects.push(new Effect(loc16,{
				"damage":TooltipHelper.compare(loc11.a,loc11.b),
				"radius":TooltipHelper.compare(loc12.a,loc12.b),
				"heal":TooltipHelper.compare(loc14.a,loc14.b),
				"ignoreDef":TooltipHelper.compare(loc15.a,loc15.b),
				"healRange":TooltipHelper.compare(MathUtil.round(loc13.a,2),MathUtil.round(loc13.b,2))
			}));
			this.AddConditionToEffects(param1,param2,"Nothing",2.5);
		}
		
		private function getTrap(param1:XML, param2:XML = null) : void {
			var loc3:ComPair = new ComPair(param1,param2,"totalDamage");
			var loc4:ComPair = new ComPair(param1,param2,"radius");
			var loc5:ComPair = new ComPair(param1,param2,"duration",20);
			var loc6:ComPair = new ComPair(param1,param2,"throwTime",1);
			var loc7:ComPair = new ComPair(param1,param2,"sensitivity",0.5);
			var loc8:Number = MathUtil.round(loc4.a * loc7.a,2);
			var loc9:Number = MathUtil.round(loc4.b * loc7.b,2);
			var loc10:* = this.colorUntiered("Trap: ");
			loc10 = loc10 + "{damage} damage within {radius} squares";
			this.effects.push(new Effect(loc10,{
				"damage":TooltipHelper.compare(loc3.a,loc3.b),
				"radius":TooltipHelper.compare(loc4.a,loc4.b)
			}));
			this.AddConditionToEffects(param1,param2,"Slowed",5);
			this.effects.push(new Effect("{throwTime} to arm for {duration} ",{
				"throwTime":TooltipHelper.compareAndGetPlural(loc6.a,loc6.b,"second",false),
				"duration":TooltipHelper.compareAndGetPlural(loc5.a,loc5.b,"second")
			}));
			this.effects.push(new Effect("Triggers within {triggerRadius} squares",{"triggerRadius":TooltipHelper.compare(loc8,loc9)}));
		}
		
		private function getLightning(param1:XML, param2:XML = null) : void {
			var loc15:String = null;
			var loc3:int = this.player != null?int(this.player.wisdom_):10;
			var loc4:ComPair = new ComPair(param1,param2,"decrDamage",0);
			var loc5:int = this.GetIntArgument(param1,"wisPerTarget",10);
			var loc6:int = this.GetIntArgument(param1,"wisDamageBase",loc4.a);
			var loc7:int = this.GetIntArgument(param1,"wisMin",50);
			var loc8:int = Math.max(0,loc3 - loc7);
			var loc9:int = loc8 / loc5;
			var loc10:int = loc6 / 10 * loc8;
			var loc11:ComPair = new ComPair(param1,param2,"maxTargets");
			loc11.add(loc9);
			var loc12:ComPair = new ComPair(param1,param2,"totalDamage");
			loc12.add(loc10);
			var loc13:String = this.colorUntiered("Lightning: ");
			loc13 = loc13 + ("{targets}" + this.colorWisBonus(loc9) + " targets\n");
			loc13 = loc13 + ("{damage}" + this.colorWisBonus(loc10) + " damage");
			var loc14:Boolean = false;
			if(loc4.a) {
				if(loc4.a < 0) {
					loc14 = true;
				}
				loc15 = "reduced";
				if(loc14) {
					loc15 = TooltipHelper.wrapInFontTag("increased","#" + TooltipHelper.NO_DIFF_COLOR.toString(16));
				}
				loc13 = loc13 + (", " + loc15 + " by \n{decrDamage} for each subsequent target");
			}
			this.effects.push(new Effect(loc13,{
				"targets":TooltipHelper.compare(loc11.a,loc11.b),
				"damage":TooltipHelper.compare(loc12.a,loc12.b),
				"decrDamage":TooltipHelper.compare(loc4.a,loc4.b,false,"",loc14)
			}));
			this.AddConditionToEffects(param1,param2,"Nothing",5);
		}
		
		private function getDecoy(param1:XML, param2:XML = null) : void {
			var loc3:ComPair = new ComPair(param1,param2,"duration");
			var loc4:ComPair = new ComPair(param1,param2,"angleOffset",0);
			var loc5:ComPair = new ComPair(param1,param2,"speed",1);
			var loc6:ComPair = new ComPair(param1,param2,"distance",8);
			var loc7:Number = MathUtil.round(loc6.a / (loc5.a * 5),2);
			var loc8:Number = MathUtil.round(loc6.b / (loc5.b * 5),2);
			var loc9:ComPair = new ComPair(param1,param2,"numShots",0);
			var loc10:* = this.colorUntiered("Decoy: ");
			loc10 = loc10 + "{duration}";
			if(loc4.a) {
				loc10 = loc10 + " at {angleOffset}";
			}
			loc10 = loc10 + "\n";
			if(loc5.a == 0) {
				loc10 = loc10 + "Decoy does not move";
			} else {
				loc10 = loc10 + "{distance} in {travelTime}";
			}
			if(loc9.a) {
				loc10 = loc10 + "\nShots: {numShots}";
			}
			this.effects.push(new Effect(loc10,{
				"duration":TooltipHelper.compareAndGetPlural(loc3.a,loc3.b,"second"),
				"angleOffset":TooltipHelper.compareAndGetPlural(loc4.a,loc4.b,"degree"),
				"distance":TooltipHelper.compareAndGetPlural(loc6.a,loc6.b,"square"),
				"travelTime":TooltipHelper.compareAndGetPlural(loc7,loc8,"second"),
				"numShots":TooltipHelper.compare(loc9.a,loc9.b)
			}));
		}
		
		private function getPoison(param1:XML, param2:XML = null) : void {
			var loc3:ComPair = new ComPair(param1,param2,"totalDamage");
			var loc4:ComPair = new ComPair(param1,param2,"radius");
			var loc5:ComPair = new ComPair(param1,param2,"duration");
			var loc6:ComPair = new ComPair(param1,param2,"throwTime",1);
			var loc7:ComPair = new ComPair(param1,param2,"impactDamage",0);
			var loc8:Number = loc3.a - loc7.a;
			var loc9:Number = loc3.b - loc7.b;
			var loc10:* = this.colorUntiered("Poison: ");
			loc10 = loc10 + "{totalDamage} damage";
			if(loc7.a) {
				loc10 = loc10 + " ({impactDamage} on impact)";
			}
			loc10 = loc10 + " within {radius}";
			loc10 = loc10 + " over {duration}";
			this.effects.push(new Effect(loc10,{
				"totalDamage":TooltipHelper.compare(loc3.a,loc3.b,true,"",false,!this.sameActivateEffect),
				"radius":TooltipHelper.compareAndGetPlural(loc4.a,loc4.b,"square",true,!this.sameActivateEffect),
				"impactDamage":TooltipHelper.compare(loc7.a,loc7.b,true,"",false,!this.sameActivateEffect),
				"duration":TooltipHelper.compareAndGetPlural(loc5.a,loc5.b,"second",false,!this.sameActivateEffect)
			}));
			this.AddConditionToEffects(param1,param2,"Nothing",5);
			this.sameActivateEffect = true;
		}
		
		private function AddConditionToEffects(param1:XML, param2:XML, param3:String = "Nothing", param4:Number = 5.0) : void {
			var loc6:ComPair = null;
			var loc7:String = null;
			var loc5:String = !!param1.hasOwnProperty("@condEffect")?param1.@condEffect:param3;
			if(loc5 != "Nothing") {
				loc6 = new ComPair(param1,param2,"condDuration",param4);
				if(param2) {
					loc7 = !!param2.hasOwnProperty("@condEffect")?param2.@condEffect:param3;
					if(loc7 == "Nothing") {
						loc6.b = 0;
					}
				}
				this.effects.push(new Effect("Inflicts {condition} for {duration} ",{
					"condition":loc5,
					"duration":TooltipHelper.compareAndGetPlural(loc6.a,loc6.b,"second")
				}));
			}
		}
		
		private function GetIntArgument(param1:XML, param2:String, param3:int = 0) : int {
			return !!param1.hasOwnProperty("@" + param2)?int(param1[param2]):int(param3);
		}
		
		private function GetFloatArgument(param1:XML, param2:String, param3:Number = 0) : Number {
			return !!param1.hasOwnProperty("@" + param2)?Number(param1[param2]):Number(param3);
		}
		
		private function GetStringArgument(param1:XML, param2:String, param3:String = "") : String {
			return !!param1.hasOwnProperty("@" + param2)?param1[param2]:param3;
		}
		
		private function colorWisBonus(param1:Number) : String {
			if(param1) {
				return TooltipHelper.wrapInFontTag(" (+" + param1 + ")","#" + TooltipHelper.WIS_BONUS_COLOR.toString(16));
			}
			return "";
		}
		
		private function colorUntiered(param1:String) : String {
			var loc2:Boolean = this.objectXML.hasOwnProperty("Tier");
			var loc3:Boolean = this.objectXML.hasOwnProperty("@setType");
			if(loc3) {
				return TooltipHelper.wrapInFontTag(param1,"#" + TooltipHelper.SET_COLOR.toString(16));
			}
			if(!loc2) {
				return TooltipHelper.wrapInFontTag(param1,"#" + TooltipHelper.UNTIERED_COLOR.toString(16));
			}
			return param1;
		}
		
		private function getEffectTag(param1:XML, param2:String) : XML {
			var matches:XMLList = null;
			var tag:XML = null;
			var xml:XML = param1;
			var effectValue:String = param2;
			matches = xml.Activate.(text() == ActivationType.GENERIC_ACTIVATE);
			for each(tag in matches) {
				if(tag.@effect == effectValue) {
					return tag;
				}
			}
			return null;
		}
		
		private function getStatTag(param1:XML, param2:String) : XML {
			var matches:XMLList = null;
			var tag:XML = null;
			var xml:XML = param1;
			var statValue:String = param2;
			matches = xml.Activate.(text() == ActivationType.STAT_BOOST_AURA);
			for each(tag in matches) {
				if(tag.@stat == statValue) {
					return tag;
				}
			}
			return null;
		}
		
		private function addActivateOnEquipTagsToEffectsList() : void {
			var loc1:XML = null;
			var loc2:Boolean = true;
			for each(loc1 in this.objectXML.ActivateOnEquip) {
				if(loc2) {
					this.effects.push(new Effect(TextKey.ON_EQUIP,""));
					loc2 = false;
				}
				if(loc1.toString() == "IncrementStat") {
					this.effects.push(new Effect(TextKey.INCREMENT_STAT,this.getComparedStatText(loc1)).setReplacementsColor(this.getComparedStatColor(loc1)));
				}
			}
		}
		
		private function getComparedStatText(param1:XML) : Object {
			var loc2:int = int(param1.@stat);
			var loc3:int = int(param1.@amount);
			return {
				"statAmount":this.prefix(loc3) + " ",
				"statName":new LineBuilder().setParams(StatData.statToName(loc2))
			};
		}
		
		private function prefix(param1:int) : String {
			var loc2:String = param1 > -1?"+":"";
			return loc2 + param1;
		}
		
		private function getComparedStatColor(param1:XML) : uint {
			var match:XML = null;
			var otherAmount:int = 0;
			var activateXML:XML = param1;
			var stat:int = int(activateXML.@stat);
			var amount:int = int(activateXML.@amount);
			var textColor:uint = !!this.playerCanUse?uint(TooltipHelper.BETTER_COLOR):uint(TooltipHelper.NO_DIFF_COLOR);
			var otherMatches:XMLList = null;
			if(this.curItemXML != null) {
				otherMatches = this.curItemXML.ActivateOnEquip.(@stat == stat);
			}
			if(otherMatches != null && otherMatches.length() == 1) {
				match = XML(otherMatches[0]);
				otherAmount = int(match.@amount);
				textColor = TooltipHelper.getTextColor(amount - otherAmount);
			}
			if(amount < 0) {
				textColor = 16711680;
			}
			return textColor;
		}
		
		private function addEquipmentItemRestrictions() : void {
			if(this.objectXML.hasOwnProperty("PetFood")) {
				this.restrictions.push(new Restriction("Used to feed your pet in the pet yard",11776947,false));
			} else if(this.objectXML.hasOwnProperty("Treasure") == false) {
				this.restrictions.push(new Restriction(TextKey.EQUIP_TO_USE,11776947,false));
				if(this.isInventoryFull || this.inventoryOwnerType == InventoryOwnerTypes.CURRENT_PLAYER) {
					this.restrictions.push(new Restriction(TextKey.DOUBLE_CLICK_EQUIP,11776947,false));
				} else {
					this.restrictions.push(new Restriction(TextKey.DOUBLE_CLICK_TAKE,11776947,false));
				}
			}
		}
		
		private function addAbilityItemRestrictions() : void {
			this.restrictions.push(new Restriction(TextKey.KEYCODE_TO_USE,16777215,false));
		}
		
		private function addConsumableItemRestrictions() : void {
			this.restrictions.push(new Restriction(TextKey.CONSUMED_WITH_USE,11776947,false));
			if(this.isInventoryFull || this.inventoryOwnerType == InventoryOwnerTypes.CURRENT_PLAYER) {
				this.restrictions.push(new Restriction(TextKey.DOUBLE_CLICK_OR_SHIFT_CLICK_TO_USE,16777215,false));
			} else {
				this.restrictions.push(new Restriction(TextKey.DOUBLE_CLICK_TAKE_SHIFT_CLICK_USE,16777215,false));
			}
		}
		
		private function addReusableItemRestrictions() : void {
			this.restrictions.push(new Restriction(TextKey.CAN_BE_USED_MULTIPLE_TIMES,11776947,false));
			this.restrictions.push(new Restriction(TextKey.DOUBLE_CLICK_OR_SHIFT_CLICK_TO_USE,16777215,false));
		}
		
		private function makeRestrictionList() : void {
			var loc2:XML = null;
			var loc3:Boolean = false;
			var loc4:int = 0;
			var loc5:int = 0;
			this.restrictions = new Vector.<Restriction>();
			if(this.objectXML.hasOwnProperty("VaultItem") && this.invType != -1 && this.invType != ObjectLibrary.idToType_["Vault Chest"]) {
				this.restrictions.push(new Restriction(TextKey.STORE_IN_VAULT,16549442,true));
			}
			if(this.objectXML.hasOwnProperty("Soulbound")) {
				this.restrictions.push(new Restriction(TextKey.ITEM_SOULBOUND,11776947,false));
			}
			if(this.playerCanUse) {
				if(this.objectXML.hasOwnProperty("Usable")) {
					this.addAbilityItemRestrictions();
					this.addEquipmentItemRestrictions();
				} else if(this.objectXML.hasOwnProperty("Consumable")) {
					if(this.objectXML.hasOwnProperty("Potion")) {
						this.restrictions.push(new Restriction("Potion",11776947,false));
					}
					this.addConsumableItemRestrictions();
				} else if(this.objectXML.hasOwnProperty("InvUse")) {
					this.addReusableItemRestrictions();
				} else {
					this.addEquipmentItemRestrictions();
				}
			} else if(this.player != null) {
				this.restrictions.push(new Restriction(TextKey.NOT_USABLE_BY,16549442,true));
			}
			var loc1:Vector.<String> = ObjectLibrary.usableBy(this.objectType);
			if(loc1 != null) {
				this.restrictions.push(new Restriction(TextKey.USABLE_BY,11776947,false));
			}
			for each(loc2 in this.objectXML.EquipRequirement) {
				loc3 = ObjectLibrary.playerMeetsRequirement(loc2,this.player);
				if(loc2.toString() == "Stat") {
					loc4 = int(loc2.@stat);
					loc5 = int(loc2.@value);
					this.restrictions.push(new Restriction("Requires " + StatData.statToName(loc4) + " of " + loc5,!!loc3?uint(11776947):uint(16549442),!!loc3?false:true));
				}
			}
		}
		
		private function makeLineTwo() : void {
			this.line2 = new LineBreakDesign(MAX_WIDTH - 12,0);
			addChild(this.line2);
		}
		
		private function makeLineThree() : void {
			this.line3 = new LineBreakDesign(MAX_WIDTH - 12,0);
			addChild(this.line3);
		}
		
		private function makeRestrictionText() : void {
			if(this.restrictions.length != 0) {
				this.restrictionsText = new TextFieldDisplayConcrete().setSize(14).setColor(11776947).setTextWidth(MAX_WIDTH - 4).setIndent(-10).setLeftMargin(10).setWordWrap(true).setHTML(true);
				this.restrictionsText.setStringBuilder(this.buildRestrictionsLineBuilder());
				this.restrictionsText.filters = FilterUtil.getStandardDropShadowFilter();
				waiter.push(this.restrictionsText.textChanged);
				addChild(this.restrictionsText);
			}
		}
		
		private function makeSetInfoText() : void {
			if(this.setInfo.length != 0) {
				this.setInfoText = new TextFieldDisplayConcrete().setSize(14).setColor(11776947).setTextWidth(MAX_WIDTH - 4).setIndent(-10).setLeftMargin(10).setWordWrap(true).setHTML(true);
				this.setInfoText.setStringBuilder(this.getSetBonusStringBuilder());
				this.setInfoText.filters = FilterUtil.getStandardDropShadowFilter();
				waiter.push(this.setInfoText.textChanged);
				addChild(this.setInfoText);
				this.makeLineThree();
			}
		}
		
		private function getSetBonusStringBuilder() : AppendingLineBuilder {
			var loc1:AppendingLineBuilder = new AppendingLineBuilder();
			this.appendEffects(this.setInfo,loc1);
			return loc1;
		}
		
		private function buildRestrictionsLineBuilder() : StringBuilder {
			var loc2:Restriction = null;
			var loc3:String = null;
			var loc4:String = null;
			var loc5:String = null;
			var loc1:AppendingLineBuilder = new AppendingLineBuilder();
			for each(loc2 in this.restrictions) {
				loc3 = !!loc2.bold_?"<b>":"";
				loc3 = loc3.concat("<font color=\"#" + loc2.color_.toString(16) + "\">");
				loc4 = "</font>";
				loc4 = loc4.concat(!!loc2.bold_?"</b>":"");
				loc5 = !!this.player?ObjectLibrary.typeToDisplayId_[this.player.objectType_]:"";
				loc1.pushParams(loc2.text_,{
					"unUsableClass":loc5,
					"usableClasses":this.getUsableClasses(),
					"keyCode":KeyCodes.CharCodeStrings[Parameters.data_.useSpecial]
				},loc3,loc4);
			}
			return loc1;
		}
		
		private function getUsableClasses() : StringBuilder {
			var loc3:String = null;
			var loc1:Vector.<String> = ObjectLibrary.usableBy(this.objectType);
			var loc2:AppendingLineBuilder = new AppendingLineBuilder();
			loc2.setDelimiter(", ");
			for each(loc3 in loc1) {
				loc2.pushParams(loc3);
			}
			return loc2;
		}
		
		private function addDescriptionText() : void {
			this.descText = new TextFieldDisplayConcrete().setSize(14).setColor(11776947).setTextWidth(MAX_WIDTH).setWordWrap(true);
			if(this.descriptionOverride) {
				this.descText.setStringBuilder(new StaticStringBuilder(this.descriptionOverride));
			} else {
				this.descText.setStringBuilder(new LineBuilder().setParams(String(this.objectXML.Description)));
			}
			this.descText.filters = FilterUtil.getStandardDropShadowFilter();
			waiter.push(this.descText.textChanged);
			addChild(this.descText);
		}
		
		override protected function alignUI() : void {
			this.titleText.x = this.icon.width + 4;
			this.titleText.y = this.icon.height / 2 - this.titleText.height / 2;
			if(this.tierText) {
				this.tierText.y = this.icon.height / 2 - this.tierText.height / 2;
				this.tierText.x = MAX_WIDTH - 30;
			}
			this.descText.x = 4;
			this.descText.y = this.icon.height + 2;
			if(contains(this.line1)) {
				this.line1.x = 8;
				this.line1.y = this.descText.y + this.descText.height + 8;
				this.effectsText.x = 4;
				this.effectsText.y = this.line1.y + 8;
			} else {
				this.line1.y = this.descText.y + this.descText.height;
				this.effectsText.y = this.line1.y;
			}
			if(this.setInfoText) {
				this.line3.x = 8;
				this.line3.y = this.effectsText.y + this.effectsText.height + 8;
				this.setInfoText.x = 4;
				this.setInfoText.y = this.line3.y + 8;
				this.line2.x = 8;
				this.line2.y = this.setInfoText.y + this.setInfoText.height + 8;
			} else {
				this.line2.x = 8;
				this.line2.y = this.effectsText.y + this.effectsText.height + 8;
			}
			var loc1:uint = this.line2.y + 8;
			if(this.restrictionsText) {
				this.restrictionsText.x = 4;
				this.restrictionsText.y = loc1;
				loc1 = loc1 + this.restrictionsText.height;
			}
			if(this.powerText) {
				if(contains(this.powerText)) {
					this.powerText.x = 4;
					this.powerText.y = loc1;
					loc1 = loc1 + this.powerText.height;
				}
			}
			if(this.supporterPointsText) {
				if(contains(this.supporterPointsText)) {
					this.supporterPointsText.x = 4;
					this.supporterPointsText.y = loc1;
				}
			}
		}
		
		private function buildCategorySpecificText() : void {
			if(this.curItemXML != null) {
				this.comparisonResults = this.slotTypeToTextBuilder.getComparisonResults(this.objectXML,this.curItemXML);
			} else {
				this.comparisonResults = new SlotComparisonResult();
			}
		}
		
		private function handleWisMod() : void {
			var loc3:XML = null;
			var loc4:XML = null;
			var loc5:String = null;
			var loc6:String = null;
			if(this.player == null) {
				return;
			}
			var loc1:Number = this.player.wisdom_;
			if(loc1 < 30) {
				return;
			}
			var loc2:Vector.<XML> = new Vector.<XML>();
			if(this.curItemXML != null) {
				this.curItemXML = this.curItemXML.copy();
				loc2.push(this.curItemXML);
			}
			if(this.objectXML != null) {
				this.objectXML = this.objectXML.copy();
				loc2.push(this.objectXML);
			}
			for each(loc4 in loc2) {
				for each(loc3 in loc4.Activate) {
					loc5 = loc3.toString();
					if(loc3.@effect == "Stasis") {
						continue;
					}
					loc6 = loc3.@useWisMod;
					if(loc6 == "" || loc6 == "false" || loc6 == "0" || loc3.@effect == "Stasis") {
						continue;
					}
					switch(loc5) {
						case ActivationType.HEAL_NOVA:
							loc3.@amount = this.modifyWisModStat(loc3.@amount,0);
							loc3.@range = this.modifyWisModStat(loc3.@range);
							loc3.@damage = this.modifyWisModStat(loc3.@damage,0);
							continue;
						case ActivationType.COND_EFFECT_AURA:
							loc3.@duration = this.modifyWisModStat(loc3.@duration);
							loc3.@range = this.modifyWisModStat(loc3.@range);
							continue;
						case ActivationType.COND_EFFECT_SELF:
							loc3.@duration = this.modifyWisModStat(loc3.@duration);
							continue;
						case ActivationType.STAT_BOOST_AURA:
							loc3.@amount = this.modifyWisModStat(loc3.@amount,0);
							loc3.@duration = this.modifyWisModStat(loc3.@duration);
							loc3.@range = this.modifyWisModStat(loc3.@range);
							continue;
						case ActivationType.GENERIC_ACTIVATE:
							loc3.@duration = this.modifyWisModStat(loc3.@duration);
							loc3.@range = this.modifyWisModStat(loc3.@range);
							continue;
						default:
							continue;
					}
				}
			}
		}
		
		private function modifyWisModStat(param1:String, param2:Number = 1) : String {
			var loc5:Number = NaN;
			var loc6:int = 0;
			var loc7:Number = NaN;
			var loc3:String = "-1";
			var loc4:Number = this.player.wisdom_;
			if(loc4 < 30) {
				loc3 = param1;
			} else {
				loc5 = Number(param1);
				loc6 = loc5 < 0?-1:1;
				loc7 = loc5 * loc4 / 150 + loc5 * loc6;
				loc7 = Math.floor(loc7 * Math.pow(10,param2)) / Math.pow(10,param2);
				if(loc7 - int(loc7) * loc6 >= 1 / Math.pow(10,param2) * loc6) {
					loc3 = loc7.toFixed(1);
				} else {
					loc3 = loc7.toFixed(0);
				}
			}
			return loc3;
		}
	}
}

class ComPair {
	 
	
	public var a:Number;
	
	public var b:Number;
	
	function ComPair(param1:XML, param2:XML, param3:String, param4:Number = 0) {
		super();
		this.a = this.b = !!param1.hasOwnProperty("@" + param3)?Number(param1[param3]):Number(param4);
		if(param2) {
			this.b = !!param2.hasOwnProperty("@" + param3)?Number(param2[param3]):Number(param4);
		}
	}
	
	public function add(param1:Number) : void {
		this.a = this.a + param1;
		this.b = this.b + param1;
	}
}

class ComPairTag {
	 
	
	public var a:Number;
	
	public var b:Number;
	
	function ComPairTag(param1:XML, param2:XML, param3:String, param4:Number = 0) {
		super();
		this.a = this.b = !!param1.hasOwnProperty(param3)?Number(param1[param3]):Number(param4);
		if(param2) {
			this.b = !!param2.hasOwnProperty(param3)?Number(param2[param3]):Number(param4);
		}
	}
	
	public function add(param1:Number) : void {
		this.a = this.a + param1;
		this.b = this.b + param1;
	}
}

class ComPairTagBool {
	 
	
	public var a:Boolean;
	
	public var b:Boolean;
	
	function ComPairTagBool(param1:XML, param2:XML, param3:String, param4:Boolean = false) {
		super();
		this.a = this.b = !!param1.hasOwnProperty(param3)?true:Boolean(param4);
		if(param2) {
			this.b = !!param2.hasOwnProperty(param3)?true:Boolean(param4);
		}
	}
}

import kabam.rotmg.text.view.stringBuilder.AppendingLineBuilder;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;

class Effect {
	 
	
	public var name_:String;
	
	public var valueReplacements_:Object;
	
	public var replacementColor_:uint = 16777103;
	
	public var color_:uint = 11776947;
	
	function Effect(param1:String, param2:Object) {
		super();
		this.name_ = param1;
		this.valueReplacements_ = param2;
	}
	
	public function setColor(param1:uint) : Effect {
		this.color_ = param1;
		return this;
	}
	
	public function setReplacementsColor(param1:uint) : Effect {
		this.replacementColor_ = param1;
		return this;
	}
	
	public function getValueReplacementsWithColor() : Object {
		var loc4:* = null;
		var loc5:LineBuilder = null;
		var loc1:Object = {};
		var loc2:* = "";
		var loc3:* = "";
		if(this.replacementColor_) {
			loc2 = "</font><font color=\"#" + this.replacementColor_.toString(16) + "\">";
			loc3 = "</font><font color=\"#" + this.color_.toString(16) + "\">";
		}
		for(loc4 in this.valueReplacements_) {
			if(this.valueReplacements_[loc4] is AppendingLineBuilder) {
				loc1[loc4] = this.valueReplacements_[loc4];
			} else if(this.valueReplacements_[loc4] is LineBuilder) {
				loc5 = this.valueReplacements_[loc4] as LineBuilder;
				loc5.setPrefix(loc2).setPostfix(loc3);
				loc1[loc4] = loc5;
			} else {
				loc1[loc4] = loc2 + this.valueReplacements_[loc4] + loc3;
			}
		}
		return loc1;
	}
}

class Restriction {
	 
	
	public var text_:String;
	
	public var color_:uint;
	
	public var bold_:Boolean;
	
	function Restriction(param1:String, param2:uint, param3:Boolean) {
		super();
		this.text_ = param1;
		this.color_ = param2;
		this.bold_ = param3;
	}
}
