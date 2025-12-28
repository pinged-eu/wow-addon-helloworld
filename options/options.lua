-- This file contains the options for the addon.

-- Define the options table
local options = {
  type="group",
  name="Hello World Options",
  desc="Options for the Hello World addon",
  args={
    enable = {
      name = "Enable",
      desc = "Enables / disables the addon",
      type = "toggle",
      set = function(info,val) HelloWorld.enabled = val end,
      get = function(info) return HelloWorld.enabled end
    },
    enableZoneMessages = {
      name = "Enable Zone Messages",
      desc = "Enables / disables the zone messages",
      type = "toggle",
      set = function(info,val) HelloWorld.enableZoneMessage = val end,
      get = function(info) return HelloWorld.enableZoneMessage end
    },
  }
}

-- Register the options with the addon
function HelloWorld:RegisterOptions()
    LibStub("AceConfig-3.0"):RegisterOptionsTable("HelloWorld", options)
    LibStub("AceConfigDialog-3.0"):AddToBlizOptions("HelloWorld", "Hello World")
end

-- Initialize the addon
function HelloWorld:OnInitialize()
  self:RegisterOptions()
end
