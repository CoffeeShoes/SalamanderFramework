--	Vizzun • 2025-05-25
--
--	This class is intented for features that are locked behind some
--	sort of common restriction. Currently this class supports:
--
--		• Restricting based a player's rank in a group
--		• Restricting based on a player's team.
--		• Restricting based on a player's UserId (i.e. only a
--		  select few will have permission)
--		• Restricting based on a player account's age.
--		• Restricting based on a game pass ownership.
--		• Restricting based on a minimum score in several
--		• leaderstat scores.
--
--	For a player to "pass" the restrictions, they have to fulfill all
--	requirements in the lock. An example would be requiring a player to
--	both be in a group and to have an old enough account – to unlock, say a
--	cosmetic.
--
--	If you wish to use this class in a way that allows a player to unlock
--	something if they fulfill one of several requirements, it is recommended
--	to combine multiple instances of this class in whatever function checks
--	for permission, each with its own way to unlocking – in which caswe,if
--	the :HasPermission() method returns true in one of the class instances,
--	the player should be given permission.
--	
--	You can add multiple requirements in a single code chain.
--	Each :AddXXXLock() method returns the class instance, allowing you to
--	chain the methods together.

local PermissionLock = {};
local Members = {
	__index = PermissionLock;
	__mode = "k";
};
setmetatable(Members :: any, Members);

-- —————————————————————————————————————————————————————————————————————————— --
--                                    Class                                   --
-- —————————————————————————————————————————————————————————————————————————— --

local MarketplaceService = game:GetService("MarketplaceService");
local LeaderstatFolderName = "leaderstats"; --> the folder under each player containing their leaderstats

-- —————————————————————————————————————————————————————————————————————————— --
--                                   Object                                   --
-- —————————————————————————————————————————————————————————————————————————— --

function PermissionLock.New()
	local self, priv = setmetatable({}, Members), {};
	Members[self] = priv;

	priv.TeamLock = nil :: Team?;

--	All group ranks must be correct for a user to pass the lock.
	priv.GroupLock = nil :: { [number]: NumberRange }?;

--	To keep with the "all required" convention, only one UserId is supported
--	here. Use several PermissionLock instances to add multiple users, as
--	detailed in the opening comment at the top of this script.
	priv.UserIdLock = nil :: number?
	
	priv.AccountAgeLock = nil :: number?;

--	All gamepasses are required to pass the lock.
	priv.GamePassLocks = nil :: { number }?;

	priv.LeaderstatLocks = nil :: { [string]: number }?;
	priv.CustomLock = nil :: ((player: Player) -> (boolean))?

	return self;
end

function PermissionLock:HasPermission(player: Player)
	local priv = Members[self];
	local userId = player.UserId;

	if priv.UserIdLock and userId ~= priv.UserIdLock then return false; end
	if priv.AccountAgeLock and player.AccountAge < priv.AccountAgeLock then
		return false;
	end

	if priv.TeamLock then
		if player.Team ~= priv.TeamLock then return false; end
	end

	if priv.CustomLock then
		if not priv.CustomLock(player) then return false; end
	end

	if priv.LeaderstatLocks then
		local playerStatFolder = player:FindFirstChild(LeaderstatFolderName);
		if not playerStatFolder then return false; end
		for statName, minScore in priv.LeaderstatLocks do
			local valueBase = playerStatFolder:FindFirstChild(statName);
			if not (valueBase and valueBase:IsA("ValueBase") and valueBase.Value >= minScore) then return false; end
		end
	end

	if priv.GroupLock then
		for groupId, rankRange in priv.GroupLock do
			local rank = player:GetRankInGroup(groupId);
			if rank < rankRange.Min or rank > rankRange.Max then return false; end
		end
	end

	if priv.GamePassLocks then
		for _, gamepassId in priv.GamePassLocks do
			if not MarketplaceService:UserOwnsGamePassAsync(userId, gamepassId) then return false; end
		end
	end

	return true;
end

function PermissionLock:AddUserIdLock(userId: number)
	local priv = Members[self];
	priv.UserIdLock = userId;
	return self;
end

function PermissionLock:AddGroupLock(groupId: number, rankRange: NumberRange)
	local priv = Members[self];
	if not priv.GroupLock then priv.GroupLock = {}; end

	priv.GroupLock[groupId] = rankRange;
	return self;
end

function PermissionLock:AddGamePassLock(gamepassId: number)
	local priv = Members[self];
	if not priv.GamePassLocks then priv.GamePassLocks = {}; end

	table.insert(priv.GamePassLocks, gamepassId);
	return self;
end

function PermissionLock:AddAccountAgeLock(minAccountAge: number)
	local priv = Members[self];
	priv.AccountAgeLock = minAccountAge;
end

function PermissionLock:AddLeaderstatLock(statName: string, minScore: number)
	local priv = Members[self];
	if not priv.LeaderstatLocks then priv.LeaderstatLocks = {}; end

	priv.LeaderstatLocks[statName] = minScore;
	return self;
end

function PermissionLock:AddTeamLock(team: Team)
	local priv = Members[self];
	
	priv.TeamLock = team;
	return self;
end

function PermissionLock:AddCustomLock(callback: (player: Player) -> (boolean))
	local priv = Members[self];
	priv.CustomLock = callback;
end

-- —————————————————————————————————————————————————————————————————————————— --
--                                     ...                                    --
-- —————————————————————————————————————————————————————————————————————————— --

export type PermissionLock = typeof(PermissionLock.New(...));
return PermissionLock;
