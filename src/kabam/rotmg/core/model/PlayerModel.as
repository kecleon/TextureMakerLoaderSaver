 
package kabam.rotmg.core.model {
	import com.company.assembleegameclient.appengine.SavedCharacter;
	import com.company.assembleegameclient.appengine.SavedCharactersList;
	import com.company.assembleegameclient.appengine.SavedNewsItem;
	import com.company.assembleegameclient.parameters.Parameters;
	import kabam.rotmg.account.core.Account;
	import kabam.rotmg.account.kongregate.KongregateAccount;
	import kabam.rotmg.servers.api.LatLong;
	import org.osflash.signals.Signal;
	
	public class PlayerModel {
		
		public static const CHARACTER_SLOT_PRICES:Array = [600,800,1000];
		 
		
		public const creditsChanged:Signal = new Signal(int);
		
		public const fameChanged:Signal = new Signal(int);
		
		public const tokensChanged:Signal = new Signal(int);
		
		public var charList:SavedCharactersList;
		
		public var isInvalidated:Boolean;
		
		private var _currentCharId:int;
		
		private var isAgeVerified:Boolean;
		
		[Inject]
		public var account:Account;
		
		public function PlayerModel() {
			super();
			this.isInvalidated = true;
		}
		
		public function set currentCharId(param1:int) : void {
			this._currentCharId = param1;
		}
		
		public function get currentCharId() : int {
			return this._currentCharId;
		}
		
		public function getHasPlayerDied() : Boolean {
			return this.charList.hasPlayerDied;
		}
		
		public function setHasPlayerDied(param1:Boolean) : void {
			this.charList.hasPlayerDied = param1;
		}
		
		public function getIsAgeVerified() : Boolean {
			return this.isAgeVerified || this.account is KongregateAccount || this.charList.isAgeVerified;
		}
		
		public function setIsAgeVerified(param1:Boolean) : void {
			this.isAgeVerified = true;
		}
		
		public function isNewPlayer() : Boolean {
			return Parameters.data_.needsTutorial && this.charList.nextCharId_ == 1;
		}
		
		public function getMaxCharacters() : int {
			return this.charList.maxNumChars_;
		}
		
		public function setMaxCharacters(param1:int) : void {
			this.charList.maxNumChars_ = param1;
		}
		
		public function getCredits() : int {
			return this.charList.credits_;
		}
		
		public function getSalesForceData() : String {
			return this.charList.salesForceData_;
		}
		
		public function changeCredits(param1:int) : void {
			this.charList.credits_ = this.charList.credits_ + param1;
			this.creditsChanged.dispatch(this.charList.credits_);
		}
		
		public function setCredits(param1:int) : void {
			if(this.charList.credits_ != param1) {
				this.charList.credits_ = param1;
				this.creditsChanged.dispatch(param1);
			}
		}
		
		public function getFame() : int {
			return this.charList.fame_;
		}
		
		public function setFame(param1:int) : void {
			if(this.charList.fame_ != param1) {
				this.charList.fame_ = param1;
				this.fameChanged.dispatch(param1);
			}
		}
		
		public function getTokens() : int {
			return this.charList.tokens_;
		}
		
		public function setTokens(param1:int) : void {
			if(this.charList.tokens_ != param1) {
				this.charList.tokens_ = param1;
				this.tokensChanged.dispatch(param1);
			}
		}
		
		public function getCharacterCount() : int {
			return this.charList.numChars_;
		}
		
		public function getCharById(param1:int) : SavedCharacter {
			return this.charList.getCharById(param1);
		}
		
		public function deleteCharacter(param1:int) : void {
			var loc2:SavedCharacter = this.charList.getCharById(param1);
			var loc3:int = this.charList.savedChars_.indexOf(loc2);
			if(loc3 != -1) {
				this.charList.savedChars_.splice(loc3,1);
				this.charList.numChars_--;
			}
		}
		
		public function getAccountId() : String {
			return this.charList.accountId_;
		}
		
		public function hasAccount() : Boolean {
			return this.charList.accountId_ != "";
		}
		
		public function getNumStars() : int {
			return this.charList.numStars_;
		}
		
		public function getGuildName() : String {
			return this.charList.guildName_;
		}
		
		public function getGuildRank() : int {
			return this.charList.guildRank_;
		}
		
		public function getNextCharSlotPrice() : int {
			var loc1:int = Math.min(CHARACTER_SLOT_PRICES.length - 1,this.charList.maxNumChars_ - 1);
			return CHARACTER_SLOT_PRICES[loc1];
		}
		
		public function getTotalFame() : int {
			return this.charList.totalFame_;
		}
		
		public function getNextCharId() : int {
			return this.charList.nextCharId_;
		}
		
		public function getCharacterById(param1:int) : SavedCharacter {
			var loc2:SavedCharacter = null;
			for each(loc2 in this.charList.savedChars_) {
				if(loc2.charId() == param1) {
					return loc2;
				}
			}
			return null;
		}
		
		public function getCharacterByIndex(param1:int) : SavedCharacter {
			return this.charList.savedChars_[param1];
		}
		
		public function isAdmin() : Boolean {
			return this.charList.isAdmin_;
		}
		
		public function mapEditor() : Boolean {
			return this.charList.canMapEdit_;
		}
		
		public function getNews() : Vector.<SavedNewsItem> {
			return this.charList.news_;
		}
		
		public function getMyPos() : LatLong {
			return this.charList.myPos_;
		}
		
		public function setClassAvailability(param1:int, param2:String) : void {
			this.charList.classAvailability[param1] = param2;
		}
		
		public function getName() : String {
			return this.charList.name_;
		}
		
		public function getConverted() : Boolean {
			return this.charList.converted_;
		}
		
		public function setName(param1:String) : void {
			this.charList.name_ = param1;
		}
		
		public function isNameChosen() : Boolean {
			return this.charList.nameChosen_;
		}
		
		public function getNewUnlocks(param1:int, param2:int) : Array {
			return this.charList.newUnlocks(param1,param2);
		}
		
		public function hasAvailableCharSlot() : Boolean {
			return this.charList.hasAvailableCharSlot();
		}
		
		public function getAvailableCharSlots() : int {
			return this.charList.availableCharSlots();
		}
		
		public function getSavedCharacters() : Vector.<SavedCharacter> {
			return this.charList.savedChars_;
		}
		
		public function getCharStats() : Object {
			return this.charList.charStats_;
		}
		
		public function isClassAvailability(param1:String, param2:String) : Boolean {
			var loc3:String = this.charList.classAvailability[param1];
			return loc3 == param2;
		}
		
		public function isLevelRequirementsMet(param1:int) : Boolean {
			return this.charList.levelRequirementsMet(param1);
		}
		
		public function getBestFame(param1:int) : int {
			return this.charList.bestFame(param1);
		}
		
		public function getBestLevel(param1:int) : int {
			return this.charList.bestLevel(param1);
		}
		
		public function getBestCharFame() : int {
			return this.charList.bestCharFame_;
		}
		
		public function setCharacterList(param1:SavedCharactersList) : void {
			this.charList = param1;
		}
		
		public function isNewToEditing() : Boolean {
			if(this.charList && !this.charList.isFirstTimeLogin()) {
				return false;
			}
			return true;
		}
	}
}
