package kabam.rotmg.chat.view {
	import com.company.assembleegameclient.objects.Player;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;

	import kabam.rotmg.core.StaticInjectorContext;
	import kabam.rotmg.ui.model.HUDModel;

	public class ChatListItem extends Sprite {

		private static const CHAT_ITEM_TIMEOUT:uint = 20000;


		private var itemWidth:int;

		private var list:Vector.<DisplayObject>;

		private var count:uint;

		private var layoutHeight:uint;

		private var creationTime:uint;

		private var timedOutOverride:Boolean;

		public var playerObjectId:int;

		public var playerName:String = "";

		public var fromGuild:Boolean = false;

		public var isTrade:Boolean = false;

		public function ChatListItem(param1:Vector.<DisplayObject>, param2:int, param3:int, param4:Boolean, param5:int, param6:String, param7:Boolean, param8:Boolean) {
			super();
			mouseEnabled = true;
			this.itemWidth = param2;
			this.layoutHeight = param3;
			this.list = param1;
			this.count = param1.length;
			this.creationTime = getTimer();
			this.timedOutOverride = param4;
			this.playerObjectId = param5;
			this.playerName = param6;
			this.fromGuild = param7;
			this.isTrade = param8;
			this.layoutItems();
			this.addItems();
			addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, this.onRightMouseDown);
		}

		public function onRightMouseDown(param1:MouseEvent):void {
			var hmod:HUDModel = null;
			var aPlayer:Player = null;
			var e:MouseEvent = param1;
			try {
				hmod = StaticInjectorContext.getInjector().getInstance(HUDModel);
				if (hmod.gameSprite.map.goDict_[this.playerObjectId] != null && hmod.gameSprite.map.goDict_[this.playerObjectId] is Player && hmod.gameSprite.map.player_.objectId_ != this.playerObjectId) {
					aPlayer = hmod.gameSprite.map.goDict_[this.playerObjectId] as Player;
					hmod.gameSprite.addChatPlayerMenu(aPlayer, e.stageX, e.stageY);
				} else if (!this.isTrade && this.playerName != null && this.playerName != "" && hmod.gameSprite.map.player_.name_ != this.playerName) {
					hmod.gameSprite.addChatPlayerMenu(null, e.stageX, e.stageY, this.playerName, this.fromGuild);
				} else if (this.isTrade && this.playerName != null && this.playerName != "" && hmod.gameSprite.map.player_.name_ != this.playerName) {
					hmod.gameSprite.addChatPlayerMenu(null, e.stageX, e.stageY, this.playerName, false, true);
				}
				return;
			}
			catch (e:Error) {
				return;
			}
		}

		public function isTimedOut():Boolean {
			return getTimer() > this.creationTime + CHAT_ITEM_TIMEOUT || this.timedOutOverride;
		}

		private function layoutItems():void {
			var loc1:int = 0;
			var loc3:DisplayObject = null;
			var loc4:Rectangle = null;
			var loc5:int = 0;
			loc1 = 0;
			var loc2:int = 0;
			while (loc2 < this.count) {
				loc3 = this.list[loc2];
				loc4 = loc3.getRect(loc3);
				loc3.x = loc1;
				loc3.y = (this.layoutHeight - loc4.height) * 0.5 - this.layoutHeight;
				if (loc1 + loc4.width > this.itemWidth) {
					loc3.x = 0;
					loc1 = 0;
					loc5 = 0;
					while (loc5 < loc2) {
						this.list[loc5].y = this.list[loc5].y - this.layoutHeight;
						loc5++;
					}
				}
				loc1 = loc1 + loc4.width;
				loc2++;
			}
		}

		private function addItems():void {
			var loc1:DisplayObject = null;
			for each(loc1 in this.list) {
				addChild(loc1);
			}
		}
	}
}
