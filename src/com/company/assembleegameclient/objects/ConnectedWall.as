 
package com.company.assembleegameclient.objects {
	import com.company.assembleegameclient.engine3d.ObjectFace3D;
	import com.company.assembleegameclient.parameters.Parameters;
	import com.company.util.AssetLibrary;
	import flash.display.BitmapData;
	import flash.geom.Vector3D;
	import kabam.rotmg.stage3D.GraphicsFillExtra;
	
	public class ConnectedWall extends ConnectedObject {
		 
		
		protected var objectXML_:XML;
		
		protected var bI_:Number = 0.5;
		
		protected var tI_:Number = 0.25;
		
		protected var h_:Number = 1.0;
		
		protected var wallRepeat_:Boolean;
		
		protected var topRepeat_:Boolean;
		
		public function ConnectedWall(param1:XML) {
			super(param1);
			this.objectXML_ = param1;
			if(param1.hasOwnProperty("BaseIndent")) {
				this.bI_ = 0.5 - Number(param1.BaseIndent);
			}
			if(param1.hasOwnProperty("TopIndent")) {
				this.tI_ = 0.5 - Number(param1.TopIndent);
			}
			if(param1.hasOwnProperty("Height")) {
				this.h_ = Number(param1.Height);
			}
			this.wallRepeat_ = !param1.hasOwnProperty("NoWallTextureRepeat");
			this.topRepeat_ = !param1.hasOwnProperty("NoTopTextureRepeat");
		}
		
		override protected function buildDot() : void {
			var loc1:Vector3D = new Vector3D(-this.bI_,-this.bI_,0);
			var loc2:Vector3D = new Vector3D(this.bI_,-this.bI_,0);
			var loc3:Vector3D = new Vector3D(this.bI_,this.bI_,0);
			var loc4:Vector3D = new Vector3D(-this.bI_,this.bI_,0);
			var loc5:Vector3D = new Vector3D(-this.tI_,-this.tI_,this.h_);
			var loc6:Vector3D = new Vector3D(this.tI_,-this.tI_,this.h_);
			var loc7:Vector3D = new Vector3D(this.tI_,this.tI_,this.h_);
			var loc8:Vector3D = new Vector3D(-this.tI_,this.tI_,this.h_);
			this.addQuad(loc6,loc5,loc1,loc2,texture_,true,true);
			this.addQuad(loc7,loc6,loc2,loc3,texture_,true,true);
			this.addQuad(loc5,loc8,loc4,loc1,texture_,true,true);
			this.addQuad(loc8,loc7,loc3,loc4,texture_,true,true);
			var loc9:BitmapData = texture_;
			if(this.objectXML_.hasOwnProperty("DotTexture")) {
				loc9 = AssetLibrary.getImageFromSet(String(this.objectXML_.DotTexture.File),int(this.objectXML_.DotTexture.Index));
			}
			this.addTop([loc5,loc6,loc7,loc8],new <Number>[0.25,0.25,0.75,0.25,0.25,0.75],loc9);
		}
		
		override protected function buildShortLine() : void {
			var loc1:Vector3D = new Vector3D(-this.bI_,-0.5,0);
			var loc2:Vector3D = new Vector3D(this.bI_,-0.5,0);
			var loc3:Vector3D = new Vector3D(this.bI_,this.bI_,0);
			var loc4:Vector3D = new Vector3D(-this.bI_,this.bI_,0);
			var loc5:Vector3D = new Vector3D(-this.tI_,-0.5,this.h_);
			var loc6:Vector3D = new Vector3D(this.tI_,-0.5,this.h_);
			var loc7:Vector3D = new Vector3D(this.tI_,this.tI_,this.h_);
			var loc8:Vector3D = new Vector3D(-this.tI_,this.tI_,this.h_);
			this.addQuad(loc7,loc6,loc2,loc3,texture_,true,false);
			this.addQuad(loc5,loc8,loc4,loc1,texture_,false,true);
			this.addQuad(loc8,loc7,loc3,loc4,texture_,true,true);
			var loc9:BitmapData = texture_;
			if(this.objectXML_.hasOwnProperty("ShortLineTexture")) {
				loc9 = AssetLibrary.getImageFromSet(String(this.objectXML_.ShortLineTexture.File),int(this.objectXML_.ShortLineTexture.Index));
			}
			this.addTop([loc5,loc6,loc7,loc8],new <Number>[0.25,0,0.75,0,0.25,0.75],loc9);
		}
		
		override protected function buildL() : void {
			var loc1:Vector3D = new Vector3D(-this.bI_,-0.5,0);
			var loc2:Vector3D = new Vector3D(this.bI_,-0.5,0);
			var loc3:Vector3D = new Vector3D(this.bI_,-this.bI_,0);
			var loc4:Vector3D = new Vector3D(0.5,-this.bI_,0);
			var loc5:Vector3D = new Vector3D(0.5,this.bI_,0);
			var loc6:Vector3D = new Vector3D(-this.bI_,this.bI_,0);
			var loc7:Vector3D = new Vector3D(-this.tI_,-0.5,this.h_);
			var loc8:Vector3D = new Vector3D(this.tI_,-0.5,this.h_);
			var loc9:Vector3D = new Vector3D(this.tI_,-this.tI_,this.h_);
			var loc10:Vector3D = new Vector3D(0.5,-this.tI_,this.h_);
			var loc11:Vector3D = new Vector3D(0.5,this.tI_,this.h_);
			var loc12:Vector3D = new Vector3D(-this.tI_,this.tI_,this.h_);
			this.addBit(loc9,loc8,loc2,loc3,texture_,N2,true,true,true);
			this.addBit(loc10,loc9,loc3,loc4,texture_,N2,false,true,false);
			this.addQuad(loc12,loc11,loc5,loc6,texture_,true,false);
			this.addQuad(loc7,loc12,loc6,loc1,texture_,false,true);
			var loc13:BitmapData = texture_;
			if(this.objectXML_.hasOwnProperty("LTexture")) {
				loc13 = AssetLibrary.getImageFromSet(String(this.objectXML_.LTexture.File),int(this.objectXML_.LTexture.Index));
			}
			this.addTop([loc7,loc8,loc9,loc10,loc11,loc12],new <Number>[0.25,0,0.75,0,0.25,0.75],loc13);
		}
		
		override protected function buildLine() : void {
			var loc1:Vector3D = new Vector3D(-this.bI_,-0.5,0);
			var loc2:Vector3D = new Vector3D(this.bI_,-0.5,0);
			var loc3:Vector3D = new Vector3D(this.bI_,0.5,0);
			var loc4:Vector3D = new Vector3D(-this.bI_,0.5,0);
			var loc5:Vector3D = new Vector3D(-this.tI_,-0.5,this.h_);
			var loc6:Vector3D = new Vector3D(this.tI_,-0.5,this.h_);
			var loc7:Vector3D = new Vector3D(this.tI_,0.5,this.h_);
			var loc8:Vector3D = new Vector3D(-this.tI_,0.5,this.h_);
			this.addQuad(loc7,loc6,loc2,loc3,texture_,false,false);
			this.addQuad(loc5,loc8,loc4,loc1,texture_,false,false);
			var loc9:BitmapData = texture_;
			if(this.objectXML_.hasOwnProperty("LineTexture")) {
				loc9 = AssetLibrary.getImageFromSet(String(this.objectXML_.LineTexture.File),int(this.objectXML_.LineTexture.Index));
			}
			this.addTop([loc5,loc6,loc7,loc8],new <Number>[0.25,0,0.75,0,0.25,1],loc9);
		}
		
		override protected function buildT() : void {
			var loc1:Vector3D = new Vector3D(-this.bI_,-0.5,0);
			var loc2:Vector3D = new Vector3D(this.bI_,-0.5,0);
			var loc3:Vector3D = new Vector3D(this.bI_,-this.bI_,0);
			var loc4:Vector3D = new Vector3D(0.5,-this.bI_,0);
			var loc5:Vector3D = new Vector3D(0.5,this.bI_,0);
			var loc6:Vector3D = new Vector3D(-0.5,this.bI_,0);
			var loc7:Vector3D = new Vector3D(-0.5,-this.bI_,0);
			var loc8:Vector3D = new Vector3D(-this.bI_,-this.bI_,0);
			var loc9:Vector3D = new Vector3D(-this.tI_,-0.5,this.h_);
			var loc10:Vector3D = new Vector3D(this.tI_,-0.5,this.h_);
			var loc11:Vector3D = new Vector3D(this.tI_,-this.tI_,this.h_);
			var loc12:Vector3D = new Vector3D(0.5,-this.tI_,this.h_);
			var loc13:Vector3D = new Vector3D(0.5,this.tI_,this.h_);
			var loc14:Vector3D = new Vector3D(-0.5,this.tI_,this.h_);
			var loc15:Vector3D = new Vector3D(-0.5,-this.tI_,this.h_);
			var loc16:Vector3D = new Vector3D(-this.tI_,-this.tI_,this.h_);
			this.addBit(loc11,loc10,loc2,loc3,texture_,N2,true);
			this.addBit(loc12,loc11,loc3,loc4,texture_,N2,false);
			this.addQuad(loc14,loc13,loc5,loc6,texture_,false,false);
			this.addBit(loc16,loc15,loc7,loc8,texture_,N0,true);
			this.addBit(loc9,loc16,loc8,loc1,texture_,N0,false);
			var loc17:BitmapData = texture_;
			if(this.objectXML_.hasOwnProperty("TTexture")) {
				loc17 = AssetLibrary.getImageFromSet(String(this.objectXML_.TTexture.File),int(this.objectXML_.TTexture.Index));
			}
			this.addTop([loc9,loc10,loc11,loc12,loc13,loc14,loc15,loc16],new <Number>[0.25,0,0.75,0,0.25,0.25],loc17);
		}
		
		override protected function buildCross() : void {
			var loc1:Vector3D = new Vector3D(-this.bI_,-0.5,0);
			var loc2:Vector3D = new Vector3D(this.bI_,-0.5,0);
			var loc3:Vector3D = new Vector3D(this.bI_,-this.bI_,0);
			var loc4:Vector3D = new Vector3D(0.5,-this.bI_,0);
			var loc5:Vector3D = new Vector3D(0.5,this.bI_,0);
			var loc6:Vector3D = new Vector3D(this.bI_,this.bI_,0);
			var loc7:Vector3D = new Vector3D(this.bI_,0.5,0);
			var loc8:Vector3D = new Vector3D(-this.bI_,0.5,0);
			var loc9:Vector3D = new Vector3D(-this.bI_,this.bI_,0);
			var loc10:Vector3D = new Vector3D(-0.5,this.bI_,0);
			var loc11:Vector3D = new Vector3D(-0.5,-this.bI_,0);
			var loc12:Vector3D = new Vector3D(-this.bI_,-this.bI_,0);
			var loc13:Vector3D = new Vector3D(-this.tI_,-0.5,this.h_);
			var loc14:Vector3D = new Vector3D(this.tI_,-0.5,this.h_);
			var loc15:Vector3D = new Vector3D(this.tI_,-this.tI_,this.h_);
			var loc16:Vector3D = new Vector3D(0.5,-this.tI_,this.h_);
			var loc17:Vector3D = new Vector3D(0.5,this.tI_,this.h_);
			var loc18:Vector3D = new Vector3D(this.tI_,this.tI_,this.h_);
			var loc19:Vector3D = new Vector3D(this.tI_,0.5,this.h_);
			var loc20:Vector3D = new Vector3D(-this.tI_,0.5,this.h_);
			var loc21:Vector3D = new Vector3D(-this.tI_,this.tI_,this.h_);
			var loc22:Vector3D = new Vector3D(-0.5,this.tI_,this.h_);
			var loc23:Vector3D = new Vector3D(-0.5,-this.tI_,this.h_);
			var loc24:Vector3D = new Vector3D(-this.tI_,-this.tI_,this.h_);
			this.addBit(loc15,loc14,loc2,loc3,texture_,N2,true);
			this.addBit(loc16,loc15,loc3,loc4,texture_,N2,false);
			this.addBit(loc18,loc17,loc5,loc6,texture_,N4,true);
			this.addBit(loc19,loc18,loc6,loc7,texture_,N4,false);
			this.addBit(loc21,loc20,loc8,loc9,texture_,N6,true);
			this.addBit(loc22,loc21,loc9,loc10,texture_,N6,false);
			this.addBit(loc24,loc23,loc11,loc12,texture_,N0,true);
			this.addBit(loc13,loc24,loc12,loc1,texture_,N0,false);
			var loc25:BitmapData = texture_;
			if(this.objectXML_.hasOwnProperty("CrossTexture")) {
				loc25 = AssetLibrary.getImageFromSet(String(this.objectXML_.CrossTexture.File),int(this.objectXML_.CrossTexture.Index));
			}
			this.addTop([loc13,loc14,loc15,loc16,loc17,loc18,loc19,loc20,loc21,loc22,loc23,loc24],new <Number>[0.25,0,0.75,0,0.25,0.25],loc25);
		}
		
		protected function addQuad(param1:Vector3D, param2:Vector3D, param3:Vector3D, param4:Vector3D, param5:BitmapData, param6:Boolean, param7:Boolean) : void {
			var loc11:Number = NaN;
			var loc12:Number = NaN;
			var loc13:Vector.<Number> = null;
			var loc8:int = obj3D_.vL_.length / 3;
			obj3D_.vL_.push(param1.x,param1.y,param1.z,param2.x,param2.y,param2.z,param3.x,param3.y,param3.z,param4.x,param4.y,param4.z);
			var loc9:Number = !!param6?Number(-(this.bI_ - this.tI_) / (1 - (this.bI_ - this.tI_) - (!!param7?this.bI_ - this.tI_:0))):Number(0);
			obj3D_.uvts_.push(0,0,0,1,0,0,1,1,0,loc9,1,0);
			var loc10:ObjectFace3D = new ObjectFace3D(obj3D_,new <int>[loc8,loc8 + 1,loc8 + 2,loc8 + 3]);
			loc10.texture_ = param5;
			loc10.bitmapFill_.repeat = this.wallRepeat_;
			obj3D_.faces_.push(loc10);
			if(GraphicsFillExtra.getVertexBuffer(loc10.bitmapFill_) == null && Parameters.isGpuRender()) {
				loc11 = 0;
				loc12 = 0;
				if(param6) {
					loc11 = loc9;
				}
				if(param7) {
					loc12 = -loc9;
				}
				if(loc12 == 0 && loc11 == 0 && param7 && param4.x == -0.5) {
					loc12 = 0.34;
				}
				loc13 = Vector.<Number>([-0.5,0.5,0,0,0,0.5,0.5,0,1,0,-0.5 + loc11,-0.5,0,0,1,0.5 + loc12,-0.5,0,1,1]);
				GraphicsFillExtra.setVertexBuffer(loc10.bitmapFill_,loc13);
			}
		}
		
		protected function addBit(param1:Vector3D, param2:Vector3D, param3:Vector3D, param4:Vector3D, param5:BitmapData, param6:Vector3D, param7:Boolean, param8:Boolean = false, param9:Boolean = false) : void {
			var loc12:Vector.<Number> = null;
			var loc10:int = obj3D_.vL_.length / 3;
			obj3D_.vL_.push(param1.x,param1.y,param1.z,param2.x,param2.y,param2.z,param3.x,param3.y,param3.z,param4.x,param4.y,param4.z);
			if(param7) {
				obj3D_.uvts_.push(-0.5 + this.tI_,0,0,0,0,0,0,0,0,-0.5 + this.bI_,1,0);
			} else {
				obj3D_.uvts_.push(1,0,0,1.5 - this.tI_,0,0,0,0,0,1,1,0);
			}
			var loc11:ObjectFace3D = new ObjectFace3D(obj3D_,new <int>[loc10,loc10 + 1,loc10 + 2,loc10 + 3]);
			loc11.texture_ = param5;
			loc11.bitmapFill_.repeat = this.wallRepeat_;
			loc11.normalL_ = param6;
			if(!Parameters.isGpuRender() && !param8) {
				obj3D_.faces_.push(loc11);
			} else if(param8) {
				if(param9) {
					loc12 = Vector.<Number>([-0.75,0.5,0,0,0,-0.5,0.5,0,1,0,-0.75,-0.5,0,0,1,-0.5,-0.5,0,1,1]);
				} else {
					loc12 = Vector.<Number>([0.5,0.5,0,0,0,0.75,0.5,0,1,0,0.5,-0.5,0,0,1,0.75,-0.5,0,1,1]);
				}
				GraphicsFillExtra.setVertexBuffer(loc11.bitmapFill_,loc12);
				obj3D_.faces_.push(loc11);
			}
		}
		
		protected function addTop(param1:Array, param2:Vector.<Number>, param3:BitmapData) : void {
			var loc8:ObjectFace3D = null;
			var loc10:Vector.<Number> = null;
			var loc11:int = 0;
			var loc12:Array = null;
			var loc13:Array = null;
			var loc14:Array = null;
			var loc15:int = 0;
			var loc16:int = 0;
			var loc17:int = 0;
			var loc4:int = obj3D_.vL_.length / 3;
			var loc5:Vector.<int> = new Vector.<int>();
			var loc6:uint = 0;
			while(loc6 < param1.length) {
				obj3D_.vL_.push(param1[loc6].x,param1[loc6].y,param1[loc6].z);
				loc5.push(loc4 + loc6);
				if(loc6 == 0) {
					obj3D_.uvts_.push(param2[0],param2[1],0);
				} else if(loc6 == 1) {
					obj3D_.uvts_.push(param2[2],param2[3],0);
				} else if(loc6 == param1.length - 1) {
					obj3D_.uvts_.push(param2[4],param2[5],0);
				} else {
					obj3D_.uvts_.push(0,0,0);
				}
				loc6++;
			}
			var loc7:ObjectFace3D = new ObjectFace3D(obj3D_,loc5);
			loc7.texture_ = param3;
			loc7.bitmapFill_.repeat = this.topRepeat_;
			obj3D_.faces_.push(loc7);
			if(loc5.length == 6 && Parameters.isGpuRender()) {
				loc8 = new ObjectFace3D(obj3D_,loc5);
				loc8.texture_ = param3;
				loc8.bitmapFill_.repeat = this.topRepeat_;
				obj3D_.faces_.push(loc8);
			}
			var loc9:int = 0;
			if(loc5.length == 4 && GraphicsFillExtra.getVertexBuffer(loc7.bitmapFill_) == null && Parameters.isGpuRender()) {
				loc10 = new Vector.<Number>();
				loc9 = 0;
				while(loc9 < loc5.length) {
					if(loc9 == 3) {
						loc11 = 2;
					} else if(loc9 == 2) {
						loc11 = 3;
					} else {
						loc11 = loc9;
					}
					loc10.push(obj3D_.vL_[loc5[loc11] * 3],obj3D_.vL_[loc5[loc11] * 3 + 1] * -1,obj3D_.vL_[loc5[loc11] * 3 + 2],obj3D_.uvts_[loc5[loc11 != 2?loc11:loc11 - 1] * 3],obj3D_.uvts_[loc5[loc11 != 2?loc11:loc11 + 1] * 3 + 1]);
					loc9++;
				}
				GraphicsFillExtra.setVertexBuffer(loc7.bitmapFill_,loc10);
			} else if(loc5.length == 6 && GraphicsFillExtra.getVertexBuffer(loc7.bitmapFill_) == null && Parameters.isGpuRender()) {
				loc12 = [0,1,5,2];
				loc13 = [2,3,5,4];
				loc14 = [5,0,2,1];
				loc15 = 0;
				while(loc15 < 2) {
					if(loc15 == 1) {
						loc12 = loc13;
					}
					loc10 = new Vector.<Number>();
					loc16 = 0;
					loc17 = 0;
					for each(loc9 in loc12) {
						if(loc15 == 1) {
							loc17 = loc14[loc16];
						} else {
							loc17 = loc9;
						}
						loc10.push(obj3D_.vL_[loc5[loc9] * 3],obj3D_.vL_[loc5[loc9] * 3 + 1] * -1,obj3D_.vL_[loc5[loc9] * 3 + 2],obj3D_.uvts_[loc5[loc17 != 2?loc17:loc17 - 1] * 3],obj3D_.uvts_[loc5[loc17 != 2?loc17:loc17 + 1] * 3 + 1]);
						loc16++;
					}
					if(loc15 == 1) {
						GraphicsFillExtra.setVertexBuffer(loc8.bitmapFill_,loc10);
					} else {
						GraphicsFillExtra.setVertexBuffer(loc7.bitmapFill_,loc10);
					}
					loc15++;
				}
			}
		}
	}
}
