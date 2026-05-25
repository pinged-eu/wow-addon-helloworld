--[[-----------------------------------------------------------------------------
    EPGP Integration for HelloWorld
    Adds GP (Gear Points) tooltip lines for chest items.
-------------------------------------------------------------------------------]]

local EPGP = {}

--- Use TooltipDataProcessor (retail 10.0+) to inject GP info on chest items.
-- For Classic (pre-10.0), use: GameTooltip:HookScript("OnTooltipSetItem", ...)
TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, function(tooltip)
    -- Get the item link from the tooltip
    local itemLink = select(2, tooltip:GetItem())
    if not itemLink then
        return
    end

    -- Extract the item ID from the hyperlink
    local itemID = tonumber(itemLink:match("item:(%d+)"))
    if not itemID then
        return
    end

    -- Retrieve the equip slot (index 9). By the time this fires,
    -- the item info is guaranteed to be cached, so this is safe.
    local equipSlot = select(9, GetItemInfo(itemID))
    if equipSlot ~= "INVTYPE_CHEST" then
        return
    end

    -- Add the GP line to the tooltip
    tooltip:AddLine("GP: 0", 1, 1, 1)
end)
