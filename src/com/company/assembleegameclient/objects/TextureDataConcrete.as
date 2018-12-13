package com.company.assembleegameclient.objects {
	import com.company.assembleegameclient.appengine.RemoteTexture;
	import com.company.assembleegameclient.objects.particles.EffectProperties;
	import com.company.assembleegameclient.util.AnimatedChar;
	import com.company.assembleegameclient.util.AnimatedChars;
	import com.company.assembleegameclient.util.AssetLoader;
	import com.company.assembleegameclient.util.MaskedImage;
	import com.company.util.AssetLibrary;

	import flash.display.BitmapData;
	import flash.utils.Dictionary;

	import kabam.rotmg.application.api.ApplicationSetup;
	import kabam.rotmg.core.StaticInjectorContext;

	public class TextureDataConcrete extends TextureData {

		public static var remoteTexturesUsed:Boolean = false;


		private var isUsingLocalTextures:Boolean;

		public function TextureDataConcrete(param1:XML) {
			var loc2:XML = null;
			super();
			this.isUsingLocalTextures = this.getWhetherToUseLocalTextures();
			if (param1.hasOwnProperty("Texture")) {
				this.parse(XML(param1.Texture), String(param1.@id));
			} else if (param1.hasOwnProperty("AnimatedTexture")) {
				this.parse(XML(param1.AnimatedTexture), String(param1.@id));
			} else if (param1.hasOwnProperty("RemoteTexture")) {
				this.parse(XML(param1.RemoteTexture));
			} else if (param1.hasOwnProperty("RandomTexture")) {
				this.parse(XML(param1.RandomTexture), String(param1.@id));
			} else {
				this.parse(param1);
			}
			for each(loc2 in param1.AltTexture) {
				this.parse(loc2);
			}
			if (param1.hasOwnProperty("Mask")) {
				this.parse(XML(param1.Mask));
			}
			if (param1.hasOwnProperty("Effect")) {
				this.parse(XML(param1.Effect));
			}
		}

		override public function getTexture(param1:int = 0):BitmapData {
			if (randomTextureData_ == null) {
				return texture_;
			}
			var loc2:TextureData = randomTextureData_[param1 % randomTextureData_.length];
			return loc2.getTexture(param1);
		}

		override public function getAltTextureData(param1:int):TextureData {
			if (altTextures_ == null) {
				return null;
			}
			return altTextures_[param1];
		}

		private function getWhetherToUseLocalTextures():Boolean {
			var loc1:ApplicationSetup = StaticInjectorContext.getInjector().getInstance(ApplicationSetup);
			return loc1.useLocalTextures();
		}

		private function parse(param1:XML, param2:String = ""):void {
			var image:MaskedImage = null;
			var remoteTexture:RemoteTexture = null;
			var childXML:XML = null;
			var xml:XML = param1;
			var id:String = param2;
			switch (xml.name().toString()) {
				case "Texture":
					try {
						texture_ = AssetLibrary.getImageFromSet(String(xml.File), int(xml.Index));
					}
					catch (error:Error) {
						throw new Error("Error loading Texture for " + id + " - name: " + String(xml.File) + " - idx: " + int(xml.Index));
					}
					break;
				case "Mask":
					mask_ = AssetLibrary.getImageFromSet(String(xml.File), int(xml.Index));
					break;
				case "Effect":
					effectProps_ = new EffectProperties(xml);
					break;
				case "AnimatedTexture":
					animatedChar_ = AnimatedChars.getAnimatedChar(String(xml.File), int(xml.Index));
					try {
						image = animatedChar_.imageFromAngle(0, AnimatedChar.STAND, 0);
						texture_ = image.image_;
						mask_ = image.mask_;
					}
					catch (error:Error) {
						throw new Error("Error loading AnimatedTexture for " + id + " - name: " + String(xml.File) + " - idx: " + int(xml.Index));
					}
					break;
				case "RemoteTexture":
					texture_ = AssetLibrary.getImageFromSet("lofiObj3", 255);
					if (this.isUsingLocalTextures) {
						remoteTexture = new RemoteTexture(xml.Id, xml.Instance, this.onRemoteTexture);
						remoteTexture.run();
						if (!AssetLoader.currentXmlIsTesting) {
							remoteTexturesUsed = true;
						}
					}
					remoteTextureDir_ = !!xml.hasOwnProperty("Right") ? int(AnimatedChar.RIGHT) : int(AnimatedChar.DOWN);
					break;
				case "RandomTexture":
					try {
						randomTextureData_ = new Vector.<TextureData>();
						for each(childXML in xml.children()) {
							randomTextureData_.push(new TextureDataConcrete(childXML));
						}
					}
					catch (error:Error) {
						throw new Error("Error loading RandomTexture for " + id);
					}
					break;
				case "AltTexture":
					if (altTextures_ == null) {
						altTextures_ = new Dictionary();
					}
					altTextures_[int(xml.@id)] = new TextureDataConcrete(xml);
			}
		}

		private function onRemoteTexture(param1:BitmapData):void {
			if (param1.width > 16) {
				AnimatedChars.add("remoteTexture", param1, null, param1.width / 7, param1.height, param1.width, param1.height, remoteTextureDir_);
				animatedChar_ = AnimatedChars.getAnimatedChar("remoteTexture", 0);
				texture_ = animatedChar_.imageFromAngle(0, AnimatedChar.STAND, 0).image_;
			} else {
				texture_ = param1;
			}
		}
	}
}
