hook.Add( "TTTSettingsTabs", "ZeagaTTTSettingsTabs", function( tabs )

	local settings = vgui.Create( "DPanelList", tabs )
	settings:StretchToParent( 0, 0, 0, 0 )
	settings:EnableVerticalScrollbar(true)
	settings:SetPadding( 10 )
	settings:SetSpacing( 10 )

	local cat_interface = vgui.Create( "DForm", settings )
		cat_interface:SetName("Interface settings")
		--cat_interface:CheckBox( "Avatar on HUD", "cp_hud_avatar_enable" )
		cat_interface:CheckBox( "Hitmarkers", "cp_hitmarker_enable" )
		cat_interface:CheckBox( "Sound on hit", "cp_hitmarker_sound" )
		cat_interface:CheckBox( "Alternate sounds", "cp_hitmarker_alt" )
		cat_interface:CheckBox( "End-round music", "cp_music_enable" )
		cat_interface:NumSlider( "End-round music volume", "cp_music_volume", 0, 100, 0 )
	settings:AddItem( cat_interface )
	
	local cat_damagelogs = vgui.Create( "DForm", settings )
		cat_damagelogs:SetName("Damagelog settings")
		cat_damagelogs:CheckBox( "RDM Manager popups upon RDM", "ttt_dmglogs_rdmpopups" )
		cat_damagelogs:CheckBox( "Open the current round by default if you're alive and allowed to open the logs", "ttt_dmglogs_currentround" )
		cat_damagelogs:CheckBox( "Notification sound outside of the game", "ttt_dmglogs_outsidenotification" )
	settings:AddItem( cat_damagelogs )

	tabs:AddSheet( "CrimePanda", settings, "icon16/heart.png", false, false, "CrimePanda Settings" )

end )