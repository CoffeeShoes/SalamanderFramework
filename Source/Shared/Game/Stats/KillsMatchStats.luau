local KillsMatchStats = {};
local Meta = { __index = KillsMatchStats };
local Members = {};

-- —————————————————————————————————————————————————————————————————————————— --
--                                    Class                                   --
-- —————————————————————————————————————————————————————————————————————————— --

export type TeamGroupId = string;

-- —————————————————————————————————————————————————————————————————————————— --
--                                   Object                                   --
-- —————————————————————————————————————————————————————————————————————————— --

function KillsMatchStats.New()
	local self, priv = setmetatable({}, Meta), {};
	Members[self] = priv;

	self.Type = "Kills" :: "Kills";
	self.TeamGroupScores = {} :: { { TeamGroupId: string, Kills: number, Deaths: number, Damage: number } };
	self.PlayerScores = {} :: { { UserId: number, Username: string, Kills: number, Deaths: number, Damage: number } };

	return self;
end

-- —————————————————————————————————————————————————————————————————————————— --
--                                     ...                                    --
-- —————————————————————————————————————————————————————————————————————————— --

export type KillsMatchStats = typeof(KillsMatchStats.New(...));
return KillsMatchStats;
