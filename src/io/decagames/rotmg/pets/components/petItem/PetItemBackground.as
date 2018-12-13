package io.decagames.rotmg.pets.components.petItem {
	import com.company.util.GraphicsUtil;

	import flash.display.GraphicsPath;
	import flash.display.GraphicsSolidFill;
	import flash.display.IGraphicsData;
	import flash.display.Sprite;

	public class PetItemBackground extends Sprite {


		public function PetItemBackground(param1:int, param2:Array, param3:uint, param4:Number) {
			super();
			var loc5:GraphicsSolidFill = new GraphicsSolidFill(param3, param4);
			var loc6:GraphicsPath = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());
			var loc7:Vector.<IGraphicsData> = new <IGraphicsData>[loc5, loc6, GraphicsUtil.END_FILL];
			GraphicsUtil.drawCutEdgeRect(0, 0, param1, param1, param1 / 12, param2, loc6);
			graphics.drawGraphicsData(loc7);
		}
	}
}
