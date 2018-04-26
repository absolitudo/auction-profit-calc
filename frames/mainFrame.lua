local ns = (select(2, ...))
ns.frames = {
    mainFrame = {}
}

function ns.frames.initFrames()
    ns.frames.mainFrame:initFrame()
end

function ns.frames.mainFrame:initFrame()
    ns.frames.mainFrame = CreateFrame("Frame", "AucProfitCalc", UIParent, 'BasicFrameTemplate')
    ns.frames.mainFrame:SetMovable(true)
    ns.frames.mainFrame:SetWidth(500)
    ns.frames.mainFrame:SetHeight(500)
    ns.frames.mainFrame:SetPoint("CENTER", UIParent, "CENTER")
    ns.frames.mainFrame:Show()
end
