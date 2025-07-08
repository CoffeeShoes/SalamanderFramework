local CAMERA_CFRAME = CFrame.new(5.40338993, 454.80542, 15.8128624, 1.00000501, 0.0105506107, 0, -1.01954356e-08, 0, 1, 0.0105506107, -1.00000501, 0);

local SpawnPickerScreen = {};

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");

local TeamGroupRemotes = require(game.ReplicatedStorage.Source.TeamGroups.TeamGroupRemotes);
local MapRemotes = require(game.ReplicatedStorage.Source.Maps.MapRemotes);

local Client = Players.LocalPlayer;
local SharedAssets = ReplicatedStorage.Assets;
local UIAssets = SharedAssets.UI.Admin;
local SpawnWindow = UIAssets.SpawnWindow;
local Gui = UIAssets.AdminGui;
local Screen = Gui.SpawnPickerScreen;

-- —————————————————————————————————————————————————————————————————————————— --
--                                   Methods                                  --
-- —————————————————————————————————————————————————————————————————————————— --

function SpawnPickerScreen.Clear()
	Screen.Visible = false;
	for _, window in Screen:GetChildren() do
		if not window:IsA("Frame") then continue; end
		window:Destroy();
	end
end

function SpawnPickerScreen.PickSpawn(teamGroupId: string)
	local teamGroupInfo;
	local mapInfo;

	local camera = workspace.CurrentCamera;
	
	do --> Team group info
		local result = TeamGroupRemotes.GetTeamGroupInfo:InvokeServer({ TeamGroupId = teamGroupId });

		if result.Type == "Error" then
			warn(`Could not pick spawn: '{result.Error}'`);
			return;
		end

		teamGroupInfo = result.Response;
	end

	do --> Map spawn info
		local result = MapRemotes.GetCurrentMapInfo:InvokeServer();

		if result.Type == "Error" then
			warn(`Could not pick spawn: '{result.Error}'`);
			return;
		end

		mapInfo = result.Response;
	end

	camera.CameraType = Enum.CameraType.Scriptable;
	camera.CFrame = CAMERA_CFRAME;
	Screen.TeamName.Text = teamGroupInfo.Name
	Screen.TeamName.TextColor3 = teamGroupInfo.TeamColour.Color;

	for _, spawn in mapInfo.SpawnInfos do
		local screenPosition = camera:WorldToScreenPoint(spawn.Location);
		local window = SpawnWindow:Clone();

		local isEnabled = false;
		for _, otherSpawn in teamGroupInfo.SpawnInfos do
			if otherSpawn.Id ~= spawn.Id then continue; end
			isEnabled = true;
		end

		window.Elements.ToggleEnabled.Visible = isEnabled;
		window.Elements.ToggleDisabled.Visible = not isEnabled;
		window.Elements.SpawnName.Text = spawn.DisplayName;
		
	end

	Screen.Visible = true;

	Screen.Exit.Activated:Wait();
	SpawnPickerScreen.Clear();
	camera.CameraType = Enum.CameraType.Custom;
end

-- —————————————————————————————————————————————————————————————————————————— --
--                                     ...                                    --
-- —————————————————————————————————————————————————————————————————————————— --

SpawnPickerScreen.Clear();

return SpawnPickerScreen;
