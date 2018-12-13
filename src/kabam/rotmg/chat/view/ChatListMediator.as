package kabam.rotmg.chat.view {
	import com.company.assembleegameclient.parameters.Parameters;

	import kabam.rotmg.application.api.ApplicationSetup;
	import kabam.rotmg.chat.control.AddChatSignal;
	import kabam.rotmg.chat.control.ScrollListSignal;
	import kabam.rotmg.chat.control.ShowChatInputSignal;
	import kabam.rotmg.chat.model.ChatMessage;
	import kabam.rotmg.chat.model.ChatModel;

	import robotlegs.bender.bundles.mvcs.Mediator;

	public class ChatListMediator extends Mediator {


		[Inject]
		public var view:ChatList;

		[Inject]
		public var model:ChatModel;

		[Inject]
		public var showChatInput:ShowChatInputSignal;

		[Inject]
		public var scrollList:ScrollListSignal;

		[Inject]
		public var addChat:AddChatSignal;

		[Inject]
		public var itemFactory:ChatListItemFactory;

		[Inject]
		public var setup:ApplicationSetup;

		public function ChatListMediator() {
			super();
		}

		override public function initialize():void {
			var loc1:ChatMessage = null;
			this.view.setup(this.model);
			for each(loc1 in this.model.chatMessages) {
				this.view.addMessage(this.itemFactory.make(loc1, true));
			}
			this.view.scrollToCurrent();
			this.showChatInput.add(this.onShowChatInput);
			this.scrollList.add(this.onScrollList);
			this.addChat.add(this.onAddChat);
			this.onAddChat(ChatMessage.make(Parameters.CLIENT_CHAT_NAME, this.getChatLabel()));
		}

		override public function destroy():void {
			this.showChatInput.remove(this.onShowChatInput);
			this.scrollList.remove(this.onScrollList);
			this.addChat.remove(this.onAddChat);
		}

		private function onShowChatInput(param1:Boolean, param2:String):void {
			this.view.y = this.model.bounds.height - (!!param1 ? this.model.lineHeight : 0);
		}

		private function onScrollList(param1:int):void {
			if (param1 > 0) {
				this.view.pageDown();
			} else if (param1 < 0) {
				this.view.pageUp();
			}
		}

		private function onAddChat(param1:ChatMessage):void {
			this.view.addMessage(this.itemFactory.make(param1));
		}

		private function getChatLabel():String {
			var loc1:String = this.setup.getBuildLabel();
			loc1 = loc1.replace(/<font .+>(.+)<\/font>/g, "$1");
			return loc1;
		}
	}
}
