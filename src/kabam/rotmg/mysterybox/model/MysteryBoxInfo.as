package kabam.rotmg.mysterybox.model {
	import com.company.assembleegameclient.util.TimeUtil;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;

	import io.decagames.rotmg.shop.genericBox.data.GenericBoxInfo;

	import kabam.display.Loader.LoaderProxy;
	import kabam.display.Loader.LoaderProxyConcrete;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;

	public class MysteryBoxInfo extends GenericBoxInfo {


		public var _iconImageUrl:String;

		private var _iconImage:DisplayObject;

		public var _infoImageUrl:String;

		private var _infoImage:DisplayObject;

		private var _loader:LoaderProxy;

		private var _infoImageLoader:LoaderProxy;

		public var _rollsWithContents:Vector.<Vector.<int>>;

		public var _rollsWithContentsUnique:Vector.<int>;

		private var _rollsContents:Vector.<Vector.<int>>;

		private var _rolls:int;

		private var _jackpots:String = "";

		private var _displayedItems:String = "";

		public function MysteryBoxInfo() {
			this._loader = new LoaderProxyConcrete();
			this._infoImageLoader = new LoaderProxyConcrete();
			this._rollsWithContents = new Vector.<Vector.<int>>();
			this._rollsWithContentsUnique = new Vector.<int>();
			this._rollsContents = new Vector.<Vector.<int>>();
			super();
		}

		public function get iconImageUrl():* {
			return this._iconImageUrl;
		}

		public function set iconImageUrl(param1:String):void {
			this._iconImageUrl = param1;
			this.loadIconImageFromUrl(this._iconImageUrl);
		}

		private function loadIconImageFromUrl(param1:String):void {
			this._loader && this._loader.unload();
			this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onComplete);
			this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.onError);
			this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.DISK_ERROR, this.onError);
			this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.NETWORK_ERROR, this.onError);
			this._loader.load(new URLRequest(param1));
		}

		private function onError(param1:IOErrorEvent):void {
		}

		private function onComplete(param1:Event):void {
			this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.onComplete);
			this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.onError);
			this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.DISK_ERROR, this.onError);
			this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.NETWORK_ERROR, this.onError);
			this._iconImage = DisplayObject(this._loader);
		}

		public function get iconImage():DisplayObject {
			return this._iconImage;
		}

		public function get infoImageUrl():* {
			return this._infoImageUrl;
		}

		public function set infoImageUrl(param1:String):void {
			this._infoImageUrl = param1;
			this.loadInfomageFromUrl(this._infoImageUrl);
		}

		private function loadInfomageFromUrl(param1:String):void {
			this.loadImageFromUrl(param1, this._infoImageLoader);
		}

		private function loadImageFromUrl(param1:String, param2:LoaderProxy):void {
			param2 && param2.unload();
			param2.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onInfoComplete);
			param2.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.onInfoError);
			param2.contentLoaderInfo.addEventListener(IOErrorEvent.DISK_ERROR, this.onInfoError);
			param2.contentLoaderInfo.addEventListener(IOErrorEvent.NETWORK_ERROR, this.onInfoError);
			param2.load(new URLRequest(param1));
		}

		private function onInfoError(param1:IOErrorEvent):void {
		}

		private function onInfoComplete(param1:Event):void {
			this._infoImageLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.onInfoComplete);
			this._infoImageLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.onInfoError);
			this._infoImageLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.DISK_ERROR, this.onInfoError);
			this._infoImageLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.NETWORK_ERROR, this.onInfoError);
			this._infoImage = DisplayObject(this._infoImageLoader);
		}

		public function parseContents():void {
			var loc4:String = null;
			var loc5:Vector.<int> = null;
			var loc6:Array = null;
			var loc7:String = null;
			var loc1:Array = _contents.split(";");
			var loc2:Dictionary = new Dictionary();
			var loc3:int = 0;
			for each(loc4 in loc1) {
				loc5 = new Vector.<int>();
				loc6 = loc4.split(",");
				for each(loc7 in loc6) {
					if (loc2[int(loc7)] == null) {
						loc2[int(loc7)] = true;
						this._rollsWithContentsUnique.push(int(loc7));
					}
					loc5.push(int(loc7));
				}
				this._rollsWithContents.push(loc5);
				this._rollsContents[loc3] = loc5;
				loc3++;
			}
		}

		public function getSaleTimeLeftStringBuilder():LineBuilder {
			var loc1:Date = new Date();
			var loc2:String = "";
			var loc3:Number = (_saleEnd.time - loc1.time) / 1000;
			var loc4:LineBuilder = new LineBuilder();
			if (loc3 > TimeUtil.DAY_IN_S) {
				loc4.setParams("MysteryBoxInfo.saleEndStringDays", {"amount": String(Math.ceil(TimeUtil.secondsToDays(loc3)))});
			} else if (loc3 > TimeUtil.HOUR_IN_S) {
				loc4.setParams("MysteryBoxInfo.saleEndStringHours", {"amount": String(Math.ceil(TimeUtil.secondsToHours(loc3)))});
			} else {
				loc4.setParams("MysteryBoxInfo.saleEndStringMinutes", {"amount": String(Math.ceil(TimeUtil.secondsToMins(loc3)))});
			}
			return loc4;
		}

		public function get currencyName():String {
			switch (_priceCurrency) {
				case "0":
					return LineBuilder.getLocalizedStringFromKey("Currency.gold").toLowerCase();
				case "1":
					return LineBuilder.getLocalizedStringFromKey("Currency.fame").toLowerCase();
				default:
					return "";
			}
		}

		public function get infoImage():DisplayObject {
			return this._infoImage;
		}

		public function set infoImage(param1:DisplayObject):void {
			this._infoImage = param1;
		}

		public function get loader():LoaderProxy {
			return this._loader;
		}

		public function set loader(param1:LoaderProxy):void {
			this._loader = param1;
		}

		public function get infoImageLoader():LoaderProxy {
			return this._infoImageLoader;
		}

		public function set infoImageLoader(param1:LoaderProxy):void {
			this._infoImageLoader = param1;
		}

		public function get jackpots():String {
			return this._jackpots;
		}

		public function set jackpots(param1:String):void {
			this._jackpots = param1;
		}

		public function get rolls():int {
			return this._rolls;
		}

		public function set rolls(param1:int):void {
			this._rolls = param1;
		}

		public function get rollsContents():Vector.<Vector.<int>> {
			return this._rollsContents;
		}

		public function get displayedItems():String {
			return this._displayedItems;
		}

		public function set displayedItems(param1:String):void {
			this._displayedItems = param1;
		}
	}
}
