local TeamsWindow = {};

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");

local TeamGroupRemotes = require(game.ReplicatedStorage.Source.TeamGroups.TeamGroupRemotes);
local HoverTooltip = require("../Tooltips/HoverTooltip");

local Client = Players.LocalPlayer;
local SharedAssets = ReplicatedStorage.Assets;
local UIAssets = SharedAssets.UI.Admin;
local TeamConfigBox = UIAssets.TeamConfigBox;
local Gui = UIAssets.AdminGui;
local Window = Gui.TeamsWindow;
local TeamList = Window.ContentHolder.TeamList;

local Enabled = false;

-- —————————————————————————————————————————————————————————————————————————— --
--                                  Functions                                 --
-- —————————————————————————————————————————————————————————————————————————— --

local function MakeTeamConfigBox(info: TeamGroupRemotes.TeamGroupInfo, matchInProgress: boolean?)
	local configBox = TeamConfigBox:Clone();
	configBox.Name = info.Id
	configBox.TeamName.Text = info.Name;
	
	configBox.Spawn.BackgroundColor3 = info.TeamColour.Color;
	configBox.Uniform.BackgroundColor3 = info.TeamColour.Color;
	configBox.Colour.BackgroundColor3 = info.TeamColour.Color;
	configBox.TeamLeader.BackgroundColor3 = info.TeamColour.Color;
	
	HoverTooltip.AssignGuiElementTooltip(configBox.DeleteDisabled, "You can not delete teams while a match is in progress.");
	HoverTooltip.AssignGuiElementTooltip(configBox.Spawn, "Change Spawn");
	HoverTooltip.AssignGuiElementTooltip(configBox.Uniform, "Change Uniform");
	HoverTooltip.AssignGuiElementTooltip(configBox.Colour, "Change Team Color");
	HoverTooltip.AssignGuiElementTooltip(configBox.TeamLeader, "Change Team Leaders");

	configBox.Delete.Visible = matchInProgress == false;
	configBox.DeleteDisabled.Visible = matchInProgress == true;

--	Connections

	configBox.TeamName.FocusLost:Connect(function()
		local newTeamName = configBox.TeamName.Text;
		if newTeamName == "" then newTeamName = "Unnamed Team"; end
		configBox.TeamName.Text = newTeamName;

		info.Name = newTeamName;
		TeamGroupRemotes.UpdateTeamGroup:FireServer({ NewTeamGroupInfo = info });
	end);

	configBox.Visible = true;
	configBox.Parent = TeamList;

	return configBox;
end

-- —————————————————————————————————————————————————————————————————————————— --
--                                   Methods                                  --
-- —————————————————————————————————————————————————————————————————————————— --

										--[=[
@param NoRefreshIds : string • An array of TeamGroupIds that say which TeamGroups do not need to be refreshed, for instance if they've just been updated by the admin, and the changes are already present on said admin's client gui.
										]=]--
function TeamsWindow.Refresh(NoRefreshIds: { string }?)
	local success, response = pcall(function()
		return TeamGroupRemotes.GetAllTeamGroupInfos:InvokeServer();
	end);

	if not (success and response) then
		warn(`Could not refresh TeamsWindow: '{response}'`);
		return;
	end

	for _, configBox in TeamList:GetChildren() do
		if not configBox:IsA("Frame") then continue; end
		if NoRefreshIds and table.find(NoRefreshIds, configBox.Name) then continue; end
		configBox:Destroy();
	end
	
	for _, info in response.AllTeamGroupInfos do
		if NoRefreshIds and table.find(NoRefreshIds, info.Id) then return; end
		MakeTeamConfigBox(info);
	end

	local matchInProgress = TeamGroupRemotes.MatchInProgress:InvokeServer();
	TeamList.AddTeam.Visible = not matchInProgress;
	TeamList.AddTeamDisabled = matchInProgress;
end

function TeamsWindow.Enable()
	if Enabled then return; end

	local tweenInfo = TweenInfo.new(.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out);
	TweenService:Create(Window, tweenInfo, { AnchorPoint = Vector2.new(.5, .5) }):Play();
end

function TeamsWindow.Disable()
	if not Enabled then return; end

	local tweenInfo = TweenInfo.new(.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out);
	TweenService:Create(Window, tweenInfo, { AnchorPoint = Vector2.new(0, .5) }):Play();
end

function TeamsWindow.Toggle()
	if Enabled then TeamsWindow.Disable() else TeamsWindow.Enable(); end
end

-- —————————————————————————————————————————————————————————————————————————— --
--                                 Connections                                --
-- —————————————————————————————————————————————————————————————————————————— --

TeamList.AddTeam.Activated:Connect(function()
	local success, response = pcall(function()
		return TeamGroupRemotes.CreateTeamGroup:InvokeServer();
	end);
	
	if not (success and response) then
		warn(`Could not add team: '{response}'`);
	end

	TeamsWindow.Refresh();
end);

-- —————————————————————————————————————————————————————————————————————————— --
--                                     ...                                    --
-- —————————————————————————————————————————————————————————————————————————— --

HoverTooltip.AssignGuiElementTooltip(TeamList.AddTeamDisabled, "You cannot add teams while a match is in progress.")
Window.AnchorPoint = Vector2.new(0, .5);

return TeamsWindow;
