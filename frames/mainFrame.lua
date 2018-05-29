local ns = (select(2, ...))
local APC = ns

local function createMainFrame()
    APC.frames.mainFrame = CreateFrame("Frame", "APCMainFrame", UIParent, 'BasicFrameTemplate')
    APC.frames.mainFrame:SetFrameStrata("DIALOG")
    APC.frames.mainFrame:SetMovable(true)
    APC.frames.mainFrame:SetWidth(338)
    APC.frames.mainFrame:SetHeight(424)
    APC.frames.mainFrame:EnableMouse(true)
    APC.frames.mainFrame:Hide()
    APC.frames.mainFrame.UpdateSelectedRecipeView = function(self)
        APC.CalcProfit()
        APC.UpdateSelectedRecipeInMainFrame()
        FauxScrollFrame_OnVerticalScroll(APC.frames.mainFrame.scrollFrame, 0, APC.frames.mainFrame.scrollFrame.rowHeight, APC.frames.mainFrame.scrollFrame.Update)
    end
    APC.frames.mainFrame.ShowFrame = function(self)
        APC.frames.mainFrame:SetPoint("TOPLEFT", TradeSkillFrame, "TOPRIGHT")
        APC.frames.mainFrame:Show()
    end
end

local function createMainFrameTitle()
    APC.frames.mainFrame.title = APC.frames.mainFrame:CreateFontString('APCMainFrameTitle')
    APC.frames.mainFrame.title:SetFontObject('GameFontHighlight')
    APC.frames.mainFrame.title:SetText('Auction profit calculator')
    APC.frames.mainFrame.title:SetTextColor(1, 0.8, 0, 1)
    APC.frames.mainFrame.title:SetPoint('TOP', APC.frames.mainFrame, 'TOP', 0, -5)
end

APC.frames.frameInitializer.MainFrame = function()
   createMainFrame()
   createMainFrameTitle()
end

