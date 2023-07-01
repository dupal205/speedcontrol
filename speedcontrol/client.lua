vRP = Proxy.getInterface("vRP")
frontend = {}
Tunnel.bindInterface(GetCurrentResourceName(), frontend)
Proxy.addInterface(GetCurrentResourceName(), frontend)
backend = Tunnel.getInterface(GetCurrentResourceName(), GetCurrentResourceName())

local ui_active = false

local function EnableEvent()
    SendNUIMessage({
        type = "show"
    })
end

local function DisableEvent()
    SendNUIMessage({
        type = "hide"
    })
end

local function ScreenUpdate()
    local ped = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(ped, false)
    local boneIndex = GetEntityBoneIndexByName(vehicle, "window_rf")
    local boneCoords = GetEntityBonePosition_2(vehicle,boneIndex)
    local result, x, y = GetScreenCoordFromWorldCoord(boneCoords.x,boneCoords.y,boneCoords.z)
    
    SendNUIMessage({
        type = "screenXY",
        x = x * 100,
        y = y * 100,
        result = result
    })
end

local function FrontVehicle()
    local ped = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(ped, false)

    local startPoint = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, 1.0, 1.0)
    local endPoint = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, 105.0, 0.0)
    local raycast = StartShapeTestCapsule(startPoint, endPoint, 3.0, 2, vehicle, 7)
    local retval, hit, endCoords, surfaceNormal, vehicleHit = GetShapeTestResult(raycast)
    
    if hit == 0 then return end
    
    SendNUIMessage({
        type = "frontVehicle",
        plate = GetVehicleNumberPlateText(vehicleHit),
        speed = math.ceil(GetEntitySpeed(vehicleHit) * 3.6)
    })
end
local function BehindVehicle()
    local ped = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(ped, false)

    local startPoint = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, 1.0, 1.0)
    local endPoint = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, -105.0, 0.0)
    local raycast = StartShapeTestCapsule(startPoint, endPoint, 3.0, 2, vehicle, 7)
    local retval, hit, endCoords, surfaceNormal, vehicleHit = GetShapeTestResult(raycast)
    
    if hit == 0 then return end
    
    SendNUIMessage({
        type = "behindVehicle",
        plate = GetVehicleNumberPlateText(vehicleHit),
        speed = math.ceil(GetEntitySpeed(vehicleHit) * 3.6)
    })
end

Citizen.CreateThread(function()
    while true do
        Wait(1)
        local ped = GetPlayerPed(-1)
        local isPoliceVehicle = IsPedInAnyPoliceVehicle(ped)
        if isPoliceVehicle and IsControlJustPressed(0, 110) then
            ui_active = not ui_active
            if ui_active then
                backend.haspermission({}, function(p_server)
                    if p_server then
                        EnableEvent()
                    else
                        ui_active = false
                    end
                end)
            else
                DisableEvent()
            end
        elseif ui_active and not isPoliceVehicle then
            ui_active = false
            DisableEvent()
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(10)
        if ui_active then
            ScreenUpdate()
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(250)
        if ui_active then
            FrontVehicle()
            BehindVehicle()
        end
    end
end)