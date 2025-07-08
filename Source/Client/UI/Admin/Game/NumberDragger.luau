local NumberDragger = {};
local Meta = { __index = NumberDragger };
local Members = {};

-- —————————————————————————————————————————————————————————————————————————— --
--                                    Class                                   --
-- —————————————————————————————————————————————————————————————————————————— --

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");

local Client = Players.LocalPlayer;

-- —————————————————————————————————————————————————————————————————————————— --
--                                   Object                                   --
-- —————————————————————————————————————————————————————————————————————————— --

--[=[
@param dragUIElement GuiObject • The element which is used for triggering the dragging. Holding the primary button while hovering over this begins the dragging.
@param displayTextElement TextBox | TextButton | TextLabel • The text object which is used to display the current value. If the 'unitText' parameter is provided, this will show at the end of this box. For instance, a NumberDragger with the unitText "Points" can display "100 Points".
@param inputs { Enum.UserInputType | Enum.KeyCode }? • The inputs that can trigger the dragger, if hovering over it. By default these are set to the primary inputs of all devices, but can be changed if desired.
@param axis ("X" | "Y")? • The axis that the mouse has to move to change the value. Default value: '"X"'.
@param startValue number? • The starting value of the NumberDragger, before being altered by the user. If the 'minValue' and 'maxValue' parameters are provided, the start value will be clamped within these values.
@param minValue number? • The minimum value of the NumberDragger.
@param maxValue number? • The maximum value of the NumberDragger.
@param increment number? • When the user is increasing or decreasing the value, the value will shift in increments of this size. Default value: '1'.
@param pixelsPerIncrement number? • The number of pixels that the mouse have to move in the axis direction to change by one increment. I.e., the smaller the number, the faster the NumberDragger will appear to change. Default value: '10'.
@param exponential boolean? • If set to true, the value will start increasing quicker the further the mouse moves from the starting point. Default value: 'false'.
@param unitText string? • The unit of the dragger. Can be "Points" or "Minutes" for instance, but can also be left empty if no unit text is needed.
]=]--
function NumberDragger.New(
	dragUIElement: GuiObject,
	displayTextElement: TextBox | TextButton | TextLabel,
	inputs: { Enum.UserInputType | Enum.KeyCode }?,
	axis: ("X" | "Y")?,
	startValue: number?,
	minValue: number?,
	maxValue: number?,
	increment: number?,
	pixelsPerIncrement: number?,
	exponential: boolean?,
	unitText: string?
)
	local self, priv = setmetatable({}, Meta), {};
	Members[self] = priv;

	priv.DragElement = dragUIElement;
	priv.DisplayElement = displayTextElement;
	
	priv.Inputs = inputs or { Enum.UserInputType.MouseButton1, Enum.UserInputType.Touch, Enum.KeyCode.ButtonA };
	priv.Axis = axis or "X";
	priv.MinValue = minValue or 0;
	priv.MaxValue = maxValue or math.huge;
	priv.Increment = increment or 1;
	priv.PixelsPerIncrement = pixelsPerIncrement or 1;
	priv.Exponential = exponential == true;
	priv.UnitText = if unitText then " " .. unitText else "";

	priv.CurrentValue = if startValue then math.clamp(startValue, priv.MinValue, priv.MaxValue) else priv.MinValue;
	priv.Dragging = false;
	priv.DisplayElement.Text = priv.CurrentValue .. priv.UnitText;

	priv.DragElement.InputBegan:Connect(function(input)
		if priv.Dragging then return; end
		if not (table.find(priv.Inputs, input.UserInputType) or table.find(priv.Inputs, input.KeyCode)) then return; end

		priv.Dragging = true;
		
		local mouse = Client:GetMouse();
		local startPosition = if priv.Axis == "X" then mouse.X else mouse.Y;
		local startValue = priv.CurrentValue;

		while RunService.Heartbeat:Wait() and priv.Dragging do
			local currentPosition = if priv.Axis == "X" then mouse.X else mouse.Y;
			local deltaPosition = currentPosition - startPosition;
			local absoluteDeltaPosition = math.abs(deltaPosition);
			local negativeMultiplier = deltaPosition // absoluteDeltaPosition;
			local incrementsMoved = absoluteDeltaPosition // priv.PixelsPerIncrement;

			local exponentialMultiplier = 1;
			if priv.Exponential then
				exponentialMultiplier = incrementsMoved ^ 2; --> not technically exponential but who cares
			end

			local valueChange = negativeMultiplier * incrementsMoved * priv.Increment * exponentialMultiplier;
			local newValue = math.clamp(startValue + valueChange, priv.MinValue, priv.MaxValue);
			
			priv.CurrentValue = newValue;
			priv.DisplayElement.Text = newValue .. priv.UnitText;
		end
	end);

	priv.DragElement.InputEnded:Connect(function(input)
		if not priv.Dragging then return; end
		if not (table.find(priv.Inputs, input.UserInputType) or table.find(priv.Inputs, input.KeyCode)) then return; end

		priv.Dragging = false;
	end);

	return self;
end

function NumberDragger:GetValue()
	local priv = Members[self];
	return priv.CurrentValue;
end

function NumberDragger:SetValue(newValue: number, ignoreClamp: boolean?)
	local priv = Members[self];
	priv.CurrentValue = if ignoreClamp then newValue else math.clamp(newValue, priv.MinValue, priv.MaxValue);
end

-- —————————————————————————————————————————————————————————————————————————— --
--                                     ...                                    --
-- —————————————————————————————————————————————————————————————————————————— --

export type NumberDragger = typeof(NumberDragger.New(...));
return NumberDragger;
