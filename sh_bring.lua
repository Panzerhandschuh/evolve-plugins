/*-------------------------------------------------------------------------------------------------------------------------
	Bring a player to you
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Bring"
PLUGIN.Description = "Bring a player."
PLUGIN.Author = "Overv & Divran"
PLUGIN.ChatCommand = "bring"
PLUGIN.Usage = "[players]"
PLUGIN.Privileges = { "Bring" }

PLUGIN.Positions = {}
for i=0,360,45 do table.insert( PLUGIN.Positions, Vector(math.cos(i),math.sin(i),0) ) end -- Around
table.insert( PLUGIN.Positions, Vector(0,0,1) ) -- Above

function PLUGIN:Call( ply, args )
	if ( ply:EV_HasPrivilege( "Bring" ) and ply:IsValid() ) then	
		local players = evolve:FindPlayer( args, ply )
		
		for i, pl in ipairs( players ) do
			if ( pl:InVehicle() ) then pl:ExitVehicle() end
			pl:SetPos( ply:GetPos() )
		end
		
		if ( #players > 0 ) then
			evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has brought ", evolve.colors.red, evolve:CreatePlayerList( players ), evolve.colors.white, " to them." )
		else
			evolve:Notify( ply, evolve.colors.red, evolve.constants.noplayers )
		end
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

function PLUGIN:Menu( arg, players )
	if ( arg ) then
		RunConsoleCommand( "ev", "bring", unpack( players ) )
	else
		return "Bring", evolve.category.teleportation
	end
end

evolve:RegisterPlugin( PLUGIN )