local TeamGroupInfo = {};
local Meta = { __index = TeamGroupInfo };
local Members = {};

-- —————————————————————————————————————————————————————————————————————————— --
--                                    Class                                   --
-- —————————————————————————————————————————————————————————————————————————— --

local SpawnInfo = require(game.ReplicatedStorage.Source.Maps.Spawns.SpawnInfo);

-- —————————————————————————————————————————————————————————————————————————— --
--                                   Object                                   --
-- —————————————————————————————————————————————————————————————————————————— --

function TeamGroupInfo.New(
	id: string,
	displayName: string,
	teamColour: BrickColor,
	groupId: number?,
	spawnInfos: { SpawnInfo.SpawnInfo }?,
	members: { Player }?,
	teamLeaders: { Player }?,
)
	local self, priv = setmetatable({}, Meta), {};
	Members[self] = priv;

	self.Id = id;
	self.DisplayName = displayName;
	self.TeamColour = teamColour;
	self.GroupId = groupId;
	self.SpawnInfos = spawnInfos or {};
	self.Members = members or {};
	self.TeamLeaders = teamLeaders or {};

	return self;
end

-- —————————————————————————————————————————————————————————————————————————— --
--                                     ...                                    --
-- —————————————————————————————————————————————————————————————————————————— --

export type TeamGroupInfo = typeof(TeamGroupInfo.New(...));
return TeamGroupInfo;
