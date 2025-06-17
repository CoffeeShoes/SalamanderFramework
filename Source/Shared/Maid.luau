local Maid = {};
local Members = {
	__index = Maid;
	__mode = "k";
};
setmetatable(Members :: any, Members);

-- ——————————————————————————————————————————————————————————————————————— --
--                                  Class                                  --
-- ——————————————————————————————————————————————————————————————————————— --



-- ——————————————————————————————————————————————————————————————————————— --
--                                  Object                                 --
-- ——————————————————————————————————————————————————————————————————————— --

function Maid.New(...: any)
	local self, priv = setmetatable({}, Members), {};
	Members[self] = priv;

	priv.Tasks = {};
	self:AddTasks(...);

	return self;
end

function Maid:AddTasks(...: any)
	local priv = Members[self];

	for _, t in {...} do
		table.insert(priv.Tasks, t);
	end
end

function Maid:Clean()
	local priv = Members[self];

	for _, t in priv.Tasks do
		if typeof(t) == "RBXScriptConnection" then
			t:Disconnect();
		elseif typeof(t) == "Instance" then
			t:Destroy();
		elseif typeof(t) == "table" and typeof(t.Destroy) == "function" then
			t:Destroy();
		end
	end

	table.clear(priv.Tasks);
end

function Maid:Destroy()
	self:Clean();
end

-- ——————————————————————————————————————————————————————————————————————— --
--                                   ...                                   --
-- ——————————————————————————————————————————————————————————————————————— --

export type Maid = typeof(Maid.New(...));
return Maid;
