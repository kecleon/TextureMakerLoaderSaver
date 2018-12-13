 
package com.company.assembleegameclient.mapeditor {
	import com.adobe.images.PNGEncoder;
	import com.company.assembleegameclient.map.GroundLibrary;
	import com.company.assembleegameclient.map.RegionLibrary;
	import com.company.assembleegameclient.objects.ObjectLibrary;
	import com.company.util.AssetLibrary;
	import com.company.util.IntPoint;
	import com.company.util.KeyCodes;
	import com.company.util.PointUtil;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	class MEMap extends Sprite {
		
		private static var transbackgroundEmbed_:Class = MEMap_transbackgroundEmbed_;
		
		private static var transbackgroundBD_:BitmapData = new transbackgroundEmbed_().bitmapData;
		
		public static var NUM_SQUARES:int = 128;
		
		public static const MAX_ALLOWED_SQUARES:int = 512;
		
		public static const SQUARE_SIZE:int = 16;
		
		public static const SIZE:int = 512;
		 
		
		public var tileDict_:Dictionary;
		
		public var fullMap_:BigBitmapData;
		
		public var regionMap_:BitmapData;
		
		public var map_:BitmapData;
		
		public var overlay_:Shape;
		
		public var anchorLock:Boolean = false;
		
		public var posT_:IntPoint;
		
		public var zoom_:Number = 1;
		
		private var mouseRectAnchorT_:IntPoint = null;
		
		private var mouseMoveAnchorT_:IntPoint = null;
		
		private var rectWidthOverride:int = 0;
		
		private var rectHeightOverride:int = 0;
		
		private var invisibleTexture_:BitmapData;
		
		private var replaceTexture_:BitmapData;
		
		private var objectLayer_:BigBitmapData;
		
		private var groundLayer_:BigBitmapData;
		
		private var ifShowObjectLayer_:Boolean = true;
		
		private var ifShowGroundLayer_:Boolean = true;
		
		private var ifShowRegionLayer_:Boolean = true;
		
		function MEMap() {
			this.tileDict_ = new Dictionary();
			this.fullMap_ = new BigBitmapData(NUM_SQUARES * SQUARE_SIZE,NUM_SQUARES * SQUARE_SIZE,true,0);
			this.regionMap_ = new BitmapDataSpy(NUM_SQUARES,NUM_SQUARES,true,0);
			this.map_ = new BitmapDataSpy(SIZE,SIZE,true,0);
			this.overlay_ = new Shape();
			this.objectLayer_ = new BigBitmapData(NUM_SQUARES * SQUARE_SIZE,NUM_SQUARES * SQUARE_SIZE,true,0);
			this.groundLayer_ = new BigBitmapData(NUM_SQUARES * SQUARE_SIZE,NUM_SQUARES * SQUARE_SIZE,true,0);
			super();
			graphics.beginBitmapFill(transbackgroundBD_,null,true);
			graphics.drawRect(0,0,SIZE,SIZE);
			addChild(new Bitmap(this.map_));
			addChild(this.overlay_);
			this.posT_ = new IntPoint(NUM_SQUARES / 2 - this.sizeInTiles() / 2,NUM_SQUARES / 2 - this.sizeInTiles() / 2);
			this.invisibleTexture_ = AssetLibrary.getImageFromSet("invisible",0);
			this.replaceTexture_ = AssetLibrary.getImageFromSet("lofiObj3",255);
			this.draw();
			addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
		}
		
		private static function minZoom() : Number {
			return SQUARE_SIZE / NUM_SQUARES * 2;
		}
		
		private static function maxZoom() : Number {
			return SQUARE_SIZE;
		}
		
		public function set ifShowObjectLayer(param1:Boolean) : void {
			this.ifShowObjectLayer_ = param1;
		}
		
		public function set ifShowGroundLayer(param1:Boolean) : void {
			this.ifShowGroundLayer_ = param1;
		}
		
		public function set ifShowRegionLayer(param1:Boolean) : void {
			this.ifShowRegionLayer_ = param1;
		}
		
		public function resize(param1:Number) : void {
			var loc4:METile = null;
			var loc5:int = 0;
			var loc6:int = 0;
			var loc7:int = 0;
			var loc8:* = null;
			var loc2:Dictionary = this.tileDict_;
			var loc3:int = NUM_SQUARES;
			NUM_SQUARES = param1;
			this.setZoom(minZoom());
			this.tileDict_ = new Dictionary();
			this.fullMap_ = new BigBitmapData(NUM_SQUARES * SQUARE_SIZE,NUM_SQUARES * SQUARE_SIZE,true,0);
			this.objectLayer_ = new BigBitmapData(NUM_SQUARES * SQUARE_SIZE,NUM_SQUARES * SQUARE_SIZE,true,0);
			this.groundLayer_ = new BigBitmapData(NUM_SQUARES * SQUARE_SIZE,NUM_SQUARES * SQUARE_SIZE,true,0);
			this.regionMap_ = new BitmapDataSpy(NUM_SQUARES,NUM_SQUARES,true,0);
			for(loc8 in loc2) {
				loc4 = loc2[loc8];
				if(loc4.isEmpty()) {
					loc4 = null;
				} else {
					loc5 = int(loc8);
					loc6 = loc5 % loc3;
					loc7 = loc5 / loc3;
					if(loc6 < NUM_SQUARES && loc7 < NUM_SQUARES) {
						this.setTile(loc6,loc7,loc4);
					}
				}
			}
			loc2 = null;
		}
		
		public function getType(param1:int, param2:int, param3:int) : int {
			var loc4:METile = this.getTile(param1,param2);
			if(loc4 == null) {
				return -1;
			}
			return loc4.types_[param3];
		}
		
		public function getTile(param1:int, param2:int) : METile {
			return this.tileDict_[param1 + param2 * NUM_SQUARES];
		}
		
		public function modifyTile(param1:int, param2:int, param3:int, param4:int) : void {
			var x:int = param1;
			var y:int = param2;
			var layer:int = param3;
			var type:int = param4;
			var tile:METile = this.getOrCreateTile(x,y);
			if(tile.types_[layer] == type) {
				return;
			}
			tile.types_[layer] = type;
			try {
				this.drawTile(x,y,tile);
				return;
			}
			catch(error:Error) {
				throw new Error("Invalid type: 0x" + type.toString(16) + " at location: " + x + " x, " + y + " y");
			}
		}
		
		public function getObjectName(param1:int, param2:int) : String {
			var loc3:METile = this.getTile(param1,param2);
			if(loc3 == null) {
				return null;
			}
			return loc3.objName_;
		}
		
		public function modifyObjectName(param1:int, param2:int, param3:String) : void {
			var loc4:METile = this.getOrCreateTile(param1,param2);
			loc4.objName_ = param3;
		}
		
		public function getAllTiles() : Vector.<IntPoint> {
			var loc2:* = null;
			var loc3:int = 0;
			var loc1:Vector.<IntPoint> = new Vector.<IntPoint>();
			for(loc2 in this.tileDict_) {
				loc3 = int(loc2);
				loc1.push(new IntPoint(loc3 % NUM_SQUARES,loc3 / NUM_SQUARES));
			}
			return loc1;
		}
		
		public function setTile(param1:int, param2:int, param3:METile) : void {
			param3 = param3.clone();
			this.tileDict_[param1 + param2 * NUM_SQUARES] = param3;
			this.drawTile(param1,param2,param3);
			param3 = null;
		}
		
		public function eraseTile(param1:int, param2:int) : void {
			this.clearTile(param1,param2);
			this.drawTile(param1,param2,null);
		}
		
		public function toggleLayers(param1:Array) : void {
		}
		
		public function clear() : void {
			var loc1:* = null;
			var loc2:int = 0;
			for(loc1 in this.tileDict_) {
				loc2 = int(loc1);
				this.eraseTile(loc2 % NUM_SQUARES,loc2 / NUM_SQUARES);
			}
		}
		
		public function getTileBounds() : Rectangle {
			var loc5:* = null;
			var loc6:METile = null;
			var loc7:int = 0;
			var loc8:int = 0;
			var loc9:int = 0;
			var loc1:int = NUM_SQUARES;
			var loc2:int = NUM_SQUARES;
			var loc3:int = 0;
			var loc4:int = 0;
			for(loc5 in this.tileDict_) {
				loc6 = this.tileDict_[loc5];
				if(!loc6.isEmpty()) {
					loc7 = int(loc5);
					loc8 = loc7 % NUM_SQUARES;
					loc9 = loc7 / NUM_SQUARES;
					if(loc8 < loc1) {
						loc1 = loc8;
					}
					if(loc9 < loc2) {
						loc2 = loc9;
					}
					if(loc8 + 1 > loc3) {
						loc3 = loc8 + 1;
					}
					if(loc9 + 1 > loc4) {
						loc4 = loc9 + 1;
					}
				}
			}
			if(loc1 > loc3) {
				return null;
			}
			return new Rectangle(loc1,loc2,loc3 - loc1,loc4 - loc2);
		}
		
		private function sizeInTiles() : int {
			return SIZE / (SQUARE_SIZE * this.zoom_);
		}
		
		private function modifyZoom(param1:Number) : void {
			if(param1 > 1 && this.zoom_ >= maxZoom() || param1 < 1 && this.zoom_ <= minZoom()) {
				return;
			}
			var loc2:IntPoint = this.mousePosT();
			this.zoom_ = this.zoom_ * param1;
			var loc3:IntPoint = this.mousePosT();
			this.movePosT(loc2.x_ - loc3.x_,loc2.y_ - loc3.y_);
		}
		
		private function setZoom(param1:Number) : void {
			if(param1 > maxZoom() || param1 < minZoom()) {
				return;
			}
			var loc2:IntPoint = this.mousePosT();
			this.zoom_ = param1;
			var loc3:IntPoint = this.mousePosT();
			this.movePosT(loc2.x_ - loc3.x_,loc2.y_ - loc3.y_);
		}
		
		public function setMinZoom(param1:Number = 0) : void {
			if(param1 != 0) {
				this.setZoom(param1);
			} else {
				this.setZoom(minZoom());
			}
		}
		
		private function canMove() : Boolean {
			return this.mouseRectAnchorT_ == null && this.mouseMoveAnchorT_ == null;
		}
		
		private function increaseZoom() : void {
			if(!this.canMove()) {
				return;
			}
			this.modifyZoom(2);
			this.draw();
		}
		
		private function decreaseZoom() : void {
			if(!this.canMove()) {
				return;
			}
			this.modifyZoom(0.5);
			this.draw();
		}
		
		private function moveLeft() : void {
			if(!this.canMove()) {
				return;
			}
			this.movePosT(-1,0);
			this.draw();
		}
		
		private function moveRight() : void {
			if(!this.canMove()) {
				return;
			}
			this.movePosT(1,0);
			this.draw();
		}
		
		private function moveUp() : void {
			if(!this.canMove()) {
				return;
			}
			this.movePosT(0,-1);
			this.draw();
		}
		
		private function moveDown() : void {
			if(!this.canMove()) {
				return;
			}
			this.movePosT(0,1);
			this.draw();
		}
		
		private function movePosT(param1:int, param2:int) : void {
			var loc3:int = 0;
			var loc4:int = NUM_SQUARES - this.sizeInTiles();
			this.posT_.x_ = Math.max(loc3,Math.min(loc4,this.posT_.x_ + param1));
			this.posT_.y_ = Math.max(loc3,Math.min(loc4,this.posT_.y_ + param2));
		}
		
		private function mousePosT() : IntPoint {
			var loc1:int = Math.max(0,Math.min(SIZE - 1,mouseX));
			var loc2:int = Math.max(0,Math.min(SIZE - 1,mouseY));
			return new IntPoint(this.posT_.x_ + loc1 / (SQUARE_SIZE * this.zoom_),this.posT_.y_ + loc2 / (SQUARE_SIZE * this.zoom_));
		}
		
		public function mouseRectT() : Rectangle {
			var loc1:IntPoint = this.mousePosT();
			if(this.mouseRectAnchorT_ == null) {
				return new Rectangle(loc1.x_,loc1.y_,1,1);
			}
			return new Rectangle(Math.min(loc1.x_,this.mouseRectAnchorT_.x_),Math.min(loc1.y_,this.mouseRectAnchorT_.y_),Math.abs(loc1.x_ - this.mouseRectAnchorT_.x_) + 1,Math.abs(loc1.y_ - this.mouseRectAnchorT_.y_) + 1);
		}
		
		private function posTToPosP(param1:IntPoint) : IntPoint {
			return new IntPoint((param1.x_ - this.posT_.x_) * SQUARE_SIZE * this.zoom_,(param1.y_ - this.posT_.y_) * SQUARE_SIZE * this.zoom_);
		}
		
		private function sizeTToSizeP(param1:int) : Number {
			return param1 * this.zoom_ * SQUARE_SIZE;
		}
		
		private function mouseRectP() : Rectangle {
			var loc1:Rectangle = this.mouseRectT();
			var loc2:IntPoint = this.posTToPosP(new IntPoint(loc1.x,loc1.y));
			loc1.x = loc2.x_;
			loc1.y = loc2.y_;
			loc1.width = this.sizeTToSizeP(loc1.width) - 1;
			loc1.height = this.sizeTToSizeP(loc1.height) - 1;
			return loc1;
		}
		
		private function onAddedToStage(param1:Event) : void {
			addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
			addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
			addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
			addEventListener(MouseEvent.RIGHT_CLICK,this.onMouseRightClick);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
		}
		
		private function onRemovedFromStage(param1:Event) : void {
			removeEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
			removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
			removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
			stage.removeEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
		}
		
		private function onKeyDown(param1:KeyboardEvent) : void {
			switch(param1.keyCode) {
				case Keyboard.SHIFT:
					if(this.mouseRectAnchorT_ != null) {
						break;
					}
					this.mouseRectAnchorT_ = this.mousePosT();
					this.draw();
					break;
				case Keyboard.CONTROL:
					if(this.mouseMoveAnchorT_ != null) {
						break;
					}
					this.mouseMoveAnchorT_ = this.mousePosT();
					this.draw();
					break;
				case Keyboard.LEFT:
					this.moveLeft();
					break;
				case Keyboard.RIGHT:
					this.moveRight();
					break;
				case Keyboard.UP:
					this.moveUp();
					break;
				case Keyboard.DOWN:
					this.moveDown();
					break;
				case KeyCodes.MINUS:
					this.decreaseZoom();
					break;
				case KeyCodes.EQUAL:
					this.increaseZoom();
			}
		}
		
		private function onKeyUp(param1:KeyboardEvent) : void {
			switch(param1.keyCode) {
				case Keyboard.SHIFT:
					this.mouseRectAnchorT_ = null;
					this.draw();
					break;
				case Keyboard.CONTROL:
					this.mouseMoveAnchorT_ = null;
					this.draw();
			}
		}
		
		public function clearSelectRect() : void {
			this.mouseRectAnchorT_ = null;
			this.anchorLock = false;
		}
		
		private function onMouseRightClick(param1:MouseEvent) : void {
		}
		
		private function onMouseWheel(param1:MouseEvent) : void {
			if(param1.delta > 0) {
				this.increaseZoom();
			} else if(param1.delta < 0) {
				this.decreaseZoom();
			}
		}
		
		private function onMouseDown(param1:MouseEvent) : void {
			var loc7:int = 0;
			var loc2:Rectangle = this.mouseRectT();
			var loc3:Vector.<IntPoint> = new Vector.<IntPoint>();
			var loc4:int = Math.max(loc2.x + this.rectWidthOverride,loc2.right);
			var loc5:int = Math.max(loc2.y + this.rectHeightOverride,loc2.bottom);
			var loc6:int = loc2.x;
			while(loc6 < loc4) {
				loc7 = loc2.y;
				while(loc7 < loc5) {
					loc3.push(new IntPoint(loc6,loc7));
					loc7++;
				}
				loc6++;
			}
			dispatchEvent(new TilesEvent(loc3));
		}
		
		public function freezeSelect() : void {
			var loc1:Rectangle = this.mouseRectT();
			this.rectWidthOverride = loc1.width;
			this.rectHeightOverride = loc1.height;
		}
		
		public function clearSelect() : void {
			this.rectHeightOverride = 0;
			this.rectWidthOverride = 0;
		}
		
		private function onMouseMove(param1:MouseEvent) : void {
			var loc2:IntPoint = null;
			if(!param1.shiftKey) {
				this.mouseRectAnchorT_ = null;
			} else if(this.mouseRectAnchorT_ == null) {
				this.mouseRectAnchorT_ = this.mousePosT();
			}
			if(!param1.ctrlKey) {
				this.mouseMoveAnchorT_ = null;
			} else if(this.mouseMoveAnchorT_ == null) {
				this.mouseMoveAnchorT_ = this.mousePosT();
			}
			if(param1.buttonDown) {
				dispatchEvent(new TilesEvent(new <IntPoint>[this.mousePosT()]));
			}
			if(this.mouseMoveAnchorT_ != null) {
				loc2 = this.mousePosT();
				this.movePosT(this.mouseMoveAnchorT_.x_ - loc2.x_,this.mouseMoveAnchorT_.y_ - loc2.y_);
				this.draw();
			} else {
				this.drawOverlay();
			}
		}
		
		private function getOrCreateTile(param1:int, param2:int) : METile {
			var loc3:int = param1 + param2 * NUM_SQUARES;
			var loc4:METile = this.tileDict_[loc3];
			if(loc4 != null) {
				return loc4;
			}
			loc4 = new METile();
			this.tileDict_[loc3] = loc4;
			return loc4;
		}
		
		private function clearTile(param1:int, param2:int) : void {
			delete this.tileDict_[param1 + param2 * NUM_SQUARES];
		}
		
		private function drawTile(param1:int, param2:int, param3:METile) : void {
			var loc5:BitmapData = null;
			var loc6:BitmapData = null;
			var loc7:uint = 0;
			var loc4:Rectangle = new Rectangle(param1 * SQUARE_SIZE,param2 * SQUARE_SIZE,SQUARE_SIZE,SQUARE_SIZE);
			this.fullMap_.erase(loc4);
			this.groundLayer_.erase(loc4);
			this.objectLayer_.erase(loc4);
			this.regionMap_.setPixel32(param1,param2,0);
			if(param3 == null) {
				this.groundLayer_.erase(loc4);
				this.objectLayer_.erase(loc4);
				return;
			}
			if(param3.types_[Layer.GROUND] != -1) {
				loc5 = GroundLibrary.getBitmapData(param3.types_[Layer.GROUND]);
				this.groundLayer_.copyTo(loc5,loc5.rect,loc4);
			}
			if(param3.types_[Layer.OBJECT] != -1) {
				loc6 = ObjectLibrary.getTextureFromType(param3.types_[Layer.OBJECT]);
				if(loc6 == null || loc6 == this.invisibleTexture_) {
					this.objectLayer_.copyTo(loc5,loc5.rect,loc4);
				} else {
					this.objectLayer_.copyTo(loc6,loc6.rect,loc4);
				}
			}
			if(param3.types_[Layer.REGION] != -1) {
				loc7 = RegionLibrary.getColor(param3.types_[Layer.REGION]);
				this.regionMap_.setPixel32(param1,param2,1593835520 | loc7);
			}
		}
		
		private function drawOverlay() : void {
			var loc1:Rectangle = this.mouseRectP();
			var loc2:Graphics = this.overlay_.graphics;
			loc2.clear();
			loc2.lineStyle(1,16777215);
			loc2.beginFill(16777215,0.1);
			loc2.drawRect(loc1.x,loc1.y,loc1.width,loc1.height);
			loc2.endFill();
			loc2.lineStyle();
		}
		
		public function draw() : void {
			var loc2:Matrix = null;
			var loc3:int = 0;
			var loc4:BitmapData = null;
			var loc1:int = SIZE / this.zoom_;
			this.map_.fillRect(this.map_.rect,0);
			if(this.ifShowGroundLayer_) {
				this.groundLayer_.copyFrom(new Rectangle(this.posT_.x_ * SQUARE_SIZE,this.posT_.y_ * SQUARE_SIZE,loc1,loc1),this.map_,this.map_.rect);
			}
			if(this.ifShowObjectLayer_) {
				this.objectLayer_.copyFrom(new Rectangle(this.posT_.x_ * SQUARE_SIZE,this.posT_.y_ * SQUARE_SIZE,loc1,loc1),this.map_,this.map_.rect);
			}
			if(this.ifShowRegionLayer_) {
				loc2 = new Matrix();
				loc2.identity();
				loc3 = SQUARE_SIZE * this.zoom_;
				if(this.zoom_ > 2) {
					loc4 = new BitmapDataSpy(SIZE / loc3,SIZE / loc3);
					loc4.copyPixels(this.regionMap_,new Rectangle(this.posT_.x_,this.posT_.y_,loc1,loc1),PointUtil.ORIGIN);
					loc2.scale(loc3,loc3);
					this.map_.draw(loc4,loc2);
				} else {
					loc2.translate(-this.posT_.x_,-this.posT_.y_);
					loc2.scale(loc3,loc3);
					this.map_.draw(this.regionMap_,loc2,null,null,this.map_.rect);
				}
			}
			this.drawOverlay();
		}
		
		private function generateThumbnail() : ByteArray {
			var loc1:Rectangle = this.getTileBounds();
			var loc2:int = 8;
			var loc3:BitmapData = new BitmapData(loc1.width * loc2,loc1.height * loc2);
			this.groundLayer_.copyFrom(new Rectangle(loc1.x * SQUARE_SIZE,loc1.y * SQUARE_SIZE,loc1.width * SQUARE_SIZE,loc1.height * SQUARE_SIZE),loc3,loc3.rect);
			this.objectLayer_.copyFrom(new Rectangle(loc1.x * SQUARE_SIZE,loc1.y * SQUARE_SIZE,loc1.width * SQUARE_SIZE,loc1.height * SQUARE_SIZE),loc3,loc3.rect);
			var loc4:Matrix = new Matrix();
			loc4.identity();
			loc4.translate(-loc1.x,-loc1.y);
			loc4.scale(loc2,loc2);
			loc3.draw(this.regionMap_,loc4);
			return PNGEncoder.encode(loc3);
		}
		
		public function getMapStatistics() : Object {
			var loc6:METile = null;
			var loc1:int = 0;
			var loc2:int = 0;
			var loc3:int = 0;
			var loc4:int = 0;
			var loc5:int = 0;
			for each(loc6 in this.tileDict_) {
				loc5++;
				if(loc6.types_[Layer.GROUND] != -1) {
					loc1++;
				}
				if(loc6.types_[Layer.OBJECT] != -1) {
					loc2++;
				}
				if(loc6.types_[Layer.REGION] != -1) {
					if(loc6.types_[Layer.REGION] == RegionLibrary.EXIT_REGION_TYPE) {
						loc3++;
					}
					if(loc6.types_[Layer.REGION] == RegionLibrary.ENTRY_REGION_TYPE) {
						loc4++;
					}
				}
			}
			return {
				"numObjects":loc2,
				"numGrounds":loc1,
				"numExits":loc3,
				"numEntries":loc4,
				"numTiles":loc5,
				"thumbnail":this.generateThumbnail()
			};
		}
	}
}
