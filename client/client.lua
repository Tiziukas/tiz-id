ESX = exports["es_extended"]:getSharedObject()
local bossPeds = {}
local menuOpen = false
local qtarget = exports.qtarget
local JobStartLocation = lib.points.new(Config.NPCLocation, 50)
AddEventHandler('onClientResourceStart', function (resourceName)
    if(GetCurrentResourceName() ~= resourceName) then
        return
    else

    end
end)

RegisterNetEvent('tizid:openmenu')
AddEventHandler("tizid:openmenu", function()
    menuOpen = true
    -- Registers the menu
    lib.registerContext({
        id = 'IDMenu',
        title = Config.Language.menutitle,
        onExit = toggleMenu(),
        options = {
            {
                title = Config.Language.buy,
                description = Config.Language.buydescription,
                icon = 'truck-fast',
                metadata = {{label = 'Kaina $', value = Config.Price}},
                onSelect = function()
                    DoApplication()
                end,
            }
        }
    }) 

    lib.showContext('IDMenu')   
end)

function DoApplication()
    local input = lib.inputDialog(Config.Language.idmenu, {
        {type = 'input', label = Config.Language.name, description = Config.Language.namedesc, required = true, min = 4, max = 16},
        {type = 'input', label = Config.Language.lname, description = Config.Language.lnamedesc, required = true, min = 4, max = 16},
        {type = 'date', label = Config.Language.dobas, icon = {'far', 'calendar'}, default = true, required = true, format = "DD/MM/YYYY",returnString = true},
        {type = 'select', label = Config.Language.gender, options = {{value = "M", label = Config.Language.male}, {value = "F", label = Config.Language.female}}, icon = {'fas', 'child'}, required = true},
        {type = 'select', label = Config.Language.category, options = {{value = Config.Language.categorya, label = Config.Language.categorya}, {value = Config.Language.categoryb, label = Config.Language.categoryb}, {value = Config.Language.categoryc, label = Config.Language.categoryc}}, icon = {'fas', 'drivers-license'}, required = true},
        {type = 'slider', label = Config.Language.height, icon = {'fas', 'child'}, required = true, min = 120, max = 200, step = 1}
    })
    if not input then return end
    canPay = lib.callback('tizid:canpay', false)
    hasaLicense = lib.callback('tizid:checklicense', false)
    if canPay then
        if hasaLicense then
            local playerID = source
            lib.notify({
                title = Config.Language.notifytitle,
                description = Config.Language.notifysucces,
                type = 'success'
            })
            TriggerServerEvent("tizid:payment", playerID)
            TriggerServerEvent("tizid:giveid", playerID, input)
        else
            lib.notify({
                title = Config.Language.notifytitle,
                description = Config.Language.notifyalready,
                type = 'success'
            })
        end
    else
        lib.notify({
            title = Config.Language.notifytitle,
            description = Config.Language.notifymoney,
            type = 'success'
        })
    end
end
function JobStartLocation:onEnter()
    spawnIDNPC()
    qtarget:AddTargetEntity(createIDNPC, {
        options = {
            {
                name = Config.Language.pedname,
                icon = 'fa fa-vcard',
                label = Config.Language.eyepedname,
                action = function()
                    TriggerEvent('tizid:openmenu')
                end,
                distance = 10
            }
        }
    })
end
function toggleMenu()
    if menuOpen then
        menuOpen = false
    else
        menuOpen = true
    end
end

--Open Fake ID menu
local open = false

-- ESX
Citizen.CreateThread(function()
	ESX = exports["es_extended"]:getSharedObject()
end)

-- Open ID card
RegisterNetEvent('tizid:openclient')
AddEventHandler('tizid:openclient', function(data, type , mugshot)
	open = true
	SendNUIMessage({
		action = "open",
		array  = data,
		type   = type,
        mugshot = mugshot
	})
end)

-- Key events
Citizen.CreateThread(function()
    while true do
        Wait(0)
		if IsControlJustReleased(0, 322) and open or IsControlJustReleased(0, 177) and open then
			SendNUIMessage({
				action = "closea"
			})
			open = false
		end
	end
end)


RegisterCommand(Config.Command, function()
	if open then
		SendNUIMessage({
			action = "closea"
		})
		open = false
	else
		lib.showContext('FakeIDMenu')
		open = true
	end
end, false)


lib.registerContext({
  id = 'FakeIDMenu',
  title = Config.Language.idtitle,
  options = {
    {
      title = Config.Language.checktitle,
      description = Config.Language.checkdesc,
      icon = 'vcard',
      onSelect = function(data, menu)
        mugshotas = exports["loaf_headshot_base64"]:getBase64(PlayerPedId())
        mugshotasf = mugshotas.base64
		TriggerServerEvent('tizid:openserver', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'fakeid', mugshotasf)
      end,
    },
    {
        title = Config.Language.showtitle,
        description = Config.Language.showkdesc,
        icon = 'users',
        onSelect = function()
            local player, distance = ESX.Game.GetClosestPlayer()
            if distance ~= -1 and distance <= 1.5 then
                TriggerServerEvent('tizid:openserver', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'fakeid', mugshotasf)
            else
                lib.notify({
                    title = Config.Language.titlemenu,
                    description = Config.Language.menudesc,
                    type = 'success'
                })    
            end
        end,
      },
  }
})
function spawnIDNPC()
    lib.RequestModel(Config.NPCModel)
    createIDNPC = CreatePed(0, Config.NPCModel, Config.NPCLocation, Config.NPCLocationheading, false, true)
    FreezeEntityPosition(createIDNPC, true)
    SetBlockingOfNonTemporaryEvents(createIDNPC, true)
    SetEntityInvincible(createIDNPC, true)
end
