--[[                                                                                                                                                      
                    NNNNNNNN        NNNNNNNN                                                           iiii                        000000000          888888888     
                    N:::::::N       N::::::N                                                          i::::i                     00:::::::::00      88:::::::::88   
                    N::::::::N      N::::::N                                                           iiii                    00:::::::::::::00  88:::::::::::::88 
                    N:::::::::N     N::::::N                                                                                  0:::::::000:::::::08::::::88888::::::8
xxxxxxx      xxxxxxxN::::::::::N    N::::::N  aaaaaaaaaaaaa  rrrrr   rrrrrrrrr       cccccccccccccccciiiiiii     ssssssssss   0::::::0   0::::::08:::::8     8:::::8
 x:::::x    x:::::x N:::::::::::N   N::::::N  a::::::::::::a r::::rrr:::::::::r    cc:::::::::::::::ci:::::i   ss::::::::::s  0:::::0     0:::::08:::::8     8:::::8
  x:::::x  x:::::x  N:::::::N::::N  N::::::N  aaaaaaaaa:::::ar:::::::::::::::::r  c:::::::::::::::::c i::::i ss:::::::::::::s 0:::::0     0:::::0 8:::::88888:::::8 
   x:::::xx:::::x   N::::::N N::::N N::::::N           a::::arr::::::rrrrr::::::rc:::::::cccccc:::::c i::::i s::::::ssss:::::s0:::::0 000 0:::::0  8:::::::::::::8  
    x::::::::::x    N::::::N  N::::N:::::::N    aaaaaaa:::::a r:::::r     r:::::rc::::::c     ccccccc i::::i  s:::::s  ssssss 0:::::0 000 0:::::0 8:::::88888:::::8 
     x::::::::x     N::::::N   N:::::::::::N  aa::::::::::::a r:::::r     rrrrrrrc:::::c              i::::i    s::::::s      0:::::0     0:::::08:::::8     8:::::8
     x::::::::x     N::::::N    N::::::::::N a::::aaaa::::::a r:::::r            c:::::c              i::::i       s::::::s   0:::::0     0:::::08:::::8     8:::::8
    x::::::::::x    N::::::N     N:::::::::Na::::a    a:::::a r:::::r            c::::::c     ccccccc i::::i ssssss   s:::::s 0::::::0   0::::::08:::::8     8:::::8
   x:::::xx:::::x   N::::::N      N::::::::Na::::a    a:::::a r:::::r            c:::::::cccccc:::::ci::::::is:::::ssss::::::s0:::::::000:::::::08::::::88888::::::8
  x:::::x  x:::::x  N::::::N       N:::::::Na:::::aaaa::::::a r:::::r             c:::::::::::::::::ci::::::is::::::::::::::s  00:::::::::::::00  88:::::::::::::88 
 x:::::x    x:::::x N::::::N        N::::::N a::::::::::aa:::ar:::::r              cc:::::::::::::::ci::::::i s:::::::::::ss     00:::::::::00      88:::::::::88   
xxxxxxx      xxxxxxxNNNNNNNN         NNNNNNN  aaaaaaaaaa  aaaarrrrrrr                cccccccccccccccciiiiiiii  sssssssssss         000000000          888888888     
                                                                                                                                                                                                                                                                                                                                  
]]


local ind = {l = false, r = false}

local hudState = true
RegisterNetEvent("xnarcis-plm:Speedometer")
AddEventHandler("xnarcis-plm:Speedometer", function(state)
	hudState = state

	if not hudState then
		SendNUIMessage({
			showhud = false
		})
	end
end)

Citizen.CreateThread(function()
	while true do

		if not hudState then
			Citizen.Wait(1000)
		else 
			local Ped = GetPlayerPed(-1)
			if(IsPedInAnyVehicle(Ped)) then
				local PedCar = GetVehiclePedIsIn(Ped, false)
				if PedCar and GetPedInVehicleSeat(PedCar, -1) == Ped then

					-- Viteza Masina
					carSpeed = math.ceil(GetEntitySpeed(PedCar) * 3.6) -- km/h daca vreti sa schimbati in mile pune-ti 1.86 ( xN )
					SendNUIMessage({
						showhud = true,
						speed = carSpeed
					})

					-- Luminite
					_,feuPosition,feuRoute = GetVehicleLightsState(PedCar)
					if(feuPosition == 1 and feuRoute == 0) then
						SendNUIMessage({
							feuPosition = true
						})
					else
						SendNUIMessage({
							feuPosition = false
						})
					end
					if(feuPosition == 1 and feuRoute == 1) then
						SendNUIMessage({
							feuRoute = true
						})
					else
						SendNUIMessage({
							feuRoute = false
						})
					end

					local VehIndicatorLight = GetVehicleIndicatorLights(GetVehiclePedIsUsing(PlayerPedId()))

					if(VehIndicatorLight == 0) then
						SendNUIMessage({
							clignotantGauche = false,
							clignotantDroite = false,
						})
					elseif(VehIndicatorLight == 1) then
						SendNUIMessage({
							clignotantGauche = true,
							clignotantDroite = false,
						})
					elseif(VehIndicatorLight == 2) then
						SendNUIMessage({
							clignotantGauche = false,
							clignotantDroite = true,
						})
					elseif(VehIndicatorLight == 3) then
						SendNUIMessage({
							clignotantGauche = true,
							clignotantDroite = true,
						})
					end

				else
					SendNUIMessage({
						showhud = false
					})
				end
			else
				SendNUIMessage({
					showhud = false
				})
			end
		end

		Citizen.Wait(1000)
	end
end)

-- Consum benzina
Citizen.CreateThread(function()
	while true do

		if not hudState then
			Citizen.Wait(1000)
		else 
			local Ped = GetPlayerPed(-1)
			if(IsPedInAnyVehicle(Ped)) then
				local PedCar = GetVehiclePedIsIn(Ped, false)
				if PedCar and GetPedInVehicleSeat(PedCar, -1) == Ped then
					carSpeed = math.ceil(GetEntitySpeed(PedCar) * 3.6)
					fuel = GetVehicleFuelLevel(PedCar)
					-- asa


					SendNUIMessage({
						showfuel = true,
						fuel = fuel
					})
				end
			end
		end
		
		Citizen.Wait(500)
	end
end)
