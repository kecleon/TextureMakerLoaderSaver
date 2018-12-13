package kabam.rotmg.text.view.stringBuilder {
	import kabam.rotmg.language.model.StringMap;

	public class AppendingLineBuilder implements StringBuilder {


		private var data:Vector.<LineData>;

		private var delimiter:String = "\n";

		private var provider:StringMap;

		public function AppendingLineBuilder() {
			this.data = new Vector.<LineData>();
			super();
		}

		public function pushParams(param1:String, param2:Object = null, param3:String = "", param4:String = ""):AppendingLineBuilder {
			this.data.push(new LineData().setKey(param1).setTokens(param2).setOpeningTags(param3).setClosingTags(param4));
			return this;
		}

		public function setDelimiter(param1:String):AppendingLineBuilder {
			this.delimiter = param1;
			return this;
		}

		public function setStringMap(param1:StringMap):void {
			this.provider = param1;
		}

		public function getString():String {
			var loc2:LineData = null;
			var loc1:Vector.<String> = new Vector.<String>();
			for each(loc2 in this.data) {
				loc1.push(loc2.getString(this.provider));
			}
			return loc1.join(this.delimiter);
		}

		public function hasLines():Boolean {
			return this.data.length != 0;
		}

		public function clear():void {
			this.data = new Vector.<LineData>();
		}
	}
}

import kabam.rotmg.language.model.StringMap;
import kabam.rotmg.text.model.TextKey;
import kabam.rotmg.text.view.stringBuilder.StringBuilder;

class LineData {


	public var key:String;

	public var tokens:Object;

	public var openingHTMLTags:String = "";

	public var closingHTMLTags:String = "";

	function LineData() {
		super();
	}

	public function setKey(param1:String):LineData {
		this.key = param1;
		return this;
	}

	public function setTokens(param1:Object):LineData {
		this.tokens = param1;
		return this;
	}

	public function setOpeningTags(param1:String):LineData {
		this.openingHTMLTags = param1;
		return this;
	}

	public function setClosingTags(param1:String):LineData {
		this.closingHTMLTags = param1;
		return this;
	}

	public function getString(param1:StringMap):String {
		var loc3:String = null;
		var loc4:* = null;
		var loc5:StringBuilder = null;
		var loc6:String = null;
		var loc2:String = this.openingHTMLTags;
		if ((loc3 = param1.getValue(TextKey.stripCurlyBrackets(this.key))) == null) {
			loc3 = this.key;
		}
		loc2 = loc2.concat(loc3);
		for (loc4 in this.tokens) {
			if (this.tokens[loc4] is StringBuilder) {
				loc5 = StringBuilder(this.tokens[loc4]);
				loc5.setStringMap(param1);
				loc2 = loc2.replace("{" + loc4 + "}", loc5.getString());
			} else {
				loc6 = this.tokens[loc4];
				if (loc6.length > 0 && loc6.charAt(0) == "{" && loc6.charAt(loc6.length - 1) == "}") {
					loc6 = param1.getValue(loc6.substr(1, loc6.length - 2));
				}
				loc2 = loc2.replace("{" + loc4 + "}", loc6);
			}
		}
		loc2 = loc2.replace(/\\n/g, "\n");
		loc2 = loc2.concat(this.closingHTMLTags);
		return loc2;
	}
}
