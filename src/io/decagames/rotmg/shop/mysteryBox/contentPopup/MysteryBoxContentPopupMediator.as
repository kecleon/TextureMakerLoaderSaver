 
package io.decagames.rotmg.shop.mysteryBox.contentPopup {
	import flash.utils.Dictionary;
	import io.decagames.rotmg.ui.buttons.BaseButton;
	import io.decagames.rotmg.ui.buttons.SliceScalingButton;
	import io.decagames.rotmg.ui.gird.UIGrid;
	import io.decagames.rotmg.ui.popups.header.PopupHeader;
	import io.decagames.rotmg.ui.popups.signals.ClosePopupSignal;
	import io.decagames.rotmg.ui.texture.TextureParser;
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	public class MysteryBoxContentPopupMediator extends Mediator {
		 
		
		[Inject]
		public var view:MysteryBoxContentPopup;
		
		[Inject]
		public var closePopupSignal:ClosePopupSignal;
		
		private var closeButton:SliceScalingButton;
		
		private var contentGrids:Vector.<UIGrid>;
		
		private var jackpotsNumber:int = 0;
		
		private var jackpotsHeight:int = 0;
		
		private var jackpotUI:JackpotContainer;
		
		public function MysteryBoxContentPopupMediator() {
			super();
		}
		
		override public function initialize() : void {
			this.closeButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI","close_button"));
			this.closeButton.clickSignal.addOnce(this.onClose);
			this.view.header.addButton(this.closeButton,PopupHeader.RIGHT_BUTTON);
			this.addJackpots(this.view.info.jackpots);
			this.addContentList(this.view.info.contents,this.view.info.jackpots);
		}
		
		private function addJackpots(param1:String) : void {
			var loc3:String = null;
			var loc4:Array = null;
			var loc5:Array = null;
			var loc6:Array = null;
			var loc7:String = null;
			var loc8:int = 0;
			var loc9:UIGrid = null;
			var loc10:UIItemContainer = null;
			var loc11:int = 0;
			var loc2:Array = param1.split("|");
			for each(loc3 in loc2) {
				loc4 = loc3.split(",");
				loc5 = [];
				loc6 = [];
				for each(loc7 in loc4) {
					loc8 = loc5.indexOf(loc7);
					if(loc8 == -1) {
						loc5.push(loc7);
						loc6.push(1);
					} else {
						loc6[loc8] = loc6[loc8] + 1;
					}
				}
				if(param1.length > 0) {
					loc9 = new UIGrid(220,5,4);
					loc9.centerLastRow = true;
					for each(loc7 in loc5) {
						loc10 = new UIItemContainer(int(loc7),4737096,0,40);
						loc10.showTooltip = true;
						loc9.addGridElement(loc10);
						loc11 = loc6[loc5.indexOf(loc7)];
						if(loc11 > 1) {
							loc10.showQuantityLabel(loc11);
						}
					}
					this.jackpotUI = new JackpotContainer();
					this.jackpotUI.x = 10;
					this.jackpotUI.y = 55 + this.jackpotsHeight - 22;
					if(this.jackpotsNumber == 0) {
						this.jackpotUI.diamondBackground();
					} else if(this.jackpotsNumber == 1) {
						this.jackpotUI.goldBackground();
					} else if(this.jackpotsNumber == 2) {
						this.jackpotUI.silverBackground();
					}
					this.jackpotUI.addGrid(loc9);
					this.view.addChild(this.jackpotUI);
					this.jackpotsHeight = this.jackpotsHeight + (this.jackpotUI.height + 5);
					this.jackpotsNumber++;
				}
			}
		}
		
		private function addContentList(param1:String, param2:String) : void {
			var loc7:String = null;
			var loc8:int = 0;
			var loc9:int = 0;
			var loc12:Array = null;
			var loc13:Array = null;
			var loc14:Array = null;
			var loc15:String = null;
			var loc16:Boolean = false;
			var loc17:String = null;
			var loc18:Array = null;
			var loc19:Dictionary = null;
			var loc20:String = null;
			var loc21:UIGrid = null;
			var loc22:Dictionary = null;
			var loc23:Vector.<ItemBox> = null;
			var loc24:* = null;
			var loc25:ItemsSetBox = null;
			var loc26:ItemBox = null;
			var loc3:Array = param1.split("|");
			var loc4:Array = param2.split("|");
			var loc5:Array = [];
			var loc6:int = 0;
			for each(loc7 in loc3) {
				loc13 = [];
				loc14 = loc7.split(";");
				for each(loc15 in loc14) {
					loc16 = false;
					for each(loc17 in loc4) {
						if(loc17 == loc15) {
							loc16 = true;
							break;
						}
					}
					if(!loc16) {
						loc18 = loc15.split(",");
						loc19 = new Dictionary();
						for each(loc20 in loc18) {
							if(loc19[loc20]) {
								loc19[loc20]++;
							} else {
								loc19[loc20] = 1;
							}
						}
						loc13.push(loc19);
					}
				}
				loc5[loc6] = loc13;
				loc6++;
			}
			loc8 = 486 - 11;
			loc9 = 30;
			if(this.jackpotsNumber > 0) {
				loc8 = loc8 - (this.jackpotsHeight + 10);
				loc9 = loc9 + (this.jackpotsHeight + 10);
			}
			this.contentGrids = new Vector.<UIGrid>(0);
			var loc10:int = 5;
			var loc11:Number = (260 - loc10 * (loc5.length - 1)) / loc5.length;
			for each(loc12 in loc5) {
				loc21 = new UIGrid(loc11,1,5);
				for each(loc22 in loc12) {
					loc23 = new Vector.<ItemBox>();
					for(loc24 in loc22) {
						loc26 = new ItemBox(loc24,loc22[loc24],loc5.length == 1,"",false);
						loc26.clearBackground();
						loc23.push(loc26);
					}
					loc25 = new ItemsSetBox(loc23);
					loc21.addGridElement(loc25);
				}
				loc21.y = loc9;
				loc21.x = 10 + loc11 * this.contentGrids.length + loc10 * this.contentGrids.length;
				this.view.addChild(loc21);
				this.contentGrids.push(loc21);
			}
		}
		
		override public function destroy() : void {
			var loc1:UIGrid = null;
			this.closeButton.dispose();
			for each(loc1 in this.contentGrids) {
				loc1.dispose();
			}
			this.contentGrids = null;
		}
		
		private function onClose(param1:BaseButton) : void {
			this.closePopupSignal.dispatch(this.view);
		}
	}
}
