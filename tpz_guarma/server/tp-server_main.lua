local TPZ    = exports.tpz_core:getCoreAPI()
local TPZInv = exports.tpz_inventory:getInventoryAPI()

exports.tpz_core:getCoreAPI().addNewCallBack("tpz_guarma:hasSelectedPaymentMethod", function(source, cb, data)
    local _source = source
    local xPlayer = TPZ.GetPlayer(_source)

    local currency, cost = data.currency, tonumber(data.cost)

    local money           = 0
    local moneyIsRequired = false

    if tonumber(currency) then
        money = xPlayer.getAccount(tonumber(currency))
        moneyIsRequired = true
    end

    if moneyIsRequired then

        if cost <= money then
            xPlayer.removeAccount(tonumber(currency), cost)
            return cb(true)
        end

        return cb(false)
    else

        local item = currency

        local itemQuantity = TPZInv.getItemQuantity(_source, item)

        if itemQuantity and itemQuantity >= 1 and cost <= itemQuantity then

            if cost ~= 0 then
                TPZInv.removeItem(_source, item, cost)
            end

            return cb(true)

        end

        return cb(false)

    end

end)
