hook.Add( "KeyPress", "ZeagaSprintKeyPress", function( ply, key )

	if not ply.ZeagaSprintLastPressed then ply.ZeagaSprintLastPressed = 0 end
	if key == IN_FORWARD then
		if RealTime( ) - ply.ZeagaSprintLastPressed <= 0.25 then
			ply.ZeagaIsSprinting = true
		end
		ply.ZeagaSprintLastPressed = RealTime( )
	end

	if not ply.MovementKeys then ply.MovementKeys = { } end
	if key == IN_FORWARD then ply.MovementKeys[IN_FORWARD] = true end
	if key == IN_MOVELEFT then ply.MovementKeys[IN_MOVELEFT] = true end
	if key == IN_BACK then ply.MovementKeys[IN_BACK] = true end
	if key == IN_MOVERIGHT then ply.MovementKeys[IN_MOVERIGHT] = true end

end )

hook.Add( "KeyRelease", "ZeagaSprintKeyRelease", function( ply, key )

	if key == IN_FORWARD then ply.ZeagaIsSprinting = false end

end )

-- Fuck lag

hook.Add( "Think", "ZeagaSprintThink", function( )
	local MaxSprint = 1
	for _, ply in pairs( player.GetAll( ) ) do
		local SprintLevel = ply:GetNWFloat( "ZeagaSprint", MaxSprint )
		if ply.ZeagaIsSprinting == true && ply:Alive( ) then
			if SprintLevel > 0 then
				ply:SetNWFloat( "ZeagaSprint", math.max( SprintLevel - 1/200, 0 ) )
			else
				ply.ZeagaIsSprinting = false
			end
		else
			if SprintLevel <= MaxSprint then
				ply:SetNWFloat( "ZeagaSprint", math.min( SprintLevel + 1/400, MaxSprint ) )
			end
		end
	end
end )