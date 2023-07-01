local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
frontend = Tunnel.getInterface(GetCurrentResourceName(), GetCurrentResourceName())

backend = {}
Tunnel.bindInterface(GetCurrentResourceName(), backend)

function backend.haspermission()
    local user_id = vRP.getUserId({source})
    if user_id ~= nil then
        if vRP.hasPermission({user_id, config["permission"]}) then
            return true
        else
            return false
        end
    end
end