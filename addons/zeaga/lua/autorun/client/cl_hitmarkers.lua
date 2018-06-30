local alpha = 255

CreateClientConVar( "cp_hitmarker_enable", 1 )
CreateClientConVar( "cp_hitmarker_sound", 0 )
CreateClientConVar( "cp_hitmarker_alt", 0 )

hook.Add( "HUDPaint", "ZeagaHitMarker", function()
	if not GetConVar( "cp_hitmarker_enable" ):GetBool( ) then return end

	local bright = GetConVar( "ttt_crosshair_brightness" ):GetFloat( )
	
	if !LocalPlayer():Alive() then alpha = 0 return end
	
	alpha = math.Approach( alpha, 0, 5 )
	
	local screen = Vector(ScrW() / 2, ScrH() / 2)
	

	if LocalPlayer( ).IsTraitor and LocalPlayer( ):IsTraitor( ) then
		surface.SetDrawColor( 255 * bright, 50 * bright, 50 * bright, alpha )
	else
		surface.SetDrawColor(0, 255 * bright, 0, alpha )
	end

	surface.DrawLine( screen.x - 15, screen.y - 15, screen.x - 5, screen.y - 5 )
	surface.DrawLine( screen.x - 15, screen.y + 15, screen.x - 5, screen.y + 5 )
	surface.DrawLine( screen.x + 15, screen.y - 15, screen.x + 5, screen.y - 5 )
	surface.DrawLine( screen.x + 15, screen.y + 15, screen.x + 5, screen.y + 5 )
end )

net.Receive( "hitmarker", function( len )
	if GetConVar( "cp_hitmarker_enable" ):GetBool( ) and GetConVar( "cp_hitmarker_sound" ):GetBool( ) then
		local soundFile = "ui/hitsound.wav"
		if GetConVar( "cp_hitmarker_alt" ):GetBool( ) then
			soundFile = "ui/hitsound_menu_note" .. math.random( 1, 9 ) .. ".wav"
		end
		LocalPlayer( ):EmitSound( soundFile, 75, 100, 1 / 3 )
	end
end )