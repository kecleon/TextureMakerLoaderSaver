 
package kabam.rotmg.language.service {
	import com.company.assembleegameclient.ui.dialogs.ErrorDialog;
	import io.decagames.rotmg.pets.data.rarity.PetRarityEnum;
	import kabam.lib.tasks.BaseTask;
	import kabam.rotmg.appengine.api.AppEngineClient;
	import kabam.rotmg.dialogs.control.OpenDialogSignal;
	import kabam.rotmg.language.model.LanguageModel;
	import kabam.rotmg.language.model.StringMap;
	
	public class GetLanguageService extends BaseTask {
		
		private static const LANGUAGE:String = "LANGUAGE";
		 
		
		[Inject]
		public var model:LanguageModel;
		
		[Inject]
		public var strings:StringMap;
		
		[Inject]
		public var openDialog:OpenDialogSignal;
		
		[Inject]
		public var client:AppEngineClient;
		
		private var language:String;
		
		public function GetLanguageService() {
			super();
		}
		
		override protected function startTask() : void {
			this.language = this.model.getLanguageFamily();
			this.client.complete.addOnce(this.onComplete);
			this.client.setMaxRetries(3);
			this.client.sendRequest("/app/getLanguageStrings",{"languageType":this.language});
		}
		
		private function onComplete(param1:Boolean, param2:*) : void {
			if(param1) {
				this.onLanguageResponse(param2);
			} else {
				this.onLanguageError();
			}
			completeTask(param1,param2);
		}
		
		private function onLanguageResponse(param1:String) : void {
			var loc3:Array = null;
			this.strings.clear();
			var loc2:Object = JSON.parse(param1);
			for each(loc3 in loc2) {
				this.strings.setValue(loc3[0],loc3[1],loc3[2]);
			}
			PetRarityEnum.parseNames();
		}
		
		private function onLanguageError() : void {
			this.strings.setValue("ok","ok",this.model.getLanguageFamily());
			var loc1:ErrorDialog = new ErrorDialog("Unable to load language [" + this.language + "]");
			this.openDialog.dispatch(loc1);
			completeTask(false);
		}
	}
}
