/*-------------------------------------------------------------------------------------------------------------------------
	Give a item to a player
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Give item"
PLUGIN.Description = "Give an item to a player."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "give"
PLUGIN.Usage = "<players> <item>"
PLUGIN.Privileges = { "Give item" }

function PLUGIN:Call( ply, args )
	if ( ply:EV_HasPrivilege( "Give item" ) ) then
		local players = evolve:FindPlayer( args, ply )
		local wep = args[ #args ]
		
		if ( #args < 2 ) then
			evolve:Notify( ply, evolve.colors.red, "No item specified!" )
		else
			if ( #players > 0 ) then
				for _, pl in ipairs( players ) do
					pl:Give( wep )
				end
				
				evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has given ", evolve.colors.red, evolve:CreatePlayerList( players ), evolve.colors.white, " a " .. wep .. "." )
			else
				evolve:Notify( ply, evolve.colors.red, evolve.constants.noplayers )
			end
		end
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

function PLUGIN:Menu( arg, players )
	if ( arg ) then
		table.insert( players, arg )
		RunConsoleCommand( "ev", "give", unpack( players ) )
	else
		return "Give", evolve.category.actions, {
			{ "Gravity gun", "weapon_physcannon" },
			{ "Physgun", "weapon_physgun" },
			{ "Crowbar", "weapon_crowbar" },
			{ "Stunstick", "weapon_stunstick" },
			{ "Pistol", "weapon_pistol" },
			{ ".357", "weapon_357" },
			{ "SMG", "weapon_smg1" },
			{ "Shotgun", "weapon_shotgun" },
			{ "Crossbow", "weapon_crossbow" },
			{ "AR2", "weapon_ar2" },
			{ "Bug bait", "weapon_bugbait" },
			{ "RPG", "weapon_rpg" },
			{ "Toolgun", "gmod_tool" },
			{ "Camera", "gmod_camera" }
		}
	end
end

evolve:RegisterPlugin( PLUGIN )