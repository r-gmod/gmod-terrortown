resource.AddSingleFile( "sound/ui/hitsound.wav" )
resource.AddSingleFile( "sound/ui/hitsound_menu_note1.wav" )
resource.AddSingleFile( "sound/ui/hitsound_menu_note2.wav" )
resource.AddSingleFile( "sound/ui/hitsound_menu_note3.wav" )
resource.AddSingleFile( "sound/ui/hitsound_menu_note4.wav" )
resource.AddSingleFile( "sound/ui/hitsound_menu_note5.wav" )
resource.AddSingleFile( "sound/ui/hitsound_menu_note6.wav" )
resource.AddSingleFile( "sound/ui/hitsound_menu_note7.wav" )
resource.AddSingleFile( "sound/ui/hitsound_menu_note8.wav" )
resource.AddSingleFile( "sound/ui/hitsound_menu_note9.wav" )
util.AddNetworkString( "hitmarker" )
 
local function ZeagaHitMarker( objEnt, dmgInfo )
	if not IsValid( objEnt ) then return end
	if dmgInfo:GetDamage( ) == 0 then return end
 
	local objAttacker = dmgInfo:GetAttacker( )
 
	if not IsValid( objAttacker ) or not objAttacker:IsPlayer( ) then return end
 
	if objEnt:IsPlayer( ) or objEnt:IsNPC( ) then
		net.Start( "hitmarker" )
			net.WriteBit( objEnt:IsNPC( ) )
		net.Send( objAttacker )
	end	
end
hook.Add( "EntityTakeDamage", "ZeagaTakeDamage", ZeagaHitMarker )