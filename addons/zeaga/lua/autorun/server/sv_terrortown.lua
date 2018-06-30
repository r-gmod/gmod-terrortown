if SERVER then

	hook.Add( "TTTCheckForWin", "ZeagaPrepareRound", function( )
	end )

	hook.Add( "TTTDelayRoundStartForVote", "ZeagaDelayRoundStartForVote", function( )
		--return true
	end )

	hook.Add( "TTTPlayerRadioCommand", "ZeagaPlayerRadioCommand", function( ply, cmd_name, cmd_target )
	end )

	hook.Add( "TTTKarmaLow", "ZeagaKarmaLow", function( ply )
		if ply:IsSuperAdmin( ) then return false end
	end )

	hook.Add( "TTTOrderedEquipment", "ZeagaOrderedEquipment", function( )
	end )

	hook.Add( "TTTFoundDNA", "ZeagaFoundDNA", function( ply, dna_owner, ent )
	end )

	hook.Add( "TTTPlayerSpeedModifier", "ZeagaPlayerSpeed", function( ply, slowed )
		local speed = 1

		if slowed then
			speed = speed * 11/6
		end

		if ply.ZeagaIsSprinting then
			speed = speed * 4/3
		end
		
		if ply:SteamID( ) == "STEAM_0:1:11319794" then
			speed = speed * 1
		end
		
		return speed
	end )

	hook.Add( "TTTPlayerUsedHealthStation", "ZeagaPlayerUsedHealthStation", function( ply, ent_station, healed )
	end )

	hook.Add( "TTTBodyFound", "ZeagaBodyFound", function( ply, deadply, rag )
	end )
	
	hook.Add( "OnPlayerHitGround", "OnZeagaHitGround", function( ply, inWater, onFloater, speed )
		ply:SetVelocity( Vector( 0, 0, 0 ) )
	end )

end