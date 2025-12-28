HelloWorld = LibStub("AceAddon-3.0"):NewAddon("HelloWorld", "AceConsole-3.0", "AceEvent-3.0")

local name = UnitName("player")

local L = LibStub("AceLocale-3.0"):GetLocale("HelloWorld")

function HelloWorld:OnInitialize()
    -- Called when the addon is loaded
    -- self:Print("onInit..")
    self:Print(L["hello"](name))
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
    -- self:Print("onEnable..")
    self:RegisterEvent("ZONE_CHANGED")
end

function HelloWorld:OnDisable()
    -- Called when the addon is disabled
    -- self:Print("onDisable..")
end

function HelloWorld:ZONE_CHANGED()
  if HelloWorld.enableZoneMessage then
    local thisZone = GetZoneText()
    local subzone = GetSubZoneText()
    -- self:Print("onZoneChanged..")
    if subzone == "" then
        self:Print(L["zoneChanged"](thisZone))
    else
        self:Print(L["zoneChangedSub"](thisZone, subzone))
    end

    if GetBindLocation() == subzone then
        self:Print(L["welcomeHome"](name))
    end
  end
end
