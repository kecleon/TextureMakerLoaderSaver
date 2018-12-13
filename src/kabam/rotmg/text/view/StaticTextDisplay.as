package kabam.rotmg.text.view {
	import kabam.rotmg.core.StaticInjectorContext;
	import kabam.rotmg.text.model.FontModel;
	import kabam.rotmg.text.model.TextAndMapProvider;

	import org.swiftsuspenders.Injector;

	public class StaticTextDisplay extends TextDisplay {


		public function StaticTextDisplay() {
			var loc1:Injector = StaticInjectorContext.getInjector();
			super(loc1.getInstance(FontModel), loc1.getInstance(TextAndMapProvider));
		}
	}
}
