package kabam.rotmg.servers.model {
	import com.company.assembleegameclient.parameters.Parameters;

	import kabam.rotmg.core.model.PlayerModel;
	import kabam.rotmg.servers.api.LatLong;
	import kabam.rotmg.servers.api.Server;
	import kabam.rotmg.servers.api.ServerModel;

	public class LiveServerModel implements ServerModel {


		[Inject]
		public var model:PlayerModel;

		private var _descendingFlag:Boolean;

		private const servers:Vector.<Server> = new Vector.<Server>(0);

		public function LiveServerModel() {
			super();
		}

		public function setServers(param1:Vector.<Server>):void {
			var loc2:Server = null;
			this.servers.length = 0;
			for each(loc2 in param1) {
				this.servers.push(loc2);
			}
			this._descendingFlag = false;
			this.servers.sort(this.compareServerName);
		}

		public function getServers():Vector.<Server> {
			return this.servers;
		}

		public function getServer():Server {
			var loc6:Server = null;
			var loc7:int = 0;
			var loc8:Number = NaN;
			var loc1:Boolean = this.model.isAdmin();
			var loc2:LatLong = this.model.getMyPos();
			var loc3:Server = null;
			var loc4:Number = Number.MAX_VALUE;
			var loc5:int = int.MAX_VALUE;
			for each(loc6 in this.servers) {
				if (!(loc6.isFull() && !loc1)) {
					if (loc6.name == Parameters.data_.preferredServer) {
						return loc6;
					}
					loc7 = loc6.priority();
					loc8 = LatLong.distance(loc2, loc6.latLong);
					if (loc7 < loc5 || loc7 == loc5 && loc8 < loc4) {
						loc3 = loc6;
						loc4 = loc8;
						loc5 = loc7;
						Parameters.data_.bestServer = loc3.name;
						Parameters.save();
					}
				}
			}
			return loc3;
		}

		public function getServerNameByAddress(param1:String):String {
			var loc2:Server = null;
			for each(loc2 in this.servers) {
				if (loc2.address == param1) {
					return loc2.name;
				}
			}
			return "";
		}

		public function isServerAvailable():Boolean {
			return this.servers.length > 0;
		}

		private function compareServerName(param1:Server, param2:Server):int {
			if (param1.name < param2.name) {
				return !!this._descendingFlag ? -1 : 1;
			}
			if (param1.name > param2.name) {
				return !!this._descendingFlag ? 1 : -1;
			}
			return 0;
		}
	}
}
