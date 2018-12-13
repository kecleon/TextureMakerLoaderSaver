package kabam.rotmg.game.focus.view {
	import com.company.assembleegameclient.game.GameSprite;
	import com.company.assembleegameclient.objects.GameObject;

	import flash.utils.Dictionary;

	import kabam.rotmg.game.focus.control.SetGameFocusSignal;

	import robotlegs.bender.bundles.mvcs.Mediator;

	public class GameFocusMediator extends Mediator {


		[Inject]
		public var signal:SetGameFocusSignal;

		[Inject]
		public var view:GameSprite;

		public function GameFocusMediator() {
			super();
		}

		override public function initialize():void {
			this.signal.add(this.onSetGameFocus);
		}

		override public function destroy():void {
			this.signal.remove(this.onSetGameFocus);
		}

		private function onSetGameFocus(param1:String = ""):void {
			this.view.setFocus(this.getFocusById(param1));
		}

		private function getFocusById(param1:String):GameObject {
			var loc3:GameObject = null;
			if (param1 == "") {
				return this.view.map.player_;
			}
			var loc2:Dictionary = this.view.map.goDict_;
			for each(loc3 in loc2) {
				if (loc3.name_ == param1) {
					return loc3;
				}
			}
			return this.view.map.player_;
		}
	}
}
