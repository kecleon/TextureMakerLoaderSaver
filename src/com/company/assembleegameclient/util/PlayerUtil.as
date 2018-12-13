package com.company.assembleegameclient.util {
	import com.company.assembleegameclient.objects.Player;
	import com.company.assembleegameclient.parameters.Parameters;

	import io.decagames.rotmg.supportCampaign.data.SupporterCampaignModel;
	import io.decagames.rotmg.supportCampaign.data.SupporterFeatures;

	public class PlayerUtil {


		public function PlayerUtil() {
			super();
		}

		public static function getPlayerNameColor(param1:Player):Number {
			if (param1.isFellowGuild_) {
				return Parameters.FELLOW_GUILD_COLOR;
			}
			if (param1.hasSupporterFeature(SupporterFeatures.SPECIAL_NAME_COLOR)) {
				return SupporterCampaignModel.SUPPORT_COLOR;
			}
			if (param1.nameChosen_) {
				return Parameters.NAME_CHOSEN_COLOR;
			}
			return 16777215;
		}
	}
}
