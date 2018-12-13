 
package kabam.rotmg.messaging.impl.incoming {
	import com.company.assembleegameclient.util.FreeList;
	import flash.utils.IDataInput;
	import kabam.rotmg.messaging.impl.data.GroundTileData;
	import kabam.rotmg.messaging.impl.data.ObjectData;
	
	public class Update extends IncomingMessage {
		 
		
		public var tiles_:Vector.<GroundTileData>;
		
		public var newObjs_:Vector.<ObjectData>;
		
		public var drops_:Vector.<int>;
		
		public function Update(param1:uint, param2:Function) {
			this.tiles_ = new Vector.<GroundTileData>();
			this.newObjs_ = new Vector.<ObjectData>();
			this.drops_ = new Vector.<int>();
			super(param1,param2);
		}
		
		override public function parseFromInput(param1:IDataInput) : void {
			var loc2:int = 0;
			var loc3:int = param1.readShort();
			loc2 = loc3;
			while(loc2 < this.tiles_.length) {
				FreeList.deleteObject(this.tiles_[loc2]);
				loc2++;
			}
			this.tiles_.length = Math.min(loc3,this.tiles_.length);
			while(this.tiles_.length < loc3) {
				this.tiles_.push(FreeList.newObject(GroundTileData) as GroundTileData);
			}
			loc2 = 0;
			while(loc2 < loc3) {
				this.tiles_[loc2].parseFromInput(param1);
				loc2++;
			}
			this.newObjs_.length = 0;
			loc3 = param1.readShort();
			loc2 = loc3;
			while(loc2 < this.newObjs_.length) {
				FreeList.deleteObject(this.newObjs_[loc2]);
				loc2++;
			}
			this.newObjs_.length = Math.min(loc3,this.newObjs_.length);
			while(this.newObjs_.length < loc3) {
				this.newObjs_.push(FreeList.newObject(ObjectData) as ObjectData);
			}
			loc2 = 0;
			while(loc2 < loc3) {
				this.newObjs_[loc2].parseFromInput(param1);
				loc2++;
			}
			this.drops_.length = 0;
			var loc4:int = param1.readShort();
			loc2 = 0;
			while(loc2 < loc4) {
				this.drops_.push(param1.readInt());
				loc2++;
			}
		}
		
		override public function toString() : String {
			return formatToString("UPDATE","tiles_","newObjs_","drops_");
		}
	}
}
