local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vrp_ems_objects")


local function ch_medbag(player,choice)
  TriggerClientEvent("artic_medbag", player)
end


local function ch_deletek(player,choice)
  TriggerClientEvent("deletek",player)
end

local function ch_spawnkatalka(player,choice)
  TriggerClientEvent("spawnkatalka",player)
end

local function ch_deletekatalka(player,choice)
  TriggerClientEvent("deletekatalka",player)
end

vRP.registerMenuBuilder("main", function(add, data)
  local user_id = vRP.getUserId(data.player)
  if user_id then
    local choices = {}

    -- build admin menu
    choices["Медики"] = {function(player,choice)
      local menu  = vRP.buildMenu("ems", {player = player})
      menu.name = "Медики"
      menu.css={top="75px",header_color="#9167dd"}
      menu.onclose = function(player) vRP.openMainMenu(player) end -- nest menu

      if vRP.hasPermission(user_id,"player.list") then
        menu["Мед.сумка"] = {ch_medbag, "Мед.сумка"}
      end
      if vRP.hasPermission(user_id, "player.list") then
        menu["Достать каталку"] = {ch_spawnkatalka, "Достать каталку"}
      end
      if vRP.hasPermission(user_id, "player.list") then
        menu["Удалить каталку"] = {ch_deletekatalka, "Удалить каталку"}
      end
      if vRP.hasPermission(user_id, "player.list") then
        menu["Удалить"] = {ch_deletek, "Удалить сумку"}
      end
   

      vRP.openMenu(player,menu)
    end}

    add(choices)
  end
end)