local ns = (select(2, ...))
local APC = ns
APC.frames = {
    mainFrame = {}
}

function APC.frames.initFrames()
    APC.frames.mainFrame:initFrame()
end

function APC.frames.mainFrame:initFrame()
    -- Frame 
    APC.frames.mainFrame = CreateFrame("Frame", "AucProfitCalc", UIParent, 'BasicFrameTemplate')
    APC.frames.mainFrame:SetMovable(true)
    APC.frames.mainFrame:SetWidth(338)
    APC.frames.mainFrame:SetHeight(424)
    APC.frames.mainFrame:Hide()

    APC.frames.mainFrame.title = APC.frames.mainFrame:CreateFontString('MainFrameTitle')
    APC.frames.mainFrame.title:SetFontObject('GameFontHighlight')
    APC.frames.mainFrame.title:SetText('Auction profit calculator')
    APC.frames.mainFrame.title:SetPoint('TOP', APC.frames.mainFrame, 'TOP', 0, -5)
    
    APC.frames.mainFrame.scrollFrame = CreateFrame("ScrollFrame", "AucProfitCalcScroll", APC.frames.mainFrame, 'FauxScrollFrameTemplate')
    APC.frames.mainFrame.scrollFrame:SetWidth(310)
    APC.frames.mainFrame.scrollFrame:SetHeight(280)
    APC.frames.mainFrame.scrollFrame:SetPoint("TOPLEFT", APC.frames.mainFrame, "TOPLEFT", 0, -96)
    local function asd(i)
        if i == 1 then 
            return APC.frames.mainFrame.scrollFrame 
        else 
            return 'AucProfitCalcScrollButton' .. i - 1
        end
    end
    local function asd2(i)
        if i == 1 then 
            return 'TOPLEFT' 
        else 
            return 'BOTTOMLEFT'
        end
    end
    for i = 1, 10, 1 do
        btn = CreateFrame('Button', '$parentButton' .. i, APC.frames.mainFrame.scrollFrame, 'UIPanelButtonTemplate')
        btn:SetSize(80 ,22) -- width, height
        btn:SetText("Button " .. i)
        btn:SetPoint("TOPLEFT", asd(i), asd2(i))
    end

    function APC.frames.mainFrame:ShowFrame()
        APC.frames.mainFrame:SetPoint("TOPLEFT", TradeSkillFrame, "TOPRIGHT")
        APC.frames.mainFrame:Show()
    end
end
