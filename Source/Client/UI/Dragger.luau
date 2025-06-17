local Dragger = {};
local Meta = { __index = Dragger };
local Members = {};

-- —————————————————————————————————————————————————————————————————————————— --
--                                    Class                                   --
-- —————————————————————————————————————————————————————————————————————————— --

local Players = game:GetService("Players");

local PRIMARY_INPUTS = {
	Enum.UserInputType.MouseButton1;
	Enum.UserInputType.Touch;
	Enum.KeyCode.ButtonA;
};

local Client = Players.LocalPlayer;

-- —————————————————————————————————————————————————————————————————————————— --
--                                   Object                                   --
-- —————————————————————————————————————————————————————————————————————————— --

function Dragger.New(dragHandle: GuiObject, getsDragged: { GuiObject }, maxTransformationPixels: Vector2)
	local self, priv = setmetatable({}, Meta), {};
	Members[self] = priv;

	priv.DragHandle = dragHandle;
	priv.BasePositionsByElements = {} :: { [GuiObject]: UDim2 };
	priv.MaxTransformation = maxTransformationPixels;

	priv.Dragging = false;
	priv.CurrentTransformation = Vector2.new();

	for _, element in getsDragged do
		priv.BasePositionsByElements[element] = element.Position;
	end

	priv.BeganConnection = priv.DragHandle.InputBegan:Connect(function(input)
		if priv.Dragging then return; end
		if not (table.find(PRIMARY_INPUTS, input.UserInputType) or table.find(PRIMARY_INPUTS, input.KeyCode)) then return; end

		priv.Dragging = true;

		local mouse = Client:GetMouse();
		local startXY = Vector2.new(mouse.X, mouse.Y);
		local startTransformation = Vector2.new(priv.CurrentTransformation.X, priv.CurrentTransformation.Y);
		local first = true;

		while priv.Dragging do
			local deltaTime = task.wait();
			local currentXY = Vector2.new(mouse.X, mouse.Y);
			local deltaXY = (currentXY - startXY) * 1.8 + startTransformation;
			local minX = math.min(priv.MaxTransformation.X, 0);
			local maxX = math.max(priv.MaxTransformation.X, 0);
			local minY = math.min(priv.MaxTransformation.Y, 0);
			local maxY = math.max(priv.MaxTransformation.Y, 0);

			local clampedXY = Vector2.new(math.clamp(deltaXY.X, minX, maxX), math.clamp(deltaXY.Y, minY, maxY));

			local lerpedXY = priv.CurrentTransformation:Lerp(clampedXY, math.min(deltaTime / 0.1, 1));

			priv.CurrentTransformation = lerpedXY;
			for element, basePosition in priv.BasePositionsByElements do
				element.Position = basePosition + UDim2.fromOffset(lerpedXY.X, lerpedXY.Y);
			end
		end
	end);

	priv.EndedConnection = priv.DragHandle.InputEnded:Connect(function(input)
		if not priv.Dragging then return; end
		if not (table.find(PRIMARY_INPUTS, input.UserInputType) or table.find(PRIMARY_INPUTS, input.KeyCode)) then return; end

		task.wait(.1);

		priv.Dragging = false;
	end);

	return self;
end

function Dragger:Destroy()
	local priv = Members[self];

	priv.BeganConnection:Disconnect();
	priv.EndedConnection:Disconnect();
end

-- —————————————————————————————————————————————————————————————————————————— --
--                                     ...                                    --
-- —————————————————————————————————————————————————————————————————————————— --

export type Dragger = typeof(Dragger.New(...));
return Dragger;
