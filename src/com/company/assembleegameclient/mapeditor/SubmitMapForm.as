 
package com.company.assembleegameclient.mapeditor {
	import com.company.assembleegameclient.account.ui.CheckBoxField;
	import com.company.assembleegameclient.account.ui.Frame;
	import com.company.assembleegameclient.account.ui.TextInputField;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import kabam.lib.json.JsonParser;
	import kabam.rotmg.account.core.Account;
	import kabam.rotmg.application.api.ApplicationSetup;
	import kabam.rotmg.core.StaticInjectorContext;
	import kabam.rotmg.editor.view.components.savedialog.TagsInputField;
	import kabam.rotmg.fortune.components.TimerCallback;
	import kabam.rotmg.text.model.TextKey;
	import org.osflash.signals.Signal;
	import ru.inspirit.net.MultipartURLLoader;
	
	public class SubmitMapForm extends Frame {
		
		public static var cancel:Signal;
		 
		
		private var mapName:TextInputField;
		
		private var descr:TextInputField;
		
		private var tags:TagsInputField;
		
		private var mapjm:String;
		
		private var mapInfo:Object;
		
		private var account:Account;
		
		private var checkbox:CheckBoxField;
		
		public function SubmitMapForm(param1:String, param2:Object, param3:Account) {
			super("SubmitMapForm.Title",TextKey.FRAME_CANCEL,TextKey.WEB_CHANGE_PASSWORD_RIGHT,null,300);
			cancel = new Signal();
			this.account = param3;
			this.mapjm = param1;
			this.mapInfo = param2;
			this.mapName = new TextInputField("Map Name");
			addTextInputField(this.mapName);
			this.tags = new TagsInputField("",238,50,true);
			addComponent(this.tags,12);
			this.descr = new TextInputField("Description",false,238,100,20,256,true);
			addTextInputField(this.descr);
			addSpace(35);
			this.checkbox = new CheckBoxField("Overwrite",true,12);
			addCheckBox(this.checkbox);
			this.enableButtons();
			addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
		}
		
		public static function isInitialized() : Boolean {
			return cancel != null;
		}
		
		private function disableButtons() : void {
			rightButton_.removeEventListener(MouseEvent.CLICK,this.onSubmit);
			leftButton_.removeEventListener(MouseEvent.CLICK,this.onCancel);
		}
		
		private function enableButtons() : void {
			rightButton_.addEventListener(MouseEvent.CLICK,this.onSubmit);
			leftButton_.addEventListener(MouseEvent.CLICK,this.onCancel);
		}
		
		private function onSubmit(param1:MouseEvent) : void {
			this.disableButtons();
			this.mapName.clearError();
			var loc2:JsonParser = StaticInjectorContext.getInjector().getInstance(JsonParser);
			var loc3:Object = loc2.parse(this.mapjm);
			var loc4:int = loc3["width"];
			var loc5:int = loc3["height"];
			var loc6:MultipartURLLoader = new MultipartURLLoader();
			loc6.addVariable("guid",this.account.getUserId());
			loc6.addVariable("password",this.account.getPassword());
			loc6.addVariable("name",this.mapName.text());
			loc6.addVariable("description",this.descr.text());
			loc6.addVariable("width",loc4);
			loc6.addVariable("height",loc5);
			loc6.addVariable("mapjm",this.mapjm);
			loc6.addVariable("tags",this.tags.text());
			loc6.addVariable("totalObjects",this.mapInfo.numObjects);
			loc6.addVariable("totalTiles",this.mapInfo.numTiles);
			loc6.addFile(this.mapInfo.thumbnail,"foo.png","thumbnail");
			loc6.addVariable("overwrite",!!this.checkbox.isChecked()?"on":"off");
			var loc7:ApplicationSetup = StaticInjectorContext.getInjector().getInstance(ApplicationSetup);
			var loc8:* = loc7.getAppEngineUrl(true) + "/ugc/save";
			this.enableButtons();
			var loc9:Object = {
				"name":this.mapName.text(),
				"description":this.descr.text(),
				"width":loc4,
				"height":loc5,
				"mapjm":this.mapjm,
				"tags":this.tags.text(),
				"totalObjects":this.mapInfo.numObjects,
				"totalTiles":this.mapInfo.numTiles,
				"thumbnail":this.mapInfo.thumbnail,
				"overwrite":(!!this.checkbox.isChecked()?"on":"off")
			};
			if(this.validated(loc9)) {
				loc6.addEventListener(Event.COMPLETE,this.onComplete);
				loc6.addEventListener(IOErrorEvent.IO_ERROR,this.onCompleteException);
				loc6.load(loc8);
			} else {
				this.enableButtons();
			}
		}
		
		private function onCompleteException(param1:IOErrorEvent) : void {
			this.descr.setError("Exception. If persists, please contact dev team.");
			this.enableButtons();
		}
		
		private function onComplete(param1:Event) : void {
			var loc3:Array = null;
			var loc4:String = null;
			var loc2:MultipartURLLoader = MultipartURLLoader(param1.target);
			if(loc2.loader.data == "<Success/>") {
				this.descr.setError("Success! Thank you!");
				new TimerCallback(2,this.onCancel);
			} else {
				loc3 = loc2.loader.data.match("<.*>(.*)</.*>");
				loc4 = loc3.length > 1?loc3[1]:loc2.loader.data;
				this.descr.setError(loc4);
			}
			this.enableButtons();
		}
		
		private function onCancel(param1:MouseEvent = null) : void {
			cancel.dispatch();
			if(parent) {
				parent.removeChild(this);
			}
		}
		
		private function onRemovedFromStage(param1:Event) : void {
			if(rightButton_) {
				rightButton_.removeEventListener(MouseEvent.CLICK,this.onSubmit);
			}
			if(cancel) {
				cancel.removeAll();
				cancel = null;
			}
		}
		
		private function validated(param1:Object) : Boolean {
			if(param1["name"].length < 6 || param1["name"].length > 24) {
				this.mapName.setError("Map name length out of range (6-24 chars)");
				return false;
			}
			if(param1["description"].length < 10 || param1["description"].length > 250) {
				this.descr.setError("Description length out of range (10-250 chars)");
				return false;
			}
			return this.isValidMap();
		}
		
		private function isValidMap() : Boolean {
			if(this.mapInfo.numExits < 1) {
				this.descr.setError("Must have at least one User Dungeon End region drawn in this dungeon. (tmp)");
				return false;
			}
			if(this.mapInfo.numEntries < 1) {
				this.descr.setError("Must have at least one Spawn Region drawn in this dungeon. (tmp)");
				return false;
			}
			return true;
		}
	}
}
