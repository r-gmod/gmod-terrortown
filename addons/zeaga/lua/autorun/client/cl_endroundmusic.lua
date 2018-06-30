-- Written by Zeaga for Zeaga's Community, CrimePanda TTT, and Questionable Ethics
-- http://steamcommunity.com/id/zeaga
CreateClientConVar( 'cp_music_enable', '1' )
CreateClientConVar( 'cp_music_volume', '100' )
net.Receive( 'MusicPlay', function( len )
	local tbl = net.ReadTable( )
	local announce = "You're listening to "
	local volume = GetConVar( 'cp_music_volume' )
	volume = volume:GetInt( ) or 100
	volume = math.min( volume, 100 )
	volume = volume / 100
	local enable = GetConVar( 'cp_music_volume' ):GetBool( )
	if enable then
		--surface.PlaySound( 'zeaga/' .. tbl[3] )
		LocalPlayer( ):EmitSound( 'zeaga/' .. tbl[3], 75, 100, volume )
		if tbl[4] then byfrom = " from " else byfrom = " by " end
		if tbl[1] and tbl[2] then
			chat.AddText( Color( 255, 255, 255 ), announce, Color( 63, 127, 255 ), tbl[2], Color( 255, 255, 255 ), byfrom, Color( 255, 63, 63 ), tbl[1] )
		elseif tbl[2] then
			chat.AddText( Color( 255, 255, 255 ), announce, Color( 63, 127, 255 ), tbl[2] )
		elseif tbl[1] then
			chat.AddText( Color( 255, 255, 255 ), announce, "a song", byfrom, Color( 255, 63, 63 ), tbl[1] )
		end
	end
end )