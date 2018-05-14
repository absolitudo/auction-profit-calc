local ns = (select(2, ...))
local APC = ns
local selectBox = LibStub:GetLibrary("SelectBox")

APC.frames.InitFrames = function()
    APC.frames.mainFrame:InitFrame()
end

APC.frames.mainFrame.InitFrame = function(self)
    -- Main window
    APC.frames.mainFrame = CreateFrame("Frame", "AucProfitCalc", UIParent, 'BasicFrameTemplate')
    APC.frames.mainFrame:SetFrameStrata("DIALOG")
    APC.frames.mainFrame:SetMovable(true)
    APC.frames.mainFrame:SetWidth(338)
    APC.frames.mainFrame:SetHeight(424)
    APC.frames.mainFrame:Hide()
    APC.frames.mainFrame.UpdateSelectedRecipeView = function(self)
        APC.UpdateSelectedRecipeInMainFrame()
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

    -- Selected recipe count
    APC.frames.mainFrame.selectedRecipeCount = APC.frames.mainFrame.selectedRecipeIcon:CreateFontString('SelectedRecipeCount')
    APC.frames.mainFrame.selectedRecipeCount:SetFont('Fonts\\FRIZQT__.TTF', 12, 'OUTLINE')
    APC.frames.mainFrame.selectedRecipeCount:SetTextColor(1, 1, 1, 1)
    APC.frames.mainFrame.selectedRecipeCount:SetPoint('TOPLEFT', APC.frames.mainFrame.selectedRecipeIcon, 'TOPLEFT', 22, -22)

    -- Selected recipe name
    APC.frames.mainFrame.selectedRecipeName = APC.frames.mainFrame.selectedRecipeIcon:CreateFontString('SelectedRecipeName')
    APC.frames.mainFrame.selectedRecipeName:SetFontObject('GameFontHighlight')
    APC.frames.mainFrame.selectedRecipeName:SetWidth(130)
    APC.frames.mainFrame.selectedRecipeName:SetMaxLines(1)
    APC.frames.mainFrame.selectedRecipeName:SetTextColor(1, 0.8, 0, 1)
    APC.frames.mainFrame.selectedRecipeName:SetPoint('TOPLEFT', APC.frames.mainFrame, 'TOPLEFT', 55, -45)
    -- Selected recipe price selection button
    APC.frames.mainFrame.selectRecipePriceButton = selectBox:Create("SelectRecipePriceButton", APC.frames.mainFrame, 120, function(self)
        APC.selectedRecipe.price = APC.GetPrice(APC.selectedRecipe, self.value)
        APC.SetMoneyFrameCopper(APC.frames.mainFrame.APCPriceBox, APC.selectedRecipe.price)
    end, APC.priceList, APC.defaultPrice)
    APC.frames.mainFrame.selectRecipePriceButton:UpdateValue()
    APC.frames.mainFrame.selectRecipePriceButton:SetPoint("TOPLEFT", APC.frames.mainFrame, "TOPLEFT", 173, -37)

    --Price box container
    APC.frames.mainFrame.recipePriceContainer = CreateFrame("Frame", 'PriceContainer', APC.frames.mainFrame)
    APC.frames.mainFrame.recipePriceContainer:SetWidth(170)
    APC.frames.mainFrame.recipePriceContainer:SetHeight(20)
    APC.frames.mainFrame.recipePriceContainer:SetPoint('TOPLEFT', APC.frames.mainFrame, 'TOPLEFT', 165, -70)
    -- Price box
    APC.frames.mainFrame.APCPriceBox = CreateFrame("Frame", 'APCPriceBox', APC.frames.mainFrame.recipePriceContainer, "MoneyInputFrameTemplate")
    APC.frames.mainFrame.APCPriceBox:SetPoint("TOPLEFT", APC.frames.mainFrame.recipePriceContainer, "TOPLEFT", 0, 0)
    --MoneyInputFrame_SetOnValueChangedFunc(APC.frames.mainFrame.APCPriceBox, function() MoneyInputFrame_GetCopper(APC.frames.mainFrame.APCPriceBox) end)

    -- Scrollframe for reagents
    APC.frames.mainFrame.scrollFrame = CreateFrame("ScrollFrame", "AucProfitCalcScroll", APC.frames.mainFrame, 'FauxScrollFrameTemplate')
    APC.frames.mainFrame.scrollFrame.height = 260
    APC.frames.mainFrame.scrollFrame.numberOfRows = 2
    APC.frames.mainFrame.scrollFrame.rowHeight = APC.frames.mainFrame.scrollFrame.height / APC.frames.mainFrame.scrollFrame.numberOfRows
    APC.frames.mainFrame.scrollFrame:SetWidth(310)
    APC.frames.mainFrame.scrollFrame:SetHeight(APC.frames.mainFrame.scrollFrame.height)
    APC.frames.mainFrame.scrollFrame:SetPoint("TOPLEFT", APC.frames.mainFrame, "TOPLEFT", 0, -116)
    APC.frames.mainFrame.scrollFrame.rows = {}
    APC.frames.mainFrame.scrollFrame.Update = function(self)
        FauxScrollFrame_Update(self, #APC.selectedRecipe.reagents, APC.frames.mainFrame.scrollFrame.numberOfRows, APC.frames.mainFrame.scrollFrame.rowHeight,  nil, nil, nil, nil, nil, nil, true)

        local offset = FauxScrollFrame_GetOffset(self)

        for i = 1, APC.frames.mainFrame.scrollFrame.numberOfRows do
            local value = offset + i
            local row = self.rows[i]
            if value <= #APC.selectedRecipe.reagents then
                APC.UpdateScrollFrameRow(row, APC.selectedRecipe.reagents[value])
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

    -- Reagents text for scrollframe
    APC.frames.mainFrame.scrollFrame.title = APC.frames.mainFrame.scrollFrame:CreateFontString('ScrollFrameTitle')
    APC.frames.mainFrame.scrollFrame.title:SetFontObject('GameFontHighlight')
    APC.frames.mainFrame.scrollFrame.title:SetTextColor(1, 0.8, 0, 1)
    APC.frames.mainFrame.scrollFrame.title:SetPoint('TOPLEFT', APC.frames.mainFrame.scrollFrame, 'TOPLEFT', 10, 15)
    APC.frames.mainFrame.scrollFrame.title:SetText('Reagents:')

    -- Rows in scrollframe
    for i = 1, APC.frames.mainFrame.scrollFrame.numberOfRows, 1 do
        -- Creation of the row
        APC.frames.mainFrame.scrollFrame.rows[i] = CreateFrame('Frame', '$parentRow' .. i, APC.frames.mainFrame.scrollFrame)
        local currentRow = APC.frames.mainFrame.scrollFrame.rows[i]
        currentRow:SetWidth(310)
        currentRow:SetHeight(APC.frames.mainFrame.scrollFrame.rowHeight)
        currentRow:SetBackdrop({
            bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", tile = true, tileSize = 16,
            insets = { left = 4, right = 4, top = 4, bottom = 4 },
        })

        -- Reagent icon
        currentRow.reagentIcon = CreateFrame('Frame', '$parentReagentIconFrame', currentRow)
        currentRow.reagentIcon:SetWidth(40)
        currentRow.reagentIcon:SetHeight(40)
        currentRow.reagentIcon:SetPoint('TOPLEFT', currentRow, 'TOPLEFT', 10, -10)
        currentRow.reagentIcon.texture = currentRow.reagentIcon:CreateTexture("$parentReagentIconTexture")
        currentRow.reagentIcon.texture:SetAllPoints()

        -- Reagent count
        currentRow.reagentCount = currentRow.reagentIcon:CreateFontString('SelectedRecipeCount')
        currentRow.reagentCount:SetFont('Fonts\\FRIZQT__.TTF', 12, 'OUTLINE')
        currentRow.reagentCount:SetTextColor(1, 1, 1, 1)
        currentRow.reagentCount:SetPoint('TOPLEFT', currentRow.reagentIcon, 'TOPLEFT', 22, -22)

        -- Reagent name
        currentRow.reagentName = currentRow:CreateFontString('$parentText' .. i)
        currentRow.reagentName:SetFontObject('GameFontHighlight')
        currentRow.reagentName:SetPoint('TOPLEFT', currentRow, 'TOPLEFT', 55, -20)

        -- reagent price selection button
        currentRow.selectRecipePriceButton = selectBox:Create("SelectRecipePriceButton" .. i, currentRow, 120, function(self) end, APC.priceList, APC.defaultPrice)
        currentRow.selectRecipePriceButton:UpdateValue()
        currentRow.selectRecipePriceButton:SetPoint("TOPLEFT", currentRow, "TOPLEFT", 173, -37)

        -- Reagent recipe price container
        currentRow.recipePriceContainer = CreateFrame("Frame", 'ReagentPriceContainer' .. i, currentRow)
        currentRow.recipePriceContainer:SetWidth(170)
        currentRow.recipePriceContainer:SetHeight(20)
        currentRow.recipePriceContainer:SetPoint('TOPLEFT', currentRow, 'TOPLEFT', 50, -50)
        -- Price box
        currentRow.APCPriceBox = CreateFrame("Frame", 'APCPriceBox' .. i, currentRow.recipePriceContainer, "MoneyInputFrameTemplate")
        currentRow.APCPriceBox:SetPoint("TOPLEFT", currentRow, "TOPLEFT", 0, 0)
        --MoneyInputFrame_SetOnValueChangedFunc(currentRow.APCPriceBox, function() print(MoneyInputFrame_GetCopper(currentRow.APCPriceBox)) end)

        if i == 1 then 
            currentRow:SetPoint("TOPLEFT", APC.frames.mainFrame.scrollFrame, 'TOPLEFT' , 0, 0)
        else 
            currentRow:SetPoint("TOPLEFT", 'AucProfitCalcScrollRow' .. i - 1 , 'BOTTOMLEFT')
        end
    end
end
