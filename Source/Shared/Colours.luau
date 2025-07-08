local Colours = {};

local Sheet = game.ReplicatedStorage.Design.Colours;

Colours.Accept = Sheet:GetAttribute("AcceptColour");
Colours.Reject = Sheet:GetAttribute("RejectColour");
Colours.Neutral = Sheet:GetAttribute("NeutralColour");

return Colours;
