 
package kabam.rotmg.arena.component {
	import com.company.assembleegameclient.ui.GuildText;
	import com.company.assembleegameclient.ui.panels.itemgrids.EquippedGrid;
	import com.company.assembleegameclient.ui.tooltip.ToolTip;
	import flash.display.Bitmap;
	import kabam.rotmg.arena.model.ArenaLeaderboardEntry;
	import kabam.rotmg.text.view.StaticTextDisplay;
	import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
	
	public class AbridgedPlayerTooltip extends ToolTip {
		 
		
		public function AbridgedPlayerTooltip(param1:ArenaLeaderboardEntry) {
			var loc5:GuildText = null;
			var loc2:Bitmap = new Bitmap();
			loc2.bitmapData = param1.playerBitmap;
			loc2.scaleX = 0.75;
			loc2.scaleY = 0.75;
			loc2.y = 5;
			addChild(loc2);
			var loc3:StaticTextDisplay = new StaticTextDisplay();
			loc3.setSize(14).setBold(true).setColor(16777215);
			loc3.setStringBuilder(new StaticStringBuilder(param1.name));
			loc3.x = 40;
			loc3.y = 5;
			addChild(loc3);
			if(param1.guildName) {
				loc5 = new GuildText(param1.guildName,param1.guildRank);
				loc5.x = 40;
				loc5.y = 20;
				addChild(loc5);
			}
			super(3552822,0.5,16777215,1);
			var loc4:EquippedGrid = new EquippedGrid(null,param1.slotTypes,null);
			loc4.x = 5;
			loc4.y = !!loc5?Number(loc5.y + loc5.height - 5):Number(55);
			loc4.setItems(param1.equipment);
			addChild(loc4);
		}
	}
}
