 
package com.company.assembleegameclient.sound {
	import com.company.assembleegameclient.parameters.Parameters;
	import flash.media.SoundTransform;
	import kabam.rotmg.core.StaticInjectorContext;
	import kabam.rotmg.core.service.GoogleAnalytics;
	
	public class SFX {
		
		private static var sfxTrans_:SoundTransform;
		 
		
		public function SFX() {
			super();
		}
		
		public static function load() : void {
			sfxTrans_ = new SoundTransform(!!Parameters.data_.playSFX?Number(1):Number(0));
		}
		
		public static function setPlaySFX(param1:Boolean) : void {
			var loc2:GoogleAnalytics = StaticInjectorContext.getInjector().getInstance(GoogleAnalytics);
			if(!loc2) {
			}
			Parameters.data_.playSFX = param1;
			Parameters.save();
			SoundEffectLibrary.updateTransform();
		}
		
		public static function setSFXVolume(param1:Number) : void {
			Parameters.data_.SFXVolume = param1;
			Parameters.save();
			SoundEffectLibrary.updateVolume(param1);
		}
	}
}
