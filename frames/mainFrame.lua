local ns = (select(2, ...))
local APC = ns
APC.frames = {
    mainFrame = {}
}

function APC.frames.initFrames()
    APC.frames.mainFrame:initFrame()
end

function APC.frames.mainFrame:initFrame()
    APC.frames.mainFrame = CreateFrame("Frame", "AucProfitCalc", UIParent, 'BasicFrameTemplate')
    APC.frames.mainFrame:SetMovable(true)
    APC.frames.mainFrame:SetWidth(500)
    APC.frames.mainFrame:SetHeight(500)
    APC.frames.mainFrame:SetPoint("CENTER", UIParent, "CENTER")
    APC.frames.mainFrame:Hide()
end

function APC.frames.mainFrame:Show()
    APC.frames.mainFrame:Show()
end

function APC.frames.mainFrame:Hide()
    APC.frames.mainFrame:Hide()
end
