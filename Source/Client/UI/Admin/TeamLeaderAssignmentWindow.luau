local TeamLeaderAssignmentWindow = {};

local ReplicatedStorage = game:GetService("ReplicatedStorage");

local TeamGroupRemotes = require(game.ReplicatedStorage.Source.TeamGroups.TeamGroupRemotes);

local UIAssets = ReplicatedStorage.Assets.UI.Admin;
local TeamLeaderOption = UIAssets.TeamLeaderOption;
local Gui = UIAssets.AdminGui;
local MainWindow = Gui.TeamLeaderAssignmentWindow;

-- —————————————————————————————————————————————————————————————————————————— --
--                                   Methods                                  --
-- —————————————————————————————————————————————————————————————————————————— --

function TeamLeaderAssignmentWindow.ClearOptions()
	for _, option in MainWindow.Elements.Options:GetChildren() do
		if not option:IsA("Frame") then continue; end
		option:Destroy();
	end
end

function TeamLeaderAssignmentWindow.BeginAssignment(teamGroupId: string)
	local success, infoResponse = xpcall(function()
		return TeamGroupRemotes.GetTeamGroupInfo:InvokeServer({ TeamGroupId = teamGroupId });
	end, warn);
	
	if not success then return; end
	if infoResponse.Type == "Error" then
		warn(`Could not assign team leader: '{infoResponse.Error}'`);
		return;
	end

	local info = infoResponse.Data;
	local members = info.Members;
	local teamLeaders = info.TeamLeaders;

	for _, player in members do
		local option = TeamLeaderOption:Clone();
		option.Name = player.UserId;
		option.PlayerName.Text = player.Name;

		local isTeamLeader = table.find(teamLeaders, player) ~= nil;
		option.ToggleEnabled.Visible = isTeamLeader
		option.ToggleDisabled.Visible = not isTeamLeader;

		option.ToggleEnabled.Activated:Connect(function()
			option.ToggleEnabled.Visible = false;
			option.ToggleDisabled.Visible = true;
			local i = table.find(teamLeaders, player);
			if not i then return; end
			table.remove(teamLeaders, i);
		end);

		option.ToggleDisabled.Activated:Connect(function()
			option.ToggleDisabled.Visible = false;
			option.ToggleEnabled.Visible = true;
			if table.find(teamLeaders, player) then return; end
			table.insert(teamLeaders, player);
		end);
	end

	MainWindow.ExitTab.Exit.Activated:Once(function()
		TeamLeaderAssignmentWindow.ClearOptions();
		TeamGroupRemotes.UpdateTeamLeaders:InvokeServer({ TeamGroupId = teamGroupId, TeamLeaders = teamLeaders });
		MainWindow.Visible = false;
	end);

	MainWindow.Visible = true;
end

-- —————————————————————————————————————————————————————————————————————————— --
--                                     ...                                    --
-- —————————————————————————————————————————————————————————————————————————— --

TeamLeaderAssignmentWindow.ClearOptions();
MainWindow.Visible = false;

return TeamLeaderAssignmentWindow;
