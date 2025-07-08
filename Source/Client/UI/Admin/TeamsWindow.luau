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
local IsMatchInProgress = false;

-- —————————————————————————————————————————————————————————————————————————— --
--                                  Functions                                 --
-- —————————————————————————————————————————————————————————————————————————— --

local function MakeTeamConfigBox(info: TeamGroupRemotes.TeamGroupInfo)
	local configBox = TeamConfigBox:Clone();
	configBox.Name = info.Id
	configBox.TeamName.Text = info.DisplayName;
	
	configBox.Spawn.BackgroundColor3 = info.TeamColour.Color;
	configBox.Uniform.BackgroundColor3 = info.TeamColour.Color;
	configBox.Colour.BackgroundColor3 = info.TeamColour.Color;
	configBox.TeamLeader.BackgroundColor3 = info.TeamColour.Color;
	
	HoverTooltip.AssignGuiElementTooltip(configBox.DeleteDisabled, "You can not delete teams while a match is in progress.");
	HoverTooltip.AssignGuiElementTooltip(configBox.Spawn, "Change Spawn");
	HoverTooltip.AssignGuiElementTooltip(configBox.Uniform, "Change Uniform");
	HoverTooltip.AssignGuiElementTooltip(configBox.Colour, "Change Team Color");
	HoverTooltip.AssignGuiElementTooltip(configBox.TeamLeader, "Change Team Leaders");

	configBox.Delete.Visible = IsMatchInProgress == false;
	configBox.DeleteDisabled.Visible = IsMatchInProgress == true;

--	Connections

	configBox.TeamName.FocusLost:Connect(function()
		local newTeamName = configBox.TeamName.Text;
		if newTeamName == "" then newTeamName = "Unnamed Team"; end
		configBox.TeamName.Text = newTeamName;

		info.DisplayName = newTeamName;
		TeamGroupRemotes.UpdateTeamGroup:FireServer({ NewTeamGroupInfo = info });
	end);

	--TODO: add all the other configs here as well, colours, team leaders, etc.

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

	TeamList.AddTeam.Visible = not IsMatchInProgress;
	TeamList.AddTeamDisabled = IsMatchInProgress;
end

function TeamsWindow.Enable()
	if Enabled then return; end
	Enabled = true;

	TeamsWindow.Refresh();
	local tweenInfo = TweenInfo.new(.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out);
	TweenService:Create(Window, tweenInfo, { AnchorPoint = Vector2.new(.5, .5) }):Play();
end

function TeamsWindow.Disable()
	if not Enabled then return; end
	Enabled = false;

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
	local result = TeamGroupRemotes.CreateTeamGroup:InvokeServer();
	
	if result.Type == "Error" then
		warn(`Could not add team: '{result.Error}'`);
		return;
	end

	MakeTeamConfigBox(result.Response);
	TeamsWindow.Refresh({ result.Response.Id });
end);

TeamGroupRemotes.MatchStatusChanged.OnClientEvent:Connect(function(info)
	IsMatchInProgress = info.IsMatchInProgress;
end);

-- —————————————————————————————————————————————————————————————————————————— --
--                                     ...                                    --
-- —————————————————————————————————————————————————————————————————————————— --

HoverTooltip.AssignGuiElementTooltip(TeamList.AddTeamDisabled, "You cannot add teams while a match is in progress.")
Window.AnchorPoint = Vector2.new(0, .5);

return TeamsWindow;
