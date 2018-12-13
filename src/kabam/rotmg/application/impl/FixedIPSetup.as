package kabam.rotmg.application.impl {
	import com.company.assembleegameclient.parameters.Parameters;

	import kabam.rotmg.application.api.ApplicationSetup;

	public class FixedIPSetup implements ApplicationSetup {


		private const SERVER:String = "test.realmofthemadgod.com";

		private const UNENCRYPTED:String = "http://" + this.SERVER;

		private const ENCRYPTED:String = "https://" + this.SERVER;

		private const ANALYTICS:String = "UA-99999999-1";

		private const BUILD_LABEL:String = "<font color=\'#9900FF\'>{IP}</font> #{VERSION}";

		private var ipAddress:String;

		public function FixedIPSetup() {
			super();
		}

		public function setAddress(param1:String):FixedIPSetup {
			this.ipAddress = param1;
			return this;
		}

		public function getAppEngineUrl(param1:Boolean = false):String {
			return !!param1 ? this.UNENCRYPTED : this.ENCRYPTED;
		}

		public function getAnalyticsCode():String {
			return this.ANALYTICS;
		}

		public function isServerLocal():Boolean {
			return false;
		}

		public function getBuildLabel():String {
			var loc1:String = Parameters.BUILD_VERSION + "." + Parameters.MINOR_VERSION;
			return this.BUILD_LABEL.replace("{IP}", this.ipAddress).replace("{VERSION}", loc1);
		}

		public function useLocalTextures():Boolean {
			return true;
		}

		public function isToolingEnabled():Boolean {
			return true;
		}

		public function isGameLoopMonitored():Boolean {
			return true;
		}

		public function useProductionDialogs():Boolean {
			return false;
		}

		public function areErrorsReported():Boolean {
			return false;
		}

		public function areDeveloperHotkeysEnabled():Boolean {
			return true;
		}

		public function isDebug():Boolean {
			return false;
		}

		public function getServerDomain():String {
			return this.SERVER;
		}
	}
}
