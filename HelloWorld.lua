local name = UnitName("player")

local f = CreateFrame("Frame")

function f:OnEvent(event, ...)
	self[event](self, event, ...)
end

function f:ADDON_LOADED(event, addOnName)
	print(event, addOnName)
end

function f:PLAYER_ENTERING_WORLD(event, isLogin, isReload)
	print(event, isLogin, isReload)
end

function f:CHAT_MSG_CHANNEL(event, text, playerName, _, channelName)
	print(event, text, playerName, channelName)
end

f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("CHAT_MSG_CHANNEL")
f:SetScript("OnEvent", OnEvent)

message("Hello, " .. name .. "!")
