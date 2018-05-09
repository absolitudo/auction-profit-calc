local ns = (select(2, ...))
local APC = ns
APC.frames = {
    mainFrame = {}
}

APC.frames.InitFrames = function()
    APC.frames.mainFrame:InitFrame()
end

APC.frames.mainFrame.InitFrame = function(self)
    local function UpdateSelectedRecipeInMain()
        APC.frames.mainFrame.selectedRecipeIcon.texture:SetTexture(APC.selectedRecipe.icon)
        APC.frames.mainFrame.selectedRecipeTextFrame.text:SetText(APC.selectedRecipe.name)
    end

    local function UpdateScrollFrameRow(row, reagentInfo)
        row.reagentName:SetText(reagentInfo.name)
    end

    -- Main window
    APC.frames.mainFrame = CreateFrame("Frame", "AucProfitCalc", UIParent, 'BasicFrameTemplate')
    APC.frames.mainFrame:SetMovable(true)
    APC.frames.mainFrame:SetWidth(338)
    APC.frames.mainFrame:SetHeight(424)
    APC.frames.mainFrame:Hide()
    APC.frames.mainFrame.UpdateSelectedRecipeView = function(self)
        UpdateSelectedRecipeInMain()
        FauxScrollFrame_OnVerticalScroll(APC.frames.mainFrame.scrollFrame, 0, APC.frames.mainFrame.scrollFrame.rowHeight, APC.frames.mainFrame.scrollFrame.Update)
    end
    APC.frames.mainFrame.ShowFrame = function(self)
        APC.frames.mainFrame:SetPoint("TOPLEFT", TradeSkillFrame, "TOPRIGHT")
        APC.frames.mainFrame:Show()
    end

    -- Window title
    APC.frames.mainFrame.title = APC.frames.mainFrame:CreateFontString('MainFrameTitle')
    APC.frames.mainFrame.title:SetFontObject('GameFontHighlight')
    APC.frames.mainFrame.title:SetText('Auction profit calculator')
    APC.frames.mainFrame.title:SetTextColor(1, 0.8, 0, 1)
    APC.frames.mainFrame.title:SetPoint('TOP', APC.frames.mainFrame, 'TOP', 0, -5)
    
    -- Selected recipe icon
    APC.frames.mainFrame.selectedRecipeIcon = CreateFrame('Frame', 'RecipeIconFrame', APC.frames.mainFrame)
    APC.frames.mainFrame.selectedRecipeIcon:SetWidth(40)
    APC.frames.mainFrame.selectedRecipeIcon:SetHeight(40)
    APC.frames.mainFrame.selectedRecipeIcon:SetPoint('TOPLEFT', APC.frames.mainFrame, 'TOPLEFT', 10, -40)
    APC.frames.mainFrame.selectedRecipeIcon.texture = APC.frames.mainFrame.selectedRecipeIcon:CreateTexture("$parentTexture")
    APC.frames.mainFrame.selectedRecipeIcon.texture:SetAllPoints()
    
    -- Selected recipe name
    APC.frames.mainFrame.selectedRecipeTextFrame = CreateFrame('Frame', 'RecipeTextFrame', APC.frames.mainFrame)
    APC.frames.mainFrame.selectedRecipeTextFrame.text = APC.frames.mainFrame.selectedRecipeTextFrame:CreateFontString('SelectedRecipeName')
    APC.frames.mainFrame.selectedRecipeTextFrame.text:SetFontObject('GameFontHighlight')
    APC.frames.mainFrame.selectedRecipeTextFrame.text:SetTextColor(1, 0.8, 0, 1)
    APC.frames.mainFrame.selectedRecipeTextFrame.text:SetPoint('TOPLEFT', APC.frames.mainFrame, 'TOPLEFT', 55, -55)

    -- Scrollframe for reagents
    APC.frames.mainFrame.scrollFrame = CreateFrame("ScrollFrame", "AucProfitCalcScroll", APC.frames.mainFrame, 'FauxScrollFrameTemplate')
    APC.frames.mainFrame.scrollFrame.height = 280
    APC.frames.mainFrame.scrollFrame.numberOfRows = 2
    APC.frames.mainFrame.scrollFrame.rowHeight = APC.frames.mainFrame.scrollFrame.height / APC.frames.mainFrame.scrollFrame.numberOfRows
    APC.frames.mainFrame.scrollFrame:SetWidth(310)
    APC.frames.mainFrame.scrollFrame:SetHeight(APC.frames.mainFrame.scrollFrame.height)
    APC.frames.mainFrame.scrollFrame:SetPoint("TOPLEFT", APC.frames.mainFrame, "TOPLEFT", 0, -96)
    APC.frames.mainFrame.scrollFrame.rows = {}
    APC.frames.mainFrame.scrollFrame.Update = function(self)
        FauxScrollFrame_Update(self, #APC.selectedRecipe.reagents, APC.frames.mainFrame.scrollFrame.numberOfRows, APC.frames.mainFrame.scrollFrame.rowHeight,  nil, nil, nil, nil, nil, nil, true)

        local offset = FauxScrollFrame_GetOffset(self)

        for i = 1, APC.frames.mainFrame.scrollFrame.numberOfRows do
            local value = offset + i
            local row = self.rows[i]
            if value <= #APC.selectedRecipe.reagents then
                UpdateScrollFrameRow(row, APC.selectedRecipe.reagents[value])
                if not row:IsVisible() then
                    row:Show()
                end
            else
                row:Hide()
            end
        end
    end
    APC.frames.mainFrame.scrollFrame:SetScript("OnVerticalScroll", function(self, offset)
        FauxScrollFrame_OnVerticalScroll(self, offset, APC.frames.mainFrame.scrollFrame.rowHeight, APC.frames.mainFrame.scrollFrame.Update)
    end)

    -- Rows in scrollframe
    for i = 1, APC.frames.mainFrame.scrollFrame.numberOfRows, 1 do
        APC.frames.mainFrame.scrollFrame.rows[i] = CreateFrame('Frame', '$parentRow' .. i, APC.frames.mainFrame.scrollFrame)
        APC.frames.mainFrame.scrollFrame.rows[i]:SetWidth(310)
        APC.frames.mainFrame.scrollFrame.rows[i]:SetHeight(APC.frames.mainFrame.scrollFrame.rowHeight)
        APC.frames.mainFrame.scrollFrame.rows[i]:SetBackdrop({
            bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", tile = true, tileSize = 16,
            insets = { left = 4, right = 4, top = 4, bottom = 4 },
        })

        APC.frames.mainFrame.scrollFrame.rows[i].reagentName = APC.frames.mainFrame.scrollFrame.rows[i]:CreateFontString('$parentText' .. i)
        APC.frames.mainFrame.scrollFrame.rows[i].reagentName:SetFontObject('GameFontHighlight')
        APC.frames.mainFrame.scrollFrame.rows[i].reagentName:SetText('Auction profit calculator')
        APC.frames.mainFrame.scrollFrame.rows[i].reagentName:SetPoint('CENTER', APC.frames.mainFrame.scrollFrame.rows[i], 'CENTER')

        if i == 1 then 
            APC.frames.mainFrame.scrollFrame.rows[i]:SetPoint("TOPLEFT", APC.frames.mainFrame.scrollFrame, 'TOPLEFT' , 0, 0)
        else 
            APC.frames.mainFrame.scrollFrame.rows[i]:SetPoint("TOPLEFT", 'AucProfitCalcScrollRow' .. i - 1 , 'BOTTOMLEFT')
        end
    end
end
