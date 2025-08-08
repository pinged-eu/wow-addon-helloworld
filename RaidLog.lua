RaidLog = {}

-- Create a new frame
local RaidLogFrame = CreateFrame("Frame", "RaidLogFrame", UIParent)
RaidLogFrame:SetWidth(300)
RaidLogFrame:SetHeight(200)
RaidLogFrame:SetPoint("CENTER", UIParent, "CENTER")
RaidLogFrame:SetMovable(true)
RaidLogFrame:EnableMouse(true)
RaidLogFrame:RegisterForDrag("LeftButton", "RightButton")
RaidLogFrame:SetScript("OnDragStart", function(self)
  self:StartMoving()
end)
RaidLogFrame:SetScript("OnDragStop", function(self)
  self:StopMovingOrSizing()
end)

-- Set background color and transparency
RaidLogFrame.backdrop = RaidLogFrame:CreateTexture(nil, "BACKGROUND")
RaidLogFrame.backdrop:SetAllPoints(RaidLogFrame)
RaidLogFrame.backdrop:SetColorTexture(0, 0.5, 0, 0.25)

-- Create a title bar
local titleBar = RaidLogFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
titleBar:SetPoint("TOP", RaidLogFrame, "TOP", 0, 0)
titleBar:SetText("Raid Log")

-- Create a scroll frame
local scrollFrame = CreateFrame("ScrollFrame", "RaidLogScrollFrame", RaidLogFrame)
scrollFrame:SetPoint("TOPLEFT", RaidLogFrame, "TOPLEFT", 10, -20)
scrollFrame:SetPoint("BOTTOMRIGHT", RaidLogFrame, "BOTTOMRIGHT", -10, 10)

-- Create a frame to hold the text
local textFrame = CreateFrame("Frame", "RaidLogTextFrame", scrollFrame)
textFrame:SetWidth(280) -- Adjust width as needed
scrollFrame:SetScrollChild(textFrame)

local textHeight = 0

-- Function to add a message to the RaidLog
function RaidLog.AddMessage(self, message)
  local newText = textFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  newText:SetText(message)
  newText:SetTextColor(1, 0, 0) -- Set color to red
  newText:SetWidth(280)         -- Adjust width as needed
  newText:SetJustifyH("LEFT")

  -- Position the new text below the previous text
  if textHeight == 0 then
    newText:SetPoint("TOPLEFT", textFrame, "TOPLEFT", 0, 0)
  else
    newText:SetPoint("TOPLEFT", textFrame, "TOPLEFT", 0, textHeight)
  end

  local height = newText:GetHeight()
  textHeight = textHeight - height - 2 -- 2 is spacing between lines

  --Update height of textFrame
  textFrame:SetHeight(math.abs(textHeight))

  -- Adjust scrollbar to bottom
  -- scrollFrame:SetVerticalScrollRange(0, math.abs(textHeight) - scrollFrame:GetHeight())
  scrollFrame:SetVerticalScroll(scrollFrame:GetVerticalScrollRange());
end

-- Create a slash command to show/hide the RaidLog
SLASH_RAIDLOG1 = "/raidlog"
SlashCmdList["RAIDLOG"] = function(msg)
  if RaidLogFrame:IsShown() then
    RaidLogFrame:Hide()
  else
    RaidLogFrame:Show()
  end
end

-- Example usage:
RaidLog:AddMessage("The boss is casting a spell!")
RaidLog:AddMessage("You have been hit by a debuff!")
-- Function to handle chat messages
-- local function OnChatMessage(event, msg, sender, language, channel, _, _, _, _, guid)
--   -- Display all NPC messages
--   if event == "CHAT_MSG_NPC" then
--     RaidLog:AddMessage(msg)
--   end
-- end

-- Register the event
-- local frame = CreateFrame("Frame")
-- frame:RegisterEvent("CHAT_MSG_NPC")
-- frame:SetScript("OnEvent", OnChatMessage)
