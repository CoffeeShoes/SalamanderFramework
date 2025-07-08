local HardpointMatchInfo = {};
local Meta = { __index = HardpointMatchInfo };
local Members = {};

-- —————————————————————————————————————————————————————————————————————————— --
--                                    Class                                   --
-- —————————————————————————————————————————————————————————————————————————— --



-- —————————————————————————————————————————————————————————————————————————— --
--                                   Object                                   --
-- —————————————————————————————————————————————————————————————————————————— --

--[=[
@param hardpointCapturePointId string • The CapturePointId of the cap that should be the hardpoint.
@param scoreGoal number? • Points required to win.
@param matchTimeInSeconds number? • The match duration.
]=]--
function HardpointMatchInfo.New(
	hardpointCapturePointId: string,
	scoreGoal: number?,
	matchTimeInSeconds: number?
)
	local self, priv = setmetatable({}, Meta), {};
	Members[self] = priv;

	self.Type = "Hardpoint";
	self.HardpointCapturePointId = hardpointCapturePointId;
	self.ScoreGoal = scoreGoal or 1000;

	return self :: typeof(self) & typeof(MatchInfo.New());
end


-- —————————————————————————————————————————————————————————————————————————— --
--                                     ...                                    --
-- —————————————————————————————————————————————————————————————————————————— --

export type HardpointMatchInfo = typeof(HardpointMatchInfo.New(...));
return HardpointMatchInfo;
