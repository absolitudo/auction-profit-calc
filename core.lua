local ns = (select(2, ...))
local APC = ns

APC.frames:initFrames()
APC:registerEvents()

--APC.scanData = {}
--APC.professions = {}

--prof1, prof2, _, _, cooking = GetProfessions()
--APC.professions[1] = function() return GetProfessionInfo(prof1) end
--APC.professions[2] = function() return GetProfessionInfo(prof2) end

--ns.professions['cooking'] = GetProfessionInfo(cooking)




--local function logTable(table)
--   for key, value in pairs(table) do
--        print(key, value)
--        if type(value) == 'table' then
--            logTable(value)
--            print('---')
--       end
--    end
--end
--ns.frames.initFrames()
-- _G.AucAdvanced.GetFaction this is the server key
-- _G.AucAdvanced.Modules.Util.ScanData.GetScanData this is the scan data requires serverkey
--SLASH_AUCPROFITCALC1 = '/apc'
--SlashCmdList['AUCPROFITCALC'] = function(...)
--    local params = ...
--   if params == '' then
--       print(TradeSkillFrame:GetWidth())
--       print(TradeSkillFrame:GetHeight())
        
--   end
--    if params == 'load' then
        --print('loading scan data')
        --_G.AucAdvanced.Scan.LoadScanData()
        --ns.scanData = _G.AucAdvanced.Modules.Util.ScanData.GetScanData(_G.AucAdvanced.GetFaction())
        
--        print(APC.professions[1]())
--        print(APC.professions[2]())
        
--    end

    --if not ns.frames.mainFrame:IsShown() then
    --    ns.frames.mainFrame:Show()
    --else
    --    ns.frames.mainFrame:Hide()
    --end
--end
--[[
----------------------------------------------------------------
-- Set up some constants (really just variables, except we call
-- them "constants" because we will never change their values, 
-- only read them) to keep track of values we'll use repeatedly:

local ROW_HEIGHT = 16   -- How tall is each row?
local MAX_ROWS = 5      -- How many rows can be shown at once?

----------------------------------------------------------------
-- Create some fake data:

local MyAddonDB = {}
for i = 1, 50 do
	MyAddonDB[i] = "Test " .. math.random(100)
end

----------------------------------------------------------------
-- Create the frame:

local frame = CreateFrame("Frame", "MyAddonFrame", UIParent)
frame:EnableMouse(true)
frame:SetMovable(true)
frame:SetSize(196, ROW_HEIGHT * MAX_ROWS + 16)
frame:SetPoint("CENTER")

-- Give the frame a visible background and border:
frame:SetBackdrop({
	bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", tile = true, tileSize = 16,
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 16,
	insets = { left = 4, right = 4, top = 4, bottom = 4 },
})

----------------------------------------------------------------
-- Define a function that we'll call later to update the datum
-- displayed in each row:

function frame:Update()
	-- Using method notation (object:function) means that the
	-- object (in this case, our frame) is available within the
	-- function's scope via the variable "self".

	local maxValue = #MyAddonDB

	-- Call the FauxScrollFrame template's Update function, with
	-- the relevant parameters:
	FauxScrollFrame_Update(self.scrollBar, maxValue, MAX_ROWS, ROW_HEIGHT)
		-- #1 is a reference to the scroll bar frame.
		-- #2 is the total number of data available to be shown.
		-- #3 is how many rows of data can be displayed at once.
		-- #4 is the height of each row.

	-- Now figure out which datum to show in each row,
	-- and show it:
	local offset = FauxScrollFrame_GetOffset(self.scrollBar)
	for i = 1, MAX_ROWS do
		local value = i + offset
		if value <= maxValue then
			-- There is a datum available to show.

			-- Get a local reference to the row to save
			-- two table lookups:
			local row = self.rows[i]
			-- Fill in the row with the datum:
			row:SetText(MyAddonDB[value])
			-- Show the row:
			row:Show()
		else
			-- We've reached the end of the data.
			-- Hide the row:
			self.rows[i]:Hide()
		end
	end
end

----------------------------------------------------------------
-- Create the scroll bar:

local bar = CreateFrame("ScrollFrame", "$parentScrollBar", frame, "FauxScrollFrameTemplate")
bar:SetPoint("TOPLEFT", 0, -8)
bar:SetPoint("BOTTOMRIGHT", -30, 8)

-- Tell the scroll bar what to do when it's scrolled:
bar:SetScript("OnVerticalScroll", function(self, offset)
	-- These first two lines replace a call to the global 
	-- FauxScrollFrame_OnVerticalScroll function, saving a
	-- global lookup and a function call.
	--self:SetValue(offset)
	self.offset = math.floor(offset / ROW_HEIGHT + 0.5)

	-- FauxScrollFrame_OnVerticalScroll can also call an update
	-- function if we pass it one, but since we aren't using it,
	-- we should just call the function ourselves:
	frame:Update()
end)

bar:SetScript("OnShow", function()
	frame:Update()
end)

frame.scrollBar = bar

----------------------------------------------------------------
-- Create the individual rows:

-- I'm using a metatable here for efficiency (rows are not created
-- until they are needed) and convenience (I don't have
-- to check if a row exists yet and create one manually).

-- I don't feel like writing out a long explanation of how this
-- works right now; feel free to look at the "How to localize an
-- addon" page on my author portal for a more detailed explanation
-- of how a metatable like this works. If you don't care how it
-- works, feel free to use it anyway. :)

local rows = setmetatable({}, { __index = function(t, i)
	local row = CreateFrame("Button", "$parentRow"..i, frame)
	row:SetSize(150, ROW_HEIGHT)
	row:SetNormalFontObject(GameFontHighlightLeft)
	
	if i == 1 then
		row:SetPoint("TOPLEFT", frame, 8, 0)
	else
		row:SetPoint("TOPLEFT", frame.rows[i-1], "BOTTOMLEFT")
	end
	
	rawset(t, i, row)
	return row
end })

frame.rows = rows
--]]