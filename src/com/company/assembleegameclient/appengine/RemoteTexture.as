package com.company.assembleegameclient.appengine {
	import flash.display.BitmapData;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.ByteArray;

	import ion.utils.png.PNGDecoder;

	import kabam.rotmg.appengine.api.RetryLoader;
	import kabam.rotmg.appengine.impl.AppEngineRetryLoader;
	import kabam.rotmg.core.StaticInjectorContext;

	import org.swiftsuspenders.Injector;

	import robotlegs.bender.framework.api.ILogger;

	public class RemoteTexture {

		private static const URL_PATTERN:String = "https://{DOMAIN}/picture/get";

		private static const ERROR_PATTERN:String = "Remote Texture Error: {ERROR} (id:{ID}, instance:{INSTANCE})";

		private static const START_TIME:int = int(new Date().getTime());


		public var id_:String;

		public var instance_:String;

		public var callback_:Function;

		private var logger:ILogger;

		public function RemoteTexture(param1:String, param2:String, param3:Function) {
			super();
			this.id_ = param1;
			this.instance_ = param2;
			this.callback_ = param3;
			var loc4:Injector = StaticInjectorContext.getInjector();
			this.logger = loc4.getInstance(ILogger);
		}

		public function run():void {
			var loc1:String = this.instance_ == "testing" ? "test.realmofthemadgod.com" : "realmofthemadgod.com";
			var loc2:String = URL_PATTERN.replace("{DOMAIN}", loc1);
			var loc3:Object = {};
			loc3.id = this.id_;
			loc3.time = START_TIME;
			var loc4:RetryLoader = new AppEngineRetryLoader();
			loc4.setDataFormat(URLLoaderDataFormat.BINARY);
			loc4.complete.addOnce(this.onComplete);
			loc4.sendRequest(loc2, loc3);
		}

		private function onComplete(param1:Boolean, param2:*):void {
			if (param1) {
				this.makeTexture(param2);
			} else {
				this.reportError(param2);
			}
		}

		public function makeTexture(param1:ByteArray):void {
			var loc2:BitmapData = PNGDecoder.decodeImage(param1);
			this.callback_(loc2);
		}

		public function reportError(param1:String):void {
			param1 = ERROR_PATTERN.replace("{ERROR}", param1).replace("{ID}", this.id_).replace("{INSTANCE}", this.instance_);
			this.logger.warn("RemoteTexture.reportError: {0}", [param1]);
			var loc2:BitmapData = new BitmapDataSpy(1, 1);
			this.callback_(loc2);
		}
	}
}
