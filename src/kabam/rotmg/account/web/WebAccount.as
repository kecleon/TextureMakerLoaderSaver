package kabam.rotmg.account.web {
	import com.company.assembleegameclient.parameters.Parameters;
	import com.company.assembleegameclient.util.GUID;

	import flash.external.ExternalInterface;
	import flash.net.SharedObject;

	import kabam.rotmg.account.core.Account;

	public class WebAccount implements Account {

		public static const NETWORK_NAME:String = "rotmg";

		private static const WEB_USER_ID:String = "";

		private static const WEB_PLAY_PLATFORM_NAME:String = "rotmg";


		private var userId:String = "";

		private var password:String;

		private var token:String = "";

		private var entryTag:String = "";

		private var isVerifiedEmail:Boolean;

		private var platformToken:String;

		private var _userDisplayName:String = "";

		private var _rememberMe:Boolean = true;

		private var _paymentProvider:String = "";

		private var _paymentData:String = "";

		public var signedRequest:String;

		public var kabamId:String;

		public function WebAccount() {
			super();
			try {
				this.entryTag = ExternalInterface.call("rotmg.UrlLib.getParam", "entrypt");
				return;
			}
			catch (error:Error) {
				return;
			}
		}

		public function getUserName():String {
			return this.userId;
		}

		public function getUserId():String {
			return this.userId = this.userId || GUID.create();
		}

		public function getPassword():String {
			return this.password || "";
		}

		public function getToken():String {
			return "";
		}

		public function getCredentials():Object {
			return {
				"guid": this.getUserId(),
				"password": this.getPassword()
			};
		}

		public function isRegistered():Boolean {
			return this.getPassword() != "" || this.getToken() != "";
		}

		public function updateUser(param1:String, param2:String, param3:String):void {
			var loc4:SharedObject = null;
			this.userId = param1;
			this.password = param2;
			this.token = param3;
			try {
				if (this._rememberMe) {
					loc4 = SharedObject.getLocal("RotMG", "/");
					loc4.data["GUID"] = param1;
					loc4.data["Token"] = param3;
					loc4.data["Password"] = param2;
					loc4.flush();
				}
				return;
			}
			catch (error:Error) {
				return;
			}
		}

		public function clear():void {
			this._rememberMe = true;
			this.updateUser(GUID.create(), null, null);
			Parameters.sendLogin_ = true;
			Parameters.data_.charIdUseMap = {};
			Parameters.save();
		}

		public function reportIntStat(param1:String, param2:int):void {
		}

		public function getRequestPrefix():String {
			return "/credits";
		}

		public function gameNetworkUserId():String {
			return WEB_USER_ID;
		}

		public function gameNetwork():String {
			return NETWORK_NAME;
		}

		public function playPlatform():String {
			return WEB_PLAY_PLATFORM_NAME;
		}

		public function getEntryTag():String {
			return this.entryTag || "";
		}

		public function getSecret():String {
			return "";
		}

		public function verify(param1:Boolean):void {
			this.isVerifiedEmail = param1;
		}

		public function isVerified():Boolean {
			return this.isVerifiedEmail;
		}

		public function getPlatformToken():String {
			return this.platformToken || "";
		}

		public function setPlatformToken(param1:String):void {
			this.platformToken = param1;
		}

		public function getMoneyAccessToken():String {
			return this.signedRequest;
		}

		public function getMoneyUserId():String {
			return this.kabamId;
		}

		public function get userDisplayName():String {
			return this._userDisplayName;
		}

		public function set userDisplayName(param1:String):void {
			this._userDisplayName = param1;
		}

		public function set rememberMe(param1:Boolean):void {
			this._rememberMe = param1;
		}

		public function get rememberMe():Boolean {
			return this._rememberMe;
		}

		public function set paymentProvider(param1:String):void {
			this._paymentProvider = param1;
		}

		public function get paymentProvider():String {
			return this._paymentProvider;
		}

		public function set paymentData(param1:String):void {
			this._paymentData = param1;
		}

		public function get paymentData():String {
			return this._paymentData;
		}
	}
}
