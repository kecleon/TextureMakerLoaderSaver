 
package com.company.assembleegameclient.objects {
	import com.company.assembleegameclient.engine3d.ObjectFace3D;
	import com.company.assembleegameclient.parameters.Parameters;
	import flash.display.BitmapData;
	import flash.geom.Vector3D;
	import kabam.rotmg.stage3D.GraphicsFillExtra;
	
	public class CaveWall extends ConnectedObject {
		 
		
		public function CaveWall(param1:XML) {
			super(param1);
		}
		
		override protected function buildDot() : void {
			var loc6:ObjectFace3D = null;
			var loc1:Vector3D = new Vector3D(-0.25 - Math.random() * 0.25,-0.25 - Math.random() * 0.25,0);
			var loc2:Vector3D = new Vector3D(0.25 + Math.random() * 0.25,-0.25 - Math.random() * 0.25,0);
			var loc3:Vector3D = new Vector3D(0.25 + Math.random() * 0.25,0.25 + Math.random() * 0.25,0);
			var loc4:Vector3D = new Vector3D(-0.25 - Math.random() * 0.25,0.25 + Math.random() * 0.25,0);
			var loc5:Vector3D = new Vector3D(-0.25 + Math.random() * 0.5,-0.25 + Math.random() * 0.5,1);
			this.faceHelper(null,texture_,loc5,loc1,loc2);
			this.faceHelper(null,texture_,loc5,loc2,loc3);
			this.faceHelper(null,texture_,loc5,loc3,loc4);
			this.faceHelper(null,texture_,loc5,loc4,loc1);
			if(Parameters.isGpuRender()) {
				for each(loc6 in obj3D_.faces_) {
					GraphicsFillExtra.setSoftwareDraw(loc6.bitmapFill_,true);
				}
			}
		}
		
		override protected function buildShortLine() : void {
			var loc9:ObjectFace3D = null;
			var loc1:Vector3D = this.getVertex(0,0);
			var loc2:Vector3D = this.getVertex(0,3);
			var loc3:Vector3D = new Vector3D(0.25 + Math.random() * 0.25,0.25 + Math.random() * 0.25,0);
			var loc4:Vector3D = new Vector3D(-0.25 - Math.random() * 0.25,0.25 + Math.random() * 0.25,0);
			var loc5:Vector3D = this.getVertex(0,1);
			var loc6:Vector3D = this.getVertex(0,2);
			var loc7:Vector3D = new Vector3D(Math.random() * 0.25,Math.random() * 0.25,0.5);
			var loc8:Vector3D = new Vector3D(Math.random() * -0.25,Math.random() * 0.25,0.5);
			this.faceHelper(null,texture_,loc5,loc8,loc4,loc1);
			this.faceHelper(null,texture_,loc8,loc7,loc3,loc4);
			this.faceHelper(null,texture_,loc7,loc6,loc2,loc3);
			this.faceHelper(null,texture_,loc5,loc6,loc7,loc8);
			if(Parameters.isGpuRender()) {
				for each(loc9 in obj3D_.faces_) {
					GraphicsFillExtra.setSoftwareDraw(loc9.bitmapFill_,true);
				}
			}
		}
		
		override protected function buildL() : void {
			var loc11:ObjectFace3D = null;
			var loc1:Vector3D = this.getVertex(0,0);
			var loc2:Vector3D = this.getVertex(0,3);
			var loc3:Vector3D = this.getVertex(1,0);
			var loc4:Vector3D = this.getVertex(1,3);
			var loc5:Vector3D = new Vector3D(-Math.random() * 0.25,Math.random() * 0.25,0);
			var loc6:Vector3D = this.getVertex(0,1);
			var loc7:Vector3D = this.getVertex(0,2);
			var loc8:Vector3D = this.getVertex(1,1);
			var loc9:Vector3D = this.getVertex(1,2);
			var loc10:Vector3D = new Vector3D(Math.random() * 0.25,-Math.random() * 0.25,1);
			this.faceHelper(null,texture_,loc6,loc10,loc5,loc1);
			this.faceHelper(null,texture_,loc10,loc9,loc4,loc5);
			this.faceHelper(N2,texture_,loc8,loc7,loc2,loc3);
			this.faceHelper(null,texture_,loc6,loc7,loc8,loc9,loc10);
			if(Parameters.isGpuRender()) {
				for each(loc11 in obj3D_.faces_) {
					GraphicsFillExtra.setSoftwareDraw(loc11.bitmapFill_,true);
				}
			}
		}
		
		override protected function buildLine() : void {
			var loc9:ObjectFace3D = null;
			var loc1:Vector3D = this.getVertex(0,0);
			var loc2:Vector3D = this.getVertex(0,3);
			var loc3:Vector3D = this.getVertex(2,3);
			var loc4:Vector3D = this.getVertex(2,0);
			var loc5:Vector3D = this.getVertex(0,1);
			var loc6:Vector3D = this.getVertex(0,2);
			var loc7:Vector3D = this.getVertex(2,2);
			var loc8:Vector3D = this.getVertex(2,1);
			this.faceHelper(N7,texture_,loc5,loc8,loc4,loc1);
			this.faceHelper(N3,texture_,loc7,loc6,loc2,loc3);
			this.faceHelper(null,texture_,loc5,loc6,loc7,loc8);
			if(Parameters.isGpuRender()) {
				for each(loc9 in obj3D_.faces_) {
					GraphicsFillExtra.setSoftwareDraw(loc9.bitmapFill_,true);
				}
			}
		}
		
		override protected function buildT() : void {
			var loc13:ObjectFace3D = null;
			var loc1:Vector3D = this.getVertex(0,0);
			var loc2:Vector3D = this.getVertex(0,3);
			var loc3:Vector3D = this.getVertex(1,0);
			var loc4:Vector3D = this.getVertex(1,3);
			var loc5:Vector3D = this.getVertex(3,3);
			var loc6:Vector3D = this.getVertex(3,0);
			var loc7:Vector3D = this.getVertex(0,1);
			var loc8:Vector3D = this.getVertex(0,2);
			var loc9:Vector3D = this.getVertex(1,1);
			var loc10:Vector3D = this.getVertex(1,2);
			var loc11:Vector3D = this.getVertex(3,2);
			var loc12:Vector3D = this.getVertex(3,1);
			this.faceHelper(N2,texture_,loc9,loc8,loc2,loc3);
			this.faceHelper(null,texture_,loc11,loc10,loc4,loc5);
			this.faceHelper(N0,texture_,loc7,loc12,loc6,loc1);
			this.faceHelper(null,texture_,loc7,loc8,loc9,loc10,loc11,loc12);
			if(Parameters.isGpuRender()) {
				for each(loc13 in obj3D_.faces_) {
					GraphicsFillExtra.setSoftwareDraw(loc13.bitmapFill_,true);
				}
			}
		}
		
		override protected function buildCross() : void {
			var loc17:ObjectFace3D = null;
			var loc1:Vector3D = this.getVertex(0,0);
			var loc2:Vector3D = this.getVertex(0,3);
			var loc3:Vector3D = this.getVertex(1,0);
			var loc4:Vector3D = this.getVertex(1,3);
			var loc5:Vector3D = this.getVertex(2,3);
			var loc6:Vector3D = this.getVertex(2,0);
			var loc7:Vector3D = this.getVertex(3,3);
			var loc8:Vector3D = this.getVertex(3,0);
			var loc9:Vector3D = this.getVertex(0,1);
			var loc10:Vector3D = this.getVertex(0,2);
			var loc11:Vector3D = this.getVertex(1,1);
			var loc12:Vector3D = this.getVertex(1,2);
			var loc13:Vector3D = this.getVertex(2,2);
			var loc14:Vector3D = this.getVertex(2,1);
			var loc15:Vector3D = this.getVertex(3,2);
			var loc16:Vector3D = this.getVertex(3,1);
			this.faceHelper(N2,texture_,loc11,loc10,loc2,loc3);
			this.faceHelper(N4,texture_,loc13,loc12,loc4,loc5);
			this.faceHelper(N6,texture_,loc15,loc14,loc6,loc7);
			this.faceHelper(N0,texture_,loc9,loc16,loc8,loc1);
			this.faceHelper(null,texture_,loc9,loc10,loc11,loc12,loc13,loc14,loc15,loc16);
			if(Parameters.isGpuRender()) {
				for each(loc17 in obj3D_.faces_) {
					GraphicsFillExtra.setSoftwareDraw(loc17.bitmapFill_,true);
				}
			}
		}
		
		protected function getVertex(param1:int, param2:int) : Vector3D {
			var loc6:int = 0;
			var loc7:Number = NaN;
			var loc8:Number = NaN;
			var loc3:int = x_;
			var loc4:int = y_;
			var loc5:int = (param1 + rotation_) % 4;
			switch(loc5) {
				case 1:
					loc3++;
					break;
				case 2:
					loc4++;
			}
			switch(param2) {
				case 0:
				case 3:
					loc6 = 15 + (loc3 * 1259 ^ loc4 * 2957) % 35;
					break;
				case 1:
				case 2:
					loc6 = 3 + (loc3 * 2179 ^ loc4 * 1237) % 35;
			}
			switch(param2) {
				case 0:
					loc7 = -loc6 / 100;
					loc8 = 0;
					break;
				case 1:
					loc7 = -loc6 / 100;
					loc8 = 1;
					break;
				case 2:
					loc7 = loc6 / 100;
					loc8 = 1;
					break;
				case 3:
					loc7 = loc6 / 100;
					loc8 = 0;
			}
			switch(param1) {
				case 0:
					return new Vector3D(loc7,-0.5,loc8);
				case 1:
					return new Vector3D(0.5,loc7,loc8);
				case 2:
					return new Vector3D(loc7,0.5,loc8);
				case 3:
					return new Vector3D(-0.5,loc7,loc8);
				default:
					return null;
			}
		}
		
		protected function faceHelper(param1:Vector3D, param2:BitmapData, ... rest) : void {
			var loc5:Vector3D = null;
			var loc6:int = 0;
			var loc7:int = 0;
			var loc4:int = obj3D_.vL_.length / 3;
			for each(loc5 in rest) {
				obj3D_.vL_.push(loc5.x,loc5.y,loc5.z);
			}
			loc6 = obj3D_.faces_.length;
			if(rest.length == 4) {
				obj3D_.uvts_.push(0,0,0,1,0,0,1,1,0,0,1,0);
				if(Math.random() < 0.5) {
					obj3D_.faces_.push(new ObjectFace3D(obj3D_,new <int>[loc4,loc4 + 1,loc4 + 3]),new ObjectFace3D(obj3D_,new <int>[loc4 + 1,loc4 + 2,loc4 + 3]));
				} else {
					obj3D_.faces_.push(new ObjectFace3D(obj3D_,new <int>[loc4,loc4 + 2,loc4 + 3]),new ObjectFace3D(obj3D_,new <int>[loc4,loc4 + 1,loc4 + 2]));
				}
			} else if(rest.length == 3) {
				obj3D_.uvts_.push(0,0,0,0,1,0,1,1,0);
				obj3D_.faces_.push(new ObjectFace3D(obj3D_,new <int>[loc4,loc4 + 1,loc4 + 2]));
			} else if(rest.length == 5) {
				obj3D_.uvts_.push(0.2,0,0,0.8,0,0,1,0.2,0,1,0.8,0,0,0.8,0);
				obj3D_.faces_.push(new ObjectFace3D(obj3D_,new <int>[loc4,loc4 + 1,loc4 + 2,loc4 + 3,loc4 + 4]));
			} else if(rest.length == 6) {
				obj3D_.uvts_.push(0,0,0,0.2,0,0,1,0.2,0,1,0.8,0,0,0.8,0,0,0.2,0);
				obj3D_.faces_.push(new ObjectFace3D(obj3D_,new <int>[loc4,loc4 + 1,loc4 + 2,loc4 + 3,loc4 + 4,loc4 + 5]));
			} else if(rest.length == 8) {
				obj3D_.uvts_.push(0,0,0,0.2,0,0,1,0.2,0,1,0.8,0,0.8,1,0,0.2,1,0,0,0.8,0,0,0.2,0);
				obj3D_.faces_.push(new ObjectFace3D(obj3D_,new <int>[loc4,loc4 + 1,loc4 + 2,loc4 + 3,loc4 + 4,loc4 + 5,loc4 + 6,loc4 + 7]));
			}
			if(param1 != null || param2 != null) {
				loc7 = loc6;
				while(loc7 < obj3D_.faces_.length) {
					obj3D_.faces_[loc7].normalL_ = param1;
					obj3D_.faces_[loc7].texture_ = param2;
					loc7++;
				}
			}
		}
	}
}
