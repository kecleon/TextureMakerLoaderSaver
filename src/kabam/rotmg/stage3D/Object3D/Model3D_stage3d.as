package kabam.rotmg.stage3D.Object3D {
	import flash.display3D.Context3D;
	import flash.display3D.VertexBuffer3D;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public class Model3D_stage3d {


		public var name:String;

		public var groups:Vector.<OBJGroup>;

		public var vertexBuffer:VertexBuffer3D;

		protected var _materials:Dictionary;

		protected var _tupleIndex:uint;

		protected var _tupleIndices:Dictionary;

		protected var _vertices:Vector.<Number>;

		public function Model3D_stage3d() {
			super();
			this.groups = new Vector.<OBJGroup>();
			this._materials = new Dictionary();
			this._vertices = new Vector.<Number>();
		}

		public function dispose():void {
			var loc1:OBJGroup = null;
			for each(loc1 in this.groups) {
				loc1.dispose();
			}
			this.groups.length = 0;
			if (this.vertexBuffer !== null) {
				this.vertexBuffer.dispose();
				this.vertexBuffer = null;
			}
			this._vertices.length = 0;
			this._tupleIndex = 0;
			this._tupleIndices = new Dictionary();
		}

		public function CreatBuffer(param1:Context3D):void {
			var loc2:OBJGroup = null;
			for each(loc2 in this.groups) {
				if (loc2._indices.length > 0) {
					loc2.indexBuffer = param1.createIndexBuffer(loc2._indices.length);
					loc2.indexBuffer.uploadFromVector(loc2._indices, 0, loc2._indices.length);
					loc2._faces = null;
				}
			}
			this.vertexBuffer = param1.createVertexBuffer(this._vertices.length / 8, 8);
			this.vertexBuffer.uploadFromVector(this._vertices, 0, this._vertices.length / 8);
		}

		public function readBytes(param1:ByteArray):void {
			var loc2:Vector.<String> = null;
			var loc3:OBJGroup = null;
			var loc10:String = null;
			var loc11:Array = null;
			var loc12:String = null;
			var loc13:int = 0;
			var loc14:int = 0;
			this.dispose();
			var loc4:String = "";
			var loc5:Vector.<Number> = new Vector.<Number>();
			var loc6:Vector.<Number> = new Vector.<Number>();
			var loc7:Vector.<Number> = new Vector.<Number>();
			param1.position = 0;
			var loc8:String = param1.readUTFBytes(param1.bytesAvailable);
			var loc9:Array = loc8.split(/[\r\n]+/);
			for each(loc10 in loc9) {
				loc10 = loc10.replace(/^\s*|\s*$/g, "");
				if (loc10 == "" || loc10.charAt(0) === "#") {
					continue;
				}
				loc11 = loc10.split(/\s+/);
				switch (loc11[0].toLowerCase()) {
					case "v":
						loc5.push(parseFloat(loc11[1]), parseFloat(loc11[2]), parseFloat(loc11[3]));
						continue;
					case "vn":
						loc6.push(parseFloat(loc11[1]), parseFloat(loc11[2]), parseFloat(loc11[3]));
						continue;
					case "vt":
						loc7.push(parseFloat(loc11[1]), 1 - parseFloat(loc11[2]));
						continue;
					case "f":
						loc2 = new Vector.<String>();
						for each(loc12 in loc11.slice(1)) {
							loc2.push(loc12);
						}
						if (loc3 === null) {
							loc3 = new OBJGroup(null, loc4);
							this.groups.push(loc3);
						}
						loc3._faces.push(loc2);
						continue;
					case "g":
						loc3 = new OBJGroup(loc11[1], loc4);
						this.groups.push(loc3);
						continue;
					case "o":
						this.name = loc11[1];
						continue;
					case "mtllib":
						continue;
					case "usemtl":
						loc4 = loc11[1];
						if (loc3 !== null) {
							loc3.materialName = loc4;
						}
						continue;
					default:
						continue;
				}
			}
			for each(loc3 in this.groups) {
				loc3._indices.length = 0;
				for each(loc2 in loc3._faces) {
					loc13 = loc2.length - 1;
					loc14 = 1;
					while (loc14 < loc13) {
						loc3._indices.push(this.mergeTuple(loc2[loc14], loc5, loc6, loc7));
						loc3._indices.push(this.mergeTuple(loc2[0], loc5, loc6, loc7));
						loc3._indices.push(this.mergeTuple(loc2[loc14 + 1], loc5, loc6, loc7));
						loc14++;
					}
				}
				loc3._faces = null;
			}
			this._tupleIndex = 0;
			this._tupleIndices = null;
		}

		protected function mergeTuple(param1:String, param2:Vector.<Number>, param3:Vector.<Number>, param4:Vector.<Number>):uint {
			var loc5:Array = null;
			var loc6:uint = 0;
			if (this._tupleIndices[param1] !== undefined) {
				return this._tupleIndices[param1];
			}
			loc5 = param1.split("/");
			loc6 = parseInt(loc5[0], 10) - 1;
			this._vertices.push(param2[loc6 * 3 + 0], param2[loc6 * 3 + 1], param2[loc6 * 3 + 2]);
			if (loc5.length > 2 && loc5[2].length > 0) {
				loc6 = parseInt(loc5[2], 10) - 1;
				this._vertices.push(param3[loc6 * 3 + 0], param3[loc6 * 3 + 1], param3[loc6 * 3 + 2]);
			} else {
				this._vertices.push(0, 0, 0);
			}
			if (loc5.length > 1 && loc5[1].length > 0) {
				loc6 = parseInt(loc5[1], 10) - 1;
				this._vertices.push(param4[loc6 * 2 + 0], param4[loc6 * 2 + 1]);
			} else {
				this._vertices.push(0, 0);
			}
			return this._tupleIndices[param1] = this._tupleIndex++;
		}
	}
}
