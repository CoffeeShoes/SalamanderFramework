local MapWindow = {};

local ReplicatedStorage = game:GetService("ReplicatedStorage");

local MapRemotes = require(game.ReplicatedStorage.Source.Maps.MapRemotes);

local UIAssets = ReplicatedStorage.Assets.UI.Admin;
local MapOption = UIAssets.MapOption;
local Gui = UIAssets.AdminGui;
local Window = Gui.MapWindow;

local IsEnabled = false;
local SelectedOption: typeof(MapOption)?;
local ConfirmConnection: RBXScriptConnection;

-- —————————————————————————————————————————————————————————————————————————— --
--                                   Methods                                  --
-- —————————————————————————————————————————————————————————————————————————— --

function MapWindow.Enable()
	if IsEnabled then return; end
	IsEnabled = true;
	MapWindow.RefreshOptions();
	Window.Visible = true;
end

function MapWindow.Disable()
	if not IsEnabled then return; end
	Window.Visible = false;
	MapWindow.ClearOptions();
	IsEnabled = false;
end

function MapWindow.ClearOptions()
	SelectedOption = nil;
	for _, option in Window.ContentHolder.MapList:GetChildren() do
		option:Destroy();
	end

	if ConfirmConnection then ConfirmConnection:Disconnect(); end
end

function MapWindow.RefreshOptions()
	MapWindow.ClearOptions();

	local allMapInfosSuccess, allMapInfosResponse = xpcall(function()
		return MapRemotes.GetAllMapInfos:InvokeServer();
	end, warn);

	if not allMapInfosSuccess then return; end
	if allMapInfosResponse.Type == "Error" then
		warn(allMapInfosResponse.Error);
		return;
	end

	local currentMapInfoSuccess, currentMapInfoResponse = xpcall(function()
		return MapRemotes.GetCurrentMapInfo:InvokeServer();
	end, warn);

	if not currentMapInfoSuccess then return; end
	if currentMapInfoResponse.Type == "Error" then
		warn(currentMapInfoResponse.Error);
		return;
	end

	local allMapInfos = allMapInfosResponse.Data;
	local currentMapInfo = currentMapInfoResponse.Data;

	for _, mapInfo in allMapInfos do
		local option = MapOption:Clone();
		option.Name = mapInfo.Id;
		option.Title.Text = mapInfo.DisplayName;

		option.Activated:Connect(function()
			if mapInfo.Id == currentMapInfo.Id then return; end

			if SelectedOption == option then
				SelectedOption = nil;
				option.Selected.Visible = false;

				Window.ContentHolder.Confirm.Visible = false;
				Window.ContentHolder.ConfirmDisabled.Visible = true;

				return;
			end

			if SelectedOption then
				SelectedOption.Selected.Visible = false;
			end

			option.Selected.Visible = true;
			SelectedOption = option;
			Window.ContentHolder.Confirm.Visible = true;
			Window.ContentHolder.ConfirmDisabled.Visible = false;
		end);

		option.Visible = true;
		option.Parent = Window.ContentHolder.MapList;
	end

	ConfirmConnection = Window.ContentHolder.Confirm.Activated:Connect(function()
		if not SelectedOption then return; end
		local success, response = xpcall(function()
			return MapRemotes.ChangeMap:InvokeServer({ MapId = SelectedOption.Name });
		end, warn);

		if not success then return; end
		if response.Type == "Error" then
			warn(response.Error);
			return;
		end

		MapWindow.Disable();
	end);
end

-- —————————————————————————————————————————————————————————————————————————— --
--                                     ...                                    --
-- —————————————————————————————————————————————————————————————————————————— --

MapWindow.Disable();
MapWindow.ClearOptions();
Window.Visible = false;

return MapWindow;
