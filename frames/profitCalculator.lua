local ns = (select(2, ...))
local APC = ns
local selectBox = LibStub:GetLibrary("SelectBox")

local function profitCalculator()
    APC.frames.mainFrame.profitCalculator = CreateFrame("Frame", "APCProfitCalculatorFrame", APC.frames.mainFrame)
    APC.frames.mainFrame.profitCalculator:SetAllPoints()
end

local function selectedRecipeIcon()
    APC.frames.mainFrame.profitCalculator.selectedRecipe.icon = CreateFrame('Frame', 'APCSelectedRecipeIcon', APC.frames.mainFrame.profitCalculator)
    APC.frames.mainFrame.profitCalculator.selectedRecipe.icon:SetWidth(40)
    APC.frames.mainFrame.profitCalculator.selectedRecipe.icon:SetHeight(40)
    APC.frames.mainFrame.profitCalculator.selectedRecipe.icon:SetPoint('TOPLEFT', APC.frames.mainFrame.profitCalculator, 'TOPLEFT', 10, -40)
    APC.frames.mainFrame.profitCalculator.selectedRecipe.icon.texture = APC.frames.mainFrame.profitCalculator.selectedRecipe.icon:CreateTexture("$parentTexture")
    APC.frames.mainFrame.profitCalculator.selectedRecipe.icon.texture:SetAllPoints()
end

local function selectedRecipeCount()
    APC.frames.mainFrame.profitCalculator.selectedRecipe.count = APC.frames.mainFrame.profitCalculator.selectedRecipe.icon:CreateFontString('APCSelectedRecipeCount')
    APC.frames.mainFrame.profitCalculator.selectedRecipe.count:SetFont('Fonts\\FRIZQT__.TTF', 12, 'OUTLINE')
    APC.frames.mainFrame.profitCalculator.selectedRecipe.count:SetTextColor(1, 1, 1, 1)
    APC.frames.mainFrame.profitCalculator.selectedRecipe.count:SetPoint('TOPLEFT', APC.frames.mainFrame.profitCalculator.selectedRecipe.icon, 'TOPLEFT', 22, -22)
end

local function selectedRecipeName()
    APC.frames.mainFrame.profitCalculator.selectedRecipe.name = APC.frames.mainFrame.profitCalculator:CreateFontString('APCSelectedRecipeName')
    APC.frames.mainFrame.profitCalculator.selectedRecipe.name:SetFontObject('GameFontHighlight')
    APC.frames.mainFrame.profitCalculator.selectedRecipe.name:SetWidth(130)
    APC.frames.mainFrame.profitCalculator.selectedRecipe.name:SetMaxLines(1)
    APC.frames.mainFrame.profitCalculator.selectedRecipe.name:SetJustifyH('LEFT')
    APC.frames.mainFrame.profitCalculator.selectedRecipe.name:SetTextColor(1, 0.8, 0, 1)
    APC.frames.mainFrame.profitCalculator.selectedRecipe.name:SetPoint('TOPLEFT', APC.frames.mainFrame.profitCalculator, 'TOPLEFT', 55, -45)
end


local function selectedRecipePriceContainer()
    APC.frames.mainFrame.profitCalculator.selectedRecipe.recipePriceContainer = CreateFrame("Frame", 'RecipePriceContainer', APC.frames.mainFrame)
    APC.frames.mainFrame.profitCalculator.selectedRecipe.recipePriceContainer:SetWidth(170)
    APC.frames.mainFrame.profitCalculator.selectedRecipe.recipePriceContainer:SetHeight(20)
    APC.frames.mainFrame.profitCalculator.selectedRecipe.recipePriceContainer:SetPoint('TOPLEFT', APC.frames.mainFrame, 'TOPLEFT', 165, -70)
    APC.frames.mainFrame.profitCalculator.selectedRecipe.recipePriceContainer.currentPrice = 0
    APC.frames.mainFrame.profitCalculator.selectedRecipe.recipePriceContainer.priceChangedByUser = false
    APC.frames.mainFrame.profitCalculator.selectedRecipe.recipePriceContainer.Update = function(self, type)
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
            APC.selectedRecipe.priceAlgorithm = self.selectRecipePriceButton.value
            APC.selectedRecipe.price = APC.GetPrice(APC.selectedRecipe, APC.selectedRecipe.priceAlgorithm)

            self.currentPrice = APC.selectedRecipe.price
            
            APC.SetMoneyFrameCopper(self.APCPriceBox, APC.selectedRecipe.price)
            
        end
        
        self.priceChangedByUser = true
        APC.CalcProfit()
        APC.frames.mainFrame.profitCalculator.displayProfit.Update()
    end
end

local function selectedRecipePriceSelection()
    APC.frames.mainFrame.profitCalculator.selectedRecipe.recipePriceContainer.selectRecipePriceButton = selectBox:Create("SelectRecipePriceButton", APC.frames.mainFrame.profitCalculator.selectedRecipe.recipePriceContainer, 120, function(self) APC.frames.mainFrame.profitCalculator.selectedRecipe.recipePriceContainer:Update('price selection')  end, APC.priceList, APC.defaultPrice)
    APC.frames.mainFrame.profitCalculator.selectedRecipe.recipePriceContainer.selectRecipePriceButton:UpdateValue()
    APC.frames.mainFrame.profitCalculator.selectedRecipe.recipePriceContainer.selectRecipePriceButton:SetPoint("TOPLEFT", APC.frames.mainFrame, "TOPLEFT", 173, -37)
end

local function selectedRecipePriceBox()
    APC.frames.mainFrame.profitCalculator.selectedRecipe.recipePriceContainer.APCPriceBox = CreateFrame("Frame", 'APCPriceBox', APC.frames.mainFrame.profitCalculator.selectedRecipe.recipePriceContainer, "MoneyInputFrameTemplate")
    APC.frames.mainFrame.profitCalculator.selectedRecipe.recipePriceContainer.APCPriceBox:SetPoint("TOPLEFT", APC.frames.mainFrame.profitCalculator.selectedRecipe.recipePriceContainer, "TOPLEFT", 0, 0)
    MoneyInputFrame_SetOnValueChangedFunc(APC.frames.mainFrame.profitCalculator.selectedRecipe.recipePriceContainer.APCPriceBox, function() APC.frames.mainFrame.profitCalculator.selectedRecipe.recipePriceContainer:Update('price change') end)
end

local function selectedRecipePriceDisplay()
    selectedRecipePriceContainer()
    selectedRecipePriceSelection()
    selectedRecipePriceBox()
end

local function selectedRecipe()
    APC.frames.mainFrame.profitCalculator.selectedRecipe = {}
    selectedRecipeIcon()
    selectedRecipeCount()
    selectedRecipeName()
    selectedRecipePriceDisplay()
end

local function displayProfitFrame()
    APC.frames.mainFrame.profitCalculator.displayProfit = CreateFrame('Frame', 'APCDisplayProfit', APC.frames.mainFrame.profitCalculator)
    APC.frames.mainFrame.profitCalculator.displayProfit:SetWidth(338)
    APC.frames.mainFrame.profitCalculator.displayProfit:SetHeight(20)
    APC.frames.mainFrame.profitCalculator.displayProfit:SetPoint('BOTTOM', APC.frames.mainFrame.profitCalculator, 'BOTTOM', 0, 15)
    APC.frames.mainFrame.profitCalculator.displayProfit.Update = function()
        local gold = floor(APC.selectedRecipe.profit / (COPPER_PER_GOLD))
        local silver = abs(floor((APC.selectedRecipe.profit - (gold * COPPER_PER_GOLD)) / COPPER_PER_SILVER))
        local copper = abs(mod(APC.selectedRecipe.profit, COPPER_PER_SILVER))
        
        APC.frames.mainFrame.profitCalculator.displayProfit.gold.text:SetText(gold)
        APC.frames.mainFrame.profitCalculator.displayProfit.silver.text:SetText(silver)
        APC.frames.mainFrame.profitCalculator.displayProfit.copper.text:SetText(copper)
    end
end

local function displayProfitText()
     APC.frames.mainFrame.profitCalculator.displayProfit.text = APC.frames.mainFrame.profitCalculator.displayProfit:CreateFontString('APCDisplayProfitText')
     APC.frames.mainFrame.profitCalculator.displayProfit.text:SetFontObject('GameFontHighlight')
     APC.frames.mainFrame.profitCalculator.displayProfit.text:SetTextColor(1, 1, 1, 1)
     APC.frames.mainFrame.profitCalculator.displayProfit.text:SetPoint('LEFT', APC.frames.mainFrame.profitCalculator.displayProfit, 'LEFT', 10, 0)
     APC.frames.mainFrame.profitCalculator.displayProfit.text:SetText('Expected Profit:')
end

local function displayProfitGold()
    APC.frames.mainFrame.profitCalculator.displayProfit.gold = CreateFrame('Frame', '$parentGoldFrame', APC.frames.mainFrame.profitCalculator.displayProfit)
    APC.frames.mainFrame.profitCalculator.displayProfit.gold:SetWidth(100)
    APC.frames.mainFrame.profitCalculator.displayProfit.gold:SetHeight(20)
    APC.frames.mainFrame.profitCalculator.displayProfit.gold:SetPoint('LEFT', APC.frames.mainFrame.profitCalculator.displayProfit, 'LEFT', 120, 0)

    APC.frames.mainFrame.profitCalculator.displayProfit.gold.text = APC.frames.mainFrame.profitCalculator.displayProfit.gold:CreateFontString('APCDisplayProfitGoldText')
    APC.frames.mainFrame.profitCalculator.displayProfit.gold.text:SetFontObject('GameFontHighlight')
    APC.frames.mainFrame.profitCalculator.displayProfit.gold.text:SetTextColor(1, 1, 1, 1)
    APC.frames.mainFrame.profitCalculator.displayProfit.gold.text:SetPoint('RIGHT', APC.frames.mainFrame.profitCalculator.displayProfit.gold, 'RIGHT', -15, 0)
    APC.frames.mainFrame.profitCalculator.displayProfit.gold.text:SetMaxLines(1)
    APC.frames.mainFrame.profitCalculator.displayProfit.gold.text:SetWidth(80)
    APC.frames.mainFrame.profitCalculator.displayProfit.gold.text:SetJustifyH('RIGHT')
    APC.frames.mainFrame.profitCalculator.displayProfit.gold.text:SetText('1')

    APC.frames.mainFrame.profitCalculator.displayProfit.gold.texture = APC.frames.mainFrame.profitCalculator.displayProfit.gold:CreateTexture("$parentIcon")
    APC.frames.mainFrame.profitCalculator.displayProfit.gold.texture:SetWidth(14)
    APC.frames.mainFrame.profitCalculator.displayProfit.gold.texture:SetHeight(14)
    APC.frames.mainFrame.profitCalculator.displayProfit.gold.texture:SetPoint('RIGHT', APC.frames.mainFrame.profitCalculator.displayProfit.gold, 'RIGHT')
    APC.frames.mainFrame.profitCalculator.displayProfit.gold.texture:SetTexture('Interface\\MoneyFrame\\UI-GoldIcon')
end

local function displayProfitSilver()
    APC.frames.mainFrame.profitCalculator.displayProfit.silver = CreateFrame('Frame', '$parentSilverFrame', APC.frames.mainFrame.profitCalculator.displayProfit)
    APC.frames.mainFrame.profitCalculator.displayProfit.silver:SetWidth(30)
    APC.frames.mainFrame.profitCalculator.displayProfit.silver:SetHeight(20)
    APC.frames.mainFrame.profitCalculator.displayProfit.silver:SetPoint('LEFT', APC.frames.mainFrame.profitCalculator.displayProfit, 'LEFT', 225, 0)

    APC.frames.mainFrame.profitCalculator.displayProfit.silver.text = APC.frames.mainFrame.profitCalculator.displayProfit.gold:CreateFontString('APCDisplayProfitSilverText')
    APC.frames.mainFrame.profitCalculator.displayProfit.silver.text:SetFontObject('GameFontHighlight')
    APC.frames.mainFrame.profitCalculator.displayProfit.silver.text:SetTextColor(1, 1, 1, 1)
    APC.frames.mainFrame.profitCalculator.displayProfit.silver.text:SetPoint('RIGHT', APC.frames.mainFrame.profitCalculator.displayProfit.silver, 'RIGHT', -15, 0)
    APC.frames.mainFrame.profitCalculator.displayProfit.silver.text:SetMaxLines(1)
    APC.frames.mainFrame.profitCalculator.displayProfit.silver.text:SetWidth(20)
    APC.frames.mainFrame.profitCalculator.displayProfit.silver.text:SetJustifyH('RIGHT')
    APC.frames.mainFrame.profitCalculator.displayProfit.silver.text:SetText('10')

    APC.frames.mainFrame.profitCalculator.displayProfit.silver.texture = APC.frames.mainFrame.profitCalculator.displayProfit.silver:CreateTexture("$parentIcon")
    APC.frames.mainFrame.profitCalculator.displayProfit.silver.texture:SetWidth(14)
    APC.frames.mainFrame.profitCalculator.displayProfit.silver.texture:SetHeight(14)
    APC.frames.mainFrame.profitCalculator.displayProfit.silver.texture:SetPoint('RIGHT', APC.frames.mainFrame.profitCalculator.displayProfit.silver, 'RIGHT')
    APC.frames.mainFrame.profitCalculator.displayProfit.silver.texture:SetTexture('Interface\\MoneyFrame\\UI-SilverIcon')
end

local function displayProfitCopper()
    APC.frames.mainFrame.profitCalculator.displayProfit.copper = CreateFrame('Frame', '$parentCopperFrame', APC.frames.mainFrame.profitCalculator.displayProfit)
    APC.frames.mainFrame.profitCalculator.displayProfit.copper:SetWidth(30)
    APC.frames.mainFrame.profitCalculator.displayProfit.copper:SetHeight(20)
    APC.frames.mainFrame.profitCalculator.displayProfit.copper:SetPoint('LEFT', APC.frames.mainFrame.profitCalculator.displayProfit, 'LEFT', 260, 0)

    APC.frames.mainFrame.profitCalculator.displayProfit.copper.text = APC.frames.mainFrame.profitCalculator.displayProfit.gold:CreateFontString('APCDisplayProfitCopperText')
    APC.frames.mainFrame.profitCalculator.displayProfit.copper.text:SetFontObject('GameFontHighlight')
    APC.frames.mainFrame.profitCalculator.displayProfit.copper.text:SetTextColor(1, 1, 1, 1)
    APC.frames.mainFrame.profitCalculator.displayProfit.copper.text:SetPoint('RIGHT', APC.frames.mainFrame.profitCalculator.displayProfit.copper, 'RIGHT', -15, 0)
    APC.frames.mainFrame.profitCalculator.displayProfit.copper.text:SetMaxLines(1)
    APC.frames.mainFrame.profitCalculator.displayProfit.copper.text:SetWidth(20)
    APC.frames.mainFrame.profitCalculator.displayProfit.copper.text:SetJustifyH('RIGHT')
    APC.frames.mainFrame.profitCalculator.displayProfit.copper.text:SetText('10')

    APC.frames.mainFrame.profitCalculator.displayProfit.copper.texture = APC.frames.mainFrame.profitCalculator.displayProfit.copper:CreateTexture("$parentIcon")
    APC.frames.mainFrame.profitCalculator.displayProfit.copper.texture:SetWidth(14)
    APC.frames.mainFrame.profitCalculator.displayProfit.copper.texture:SetHeight(14)
    APC.frames.mainFrame.profitCalculator.displayProfit.copper.texture:SetPoint('RIGHT', APC.frames.mainFrame.profitCalculator.displayProfit.copper, 'RIGHT')
    APC.frames.mainFrame.profitCalculator.displayProfit.copper.texture:SetTexture('Interface\\MoneyFrame\\UI-CopperIcon')
end

local function displayProfit()
    displayProfitFrame()
    displayProfitText()
    displayProfitGold()
    displayProfitSilver()
    displayProfitCopper()
end

APC.frames.frameInitializer.ProfitCalculator = function()
    
    profitCalculator()
    selectedRecipe()
    displayProfit()

    

    -- Scrollframe for reagents
    APC.frames.mainFrame.scrollFrame = CreateFrame("ScrollFrame", "AucProfitCalcScroll", APC.frames.mainFrame, 'FauxScrollFrameTemplate')
    APC.frames.mainFrame.scrollFrame.height = 265
    APC.frames.mainFrame.scrollFrame.numberOfRows = 4
    APC.frames.mainFrame.scrollFrame.rowHeight = APC.frames.mainFrame.scrollFrame.height / APC.frames.mainFrame.scrollFrame.numberOfRows
    APC.frames.mainFrame.scrollFrame:SetWidth(310)
    APC.frames.mainFrame.scrollFrame:SetHeight(APC.frames.mainFrame.scrollFrame.height)
    APC.frames.mainFrame.scrollFrame:SetPoint("TOPLEFT", APC.frames.mainFrame, "TOPLEFT", 0, -116)
    APC.frames.mainFrame.scrollFrame:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", tile = true, tileSize = 16,
        insets = { left = 3, right = -23, top = 0, bottom = 0 },
    })
     
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

        APC.frames.mainFrame.profitCalculator.displayProfit.Update()

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
        currentRow.reagentName:SetWidth(115)
        currentRow.reagentName:SetMaxLines(1)
        currentRow.reagentName:SetJustifyH('LEFT')
        currentRow.reagentName:SetFontObject('GameFontHighlight')
        currentRow.reagentName:SetPoint('TOPLEFT', currentRow, 'TOPLEFT', 55, -10)

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
                
                APC.selectedRecipe.reagents[index].priceAlgorithm = self.selectRecipePriceButton.value
                APC.selectedRecipe.reagents[index].price = APC.GetPrice(APC.selectedRecipe.reagents[index], APC.selectedRecipe.reagents[index].priceAlgorithm)

                self.currentPrice = APC.selectedRecipe.reagents[index].price
                
                APC.SetMoneyFrameCopper(self.APCPriceBox, APC.selectedRecipe.reagents[index].price)
                
            end
            
            self.priceChangedByUser = true
            APC.CalcProfit()
            APC.frames.mainFrame.profitCalculator.displayProfit.Update()

        end

        -- reagent price selection button
        currentRow.recipePriceContainer.selectRecipePriceButton = selectBox:Create("SelectRecipePriceButton" .. i, currentRow, 120, function(self) currentRow.recipePriceContainer:Update('price selection') end, APC.priceList, APC.defaultPrice)
        currentRow.recipePriceContainer.selectRecipePriceButton:UpdateValue()
        currentRow.recipePriceContainer.selectRecipePriceButton:SetPoint("TOPLEFT", currentRow, "TOPLEFT", 160, -4)
        
        -- Price box
        currentRow.recipePriceContainer.APCPriceBox = CreateFrame("Frame", 'APCPriceBox' .. i, currentRow.recipePriceContainer, "MoneyInputFrameTemplate")
        currentRow.recipePriceContainer.APCPriceBox:SetPoint("TOPLEFT", currentRow, "TOPLEFT", 60, -30)
        MoneyInputFrame_SetOnValueChangedFunc(currentRow.recipePriceContainer.APCPriceBox, function() currentRow.recipePriceContainer:Update('price change') end)

        if i == 1 then 
            currentRow:SetPoint("TOPLEFT", APC.frames.mainFrame.scrollFrame, 'TOPLEFT' , 0, 0)
        else 
            currentRow:SetPoint("TOPLEFT", 'AucProfitCalcScrollRow' .. i - 1 , 'BOTTOMLEFT')
        end
    end
end