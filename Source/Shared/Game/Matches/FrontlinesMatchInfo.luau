local FrontlinesMatchInfo = {};
local Meta = { __index = FrontlinesMatchInfo };
local Members = {};

-- —————————————————————————————————————————————————————————————————————————— --
--                                    Class                                   --
-- —————————————————————————————————————————————————————————————————————————— --



-- —————————————————————————————————————————————————————————————————————————— --
--                                   Object                                   --
-- —————————————————————————————————————————————————————————————————————————— --

--[=[
@param startingCapturePoints { { CapturePointId: string, ControllerTeamGroupId: string } } • The caps that each teams starts out with.
@param scoreGoal number? • The score that has to be reached to win.
@param matchTimeInSeconds • The match duration, in seconds.
]=]--
function FrontlinesMatchInfo.New(
	startingCapturePoints: { { CapturePointId: string, ControllerTeamGroupId: string } },
	scoreGoal: number?,
	matchTimeInSeconds: number?
)
	local self, priv = setmetatable({}, Meta), {};
	Members[self] = priv;

	self.Type = "Frontlines";
	self.StartingCapturePoints = startingCapturePoints;
	self.ScoreGoal = scoreGoal or 1000;

	return self;
end

-- —————————————————————————————————————————————————————————————————————————— --
--                                     ...                                    --
-- —————————————————————————————————————————————————————————————————————————— --

export type FrontlinesMatchInfo = typeof(FrontlinesMatchInfo.New(...));
return FrontlinesMatchInfo;
