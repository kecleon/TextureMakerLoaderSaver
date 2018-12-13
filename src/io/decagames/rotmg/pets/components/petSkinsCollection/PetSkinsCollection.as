 
package io.decagames.rotmg.pets.components.petSkinsCollection {
	import flash.display.Sprite;
	import io.decagames.rotmg.pets.components.petSkinSlot.PetSkinSlot;
	import io.decagames.rotmg.pets.data.vo.SkinVO;
	import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
	import io.decagames.rotmg.ui.gird.UIGrid;
	import io.decagames.rotmg.ui.gird.UIGridElement;
	import io.decagames.rotmg.ui.labels.UILabel;
	import io.decagames.rotmg.ui.scroll.UIScrollbar;
	import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
	import io.decagames.rotmg.ui.texture.TextureParser;
	import io.decagames.rotmg.utils.colors.Tint;
	
	public class PetSkinsCollection extends Sprite {
		
		public static var COLLECTION_WIDTH:int = 360;
		
		public static const COLLECTION_HEIGHT:int = 425;
		 
		
		private var collectionContainer:Sprite;
		
		private var contentInset:SliceScalingBitmap;
		
		private var contentTitle:SliceScalingBitmap;
		
		private var title:UILabel;
		
		private var contentGrid:UIGrid;
		
		private var contentElement:UIGridElement;
		
		private var petGrid:UIGrid;
		
		public function PetSkinsCollection(param1:int, param2:int) {
			var loc3:SliceScalingBitmap = null;
			var loc4:UILabel = null;
			super();
			this.contentGrid = new UIGrid(COLLECTION_WIDTH - 40,1,15);
			this.contentInset = TextureParser.instance.getSliceScalingBitmap("UI","popup_content_inset",COLLECTION_WIDTH);
			addChild(this.contentInset);
			this.contentInset.height = COLLECTION_HEIGHT;
			this.contentInset.x = 0;
			this.contentInset.y = 0;
			this.contentTitle = TextureParser.instance.getSliceScalingBitmap("UI","content_title_decoration",COLLECTION_WIDTH);
			addChild(this.contentTitle);
			this.contentTitle.x = 0;
			this.contentTitle.y = 0;
			this.title = new UILabel();
			this.title.text = "Collection";
			DefaultLabelFormat.petNameLabel(this.title,16777215);
			this.title.width = COLLECTION_WIDTH;
			this.title.wordWrap = true;
			this.title.y = 4;
			this.title.x = 0;
			addChild(this.title);
			loc3 = TextureParser.instance.getSliceScalingBitmap("UI","content_divider_smalltitle_white",94);
			Tint.add(loc3,3355443,1);
			addChild(loc3);
			loc3.x = Math.round((COLLECTION_WIDTH - loc3.width) / 2);
			loc3.y = 23;
			loc4 = new UILabel();
			DefaultLabelFormat.wardrobeCollectionLabel(loc4);
			loc4.text = param1 + "/" + param2;
			loc4.width = loc3.width;
			loc4.wordWrap = true;
			loc4.y = loc3.y + 1;
			loc4.x = loc3.x;
			addChild(loc4);
			this.createScrollview();
		}
		
		private function createScrollview() : void {
			var loc1:Sprite = null;
			var loc2:UIScrollbar = null;
			var loc3:Sprite = null;
			loc1 = new Sprite();
			this.collectionContainer = new Sprite();
			this.collectionContainer.x = this.contentInset.x;
			this.collectionContainer.y = 2;
			this.collectionContainer.addChild(this.contentGrid);
			loc1.addChild(this.collectionContainer);
			loc2 = new UIScrollbar(COLLECTION_HEIGHT - 57);
			loc2.mouseRollSpeedFactor = 1;
			loc2.scrollObject = this;
			loc2.content = this.collectionContainer;
			loc1.addChild(loc2);
			loc2.x = this.contentInset.x + this.contentInset.width - 25;
			loc2.y = 7;
			loc3 = new Sprite();
			loc3.graphics.beginFill(0);
			loc3.graphics.drawRect(0,0,COLLECTION_WIDTH,380);
			loc3.x = this.collectionContainer.x;
			loc3.y = this.collectionContainer.y;
			this.collectionContainer.mask = loc3;
			loc1.addChild(loc3);
			addChild(loc1);
			loc1.y = 42;
		}
		
		private function sortByName(param1:SkinVO, param2:SkinVO) : int {
			if(param1.name > param2.name) {
				return 1;
			}
			return -1;
		}
		
		private function sortByRarity(param1:SkinVO, param2:SkinVO) : int {
			if(param1.rarity.ordinal == param2.rarity.ordinal) {
				return this.sortByName(param1,param2);
			}
			if(param1.rarity.ordinal > param2.rarity.ordinal) {
				return 1;
			}
			return -1;
		}
		
		public function addPetSkins(param1:String, param2:Vector.<SkinVO>) : void {
			var loc5:SkinVO = null;
			if(param2 == null) {
				return;
			}
			var loc3:int = 0;
			var loc4:int = 0;
			this.petGrid = new UIGrid(COLLECTION_WIDTH - 40,7,5);
			param2 = param2.sort(this.sortByRarity);
			for each(loc5 in param2) {
				this.petGrid.addGridElement(new PetSkinSlot(loc5,true));
				loc3++;
				if(loc5.isOwned) {
					loc4++;
				}
			}
			this.petGrid.x = 10;
			this.petGrid.y = 25;
			var loc6:PetFamilyContainer = new PetFamilyContainer(param1,loc4,loc3);
			loc6.addChild(this.petGrid);
			this.contentGrid.addGridElement(loc6);
		}
	}
}
