local ns = (select(2, ...))
ns.frames.mainFrame = CreateFrame("Frame", "AucProfitCalc", UIParent)
ns.frames.mainFrame:SetFrameStrata("BACKGROUND")

ns.frames.mainFrame:SetWidth(128)
ns.frames.mainFrame:SetHeight(64)
ns.frames.mainFrame:SetPoint("CENTER", UIParent, "CENTER")

ns.frames.mainFrame.texture = ns.frames.mainFrame:CreateTexture('mainFrameBackground')
ns.frames.mainFrame.texture:SetAllPoints(ns.frames.mainFrame)
ns.frames.mainFrame.texture:SetTexture(0, 0, 0, 0.8)

ns.frames.mainFrame:Show()
