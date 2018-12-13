 
package kabam.rotmg.application.model {
	import flash.net.LocalConnection;
	import flash.system.Security;
	
	public class DomainModel {
		 
		
		private const LOCALHOST:String = "localhost";
		
		private const PRODUCTION_WHITELIST:Array = ["www.realmofthemadgod.com","realmofthemadgodhrd.appspot.com","realmofthemadgod.appspot.com"];
		
		private const TESTING_WHITELIST:Array = ["test.realmofthemadgod.com","testing.realmofthemadgod.com","rotmgtesting.appspot.com","rotmghrdtesting.appspot.com"];
		
		private const TESTING2_WHITELIST:Array = ["realmtesting2.appspot.com","test2.realmofthemadgod.com"];
		
		private const TRANSLATION_WHITELIST:Array = ["xlate.kabam.com"];
		
		private const WHITELIST:Array = this.PRODUCTION_WHITELIST.concat(this.TESTING_WHITELIST).concat(this.TRANSLATION_WHITELIST).concat(this.TESTING2_WHITELIST);
		
		[Inject]
		public var client:PlatformModel;
		
		private var localDomain:String;
		
		public function DomainModel() {
			super();
		}
		
		public function applyDomainSecurity() : void {
			var loc1:String = null;
			for each(loc1 in this.WHITELIST) {
				Security.allowDomain(loc1);
			}
		}
		
		public function isLocalDomainValid() : Boolean {
			return this.client.isDesktop() || this.isLocalDomainInWhiteList();
		}
		
		public function isLocalDomainProduction() : Boolean {
			var loc1:String = this.getLocalDomain();
			return this.PRODUCTION_WHITELIST.indexOf(loc1) != -1;
		}
		
		private function isLocalDomainInWhiteList() : Boolean {
			var loc3:String = null;
			var loc1:String = this.getLocalDomain();
			var loc2:* = loc1 == this.LOCALHOST;
			for each(loc3 in this.WHITELIST) {
				loc2 = Boolean(loc2 || loc1 == loc3);
			}
			return loc2;
		}
		
		private function getLocalDomain() : String {
			return this.localDomain = this.localDomain || new LocalConnection().domain;
		}
	}
}
