local HardpointOptions = {};

local ReplicatedStorage = game:GetService("ReplicatedStorage");

local HardpointMatchInfo = require(game.ReplicatedStorage.Source.Game.Matches.HardpointMatchInfo);
local Colours = require(game.ReplicatedStorage.Source.Colours);
local GameClient = require("../../../Game/GameClient");
local MapsClient = require("../../../Maps/MapsClient");
local MapInfo = require(game.ReplicatedStorage.Source.Maps.MapInfo);
local NumberDragger = require("./NumberDragger");

local UIAssets = ReplicatedStorage.Assets.UI;
local AdminUIAssets = UIAssets.Admin;
local Gui = AdminUIAssets.AdminGui;
local GameWindow = Gui.GameWindow;
local Main = GameWindow.ContentHolder.Hardpoint;

local DraggerInputs = { Enum.UserInputType.Touch, Enum.UserInputType.MouseButton1, Enum.KeyCode.ButtonA };
local ScoreDragger = NumberDragger.New(Main.ScoreGoal.Dragger, Main.ScoreGoal.Dragger, DraggerInputs, "Y", 1000, 100, 1000000, 100, 5, true);
local HourDragger = NumberDragger.New(Main.Time.ClockInput.HourDragger, Main.Time.ClockInput.HourDragger, DraggerInputs, "Y", 0, 0, 10, 1, 30, false, "H");
local MinuteDragger = NumberDragger.New(Main.Time.ClockInput.MinuteDragger, Main.Time.ClockInput.MinuteDragger, DraggerInputs, "Y", 30, 0, 59, 1, 10, true, "M");
local SecondDragger = NumberDragger.New(Main.Time.ClockInput.SecondDragger, Main.Time.ClockInput.SecondDragger, DraggerInputs, "Y", 0, 0, 59, 1, 5, true, "S");

local Enabled = false;
local CurrentMatchInfo: GameClient.MatchInfo?;
local ChosenHardpointIndex = 1;

-- —————————————————————————————————————————————————————————————————————————— --
--                                  Functions                                 --
-- —————————————————————————————————————————————————————————————————————————— --

local function UpdateChosenHardpointVisuals(currentMapInfo: MapInfo.MapInfo?)
	local mapInfo = currentMapInfo or MapsClient.GetCurrentMapInfo();
	if not mapInfo then return; end
	
	Main.ChosenHardpoint.Toggles.CaptureToggle.Text = mapInfo.CapturePointInfos[ChosenHardpointIndex].DisplayName;
end

-- —————————————————————————————————————————————————————————————————————————— --
--                                   Methods                                  --
-- —————————————————————————————————————————————————————————————————————————— --

function HardpointOptions.Start()
	local currentMapInfo = MapsClient.GetCurrentMapInfo();
	if not currentMapInfo then return; end

	if #currentMapInfo.CapturePointInfos == 0 then return; end

	if Enabled then return; end
	Enabled = true;
	Main.Visible = true;

	local info = HardpointMatchInfo.New(
		currentMapInfo.CapturePointInfos[ChosenHardpointIndex].Id,
		ScoreDragger:GetValue(),
		HourDragger:GetValue() * 3600 + MinuteDragger:GetValue() * 60 + SecondDragger:GetValue()
	);

	CurrentMatchInfo = info;
end

function HardpointOptions:GetConfiguredMatchInfo()
	return CurrentMatchInfo;
end

function HardpointOptions.Finish(): GameClient.MatchInfo
	if not Enabled then return; end
	Enabled = false;
	Main.Visible = false;

	local info = CurrentMatchInfo;
	CurrentMatchInfo = nil;

	return info;
end

-- —————————————————————————————————————————————————————————————————————————— --
--                                     ...                                    --
-- —————————————————————————————————————————————————————————————————————————— --

Main.ChosenHardpoint.Toggles.CaptureToggle.Activated:Connect(function()
	local currentMapInfo = MapsClient.GetCurrentMapInfo();
	if not currentMapInfo then return; end

	ChosenHardpointIndex = (ChosenHardpointIndex % #currentMapInfo.CapturePointInfos) + 1;
	UpdateChosenHardpointVisuals();
end);

MapsClient.MapChanged:Connect(function(request)
	UpdateChosenHardpointVisuals(request.NewMapInfo);
end);

UpdateChosenHardpointVisuals()
HardpointOptions.Disable();

return HardpointOptions;
