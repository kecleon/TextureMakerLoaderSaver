package {
	import com.company.assembleegameclient.parameters.Parameters;
	import com.company.assembleegameclient.util.AssetLoader;

	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	import kabam.lib.console.ConsoleExtension;
	import kabam.rotmg.account.AccountConfig;
	import kabam.rotmg.appengine.AppEngineConfig;
	import kabam.rotmg.application.ApplicationConfig;
	import kabam.rotmg.build.BuildConfig;
	import kabam.rotmg.core.StaticInjectorContext;
	import kabam.rotmg.editor.EditorConfig;
	import kabam.rotmg.errors.ErrorConfig;
	import kabam.rotmg.language.LanguageConfig;
	import kabam.rotmg.servers.ServersConfig;
	import kabam.rotmg.startup.StartupConfig;
	import kabam.rotmg.startup.control.StartupSignal;
	import kabam.rotmg.text.TextConfig;

	import robotlegs.bender.bundles.mvcs.MVCSBundle;
	import robotlegs.bender.extensions.signalCommandMap.SignalCommandMapExtension;
	import robotlegs.bender.framework.api.LogLevel;

	[SWF(frameRate="60", backgroundColor="#000000", width="800", height="600")]
	public class EditorMain extends Sprite {


		private var context:StaticInjectorContext;

		public function EditorMain() {
			super();
			if (stage) {
				this.setup();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
			}
		}

		private function onAddedToStage(param1:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
			this.setup();
		}

		private function setup():void {
			this.hackParameters();
			this.createContext();
			new AssetLoader().load();
			stage.scaleMode = StageScaleMode.EXACT_FIT;
			this.context.injector.getInstance(StartupSignal).dispatch();
		}

		private function hackParameters():void {
			Parameters.root = stage.root;
		}

		private function createContext():void {
			this.context = new StaticInjectorContext();
			this.context.injector.map(LoaderInfo).toValue(root.stage.root.loaderInfo);
			this.context.extend(MVCSBundle).extend(SignalCommandMapExtension).extend(ConsoleExtension).configure(BuildConfig).configure(StartupConfig).configure(ApplicationConfig).configure(AppEngineConfig).configure(AccountConfig).configure(ErrorConfig).configure(ServersConfig).configure(EditorConfig).configure(LanguageConfig).configure(TextConfig).configure(this);
			this.context.logLevel = LogLevel.DEBUG;
		}
	}
}
