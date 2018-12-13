package kabam.rotmg.stage3D.graphic3D {
	import flash.display.BitmapData;
	import flash.display.GraphicsBitmapFill;
	import flash.display.GraphicsGradientFill;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.VertexBuffer3D;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;

	import kabam.rotmg.stage3D.GraphicsFillExtra;
	import kabam.rotmg.stage3D.proxies.Context3DProxy;
	import kabam.rotmg.stage3D.proxies.IndexBuffer3DProxy;
	import kabam.rotmg.stage3D.proxies.TextureProxy;
	import kabam.rotmg.stage3D.proxies.VertexBuffer3DProxy;

	public class Graphic3D {

		private static const gradientVertex:Vector.<Number> = Vector.<Number>([-0.5, 0.5, 0, 0, 0, 0, 0.01, 0, 1, 0.5, 0.5, 0, 0, 0, 0, 0.3, 1, 1, -0.5, -0.5, 0, 0, 0, 0, 0.1, 0, 0, 0.5, -0.5, 0, 0, 0, 0, 0.2, 1, 0]);

		private static const indices:Vector.<uint> = Vector.<uint>([0, 1, 2, 2, 1, 3]);


		public var texture:TextureProxy;

		public var matrix3D:Matrix3D;

		public var context3D:Context3DProxy;

		[Inject]
		public var textureFactory:TextureFactory;

		[Inject]
		public var vertexBuffer:VertexBuffer3DProxy;

		[Inject]
		public var indexBuffer:IndexBuffer3DProxy;

		private var bitmapData:BitmapData;

		private var matrix2D:Matrix;

		private var shadowMatrix2D:Matrix;

		private var sinkLevel:Number = 0;

		private var offsetMatrix:Vector.<Number>;

		private var vertexBufferCustom:VertexBuffer3D;

		private var gradientVB:VertexBuffer3D;

		private var gradientIB:IndexBuffer3D;

		private var repeat:Boolean;

		public function Graphic3D() {
			this.matrix3D = new Matrix3D();
			super();
		}

		public function setGraphic(param1:GraphicsBitmapFill, param2:Context3DProxy):void {
			this.bitmapData = param1.bitmapData;
			this.repeat = param1.repeat;
			this.matrix2D = param1.matrix;
			this.texture = this.textureFactory.make(param1.bitmapData);
			this.offsetMatrix = GraphicsFillExtra.getOffsetUV(param1);
			this.vertexBufferCustom = GraphicsFillExtra.getVertexBuffer(param1);
			this.sinkLevel = GraphicsFillExtra.getSinkLevel(param1);
			if (this.sinkLevel != 0) {
				this.offsetMatrix = Vector.<Number>([0, -this.sinkLevel, 0, 0]);
			}
			this.transform();
			var loc3:ColorTransform = GraphicsFillExtra.getColorTransform(this.bitmapData);
			param2.GetContext3D().setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 2, Vector.<Number>([loc3.redMultiplier, loc3.greenMultiplier, loc3.blueMultiplier, loc3.alphaMultiplier]));
			param2.GetContext3D().setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 3, Vector.<Number>([loc3.redOffset / 255, loc3.greenOffset / 255, loc3.blueOffset / 255, loc3.alphaOffset / 255]));
		}

		public function setGradientFill(param1:GraphicsGradientFill, param2:Context3DProxy, param3:Number, param4:Number):void {
			this.shadowMatrix2D = param1.matrix;
			if (this.gradientVB == null || this.gradientIB == null) {
				this.gradientVB = param2.GetContext3D().createVertexBuffer(4, 9);
				this.gradientVB.uploadFromVector(gradientVertex, 0, 4);
				this.gradientIB = param2.GetContext3D().createIndexBuffer(6);
				this.gradientIB.uploadFromVector(indices, 0, 6);
			}
			this.shadowTransform(param3, param4);
		}

		private function shadowTransform(param1:Number, param2:Number):void {
			this.matrix3D.identity();
			var loc3:Vector.<Number> = this.matrix3D.rawData;
			loc3[4] = -this.shadowMatrix2D.c;
			loc3[1] = -this.shadowMatrix2D.b;
			loc3[0] = this.shadowMatrix2D.a * 4;
			loc3[5] = this.shadowMatrix2D.d * 4;
			loc3[12] = this.shadowMatrix2D.tx / param1;
			loc3[13] = -this.shadowMatrix2D.ty / param2;
			this.matrix3D.rawData = loc3;
		}

		private function transform():void {
			this.matrix3D.identity();
			var loc1:Vector.<Number> = this.matrix3D.rawData;
			loc1[4] = -this.matrix2D.c;
			loc1[1] = -this.matrix2D.b;
			loc1[0] = this.matrix2D.a;
			loc1[5] = this.matrix2D.d;
			loc1[12] = this.matrix2D.tx;
			loc1[13] = -this.matrix2D.ty;
			this.matrix3D.rawData = loc1;
			this.matrix3D.prependScale(Math.ceil(this.texture.getWidth()), Math.ceil(this.texture.getHeight()), 1);
			this.matrix3D.prependTranslation(0.5, -0.5, 0);
		}

		public function render(param1:Context3DProxy):void {
			var loc2:Program3DFactory = Program3DFactory.getInstance();
			param1.setProgram(loc2.getProgram(param1, this.repeat));
			param1.setTextureAt(0, this.texture);
			if (this.vertexBufferCustom != null) {
				param1.GetContext3D().setVertexBufferAt(0, this.vertexBufferCustom, 0, Context3DVertexBufferFormat.FLOAT_3);
				param1.GetContext3D().setVertexBufferAt(1, this.vertexBufferCustom, 3, Context3DVertexBufferFormat.FLOAT_2);
				param1.GetContext3D().setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4, this.offsetMatrix);
				param1.GetContext3D().setVertexBufferAt(2, null, 6, Context3DVertexBufferFormat.FLOAT_2);
				param1.drawTriangles(this.indexBuffer);
			} else {
				param1.setVertexBufferAt(0, this.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
				param1.setVertexBufferAt(1, this.vertexBuffer, 3, Context3DVertexBufferFormat.FLOAT_2);
				param1.GetContext3D().setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4, this.offsetMatrix);
				param1.GetContext3D().setVertexBufferAt(2, null, 6, Context3DVertexBufferFormat.FLOAT_2);
				param1.drawTriangles(this.indexBuffer);
			}
		}

		public function renderShadow(param1:Context3DProxy):void {
			param1.GetContext3D().setVertexBufferAt(0, this.gradientVB, 0, Context3DVertexBufferFormat.FLOAT_3);
			param1.GetContext3D().setVertexBufferAt(1, this.gradientVB, 3, Context3DVertexBufferFormat.FLOAT_4);
			param1.GetContext3D().setVertexBufferAt(2, this.gradientVB, 7, Context3DVertexBufferFormat.FLOAT_2);
			param1.GetContext3D().setTextureAt(0, null);
			param1.GetContext3D().drawTriangles(this.gradientIB);
		}

		public function getMatrix3D():Matrix3D {
			return this.matrix3D;
		}
	}
}
