local SpawnLocation = {};
local Meta = { __index = SpawnLocation };
local Members = {};

-- —————————————————————————————————————————————————————————————————————————— --
--                                    Class                                   --
-- —————————————————————————————————————————————————————————————————————————— --

local Players = game:GetService("Players");

local Signal = require(game.ReplicatedStorage.Source.Signal);
local SpawnInfo = require(game.ReplicatedStorage.Source.Maps.Spawns.SpawnInfo);

local AssignedSpawnLocationByPlayer = {};

function SpawnLocation.UnassignFromPlayer(player: Player)
	AssignedSpawnLocationByPlayer[player] = nil;
end

-- —————————————————————————————————————————————————————————————————————————— --
--                                   Object                                   --
-- —————————————————————————————————————————————————————————————————————————— --

function SpawnLocation.New(spawnInfo: SpawnInfo.SpawnInfo)
	local self, priv = setmetatable({}, Meta), {};
	Members[self] = priv;

	self.Destroying = Signal.New();
	self.Info = spawnInfo;

	return self;
end

-- function SpawnLocation:AssignToPlayer(player: Player)
-- 	local priv = Members[self];
-- 	AssignedSpawnLocationByPlayer[player] = self;
-- end

-- function SpawnLocation:TeleportCharacter(character: Model)
-- 	local priv = Members[self];
-- 	character:PivotTo(CFrame.new(self.Info.Location));
-- end

function SpawnLocation:TeleportPlayer(player: Player)
	local priv = Members[self];
	local character = player.Character;
	if not character then return; end

	self:TeleportCharacter(character);
end

function SpawnLocation:Destroy()
	local priv = Members[self];

	-- for player, spawn in AssignedSpawnLocationByPlayer do
	-- 	if spawn ~= self then continue; end
	-- 	AssignedSpawnLocationByPlayer[player] = nil;
	-- end

	self.Destroying:Fire();
end

-- —————————————————————————————————————————————————————————————————————————— --
--                                 Connections                                --
-- —————————————————————————————————————————————————————————————————————————— --

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		if not AssignedSpawnLocationByPlayer[player] then return; end

	end);
end);

Players.PlayerRemoving:Connect(function(player)
	AssignedSpawnLocationByPlayer[player] = nil;
end);

-- —————————————————————————————————————————————————————————————————————————— --
--                                     ...                                    --
-- —————————————————————————————————————————————————————————————————————————— --

export type SpawnLocation = typeof(SpawnLocation.New(...));
return SpawnLocation;
