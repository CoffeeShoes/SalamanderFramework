local AdminStatus = {};

local PermissionLock = require(game.ReplicatedStorage.Source.PermissionLock);

local AdminLocks = {
	PermissionLock.New():AddUserIdLock(153998122);	-- Vizzun
	PermissionLock.New():AddUserIdLock(7119124767);	-- Heracles
	PermissionLock.New():AddUserIdLock(7136815432);	-- SallyMander
	PermissionLock.New():AddUserIdLock(2324286055);	-- Crowned

--	Private server owner
	PermissionLock.New():AddCustomLock(function(player)
		return game.PrivateServerOwnerId == player.UserId;
	end);
};

function AdminStatus.PlayerIsAdmin(player: Player)
	for _, lock in AdminLocks do
		if lock:HasPermission(player) then return true; end
	end
	return false;
end

function AdminStatus.MakePlayerAdmin(player: Player)
	table.insert(AdminLocks, PermissionLock.New():AddUserIdLock(player.UserId));
	--todo: update the players ui, so they get the admin ui stuff
end

return AdminStatus;
