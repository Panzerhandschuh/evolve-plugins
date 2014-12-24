/*-------------------------------------------------------------------------------------------------------------------------
	Goto a player
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Teleport To"
PLUGIN.Description = "Teleport to a player."
PLUGIN.Author = "Overv & Divran"
PLUGIN.ChatCommand = "tpto"
PLUGIN.Usage = "[player]"
PLUGIN.Privileges = { "Tpto" }

PLUGIN.Cooldowns = {}

function PLUGIN:Call(ply, args)
	if (self.Cooldowns[ply]) then
		evolve:Notify(ply, evolve.colors.red, "You must wait before reusing this command.")
		return
	end
	
	if (string.find(game.GetMap(), "puzzle")) then
		evolve:Notify(ply, evolve.colors.red, "You cannot teleport to players on puzzle maps.")
		return
	end
	
	if (!ply:Alive()) then
		evolve:Notify(ply, evolve.colors.red, "You must be alive to use this command.")
		return
	end
	
	if (table.Count(args) == 0) then
		evolve:Notify(ply, evolve.colors.red, "You must specify a player to use this command.")
		return
	end

	if (ply:EV_HasPrivilege("Tpto" ) and ply:IsValid()) then	
		local players = evolve:FindPlayer(args, ply, false, true)
		
		if ( #players < 2 ) then			
			if ( #players > 0 ) then
				if (players[1] == ply) then
					evolve:Notify(ply, evolve.colors.red, "You cannot teleport to yourself")
					return
				elseif (!players[1]:Alive()) then
					evolve:Notify(ply, evolve.colors.red, "You cannot teleport to a dead player.")
					return
				end
			
				if ( ply:InVehicle() ) then ply:ExitVehicle() end
				
				ply:SetPos(players[1]:GetPos())
				self.Cooldowns[ply] = true
				timer.Simple(5, function()
					self.Cooldowns[ply] = false
				end)
				
				evolve:Notify(evolve.colors.blue, ply:Nick(), evolve.colors.white, " has teleported to ", evolve.colors.red, players[1]:Nick(), evolve.colors.white, ".")
			else
				evolve:Notify(ply, evolve.colors.red, evolve.constants.noplayers)
			end
		else
			evolve:Notify(ply, evolve.colors.white, "Did you mean ", evolve.colors.red, evolve:CreatePlayerList( players, true ), evolve.colors.white, "?")
		end
	else
		evolve:Notify(ply, evolve.colors.red, evolve.constants.notallowed)
	end
end

function PLUGIN:Menu( arg, players )
	if ( arg ) then
		RunConsoleCommand( "ev", "tpto", unpack( players ) )
	else
		return "Tpto", evolve.category.teleportation
	end
end

evolve:RegisterPlugin( PLUGIN )