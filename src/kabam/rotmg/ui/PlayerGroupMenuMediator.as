 
package kabam.rotmg.ui {
	import com.company.assembleegameclient.parameters.Parameters;
	import com.company.assembleegameclient.ui.menu.PlayerGroupMenu;
	import kabam.rotmg.chat.model.ChatMessage;
	import kabam.rotmg.core.StaticInjectorContext;
	import kabam.rotmg.game.signals.AddTextLineSignal;
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	public class PlayerGroupMenuMediator extends Mediator {
		 
		
		[Inject]
		public var view:PlayerGroupMenu;
		
		public function PlayerGroupMenuMediator() {
			super();
		}
		
		override public function initialize() : void {
			this.view.unableToTeleport.add(this.onUnableToTeleport);
		}
		
		override public function destroy() : void {
			this.view.unableToTeleport.remove(this.onUnableToTeleport);
		}
		
		private function onUnableToTeleport() : void {
			var loc1:Injector = StaticInjectorContext.getInjector();
			var loc2:AddTextLineSignal = loc1.getInstance(AddTextLineSignal);
			loc2.dispatch(ChatMessage.make(Parameters.ERROR_CHAT_NAME,"No players are eligible for teleporting."));
		}
	}
}
