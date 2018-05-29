local ns = (select(2, ...))
local APC = ns

APC.InitFrames = function()
    APC.frames.frameInitializer.MainFrame()
    APC.frames.frameInitializer.ProfitCalculator()
end