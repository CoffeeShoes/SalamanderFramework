local Players = game:GetService("Players");

Players.PlayerAdded:Connect(function(player)
	local leaderstatsFolder = Instance.new("Folder");
	leaderstatsFolder.Name = "leaderstats";
	
	local kills = Instance.new("IntValue");
	kills.Name = "Kills";

	local deaths = Instance.new("IntValue");
	deaths.Name = "Deaths";

	local damage = Instance.new("IntValue");
	damage.Name = "Damage";

	kills.Parent = leaderstatsFolder;
	deaths.Parent = leaderstatsFolder;
	damage.Parent = leaderstatsFolder;
	leaderstatsFolder.Parent = player;
end);

return nil;
