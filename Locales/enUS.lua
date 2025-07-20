local L = LibStub("AceLocale-3.0"):NewLocale("HelloWorld", "enUS", true)
if L then
    L["hello"] = function(name)
        return "Hi, " .. name .. "!"
    end
    L["zoneChanged"] = function(zone)
        return "You have changed the zone! You are now in " .. zone .. "!";
    end
    L["zoneChangedSub"] = function(zone, subzone)
        return "You have changed the zone! You are now in " .. subzone .. " of " .. zone .. "!";
    end

    L["welcomeHome"] = function(name)
        return "Welcome home, " .. name .. "!";
    end
end
