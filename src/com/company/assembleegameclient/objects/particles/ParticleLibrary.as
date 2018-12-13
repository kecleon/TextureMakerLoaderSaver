package com.company.assembleegameclient.objects.particles {
	public class ParticleLibrary {

		public static const propsLibrary_:Object = {};


		public function ParticleLibrary() {
			super();
		}

		public static function parseFromXML(param1:XML):void {
			var loc2:XML = null;
			for each(loc2 in param1.Particle) {
				propsLibrary_[loc2.@id] = new ParticleProperties(loc2);
			}
		}
	}
}
