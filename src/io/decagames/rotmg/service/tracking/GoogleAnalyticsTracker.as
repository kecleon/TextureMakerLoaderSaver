package io.decagames.rotmg.service.tracking {
	import flash.crypto.generateRandomBytes;
	import flash.display.Loader;
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	import robotlegs.bender.framework.api.ILogger;

	public class GoogleAnalyticsTracker {

		public static const VERSION:String = "1";


		private var _debug:Boolean = false;

		private var trackingURL:String = "https://www.google-analytics.com/collect";

		private var account:String;

		private var logger:ILogger;

		private var clientID:String;

		public function GoogleAnalyticsTracker(param1:String, param2:ILogger, param3:String, param4:Boolean = false) {
			super();
			this.account = param1;
			this.logger = param2;
			this._debug = param4;
			if (param4) {
				this.trackingURL = "http://www.google-analytics.com/debug/collect";
			}
			this.clientID = this.getClientID();
		}

		private function getClientID():String {
			var cid:String = null;
			var so:SharedObject = SharedObject.getLocal("_ga2");
			if (!so.data.clientid) {
				this.logger.debug("CID not found, generate Client ID");
				cid = this._generateUUID();
				so.data.clientid = cid;
				try {
					so.flush(1024);
				}
				catch (e:Error) {
					logger.debug("Could not write SharedObject to disk: " + e.message);
				}
			} else {
				this.logger.debug("CID found, restore from SharedObject: " + so.data.clientid);
				cid = so.data.clientid;
			}
			return cid;
		}

		private function _generateUUID():String {
			var i:uint = 0;
			var b:uint = 0;
			var randomBytes:ByteArray = generateRandomBytes(16);
			randomBytes[6] = randomBytes[6] & 15;
			randomBytes[6] = randomBytes[6] | 64;
			randomBytes[8] = randomBytes[8] & 63;
			randomBytes[8] = randomBytes[8] | 128;
			var toHex:Function = function (param1:uint):String {
				var loc2:String = param1.toString(16);
				loc2 = loc2.length > 1 ? loc2 : "0" + loc2;
				return loc2;
			};
			var str:String = "";
			var l:uint = randomBytes.length;
			randomBytes.position = 0;
			i = 0;
			while (i < l) {
				b = randomBytes[i];
				str = str + toHex(b);
				i++;
			}
			var uuid:String = "";
			uuid = uuid + str.substr(0, 8);
			uuid = uuid + "-";
			uuid = uuid + str.substr(8, 4);
			uuid = uuid + "-";
			uuid = uuid + str.substr(12, 4);
			uuid = uuid + "-";
			uuid = uuid + str.substr(16, 4);
			uuid = uuid + "-";
			uuid = uuid + str.substr(20, 12);
			return uuid;
		}

		public function trackEvent(param1:String, param2:String, param3:String = "", param4:Number = NaN):void {
			this.triggerEvent("&t=event" + "&ec=" + param1 + "&ea=" + param2 + (param3 != "" ? "&el=" + param3 : "") + (!isNaN(param4) ? "&ev=" + param4 : ""));
		}

		public function trackPageView(param1:String):void {
			this.triggerEvent("&t=pageview" + "&dp=" + param1);
		}

		private function prepareURL(param1:String):String {
			return this.trackingURL + "?v=" + VERSION + "&tid=" + this.account + "&cid=" + this.clientID + param1;
		}

		private function triggerEvent(param1:String):void {
			var urlLoader:Loader = null;
			var request:URLRequest = null;
			var url:String = param1;
			url = this.prepareURL(url);
			if (this._debug) {
				this.logger.debug("DEBUGGING GA:" + url);
				return;
			}
			try {
				urlLoader = new Loader();
				request = new URLRequest(url);
				urlLoader.load(request);
				return;
			}
			catch (e:Error) {
				logger.error("Tracking Error:" + e.message + ", " + e.name + ", " + e.getStackTrace());
				return;
			}
		}

		public function get debug():Boolean {
			return this._debug;
		}
	}
}
