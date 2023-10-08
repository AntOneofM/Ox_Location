ESX = nil
local playerHasRentedVehicle = false
local ComptLocation = false

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('aLocation:CheckLiquide', function(source, cb, price)
    local xPlayer = ESX.GetPlayerFromId(source)

    if playerHasRentedVehicle then
        cb(false) -- Le joueur a déjà loué un véhicule, retournez false
    elseif xPlayer.getMoney() < price then 
        cb(false) -- Le joueur n'a pas assez d'argent en liquide
    elseif xPlayer.getMoney() >= price then 
        xPlayer.removeMoney(price)
        cb(true)
        playerHasRentedVehicle = true -- Mettez à jour la variable pour indiquer que le joueur a loué un véhicule
    end
end)

RegisterServerEvent('aLocation:retourlocation')
AddEventHandler('aLocation:retourlocation', function(Caution)
    local xPlayer = ESX.GetPlayerFromId(source)
    print(("Le joueur %s a retourné un véhicule et devrait être remboursé de $%s."):format(xPlayer.getName(), Caution))
    xPlayer.addMoney(Caution)
    playerHasRentedVehicle = false
    ComptLocation = false
    print(("Le joueur %s a été remboursé de $%s."):format(xPlayer.getName(), Caution))
    TriggerClientEvent("esx:showNotification", source, "Vous venez d'être remboursé de ~g~$" .. ESX.Math.GroupDigits(Caution) .. " !")
end)


RegisterServerEvent('aLocation:perteLocation')
AddEventHandler('aLocation:perteLocation', function(CautionPerteVehicule)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getMoney() >= CautionPerteVehicule then
        xPlayer.removeMoney(CautionPerteVehicule)
        playerHasRentedVehicle = false
        ComptLocation = false
        TriggerClientEvent("esx:showNotification", source, "Vous venez de payer une caution de ~g~"..ESX.Math.GroupDigits(CautionPerteVehicule).."$ !")
    else
        TriggerClientEvent("esx:showNotification", source, "Vous n'avez pas assez d'argent pour payer la caution.")
    end
end)


