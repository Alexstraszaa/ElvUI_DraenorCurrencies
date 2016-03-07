local E, L, V, P, G, _ =  unpack(ElvUI);
local DT = E:GetModule('DataTexts')

local labelType = 2 -- 1 = text, 2 = icon, 3 = icon + text
local lastPanel
local displayString = "---"
local _hex
local red = "|cffc74040"
local orange = "|cffda8c4f"

local Currencies = {823, 944, 980, 824, 1101, 994, 1129, 1191}
local state ={true, true, true, true, true, true, true, true}
local MAX = 8

local function getCurrenyCap(name)
	local cap = 0
	if name == "Apexis Crystal" then cap = 0
	elseif name == "Artifact Fragment" then cap = 1000
	elseif name == "Dingy Iron Coins" then cap = 20000
	elseif name == "Garrison Resources" then cap = 10000
	elseif name == "Oil" then cap = 100000
	elseif name == "Seal of Tempered Fate" then cap = 20
	elseif name == "Seal of Inevitable Fate" then cap = 10
	elseif name == "Valor" then cap = 5000
	end
	return cap
end

local function ColorValue(name, currency)
	local color
	local cap = getCurrenyCap(name)
	local percent = currency * (100 / cap)
	
	if percent < 70 then color = _hex
	elseif percent >= 70 and percent < 90 then color = orange
	elseif percent >= 90 then color = red
	end

	if cap == 0 then return _hex
	else return color
	end
end

local function OnEvent(self, event, ...)
	lastPanel = self
	
	local _text = "---"
	if not _hex then return end
	
	for i = 1, MAX do -- MAX_WATCHED_TOKENS
		if i == 1 then 
			displayString = '' 
		end
		local index = Currencies[i]
		local name, count, icon, earnedThisWeek, weeklyMax, totalMax, isDiscovered = GetCurrencyInfo(index)
--		local name, count, icon, itemid = GetBackpackCurrencyInfo(i)
		if isDiscovered and (state[i] == true) then
			if name then
				if(i ~= 1) then _text = " " else _text = "" end
				local texture = format('|T%s:14:14:0:0:64:64:4:60:4:60|t', icon)
				words = { strsplit(" ", name) }
				for _, word in ipairs(words) do
					_text = _text .. string.sub(word,1,1)
				end
				local str
				if labelType == 1 then
					str = tostring(_text..": ".._hex..count.."|r")
				elseif labelType == 2 then
					str = tostring(texture..":"..ColorValue(name, count)..count.._hex.."|r  ")
				elseif labelType == 3 then
					str = tostring(texture.." ".._text..": ".._hex..count.."|r")
				end
				displayString = displayString..str

			elseif i == 1 and not name and not count then 
				displayString = tostring(_hex.."---")
			end
		end
	end	
	if self then 
		self.text:SetFormattedText(displayString)
	end
	displayString = "---"

end

local function OnEnter(self)
	DT:SetupTooltip(self)
	if lastPanel ~= nil then
		OnEvent(lastPanel)
	end
	GameTooltip:Show()
end

local function OnClick(self)
	GetBackpackCurrencyInfo(i)
end

local function ValueColorUpdate(hex, r, g, b)
	_hex = hex
	if lastPanel ~= nil then
		OnEvent(lastPanel)
	end
end
E['valueColorUpdateFuncs'][ValueColorUpdate] = true

--[[
	DT:RegisterDatatext(name, events, eventFunc, updateFunc, clickFunc, onEnterFunc)

	name - name of the datatext (required)
	events - must be a table with string values of event names to register
	eventFunc - function that gets fired when an event gets triggered
	updateFunc - onUpdate script target function
	click - function to fire when clicking the datatext
	onEnterFunc - function to fire OnEnter
]]
DT:RegisterDatatext('DraenorCurrencies', {"PLAYER_LOGIN"}, OnEvent, nil, nil, OnEnter) hooksecurefunc("BackpackTokenFrame_Update", function(...) OnEvent(lastPanel) end)
