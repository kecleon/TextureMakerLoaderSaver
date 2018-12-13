 
package com.company.assembleegameclient.objects.animation {
	public class AnimationsData {
		 
		
		public var animations:Vector.<AnimationData>;
		
		public function AnimationsData(param1:XML) {
			var loc2:XML = null;
			this.animations = new Vector.<AnimationData>();
			super();
			for each(loc2 in param1.Animation) {
				this.animations.push(new AnimationData(loc2));
			}
		}
	}
}
