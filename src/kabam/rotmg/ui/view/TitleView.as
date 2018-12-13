 
package kabam.rotmg.ui.view {
	import com.company.assembleegameclient.screens.AccountScreen;
	import com.company.assembleegameclient.screens.TitleMenuOption;
	import com.company.assembleegameclient.ui.SoundIcon;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextFieldAutoSize;
	import kabam.rotmg.account.transfer.view.KabamLoginView;
	import kabam.rotmg.core.StaticInjectorContext;
	import kabam.rotmg.dialogs.control.OpenDialogSignal;
	import kabam.rotmg.text.model.TextKey;
	import kabam.rotmg.text.view.TextFieldDisplayConcrete;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;
	import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
	import kabam.rotmg.ui.model.EnvironmentData;
	import kabam.rotmg.ui.view.components.DarkLayer;
	import kabam.rotmg.ui.view.components.MenuOptionsBar;
	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeMappedSignal;
	
	public class TitleView extends Sprite {
		
		static var TitleScreenGraphic:Class = TitleView_TitleScreenGraphic;
		
		static var TitleScreenBackground:Class = TitleView_TitleScreenBackground;
		
		public static const MIDDLE_OF_BOTTOM_BAND:Number = 589.45;
		
		public static var queueEmailConfirmation:Boolean = false;
		
		public static var queuePasswordPrompt:Boolean = false;
		
		public static var queuePasswordPromptFull:Boolean = false;
		
		public static var queueRegistrationPrompt:Boolean = false;
		
		public static var kabammigrateOpened:Boolean = false;
		 
		
		private var versionText:TextFieldDisplayConcrete;
		
		private var copyrightText:TextFieldDisplayConcrete;
		
		private var menuOptionsBar:MenuOptionsBar;
		
		private var data:EnvironmentData;
		
		public var playClicked:Signal;
		
		public var serversClicked:Signal;
		
		public var accountClicked:Signal;
		
		public var legendsClicked:Signal;
		
		public var languagesClicked:Signal;
		
		public var supportClicked:Signal;
		
		public var kabamTransferClicked:Signal;
		
		public var editorClicked:Signal;
		
		public var quitClicked:Signal;
		
		public var optionalButtonsAdded:Signal;
		
		private var migrateButton:TitleMenuOption;
		
		public function TitleView() {
			this.menuOptionsBar = this.makeMenuOptionsBar();
			this.optionalButtonsAdded = new Signal();
			super();
			addChild(new TitleScreenBackground());
			addChild(new DarkLayer());
			addChild(new TitleScreenGraphic());
			addChild(this.menuOptionsBar);
			addChild(new AccountScreen());
			this.makeChildren();
			addChild(new SoundIcon());
		}
		
		public function openKabamTransferView() : void {
			var loc1:OpenDialogSignal = StaticInjectorContext.getInjector().getInstance(OpenDialogSignal);
			loc1.dispatch(new KabamLoginView());
		}
		
		private function makeMenuOptionsBar() : MenuOptionsBar {
			var loc1:TitleMenuOption = ButtonFactory.getPlayButton();
			var loc2:TitleMenuOption = ButtonFactory.getServersButton();
			var loc3:TitleMenuOption = ButtonFactory.getAccountButton();
			var loc4:TitleMenuOption = ButtonFactory.getLegendsButton();
			var loc5:TitleMenuOption = ButtonFactory.getSupportButton();
			this.playClicked = loc1.clicked;
			this.serversClicked = loc2.clicked;
			this.accountClicked = loc3.clicked;
			this.legendsClicked = loc4.clicked;
			this.supportClicked = loc5.clicked;
			var loc6:MenuOptionsBar = new MenuOptionsBar();
			loc6.addButton(loc1,MenuOptionsBar.CENTER);
			loc6.addButton(loc2,MenuOptionsBar.LEFT);
			loc6.addButton(loc5,MenuOptionsBar.LEFT);
			loc6.addButton(loc3,MenuOptionsBar.RIGHT);
			loc6.addButton(loc4,MenuOptionsBar.RIGHT);
			return loc6;
		}
		
		private function makeChildren() : void {
			this.versionText = this.makeText().setHTML(true).setAutoSize(TextFieldAutoSize.LEFT).setVerticalAlign(TextFieldDisplayConcrete.MIDDLE);
			this.versionText.y = MIDDLE_OF_BOTTOM_BAND;
			addChild(this.versionText);
			this.copyrightText = this.makeText().setAutoSize(TextFieldAutoSize.RIGHT).setVerticalAlign(TextFieldDisplayConcrete.MIDDLE);
			this.copyrightText.setStringBuilder(new LineBuilder().setParams(TextKey.COPYRIGHT));
			this.copyrightText.filters = [new DropShadowFilter(0,0,0)];
			this.copyrightText.x = 800;
			this.copyrightText.y = MIDDLE_OF_BOTTOM_BAND;
			addChild(this.copyrightText);
		}
		
		public function makeText() : TextFieldDisplayConcrete {
			var loc1:TextFieldDisplayConcrete = new TextFieldDisplayConcrete().setSize(12).setColor(8355711);
			loc1.filters = [new DropShadowFilter(0,0,0)];
			return loc1;
		}
		
		public function initialize(param1:EnvironmentData) : void {
			this.data = param1;
			this.updateVersionText();
			this.handleOptionalButtons();
		}
		
		public function putNoticeTagToOption(param1:TitleMenuOption, param2:String, param3:int = 14, param4:uint = 10092390, param5:Boolean = true) : void {
			param1.createNoticeTag(param2,param3,param4,param5);
		}
		
		private function updateVersionText() : void {
			this.versionText.setStringBuilder(new StaticStringBuilder(this.data.buildLabel));
		}
		
		private function handleOptionalButtons() : void {
			this.data.canMapEdit && this.createEditorButton();
			this.data.isDesktop && this.createQuitButton();
			this.optionalButtonsAdded.dispatch();
		}
		
		private function createQuitButton() : void {
			var loc1:TitleMenuOption = ButtonFactory.getQuitButton();
			this.menuOptionsBar.addButton(loc1,MenuOptionsBar.RIGHT);
			this.quitClicked = loc1.clicked;
		}
		
		private function createEditorButton() : void {
			var loc1:TitleMenuOption = ButtonFactory.getEditorButton();
			this.menuOptionsBar.addButton(loc1,MenuOptionsBar.RIGHT);
			this.editorClicked = loc1.clicked;
		}
		
		private function makeMigrateButton() : void {
			this.migrateButton = new TitleMenuOption("Want to migrate your Kabam.com account?",16,false);
			this.migrateButton.setAutoSize(TextFieldAutoSize.CENTER);
			this.kabamTransferClicked = new NativeMappedSignal(this.migrateButton,MouseEvent.CLICK);
			this.migrateButton.setTextKey("Want to migrate your Kabam.com account?");
			this.migrateButton.x = 400;
			this.migrateButton.y = 500;
		}
	}
}
