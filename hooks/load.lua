local class = require "engine.class"
local Birther = require "engine.Birther"
local ActorTalents = require "engine.interface.ActorTalents"

class:bindHook("ToME:load", function(self, data)
	ActorTalents:loadDefinition("/data-earthmage/talents/talents.lua")
	Birther:loadDefinition("/data-earthmage/birth/classes/mage.lua")
end)

