package kabam.rotmg.account.kongregate.services {
	import com.company.assembleegameclient.util.GUID;

	import flash.net.SharedObject;

	public class KongregateSharedObject {


		private var guid:String;

		public function KongregateSharedObject() {
			super();
		}

		public function getGuestGUID():String {
			return this.guid = this.guid || this.makeGuestGUID();
		}

		private function makeGuestGUID():String {
			var loc1:String = null;
			var loc2:SharedObject = null;
			try {
				loc2 = SharedObject.getLocal("KongregateRotMG", "/");
				if (loc2.data.hasOwnProperty("GuestGUID")) {
					loc1 = loc2.data["GuestGUID"];
				}
			}
			catch (error:Error) {
			}
			if (loc1 == null) {
				loc1 = GUID.create();
				try {
					loc2 = SharedObject.getLocal("KongregateRotMG", "/");
					loc2.data["GuestGUID"] = loc1;
					loc2.flush();
				}
				catch (error:Error) {
				}
			}
			return loc1;
		}
	}
}
