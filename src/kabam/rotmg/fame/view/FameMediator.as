 
package kabam.rotmg.fame.view {
	import com.company.assembleegameclient.objects.ObjectLibrary;
	import com.company.assembleegameclient.objects.TextureData;
	import com.company.assembleegameclient.util.AnimatedChar;
	import com.company.assembleegameclient.util.MaskedImage;
	import com.company.assembleegameclient.util.TextureRedrawer;
	import flash.display.BitmapData;
	import kabam.rotmg.assets.services.CharacterFactory;
	import kabam.rotmg.core.signals.GotoPreviousScreenSignal;
	import kabam.rotmg.core.signals.SetScreenSignal;
	import kabam.rotmg.core.signals.TrackPageViewSignal;
	import kabam.rotmg.death.model.DeathModel;
	import kabam.rotmg.fame.model.FameModel;
	import kabam.rotmg.fame.service.RequestCharacterFameTask;
	import kabam.rotmg.legends.view.LegendsView;
	import kabam.rotmg.messaging.impl.incoming.Death;
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	public class FameMediator extends Mediator {
		 
		
		[Inject]
		public var view:FameView;
		
		[Inject]
		public var fameModel:FameModel;
		
		[Inject]
		public var deathModel:DeathModel;
		
		[Inject]
		public var setScreen:SetScreenSignal;
		
		[Inject]
		public var gotoPrevious:GotoPreviousScreenSignal;
		
		[Inject]
		public var track:TrackPageViewSignal;
		
		[Inject]
		public var task:RequestCharacterFameTask;
		
		[Inject]
		public var factory:CharacterFactory;
		
		private var isFreshDeath:Boolean;
		
		private var death:Death;
		
		public function FameMediator() {
			super();
		}
		
		override public function initialize() : void {
			this.view.closed.add(this.onClosed);
			this.track.dispatch("/fame");
			this.setViewDataFromDeath();
			this.requestFameData();
		}
		
		override public function destroy() : void {
			this.view.closed.remove(this.onClosed);
			this.view.clearBackground();
			this.death && this.death.disposeBackground();
			this.task.finished.removeAll();
		}
		
		private function setViewDataFromDeath() : void {
			this.isFreshDeath = this.deathModel.getIsDeathViewPending();
			this.view.setIsAnimation(this.isFreshDeath);
			this.death = this.deathModel.getLastDeath();
			if(this.death && this.death.background) {
				this.view.setBackground(this.death.background);
			}
		}
		
		private function requestFameData() : void {
			this.task.accountId = this.fameModel.accountId;
			this.task.charId = this.fameModel.characterId;
			this.task.finished.addOnce(this.onFameResponse);
			this.task.start();
		}
		
		private function onFameResponse(param1:RequestCharacterFameTask, param2:Boolean, param3:String = "") : void {
			var loc4:BitmapData = this.makeIcon();
			this.view.setCharacterInfo(param1.name,param1.level,param1.type);
			this.view.setDeathInfo(param1.deathDate,param1.killer);
			this.view.setIcon(loc4);
			this.view.setScore(param1.totalFame,param1.xml);
		}
		
		private function makeIcon() : BitmapData {
			if(this.isFreshDeath && this.death.isZombie) {
				return this.makeZombieTexture();
			}
			return this.makeNormalTexture();
		}
		
		private function makeNormalTexture() : BitmapData {
			return this.factory.makeIcon(this.task.template,this.task.size,this.task.texture1,this.task.texture2);
		}
		
		private function makeZombieTexture() : BitmapData {
			var loc1:TextureData = ObjectLibrary.typeToTextureData_[this.death.zombieType];
			var loc2:AnimatedChar = loc1.animatedChar_;
			var loc3:MaskedImage = loc2.imageFromDir(AnimatedChar.RIGHT,AnimatedChar.STAND,0);
			return TextureRedrawer.resize(loc3.image_,loc3.mask_,250,true,this.task.texture1,this.task.texture2);
		}
		
		private function onClosed() : void {
			if(this.isFreshDeath) {
				this.setScreen.dispatch(new LegendsView());
			} else {
				this.gotoPrevious.dispatch();
			}
		}
	}
}
