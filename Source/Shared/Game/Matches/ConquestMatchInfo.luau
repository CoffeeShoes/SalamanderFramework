local ConquestMatchInfo = {};
local Meta = { __index = ConquestMatchInfo };
local Members = {};

-- —————————————————————————————————————————————————————————————————————————— --
--                                    Class                                   --
-- —————————————————————————————————————————————————————————————————————————— --



-- —————————————————————————————————————————————————————————————————————————— --
--                                   Object                                   --
-- —————————————————————————————————————————————————————————————————————————— --

--[=[
@param defendingTeamGroupId string • The ID of the defending TeamGroup.
@param attackingTeamGroupId string • The ID of the attacking TeamGroup.
@param capturePointIdsInOrder { string } • An array of capture point IDs, where the first one is the first to be captured, second is the second, and so on.
@param matchTimeInSeconds number? • The match duration.
]=]--
function ConquestMatchInfo.New(
	defendingTeamGroupId: string,
	attackingTeamGroupId: string,
	capturePointIdsInOrder: { { CapturePointId: string } },
	matchTimeInSeconds: number?
)
	local self, priv = setmetatable({}, Meta), {};
	Members[self] = priv;

	self.Type = "Conquest" :: "Conquest";
	self.DefendingTeamGroupId = defendingTeamGroupId;
	self.AttackingTeamGroupId = attackingTeamGroupId;
	self.CapturePointIdsInOrder = capturePointIdsInOrder;

	return self;
end

-- —————————————————————————————————————————————————————————————————————————— --
--                                     ...                                    --
-- —————————————————————————————————————————————————————————————————————————— --

export type ConquestMatchInfo = typeof(ConquestMatchInfo.New(...)) & typeof(MatchInfo.New(...));
return ConquestMatchInfo;
