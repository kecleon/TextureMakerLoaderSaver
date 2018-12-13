 
package com.company.assembleegameclient.mapeditor {
	import com.company.assembleegameclient.account.ui.CheckBoxField;
	import com.company.assembleegameclient.account.ui.TextInputField;
	import com.company.assembleegameclient.editor.CommandEvent;
	import com.company.assembleegameclient.editor.CommandList;
	import com.company.assembleegameclient.editor.CommandQueue;
	import com.company.assembleegameclient.map.GroundLibrary;
	import com.company.assembleegameclient.map.RegionLibrary;
	import com.company.assembleegameclient.objects.ObjectLibrary;
	import com.company.assembleegameclient.screens.TitleMenuOption;
	import com.company.assembleegameclient.ui.DeprecatedClickableText;
	import com.company.assembleegameclient.ui.dropdown.DropDown;
	import com.company.util.IntPoint;
	import com.company.util.SpriteUtil;
	import com.hurlant.util.Base64;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.text.TextFieldAutoSize;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import kabam.lib.json.JsonParser;
	import kabam.rotmg.core.StaticInjectorContext;
	import kabam.rotmg.core.model.PlayerModel;
	import kabam.rotmg.ui.view.components.ScreenBase;
	import org.swiftsuspenders.Injector;
	
	public class EditingScreen extends Sprite {
		
		private static const MAP_Y:int = 600 - MEMap.SIZE - 10;
		 
		
		public var commandMenu_:MECommandMenu;
		
		private var commandQueue_:CommandQueue;
		
		public var meMap_:MEMap;
		
		public var infoPane_:InfoPane;
		
		public var chooserDropDown_:DropDown;
		
		public var mapSizeDropDown_:DropDown;
		
		public var choosers_:Dictionary;
		
		public var groundChooser_:GroundChooser;
		
		public var objChooser_:ObjectChooser;
		
		public var enemyChooser_:EnemyChooser;
		
		public var object3DChooser_:Object3DChooser;
		
		public var wallChooser_:WallChooser;
		
		public var allObjChooser_:AllObjectChooser;
		
		public var allGameObjChooser_:AllObjectChooser;
		
		public var regionChooser_:RegionChooser;
		
		public var dungeonChooser_:DungeonChooser;
		
		public var search:TextInputField;
		
		public var filter:Filter;
		
		public var returnButton_:TitleMenuOption;
		
		public var chooser_:Chooser;
		
		public var filename_:String = null;
		
		public var checkBoxArray:Array;
		
		private var json:JsonParser;
		
		private var pickObjHolder:Sprite;
		
		private var injector:Injector;
		
		private var isPlayerAdmin:Boolean;
		
		private var tilesBackup:Vector.<METile>;
		
		private var loadedFile_:FileReference = null;
		
		public function EditingScreen() {
			super();
			this.init();
		}
		
		private function init() : void {
			this.injector = StaticInjectorContext.getInjector();
			var loc1:PlayerModel = this.injector.getInstance(PlayerModel);
			this.isPlayerAdmin = loc1.isAdmin();
			addChild(new ScreenBase());
			this.json = this.injector.getInstance(JsonParser);
			this.createCommandMenu();
			this.createMEMap();
			this.createInfoPane();
			this.createChooserDropDown();
			this.createMapSizeDropDown();
			this.createCheckboxes();
			this.createFilter();
			this.createReturnButton();
			this.createChoosers();
		}
		
		private function createCommandMenu() : void {
			this.commandMenu_ = new MECommandMenu();
			this.commandMenu_.x = 15;
			this.commandMenu_.y = MAP_Y - 60;
			this.commandMenu_.addEventListener(CommandEvent.UNDO_COMMAND_EVENT,this.onUndo);
			this.commandMenu_.addEventListener(CommandEvent.REDO_COMMAND_EVENT,this.onRedo);
			this.commandMenu_.addEventListener(CommandEvent.CLEAR_COMMAND_EVENT,this.onClear);
			this.commandMenu_.addEventListener(CommandEvent.LOAD_COMMAND_EVENT,this.onLoad);
			this.commandMenu_.addEventListener(CommandEvent.SAVE_COMMAND_EVENT,this.onSave);
			this.commandMenu_.addEventListener(CommandEvent.SUBMIT_COMMAND_EVENT,this.onSubmit);
			this.commandMenu_.addEventListener(CommandEvent.TEST_COMMAND_EVENT,this.onTest);
			this.commandMenu_.addEventListener(CommandEvent.SELECT_COMMAND_EVENT,this.onMenuSelect);
			addChild(this.commandMenu_);
			this.commandQueue_ = new CommandQueue();
		}
		
		private function createMEMap() : void {
			this.meMap_ = new MEMap();
			this.meMap_.addEventListener(TilesEvent.TILES_EVENT,this.onTilesEvent);
			this.meMap_.x = 800 / 2 - MEMap.SIZE / 2;
			this.meMap_.y = MAP_Y;
			addChild(this.meMap_);
		}
		
		private function createInfoPane() : void {
			this.infoPane_ = new InfoPane(this.meMap_);
			this.infoPane_.x = 4;
			this.infoPane_.y = 600 - InfoPane.HEIGHT - 10;
			addChild(this.infoPane_);
		}
		
		private function createChooserDropDown() : void {
			var loc1:Vector.<String> = null;
			if(this.isPlayerAdmin) {
				this.chooserDropDown_ = new DropDown(GroupDivider.GROUP_LABELS,Chooser.WIDTH,26);
			} else {
				loc1 = GroupDivider.GROUP_LABELS.concat();
				loc1.splice(loc1.indexOf(AllObjectChooser.GROUP_NAME_GAME_OBJECTS),1);
				this.chooserDropDown_ = new DropDown(loc1,Chooser.WIDTH,26);
			}
			this.chooserDropDown_.x = this.meMap_.x + MEMap.SIZE + 4;
			this.chooserDropDown_.y = MAP_Y - this.chooserDropDown_.height - 4;
			this.chooserDropDown_.addEventListener(Event.CHANGE,this.onDropDownChange);
			addChild(this.chooserDropDown_);
		}
		
		private function createMapSizeDropDown() : void {
			var loc1:Vector.<String> = new Vector.<String>(0);
			var loc2:Number = MEMap.MAX_ALLOWED_SQUARES;
			while(loc2 >= 64) {
				loc1.push(loc2 + "x" + loc2);
				loc2 = loc2 / 2;
			}
			this.mapSizeDropDown_ = new DropDown(loc1,Chooser.WIDTH,26);
			this.mapSizeDropDown_.setValue(MEMap.NUM_SQUARES + "x" + MEMap.NUM_SQUARES);
			this.mapSizeDropDown_.x = this.chooserDropDown_.x - this.chooserDropDown_.width - 4;
			this.mapSizeDropDown_.y = this.chooserDropDown_.y;
			this.mapSizeDropDown_.addEventListener(Event.CHANGE,this.onDropDownSizeChange);
			addChild(this.mapSizeDropDown_);
		}
		
		private function createCheckboxes() : void {
			var loc1:DeprecatedClickableText = null;
			this.checkBoxArray = [];
			loc1 = new DeprecatedClickableText(14,true,"(Show All)");
			loc1.buttonMode = true;
			loc1.x = this.mapSizeDropDown_.x - 380;
			loc1.y = this.mapSizeDropDown_.y - 20;
			loc1.setAutoSize(TextFieldAutoSize.LEFT);
			loc1.addEventListener(MouseEvent.CLICK,this.onCheckBoxUpdated);
			addChild(loc1);
			var loc2:CheckBoxField = new CheckBoxField("Objects",true);
			loc2.x = loc1.x + 80;
			loc2.y = this.mapSizeDropDown_.y - 20;
			loc2.scaleX = loc2.scaleY = 0.8;
			loc2.addEventListener(MouseEvent.CLICK,this.onCheckBoxUpdated);
			addChild(loc2);
			var loc3:DeprecatedClickableText = new DeprecatedClickableText(14,true,"(Hide All)");
			loc3.buttonMode = true;
			loc3.x = this.mapSizeDropDown_.x - 380;
			loc3.y = this.mapSizeDropDown_.y + 8;
			loc3.setAutoSize(TextFieldAutoSize.LEFT);
			loc3.addEventListener(MouseEvent.CLICK,this.onCheckBoxUpdated);
			addChild(loc3);
			var loc4:CheckBoxField = new CheckBoxField("Regions",true);
			loc4.x = loc1.x + 80;
			loc4.y = this.mapSizeDropDown_.y + 8;
			loc4.scaleX = loc4.scaleY = 0.8;
			loc4.addEventListener(MouseEvent.CLICK,this.onCheckBoxUpdated);
			addChild(loc4);
			this.checkBoxArray.push(loc1);
			this.checkBoxArray.push(loc2);
			this.checkBoxArray.push(loc4);
			this.checkBoxArray.push(loc3);
		}
		
		private function createFilter() : void {
			this.filter = new Filter();
			this.filter.x = this.meMap_.x + MEMap.SIZE + 4;
			this.filter.y = MAP_Y;
			addChild(this.filter);
			this.filter.addEventListener(Event.CHANGE,this.onFilterChange);
			this.filter.enableDropDownFilter(true);
			this.filter.enableValueFilter(false);
		}
		
		private function createReturnButton() : void {
			this.returnButton_ = new TitleMenuOption("Screens.back",18,false);
			this.returnButton_.setAutoSize(TextFieldAutoSize.RIGHT);
			this.returnButton_.x = this.chooserDropDown_.x + this.chooserDropDown_.width - 7;
			this.returnButton_.y = 2;
			addChild(this.returnButton_);
		}
		
		private function createChoosers() : void {
			GroupDivider.divideObjects();
			this.choosers_ = new Dictionary(true);
			var loc1:int = MAP_Y + this.mapSizeDropDown_.height + 50;
			this.groundChooser_ = new GroundChooser();
			this.groundChooser_.x = this.chooserDropDown_.x;
			this.groundChooser_.y = loc1;
			this.choosers_[GroupDivider.GROUP_LABELS[0]] = this.groundChooser_;
			this.objChooser_ = new ObjectChooser();
			this.objChooser_.x = this.chooserDropDown_.x;
			this.objChooser_.y = loc1;
			this.choosers_[GroupDivider.GROUP_LABELS[1]] = this.objChooser_;
			this.enemyChooser_ = new EnemyChooser();
			this.enemyChooser_.x = this.chooserDropDown_.x;
			this.enemyChooser_.y = loc1;
			this.choosers_[GroupDivider.GROUP_LABELS[2]] = this.enemyChooser_;
			this.wallChooser_ = new WallChooser();
			this.wallChooser_.x = this.chooserDropDown_.x;
			this.wallChooser_.y = loc1;
			this.choosers_[GroupDivider.GROUP_LABELS[3]] = this.wallChooser_;
			this.object3DChooser_ = new Object3DChooser();
			this.object3DChooser_.x = this.chooserDropDown_.x;
			this.object3DChooser_.y = loc1;
			this.choosers_[GroupDivider.GROUP_LABELS[4]] = this.object3DChooser_;
			this.allObjChooser_ = new AllObjectChooser();
			this.allObjChooser_.x = this.chooserDropDown_.x;
			this.allObjChooser_.y = loc1;
			this.choosers_[GroupDivider.GROUP_LABELS[5]] = this.allObjChooser_;
			this.regionChooser_ = new RegionChooser();
			this.regionChooser_.x = this.chooserDropDown_.x;
			this.regionChooser_.y = loc1;
			this.choosers_[GroupDivider.GROUP_LABELS[6]] = this.regionChooser_;
			this.dungeonChooser_ = new DungeonChooser();
			this.dungeonChooser_.x = this.chooserDropDown_.x;
			this.dungeonChooser_.y = loc1;
			this.choosers_[GroupDivider.GROUP_LABELS[7]] = this.dungeonChooser_;
			if(this.isPlayerAdmin) {
				this.allGameObjChooser_ = new AllObjectChooser();
				this.allGameObjChooser_.x = this.chooserDropDown_.x;
				this.allGameObjChooser_.y = loc1;
				this.choosers_[GroupDivider.GROUP_LABELS[8]] = this.allGameObjChooser_;
			}
			this.chooser_ = this.groundChooser_;
			this.groundChooser_.reloadObjects("","");
			addChild(this.groundChooser_);
			this.chooserDropDown_.setIndex(0);
		}
		
		private function setSearch(param1:String) : void {
			this.filter.removeEventListener(Event.CHANGE,this.onFilterChange);
			this.filter.setSearch(param1);
			this.filter.addEventListener(Event.CHANGE,this.onFilterChange);
		}
		
		private function onFilterChange(param1:Event) : void {
			switch(this.chooser_) {
				case this.groundChooser_:
					this.groundChooser_.reloadObjects(this.filter.searchStr,this.filter.filterType);
					break;
				case this.objChooser_:
					this.objChooser_.reloadObjects(this.filter.searchStr);
					break;
				case this.enemyChooser_:
					this.enemyChooser_.reloadObjects(this.filter.searchStr,this.filter.filterType,this.filter.minValue,this.filter.maxValue);
					break;
				case this.wallChooser_:
					this.wallChooser_.reloadObjects(this.filter.searchStr);
					break;
				case this.object3DChooser_:
					this.object3DChooser_.reloadObjects(this.filter.searchStr);
					break;
				case this.allObjChooser_:
					this.allObjChooser_.reloadObjects(this.filter.searchStr);
					break;
				case this.allGameObjChooser_:
					this.allGameObjChooser_.reloadObjects(this.filter.searchStr,AllObjectChooser.GROUP_NAME_GAME_OBJECTS);
					break;
				case this.regionChooser_:
					break;
				case this.dungeonChooser_:
					this.dungeonChooser_.reloadObjects(this.filter.dungeon,this.filter.searchStr);
			}
		}
		
		private function onCheckBoxUpdated(param1:MouseEvent) : void {
			var loc2:CheckBoxField = null;
			switch(param1.currentTarget) {
				case this.checkBoxArray[0]:
					this.meMap_.ifShowGroundLayer = true;
					this.meMap_.ifShowObjectLayer = true;
					this.meMap_.ifShowRegionLayer = true;
					(this.checkBoxArray[Layer.OBJECT] as CheckBoxField).setChecked();
					(this.checkBoxArray[Layer.REGION] as CheckBoxField).setChecked();
					break;
				case this.checkBoxArray[Layer.OBJECT]:
					loc2 = param1.currentTarget as CheckBoxField;
					this.meMap_.ifShowObjectLayer = loc2.isChecked();
					break;
				case this.checkBoxArray[Layer.REGION]:
					loc2 = param1.currentTarget as CheckBoxField;
					this.meMap_.ifShowRegionLayer = loc2.isChecked();
					break;
				case this.checkBoxArray[3]:
					this.meMap_.ifShowGroundLayer = false;
					this.meMap_.ifShowObjectLayer = false;
					this.meMap_.ifShowRegionLayer = false;
					(this.checkBoxArray[Layer.OBJECT] as CheckBoxField).setUnchecked();
					(this.checkBoxArray[Layer.REGION] as CheckBoxField).setUnchecked();
			}
			this.meMap_.draw();
		}
		
		private function onTilesEvent(param1:TilesEvent) : void {
			var loc2:IntPoint = null;
			var loc3:METile = null;
			var loc4:int = 0;
			var loc5:String = null;
			var loc6:String = null;
			var loc7:EditTileProperties = null;
			var loc8:Vector.<METile> = null;
			var loc9:Bitmap = null;
			var loc10:uint = 0;
			loc2 = param1.tiles_[0];
			switch(this.commandMenu_.getCommand()) {
				case MECommandMenu.DRAW_COMMAND:
					this.addModifyCommandList(param1.tiles_,this.chooser_.layer_,this.chooser_.selectedType());
					break;
				case MECommandMenu.ERASE_COMMAND:
					this.addModifyCommandList(param1.tiles_,this.chooser_.layer_,-1);
					break;
				case MECommandMenu.SAMPLE_COMMAND:
					loc4 = this.meMap_.getType(loc2.x_,loc2.y_,this.chooser_.layer_);
					if(loc4 == -1) {
						return;
					}
					loc5 = GroupDivider.getCategoryByType(loc4,this.chooser_.layer_);
					if(loc5 == "") {
						break;
					}
					this.chooser_ = this.choosers_[loc5];
					this.chooserDropDown_.setValue(loc5);
					this.chooser_.setSelectedType(loc4);
					this.commandMenu_.setCommand(MECommandMenu.DRAW_COMMAND);
					break;
				case MECommandMenu.EDIT_COMMAND:
					loc6 = this.meMap_.getObjectName(loc2.x_,loc2.y_);
					loc7 = new EditTileProperties(param1.tiles_,loc6);
					loc7.addEventListener(Event.COMPLETE,this.onEditComplete);
					addChild(loc7);
					break;
				case MECommandMenu.CUT_COMMAND:
					this.tilesBackup = new Vector.<METile>();
					loc8 = new Vector.<METile>();
					for each(loc2 in param1.tiles_) {
						loc3 = this.meMap_.getTile(loc2.x_,loc2.y_);
						if(loc3 != null) {
							loc3 = loc3.clone();
						}
						this.tilesBackup.push(loc3);
						loc8.push(null);
					}
					this.addPasteCommandList(param1.tiles_,loc8);
					this.meMap_.freezeSelect();
					this.commandMenu_.setCommand(MECommandMenu.PASTE_COMMAND);
					break;
				case MECommandMenu.COPY_COMMAND:
					this.tilesBackup = new Vector.<METile>();
					for each(loc2 in param1.tiles_) {
						loc3 = this.meMap_.getTile(loc2.x_,loc2.y_);
						if(loc3 != null) {
							loc3 = loc3.clone();
						}
						this.tilesBackup.push(loc3);
					}
					this.meMap_.freezeSelect();
					this.commandMenu_.setCommand(MECommandMenu.PASTE_COMMAND);
					break;
				case MECommandMenu.PASTE_COMMAND:
					this.addPasteCommandList(param1.tiles_,this.tilesBackup);
					break;
				case MECommandMenu.PICK_UP_COMMAND:
					loc3 = this.meMap_.getTile(loc2.x_,loc2.y_);
					if(loc3 != null && loc3.types_[Layer.OBJECT] != -1) {
						loc9 = new Bitmap(ObjectLibrary.getTextureFromType(loc3.types_[Layer.OBJECT]));
						this.pickObjHolder = new Sprite();
						this.pickObjHolder.addChild(loc9);
						this.pickObjHolder.startDrag();
						this.pickObjHolder.name = String(loc3.types_[Layer.OBJECT]);
						this.addModifyCommandList(param1.tiles_,Layer.OBJECT,-1);
						this.commandMenu_.setCommand(MECommandMenu.DROP_COMMAND);
					}
					break;
				case MECommandMenu.DROP_COMMAND:
					if(this.pickObjHolder != null) {
						loc10 = int(this.pickObjHolder.name);
						this.addModifyCommandList(param1.tiles_,Layer.OBJECT,loc10);
						this.pickObjHolder.stopDrag();
						this.pickObjHolder.removeChildAt(0);
						this.pickObjHolder = null;
						this.commandMenu_.setCommand(MECommandMenu.PICK_UP_COMMAND);
					}
			}
			this.meMap_.draw();
		}
		
		private function onEditComplete(param1:Event) : void {
			var loc2:EditTileProperties = param1.currentTarget as EditTileProperties;
			this.addObjectNameCommandList(loc2.tiles_,loc2.getObjectName());
		}
		
		private function addModifyCommandList(param1:Vector.<IntPoint>, param2:int, param3:int) : void {
			var loc5:IntPoint = null;
			var loc6:int = 0;
			var loc4:CommandList = new CommandList();
			for each(loc5 in param1) {
				loc6 = this.meMap_.getType(loc5.x_,loc5.y_,param2);
				if(loc6 != param3) {
					loc4.addCommand(new MEModifyCommand(this.meMap_,loc5.x_,loc5.y_,param2,loc6,param3));
				}
			}
			if(loc4.empty()) {
				return;
			}
			this.commandQueue_.addCommandList(loc4);
		}
		
		private function addPasteCommandList(param1:Vector.<IntPoint>, param2:Vector.<METile>) : void {
			var loc5:IntPoint = null;
			var loc6:METile = null;
			var loc3:CommandList = new CommandList();
			var loc4:int = 0;
			for each(loc5 in param1) {
				if(loc4 >= param2.length) {
					break;
				}
				loc6 = this.meMap_.getTile(loc5.x_,loc5.y_);
				loc3.addCommand(new MEReplaceCommand(this.meMap_,loc5.x_,loc5.y_,loc6,param2[loc4]));
				loc4++;
			}
			if(loc3.empty()) {
				return;
			}
			this.commandQueue_.addCommandList(loc3);
		}
		
		private function addObjectNameCommandList(param1:Vector.<IntPoint>, param2:String) : void {
			var loc4:IntPoint = null;
			var loc5:String = null;
			var loc3:CommandList = new CommandList();
			for each(loc4 in param1) {
				loc5 = this.meMap_.getObjectName(loc4.x_,loc4.y_);
				if(loc5 != param2) {
					loc3.addCommand(new MEObjectNameCommand(this.meMap_,loc4.x_,loc4.y_,loc5,param2));
				}
			}
			if(loc3.empty()) {
				return;
			}
			this.commandQueue_.addCommandList(loc3);
		}
		
		private function safeRemoveCategoryChildren() : void {
			SpriteUtil.safeRemoveChild(this,this.groundChooser_);
			SpriteUtil.safeRemoveChild(this,this.objChooser_);
			SpriteUtil.safeRemoveChild(this,this.enemyChooser_);
			SpriteUtil.safeRemoveChild(this,this.regionChooser_);
			SpriteUtil.safeRemoveChild(this,this.wallChooser_);
			SpriteUtil.safeRemoveChild(this,this.object3DChooser_);
			SpriteUtil.safeRemoveChild(this,this.allObjChooser_);
			SpriteUtil.safeRemoveChild(this,this.allGameObjChooser_);
			SpriteUtil.safeRemoveChild(this,this.dungeonChooser_);
		}
		
		private function onDropDownChange(param1:Event = null) : void {
			switch(this.chooserDropDown_.getValue()) {
				case GroundLibrary.GROUND_CATEGORY:
					if(!this.groundChooser_.hasBeenLoaded) {
						this.groundChooser_.reloadObjects("","");
					}
					this.setSearch(this.groundChooser_.getLastSearch());
					this.safeRemoveCategoryChildren();
					SpriteUtil.safeAddChild(this,this.groundChooser_);
					this.chooser_ = this.groundChooser_;
					this.filter.setFilterType(ObjectLibrary.TILE_FILTER_LIST);
					this.filter.enableDropDownFilter(true);
					this.filter.enableValueFilter(false);
					this.filter.enableDungeonFilter(false);
					break;
				case "Basic Objects":
					if(!this.objChooser_.hasBeenLoaded) {
						this.objChooser_.reloadObjects("");
					}
					this.setSearch(this.objChooser_.getLastSearch());
					this.safeRemoveCategoryChildren();
					SpriteUtil.safeAddChild(this,this.objChooser_);
					this.chooser_ = this.objChooser_;
					this.filter.enableDropDownFilter(false);
					this.filter.enableValueFilter(false);
					this.filter.enableDungeonFilter(false);
					break;
				case "Enemies":
					if(!this.enemyChooser_.hasBeenLoaded) {
						this.enemyChooser_.reloadObjects("","",0,-1);
					}
					this.setSearch(this.enemyChooser_.getLastSearch());
					this.safeRemoveCategoryChildren();
					SpriteUtil.safeAddChild(this,this.enemyChooser_);
					this.chooser_ = this.enemyChooser_;
					this.filter.setFilterType(ObjectLibrary.ENEMY_FILTER_LIST);
					this.filter.enableDropDownFilter(true);
					this.filter.enableValueFilter(true);
					this.filter.enableDungeonFilter(false);
					break;
				case "Regions":
					this.setSearch("");
					this.safeRemoveCategoryChildren();
					SpriteUtil.safeAddChild(this,this.regionChooser_);
					this.chooser_ = this.regionChooser_;
					this.filter.enableDropDownFilter(false);
					this.filter.enableValueFilter(false);
					this.filter.enableDungeonFilter(false);
					break;
				case "Walls":
					if(!this.wallChooser_.hasBeenLoaded) {
						this.wallChooser_.reloadObjects("");
					}
					this.setSearch(this.wallChooser_.getLastSearch());
					this.safeRemoveCategoryChildren();
					SpriteUtil.safeAddChild(this,this.wallChooser_);
					this.chooser_ = this.wallChooser_;
					this.filter.enableDropDownFilter(false);
					this.filter.enableValueFilter(false);
					this.filter.enableDungeonFilter(false);
					break;
				case "3D Objects":
					if(!this.object3DChooser_.hasBeenLoaded) {
						this.object3DChooser_.reloadObjects("");
					}
					this.setSearch(this.object3DChooser_.getLastSearch());
					this.safeRemoveCategoryChildren();
					SpriteUtil.safeAddChild(this,this.object3DChooser_);
					this.chooser_ = this.object3DChooser_;
					this.filter.enableDropDownFilter(false);
					this.filter.enableValueFilter(false);
					this.filter.enableDungeonFilter(false);
					break;
				case "All Map Objects":
					if(!this.allObjChooser_.hasBeenLoaded) {
						this.allObjChooser_.reloadObjects("");
					}
					this.setSearch(this.allObjChooser_.getLastSearch());
					this.safeRemoveCategoryChildren();
					SpriteUtil.safeAddChild(this,this.allObjChooser_);
					this.chooser_ = this.allObjChooser_;
					this.filter.enableDropDownFilter(false);
					this.filter.enableValueFilter(false);
					break;
				case "All Game Objects":
					if(!this.allGameObjChooser_.hasBeenLoaded) {
						this.allGameObjChooser_.reloadObjects("",AllObjectChooser.GROUP_NAME_GAME_OBJECTS);
					}
					this.setSearch(this.allGameObjChooser_.getLastSearch());
					this.safeRemoveCategoryChildren();
					SpriteUtil.safeAddChild(this,this.allGameObjChooser_);
					this.chooser_ = this.allGameObjChooser_;
					this.filter.enableDropDownFilter(false);
					this.filter.enableValueFilter(false);
					break;
				case "Dungeons":
					if(!this.dungeonChooser_.hasBeenLoaded) {
						this.dungeonChooser_.reloadObjects(GroupDivider.DEFAULT_DUNGEON,"");
					}
					this.setSearch(this.dungeonChooser_.getLastSearch());
					this.safeRemoveCategoryChildren();
					SpriteUtil.safeAddChild(this,this.dungeonChooser_);
					this.chooser_ = this.dungeonChooser_;
					this.filter.enableDropDownFilter(false);
					this.filter.enableValueFilter(false);
					this.filter.enableDungeonFilter(true);
			}
		}
		
		private function onDropDownSizeChange(param1:Event) : void {
			var loc2:Number = NaN;
			switch(this.mapSizeDropDown_.getValue()) {
				case "64x64":
					loc2 = 64;
					break;
				case "128x128":
					loc2 = 128;
					break;
				case "256x256":
					loc2 = 256;
					break;
				case "512x512":
					loc2 = 512;
					break;
				case "1024x1024":
					loc2 = 1024;
			}
			this.meMap_.resize(loc2);
			this.meMap_.draw();
		}
		
		private function onUndo(param1:CommandEvent) : void {
			this.commandQueue_.undo();
			this.meMap_.draw();
		}
		
		private function onRedo(param1:CommandEvent) : void {
			this.commandQueue_.redo();
			this.meMap_.draw();
		}
		
		private function onClear(param1:CommandEvent) : void {
			var loc4:IntPoint = null;
			var loc5:METile = null;
			var loc2:Vector.<IntPoint> = this.meMap_.getAllTiles();
			var loc3:CommandList = new CommandList();
			for each(loc4 in loc2) {
				loc5 = this.meMap_.getTile(loc4.x_,loc4.y_);
				if(loc5 != null) {
					loc3.addCommand(new MEClearCommand(this.meMap_,loc4.x_,loc4.y_,loc5));
				}
			}
			if(loc3.empty()) {
				return;
			}
			this.commandQueue_.addCommandList(loc3);
			this.meMap_.draw();
			this.filename_ = null;
		}
		
		private function createMapJSON() : String {
			var loc7:int = 0;
			var loc8:METile = null;
			var loc9:Object = null;
			var loc10:String = null;
			var loc11:int = 0;
			var loc1:Rectangle = this.meMap_.getTileBounds();
			if(loc1 == null) {
				return null;
			}
			var loc2:Object = {};
			loc2["width"] = int(loc1.width);
			loc2["height"] = int(loc1.height);
			var loc3:Object = {};
			var loc4:Array = [];
			var loc5:ByteArray = new ByteArray();
			var loc6:int = loc1.y;
			while(loc6 < loc1.bottom) {
				loc7 = loc1.x;
				while(loc7 < loc1.right) {
					loc8 = this.meMap_.getTile(loc7,loc6);
					loc9 = this.getEntry(loc8);
					loc10 = this.json.stringify(loc9);
					if(!loc3.hasOwnProperty(loc10)) {
						loc11 = loc4.length;
						loc3[loc10] = loc11;
						loc4.push(loc9);
					} else {
						loc11 = loc3[loc10];
					}
					loc5.writeShort(loc11);
					loc7++;
				}
				loc6++;
			}
			loc2["dict"] = loc4;
			loc5.compress();
			loc2["data"] = Base64.encodeByteArray(loc5);
			return this.json.stringify(loc2);
		}
		
		private function onSave(param1:CommandEvent) : void {
			var loc2:String = this.createMapJSON();
			if(loc2 == null) {
				return;
			}
			new FileReference().save(loc2,this.filename_ == null?"map.jm":this.filename_);
		}
		
		private function onSubmit(param1:CommandEvent) : void {
			var loc2:String = this.createMapJSON();
			if(loc2 == null) {
				return;
			}
			this.meMap_.setMinZoom();
			this.meMap_.draw();
			dispatchEvent(new SubmitJMEvent(loc2,this.meMap_.getMapStatistics()));
		}
		
		private function getEntry(param1:METile) : Object {
			var loc3:Vector.<int> = null;
			var loc4:String = null;
			var loc5:Object = null;
			var loc2:Object = {};
			if(param1 != null) {
				loc3 = param1.types_;
				if(loc3[Layer.GROUND] != -1) {
					loc4 = GroundLibrary.getIdFromType(loc3[Layer.GROUND]);
					loc2["ground"] = loc4;
				}
				if(loc3[Layer.OBJECT] != -1) {
					loc4 = ObjectLibrary.getIdFromType(loc3[Layer.OBJECT]);
					loc5 = {"id":loc4};
					if(param1.objName_ != null) {
						loc5["name"] = param1.objName_;
					}
					loc2["objs"] = [loc5];
				}
				if(loc3[Layer.REGION] != -1) {
					loc4 = RegionLibrary.getIdFromType(loc3[Layer.REGION]);
					loc2["regions"] = [{"id":loc4}];
				}
			}
			return loc2;
		}
		
		private function onLoad(param1:CommandEvent) : void {
			this.loadedFile_ = new FileReference();
			this.loadedFile_.addEventListener(Event.SELECT,this.onFileBrowseSelect);
			this.loadedFile_.browse([new FileFilter("JSON Map (*.jm)","*.jm")]);
		}
		
		private function onFileBrowseSelect(param1:Event) : void {
			var event:Event = param1;
			var loadedFile:FileReference = event.target as FileReference;
			loadedFile.addEventListener(Event.COMPLETE,this.onFileLoadComplete);
			loadedFile.addEventListener(IOErrorEvent.IO_ERROR,this.onFileLoadIOError);
			try {
				loadedFile.load();
				return;
			}
			catch(e:Error) {
				return;
			}
		}
		
		private function onFileLoadComplete(param1:Event) : void {
			var loc7:String = null;
			var loc11:int = 0;
			var loc13:int = 0;
			var loc14:Object = null;
			var loc15:Array = null;
			var loc16:Array = null;
			var loc17:Object = null;
			var loc18:Object = null;
			var loc2:FileReference = param1.target as FileReference;
			this.filename_ = loc2.name;
			var loc3:Object = this.json.parse(loc2.data.toString());
			var loc4:int = loc3["width"];
			var loc5:int = loc3["height"];
			var loc6:Number = 64;
			while(loc6 < loc3["width"] || loc6 < loc3["height"]) {
				loc6 = loc6 * 2;
			}
			if(MEMap.NUM_SQUARES != loc6) {
				loc7 = loc6 + "x" + loc6;
				if(!this.mapSizeDropDown_.setValue(loc7)) {
					this.mapSizeDropDown_.setValue("512x512");
				}
			}
			var loc8:Rectangle = new Rectangle(int(MEMap.NUM_SQUARES / 2 - loc4 / 2),int(MEMap.NUM_SQUARES / 2 - loc5 / 2),loc4,loc5);
			this.meMap_.clear();
			this.commandQueue_.clear();
			var loc9:Array = loc3["dict"];
			var loc10:ByteArray = Base64.decodeToByteArray(loc3["data"]);
			loc10.uncompress();
			var loc12:int = loc8.y;
			while(loc12 < loc8.bottom) {
				loc13 = loc8.x;
				while(loc13 < loc8.right) {
					loc14 = loc9[loc10.readShort()];
					if(loc14.hasOwnProperty("ground")) {
						loc11 = GroundLibrary.idToType_[loc14["ground"]];
						this.meMap_.modifyTile(loc13,loc12,Layer.GROUND,loc11);
					}
					loc15 = loc14["objs"];
					if(loc15 != null) {
						for each(loc17 in loc15) {
							if(ObjectLibrary.idToType_.hasOwnProperty(loc17["id"])) {
								loc11 = ObjectLibrary.idToType_[loc17["id"]];
								this.meMap_.modifyTile(loc13,loc12,Layer.OBJECT,loc11);
								if(loc17.hasOwnProperty("name")) {
									this.meMap_.modifyObjectName(loc13,loc12,loc17["name"]);
								}
							}
						}
					}
					loc16 = loc14["regions"];
					if(loc16 != null) {
						for each(loc18 in loc16) {
							loc11 = RegionLibrary.idToType_[loc18["id"]];
							this.meMap_.modifyTile(loc13,loc12,Layer.REGION,loc11);
						}
					}
					loc13++;
				}
				loc12++;
			}
			this.meMap_.draw();
		}
		
		public function disableInput() : void {
			removeChild(this.commandMenu_);
		}
		
		public function enableInput() : void {
			addChild(this.commandMenu_);
		}
		
		private function onFileLoadIOError(param1:Event) : void {
		}
		
		private function onTest(param1:Event) : void {
			dispatchEvent(new MapTestEvent(this.createMapJSON()));
		}
		
		private function onMenuSelect(param1:Event) : void {
			if(this.meMap_ != null) {
				this.meMap_.clearSelect();
			}
		}
	}
}
