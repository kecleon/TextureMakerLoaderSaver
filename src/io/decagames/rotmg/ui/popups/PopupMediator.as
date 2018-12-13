package io.decagames.rotmg.ui.popups {
	import io.decagames.rotmg.ui.popups.signals.CloseAllPopupsSignal;
	import io.decagames.rotmg.ui.popups.signals.CloseCurrentPopupSignal;
	import io.decagames.rotmg.ui.popups.signals.ClosePopupByClassSignal;
	import io.decagames.rotmg.ui.popups.signals.ClosePopupSignal;
	import io.decagames.rotmg.ui.popups.signals.RemoveLockFade;
	import io.decagames.rotmg.ui.popups.signals.ShowLockFade;
	import io.decagames.rotmg.ui.popups.signals.ShowPopupSignal;

	import robotlegs.bender.bundles.mvcs.Mediator;

	public class PopupMediator extends Mediator {


		[Inject]
		public var view:PopupView;

		[Inject]
		public var showPopupSignal:ShowPopupSignal;

		[Inject]
		public var closePopupSignal:ClosePopupSignal;

		[Inject]
		public var closePopupByClassSignal:ClosePopupByClassSignal;

		[Inject]
		public var closeCurrentPopupSignal:CloseCurrentPopupSignal;

		[Inject]
		public var closeAllPopupsSignal:CloseAllPopupsSignal;

		[Inject]
		public var removeLockFade:RemoveLockFade;

		[Inject]
		public var showLockFade:ShowLockFade;

		private var popups:Vector.<BasePopup>;

		public function PopupMediator() {
			super();
			this.popups = new Vector.<BasePopup>();
		}

		override public function initialize():void {
			this.showPopupSignal.add(this.showPopupHandler);
			this.closePopupSignal.add(this.closePopupHandler);
			this.closePopupByClassSignal.add(this.closeByClassHandler);
			this.closeCurrentPopupSignal.add(this.closeCurrentPopupHandler);
			this.closeAllPopupsSignal.add(this.closeAllPopupsHandler);
			this.removeLockFade.add(this.onRemoveLock);
			this.showLockFade.add(this.onShowLock);
		}

		private function closeCurrentPopupHandler():void {
			var loc1:BasePopup = this.popups.pop();
			this.view.removeChild(loc1);
		}

		private function onShowLock():void {
			this.view.showFade();
		}

		private function onRemoveLock():void {
			this.view.removeFade();
		}

		private function closeAllPopupsHandler():void {
			var loc1:BasePopup = null;
			for each(loc1 in this.popups) {
				this.view.removeChild(loc1);
			}
			this.popups = new Vector.<BasePopup>();
		}

		private function showPopupHandler(param1:BasePopup):void {
			this.view.addChild(param1);
			this.popups.push(param1);
			if (param1.showOnFullScreen) {
				if (param1.overrideSizePosition != null) {
					param1.x = Math.round((800 - param1.overrideSizePosition.width) / 2);
					param1.y = Math.round((600 - param1.overrideSizePosition.height) / 2);
				} else {
					param1.x = Math.round((800 - param1.width) / 2);
					param1.y = Math.round((600 - param1.height) / 2);
				}
			}
			this.drawPopupBackground(param1);
		}

		private function closePopupHandler(param1:BasePopup):void {
			var loc2:int = this.popups.indexOf(param1);
			if (loc2 >= 0) {
				this.view.removeChild(this.popups[loc2]);
				this.popups.splice(loc2, 1);
			}
		}

		private function closeByClassHandler(param1:Class):void {
			var loc2:int = this.popups.length - 1;
			while (loc2 >= 0) {
				if (this.popups[loc2] is param1) {
					this.view.removeChild(this.popups[loc2]);
					this.popups.splice(loc2, 1);
				}
				loc2--;
			}
		}

		private function drawPopupBackground(param1:BasePopup):void {
			param1.graphics.beginFill(param1.popupFadeColor, param1.popupFadeAlpha);
			param1.graphics.drawRect(-param1.x, -param1.y, 800, 600);
			param1.graphics.endFill();
		}

		override public function destroy():void {
			this.showPopupSignal.remove(this.showPopupHandler);
			this.closePopupSignal.remove(this.closePopupHandler);
			this.closePopupByClassSignal.remove(this.closeByClassHandler);
			this.closeCurrentPopupSignal.remove(this.closeCurrentPopupHandler);
			this.removeLockFade.remove(this.onRemoveLock);
			this.showLockFade.remove(this.onShowLock);
		}
	}
}
