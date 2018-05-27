if not AucAdvanced then
    print('Auction profit calculator only works with Auctioneer addon. Download and install it first.')
    return
end

if not AucAdvanced.API or not AucAdvanced.Modules.Util.Appraiser.Processors then
    print('Auction profit calculator: It seems like you don\'t have all the required parts of Auctioneer enabled.')
    return
end

if not LibStub:GetLibrary("SelectBox") then
    print('Auction profit calculator: LibStub is a required addon for auction profit calculator to work properly.')
    return
end