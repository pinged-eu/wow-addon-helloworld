-- This file contains the options for the addon.

-- Define the options table
local options = {
  type = "group",
  name = "Hello World Options",
  desc = "Options for the Hello World addon",
  args = {
    enableZoneMessages = {
      name = "Enable Zone Messages",
      desc = "Enables / disables the zone messages",
      type = "toggle",
      set = function(info, val)
        HelloWorld.db.profile.enableZoneMessage = val
      end,
      get = function(info)
        return HelloWorld.db.profile.enableZoneMessage
      end
    },
  }
}

-- Register the options with the addon
function HelloWorld:RegisterOptions()
  LibStub("AceConfig-3.0"):RegisterOptionsTable("HelloWorld", options)
  LibStub("AceConfigDialog-3.0"):AddToBlizOptions("HelloWorld", "Hello World")
end
