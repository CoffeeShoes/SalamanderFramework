local HardpointMatchStats = {};
local Meta = { __index = HardpointMatchStats };
local Members = {};

-- —————————————————————————————————————————————————————————————————————————— --
--                                    Class                                   --
-- —————————————————————————————————————————————————————————————————————————— --

export type TeamGroupId = string;

-- —————————————————————————————————————————————————————————————————————————— --
--                                   Object                                   --
-- —————————————————————————————————————————————————————————————————————————— --

function HardpointMatchStats.New()
	local self, priv = setmetatable({}, Meta), {};
	Members[self] = priv;

	self.Type = "Hardpoint" :: "Hardpoint";
	self.ControllingTeamGroupId = nil :: string?;
	self.ProgressAlpha = 0;
	
	self.TeamGroupScores = {} :: { { TeamGroupId: string, CaptureScore: number, Kills: number, Deaths: number, Damage: number } };
	self.PlayerScores = {} :: { { UserId: number, Username: string, CaptureScore: number, Kills: number, Deaths: number, Damage: number } };

	return self;
end

-- —————————————————————————————————————————————————————————————————————————— --
--                                     ...                                    --
-- —————————————————————————————————————————————————————————————————————————— --

export type HardpointMatchStats = typeof(HardpointMatchStats.New(...));
return HardpointMatchStats;
