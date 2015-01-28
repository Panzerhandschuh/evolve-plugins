/*-------------------------------------------------------------------------------------------------------------------------
	Kick a player
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Vote Kick"
PLUGIN.Description = "Vote to kick a player."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "votekick"
PLUGIN.Usage = "<player>"
PLUGIN.Privileges = { "VoteKick" }

local votes = { }
local VOTE_PERCENT = 0.6
local MIN_VOTES = 2

function PLUGIN:Call( ply, args )
	if ( ply:EV_HasPrivilege( "VoteKick" ) ) then
		local pl = evolve:FindPlayer( args[1] )
		
		if ( #pl > 1 ) then
			evolve:Notify( ply, evolve.colors.white, "Did you mean ", evolve.colors.red, evolve:CreatePlayerList( pl, true ), evolve.colors.white, "?" )
		elseif ( #pl == 1 ) then
			if ( ply:EV_BetterThanOrEqual( pl[1] ) ) then
				
				if (CheckVote(ply, pl[1])) then
					-- Remove player's props
					for _, v in ipairs( ents.GetAll() ) do
						if ( v:EV_GetOwner() == pl[1]:UniqueID() ) then v:Remove() end
					end
					
					evolve:Notify( evolve.colors.red, pl[1]:Nick(), evolve.colors.white, " was kicked by a vote." )
					
					if ( gatekeeper ) then
						gatekeeper.Drop( pl[1]:UserID(), "Kicked by vote." )
					else
						pl[1]:Kick( "Kicked by vote." )
					end	
				end
			else
				evolve:Notify( ply, evolve.colors.red, evolve.constants.noplayers2 )
			end
		else
			evolve:Notify( ply, evolve.colors.red, evolve.constants.noplayers )
		end
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

function CheckVote( ply, target )
	-- Register vote
	if (!votes[target]) then
		votes[target] = { }
	end
	
	ResetVote(ply)
	if (!votes[target][ply]) then
		votes[target][ply] = true
	else
		evolve:Notify( ply, evolve.colors.red, "You have already voted to kick this player." )
		return false
	end

	-- Check if vote requirements have been met
	local voteCount = 0
	for k,v in pairs(votes[target]) do
		if (v) then
			voteCount = voteCount + 1
		end
	end
	
	local requiredVotes = math.Round(VOTE_PERCENT * #player.GetAll())
	if (requiredVotes < MIN_VOTES) then
		requiredVotes = MIN_VOTES
	end
	
	evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has voted to kick ", 
		evolve.colors.red, target:Nick(), evolve.colors.white,  ". (" .. voteCount, "/" .. requiredVotes .. ")" )
	if (voteCount < requiredVotes) then
		return false
	else
		return true
	end
end

function ResetVote(ply)
	for k,v in pairs(votes) do
		if (votes[k]) then
			votes[k][ply] = false
		end
	end
end

function PLUGIN:Menu( arg, players )
	if ( arg ) then
		RunConsoleCommand( "ev", "votekick", players[1], arg )
	else
		return "VoteKick", evolve.category.administration, { "No reason", "Spammer", "Asshole", "Mingebag", "Retard", "Continued despite warning" }, "Reason"
	end
end

hook.Add("PlayerDisconnected", "VoteKickDisconnect", function(ply)
	-- Remove player's votes
	ResetVote(ply)
end)

evolve:RegisterPlugin( PLUGIN )