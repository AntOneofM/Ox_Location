local playerHasRentedVehicle = false
local ComptLocation = false

RegisterServerEvent('aLocation:CheckLiquide')
AddEventHandler('aLocation:CheckLiquide', function(amount)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if playerHasRentedVehicle then
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Vous avez déjà loué un véhicule.',
            type = 'error'
        })
    else
        if xPlayer.getMoney() >= amount then
            xPlayer.removeMoney(amount)
            TriggerClientEvent('ox_lib:notify', src, {
                title = 'Vous avez loué un véhicule.',
                type = 'success'
            })
            playerHasRentedVehicle = true -- Mettez à jour la variable pour indiquer que le joueur a loué un véhicule
        else
            TriggerClientEvent('ox_lib:notify', src, {
                title = 'Vous n\'avez pas assez d\'argent pour louer un véhicule.',
                type = 'error'
            })
        end
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
        TriggerClientEvent("esx:showNotification", source, "Vous venez de payer une caution de ~g~" .. ESX.Math.GroupDigits(CautionPerteVehicule) .. "$ !")
    else
        TriggerClientEvent("esx:showNotification", source, "Vous n'avez pas assez d'argent pour payer la caution.")
    end
end)
