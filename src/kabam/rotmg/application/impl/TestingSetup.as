package kabam.rotmg.application.impl {
	import com.company.assembleegameclient.parameters.Parameters;

	import kabam.rotmg.application.api.ApplicationSetup;

	public class TestingSetup implements ApplicationSetup {


		private const SERVER:String = "test.realmofthemadgod.com";

		private const UNENCRYPTED:String = "http://" + this.SERVER;

		private const ENCRYPTED:String = "https://" + this.SERVER;

		private const ANALYTICS:String = "UA-101960510-4";

		private const BUILD_LABEL:String = "<font color=\'#FF0000\'>TESTING</font> #{VERSION}";

		public function TestingSetup() {
			super();
		}

		public function getAppEngineUrl(param1:Boolean = false):String {
			return this.ENCRYPTED;
		}

		public function getAnalyticsCode():String {
			return this.ANALYTICS;
		}

		public function getBuildLabel():String {
			var loc1:String = Parameters.BUILD_VERSION + "." + Parameters.MINOR_VERSION;
			return this.BUILD_LABEL.replace("{VERSION}", loc1);
		}

		public function useLocalTextures():Boolean {
			return true;
		}

		public function isServerLocal():Boolean {
			return false;
		}

		public function isToolingEnabled():Boolean {
			return true;
		}

		public function isGameLoopMonitored():Boolean {
			return true;
		}

		public function areErrorsReported():Boolean {
			return false;
		}

		public function useProductionDialogs():Boolean {
			return true;
		}

		public function areDeveloperHotkeysEnabled():Boolean {
			return false;
		}

		public function isDebug():Boolean {
			return false;
		}

		public function getServerDomain():String {
			return this.SERVER;
		}
	}
}
