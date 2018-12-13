 
package com.company.assembleegameclient.util {
	import com.company.util.AssetLibrary;
	import flash.display.BitmapData;
	import kabam.rotmg.text.model.TextKey;
	
	public class GuildUtil {
		
		public static const INITIATE:int = 0;
		
		public static const MEMBER:int = 10;
		
		public static const OFFICER:int = 20;
		
		public static const LEADER:int = 30;
		
		public static const FOUNDER:int = 40;
		
		public static const MAX_MEMBERS:int = 50;
		 
		
		public function GuildUtil() {
			super();
		}
		
		public static function rankToString(param1:int) : String {
			switch(param1) {
				case INITIATE:
					return wrapInBraces(TextKey.GUILD_RANK_INITIATE);
				case MEMBER:
					return wrapInBraces(TextKey.GUILD_RANK_MEMBER);
				case OFFICER:
					return wrapInBraces(TextKey.GUILD_RANK_OFFICER);
				case LEADER:
					return wrapInBraces(TextKey.GUILD_RANK_LEADER);
				case FOUNDER:
					return wrapInBraces(TextKey.GUILD_RANK_FOUNDER);
				default:
					return wrapInBraces(TextKey.GUILD_RANK_UNKNOWN);
			}
		}
		
		private static function wrapInBraces(param1:String) : String {
			return "{" + param1 + "}";
		}
		
		public static function rankToIcon(param1:int, param2:int) : BitmapData {
			var loc3:BitmapData = null;
			switch(param1) {
				case INITIATE:
					loc3 = AssetLibrary.getImageFromSet("lofiInterfaceBig",20);
					break;
				case MEMBER:
					loc3 = AssetLibrary.getImageFromSet("lofiInterfaceBig",19);
					break;
				case OFFICER:
					loc3 = AssetLibrary.getImageFromSet("lofiInterfaceBig",18);
					break;
				case LEADER:
					loc3 = AssetLibrary.getImageFromSet("lofiInterfaceBig",17);
					break;
				case FOUNDER:
					loc3 = AssetLibrary.getImageFromSet("lofiInterfaceBig",16);
			}
			return TextureRedrawer.redraw(loc3,param2,true,0,true);
		}
		
		public static function guildFameIcon(param1:int) : BitmapData {
			var loc2:BitmapData = AssetLibrary.getImageFromSet("lofiObj3",226);
			return TextureRedrawer.redraw(loc2,param1,true,0,true);
		}
		
		public static function allowedChange(param1:int, param2:int, param3:int) : Boolean {
			if(param2 == param3) {
				return false;
			}
			if(param1 == FOUNDER && param2 < FOUNDER && param3 < FOUNDER) {
				return true;
			}
			if(param1 == LEADER && param2 < LEADER && param3 <= LEADER) {
				return true;
			}
			if(param1 == OFFICER && param2 < OFFICER && param3 < OFFICER) {
				return true;
			}
			return false;
		}
		
		public static function promotedRank(param1:int) : int {
			switch(param1) {
				case INITIATE:
					return MEMBER;
				case MEMBER:
					return OFFICER;
				case OFFICER:
					return LEADER;
				default:
					return FOUNDER;
			}
		}
		
		public static function canPromote(param1:int, param2:int) : Boolean {
			var loc3:int = promotedRank(param2);
			return allowedChange(param1,param2,loc3);
		}
		
		public static function demotedRank(param1:int) : int {
			switch(param1) {
				case OFFICER:
					return MEMBER;
				case LEADER:
					return OFFICER;
				case FOUNDER:
					return LEADER;
				default:
					return INITIATE;
			}
		}
		
		public static function canDemote(param1:int, param2:int) : Boolean {
			var loc3:int = demotedRank(param2);
			return allowedChange(param1,param2,loc3);
		}
		
		public static function canRemove(param1:int, param2:int) : Boolean {
			return param1 >= OFFICER && param2 < param1;
		}
		
		public static function getRankIconIdByRank(param1:int) : Number {
			var loc2:Number = NaN;
			switch(param1) {
				case INITIATE:
					loc2 = 20;
					break;
				case MEMBER:
					loc2 = 19;
					break;
				case OFFICER:
					loc2 = 18;
					break;
				case LEADER:
					loc2 = 17;
					break;
				case FOUNDER:
					loc2 = 16;
			}
			return loc2;
		}
	}
}
