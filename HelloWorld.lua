HelloWorld = LibStub("AceAddon-3.0"):NewAddon("HelloWorld", "AceConsole-3.0", "AceEvent-3.0")

local name = UnitName("player")

local L = LibStub("AceLocale-3.0"):GetLocale("HelloWorld")

-- Default settings table
local defaults = {
    profile = {
      optionA = true,
      enableZoneMessage = true, -- Default to enabled
      showGP = true, -- Default to enabled
    }
}

function HelloWorld:OnInitialize()
    -- Called when the addon is loaded
    -- self:Print("OnInitialize..")
    self:Print(L["hello"](name))
    self:RegisterChatCommand("hw", "SlashCommand")
    self:RegisterChatCommand("helloworld", "SlashCommand")

    -- database loading
    self.db = LibStub("AceDB-3.0"):New("HelloWorldDb", defaults)

    self.db.RegisterCallback(self, "OnProfileChanged", "RefreshConfig")
    self.db.RegisterCallback(self, "OnProfileCopied", "RefreshConfig")
    self.db.RegisterCallback(self, "OnProfileReset", "RefreshConfig")

    -- Make sure the options file registers its options
    if self.RegisterOptions then
        self:RegisterOptions()
    end
end

function HelloWorld:RefreshConfig()
  -- would do some stuff here
  self:Print("RefreshConfig..")
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
    self.db.char.money = GetMoney()
    --self.db.global.money[charName] = GetMoney()
    --if self.db.profile.optionA then
    --    self.db.profile.playerName = UnitName("player")
    --end
end

function HelloWorld:OnDisable()
    -- Called when the addon is disabled
    self:Print("onDisable..")
end

function HelloWorld:ZONE_CHANGED()
  -- Use the setting from the profile
  if self.db.profile.enableZoneMessage then
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
