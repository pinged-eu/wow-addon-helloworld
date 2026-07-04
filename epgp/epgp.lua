--[[-----------------------------------------------------------------------------
    EPGP Integration for HelloWorld
    Adds GP (Gear Points) tooltip lines for equippable items.
-------------------------------------------------------------------------------]]

local EPGP = {}

--- Use TooltipDataProcessor (retail 10.0+) to inject GP info on items.
-- For Classic (pre-10.0), use: GameTooltip:HookScript("OnTooltipSetItem", ...)
TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, function(tooltip, data)
  -- print("TooltipDataProcessor: " .. tostring(tooltip) .. ", " .. tostring(data))
    -- data contains the item info directly (no need for tooltip:GetItem())
    -- if tooltip == GameTooltip then
    --     print("OnTooltipSetItem", tooltip, data)
    -- end
    local itemID = data and (data.id or data.itemID)
    if not itemID then
        return
    end

    -- Retrieve the equip slot (index 9). By the time this fires,
    -- the item info is guaranteed to be cached, so this is safe.
    local slotValue = EPGP:GetSlotValue(itemID)
    if slotValue == 0 then
        return
    end

    -- Add the GP line to the tooltip
    tooltip:AddLine("GP: " .. EPGP:calculateGP(itemID, slotValue), 1, 1, 1)
end)

-- Calculates the GP value for a given item ID.
function EPGP:calculateGP(itemID, slotValue)
    local itemValue = self:GetItemValue(itemID)
    if itemValue == 0 then
        return 0
    end
    -- wowpedia: GP = itemValue^2 * 0.04 * slotValue
    return math.floor((itemValue * itemValue) * 0.04 * slotValue + 0.5)
end

-- Slot value multiplier used in the EPGP formula (defaults to 0 for unsupported slots).
-- Common multipliers:
--   1.0   = head, chest, legs, 2-handed weapons
--   0.777 = shoulders, hands, waist, feet
local SLOT_VALUE = {
  ["INVTYPE_HEAD"]       = 1,
  ["INVTYPE_CHEST"]      = 1,
  ["INVTYPE_LEGS"]       = 1,
  ["INVTYPE_2HWEAPON"]  = 1,
  ["INVTYPE_SHOULDER"]   = 0.777,
  ["INVTYPE_HAND"]       = 0.777,
  ["INVTYPE_WAIST"]      = 0.777,
  ["INVTYPE_FEET"]       = 0.777,
  ["INVTYPE_TRINKET"]  = 0.7,
    ["INVTYPE_WRIST"]    = 0.55,
    ["INVTYPE_NECK"]     = 0.55,
    ["INVTYPE_BACK"]     = 0.55,
    ["INVTYPE_FINGER"]   = 0.55,
    ["INVTYPE_OFFHAND"]  = 0.55,
  ["INVTYPE_SHIELD"]   = 0.55,
  ["INVTYPE_1HWEAPON"] = 0.42,
  ["INVTYPE_RANGEDRIGHT"] = 0.42,
  ["INVTYPE_RANGED"] = 0.42,
  ["INVTYPE_WAND"] = 0.42,
}

function EPGP:GetSlotValue(itemId)
    local equipSlot = select(9, GetItemInfo(itemId))
    return SLOT_VALUE[equipSlot] or 0
end

function EPGP:GetItemValue(itemId)
    -- Item quality IDs (0-based, from select(3, GetItemInfo)):
    --   0 = poor, 1 = common, 2 = uncommon (green)
    --   3 = rare (blue), 4 = epic (purple), 5 = legendary (orange)
    --
    -- Formulas:
    --   Uncommon: (itemLevel - 4)     / 2
    --   Rare:     (itemLevel - 1.84)  / 1.6
    --   Epic:     (itemLevel - 1.3)   / 1.3
    --   Legendary:(itemLevel - 1.2)   / 1.2
    --   Anything else -> 0
    if not C_Item.IsItemDataCachedByID(itemId) then
        return 0
    end
    local _, _, itemQuality, itemLevel = GetItemInfo(itemId)
    if not itemLevel then
        return 0
    end

    local itemValue = 0
    if itemQuality == 2 then         -- uncommon (green)
        itemValue = (itemLevel - 4) / 2
    elseif itemQuality == 3 then     -- rare (blue)
        itemValue = (itemLevel - 1.84) / 1.6
    elseif itemQuality == 4 then     -- epic (purple)
        itemValue = (itemLevel - 1.3) / 1.3
    elseif itemQuality == 5 then     -- legendary (orange)
        itemValue = (itemLevel - 1.2) / 1.2
    end
    return itemValue
end

function EPGP:OnInitialize()
    -- Initialize any necessary state or data here

end
