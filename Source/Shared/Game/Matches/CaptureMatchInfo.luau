local CaptureMatchInfo = {};
local Meta = { __index = CaptureMatchInfo };
local Members = {};

-- —————————————————————————————————————————————————————————————————————————— --
--                                    Class                                   --
-- —————————————————————————————————————————————————————————————————————————— --

-- —————————————————————————————————————————————————————————————————————————— --
--                                   Object                                   --
-- —————————————————————————————————————————————————————————————————————————— --

function CaptureMatchInfo.New(
	enabledCapsIds: { string }?,
	matchTimeInSeconds: number?,
	scoreGoal: number?
)
	local self, priv = setmetatable({}, Meta), {};
	Members[self] = priv;

	self.Type = "Capture" :: "Capture";
	self.EnabledCapturePointsIds = enabledCapsIds;
	self.ScoreGoal = scoreGoal or 1000;
	self.MatchTimeInSeconds = matchTimeInSeconds or 1800;

	return self;
end

-- —————————————————————————————————————————————————————————————————————————— --
--                                     ...                                    --
-- —————————————————————————————————————————————————————————————————————————— --

export type CaptureMatchInfo = typeof(CaptureMatchInfo.New(...));
return CaptureMatchInfo;
