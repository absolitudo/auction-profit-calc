local ns = (select(2, ...))
local APC = ns
APC.frames = {
    mainFrame = {}
}

function APC.frames.InitFrames()
    APC.frames.mainFrame:InitFrame()
end

function APC.frames.mainFrame:InitFrame()
    

    local myData = {}

    for i = 1, 10, 1 do
        myData[i] = i
    end


    APC.frames.mainFrame = CreateFrame("Frame", "AucProfitCalc", UIParent, 'BasicFrameTemplate')
    APC.frames.mainFrame:SetMovable(true)
    APC.frames.mainFrame:SetWidth(338)
    APC.frames.mainFrame:SetHeight(424)
    APC.frames.mainFrame:Hide()

    APC.frames.mainFrame.title = APC.frames.mainFrame:CreateFontString('MainFrameTitle')
    APC.frames.mainFrame.title:SetFontObject('GameFontHighlight')
    APC.frames.mainFrame.title:SetText('Auction profit calculator')
    APC.frames.mainFrame.title:SetTextColor(1, 0.8, 0, 1)
    APC.frames.mainFrame.title:SetPoint('TOP', APC.frames.mainFrame, 'TOP', 0, -5)
    
    APC.frames.mainFrame.selectedRecipeIcon = CreateFrame('Frame', 'RecipeIconFrame', APC.frames.mainFrame)
    APC.frames.mainFrame.selectedRecipeIcon:SetWidth(40)
    APC.frames.mainFrame.selectedRecipeIcon:SetHeight(40)
    APC.frames.mainFrame.selectedRecipeIcon:SetPoint('TOPLEFT', APC.frames.mainFrame, 'TOPLEFT', 10, -40)
    APC.frames.mainFrame.selectedRecipeIcon.texture = APC.frames.mainFrame.selectedRecipeIcon:CreateTexture("$parentTexture")
    APC.frames.mainFrame.selectedRecipeIcon.texture:SetAllPoints()

    APC.frames.mainFrame.selectedRecipeTextFrame = CreateFrame('Frame', 'RecipeTextFrame', APC.frames.mainFrame)
    APC.frames.mainFrame.selectedRecipeTextFrame.text = APC.frames.mainFrame.selectedRecipeTextFrame:CreateFontString('SelectedRecipeName')
    APC.frames.mainFrame.selectedRecipeTextFrame.text:SetFontObject('GameFontHighlight')
    APC.frames.mainFrame.selectedRecipeTextFrame.text:SetTextColor(1, 0.8, 0, 1)
    APC.frames.mainFrame.selectedRecipeTextFrame.text:SetPoint('TOPLEFT', APC.frames.mainFrame, 'TOPLEFT', 60, -55)

    local scrollFrameHeight = 280
    local scrollFrameRow = 2
    local scrollFrameRowHeight = scrollFrameHeight / scrollFrameRow
    APC.frames.mainFrame.scrollFrame = CreateFrame("ScrollFrame", "AucProfitCalcScroll", APC.frames.mainFrame, 'FauxScrollFrameTemplate')
    APC.frames.mainFrame.scrollFrame:SetWidth(310)
    APC.frames.mainFrame.scrollFrame:SetHeight(scrollFrameHeight)
    APC.frames.mainFrame.scrollFrame:SetPoint("TOPLEFT", APC.frames.mainFrame, "TOPLEFT", 0, -96)
    APC.frames.mainFrame.scrollFrame.rows = {}

    for i = 1, scrollFrameRow, 1 do
        APC.frames.mainFrame.scrollFrame.rows[i] = CreateFrame('Frame', '$parentRow' .. i, APC.frames.mainFrame.scrollFrame)
        APC.frames.mainFrame.scrollFrame.rows[i]:SetWidth(310)
        APC.frames.mainFrame.scrollFrame.rows[i]:SetHeight(scrollFrameRowHeight)
        APC.frames.mainFrame.scrollFrame.rows[i]:SetBackdrop({
            bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", tile = true, tileSize = 16,
            insets = { left = 4, right = 4, top = 4, bottom = 4 },
        })

        APC.frames.mainFrame.scrollFrame.rows[i].textFrame = APC.frames.mainFrame.scrollFrame.rows[i]:CreateFontString('$parentText' .. i)
        APC.frames.mainFrame.scrollFrame.rows[i].textFrame:SetFontObject('GameFontHighlight')
        APC.frames.mainFrame.scrollFrame.rows[i].textFrame:SetText('Auction profit calculator')
        APC.frames.mainFrame.scrollFrame.rows[i].textFrame:SetPoint('CENTER', APC.frames.mainFrame.scrollFrame.rows[i], 'CENTER')

        if i == 1 then 
            APC.frames.mainFrame.scrollFrame.rows[i]:SetPoint("TOPLEFT", APC.frames.mainFrame.scrollFrame, 'TOPLEFT' , 0, 0)
        else 
            APC.frames.mainFrame.scrollFrame.rows[i]:SetPoint("TOPLEFT", 'AucProfitCalcScrollRow' .. i - 1 , 'BOTTOMLEFT')
        end
    end

    function APC.frames.mainFrame.scrollFrame:Update()
        FauxScrollFrame_Update(self, #myData, scrollFrameRow, scrollFrameRowHeight)

        local offset = FauxScrollFrame_GetOffset(self)

        for i = 1, scrollFrameRow do
            local value = offset + i
            local row = self.rows[i]
            if value <= value then
                row.textFrame:SetText("Data: " .. myData[value])
                row:Show()
            else
                row:Hide()
            end
        end
    end

    APC.frames.mainFrame.scrollFrame:SetScript("OnVerticalScroll", function(self, offset)
        FauxScrollFrame_OnVerticalScroll(self, offset, scrollFrameRowHeight, APC.frames.mainFrame.scrollFrame.Update)
    end)
    
    APC.frames.mainFrame.scrollFrame:SetScript("OnShow", function()
        APC.frames.mainFrame.scrollFrame:Update()
    end)

    function APC.frames.mainFrame:ShowFrame()
        APC.frames.mainFrame:SetPoint("TOPLEFT", TradeSkillFrame, "TOPRIGHT")
        APC.frames.mainFrame:Show()
    end

    function APC.frames.mainFrame:UpdateSelectedRecipeView()
        APC.frames.mainFrame.selectedRecipeIcon.texture:SetTexture(APC.selectedRecipe.icon)
        APC.frames.mainFrame.selectedRecipeTextFrame.text:SetText(APC.selectedRecipe.name)
    end    

end
