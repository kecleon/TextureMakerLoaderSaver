package kabam.rotmg.death.view {
	import com.company.assembleegameclient.game.GameSprite;
	import com.company.assembleegameclient.objects.Player;

	import flash.utils.Dictionary;

	import kabam.rotmg.death.control.ZombifySignal;
	import kabam.rotmg.game.signals.SetWorldInteractionSignal;
	import kabam.rotmg.messaging.impl.incoming.Death;

	import robotlegs.bender.bundles.mvcs.Mediator;

	public class ZombifyGameMediator extends Mediator {


		[Inject]
		public var view:GameSprite;

		[Inject]
		public var zombify:ZombifySignal;

		[Inject]
		public var setWorldInteraction:SetWorldInteractionSignal;

		public function ZombifyGameMediator() {
			super();
		}

		override public function initialize():void {
			this.zombify.add(this.onZombify);
		}

		override public function destroy():void {
			this.zombify.remove(this.onZombify);
		}

		private function onZombify(param1:Death):void {
			this.removePlayer();
			this.setZombieAsViewFocus(param1);
			this.setWorldInteraction.dispatch(false);
		}

		private function removePlayer():void {
			var loc1:Player = this.view.map.player_;
			loc1 && this.view.map.removeObj(loc1.objectId_);
			this.view.map.player_ = null;
		}

		private function setZombieAsViewFocus(param1:Death):void {
			var loc2:Dictionary = this.view.map.goDict_;
			loc2 && this.view.setFocus(loc2[param1.zombieId]);
		}
	}
}
