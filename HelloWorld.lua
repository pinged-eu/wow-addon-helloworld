HelloWorld = LibStub("AceAddon-3.0"):NewAddon("HelloWorld", "AceConsole-3.0", "AceEvent-3.0")

local name = UnitName("player")

---@class L
local _, L = ...;

function HelloWorld:OnInitialize()
	-- Called when the addon is loaded
	self:Print(L["hello"] .. name .. "!")
	self:RegisterChatCommand("hw", "SlashCommand")
	self:RegisterChatCommand("helloworld", "SlashCommand")
end

function HelloWorld:SlashCommand(msg)
	if msg == "ping" then
		self:Print("pong!")
	else
		self:Print("hello there!")
	end
end

function HelloWorld:OnEnable()
	self:RegisterEvent("ZONE_CHANGED")
end

function HelloWorld:OnDisable()
	-- Called when the addon is disabled
end

function HelloWorld:ZONE_CHANGED()
	local subzone = GetSubZoneText()
	self:Print("You have changed zones!", GetZoneText(), subzone)
	if GetBindLocation() == subzone then
		self:Print("Welcome Home!")
	end
end
