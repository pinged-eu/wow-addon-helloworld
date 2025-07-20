local L = LibStub("AceLocale-3.0"):NewLocale("HelloWorld", "deDE")
if L then
    L["hello"] = function(name)
        return "Hallo, " .. name .. "!";
    end

    L["zoneChanged"] = function(zone)
        return "Du hast die Zone geändert! Du bist jetzt in " .. zone .. "!";
    end

    L["zoneChangedSub"] = function(zone, subzone)
        return "Du hast die Zone geändert! Du bist jetzt in " .. subzone .. " innerhalb von " .. zone .. "!";
    end

    L["welcomeHome"] = function(name)
        return "Willkommen zu Hause, " .. name .. "!";
    end
end
