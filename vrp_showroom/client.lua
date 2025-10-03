vRP = Proxy.getInterface("vRP")
vRPg = Proxy.getInterface("vRP_garages")
heading = 0

function deleteVehiclePedIsIn()
  local v = GetVehiclePedIsIn(GetPlayerPed(-1),false)
  SetVehicleHasBeenOwnedByPlayer(v,false)
  Citizen.InvokeNative(0xAD738C3085FE7E11, v, false, true) -- set not as mission entity
  SetVehicleAsNoLongerNeeded(Citizen.PointerValueIntInitialized(v))
  Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(v))
end

RegisterNetEvent( 'wk:deleteVehicle2' )
AddEventHandler( 'wk:deleteVehicle2', function()
    local ped = GetPlayerPed( -1 )

    if ( DoesEntityExist( ped ) and not IsEntityDead( ped ) ) then 
        local pos = GetEntityCoords( ped )

        if ( IsPedSittingInAnyVehicle( ped ) ) then 
            local vehicle = GetVehiclePedIsIn( ped, false )

            if ( GetPedInVehicleSeat( vehicle, -1 ) == ped ) then 
                SetEntityAsMissionEntity( vehicle, true, true )
                deleteCar( vehicle )

                if ( DoesEntityExist( vehicle ) ) then 
					--ShowNotification( "~r~Unable to delete vehicle, try again." )
					exports['mythic_notify']:SendAlert('inform',"Kunne ikke slette bilen, prøv igen")
                else 
					--ShowNotification( "Vehicle deleted." )
					exports['mythic_notify']:SendAlert('inform',"Bil slettet")
                end 
            else 
				--ShowNotification( "You must be in the driver's seat!" )
				exports['mythic_notify']:SendAlert('inform',"Du skal være i førersædet")
            end 
        else
            local playerPos = GetEntityCoords( ped, 1 )
            local inFrontOfPlayer = GetOffsetFromEntityInWorldCoords( ped, 0.0, distanceToCheck, 0.0 )
            local vehicle = GetVehicleInDirection( playerPos, inFrontOfPlayer )

            if ( DoesEntityExist( vehicle ) ) then 
                SetEntityAsMissionEntity( vehicle, true, true )
                deleteCar( vehicle )

                if ( DoesEntityExist( vehicle ) ) then 
					--ShowNotification( "~r~Unable to delete vehicle, try again." )
					exports['mythic_notify']:SendAlert('inform',"Kunne ikke slette bilen, prøv igen")
                else 
					--ShowNotification( "Vehicle deleted." )
					exports['mythic_notify']:SendAlert('inform',"Bil slettet")
                end 
            else 
				--ShowNotification( "You must be in or near a vehicle to delete it." )
				exports['mythic_notify']:SendAlert('inform',"Du skal være tæt på bilen for at slette den")
            end 
        end 
    end 
end )

function deleteCar( entity )
    Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( entity ) )
end

-- Gets a vehicle in a certain direction
-- Credit to Konijima
function GetVehicleInDirection( coordFrom, coordTo )
    local rayHandle = CastRayPointToPoint( coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed( -1 ), 0 )
    local _, _, _, _, vehicle = GetRaycastResult( rayHandle )
    return vehicle
end

-- Shows a notification on the player's screen 
function ShowNotification( text )
    SetNotificationTextEntry( "STRING" )
    AddTextComponentString( text )
    DrawNotification( false, false )
end

local vehshop = {
	opened = false,
	title = "HazeRP Bilforhandler",
	currentmenu = "main",
	lastmenu = nil,
	currentpos = nil,
	selectedbutton = 0,
	marker = { r = 0, g = 155, b = 255, a = 200, type = 1 },
	menu = {
		x = 0.1,
		y = 0.08,
		width = 0.2,
		height = 0.04,
		buttons = 10,
		from = 1,
		to = 10,
		scale = 0.4,
		font = 0,
		["main"] = {
			title = "Showroom",
			name = "main",
			buttons = {
				{name = "Eksklusiv", description = ''},
				{name = "Kompakte", description = ''},
				{name = "Coupéer", description = ''},
				{name = "Sedan", description = ''},
				{name = "Sports", description = ''},
				{name = "Sport klassikere", description = ''},
				{name = "Supers", description = ''},
				{name = "Muskel", description = ''},
				{name = "Offroad", description = ''},
				{name = "SUVer", description = ''},
				{name = "Varevogne", description = ''},
				{name = "Motorcykler", description = ''},
			}
		},
		["Eksklusiv"] = {
			title = "Eksklusiv",
			name = "Eksklusiv",
			buttons = {
				{name = "Lamborghini Performante", costs = 7000000, description = {}, model = "18performante"},
				{name = "Ferrari 599 Gtox", costs = 2000000, description = {}, model = "599gtox"},
				{name = "Porsche 718 Boxster", costs = 2500000, description = {}, model = "718boxster"},
				{name = "Brabus 850", costs = 50000000, description = {}, model = "brabus850"},
				{name = "Porsche 911 Turbo S", costs = 4000000, description = {}, model = "911turbos"},
				{name = "Bugatti Chiron", costs = 8000000, description = {}, model = ""},
				{name = "Mercedes A45 AMG", costs = 700000, description = {}, model = "a45amg"},
				{name = "Koenigsegg Agera", costs = 9000000, description = {}, model = "acsr"},
				{name = "Ferrari Aperta", costs = 6000000, description = {}, model = "aperta"},
				{name = "Audi S8", costs = 1000000, description = {}, model = "audis8om"},
				{name = "Pagani", costs = 7000000, description = {}, model = "bc"},
				{name = "Bugatti Divo", costs = 15000000, description = {}, model = "bdivo"},
				{name = "Mercedes Sl63", costs = 2000000, description = {}, model = "benzsl63"},
				{name = "BMW M5", costs = 1000000, description = {}, model = "bmci"},
				{name = "BMW s1000", costs = 16000000, description = {}, model = "bmws"},
				{name = "Bugatti Veyron", costs = 8000000, description = {}, model = "bugatti"},
				{name = "Corvette C7", costs = 3000000, description = {}, model = "c7"},
				{name = "Corvette C8", costs = 7000000, description = {}, model = "c8"},
				{name = "Mercedes C63s", costs = 10000000, description = {}, model = "c63s"},
				{name = "Ford GT 1968", costs = 2000000, description = {}, model = "fgt"},
				{name = "Ferrari Fxxk", costs = 5000000, description = {}, model = "fxxk"},
				{name = "Mercedes G63 AMG", costs = 1000000, description = {}, model = "g63amg"},
				{name = "Gardenshed", costs = 50000, description = {}, model = "gardenshed"},
				{name = "Mercedes GTR", costs = 6000000, description = {}, model = "gtrc"},
				{name = "Nissan GTR GT3", costs = 5000000, description = {}, model = "gtrgt3"},
				{name = "BMW i8", costs = 3000000, description = {}, model = "i8"},
				{name = "Hummer", costs = 1500000, description = {}, model = "h2m"},
				{name = "Isetta", costs = 30000, description = {}, model = "isetta"},
				{name = "Koenigsegg Jerka", costs = 9000000, description = {}, model = "jes"},
				{name = "Lexus", costs = 1000000, description = {}, model = "lc500"},
				{name = "Lamborghini LP700", costs = 8000000, description = {}, model = "lp700"},
				{name = "Lykan Hypersport", costs = 7000000, description = {}, model = "lykan"},
				{name = "BMW M6", costs = 6000000, description = {}, model = "m6f13"},
				{name = "Kawasaki", costs = 3000000, description = {}, model = "nh2r"},
				{name = "Randers knallert", costs = 30000, description = {}, model = "nrg"},
				{name = "McLaren P1", costs = 10000000, description = {}, model = "p1"},
				{name = "Porsche Panamera Turbo", costs = 2500000, description = {}, model = "panamera17turbo"},
				{name = "Audi R8", costs = 6000000, description = {}, model = "r820"},
				{name = "Mercedes GT63 Coupe", costs = 14000000, description = {}, model = "rmodgt63"},
				{name = "BMW M4", costs = 700000, description = {}, model = "rmodm4gts"},
				{name = "Mustang GT", costs = 1800000, description = {}, model = "rmodmustang"},
				{name = "Lamborghini Veneno", costs = 7000000, description = {}, model = "rmodveneno"},
				{name = "Audi RS6", costs = 1600000, description = {}, model = "rs615"},
				{name = "Mercedes S500 W222", costs = 20000000, description = {}, model = "s500w222"},
				{name = "Lamborghini SC18", costs = 11000000, description = {}, model = "sc18"},
				{name = "Mercedes E63", costs = 5000000, description = {}, model = "schafter3"},
				{name = "McLaren Senna", costs = 17000000, description = {}, model = "senna"},
				{name = "Lamborghini Sesto", costs = 10000000, description = {}, model = "sesto"},
				{name = "Lamborghini Sian", costs = 7000000, description = {}, model = "sian2"},
				{name = "Mercedes SLS AMG", costs = 3000000, description = {}, model = "slsamg"},
				{name = "Audi SQ7", costs = 6000000, description = {}, model = "sq72016"},
				{name = "Toyota Supra", costs = 2000000, description = {}, model = "supra2"},
				{name = "Tesla Model X", costs = 1500000, description = {}, model = "teslax"},
				{name = "Lamborghini Urus", costs = 13000000, description = {}, model = "urus2018"},
				{name = "Dodge Viper", costs = 455000, description = {}, model = "viper"},
				{name = "Lada", costs = 1000, description = {}, model = "urban"},
			}
		},
		["Kompakte"] = {
			title = "Kompakte",
			name = "Kompakte",
			buttons = {
				{name = "Blista", costs = 50000, description = {}, model = "blista"},
				{name = "Blista Compact", costs = 40000, description = {}, model = "blista2"},
				{name = "Brioso R/A", costs = 75000, description = {}, model = "brioso"},
				{name = "Dilettante", costs = 50000, description = {}, model = "Dilettante"},
				{name = "Issi", costs = 60000, description = {}, model = "issi2"},
				{name = "Issi Classic", costs = 40000, description = {}, model = "issi3"},
				{name = "Panto", costs = 60000, description = {}, model = "panto"},
				{name = "Prairie", costs = 75000, description = {}, model = "prairie"},
				{name = "Rhapsody", costs = 50000, description = {}, model = "rhapsody"},
			}
		},
		["Coupéer"] = {
			title = "Coupéer",
			name = "Coupéer",
			buttons = {
				{name = "Specter", costs = 2700000, description = {}, model = "specter"},
				{name = "Specter CTM", costs = 2700000, description = {}, model = "specter2"},
				{name = "Cognoscenti Cabrio", costs = 2300000, description = {}, model = "cogcabrio"},
				{name = "F620", costs = 2300000, description = {}, model = "f620"},
				{name = "Felon GT", costs = 1900000, description = {}, model = "felon2"},
				{name = "Jackal", costs = 1600000, description = {}, model = "jackal"},
				{name = "Oracle", costs = 1600000, description = {}, model = "oracle"},
				{name = "Oracle XS", costs = 1700000, description = {}, model = "oracle2"},
				{name = "Sentinel", costs = 900000, description = {}, model = "sentinel"},
				{name = "Sentinel XS", costs = 900000, description = {}, model = "sentinel2"},
				{name = "Windsor", costs = 2000000, description = {}, model = "windsor"},
				{name = "Windsor Drop", costs = 2200000, description = {}, model = "windsor2"},
				{name = "Zion", costs = 1100000, description = {}, model = "zion"},
				{name = "Zion Cabrio", costs = 1300000, description = {}, model = "zion2"},
			}
		},
		["Sports"] = {
			title = "Sports",
			name = "Sports",
			buttons = {
                {name = "Neon", costs = 1500000, description = {}, model = "neon"},
                {name = "Comet SR", costs = 1145000, description = {}, model = "comet5"},
                {name = "Comet", costs = 550000, description = {}, model = "comet3"},
                {name = "Pariah", costs = 1420000, description = {}, model = "pariah"},
                {name = "Banshee", costs = 105000, description = {}, model = "banshee"},
                {name = "Bestia GTS", costs = 610000, description = {}, model = "bestiagts"},
                {name = "Buffalo", costs = 750000, description = {}, model = "buffalo"},
                {name = "Buffalo S", costs = 960000, description = {}, model = "buffalo2"},
                {name = "Carbonizzare", costs = 195000, description = {}, model = "carbonizzare"},
                {name = "Coquette", costs = 138000, description = {}, model = "coquette"},
                {name = "Drift Tampa", costs = 995000, description = {}, model = "tampa2"},
                {name = "Feltzer", costs = 145000, description = {}, model = "feltzer2"},
                {name = "Furore GT", costs = 448000, description = {}, model = "furoregt"},
                {name = "Fusilade", costs = 650000, description = {}, model = "fusilade"},
                {name = "Jester", costs = 240000, description = {}, model = "jester"},
                {name = "Jester(Racerbil)", costs = 350000, description = {}, model = "jester2"},
                {name = "Kuruma", costs = 126350, description = {}, model = "kuruma"},
                {name = "Lynx", costs = 1735000, description = {}, model = "lynx"},
                {name = "Massacro", costs = 275000, description = {}, model = "massacro"},
                {name = "Massacro(Racecar)", costs = 385000, description = {}, model = "massacro2"},
                {name = "Omnis", costs = 701000, description = {}, model = "omnis"},
                {name = "Penumbra", costs = 600000, description = {}, model = "penumbra"},
                {name = "Rapid GT", costs = 132000, description = {}, model = "rapidgt"},
                {name = "Rapid GT Convertible", costs = 140000, description = {}, model = "rapidgt2"},
                {name = "Surano", costs = 100000, description = {}, model = "surano"},
                {name = "Tropos", costs = 816000, description = {}, model = "tropos"},
                {name = "Verkierer", costs = 695000, description = {}, model = "verlierer2"},
                {name = "Schlagen GT", costs = 1300000, description = {}, model = "Schlagen"},
                {name = "Khamelion", costs = 100000, description = {}, model = "khamelion"},
                {name = "Raptor", costs = 648000, description = {}, model = "raptor"},
                {name = "Ruston", costs = 430000, description = {}, model = "ruston"},
                {name = "Dominator GTX", costs = 725000, description = {}, model = "dominator3"},
				{name = "Sultan RS", costs = 450000, description = {}, model = "sultanrs"},
 
			}
		},
		["Sport klassikere"] = {
			title = "Sport klassikere",
			name = "Sport klassikere",
			buttons = {
				{name = "Rapid GT", costs = 885000, description = {}, model = "rapidgt3"},
                {name = "Retinue", costs = 615000, description = {}, model = "retinue"},
                {name = "Torero", costs = 998000, description = {}, model = "torero"},
                {name = "Cheetah Classic", costs = 865000, description = {}, model = "cheetah2"},
                {name = "GT500", costs = 785000, description = {}, model = "gt500"},
                {name = "Hermes", costs = 535000, description = {}, model = "hermes"},
                {name = "Casco", costs = 904000, description = {}, model = "casco"},
                {name = "Coquette Classic", costs = 665000, description = {}, model = "coquette2"},
                {name = "Pigalle", costs = 400000, description = {}, model = "pigalle"},
                {name = "Stinger", costs = 850000, description = {}, model = "stinger"},
                {name = "Stinger GT", costs = 875000, description = {}, model = "stingergt"},
                {name = "Stirling GT", costs = 975000, description = {}, model = "feltzer3"},
                {name = "Z-Type", costs = 950000, description = {}, model = "ztype"},
			}
		},
		["Supers"] = {
			title = "Supers",
			name = "Supers",
			buttons = {
                {name = "Adder", costs = 1000000, description = {}, model = "adder"},
                {name = "Nero", costs = 1440000, description = {}, model = "nero"},
                {name = "Entity XF", costs = 795000, description = {}, model = "entityxf"},
                {name = "Entity XXR", costs = 2305000, description = {}, model = "entity2"},
                {name = "811", costs = 1135000, description = {}, model = "pfister811"},
                {name = "Cyclone", costs = 1890000, description = {}, model = "cyclone"},
                {name = "Reaper", costs = 1595000, description = {}, model = "reaper"},
                {name = "Tyrant", costs = 2515000, description = {}, model = "tyrant"},
			}
		},
		["Muskel"] = {
			title = "Muskel",
			name = "Muskel",
			buttons = {
				{name = "Blade", costs = 160000, description = {}, model = "blade"},
				{name = "Buccaneer", costs = 190000, description = {}, model = "buccaneer"},
				{name = "Chino", costs = 225000, description = {}, model = "chino"},
				{name = "Coquette BlackFin", costs = 695000, description = {}, model = "coquette3"},
				{name = "Dominator", costs = 350000, description = {}, model = "dominator"},
				{name = "Dukes", costs = 162000, description = {}, model = "dukes"},
				{name = "Hotknife", costs = 190000, description = {}, model = "hotknife"},
				{name = "Faction", costs = 136000, description = {}, model = "faction"},
				{name = "Nightshade", costs = 585000, description = {}, model = "nightshade"},
				{name = "Picador", costs = 100000, description = {}, model = "picador"},
				{name = "Sabre Turbo", costs = 500000, description = {}, model = "sabregt"},
				{name = "Tampa", costs = 375000, description = {}, model = "tampa"},
				{name = "Virgo", costs = 195000, description = {}, model = "virgo"},
			}
		},
		["Offroad"] = {
			title = "Offroad",
			name = "Offroad",
			buttons = {
				{name = "Kamacho", costs = 315000, description = {}, model = "kamacho"},
				{name = "Riata", costs = 325000, description = {}, model = "riata"},
				{name = "Streiter", costs = 235000, description = {}, model = "streiter"},
				{name = "Bifta", costs = 75000, description = {}, model = "bifta"},
				{name = "Blazer", costs = 10000, description = {}, model = "blazer"},
				{name = "Brawler", costs = 715000, description = {}, model = "brawler"},
				{name = "Bubsta 6x6", costs = 375000, description = {}, model = "dubsta3"},
				{name = "Dune Buggy", costs = 200000, description = {}, model = "dune"},
				{name = "Rebel", costs = 220000, description = {}, model = "rebel2"},
				{name = "Nagasaki Street Blazer", costs = 35000, description = {}, model = "blazer4"},
			}
		},
		["SUVer"] = {
			title = "SUVer",
			name = "SUVer",
			buttons = {
                {name = "Baller", costs = 60000, description = {}, model = "baller"},
                {name = "Baller 2", costs = 90000, description = {}, model = "baller2"},
                {name = "Baller LE", costs = 149000, description = {}, model = "baller3"},
                {name = "Dubsta", costs = 1245000, description = {}, model = "dubsta"},
                {name = "Dubsta 2", costs = 249000, description = {}, model = "dubsta2"},
                {name = "Toros", costs = 498000, description = {}, model = "toros"},
                {name = "Contender", costs = 250000, description = {}, model = "contender"},
                {name = "XLS", costs = 253000, description = {}, model = "xls"},
                {name = "Rocoto", costs = 85000, description = {}, model = "rocoto"},
			}
		},
		["Varevogne"] = {
			title = "Varevogne",
			name = "Varevogne",
			buttons = {
				{name = "Moonbeam", costs = 450000, description = {}, model = "moonbeam2"},
				{name = "Yosemite", costs = 285000, description = {}, model = "yosemite"},
				{name = "Bison", costs = 130000, description = {}, model = "bison"},
				{name = "Bobcat XL", costs = 123000, description = {}, model = "bobcatxl"},
				{name = "Gang Burrito", costs = 245000, description = {}, model = "gburrito"},
				{name = "Journey", costs = 150000, description = {}, model = "journey"},
				{name = "Minivan", costs = 300000, description = {}, model = "minivan"},
				{name = "Paradise", costs = 250000, description = {}, model = "paradise"},
				{name = "Rumpo", costs = 130000, description = {}, model = "rumpo"},
				{name = "Surfer", costs = 110000, description = {}, model = "surfer"},
				{name = "Youga", costs = 160000, description = {}, model = "youga"},
				{name = "Granger", costs = 315000, description = {}, model = "granger"},
			}
		},
		["Sedan"] = {
			title = "Sedan",
			name = "Sedan",
			buttons = {
				{name = "Raiden", costs = 2500000, description = {}, model = "raiden"},
				{name = "Asea", costs = 200000, description = {}, model = "asea"},
				{name = "Cognoscenti", costs = 2200000, description = {}, model = "cognoscenti"},
				{name = "Cognoscenti 55", costs = 2000000, description = {}, model = "cog55"},
				{name = "Glendale", costs = 400000, description = {}, model = "glendale"},
				{name = "Ingot", costs = 85000, description = {}, model = "ingot"},
				{name = "Intruder", costs = 120000, description = {}, model = "intruder"},
				{name = "Premier", costs = 150000, description = {}, model = "premier"},
				{name = "Primo", costs = 100000, description = {}, model = "primo"},
				{name = "Primo Custom", costs = 200000, description = {}, model = "primo2"},
				{name = "Regina", costs = 100000, description = {}, model = "regina"},
				{name = "Stanier", costs = 100000, description = {}, model = "stanier"},
				{name = "Stratum", costs = 100000, description = {}, model = "stratum"},
				{name = "Super Diamond", costs = 1250000, description = {}, model = "superd"},
				{name = "Surge", costs = 240000, description = {}, model = "surge"},
				{name = "Tailgater", costs = 600000, description = {}, model = "tailgate"},
				{name = "Warrener", costs = 320000, description = {}, model = "warrener"},
				{name = "Washington", costs = 150000, description = {}, model = "washingt"},
			}
		},
		["Motorcykler"] = {
			title = "Motorcykler",
			name = "Motorcykler",
			buttons = {
				{name = "Akuma", costs = 90000, description = {}, model = "AKUMA"},
				{name = "Bagger", costs = 50000, description = {}, model = "bagger"},
				{name = "Bati 801", costs = 150000, description = {}, model = "bati"},
				{name = "Bati 801RR", costs = 150000, description = {}, model = "bati2"},
				{name = "BF400", costs = 195000, description = {}, model = "bf400"},
				{name = "Carbon RS", costs = 180000, description = {}, model = "carbonrs"},
				{name = "Cliffhanger", costs = 325000, description = {}, model = "cliffhanger"},
				{name = "Double T", costs = 112000, description = {}, model = "double"},
				{name = "Faggio", costs = 14000, description = {}, model = "faggio2"},
				{name = "Knallert", costs = 18000, description = {}, model = "faggio"},
				{name = "Gargoyle", costs = 220000, description = {}, model = "gargoyle"},
				--{name = "Daemon", costs = 100000, description = {}, model = "daemon"},
				{name = "Innovation", costs = 190000, description = {}, model = "innovation"},
				{name = "PCJ-600", costs = 90000, description = {}, model = "pcj"},
				{name = "Zombie Chobber", costs = 385000, description = {}, model = "zombieb"},
				{name = "Vindicator", costs = 600000, description = {}, model = "vindicator"},
				{name = "Sanchez", costs = 100000, description = {}, model = "sanchez"},
				{name = "Nightblade", costs = 400000, description = {}, model = "nightblade"},
			}
		},
	}
}

local fakecar = {model = '', car = nil}
local vehshop_locations = {
{entering = {-30.026309967042,-1105.0656738282,26.422369003296}, inside = {-75.28823852539,-819.08709716796,326.17541503906}, outside = {-29.130708694458,-1081.6518554688,26.638877868652}},
}

local vehshop_blips ={}
local inrangeofvehshop = false
local currentlocation = nil
local boughtcar = false


function vehPrs_drawTxt(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function vehSR_drawTxt(text,font,centre,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(scale, scale)
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

function vehSR_IsPlayerInRangeOfVehshop()
	return inrangeofvehshop
end

local firstspawn = 0
AddEventHandler('playerSpawned', function(spawn)
if firstspawn == 0 then
	--326 car blip 227 225
	vehSR_ShowVehshopBlips(true)
	firstspawn = 1
end
end)

function vehSR_ShowVehshopBlips(bool)
	if bool and #vehshop_blips == 0 then
		for station,pos in pairs(vehshop_locations) do
			local loc = pos
			pos = pos.entering
			local blip = AddBlipForCoord(pos[1],pos[2],pos[3])
			-- 60 58 137
			SetBlipSprite(blip,326)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString("Showroom")
			EndTextCommandSetBlipName(blip)
			SetBlipAsShortRange(blip,true)
			SetBlipAsMissionCreatorBlip(blip,true)
			table.insert(vehshop_blips, {blip = blip, pos = loc})
		end
		Citizen.CreateThread(function()
			while #vehshop_blips > 0 do
				Citizen.Wait(0)
				local inrange = false
				for i,b in ipairs(vehshop_blips) do
					if IsPlayerWantedLevelGreater(GetPlayerIndex(),0) == false and vehshop.opened == false and IsPedInAnyVehicle(vehSR_LocalPed(), true) == false and  GetDistanceBetweenCoords(b.pos.entering[1],b.pos.entering[2],b.pos.entering[3],GetEntityCoords(vehSR_LocalPed())) < 2.5 then
						--DrawMarker(36,b.pos.entering[1],b.pos.entering[2],b.pos.entering[3]-0.2,0,0,0,0,0,0,0.5,0.3,0.5,0,155,255,150,0,true,0,true)
						vehPrs_drawTxt("Tryk ~INPUT_CELLPHONE_SELECT~ for at snakke med ~r~Bilforhandleren")
						currentlocation = b
						inrange = true
					end
				end
				inrangeofvehshop = inrange
			end
		end)
	elseif bool == false and #vehshop_blips > 0 then
		for i,b in ipairs(vehshop_blips) do
			if DoesBlipExist(b.blip) then
				SetBlipAsMissionCreatorBlip(b.blip,false)
				Citizen.InvokeNative(0x86A652570E5F25DD, Citizen.PointerValueIntInitialized(b.blip))
			end
		end
		vehshop_blips = {}
	end
end

vehSR_ShowVehshopBlips(true)

function vehSR_f(n)
	return n + 0.0001
end

function vehSR_LocalPed()
	return GetPlayerPed(-1)
end

function vehSR_try(f, catch_f)
	local status, exception = pcall(f)
	if not status then
		catch_f(exception)
	end
end
function vehSR_firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end
--local veh = nil
function vehSR_OpenCreator()
	boughtcar = false
	local ped = vehSR_LocalPed()
	local pos = currentlocation.pos.inside
	FreezeEntityPosition(ped,true)
	local g = Citizen.InvokeNative(0xC906A7DAB05C8D2B,pos[1],pos[2],pos[3],Citizen.PointerValueFloat(),0)
	SetEntityCoords(ped,pos[1],pos[2],g)
	SetEntityHeading(ped,pos[4])
	SetEntityVisible(ped,false)
	vehshop.currentmenu = "main"
	vehshop.opened = true
	vehshop.selectedbutton = 0
end

local vehicle_price = 0
function vehSR_CloseCreator(vehicle,veh_type)
	Citizen.CreateThread(function()
		local ped = vehSR_LocalPed()
		if not boughtcar then
			local pos = currentlocation.pos.entering
			SetEntityCoords(ped,pos[1],pos[2],pos[3])
			FreezeEntityPosition(ped,false)
			SetEntityVisible(ped,true)
			vRP.teleport({-39.77363204956,-1110.4862060546,26.438457489014})
			SetEntityHeading(ped, 180.0)
			scaleform = nil
		else
			deleteVehiclePedIsIn()
			vRP.teleport({-39.77363204956,-1110.4862060546,26.438457489014})
			SetEntityHeading(ped, 180.0)
			--vRPg.spawnBoughtVehicle({veh_type, vehicle})
			SetEntityVisible(ped,true)
			FreezeEntityPosition(ped,false)
		end
		vehshop.opened = false
		vehshop.menu.from = 1
		vehshop.menu.to = 10
	end)
end

function vehSR_drawMenuButton(button,x,y,selected)
	local menu = vehshop.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(menu.scale, menu.scale)
	if selected then
		SetTextColour(0, 0, 0, 255)
	else
		SetTextColour(255, 255, 255, 255)
	end
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(button.name)
	if selected then
		DrawRect(x,y,menu.width,menu.height,255,255,255,255)
	else
		DrawRect(x,y,menu.width,menu.height,0,0,0,150)
	end
	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)
end

function vehSR_drawMenuTitle(txt,x,y)
local menu = vehshop.menu
	SetTextFont(2)
	SetTextProportional(0)
	SetTextScale(0.5, 0.5)
	SetTextColour(255, 255, 255, 255)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawRect(x,y,menu.width,menu.height,0,0,0,150)
	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)
end

simeonX, simeonY, simeonZ = -30.41927909851, -1106.771118164, 26.25236328125

function DrawText3D(x,y,z, text, scl) 

    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
 
    local scale = (1/dist)*scl
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
   
    if onScreen then
        SetTextScale(0.0*scale, 1.1*scale)
        SetTextFont(1)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

Citizen.CreateThread(function()
	simeon = 1283141381
	RequestModel( simeon )
	while ( not HasModelLoaded( simeon ) ) do
		Citizen.Wait( 1 )
	end
	theSimeon = CreatePed(4, simeon, simeonX, simeonY, simeonZ, 90, false, false)
	SetModelAsNoLongerNeeded(simeon)
	SetEntityHeading(theSimeon, -15.0)
	FreezeEntityPosition(theSimeon, true)
	SetEntityInvincible(theSimeon, true)
	SetBlockingOfNonTemporaryEvents(theSimeon, true)
	TaskStartScenarioAtPosition(theSimeon, "PROP_HUMAN_SEAT_BENCH", simeonX, simeonY, simeonZ-0.35, GetEntityHeading(theSimeon), 0, 0, false)
end)

Citizen.CreateThread(function()
	while true do
		local pos = GetEntityCoords(GetPlayerPed(-1), true)
		if(GetDistanceBetweenCoords(pos.x, pos.y, pos.z, simeonX, simeonY, simeonZ) < 5.5)then
			DrawText3D(simeonX, simeonY, simeonZ+0.8, "~r~ Bilforhandler", 1.2)
		end
		Citizen.Wait(0)
	end
end)


function vehSR_tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end
function vehSR_Notify(text)
SetNotificationTextEntry('STRING')
AddTextComponentString(text)
DrawNotification(false, false)
end

function vehSR_drawMenuRight(txt,x,y,selected)
	local menu = vehshop.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(menu.scale, menu.scale)
	if selected then
		SetTextColour(0, 0, 0, 255)
	else
		SetTextColour(255, 255, 255, 255)
	end
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawText(x + menu.width/2 - 0.06, y - menu.height/2 + 0.0028)
end
scaleform = nil
function Initialize(scaleform, price, vehName, speed, acce, brake, trac)
	scaleform = RequestScaleformMovie(scaleform)
	while not HasScaleformMovieLoaded(scaleform) do
		Citizen.Wait(0)
	end
	PushScaleformMovieFunction(scaleform, "SET_VEHICLE_INFOR_AND_STATS")
	PushScaleformMovieFunctionParameterString(vehName)
	PushScaleformMovieFunctionParameterString(price)
	PushScaleformMovieFunctionParameterString("MPCarHUD")
	PushScaleformMovieFunctionParameterString("Benefactor")
	PushScaleformMovieFunctionParameterString("Speed")
	PushScaleformMovieFunctionParameterString("Acceleration")
	PushScaleformMovieFunctionParameterString("Brakes")
	PushScaleformMovieFunctionParameterString("Traction")
	PushScaleformMovieFunctionParameterInt(speed or 100)
	PushScaleformMovieFunctionParameterInt(acce or 100)
	PushScaleformMovieFunctionParameterInt(brake or 100)
	PushScaleformMovieFunctionParameterInt(trac or 100)
	PopScaleformMovieFunctionVoid()
	return scaleform
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if(fakecar.model ~= nil) and (scaleform ~= nil)then
			local x = 0.67
			local y = 0.52
			local width = 0.65
			local height = width / 0.68
			DrawScaleformMovie(scaleform, x, y, width, height)
		end
	end
end)

function showroom_drawTxt(x,y ,width,height,scale, text, r,g,b,a, outline)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    if(outline)then
	    SetTextOutline()
	end
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

testDriveCar = nil
testDriveSeconds = 60
isInTestDrive = false
isInCar = false

function destroyTestDriveCar()
	if(testDriveCar ~= nil)then
		if(DoesEntityExist(testDriveCar))then
			Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(testDriveCar))
		end
		testDriveCar = nil
		isInTestDrive = false
	end
	testDriveSeconds = 60
	vRP.teleport({-39.77363204956,-1110.4862060546,26.438457489014})
	SetEntityHeading(GetPlayerPed(-1), 180.0)
	--vRP.notify({"~r~The test drive is over!"})
	exports['mythic_notify']:SendAlert('inform',"Testkørslen er færdig")
end

AddEventHandler("playerDropped", function()
	if(testDriveCar ~= nil)then
		destroyTestDriveCar()
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1100)
		if(testDriveCar ~= nil) and (isInTestDrive == false) then
			isInTestDrive = true
		else
			isInTestDrive = false
		end
		if(testDriveCar ~= nil)then
			local IsInVehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
			if(IsInVehicle ~= nil)then
				if(testDriveCar == IsInVehicle)then
					if(testDriveSeconds > 0)then
						testDriveSeconds = testDriveSeconds - 1
					else
						destroyTestDriveCar()
					end
					isInCar = true
				else
					isInCar = false
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if(testDriveSeconds < 60)then
			showroom_drawTxt(1.30, 1.40, 1.0,1.0,0.35, "~g~Testkør: ~r~"..testDriveSeconds.." ~y~Sekunder", 255, 255, 255, 255)
		end
		if(isInTestDrive) then
			if(isInCar == false)then
				destroyTestDriveCar()
			end
		end
	end
end)

carPrice = "$0"
local backlock = false
Citizen.CreateThread(function()
	local last_dir
	while true do
		Citizen.Wait(0)
		if IsControlJustPressed(1,201) and vehSR_IsPlayerInRangeOfVehshop() then
			if vehshop.opened then
				vehSR_CloseCreator("","")
			else
				vehSR_OpenCreator()
			end
		end
		if vehshop.opened then
			showroom_drawTxt(0.5, 1.073, 1.0,1.0,0.4, "~r~[ENTER] ~p~-> ~b~Køb bilen", 255, 255, 255, 255)
			showroom_drawTxt(0.5, 1.1, 1.0,1.0,0.4, "~r~[E] ~p~-> ~g~Load bilen", 255, 255, 255, 255)
			showroom_drawTxt(0.5, 1.13, 1.0,1.0,0.4, "~r~[F] ~p~-> ~y~Testkør bilen", 255, 255, 255, 255)
			local ped = vehSR_LocalPed()
			local menu = vehshop.menu[vehshop.currentmenu]
			vehSR_drawTxt(vehshop.title,1,1,vehshop.menu.x,vehshop.menu.y,1.0, 255,255,255,255)
			vehSR_drawMenuTitle(menu.title, vehshop.menu.x,vehshop.menu.y + 0.08)
			vehSR_drawTxt(vehshop.selectedbutton.."/"..vehSR_tablelength(menu.buttons),0,0,vehshop.menu.x + vehshop.menu.width/2 - 0.0385,vehshop.menu.y + 0.067,0.4, 255,255,255,255)
			local y = vehshop.menu.y + 0.12
			buttoncount = vehSR_tablelength(menu.buttons)
			local selected = false

			for i,button in pairs(menu.buttons) do
				if i >= vehshop.menu.from and i <= vehshop.menu.to then

					if i == vehshop.selectedbutton then
						selected = true
					else
						selected = false
					end
					vehSR_drawMenuButton(button,vehshop.menu.x,y,selected)
					if button.costs ~= nil then
						if vehshop.currentmenu == "Eksklusiv" or vehshop.currentmenu == "Kompakte" or vehshop.currentmenu == "Coupéer" or vehshop.currentmenu == "Sedan" or vehshop.currentmenu == "Sports" or vehshop.currentmenu == "Sport klassikere" or vehshop.currentmenu == "Supers" or vehshop.currentmenu == "Muskel" or vehshop.currentmenu == "Offroad" or vehshop.currentmenu == "SUVer" or vehshop.currentmenu == "Varevogne" or vehshop.currentmenu == "Motorcykler" then
							vehSR_drawMenuRight(" "..button.costs,vehshop.menu.x,y,selected)
							carPrice = " DKK"..button.costs
						else
							vehSR_drawMenuButton(button,vehshop.menu.x,y,selected)
						end
					end
					y = y + 0.04
					if vehshop.currentmenu == "Eksklusiv" or vehshop.currentmenu == "Kompakte" or vehshop.currentmenu == "Coupéer" or vehshop.currentmenu == "Sedan" or vehshop.currentmenu == "Sports" or vehshop.currentmenu == "Sport klassikere" or vehshop.currentmenu == "Supers" or vehshop.currentmenu == "Muskel" or vehshop.currentmenu == "Offroad" or vehshop.currentmenu == "SUVer" or vehshop.currentmenu == "Varevogne" or vehshop.currentmenu == "Motorcykler" then
						if selected then
							hash = GetHashKey(button.model)
							if IsControlJustPressed(1,23) then
								if(testDriveCar == nil)then
									if DoesEntityExist(fakecar.car) then
										Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(fakecar.car))
										scaleform = nil
									end
									fakecar = {model = '', car = nil}
									while not HasModelLoaded(hash) do
										RequestModel(hash)
										Citizen.Wait(10)
										showroom_drawTxt(0.935, 0.575, 1.0,1.0,0.4, "~r~LOADER BILEN", 255, 255, 255, 255)
									end
									if HasModelLoaded(hash) then
										testDriveCar = CreateVehicle(hash,-914.83026123046,-3287.1538085938,13.521618843078,60.962993621826,false,false)
										SetModelAsNoLongerNeeded(hash)
										TaskWarpPedIntoVehicle(GetPlayerPed(-1),testDriveCar,-1)
										--vRP.notify({"~g~You have ~r~1 Minute~g~ to test drive this vehicle!"})
										exports['mythic_notify']:SendAlert('inform',"Du har et minut til at prøve bilen")
										for i = 0,24 do
											SetVehicleModKit(testDriveCar,0)
											RemoveVehicleMod(testDriveCar,i)
										end
										if(testDriveCar)then
											vehshop.opened = false
											vehshop.menu.from = 1
											vehshop.menu.to = 10
											SetEntityVisible(GetPlayerPed(-1),true)
											FreezeEntityPosition(GetPlayerPed(-1),false)
											scaleform = nil
										end
									end
								end
							end
							if fakecar.model ~= button.model then
								if IsControlJustPressed(1,38) then
									if DoesEntityExist(fakecar.car) then
										Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(fakecar.car))
										scaleform = nil
									end
									local pos = currentlocation.pos.inside									
									local i = 0
									while not HasModelLoaded(hash) and i < 500 do
										RequestModel(hash)
										Citizen.Wait(10)
										i = i+1
										showroom_drawTxt(0.935, 0.575, 1.0,1.0,0.4, "~r~LOADER BILEN", 255, 255, 255, 255)
									end

									-- spawn car
									if HasModelLoaded(hash) then
									--if timer < 255 then
										veh = CreateVehicle(hash,pos[1],pos[2],pos[3],pos[4],false,false)
										FreezeEntityPosition(veh,true)
										SetEntityInvincible(veh,true)
										SetVehicleDoorsLocked(veh,4)
										SetModelAsNoLongerNeeded(hash)
										--SetEntityCollision(veh,false,false)
										TaskWarpPedIntoVehicle(vehSR_LocalPed(),veh,-1)
										for i = 0,24 do
											SetVehicleModKit(veh,0)
											RemoveVehicleMod(veh,i)
										end
										fakecar = { model = button.model, car = veh}
										Citizen.CreateThread(function()
											while DoesEntityExist(veh) do
												Citizen.Wait(25)
												SetEntityHeading(veh, GetEntityHeading(veh)+1 %360)
											end
										end)

										scaleform = Initialize("mp_car_stats_01", carPrice, button.name, button.speed, button.acce, button.brake, button.trac)
									else
										if last_dir then
											if vehshop.selectedbutton < buttoncount then
												vehshop.selectedbutton = vehshop.selectedbutton +1
												if buttoncount > 10 and vehshop.selectedbutton > vehshop.menu.to then
													vehshop.menu.to = vehshop.menu.to + 1
													vehshop.menu.from = vehshop.menu.from + 1
												end
											else
												last_dir = false
												vehshop.selectedbutton = vehshop.selectedbutton -1
												if buttoncount > 10 and vehshop.selectedbutton < vehshop.menu.from then
													vehshop.menu.from = vehshop.menu.from -1
													vehshop.menu.to = vehshop.menu.to - 1
												end
											end
										else
											if vehshop.selectedbutton > 1 then
												vehshop.selectedbutton = vehshop.selectedbutton -1
												if buttoncount > 10 and vehshop.selectedbutton < vehshop.menu.from then
													vehshop.menu.from = vehshop.menu.from -1
													vehshop.menu.to = vehshop.menu.to - 1
												end
											else
												last_dir = true
												vehshop.selectedbutton = vehshop.selectedbutton +1
												if buttoncount > 10 and vehshop.selectedbutton > vehshop.menu.to then
													vehshop.menu.to = vehshop.menu.to + 1
													vehshop.menu.from = vehshop.menu.from + 1
												end
											end
										end
									end
								end
							end
						end
					end
					if selected and IsControlJustPressed(1,201) then
						vehSR_ButtonSelected(button)
					end
				end
			end
			if IsControlJustPressed(1,202) then
				vehSR_Back()
			end
			if IsControlJustReleased(1,202) then
				backlock = false
			end
			if IsControlJustPressed(1,188) then
				last_dir = false
				if vehshop.selectedbutton > 1 then
					vehshop.selectedbutton = vehshop.selectedbutton -1
					if buttoncount > 10 and vehshop.selectedbutton < vehshop.menu.from then
						vehshop.menu.from = vehshop.menu.from -1
						vehshop.menu.to = vehshop.menu.to - 1
					end
				end
			end
			if IsControlJustPressed(1,187)then
				last_dir = true
				if vehshop.selectedbutton < buttoncount then
					vehshop.selectedbutton = vehshop.selectedbutton +1
					if buttoncount > 10 and vehshop.selectedbutton > vehshop.menu.to then
						vehshop.menu.to = vehshop.menu.to + 1
						vehshop.menu.from = vehshop.menu.from + 1
					end
				end
			end
		end

	end
end)


function vehSR_round(num, idp)
  if idp and idp>0 then
    local mult = 10^idp
    return math.floor(num * mult + 0.5) / mult
  end
  return math.floor(num + 0.5)
end
function vehSR_ButtonSelected(button)
	local ped = GetPlayerPed(-1)
	local this = vehshop.currentmenu
	local btn = button.name
	if this == "main" then
		if btn == "Eksklusiv" then
			vehSR_OpenMenu('Eksklusiv')
		elseif btn == "Kompakte" then
			vehSR_OpenMenu('Kompakte')
		elseif btn == "Coupéer" then
			vehSR_OpenMenu('Coupéer')
		elseif btn == "Sedan" then
			vehSR_OpenMenu('Sedan')
		elseif btn == "Sports" then
			vehSR_OpenMenu('Sports')
		elseif btn == "Sport klassikere" then
			vehSR_OpenMenu('Sport klassikere')
	    elseif btn == "Supers" then
		    vehSR_OpenMenu('Supers')
		elseif btn == "Muskel" then
			vehSR_OpenMenu('Muskel')
		elseif btn == "Offroad" then
			vehSR_OpenMenu('Offroad')
		elseif btn == "SUVer" then
			vehSR_OpenMenu('SUVer')
		elseif btn == "Varevogne" then
			vehSR_OpenMenu("Varevogne")
		elseif btn == "Motorcykler" then
			vehSR_OpenMenu('Motorcykler')
		end
	elseif this == "Eksklusiv" or this == "Kompakte" or this == "Coupéer" or this == "Muskel" or this == "Offroad" or this == "Sedan" or this == "Sports" or this == "Sport klassikere" or this == "Supers" or this == "SUVer" or this == "Varevogne" then
		TriggerServerEvent('veh_SR:CheckMoneyForVeh',this,button.model,button.costs,"car",false,false)
	elseif  this == "Motorcykler" then
		TriggerServerEvent('veh_SR:CheckMoneyForVeh',this,button.model,button.costs,"bike",false,false)
	end
end

RegisterNetEvent('veh_SR:CloseMenu')
AddEventHandler('veh_SR:CloseMenu', function(vehicle, veh_type)
	boughtcar = true
	vehSR_CloseCreator(vehicle,veh_type)
	scaleform = nil
end)

function vehSR_OpenMenu(menu)
	fakecar = {model = '', car = nil}
	vehshop.lastmenu = vehshop.currentmenu
	if menu == "Eksklusiv" then
		vehshop.lastmenu = "main"
	elseif menu == "Coupéer"  then
		vehshop.lastmenu = "main"
	elseif menu == "Sedan"  then
		vehshop.lastmenu = "main"
	elseif menu == "Sports"  then
		vehshop.lastmenu = "main"
	elseif menu == "Sport klassikere"  then
		vehshop.lastmenu = "main"
	elseif menu == "Supers"  then
		vehshop.lastmenu = "main"
	elseif menu == "SUVer"  then
		vehshop.lastmenu = "main"
	elseif menu == "Varevogne"  then
		vehshop.lastmenu = "main"
	elseif menu == "Muskel"  then
		vehshop.lastmenu = "main"
	elseif menu == 'race_create_objects' then
		vehshop.lastmenu = "main"
	elseif menu == "race_create_objects_spawn" then
		vehshop.lastmenu = "race_create_objects"
	end
	vehshop.menu.from = 1
	vehshop.menu.to = 10
	vehshop.selectedbutton = 0
	vehshop.currentmenu = menu
end


function vehSR_Back()
	if backlock then
		return
	end
	backlock = true
	if vehshop.currentmenu == "main" then
		vehSR_CloseCreator("","")
	elseif vehshop.currentmenu == "Eksklusiv" or vehshop.currentmenu == "Kompakte" or vehshop.currentmenu == "Coupéer" or vehshop.currentmenu == "Sedan" or vehshop.currentmenu == "Sports" or vehshop.currentmenu == "Sport klassikere" or vehshop.currentmenu == "Supers" or vehshop.currentmenu == "Muskel" or vehshop.currentmenu == "Offroad" or vehshop.currentmenu == "SUVer" or vehshop.currentmenu == "Varevogne" or vehshop.currentmenu == "Motorcykler" or vehshop.currentmenu == "Aston Martin" or vehshop.currentmenu == "Porche" or vehshop.currentmenu == "Toyota" or vehshop.currentmenu == "cars5" or vehshop.currentmenu == "bikes" or vehshop.currentmenu == "altele" or vehshop.currentmenu == "motociclete" or vehshop.currentmenu == "cop" or vehshop.currentmenu == "swat" or vehshop.currentmenu == "fisher" or vehshop.currentmenu == "weazelnews" or vehshop.currentmenu == "fbi" or vehshop.currentmenu == "ems" or vehshop.currentmenu == "uber" or vehshop.currentmenu == "lawyer" or vehshop.currentmenu == "delivery" or vehshop.currentmenu == "repair" or vehshop.currentmenu == "bankdriver" or vehshop.currentmenu == "medicalweed" or vehshop.currentmenu == "vip" or vehshop.currentmenu == "aviation" then
		if DoesEntityExist(fakecar.car) then
			Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(fakecar.car))
			scaleform = nil
		end
		fakecar = {model = '', car = nil}
		vehSR_OpenMenu(vehshop.lastmenu)
	else
		vehSR_OpenMenu(vehshop.lastmenu)
	end

end

function vehSR_stringstarts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end