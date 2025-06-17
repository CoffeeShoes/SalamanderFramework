local Hotkey = {};
local Meta = { __index = Hotkey };
local Members = {};

-- —————————————————————————————————————————————————————————————————————————— --
--                                    Class                                   --
-- —————————————————————————————————————————————————————————————————————————— --

local UserInputService = game:GetService("UserInputService");
local Signal = require(game.ReplicatedStorage.Source.Signal);

local Active: { Hotkey } = {};

-- —————————————————————————————————————————————————————————————————————————— --
--                                   Object                                   --
-- —————————————————————————————————————————————————————————————————————————— --

function Hotkey.New()
	local self, priv = setmetatable({}, Meta), {};
	Members[self] = priv;

--	Public
	self.TriggerBegan = Signal.New();
	self.TriggerEnded = Signal.New();

--	Private
	priv.DesktopShortcuts = {};
	priv.ConsoleShortcuts = {};
	priv.MobileShortcuts = {};
	
	return self;
end

function Hotkey:AddDesktopShortcuts(...: Enum.KeyCode | Enum.UserInputType)
	local priv = Members[self];
	local shortcuts = { ... };

	for _, shortcut in shortcuts do
		table.insert(priv.DesktopShortcuts, shortcut);
	end
end

function Hotkey:AddConsoleShortcuts(...: Enum.KeyCode | Enum.UserInputType)
	local priv = Members[self];
	local shortcuts = { ... };

	for _, shortcut in shortcuts do
		table.insert(priv.ConsoleShortcuts, shortcut);
	end
end

function Hotkey:AddMobileShortcuts(...: Enum.KeyCode | Enum.UserInputType)
	local priv = Members[self];
	local shortcuts = { ... };

	for _, shortcut in shortcuts do
		table.insert(priv.MobileShortcuts, shortcut);
	end
end

function Hotkey:Destroy()
	local _ = Members[self];
	self.TriggerBegan:DisconnectAll();
	self.TriggerEnded:DisconnectAll();
	Members[self] = nil;
end

-- —————————————————————————————————————————————————————————————————————————— --
--                                 Connections                                --
-- —————————————————————————————————————————————————————————————————————————— --

UserInputService.InputBegan:Connect(function(inputObject)
	for self, priv in Members do
		if table.find(priv.DesktopShortcuts, inputObject.UserInputType) or table.find(priv.DesktopShortcuts, inputObject.KeyCode) then
			self.TriggerBegan:Fire();
			continue;
		end
		if table.find(priv.ConsoleShortcuts, inputObject.UserInputType) or table.find(priv.ConsoleShortcuts, inputObject.KeyCode) then
			self.TriggerBegan:Fire();
			continue;
		end
		if table.find(priv.MobileShortcuts, inputObject.UserInputType) or table.find(priv.MobileShortcuts, inputObject.KeyCode) then
			self.TriggerBegan:Fire();
			continue;
		end
	end
end);

UserInputService.InputBegan:Connect(function(inputObject)
	for self, priv in Members do
		if table.find(priv.DesktopShortcuts, inputObject.UserInputType) or table.find(priv.DesktopShortcuts, inputObject.KeyCode) then
			self.TriggerEnded:Fire();
			continue;
		end
		if table.find(priv.ConsoleShortcuts, inputObject.UserInputType) or table.find(priv.ConsoleShortcuts, inputObject.KeyCode) then
			self.TriggerEnded:Fire();
			continue;
		end
		if table.find(priv.MobileShortcuts, inputObject.UserInputType) or table.find(priv.MobileShortcuts, inputObject.KeyCode) then
			self.TriggerEnded:Fire();
			continue;
		end
	end
end);

-- —————————————————————————————————————————————————————————————————————————— --
--                                     ...                                    --
-- —————————————————————————————————————————————————————————————————————————— --

export type Hotkey = typeof(Hotkey.New(...));
return Hotkey;
