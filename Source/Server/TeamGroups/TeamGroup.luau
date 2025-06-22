local TeamGroup = {};
local Members = {
	__index = TeamGroup;
	__mode = "k";
};
setmetatable(Members :: any, Members);

-- —————————————————————————————————————————————————————————————————————————— --
--                                    Class                                   --
-- —————————————————————————————————————————————————————————————————————————— --

local GroupService = game:GetService("GroupService");
local HttpService = game:GetService("HttpService");
local Players = game:GetService("Players");
local Teams = game:GetService("Teams");

local TeamGroupRemotes = require(game.ReplicatedStorage.Source.TeamGroups.TeamGroupRemotes);

local 	DEFAULT_ICON_ASSET_ID	= "rbxassetid://0";
local 	SPECTATING_TEAM 		= Instance.new("Team");
	SPECTATING_TEAM.Name 		= "Spectator";
	SPECTATING_TEAM.TeamColor 	= BrickColor.White();
	SPECTATING_TEAM.AutoAssignable 	= true;
	SPECTATING_TEAM.Parent 		= Teams;

-- —————————————————————————————————————————————————————————————————————————— --
--                                   Object                                   --
-- —————————————————————————————————————————————————————————————————————————— --

function TeamGroup.New(name: string, colour: BrickColor?, robloxGroupId: number?)
	local self, priv = setmetatable({}, Members), {};
	Members[self] = priv;

	self.Id = HttpService:GenerateGUID(false);
	self.Name = name;
	self.BrickColour = colour or BrickColor.Gray();
	self.GroupId = robloxGroupId;

	self.Team = Instance.new("Team");
	self.Team.Name = self.Name;
	self.Team.TeamColor = self.BrickColour;

	if self.GroupId then
		self.GroupInfo = GroupService:GetGroupInfoAsync(self.GroupId);
		self.IconAssetId = self.GroupInfo.EmblemUrl;
		self.IconColour = Color3.new(1, 1, 1);
	else
		self.IconAssetId = DEFAULT_ICON_ASSET_ID;
		self.IconColour = self.BrickColour.Color;
	end

	return self;
end

function TeamGroup:Destroy();
	local priv = Members[self];

	for _, player in Players:GetPlayers() do
		if player.Team ~= self.Team then continue; end
		player.TeamColor = SPECTATING_TEAM.TeamColor;
		player:LoadCharacter();
	end

	self.Team:Destroy();
end

function TeamGroup:GetInfo(): TeamGroupRemotes.TeamGroupInfo
	local priv = Members[self];

	local response: TeamGroupRemotes.TeamGroupInfo = {
		Id = self.Id;
		Name = self.Name;
		TeamColour = self.Team.TeamColor;
		Colour = self.Team.TeamColor.Color;
		GroupId = self.GroupId;
	};

	return response;
end

-- —————————————————————————————————————————————————————————————————————————— --
--                                     ...                                    --
-- —————————————————————————————————————————————————————————————————————————— --

export type TeamGroup = typeof(TeamGroup.New(...));
return TeamGroup;
