local ns = (select(2, ...))
local APC = ns

APC.frames = {
    mainFrame = {}
}
APC.GetMarketPrice = AucAdvanced.API.GetMarketValue
APC.GetAlgorithmPrice = AucAdvanced.API.GetAlgorithmValue
APC.priceList = {
    [1] = {
        [1] = 'market',
        [2] = 'Market'
    },
    [2] = {
        [1] = 'VendMarkup',
        [2] = 'Stats: VendMarkup'
    },
    [3] = {
        [1] = 'Histogram',
        [2] = 'Stats: Histogram'
    },
    [4] = {
        [1] = 'iLevel',
        [2] = 'Stats: iLevel'
    },
    [5] = {
        [1] = 'Purchased',
        [2] = 'Stats: Purchased'
    },
    [6] = {
        [1] = 'Sales',
        [2] = 'Stats: Sales'
    },
    [7] = {
        [1] = 'Simple',
        [2] = 'Stats: Simple'
    },
    [8] = {
        [1] = 'StdDev',
        [2] = 'Stats: StdDev'
    },
    [9] = {
        [1] = 'fixed',
        [2] = 'Fixed price'
    },
    [10] = {
        [1] = 'default',
        [2] = 'Default'
    }
}
function logTable(table)
    for key, value in pairs(table) do
         print(key, value)
         if type(value) == 'table' then
             logTable(value)
             print('---')
        end
    end
end