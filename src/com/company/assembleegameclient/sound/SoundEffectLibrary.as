package com.company.assembleegameclient.sound {
	import com.company.assembleegameclient.parameters.Parameters;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;

	import kabam.rotmg.application.api.ApplicationSetup;
	import kabam.rotmg.core.StaticInjectorContext;

	public class SoundEffectLibrary {

		private static var urlBase:String;

		private static const URL_PATTERN:String = "{URLBASE}/sfx/{NAME}.mp3";

		public static var nameMap_:Dictionary = new Dictionary();

		private static var activeSfxList_:Dictionary = new Dictionary(true);


		public function SoundEffectLibrary() {
			super();
		}

		public static function load(param1:String):Sound {
			return nameMap_[param1] = nameMap_[param1] || makeSound(param1);
		}

		public static function makeSound(param1:String):Sound {
			var loc2:Sound = new Sound();
			loc2.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loc2.load(makeSoundRequest(param1));
			return loc2;
		}

		private static function getUrlBase():String {
			var setup:ApplicationSetup = null;
			var base:String = "";
			try {
				setup = StaticInjectorContext.getInjector().getInstance(ApplicationSetup);
				base = setup.getAppEngineUrl(true);
			}
			catch (error:Error) {
				base = "localhost";
			}
			return base;
		}

		private static function makeSoundRequest(param1:String):URLRequest {
			urlBase = urlBase || getUrlBase();
			var loc2:String = URL_PATTERN.replace("{URLBASE}", urlBase).replace("{NAME}", param1);
			return new URLRequest(loc2);
		}

		public static function play(param1:String, param2:Number = 1.0, param3:Boolean = true):void {
			var actualVolume:Number = NaN;
			var trans:SoundTransform = null;
			var channel:SoundChannel = null;
			var name:String = param1;
			var volumeMultiplier:Number = param2;
			var isFX:Boolean = param3;
			var sound:Sound = load(name);
			var volume:Number = Parameters.data_.SFXVolume * volumeMultiplier;
			try {
				actualVolume = Parameters.data_.playSFX && isFX || !isFX && Parameters.data_.playPewPew ? Number(volume) : Number(0);
				trans = new SoundTransform(actualVolume);
				channel = sound.play(0, 0, trans);
				channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete, false, 0, true);
				activeSfxList_[channel] = volume;
				return;
			}
			catch (error:Error) {
				return;
			}
		}

		private static function onSoundComplete(param1:Event):void {
			var loc2:SoundChannel = param1.target as SoundChannel;
			delete activeSfxList_[loc2];
		}

		public static function updateVolume(param1:Number):void {
			var loc2:SoundChannel = null;
			var loc3:SoundTransform = null;
			for each(loc2 in activeSfxList_) {
				activeSfxList_[loc2] = param1;
				loc3 = loc2.soundTransform;
				loc3.volume = !!Parameters.data_.playSFX ? Number(activeSfxList_[loc2]) : Number(0);
				loc2.soundTransform = loc3;
			}
		}

		public static function updateTransform():void {
			var loc1:SoundChannel = null;
			var loc2:SoundTransform = null;
			for each(loc1 in activeSfxList_) {
				loc2 = loc1.soundTransform;
				loc2.volume = !!Parameters.data_.playSFX ? Number(activeSfxList_[loc1]) : Number(0);
				loc1.soundTransform = loc2;
			}
		}

		public static function onIOError(param1:IOErrorEvent):void {
		}
	}
}
