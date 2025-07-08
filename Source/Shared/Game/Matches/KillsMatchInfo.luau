local KillsMatchInfo = {};
local Meta = { __index = KillsMatchInfo };
local Members = {};

-- —————————————————————————————————————————————————————————————————————————— --
--                                    Class                                   --
-- —————————————————————————————————————————————————————————————————————————— --



-- —————————————————————————————————————————————————————————————————————————— --
--                                   Object                                   --
-- —————————————————————————————————————————————————————————————————————————— --

function KillsMatchInfo.New(
	killGoal: number?,
	matchTimeInSeconds: number?
)
	local self, priv = setmetatable({}, Meta), {};
	Members[self] = priv;

	self.Type = "Kills";
	self.KillGoal = killGoal or 100;

	return self;
end

-- —————————————————————————————————————————————————————————————————————————— --
--                                     ...                                    --
-- —————————————————————————————————————————————————————————————————————————— --

export type KillsMatchInfo = typeof(KillsMatchInfo.New(...));
return KillsMatchInfo;
