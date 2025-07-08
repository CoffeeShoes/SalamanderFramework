local ConquestMatchStats = {};
local Meta = { __index = ConquestMatchStats };
local Members = {};

-- —————————————————————————————————————————————————————————————————————————— --
--                                    Class                                   --
-- —————————————————————————————————————————————————————————————————————————— --

export type TeamGroupId = string;

-- —————————————————————————————————————————————————————————————————————————— --
--                                   Object                                   --
-- —————————————————————————————————————————————————————————————————————————— --

function ConquestMatchStats.New()
	local self, priv = setmetatable({}, Meta), {};
	Members[self] = priv;

	self.Type = "Conquest" :: "Conquest";
	self.CurrentCapturePoint = nil :: { CapturePointId: string, ProgressAlpha: number, CapturePointsRemaining: number }?
	self.CapturePoints = {} :: { { CapturePointId: string, DisplayName: string,  } }

	self.TeamGroupScores = {} :: { { TeamGroupId: string, CaptureScore: number, Kills: number, Deaths: number, Damage: number } };
	self.PlayerScores = {} :: { { UserId: number, Username: string, CaptureScore: number, Kills: number, Deaths: number, Damage: number } };

	return self;
end

-- —————————————————————————————————————————————————————————————————————————— --
--                                     ...                                    --
-- —————————————————————————————————————————————————————————————————————————— --

export type ConquestMatchStats = typeof(ConquestMatchStats.New(...));
return ConquestMatchStats;
