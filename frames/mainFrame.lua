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
        APC.CalcProfit()
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
    APC.frames.mainFrame.selectedRecipeName:SetJustifyH('LEFT')
    APC.frames.mainFrame.selectedRecipeName:SetTextColor(1, 0.8, 0, 1)
    APC.frames.mainFrame.selectedRecipeName:SetPoint('TOPLEFT', APC.frames.mainFrame, 'TOPLEFT', 55, -45)

    --Price box container
    APC.frames.mainFrame.recipePriceContainer = CreateFrame("Frame", 'RecipePriceContainer', APC.frames.mainFrame)
    APC.frames.mainFrame.recipePriceContainer:SetWidth(170)
    APC.frames.mainFrame.recipePriceContainer:SetHeight(20)
    APC.frames.mainFrame.recipePriceContainer:SetPoint('TOPLEFT', APC.frames.mainFrame, 'TOPLEFT', 165, -70)
    APC.frames.mainFrame.recipePriceContainer.currentPrice = 0
    APC.frames.mainFrame.recipePriceContainer.priceChangedByUser = false
    APC.frames.mainFrame.recipePriceContainer.Update = function(self, type)
        local changedPrice = MoneyInputFrame_GetCopper(self.APCPriceBox)
        if type == 'price change' and self.currentPrice ~= changedPrice then
            APC.selectedRecipe.price = changedPrice

            self.currentPrice = APC.selectedRecipe.price
            
            APC.SetMoneyFrameCopper(self.APCPriceBox, APC.selectedRecipe.price)
            if self.priceChangedByUser then
                self.selectRecipePriceButton.value = 'fixed'
                self.selectRecipePriceButton:UpdateValue()
            end
        end
        if type == 'price selection' then
            APC.selectedRecipe.price = APC.GetPrice(APC.selectedRecipe, self.selectRecipePriceButton.value)
            
            self.currentPrice = APC.selectedRecipe.price
            
            APC.SetMoneyFrameCopper(self.APCPriceBox, APC.selectedRecipe.price)
            
        end
        
        self.priceChangedByUser = true
        APC.CalcProfit()
        APC.frames.mainFrame.displayProfit.Update()
    end

    -- Selected recipe price selection button
    APC.frames.mainFrame.recipePriceContainer.selectRecipePriceButton = selectBox:Create("SelectRecipePriceButton", APC.frames.mainFrame.recipePriceContainer, 120, function(self) APC.frames.mainFrame.recipePriceContainer:Update('price selection')  end, APC.priceList, APC.defaultPrice)
    APC.frames.mainFrame.recipePriceContainer.selectRecipePriceButton:UpdateValue()
    APC.frames.mainFrame.recipePriceContainer.selectRecipePriceButton:SetPoint("TOPLEFT", APC.frames.mainFrame, "TOPLEFT", 173, -37)
   
    -- Price box
    APC.frames.mainFrame.recipePriceContainer.APCPriceBox = CreateFrame("Frame", 'APCPriceBox', APC.frames.mainFrame.recipePriceContainer, "MoneyInputFrameTemplate")
    APC.frames.mainFrame.recipePriceContainer.APCPriceBox:SetPoint("TOPLEFT", APC.frames.mainFrame.recipePriceContainer, "TOPLEFT", 0, 0)
    MoneyInputFrame_SetOnValueChangedFunc(APC.frames.mainFrame.recipePriceContainer.APCPriceBox, function() APC.frames.mainFrame.recipePriceContainer:Update('price change') end)

    -- Display profit
    APC.frames.mainFrame.displayProfit = CreateFrame('Frame', 'APCDisplayProfit', APC.frames.mainFrame)
    APC.frames.mainFrame.displayProfit:SetWidth(338)
    APC.frames.mainFrame.displayProfit:SetHeight(20)
    APC.frames.mainFrame.displayProfit:SetPoint('BOTTOM', APC.frames.mainFrame, 'BOTTOM', 0, 15)
    APC.frames.mainFrame.displayProfit.Update = function()

        local gold = floor(APC.selectedRecipe.profit / (COPPER_PER_GOLD))
        local silver = abs(floor((APC.selectedRecipe.profit - (gold * COPPER_PER_GOLD)) / COPPER_PER_SILVER))
        local copper = abs(mod(APC.selectedRecipe.profit, COPPER_PER_SILVER))
        
        APC.frames.mainFrame.displayProfit.gold.text:SetText(gold)
        APC.frames.mainFrame.displayProfit.silver.text:SetText(silver)
        APC.frames.mainFrame.displayProfit.copper.text:SetText(copper)
    end

    -- Display profit text
    APC.frames.mainFrame.displayProfit.text = APC.frames.mainFrame.displayProfit:CreateFontString('APCDisplayProfitText')
    APC.frames.mainFrame.displayProfit.text:SetFontObject('GameFontHighlight')
    APC.frames.mainFrame.displayProfit.text:SetTextColor(1, 1, 1, 1)
    APC.frames.mainFrame.displayProfit.text:SetPoint('LEFT', APC.frames.mainFrame.displayProfit, 'LEFT', 10, 0)
    APC.frames.mainFrame.displayProfit.text:SetText('Expected Profit:')

    -- Display profit gold
    APC.frames.mainFrame.displayProfit.gold = CreateFrame('Frame', '$parentGoldFrame', APC.frames.mainFrame.displayProfit)
    APC.frames.mainFrame.displayProfit.gold:SetWidth(100)
    APC.frames.mainFrame.displayProfit.gold:SetHeight(20)
    APC.frames.mainFrame.displayProfit.gold:SetPoint('LEFT', APC.frames.mainFrame.displayProfit, 'LEFT', 120, 0)

    -- Display profit gold text
    APC.frames.mainFrame.displayProfit.gold.text = APC.frames.mainFrame.displayProfit.gold:CreateFontString('APCDisplayProfitGoldText')
    APC.frames.mainFrame.displayProfit.gold.text:SetFontObject('GameFontHighlight')
    APC.frames.mainFrame.displayProfit.gold.text:SetTextColor(1, 1, 1, 1)
    APC.frames.mainFrame.displayProfit.gold.text:SetPoint('RIGHT', APC.frames.mainFrame.displayProfit.gold, 'RIGHT', -15, 0)
    APC.frames.mainFrame.displayProfit.gold.text:SetMaxLines(1)
    APC.frames.mainFrame.displayProfit.gold.text:SetWidth(80)
    APC.frames.mainFrame.displayProfit.gold.text:SetJustifyH('RIGHT')
    APC.frames.mainFrame.displayProfit.gold.text:SetText('1')

    -- Display profit gold icon
    APC.frames.mainFrame.displayProfit.gold.texture = APC.frames.mainFrame.displayProfit.gold:CreateTexture("$parentIcon")
    APC.frames.mainFrame.displayProfit.gold.texture:SetWidth(14)
    APC.frames.mainFrame.displayProfit.gold.texture:SetHeight(14)
    APC.frames.mainFrame.displayProfit.gold.texture:SetPoint('RIGHT', APC.frames.mainFrame.displayProfit.gold, 'RIGHT')
    APC.frames.mainFrame.displayProfit.gold.texture:SetTexture('Interface\\MoneyFrame\\UI-GoldIcon')

    -- Display profit silver
    APC.frames.mainFrame.displayProfit.silver = CreateFrame('Frame', '$parentSilverFrame', APC.frames.mainFrame.displayProfit)
    APC.frames.mainFrame.displayProfit.silver:SetWidth(30)
    APC.frames.mainFrame.displayProfit.silver:SetHeight(20)
    APC.frames.mainFrame.displayProfit.silver:SetPoint('LEFT', APC.frames.mainFrame.displayProfit, 'LEFT', 220, 0)

    -- Display profit silver text
    APC.frames.mainFrame.displayProfit.silver.text = APC.frames.mainFrame.displayProfit.gold:CreateFontString('APCDisplayProfitSilverText')
    APC.frames.mainFrame.displayProfit.silver.text:SetFontObject('GameFontHighlight')
    APC.frames.mainFrame.displayProfit.silver.text:SetTextColor(1, 1, 1, 1)
    APC.frames.mainFrame.displayProfit.silver.text:SetPoint('RIGHT', APC.frames.mainFrame.displayProfit.silver, 'RIGHT', -15, 0)
    APC.frames.mainFrame.displayProfit.silver.text:SetMaxLines(1)
    APC.frames.mainFrame.displayProfit.silver.text:SetWidth(20)
    APC.frames.mainFrame.displayProfit.silver.text:SetJustifyH('RIGHT')
    APC.frames.mainFrame.displayProfit.silver.text:SetText('10')

    -- Display profit silver icon
    APC.frames.mainFrame.displayProfit.silver.texture = APC.frames.mainFrame.displayProfit.silver:CreateTexture("$parentIcon")
    APC.frames.mainFrame.displayProfit.silver.texture:SetWidth(14)
    APC.frames.mainFrame.displayProfit.silver.texture:SetHeight(14)
    APC.frames.mainFrame.displayProfit.silver.texture:SetPoint('RIGHT', APC.frames.mainFrame.displayProfit.silver, 'RIGHT')
    APC.frames.mainFrame.displayProfit.silver.texture:SetTexture('Interface\\MoneyFrame\\UI-SilverIcon')

    -- Display profit copper
    APC.frames.mainFrame.displayProfit.copper = CreateFrame('Frame', '$parentCopperFrame', APC.frames.mainFrame.displayProfit)
    APC.frames.mainFrame.displayProfit.copper:SetWidth(30)
    APC.frames.mainFrame.displayProfit.copper:SetHeight(20)
    APC.frames.mainFrame.displayProfit.copper:SetPoint('LEFT', APC.frames.mainFrame.displayProfit, 'LEFT', 250, 0)

    -- Display profit copper text
    APC.frames.mainFrame.displayProfit.copper.text = APC.frames.mainFrame.displayProfit.gold:CreateFontString('APCDisplayProfitCopperText')
    APC.frames.mainFrame.displayProfit.copper.text:SetFontObject('GameFontHighlight')
    APC.frames.mainFrame.displayProfit.copper.text:SetTextColor(1, 1, 1, 1)
    APC.frames.mainFrame.displayProfit.copper.text:SetPoint('RIGHT', APC.frames.mainFrame.displayProfit.copper, 'RIGHT', -15, 0)
    APC.frames.mainFrame.displayProfit.copper.text:SetMaxLines(1)
    APC.frames.mainFrame.displayProfit.copper.text:SetWidth(20)
    APC.frames.mainFrame.displayProfit.copper.text:SetJustifyH('RIGHT')
    APC.frames.mainFrame.displayProfit.copper.text:SetText('10')

    -- Display profit copper icon
    APC.frames.mainFrame.displayProfit.copper.texture = APC.frames.mainFrame.displayProfit.copper:CreateTexture("$parentIcon")
    APC.frames.mainFrame.displayProfit.copper.texture:SetWidth(14)
    APC.frames.mainFrame.displayProfit.copper.texture:SetHeight(14)
    APC.frames.mainFrame.displayProfit.copper.texture:SetPoint('RIGHT', APC.frames.mainFrame.displayProfit.copper, 'RIGHT')
    APC.frames.mainFrame.displayProfit.copper.texture:SetTexture('Interface\\MoneyFrame\\UI-CopperIcon')

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
        APC.selectedRecipe.reagents.offset = offset
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

        APC.frames.mainFrame.displayProfit.Update()

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

        -- Reagent recipe price container
        currentRow.recipePriceContainer = CreateFrame("Frame", 'ReagentPriceContainer' .. i, currentRow)
        currentRow.recipePriceContainer:SetWidth(170)
        currentRow.recipePriceContainer:SetHeight(20)
        currentRow.recipePriceContainer:SetPoint('TOPLEFT', currentRow, 'TOPLEFT', 50, -50)
        currentRow.recipePriceContainer.currentPrice = 0
        currentRow.recipePriceContainer.priceChangedByUser = false
        currentRow.recipePriceContainer.Update = function(self, type)
            local changedPrice = MoneyInputFrame_GetCopper(self.APCPriceBox)

            local offset = 0

            if APC.selectedRecipe then
                offset =  APC.selectedRecipe.reagents.offset
            end   

            local index = offset + i

            if type == 'price change' and self.currentPrice ~= changedPrice then
                APC.selectedRecipe.reagents[index].price = changedPrice

                self.currentPrice = APC.selectedRecipe.reagents[index].price
                
                APC.SetMoneyFrameCopper(self.APCPriceBox, APC.selectedRecipe.reagents[index].price)

                if self.priceChangedByUser then
                    self.selectRecipePriceButton.value = 'fixed'
                    self.selectRecipePriceButton:UpdateValue()
                end
            end
            if type == 'price selection' then
                
                APC.selectedRecipe.reagents[index].price = APC.GetPrice(APC.selectedRecipe.reagents[index], self.selectRecipePriceButton.value)
                
                self.currentPrice = APC.selectedRecipe.reagents[index].price
                
                APC.SetMoneyFrameCopper(self.APCPriceBox, APC.selectedRecipe.reagents[index].price)
                
            end
            
            self.priceChangedByUser = true
            APC.CalcProfit()
            APC.frames.mainFrame.displayProfit.Update()

        end

        -- reagent price selection button
        currentRow.recipePriceContainer.selectRecipePriceButton = selectBox:Create("SelectRecipePriceButton" .. i, currentRow, 120, function(self) currentRow.recipePriceContainer:Update('price selection') end, APC.priceList, APC.defaultPrice)
        currentRow.recipePriceContainer.selectRecipePriceButton:UpdateValue()
        currentRow.recipePriceContainer.selectRecipePriceButton:SetPoint("TOPLEFT", currentRow, "TOPLEFT", 173, -37)
        
        -- Price box
        currentRow.recipePriceContainer.APCPriceBox = CreateFrame("Frame", 'APCPriceBox' .. i, currentRow.recipePriceContainer, "MoneyInputFrameTemplate")
        currentRow.recipePriceContainer.APCPriceBox:SetPoint("TOPLEFT", currentRow, "TOPLEFT", 0, 0)
        MoneyInputFrame_SetOnValueChangedFunc(currentRow.recipePriceContainer.APCPriceBox, function() currentRow.recipePriceContainer:Update('price change') end)

        if i == 1 then 
            currentRow:SetPoint("TOPLEFT", APC.frames.mainFrame.scrollFrame, 'TOPLEFT' , 0, 0)
        else 
            currentRow:SetPoint("TOPLEFT", 'AucProfitCalcScrollRow' .. i - 1 , 'BOTTOMLEFT')
        end
    end
end
