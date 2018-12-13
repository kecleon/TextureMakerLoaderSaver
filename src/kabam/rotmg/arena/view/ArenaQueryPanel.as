 
package kabam.rotmg.arena.view {
	import com.company.assembleegameclient.game.GameSprite;
	import com.company.assembleegameclient.ui.DeprecatedTextButton;
	import com.company.assembleegameclient.ui.panels.Panel;
	import flash.display.Bitmap;
	import kabam.rotmg.arena.util.ArenaViewAssetFactory;
	import kabam.rotmg.text.view.TextFieldDisplayConcrete;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;
	import kabam.rotmg.ui.view.SignalWaiter;
	
	public class ArenaQueryPanel extends Panel {
		 
		
		private const titleText:TextFieldDisplayConcrete = ArenaViewAssetFactory.returnTextfield(16777215,16,true);
		
		private var icon:Bitmap;
		
		var infoButton:DeprecatedTextButton;
		
		var enterButton:DeprecatedTextButton;
		
		private var title:String = "ArenaQueryPanel.title";
		
		private var infoButtonString:String = "Pets.caretakerPanelButtonInfo";
		
		private var upgradeYardButtonString:String = "ArenaQueryPanel.leaderboard";
		
		private var waiter:SignalWaiter;
		
		var type:uint;
		
		public function ArenaQueryPanel(param1:GameSprite, param2:uint) {
			this.waiter = new SignalWaiter();
			this.type = param2;
			super(param1);
			this.waiter.complete.addOnce(this.alignButton);
			this.handleIcon();
			this.handleTitleText();
			this.handleInfoButton();
			this.handleEnterButton();
		}
		
		private function handleInfoButton() : void {
			this.infoButton = new DeprecatedTextButton(16,this.infoButtonString);
			this.waiter.push(this.infoButton.textChanged);
			addChild(this.infoButton);
		}
		
		private function handleTitleText() : void {
			this.titleText.setStringBuilder(new LineBuilder().setParams(this.title));
			this.titleText.x = 65;
			this.titleText.y = 28;
			addChild(this.titleText);
		}
		
		private function handleEnterButton() : void {
			this.enterButton = new DeprecatedTextButton(16,this.upgradeYardButtonString);
			this.waiter.push(this.enterButton.textChanged);
			addChild(this.enterButton);
		}
		
		private function handleIcon() : void {
			this.icon = ArenaViewAssetFactory.returnHostBitmap(this.type);
			addChild(this.icon);
			this.icon.x = 5;
		}
		
		private function alignButton() : void {
			var loc1:int = 15;
			var loc2:int = this.infoButton.width + loc1 + this.enterButton.width;
			this.infoButton.x = WIDTH / 2 - loc2 / 2;
			this.enterButton.x = this.infoButton.x + this.infoButton.width + loc1;
			this.enterButton.y = HEIGHT - this.enterButton.height - 4;
			this.infoButton.y = HEIGHT - this.infoButton.height - 4;
		}
	}
}
