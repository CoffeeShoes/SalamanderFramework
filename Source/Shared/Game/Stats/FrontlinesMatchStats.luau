local FrontlinesMatchStats = {};
local Meta = { __index = FrontlinesMatchStats };
local Members = {};

-- —————————————————————————————————————————————————————————————————————————— --
--                                    Class                                   --
-- —————————————————————————————————————————————————————————————————————————— --

export type TeamGroupId = string;

-- —————————————————————————————————————————————————————————————————————————— --
--                                   Object                                   --
-- —————————————————————————————————————————————————————————————————————————— --

function FrontlinesMatchStats.New()
	local self, priv = setmetatable({}, Meta), {};
	Members[self] = priv;

	self.Type = "Frontlines" :: "Frontlines";
	self.CapturePoints = {} :: { { CapturePointId: string, ControllingTeamGroupId: string?, ProgressAlpha: number  } };
	
	self.TeamGroupScores = {} :: { { TeamGroupId: string, CaptureScore: number, Kills: number, Deaths: number, Damage: number } };
	self.PlayerScores = {} :: { { UserId: number, Username: string, CaptureScore: number, Kills: number, Deaths: number, Damage: number } };

	return self;
end

-- —————————————————————————————————————————————————————————————————————————— --
--                                     ...                                    --
-- —————————————————————————————————————————————————————————————————————————— --

export type FrontlinesMatchStats = typeof(FrontlinesMatchStats.New(...));
return FrontlinesMatchStats;
