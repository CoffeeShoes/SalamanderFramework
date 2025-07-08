local CaptureMatchStats = {};
local Meta = { __index = CaptureMatch };
local Members = {};

-- —————————————————————————————————————————————————————————————————————————— --
--                                    Class                                   --
-- —————————————————————————————————————————————————————————————————————————— --

export type TeamGroupId = string;

local Remotes = require(game.ReplicatedStorage.Source.TeamGroups.TeamGroupRemotes);

-- —————————————————————————————————————————————————————————————————————————— --
--                                   Object                                   --
-- —————————————————————————————————————————————————————————————————————————— --

function CaptureMatchStats.New()
	local self, priv = setmetatable({}, Meta), {};
	Members[self] = priv;

	self.Type = "Capture" :: "Capture";
	self.CapturePoints = {} :: { { CapturePointId: string, ControllingTeamGroupId: string?, ProgressAlpha: number  } };

	self.TeamGroupScores = {} :: { { TeamGroupId: string, CaptureScore: number, Kills: number, Deaths: number, Damage: number } };
	self.PlayerScores = {} :: { { UserId: number, Username: string, CaptureScore: number, Kills: number, Deaths: number, Damage: number } };

	return self;
end

-- —————————————————————————————————————————————————————————————————————————— --
--                                     ...                                    --
-- —————————————————————————————————————————————————————————————————————————— --

export type CaptureMatchStats = typeof(CaptureMatchStats.New(...));
return CaptureMatchStats;
