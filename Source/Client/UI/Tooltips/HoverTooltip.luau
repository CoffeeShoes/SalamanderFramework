local HoverTooltip = {};

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");

local Client = Players.LocalPlayer;
local Gui = game.ReplicatedStorage.Assets.UI.Tooltips.TooltipsGui;
local MainFrame = Gui.HoverTooltip;
local Mouse = Client:GetMouse();

local UpdateConnection: RBXScriptConnection?;

local MOUSE_X_OFFSET = 0;
local MOUSE_Y_OFFSET = 0;

-- —————————————————————————————————————————————————————————————————————————— --
--                                   Methods                                  --
-- —————————————————————————————————————————————————————————————————————————— --

function HoverTooltip.Set(message: string)
	MainFrame.Content.Text = message;

	UpdateConnection = RunService.Heartbeat:Connect(function()
		MainFrame.Position = UDim2.fromOffset(Mouse.X + MOUSE_X_OFFSET, Mouse.Y + MOUSE_Y_OFFSET);
	end);

	RunService.Heartbeat:Once(function() MainFrame.Visible = true; end);
end

function HoverTooltip.Disable()
	if UpdateConnection then UpdateConnection:Disconnect(); end
	MainFrame.Visible = false;
end

-- —————————————————————————————————————————————————————————————————————————— --
--                             Gui Initialisation                             --
-- —————————————————————————————————————————————————————————————————————————— --

Gui.ResetOnSpawn = false;
Gui.Parent = Client.PlayerGui;

-- —————————————————————————————————————————————————————————————————————————— --
--                                     ...                                    --
-- —————————————————————————————————————————————————————————————————————————— --

return HoverTooltip;
