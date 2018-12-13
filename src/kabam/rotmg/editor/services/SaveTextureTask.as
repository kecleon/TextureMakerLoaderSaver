package kabam.rotmg.editor.services {
	import com.adobe.images.PNGEncoder;

	import flash.events.Event;
	import flash.utils.ByteArray;

	import kabam.lib.tasks.BaseTask;
	import kabam.rotmg.account.core.Account;
	import kabam.rotmg.application.api.ApplicationSetup;
	import kabam.rotmg.editor.model.TextureData;

	import ru.inspirit.net.MultipartURLLoader;

	public class SaveTextureTask extends BaseTask {


		[Inject]
		public var account:Account;

		[Inject]
		public var data:TextureData;

		[Inject]
		public var setup:ApplicationSetup;

		public function SaveTextureTask() {
			super();
		}

		override protected function startTask():void {
			var loc1:MultipartURLLoader = new MultipartURLLoader();
			loc1.addVariable("guid", this.account.getUserId());
			loc1.addVariable("password", "");
			loc1.addVariable("token", this.account.getToken());
			loc1.addVariable("secret", "");
			loc1.addVariable("name", this.data.name);
			loc1.addVariable("dataType", this.data.type);
			loc1.addVariable("tags", this.data.tags);
			loc1.addVariable("overwrite", "on");
			var loc2:* = this.setup.getAppEngineUrl(true) + "/picture/save";
			var loc3:ByteArray = PNGEncoder.encode(this.data.bitmapData);
			loc1.addFile(loc3, "Foo.png", "data");
			loc1.addEventListener(Event.COMPLETE, this.onSaveComplete);
			loc1.load(loc2);
		}

		private function onSaveComplete(param1:Event):void {
			completeTask(true);
		}
	}
}
