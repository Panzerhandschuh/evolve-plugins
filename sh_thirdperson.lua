/*-------------------------------------------------------------------------------------------------------------------------
	Kill a player
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Thirdperson"
PLUGIN.Description = "Toggle third person mode."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "thirdperson"
PLUGIN.Usage = "[players]"
PLUGIN.Privileges = { "Thirdperson" }

PLUGIN.Enabled = {}

function PLUGIN:Call( ply, args )
	if (ply:EV_HasPrivilege("Thirdperson")) then
		if (ply:GetNWBool("Thirdperson")) then
			ply:SetNWBool("Thirdperson", false)
			evolve:Notify(ply, evolve.colors.white, "Third person disabled")
		else -- Thirdperson is currently disabled, so toggle it on
			ply:SetNWBool("Thirdperson", true)
			evolve:Notify(ply, evolve.colors.white, "Third person enabled")
		end
	else
		evolve:Notify(ply, evolve.colors.red, evolve.constants.notallowed)
	end
end

function PLUGIN:Menu( arg, players )
	if ( arg ) then
		RunConsoleCommand( "ev", "thirdperson", unpack( players ) )
	else
		return "Thirdperson", evolve.category.actions
	end
end

if CLIENT then
	hook.Add("ShouldDrawLocalPlayer", "SimpleTP.ShouldDraw", function(ply)
		if (ply:GetNWBool("Thirdperson")) then
			return true
		end
	end)

	hook.Add("CalcView","SimpleTP.CameraView", function(ply, pos, angles, fov)
		if (ply:GetNWBool("Thirdperson")) then
			local view = {}
			
			angles.p = angles.p
			angles.y = angles.y
			
			-- Camera collision detection
			local traceData = {}
			traceData.start = pos
			traceData.endpos = traceData.start + angles:Forward() * -100
			traceData.endpos = traceData.endpos + angles:Right()
			traceData.endpos = traceData.endpos + angles:Up()
			traceData.filter = ply
			
			local trace = util.TraceLine(traceData)
			
			pos = trace.HitPos
			
			if trace.Fraction < 1.0 then
				pos = pos + trace.HitNormal * 5
			end
			
			view.origin = pos

			view.angles = angles
			view.fov = fov
		 
			return view

		end
	end)
end

evolve:RegisterPlugin( PLUGIN )