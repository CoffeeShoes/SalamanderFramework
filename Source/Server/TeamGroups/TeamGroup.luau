local TeamGroup = {};
local Meta = { __index = TeamGroup };
local Members = setmetatable({}, { __mode = "k" });

-- —————————————————————————————————————————————————————————————————————————— --
--                                    Class                                   --
-- —————————————————————————————————————————————————————————————————————————— --

local GroupService = game:GetService("GroupService");
local HttpService = game:GetService("HttpService");
local Players = game:GetService("Players");
local Teams = game:GetService("Teams");

local TeamGroupRemotes = require(game.ReplicatedStorage.Source.TeamGroups.TeamGroupRemotes);
local SpawnLocation = require(game.ServerScriptService.Source.Maps.Spawns.SpawnLocation);
local TeamGroupInfo = require(game.ReplicatedStorage.Source.TeamGroups.TeamGroupInfo);

local 	DEFAULT_ICON_ASSET_ID	= "rbxassetid://0";
local 	SPECTATING_TEAM 		= Instance.new("Team");
	SPECTATING_TEAM.Name 		= "Spectator";
	SPECTATING_TEAM.TeamColor 	= BrickColor.White();
	SPECTATING_TEAM.AutoAssignable 	= true;
	SPECTATING_TEAM.Parent 		= Teams;

local TeamGroupInstances = {};

function TeamGroup.UnteamPlayer(player: Player)
	for _, self in TeamGroupInstances do
		local priv = Members[self];
		local i = table.find(priv.Members, player);
		if not i then continue; end
		table.remove(priv.Members, i);
	end
end


-- —————————————————————————————————————————————————————————————————————————— --
--                                   Object                                   --
-- —————————————————————————————————————————————————————————————————————————— --

function TeamGroup.New(displayName: string, colour: BrickColor?, robloxGroupId: number?, spawnLocations: { SpawnLocation.SpawnLocation }?)
	local self, priv = setmetatable({}, Members), {};
	Members[self] = priv;

	self.Id = HttpService:GenerateGUID(false);
	self.DisplayName = displayName;
	self.BrickColour = colour or BrickColor.Gray();
	self.GroupId = robloxGroupId;

	self.Team = Instance.new("Team");
	self.Team.Name = self.DisplayName;
	self.Team.TeamColor = self.BrickColour;

	priv.SpawnLocations = spawnLocations or {} :: { SpawnLocation.SpawnLocation };
	priv.Members = {} :: { Player };
	priv.TeamLeaders = {};

	if self.GroupId then
		self.GroupInfo = GroupService:GetGroupInfoAsync(self.GroupId);
		self.IconAssetId = self.GroupInfo.EmblemUrl;
		self.IconColour = Color3.new(1, 1, 1);
	else
		self.IconAssetId = DEFAULT_ICON_ASSET_ID;
		self.IconColour = self.BrickColour.Color;
	end

	table.insert(TeamGroupInstances, self);

	return self;
end

function TeamGroup:GetInfo(): TeamGroupRemotes.TeamGroupInfo
	local priv = Members[self];

	local spawnInfos = {};
	for _, spawn in priv.SpawnLocations do
		table.insert(spawnInfos, spawn.Info);
	end

	local info = TeamGroupInfo.New(
		self.Id,
		self.DisplayName,
		self.TeamColour,
		self.GroupId,
		self.SpawnInfos,
		self.Members,
		self.TeamLeaders
	);

	return info;
end

function TeamGroup:ChangeGroupId(newGroupId: number)
	local priv = Members[self];

	self.GroupId = newGroupId;
	return self; --> Chaining
end

function TeamGroup:AddSpawnLocation(spawnLocation: SpawnLocation.SpawnLocation)
	local priv = Members[self];
	local i = table.find(priv.SpawnLocations, spawnLocation);
	if i then return; end
	table.insert(priv.SpawnLocations, spawnLocation);
	return self; --> Chaining
end

function TeamGroup:RemoveSpawnLocation(spawnLocation: SpawnLocation.SpawnLocation)
	local priv = Members[self];
	local i = table.find(priv.SpawnLocations, spawnLocation);
	if not i then return; end
	table.remove(priv.SpawnLocations, i);
end

function TeamGroup:RemoveAllSpawnLocations()
	local priv = Members[self];
	table.clear(priv.SpawnLocations);
end

function TeamGroup:TeamPlayer(player: Player)
	local priv = Members[self];
	TeamGroup.UnteamPlayer(player);
	table.insert(priv.Members, player);
end

function TeamGroup:SetTeamLeaders(teamLeaders: { Player })
	local priv = Members[self];
	priv.TeamLeaders = teamLeaders;
end

function TeamGroup:Destroy()
	local priv = Members[self];

	for _, player in Players:GetPlayers() do
		if player.Team ~= self.Team then continue; end
		player.TeamColor = SPECTATING_TEAM.TeamColor;
		player:LoadCharacter();
	end

	self.Team:Destroy();
end

-- —————————————————————————————————————————————————————————————————————————— --
--                                 Connections                                --
-- —————————————————————————————————————————————————————————————————————————— --

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		for _, self in TeamGroupInstances do
			local priv = Members[self];
			if not table.find(priv.Members, player) then continue; end
			if #priv.SpawnLocations == 0 then continue; end
			local spawn = priv.SpawnLocations[math.random(1, #priv.SpawnLocations)];
			spawn:TeleportPlayer(player);
			break;
		end
	end);
end);

Players.PlayerRemoving:Connect(function(player)
	TeamGroup.UnteamPlayer(player);
end);

-- —————————————————————————————————————————————————————————————————————————— --
--                                     ...                                    --
-- —————————————————————————————————————————————————————————————————————————— --

export type TeamGroup = typeof(TeamGroup.New(...));
return TeamGroup;
