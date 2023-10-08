ESX = exports["es_extended"]:getSharedObject()


local selectedVehicle = nil

local playerHasRentedVehicle = false



Citizen.CreateThread(function()
  for k, v in pairs(Config.Position) do 
    local pedmodel = GetHashKey("ig_bankman")
    RequestModel(pedmodel)

    while not HasModelLoaded(pedmodel) do
      Citizen.Wait(1)
    end

    local Ped = CreatePed(2, pedmodel, Config.location.x, Config.location.y, Config.location.z, v.HeadingPed, 0, 0)
    SetEntityCoordsNoOffset(Ped, Config.location.x, Config.location.y, Config.location.z, true, true, true)

    FreezeEntityPosition(Ped, 1)
    TaskStartScenarioInPlace(Ped, Config.Blip.Ped.hash, 0, false)
    SetEntityInvincible(Ped, true)
    SetBlockingOfNonTemporaryEvents(Ped, 1)
  end
end)

Citizen.CreateThread(function()
  for k, v in pairs(Config.Position) do
      local blip = AddBlipForCoord(v.pos.x, v.pos.y, v.pos.z)
      SetBlipSprite(blip, Config.Blip.Type)
      SetBlipDisplay(blip, 4)
      SetBlipScale(blip, Config.Blip.Size)
      SetBlipColour(blip, Config.Blip.Color)
      SetBlipAsShortRange(blip, true)
      BeginTextCommandSetBlipName('STRING')
      AddTextComponentSubstringPlayerName(Config.Blip.Label)
      EndTextCommandSetBlipName(blip)
  end
end)

Citizen.CreateThread(function()
  for k, v in pairs(Config.Position) do
      local blip = AddBlipForCoord(Config.retourlocation.x, Config.retourlocation.y, Config.retourlocation.z)
      SetBlipSprite(blip, Config.Blip.Type)
      SetBlipDisplay(blip, 4)
      SetBlipScale(blip, Config.Blip.Size)
      SetBlipColour(blip, Config.Blip.Color)
      SetBlipAsShortRange(blip, true)
      BeginTextCommandSetBlipName('STRING')
      AddTextComponentSubstringPlayerName("Retour Location")
      EndTextCommandSetBlipName(blip)
  end
end)









------------------------ ox target

exports.ox_target:addBoxZone({
  coords =  vec3(Config.location.x, Config.location.y, Config.location.z),

  size = vec3(1, 1, 1),
  rotation = 180,
  debug = drawZones,
  options = {
      {
          name = 'box',
          event = 'zejay:VoitureLocation',
          icon = 'fa-solid fa-car',
          label = "Location : Voiture",
      },
      {
        name = 'box',
          event = 'zejay:MotoLocation',
          icon = 'fa-solid fa-bicycle',
          label = "Location : moto",

      },
  }
}) 


RegisterNetEvent('zejay:VoitureLocation')
AddEventHandler('zejay:VoitureLocation', function()
    lib.showContext('VoitureLocation')
end)


RegisterNetEvent('zejay:MotoLocation')
AddEventHandler('zejay:MotoLocation', function()
    lib.showContext('MotoLocation')
end)

options = {} 

if Config.Veh.Car and #Config.Veh.Car > 0 then
  for k, v in pairs(Config.Veh.Car) do
    local option = {
      title = v.label,
      icon = 'fa-solid fa-car',
      image = v.img,
    }

  if not playerHasRentedVehicle then
    option.event = 'aLocation:CheckLiquide'
    option.onSelect = function()
      selectedVehicle = v
      price = v.price + Config.Caution
      veh = v.veh 
      label = v.label 
    end
  else
    option.disabled = true
    option.description = 'Vous avez déjà loué un véhicule.'
  end
    table.insert(options, option) 
  end
end


lib.registerContext({
  id = 'VoitureLocation',
  title = 'Voiture Location',
  options = options, 

})


options = {} 

if Config.Veh.Bike and #Config.Veh.Bike > 0 then
  for k, v in pairs(Config.Veh.Bike) do
    local option = {
      title = v.label,
      icon = 'fa-solid fa-bicycle',
      image = v.img,
    }

    if not playerHasRentedVehicle then
      
      option.onSelect = function()
        selectedVehicle = v
        price = v.price + Config.Caution
        veh = v.veh 
        label = v.label 
      end
      option.event = 'aLocation:CheckLiquide'
    else
      option.disabled = true
      option.description = 'Vous avez déjà loué un véhicule.'
    end

    table.insert(options, option) 
  end
end
      



lib.registerContext({
  id = 'MotoLocation',
  title = 'Moto Location',
  options = options, 
})









RegisterNetEvent('aLocation:CheckLiquide')
AddEventHandler('aLocation:CheckLiquide', function()
  if not playerHasRentedVehicle then
    -- Vérifiez d'abord si le joueur a déjà loué un véhicule.
    ESX.TriggerServerCallback('aLocation:CheckLiquide', function(HasEnoughLiquide)
      if HasEnoughLiquide then 
        SpawnVehicule(selectedVehicle.veh, selectedVehicle.label)
        ComptLocation = true
        playerHasRentedVehicle = true
        selectedVehicle = nil
      else
        lib.notify({
          title = "Vous n'avez pas assez d'argent en liquide !",
          position = 'center',
          style = {
            backgroundColor = '#141517',
            color = '#C1C2C5',
            ['.description'] = {
              color = '#909296'
            }
          },
          icon = 'ban',
          iconColor = '#C53030'
        })
      end
    end, price) -- 'price' est le montant total à payer
  else
    -- Le joueur a déjà une location en cours, affichez un message d'erreur.
    lib.notify({
      title = 'Vous avez déjà loué un véhicule.',
      position = 'center',
      style = {
        backgroundColor = '#141517',
        color = '#C1C2C5',
        ['.description'] = {
          color = '#909296'
        }
      },
      icon = 'ban',
      iconColor = '#C53030'
    })
  end
end)

-- ...

-- Gestionnaire d'événement 'aLocation:CheckBank' mis à jour
RegisterNetEvent('aLocation:CheckBank', function()
  if selectedVehicle then
    local HasEnoughBank = true  -- Vous devrez ajouter votre propre logique pour vérifier l'argent en banque ici
    if HasEnoughBank then
      SpawnVehicule()
      ComptLocation = true
      playerHasRentedVehicle = true
    else
      lib.notify({
        title = "Vous n'avez pas assez d'argent en banque !",
        position = 'center',
        style = {
          backgroundColor = '#141517',
          color = '#C1C2C5',
          ['.description'] = {
            color = '#909296'
          }
        },
        icon = 'ban',
        iconColor = '#C53030'
      })
      return
    end
  else
    -- Gérez le cas où selectedVehicle est nil
  end
end)



function SpawnVehicule(typevehicle, label)


  if not typevehicle then
    print("Type de véhicule non défini dans la fonction SpawnVehicule.")
    return
  end
  local vehicleModel = GetHashKey(typevehicle)

  if not IsModelInCdimage(vehicleModel) or not IsModelAVehicle(vehicleModel) then
    print("Modèle de véhicule invalide : " .. typevehicle)
    return
  end
    -- Ajoutez ceci pour vérifier si le joueur a déjà loué un véhicule
  if playerHasRentedVehicle then
    lib.notify({
      title = 'vous avez deja loué un véhicule :',
      description = label,
      position = 'center',
      style = {
        backgroundColor = '#141517',
        color = '#C1C2C5',
        ['.description'] = {
          color = '#909296'
        }
      },
      icon = 'ban',
      iconColor = '#C53030'
    })
    return
  end
  
  -- Le joueur n'a pas encore loué de véhicule, continuez avec la location.
  RequestModel(vehicleModel)

  while not HasModelLoaded(vehicleModel) do
    Citizen.Wait(1)
    print("Chargement du modèle de véhicule...")
  end

  local ped = PlayerPedId()
  local pos = GetEntityCoords(ped)
  local heading = GetEntityHeading(ped)
  local veh = CreateVehicle(vehicleModel,vec3(Config.spawnveh.x, Config.spawnveh.y, Config.spawnveh.z), heading, false, false)

  if DoesEntityExist(veh) then
    SetVehRadioStation(veh, 0)
    SetVehicleNumberPlateText(veh, "Location")
    FreezeEntityPosition(ped)
    -- Téléporter le joueur dans la voiture côté passager.
    local seatIndex = -1 -- Côté passager
    TaskWarpPedIntoVehicle(ped, veh, seatIndex)
    lib.notify({
      title = 'Vous venez de louer :',
      description = label,
      position = 'center',
      type = 'success'
    })

    -- Mettez à jour la variable pour indiquer que le joueur a loué un véhicule.
    playerHasRentedVehicle = true
  else
    lib.notify({
      title = 'vous avez deja loué un veh :',
      description = label,
      position = 'center',
      style = {
        backgroundColor = '#141517',
        color = '#C1C2C5',
        ['.description'] = {
          color = '#909296'
        }
      },
      icon = 'ban',
      iconColor = '#C53030'
    })
  end
end





Citizen.CreateThread(function()
  for k, v in pairs(Config.Position) do 
    local pedmodel = GetHashKey("ig_bankman")
    RequestModel(pedmodel)

    while not HasModelLoaded(pedmodel) do
      Citizen.Wait(1)
    end

    local Ped = CreatePed(2, pedmodel, Config.retourlocation.x, Config.retourlocation.y, Config.retourlocation.z, 10, 0, 0)
    SetEntityCoordsNoOffset(Ped, Config.retourlocation.x, Config.retourlocation.y, Config.retourlocation.z, true, true, true)

    FreezeEntityPosition(Ped, 1)
    TaskStartScenarioInPlace(Ped, Config.Blip.Ped.hash, 0, false)
    SetEntityInvincible(Ped, true)
    SetBlockingOfNonTemporaryEvents(Ped, 1)
  end
end)



exports.ox_target:addBoxZone({
  coords =  vec3(Config.retourlocation.x, Config.retourlocation.y, Config.retourlocation.z),

  size = vec3(1, 1, 1),
  rotation = 180,
  debug = drawZones,
  options = {
      {
          name = 'box',
          event = 'aLocation:retourlocation',
          icon = 'fa-solid fa-car',
          label = "retour location",
      },
      {
        name = 'box',
        event = 'aLocation:perteLocation',
        icon = 'fa-solid fa-car',
        label = "Perte de location",
    },
  }
}) 



RegisterNetEvent('aLocation:retourlocation')
AddEventHandler('aLocation:retourlocation', function()
  local playerPed = PlayerPedId()
  if IsPedInAnyVehicle(playerPed, false) then
    -- Le joueur est dans un véhicule, vous pouvez permettre le retour de la location ici.
    if playerHasRentedVehicle then
      -- Le joueur a déjà une location en cours, vous pouvez gérer le retour ici.
      -- Par exemple, vous pouvez désactiver le véhicule loué et effectuer d'autres actions nécessaires.

      local GetVeh = GetVehiclePedIsIn(PlayerPedId(), false) 
      local HashVeh = GetEntityModel(GetVeh)
      local Plaque = GetVehicleNumberPlateText(GetVeh)
      if Plaque == "LOCATION" then 
        TriggerServerEvent('aLocation:retourlocation', Config.Caution)
        DeleteEntity(GetVeh)
        ComptLocation = false
        playerHasRentedVehicle = false  -- Réinitialisez ici
        selectedVehicle = nil
        lib.notify({
          title = 'Vous avez retourné le véhicule.',
          position = 'center',
          style = {
            backgroundColor = '#141517',
            color = '#C1C2C5',
            ['.description'] = {
              color = '#909296'
            }
          },
          icon = 'check',
          iconColor = '#28A745'
        })
      else
        lib.notify({
          title = "Votre véhicule n'est pas une location !.",
          position = 'center',
          style = {
            backgroundColor = '#141517',
            color = '#C1C2C5',
            ['.description'] = {
              color = '#909296'
            }
          },
          icon = 'ban',
          iconColor = '#28A745'
        })
      end

    else
      -- Le joueur n'a pas de location en cours, affichez un message d'erreur.
      lib.notify({
        title = "Vous n'avez pas de location en cours.",
        position = 'center',
        style = {
          backgroundColor = '#141517',
          color = '#C1C2C5',
          ['.description'] = {
            color = '#909296'
          }
        },
        icon = 'ban',
        iconColor = '#C53030'
      })
    end
  else
    -- Le joueur n'est pas dans un véhicule, affichez un message d'erreur.
    lib.notify({
      title = "Vous devez être dans un véhicule pour retourner la location.",
      position = 'center',
      style = {
        backgroundColor = '#141517',
        color = '#C1C2C5',
        ['.description'] = {
          color = '#909296'
        }
      },
      icon = 'ban',
      iconColor = '#C53030'
    })
  end
end)



RegisterNetEvent('aLocation:perteLocation')
AddEventHandler('aLocation:perteLocation', function()
  local playerPed = PlayerPedId()

  if playerHasRentedVehicle then
    TriggerServerEvent('aLocation:perteLocation', Config.Caution)
    ComptLocation = false
    playerHasRentedVehicle = false  -- Réinitialisez ici
    selectedVehicle = nil
    lib.notify({
      title = 'Perte de location',
      position = 'center',
      type = 'success'
    })

  else
    -- Le joueur n'a pas de location en cours, affichez un message d'erreur.
    lib.notify({
      title = "Vous n'avez pas de location en cours.",
      position = 'center',
      style = {
        backgroundColor = '#141517',
        color = '#C1C2C5',
        ['.description'] = {
          color = '#909296'
        }
      },
      icon = 'ban',
      iconColor = '#C53030'
    })
  end
end)

--(-959.8154.-2711.539,13.82861)