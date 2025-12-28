-- This file contains the options for the addon.

-- Define the options table
local options = {
    {
        type = "header",
        name = "Hello World Options",
    },
    {
        type = "checkbox",
        name = "Enable addon",
        desc = "Enable or disable the addon",
        get = function() return true end,
        set = function(value) end,
    },
}

-- Register the options with the addon
function HelloWorld:RegisterOptions()
    LibStub("AceConfig-3.0"):RegisterOptionsTable("HelloWorld", options)
    LibStub("AceConfigDialog-3.0"):AddToBlizOptions("HelloWorld", "Hello World")
end

-- Initialize the addon
function HelloWorld:Initialize()
    self:RegisterOptions()
end
