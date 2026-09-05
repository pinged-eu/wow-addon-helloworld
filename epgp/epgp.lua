--[[-----------------------------------------------------------------------------
    EPGP Integration for HelloWorld
    Adds GP (Gear Points) tooltip lines for equippable items.
-------------------------------------------------------------------------------]]

local EPGP = {}

-- Compatibility layer: retail (10.0+) exposes C_Item.*, older/Classic clients
-- (e.g. Burning Crusade Classic) only have the classic global API.
local GetItemInfoCompat = (C_Item and C_Item.GetItemInfo) or GetItemInfo
local IsItemDataCachedCompat = (C_Item and C_Item.IsItemDataCachedByID)
    or function(itemId)
        -- Classic API has no dedicated cache check; a successful GetItemInfo
        -- call means the data is already cached client-side.
        return GetItemInfo(itemId) ~= nil
    end

-- Shared handler that adds the GP tooltip line, used by both the retail and
-- classic tooltip hooks below.
local function AddGPLine(tooltip, itemID)
    -- Respect the user's "Show GP on Item Tooltips" option (default: enabled)
    if HelloWorld and HelloWorld.db and HelloWorld.db.profile.showGP == false then
        return
    end
    if not itemID then
        return
    end

    -- Retrieve the equip slot. By the time this fires,
    -- the item info is guaranteed to be cached, so this is safe.
    local slotValue = EPGP:GetSlotValue(itemID)
    if slotValue == 0 then
        return
    end

    -- Add the GP line to the tooltip
    local gp = EPGP:calculateGP(itemID, slotValue)
    if gp == 0 then
        return
    end
    tooltip:AddLine("GP: " .. gp, 1, 1, 1)
end

if TooltipDataProcessor and Enum and Enum.TooltipDataType then
    --- Retail (10.0+): use TooltipDataProcessor to inject GP info on items.
    TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, function(tooltip, data)
        local itemID = data and (data.id or data.itemID)
        AddGPLine(tooltip, itemID)
    end)
else
    --- Classic (e.g. TBC/Wrath/Cata/Mists): no TooltipDataProcessor, fall
    -- back to the classic OnTooltipSetItem hook and resolve the item ID from
    -- the tooltip's item link.
    GameTooltip:HookScript("OnTooltipSetItem", function(tooltip)
        local _, itemLink = tooltip:GetItem()
        if not itemLink then
            return
        end
        local itemID = tonumber(itemLink:match("item:(%d+)"))
        AddGPLine(tooltip, itemID)
    end)
end

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
-- Keys are the ItemEquipLoc strings returned by C_Item.GetItemInfo (see Enum.InventoryType).
-- Common multipliers:
--   1.0   = head, chest, legs, 2-handed weapons, robes
--   0.777 = shoulders, hands, waist, feet
local SLOT_VALUE = {
    ["INVTYPE_HEAD"]           = 1,
    ["INVTYPE_CHEST"]          = 1,
    ["INVTYPE_LEGS"]           = 1,
    ["INVTYPE_2HWEAPON"]       = 1,
    ["INVTYPE_ROBE"]           = 1,
    ["INVTYPE_SHOULDER"]       = 0.777,
    ["INVTYPE_HAND"]           = 0.777,
    ["INVTYPE_WAIST"]          = 0.777,
    ["INVTYPE_FEET"]           = 0.777,
    ["INVTYPE_TRINKET"]        = 0.7,
    ["INVTYPE_WRIST"]          = 0.55,
    ["INVTYPE_NECK"]           = 0.55,
    ["INVTYPE_CLOAK"]          = 0.55,
    ["INVTYPE_FINGER"]         = 0.55,
    ["INVTYPE_SHIELD"]         = 0.55,
    ["INVTYPE_HOLDABLE"]       = 0.55,
    ["INVTYPE_WEAPON"]         = 0.42,
    ["INVTYPE_RANGEDRIGHT"]    = 0.42,
    ["INVTYPE_RANGED"]         = 0.42,
    ["INVTYPE_WEAPONMAINHAND"] = 0.42,
    ["INVTYPE_WEAPONOFFHAND"]  = 0.42,
    ["INVTYPE_THROWN"]         = 0.42,
    ["INVTYPE_RELIC"]          = 0.42,
}

function EPGP:GetSlotValue(itemId)
    if not IsItemDataCachedCompat(itemId) then
        return 0
    end
    local equipSlot = select(9, GetItemInfoCompat(itemId))
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
    if not IsItemDataCachedCompat(itemId) then
        return 0
    end
    local _, _, itemQuality, itemLevel = GetItemInfoCompat(itemId)
    if not itemLevel then
        return 0
    end

    if itemQuality == 0 or itemQuality == 1 then
        -- gray and white items: no GP value
        return 0
    elseif itemQuality == 2 then     -- uncommon (green)
        return (itemLevel - 4) / 2
    elseif itemQuality == 3 then     -- rare (blue)
        return (itemLevel - 1.84) / 1.6
    elseif itemQuality == 4 then     -- epic (purple)
        return (itemLevel - 1.3) / 1.3
    elseif itemQuality == 5 then     -- legendary (orange)
        return (itemLevel - 1.2) / 1.2
    else
        -- Artifact (6), Heirloom (7), WowToken (8): no GP value
        return 0
    end
end
