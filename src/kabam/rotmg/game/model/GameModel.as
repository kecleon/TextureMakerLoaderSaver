 
package kabam.rotmg.game.model {
	import com.company.assembleegameclient.objects.GameObject;
	import com.company.assembleegameclient.objects.Player;
	import flash.utils.Dictionary;
	
	public class GameModel {
		 
		
		public var player:Player;
		
		public var gameObjects:Dictionary;
		
		public function GameModel() {
			super();
		}
		
		public function getGameObject(param1:int) : GameObject {
			var loc2:GameObject = this.gameObjects[param1];
			if(!loc2 && this.player.objectId_ == param1) {
				loc2 = this.player;
			}
			return loc2;
		}
	}
}
