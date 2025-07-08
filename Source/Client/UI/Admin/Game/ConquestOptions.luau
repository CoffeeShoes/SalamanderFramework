local ConquestOptions = {};

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");

local ConquestMatchInfo = require(game.ReplicatedStorage.Source.Game.Matches.ConquestMatchInfo);
local Colours = require(game.ReplicatedStorage.Source.Colours);
local GameClient = require("../../../Game/GameClient");
local MapsClient = require("../../../Maps/MapsClient");
local MapInfo = require(game.ReplicatedStorage.Source.Maps.MapInfo);
local NumberDragger = require("./NumberDragger");
local TeamGroupRemotes = require(game.ReplicatedStorage.Source.TeamGroups.TeamGroupRemotes);

local Client = Players.LocalPlayer;
local UIAssets = ReplicatedStorage.Assets.UI;
local AdminUIAssets = UIAssets.Admin;
local GameUIAssets = AdminUIAssets.Game;
local Gui = AdminUIAssets.AdminGui;
local GameWindow = Gui.GameWindow;
local Main = GameWindow.ContentHolder.Conquest;

local DraggerInputs = { Enum.UserInputType.Touch, Enum.UserInputType.MouseButton1, Enum.KeyCode.ButtonA };
local HourDragger = NumberDragger.New(Main.Time.ClockInput.HourDragger, Main.Time.ClockInput.HourDragger, DraggerInputs, "Y", 0, 0, 10, 1, 30, false, "H");
local MinuteDragger = NumberDragger.New(Main.Time.ClockInput.MinuteDragger, Main.Time.ClockInput.MinuteDragger, DraggerInputs, "Y", 30, 0, 59, 1, 10, true, "M");
local SecondDragger = NumberDragger.New(Main.Time.ClockInput.SecondDragger, Main.Time.ClockInput.SecondDragger, DraggerInputs, "Y", 0, 0, 59, 1, 5, true, "S");

local Enabled = false;
local CurrentMatchInfo: GameClient.MatchInfo?;
local DefendingTeamGroupInfo;
local AttackingTeamGroupInfo;
local AllCapturePointIdsInOrder = {};
local EnabledCapturePointIdsInOrder = {};

-- —————————————————————————————————————————————————————————————————————————— --
--                                  Functions                                 --
-- —————————————————————————————————————————————————————————————————————————— --

function UpdateTeamGroupVisuals()
	if not (DefendingTeamGroupInfo and AttackingTeamGroupInfo) then return; end
	Main.TeamRoles.Input.Defending.Text = DefendingTeamGroupInfo.DisplayName;
	Main.TeamRoles.Input.Defending.BackgroundColor3 = DefendingTeamGroupInfo.TeamColour.Color;
	Main.TeamRoles.Input.Attacking.Text = AttackingTeamGroupInfo.DisplayName;
	Main.TeamRoles.Input.Attacking.BackgroundColor3 = AttackingTeamGroupInfo.TeamColour.Color;
end

local function RegenerateCapturePointToggles(mapInfo: MapInfo.MapInfo)
	table.clear(EnabledCapturePointIdsInOrder);
	table.clear(AllCapturePointIdsInOrder);

	for _, toggle in Main.CaptureOrder.Toggles:GetChildren() do
		if toggle.ClassName == GameUIAssets.ConquestCaptureToggle.ClassName then toggle:Destroy(); end
	end

	local currentMapInfo = mapInfo or MapsClient.GetCurrentMapInfo();
	if not currentMapInfo then return; end

	for i, cap in MapsClient do
		local toggle = GameUIAssets.ConquestCaptureToggle:Clone();
		local dragging = false;
		local isEnabled = false;
		local orderPosition = i;

		table.insert(EnabledCapturePointIdsInOrder, cap.Id);
		table.insert(AllCapturePointIdsInOrder, cap.Id);

		toggle.Drag.InputBegan:Connect(function(input)
			if not (table.find(DraggerInputs, input.UserInputType) or table.find(DraggerInputs, input.KeyCode)) then return; end

			dragging = true;
			local mouse = Client:GetMouse();
			local startY = mouse.Y;
			local currentOrderPosition = orderPosition;
			toggle.Parent = Gui;
			Main.CaptureOrder.Toggles.
			Main.CaptureOrder.Toggles.Placeholder.Visible = true;

			while task.wait() and dragging do
				local currentY = mouse.Y;
				local deltaY = currentY - startY;
				local unit = deltaY / math.abs(deltaY);
				orderPosition = (currentOrderPosition + unit * (deltaY % 24)) // 1

				local i = table.find(AllCapturePointIdsInOrder, cap.Id);
				if i then table.remove(AllCapturePointIdsInOrder, i); end
				table.insert(AllCapturePointIdsInOrder, orderPosition, cap.Id);
				
				for i, id in AllCapturePointIdsInOrder do
					local toggle = Main.CaptureOrder.Toggles:FindFirstChild(id);
					if not toggle then continue; end
					if toggle.ClassName ~= GameUIAssets.ConquestCaptureToggle.ClassName then continue; end
					toggle.LayoutOrder = i;
				end

				toggle.LayoutOrder, Main.CaptureOrder.Toggles.Placeholder.LayoutOrder = orderPosition, orderPosition;
				toggle.Position = UDim2.fromOffset(mouse.X - 14, mouse.Y)
			end
		end);

		toggle.Drag.InputEnded:Connect(function(input)
			if not (table.find(DraggerInputs, input.UserInputType) or table.find(DraggerInputs, input.KeyCode)) then return; end
			dragging = false;
			toggle.Parent = Main.CaptureOrder.Toggles;
			Main.CaptureOrder.Toggles.Placeholder.Visible = false;
		end);

		toggle.Activated:Connect(function()
			isEnabled = not isEnabled;
			
			if isEnabled then
				local i = table.find(EnabledCapturePointIdsInOrder, cap.Id);
				if i then table.remove(EnabledCapturePointIdsInOrder, i); end
				table.insert(EnabledCapturePointIdsInOrder, orderPosition, cap.Id);
				toggle.BackgroundColor3 = Colours.Accept;
			else
				local i = table.find(EnabledCapturePointIdsInOrder, cap.Id);
				if i then table.remove(EnabledCapturePointIdsInOrder, i); end
				toggle.BackgroundColor3 = Colours.Neutral;
			end
		end);

		toggle.Name = cap.Id;
		toggle.LayoutOrder = orderPosition;
		toggle.Visible = true;
		toggle.Parent = Main.CaptureOrder.Toggles;
	end
end

-- —————————————————————————————————————————————————————————————————————————— --
--                                   Methods                                  --
-- —————————————————————————————————————————————————————————————————————————— --

function ConquestOptions.Start()
--	Conditions
	
	local success, result = xpcall(function()
		return TeamGroupRemotes.GetAllTeamGroupInfos:InvokeServer();
	end, warn);

	if not success then return; end
	if result.Type == "Error" then
		warn(result.Error);
		return;
	end

	local teamGroups = result.Data;
	if #teamGroups ~= 2 then
		--TODO: WARN PLAYER, need 2 teams
		return;
	end
	
	if Enabled then return; end
	Enabled = true;
	Main.Visible = true;

--	Handling
	
	DefendingTeamGroupInfo = teamGroups[1];
	AttackingTeamGroupInfo = teamGroups[2];

	local info = ConquestMatchInfo.New(
		DefendingTeamGroupInfo.Id,
		AttackingTeamGroupInfo.Id,
		EnabledCapturePointIdsInOrder,
		HourDragger:GetValue() * 3600 + MinuteDragger:GetValue() * 60 + SecondDragger:GetValue()
	);

	CurrentMatchInfo = info;
end

function ConquestOptions:GetConfiguredMatchInfo()
	return CurrentMatchInfo;
end

function ConquestOptions.Finished(): GameClient.MatchInfo
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

Main.TeamRoles.Input.Switch.Activated:Connect(function()
	AttackingTeamGroupInfo, DefendingTeamGroupInfo = DefendingTeamGroupInfo, AttackingTeamGroupInfo;
	UpdateTeamGroupVisuals();
end);

MapsClient.MapChanged:Connect(function(request)
	RegenerateCapturePointToggles(request.NewMapInfo);
end);

RegenerateCapturePointToggles();
ConquestOptions.Disable();

return ConquestOptions;
