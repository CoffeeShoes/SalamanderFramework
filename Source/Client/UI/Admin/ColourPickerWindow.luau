local ColourPicker = {};

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");

local HoverTooltip = require("../Tooltips/HoverTooltip");

local Client = Players.LocalPlayer;
local SharedAssets = ReplicatedStorage.Assets;
local UIAssets = SharedAssets.UI.Admin;
local Gui = UIAssets.AdminGui;
local Window = Gui.ColourPickerWindow;
local Options = Window.ColourOptions;

local ButtonConnections = {};

-- —————————————————————————————————————————————————————————————————————————— --
--                                   Methods                                  --
-- —————————————————————————————————————————————————————————————————————————— --

function ColourPicker.PromptPick()
	local thread = coroutine.running();

	for _, button in Options:GetChildren() do
		if not button:IsA("GuiButton") then continue; end
		
		table.insert(ButtonConnections, button.MouseEnter:Connect(function()
			HoverTooltip.Set(button.Name);
		end));

		table.insert(ButtonConnections, button.Activated:Connect(function()
			task.spawn(thread, BrickColor.new(button.Name));
		end));
	end

	table.insert(ButtonConnections, Options.MouseLeave:Connect(function()
		HoverTooltip.Disable()
	end));

	table.insert(ButtonConnections, Window.ExitTab.Exit.Activated:Connect(function()
		task.spawn(thread, nil);
	end));

	Window.Visible = true;

	local choice = coroutine.yield();
	for _, connection in ButtonConnections do connection:Disconnect(); end

	Window.Visible = false;

	return choice :: BrickColor?;
end

-- —————————————————————————————————————————————————————————————————————————— --
--                                     ...                                    --
-- —————————————————————————————————————————————————————————————————————————— --

Window.Visible = false;

return ColourPicker;
