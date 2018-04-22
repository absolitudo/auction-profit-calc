local ns = (select(2, ...))
ns.frames = {
    mainFrame = {}
}

function ns.frames:initFrames()
    self.mainFrame:initFrame()
end

function ns.frames.mainFrame:initFrame()
    self = CreateFrame("Frame", "AucProfitCalc", UIParent)
    self:SetFrameStrata("BACKGROUND")

    self:SetWidth(500)
    self:SetHeight(500)
    self:SetPoint("CENTER", UIParent, "CENTER")

    self.texture = self:CreateTexture('mainFrameBackground')
    self.texture:SetAllPoints(self)
    self.texture:SetTexture(0, 0, 0, 0.7)
end
