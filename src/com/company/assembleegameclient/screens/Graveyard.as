package com.company.assembleegameclient.screens {
	import com.company.assembleegameclient.appengine.SavedNewsItem;

	import flash.display.Sprite;

	import kabam.rotmg.core.model.PlayerModel;

	public class Graveyard extends Sprite {


		private var lines_:Vector.<GraveyardLine>;

		private var hasCharacters_:Boolean = false;

		public function Graveyard(param1:PlayerModel) {
			var loc2:SavedNewsItem = null;
			this.lines_ = new Vector.<GraveyardLine>();
			super();
			for each(loc2 in param1.getNews()) {
				if (loc2.isCharDeath()) {
					this.addLine(new GraveyardLine(loc2.getIcon(), loc2.title_, loc2.tagline_, loc2.link_, loc2.date_, param1.getAccountId()));
					this.hasCharacters_ = true;
				}
			}
		}

		public function hasCharacters():Boolean {
			return this.hasCharacters_;
		}

		public function addLine(param1:GraveyardLine):void {
			param1.y = 4 + this.lines_.length * (GraveyardLine.HEIGHT + 4);
			this.lines_.push(param1);
			addChild(param1);
		}
	}
}
