 
package kabam.rotmg.chat.view {
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import kabam.rotmg.chat.model.ChatModel;
	
	public class ChatList extends Sprite {
		 
		
		private var listItems:Vector.<ChatListItem>;
		
		private var visibleItems:Vector.<ChatListItem>;
		
		private var visibleItemCount:int;
		
		private var index:int;
		
		private var isCurrent:Boolean;
		
		private const timer:Timer = new Timer(1000);
		
		private const itemsToRemove:Vector.<ChatListItem> = new Vector.<ChatListItem>();
		
		private var ignoreTimeOuts:Boolean = false;
		
		private var maxLength:int;
		
		public function ChatList(param1:int = 7, param2:uint = 150) {
			super();
			mouseEnabled = true;
			mouseChildren = true;
			this.listItems = new Vector.<ChatListItem>();
			this.visibleItems = new Vector.<ChatListItem>();
			this.visibleItemCount = param1;
			this.maxLength = param2;
			this.index = 0;
			this.isCurrent = true;
			this.timer.addEventListener(TimerEvent.TIMER,this.onCheckTimeout);
			this.timer.start();
		}
		
		private function onCheckTimeout(param1:TimerEvent) : void {
			var loc2:ChatListItem = null;
			var loc3:ChatListItem = null;
			for each(loc2 in this.visibleItems) {
				if(loc2.isTimedOut() && !this.ignoreTimeOuts) {
					this.itemsToRemove.push(loc2);
					continue;
				}
				break;
			}
			while(this.itemsToRemove.length > 0) {
				this.onItemTimedOut(this.itemsToRemove.pop());
				if(!this.isCurrent) {
					loc3 = this.listItems[this.index++];
					if(!loc3.isTimedOut()) {
						this.addNewItem(loc3);
						this.isCurrent = this.index == this.listItems.length;
						this.positionItems();
					}
				}
			}
		}
		
		public function setup(param1:ChatModel) : void {
			this.visibleItemCount = param1.visibleItemCount;
		}
		
		public function addMessage(param1:ChatListItem) : void {
			var loc2:ChatListItem = null;
			if(this.listItems.length > this.maxLength) {
				loc2 = this.listItems.shift();
				this.onItemTimedOut(loc2);
				this.index--;
				if(!this.isCurrent && this.index < this.visibleItemCount) {
					this.pageDown();
				}
			}
			this.listItems.push(param1);
			if(this.isCurrent) {
				this.displayNewItem(param1);
			}
		}
		
		private function onItemTimedOut(param1:ChatListItem) : void {
			var loc2:int = this.visibleItems.indexOf(param1);
			if(loc2 != -1) {
				removeChild(param1);
				this.visibleItems.splice(loc2,1);
				this.isCurrent = this.index == this.listItems.length;
			}
		}
		
		private function displayNewItem(param1:ChatListItem) : void {
			this.index++;
			this.addNewItem(param1);
			this.removeOldestVisibleIfNeeded();
			this.positionItems();
		}
		
		public function scrollUp() : void {
			if(this.ignoreTimeOuts && this.canScrollUp()) {
				this.scrollItemsUp();
			} else {
				this.showAvailable();
			}
			this.ignoreTimeOuts = true;
		}
		
		public function showAvailable() : void {
			var loc4:ChatListItem = null;
			var loc1:int = this.index - this.visibleItems.length - 1;
			var loc2:int = Math.max(0,this.index - this.visibleItemCount - 1);
			var loc3:int = loc1;
			while(loc3 > loc2) {
				loc4 = this.listItems[loc3];
				if(this.visibleItems.indexOf(loc4) == -1) {
					this.addOldItem(loc4);
				}
				loc3--;
			}
			this.positionItems();
		}
		
		public function scrollDown() : void {
			if(this.ignoreTimeOuts) {
				this.ignoreTimeOuts = false;
				this.scrollToCurrent();
				this.onCheckTimeout(null);
			}
			if(!this.isCurrent) {
				this.scrollItemsDown();
			} else if(this.ignoreTimeOuts) {
				this.ignoreTimeOuts = false;
			}
		}
		
		public function scrollToCurrent() : void {
			while(!this.isCurrent) {
				this.scrollItemsDown();
			}
		}
		
		public function pageUp() : void {
			var loc1:int = 0;
			if(!this.ignoreTimeOuts) {
				this.showAvailable();
				this.ignoreTimeOuts = true;
			} else {
				loc1 = 0;
				while(loc1 < this.visibleItemCount) {
					if(this.canScrollUp()) {
						this.scrollItemsUp();
						loc1++;
						continue;
					}
					break;
				}
			}
		}
		
		public function pageDown() : void {
			var loc1:int = 0;
			while(loc1 < this.visibleItemCount) {
				if(!this.isCurrent) {
					this.scrollItemsDown();
					loc1++;
					continue;
				}
				this.ignoreTimeOuts = false;
				break;
			}
		}
		
		private function addNewItem(param1:ChatListItem) : void {
			this.visibleItems.push(param1);
			addChild(param1);
		}
		
		private function removeOldestVisibleIfNeeded() : void {
			if(this.visibleItems.length > this.visibleItemCount) {
				removeChild(this.visibleItems.shift());
			}
		}
		
		private function canScrollUp() : Boolean {
			return this.index > this.visibleItemCount;
		}
		
		private function scrollItemsUp() : void {
			var loc1:ChatListItem = this.listItems[--this.index - this.visibleItemCount];
			this.addOldItem(loc1);
			this.removeNewestVisibleIfNeeded();
			this.positionItems();
			this.isCurrent = false;
		}
		
		private function scrollItemsDown() : void {
			if(this.index < 0) {
				this.index = 0;
			}
			var loc1:ChatListItem = this.listItems[this.index];
			this.index++;
			this.addNewItem(loc1);
			this.removeOldestVisibleIfNeeded();
			this.isCurrent = this.index == this.listItems.length;
			this.positionItems();
		}
		
		private function addOldItem(param1:ChatListItem) : void {
			this.visibleItems.unshift(param1);
			addChild(param1);
		}
		
		private function removeNewestVisibleIfNeeded() : void {
			if(this.visibleItems.length > this.visibleItemCount) {
				removeChild(this.visibleItems.pop());
			}
		}
		
		private function positionItems() : void {
			var loc3:ChatListItem = null;
			var loc1:int = 0;
			var loc2:int = this.visibleItems.length;
			while(loc2--) {
				loc3 = this.visibleItems[loc2];
				loc3.y = loc1;
				loc1 = loc1 - loc3.height;
			}
		}
	}
}
