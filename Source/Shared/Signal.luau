local Signal = {};
local Members = {
	__index = Signal;
	__mode = "k";
}
setmetatable(Members :: any, Members);

-- —————————————————————————————————————————————————————————————————————————— --
--                                    Types                                   --
-- —————————————————————————————————————————————————————————————————————————— --

type Callback = (...any) -> (...any);

-- —————————————————————————————————————————————————————————————————————————— --
--                                   Object                                   --
-- —————————————————————————————————————————————————————————————————————————— --

--	Init

function Signal.New<P..., R...>()
	local self, priv = setmetatable({}, Members), {};
	Members[self] = priv;

	priv.Connected = {} :: { [any]: boolean? };
	
	return self;
end

--	Public

function Signal:Connect(callback: any)
	local priv = Members[self];
	priv.Connected[callback] = true;
end

function Signal:Once(callback: any)
	local priv = Members[self];
	priv.Connected[callback] = false;
end

function Signal:Disconnect(callback: any)
	local priv = Members[self];
	priv.Connected[callback] = nil;
end

function Signal:Wait()
	local priv = Members[self];
	priv.Connected[coroutine.running()] = false;
	return coroutine.yield();
end

function Signal:Fire(...)
	local priv = Members[self];
	for callback, keep in pairs(priv.Connected) do
		priv.Connected[callback] = if keep then true else nil;
		task.spawn(callback, ...);
	end
end

function Signal:DisconnectAll()
	local priv = Members[self];
	for callback in pairs(priv.Connected) do
		priv.Connected[callback] = nil;
	end
end

-- —————————————————————————————————————————————————————————————————————————— --
--                                     ...                                    --
-- —————————————————————————————————————————————————————————————————————————— --

export type Signal = typeof(Signal.New(...));
export type TypedSignal<Parameters...> = {
	Fire: (unknown, Parameters...) -> ();
	Connect: (self: TypedSignal<Parameters...>, callback: (Parameters...) -> ()) -> ();
	Disconnect: (self: TypedSignal<Parameters...>, callback: (Parameters...) -> ()) -> ();
	Once: (self: TypedSignal<Parameters...>, callback: (Parameters...) -> ()) -> ();
	Wait: (self: TypedSignal<Parameters...>) -> (Parameters...);
	DisconnectAll: () -> ();
};
return Signal;
