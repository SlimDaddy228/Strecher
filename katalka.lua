
local function LoadModel(model)
	while not HasModelLoaded(model) do
		RequestModel(model)
		
		Citizen.Wait(10)
	end
end

local function loadanim(dict)
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		
		Citizen.Wait(10)
	end
end
local function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
	SetTextFont(6)
	SetTextProportional(6)
	SetTextScale(scale/1.0, scale/1.0)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x , y)
end

local function Sit(wheelchairObject)
	loadanim("anim@gangops@morgue@table@")
	AttachEntityToEntity(PlayerPedId(), wheelchairObject, 0, 0, 0.0, 2.1, 0.0, 0.0, 270.0, 0.0, false, false, false, false, 2, true)
	local heading = GetEntityHeading(wheelchairObject)
	while IsEntityAttachedToEntity(PlayerPedId(), wheelchairObject) do
		Citizen.Wait(5)

		if IsPedDeadOrDying(PlayerPedId()) then
			DetachEntity(PlayerPedId(), true, true)
		end

		if not IsEntityPlayingAnim(PlayerPedId(), 'anim@gangops@morgue@table@', 'ko_front', 3) then
			TaskPlayAnim(PlayerPedId(), 'anim@gangops@morgue@table@', 'ko_front', 8.0, 8.0, -1, 69, 1, false, false, false)
		end
			if IsControlJustPressed(0, 73) then
				Citizen.Wait(100)
				DetachEntity(wheelchairObject, true, true)
				ClearPedTasks(PlayerPedId())
		end
	end
end

local function pickup(wheelchairObject)
	NetworkRequestControlOfEntity(wheelchairObject)
	loadanim("anim@mp_ferris_wheel")
	AttachEntityToEntity(wheelchairObject, PlayerPedId(), GetPedBoneIndex(PlayerPedId(),  28422), 0.9, 0.3, -1.1, 183.0, 183.0, 180.0, 0.0, false, false, true, false, 2, true)
	while IsEntityAttachedToEntity(wheelchairObject, PlayerPedId()) do
		Citizen.Wait(10)
		if not IsEntityPlayingAnim(PlayerPedId(), 'anim@mp_ferris_wheel', 'idle_a_player_one', 3) then
			TaskPlayAnim(PlayerPedId(), 'anim@mp_ferris_wheel', 'idle_a_player_one', 8.0, 8.0, -1, 50, 0, false, false, false)
		end
		if IsPedDeadOrDying(PlayerPedId()) then
			DetachEntity(wheelchairObject, true, true)
		end
		if IsControlJustPressed(0, 73) then
			DetachEntity(wheelchairObject, true, true)
			ClearPedTasks(PlayerPedId())
		end
	end
end


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
		local ped = PlayerPedId()
		local pedCoords = GetEntityCoords(ped)
		local closestObject = GetClosestObjectOfType(pedCoords, 3.0, GetHashKey("prop_ld_binbag_01"), false)
		local wheelChairCoords = GetEntityCoords(closestObject)
		local pickupCoords = wheelChairCoords
		if GetDistanceBetweenCoords(pedCoords, pickupCoords, true) <= 3.0 then
			drawTxt("~g~E~s~ взять ~o~G~s~ лечь ~r~X~w~ отпустить",0,1,0.5,0.95,0.6,255,255,255,255)
			if IsControlJustPressed(0, 38) then
				pickup(closestObject)
			end
			if IsControlJustPressed(0, 47) then
				Sit(closestObject)
			end
		end
	end
end)




RegisterNetEvent('spawnkatalka')
AddEventHandler('spawnkatalka', function()
	LoadModel('prop_ld_binbag_01')

	local wheelchair = CreateObject(GetHashKey('prop_ld_binbag_01'), GetEntityCoords(PlayerPedId()), true)
end)

RegisterNetEvent('deletekatalka')
AddEventHandler('deletekatalka', function()
	local wheelchair = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 10.0, GetHashKey('prop_ld_binbag_01'))

	if DoesEntityExist(wheelchair) then
		DeleteEntity(wheelchair)
	end
end)

