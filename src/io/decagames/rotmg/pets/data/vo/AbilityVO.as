package io.decagames.rotmg.pets.data.vo {
	import com.company.assembleegameclient.objects.ObjectLibrary;

	import org.osflash.signals.Signal;

	public class AbilityVO {


		private var _type:uint;

		private var _staticData:XML;

		public const updated:Signal = new Signal(AbilityVO);

		public var level:int;

		public var points:int;

		public var name:String;

		public var description:String;

		private var unlocked:Boolean;

		public function AbilityVO() {
			super();
		}

		public function set type(param1:uint):void {
			this._type = param1;
			this._staticData = ObjectLibrary.getPetDataXMLByType(this._type);
			this.name = this._staticData.DisplayId == undefined ? this._staticData.@id : this._staticData.DisplayId;
			this.description = this._staticData.Description;
		}

		public function setUnlocked(param1:Boolean):void {
			this.unlocked = param1;
		}

		public function getUnlocked():Boolean {
			return this.unlocked;
		}

		public function clone():AbilityVO {
			var loc1:AbilityVO = new AbilityVO();
			loc1.type = this._type;
			loc1.level = this.level;
			loc1.points = this.points;
			loc1.setUnlocked(this.getUnlocked());
			return loc1;
		}

		public function toString():String {
			return "[AbilityVO] Name: " + this.name + ", level:" + this.level + ", unlocked? " + (!!this.getUnlocked() ? "yes" : "no");
		}
	}
}
