 
package kabam.rotmg.language.control {
	import kabam.lib.console.signals.RegisterConsoleActionSignal;
	import kabam.lib.console.vo.ConsoleAction;
	
	public class RegisterChangeLanguageViaConsoleCommand {
		 
		
		[Inject]
		public var registerConsoleAction:RegisterConsoleActionSignal;
		
		[Inject]
		public var setLanguage:SetLanguageSignal;
		
		public function RegisterChangeLanguageViaConsoleCommand() {
			super();
		}
		
		public function execute() : void {
			var loc1:ConsoleAction = null;
			loc1 = new ConsoleAction();
			loc1.name = "setlang";
			loc1.description = "Sets the locale language (defaults to en-US)";
			this.registerConsoleAction.dispatch(loc1,this.setLanguage);
		}
	}
}
