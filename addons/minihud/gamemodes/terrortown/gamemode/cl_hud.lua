--[[ MiniHUD v2.1.2
		Written by Zeaga ( STEAM_0:1:11319794 ) for Zeaga's Community, CrimePanda, and /r/gmod
		Some modifications made to accommodate for the needs of Questionable Ethics
		Based on a design by Infideon ( STEAM_0:0:38309588 ) created for Zeaga's Community

		Not for resale or redistribution.
		The user is not promised indefinite support regarding this addon, but it is welcomed.
		Do not remove or modify this comment block.

		YES, I KNOW THIS ADDON IS MESSY.  Writing a HUD addon for a gamemode is janky as shit.
		These were actually in seperate files before, hence being seperated into "blocks", but
		that didn't work out and I was on a deadline.
		This will look (hopefully) better in the future.  Stay tuned!
]]

MiniHUD = MiniHUD or { } -- Do not touch this line.  You've been warned.

--[[    CONFIG BLOCK    ]]
do
	function MiniHUD.CanColor( ) -- Whether or not the player can change the HUD colors | return boolean (true/false)
		return true --LocalPlayer( ):IsDonor( )
	end

	function MiniHUD.GetStamina( ) -- Stamina check | return number 0-1 OR false to disable
		return LocalPlayer( ):GetNWFloat( "ZeagaSprint", 0 )
	end

	function MiniHUD.GetPunch( ) -- Punch check | return number 0-1 OR false to disable
		return false --LocalPlayer( ):GetNWFloat( "specpunches", 0 )
	end

	MiniHUD.ColorsDefault = {
		health = {
			back = Color( 15, 71, 31 ),
			fill = Color( 31, 143, 63 ),
		},
		stamina = {
			back = Color( 15, 31, 71 ),
			fill = Color( 31, 63, 143 ),
		},
		ammo = {
			back = Color( 71, 71, 31 ),
			fill = Color( 143, 143, 63 ),
		},
		punch = {
			back = Color( 15, 31, 71 ),
			fill = Color( 31, 63, 143 ),
		},
	}

	MiniHUD.ColorsMisc = {
		background = Color( 0, 0, 0, 207 ), -- You might want to leave this unchanged.
		spectator = Color( 95, 95, 95 ),
		traitor = Color( 191, 31, 31 ),
		innocent = Color( 31, 191, 31 ),
		detective = Color( 31, 31, 191 ),
	}
end -- STOP HERE.  DO NOT TREAD FURTHER UNLESS YOU KNOW WHAT YOU'RE DOING.



--[[   GAMEMODE BLOCK    ]]
do
	MiniHUD.Prefix = "minihud_"
	MiniHUD.PrefixColor = MiniHUD.Prefix .. "color_"

	local hud = { "CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo" }
	function GM:HUDShouldDraw( name )
		for k, v in pairs( hud ) do
			if name == v then return false end
		end
		return true
	end
	local words = {
		["stamina"] = {
			["english"] = "Stamina",
			["Deutsch"] = "Ausdauer",
			["Português"] = "Resistência",
			["Русский"] = "Выносливость",
			["Español"] = "Aguante",
			["Svenska"] = "Uthållighet",
			["正體中文 "] = "耐力",
		},
		["health"] = {
			["english"] = "Health",
			["Deutsch"] = "Gesundheit",
			["Português"] = "Vida",
			["Русский"] = "Здоровье",
			["Español"] = "Salud",
			["Svenska"] = "Hälsa",
			["正體中文 "] = "健康值",
		},
		["ammo"] = {
			["english"] = "Ammo",
			["Deutsch"] = "Munition",
			["Português"] = "Munição",
			["Русский"] = "патроны",
			["Español"] = "Munición",
			["Svenska"] = "Ammo",
			["正體中文 "] = "彈藥",
		}
	}
	for string_name, word_table in pairs( words ) do
		for lang_name, string_text in pairs( word_table ) do
			LANG.AddToLanguage( lang_name, string_name, string_text )
		end
	end
end



--[[    UTIL BLOCK    ]]
do
	function MiniHUD.Log( str )
		return MsgC( Color( 127, 191, 255 ), '[MiniHUD] ', Color( 255, 255, 255 ), str .. '\n' )
	end

	function MiniHUD.Inlog( str )
		return MsgC( Color( 127, 191, 255 ), '>\t', Color( 255, 255, 255 ), str .. '\n' )
	end

	function MiniHUD.GetAmmo( ply )
		local weap = ply:GetActiveWeapon( )
		if not weap or not ply:Alive( ) then return -1 end

		local ammo_inv = weap:Ammo1( ) or 0
		local ammo_clip = weap:Clip1( ) or 0
		local ammo_max = weap.Primary.ClipSize or 0

		return ammo_clip, ammo_max, ammo_inv
	end

	local roundstate_string = {
		[ROUND_WAIT] = "round_wait",
		[ROUND_PREP] = "round_prep",
		[ROUND_ACTIVE] = "round_active",
		[ROUND_POST] = "round_post"
	}

	function MiniHUD.RoundState( state )
		return roundstate_string[state]
	end

	local blur = Material( "pp/blurscreen" )
	function MiniHUD.DrawBlurredRect( x, y, w, h, layers, density, alpha )
		local X, Y = 0, 0
		local scrW, scrH = ScrW( ), ScrH( )
		surface.SetDrawColor( 255, 255, 255, alpha )
		surface.SetMaterial( blur )
		for i = 1, 3 do
			blur:SetFloat( "$blur", ( i / layers ) * density )
			blur:Recompute( )
			render.UpdateScreenEffectTexture( )
			render.SetScissorRect( x, y, x+w, y+h, true )
				surface.DrawTexturedRect( X * -1, Y * -1, scrW, scrH )
			render.SetScissorRect( 0, 0, 0, 0, false )
		end
	end

	function MiniHUD.PaintBar( x, y, w, h, back, fill, value )
		surface.SetDrawColor( back )
		surface.DrawRect( x, y, w, h )

		local w = w * math.Clamp( value, 0, 1 )

		if w > 0 then
			surface.SetDrawColor( fill )
			surface.DrawRect( x, y, w, h )
		end
	end

	function MiniHUD.ShadowedText( text, font, x, y, color, xalign, yalign, invert )
		local back = COLOR_BLACK
		if invert then back = invert end
		draw.SimpleText( text, font, x+2, y+2, back, xalign, yalign )
		draw.SimpleText( text, font, x, y, color, xalign, yalign )
	end
end



--[[    VARS BLOCK    ]]
do
	local BoolVars = { avatar = "0", label = "1", value = "1", percent = "1", lerp = "1" }

	function MiniHUD.VarsInit( )
		for k, v in pairs( BoolVars ) do
			CreateClientConVar( MiniHUD.Prefix .. k, v )
		end
		for statK, statV in pairs( MiniHUD.ColorsDefault ) do
			for layerK, layerV in pairs( statV ) do
				CreateClientConVar( MiniHUD.PrefixColor .. statK .. "_" .. layerK .. "_r", layerV.r )
				CreateClientConVar( MiniHUD.PrefixColor .. statK .. "_" .. layerK .. "_g", layerV.g )
				CreateClientConVar( MiniHUD.PrefixColor .. statK .. "_" .. layerK .. "_b", layerV.b )
			end
		end
		concommand.Add( MiniHUD.PrefixColor .. "reset", function( )
			MiniHUD.VarsReset( )
		end )
	end
	MiniHUD.VarsInit( )

	function MiniHUD.VarsReset( )
		for k, v in pairs( BoolVars ) do
			RunConsoleCommand( MiniHUD.Prefix .. k, v )
		end
		for statK, statV in pairs( MiniHUD.ColorsDefault ) do
			for layerK, layerV in pairs( statV ) do
				RunConsoleCommand( MiniHUD.PrefixColor .. statK .. "_" .. layerK .. "_r", layerV.r )
				RunConsoleCommand( MiniHUD.PrefixColor .. statK .. "_" .. layerK .. "_g", layerV.g )
				RunConsoleCommand( MiniHUD.PrefixColor .. statK .. "_" .. layerK .. "_b", layerV.b )
			end
		end
	end

	function MiniHUD.VarsGet( convar, layer, key )
		if BoolVars[convar] then
			return GetConVar( MiniHUD.Prefix .. convar ):GetBool( )
		elseif MiniHUD.ColorsDefault[convar] then
			if layer then
				if key then
					if MiniHUD.ColorsDefault[convar][layer][key] then
						if MiniHUD.CanColor( ) then
							return GetConVar( MiniHUD.PrefixColor .. convar .. "_" .. layer .. "_" .. key ):GetInt( )
						else
							return MiniHUD.ColorsDefault[convar][layer][key]
						end
					else
						return false
					end
				else
					if MiniHUD.CanColor( ) then
						local r, g, b
						r = GetConVar( MiniHUD.PrefixColor .. convar .. "_" .. layer .. "_r" ):GetInt( )
						g = GetConVar( MiniHUD.PrefixColor .. convar .. "_" .. layer .. "_g" ):GetInt( )
						b = GetConVar( MiniHUD.PrefixColor .. convar .. "_" .. layer .. "_b" ):GetInt( )
						return Color( r, g, b )
					else
						return MiniHUD.ColorsDefault[convar][layer]
					end
				end
			else
				if MiniHUD.CanColor( ) then
					local rB, gB, bB, rF, gF, bF
					rB = GetConVar( MiniHUD.PrefixColor .. convar .. "_back_r" ):GetInt( )
					gB = GetConVar( MiniHUD.PrefixColor .. convar .. "_back_g" ):GetInt( )
					bB = GetConVar( MiniHUD.PrefixColor .. convar .. "_back_b" ):GetInt( )
					rF = GetConVar( MiniHUD.PrefixColor .. convar .. "_fill_r" ):GetInt( )
					gF = GetConVar( MiniHUD.PrefixColor .. convar .. "_fill_g" ):GetInt( )
					bF = GetConVar( MiniHUD.PrefixColor .. convar .. "_fill_b" ):GetInt( )
					print( rB, gB, bB, rF, gF, bF )
					return { Color( rB, gB, bB ), Color( rF, gF, bF ) }
				else
					return MiniHUD.ColorsDefault[convar]
				end
			end
		else
			return false
		end
	end
end



--[[    SETTINGS BLOCK    ]]
do

	hook.Add( "TTTSettingsTabs", "ZeagaMiniHUDSettingsTab", function( tabs )

		local settings = vgui.Create( "DPanelList", tabs )

			settings:StretchToParent( 0, 0, 0, 0 )
			settings:EnableVerticalScrollbar( true )
			settings:SetPadding( 10 )
			settings:SetSpacing( 10 )

			local cat_interface = vgui.Create( "DForm", settings )
				cat_interface:SetName( "Interface settings" )
				cat_interface:CheckBox( "Display avatar on HUD", MiniHUD.Prefix .. "avatar" )
				cat_interface:CheckBox( "Display values", MiniHUD.Prefix .. "value" )
				cat_interface:CheckBox( "Display percentage sign", MiniHUD.Prefix .. "percent" )
				cat_interface:CheckBox( "Display bar labels", MiniHUD.Prefix .. "label" )
				cat_interface:CheckBox( "Smooth bar movement", MiniHUD.Prefix .. "lerp" )
			settings:AddItem( cat_interface )

			local cat_color

			if MiniHUD:CanColor( ) then
				cat_color = vgui.Create( "DCollapsibleCategory", settings )
				cat_color:SetLabel( "Color settings" )
				local col = settings:GetWide( ) / 2 - 40
				local grid = vgui.Create( "DGrid", cat_color )
				grid:SetPos( 10, 30 )
				grid:SetCols( 2 )
				grid:SetColWide( col )

				local buthf, buthb, butsf, butsb, butaf, butab, butpf, butpb, reset
				buthf = vgui.Create( "DButton" )
					buthf:SetText( "Health - Fill" )
					buthf:SetSize( col - 10, 20 )
					buthf.DoClick = function( ) MiniHUD.ColorPanel( 0, 0 ) end
				buthb = vgui.Create( "DButton" )
					buthb:SetText( "Health - Background" )
					buthb:SetSize( col - 10, 20 )
					buthb.DoClick = function( ) MiniHUD.ColorPanel( 0, 1 ) end
				if MiniHUD.GetStamina( ) != false then
					butsf = vgui.Create( "DButton" )
						butsf:SetText( "Stamina - Fill" )
						butsf:SetSize( col - 10, 20 )
						butsf.DoClick = function( ) MiniHUD.ColorPanel( 1, 0 ) end
					butsb = vgui.Create( "DButton" )
						butsb:SetText( "Stamina - Background" )
						butsb:SetSize( col - 10, 20 )
						butsb.DoClick = function( ) MiniHUD.ColorPanel( 1, 1 ) end
				end
				butaf = vgui.Create( "DButton" )
					butaf:SetText( "Ammo - Fill" )
					butaf:SetSize( col - 10, 20 )
					butaf.DoClick = function( ) MiniHUD.ColorPanel( 2, 0 ) end
				butab = vgui.Create( "DButton" )
					butab:SetText( "Ammo - Background" )
					butab:SetSize( col - 10, 20 )
					butab.DoClick = function( ) MiniHUD.ColorPanel( 2, 1 ) end
				if MiniHUD.GetPunch( ) != false then
					butpf = vgui.Create( "DButton" )
						butpf:SetText( "Punch - Fill" )
						butpf:SetSize( col - 10, 20 )
						butpf.DoClick = function( ) MiniHUD.ColorPanel( 3, 0 ) end
					butpb = vgui.Create( "DButton" )
						butpb:SetText( "Punch - Background" )
						butpb:SetSize( col - 10, 20 )
						butpb.DoClick = function( ) MiniHUD.ColorPanel( 3, 1 ) end
				end
				reset = vgui.Create( "DButton" )
					reset:SetText( "Default Colors" )
					reset:SetSize( ( col * 2 ) - 10, 20 )
					reset.DoClick = function( ) MiniHUD.VarsReset( ) end

				grid:AddItem( buthf )
				grid:AddItem( buthb )
				if MiniHUD.GetStamina( ) != false then
					grid:AddItem( butsf )
					grid:AddItem( butsb )
				end
				grid:AddItem( butaf )
				grid:AddItem( butab )
				if MiniHUD.GetPunch( ) != false then
					grid:AddItem( butpf )
					grid:AddItem( butpb )
				end
				grid:AddItem( reset )
			else
				cat_color = vgui.Create( "DForm", settings )
				cat_color:SetName( "Color settings" )
				cat_color:Help( "Donate to customize MiniHUD's colors!" )
			end

			settings:AddItem( cat_color )

		tabs:AddSheet( "MiniHUD settings", settings, "icon16/color_wheel.png", false, false, "Customize MiniHUD's appearance" )

	end )

	function MiniHUD.ColorPanel( stat, layer )
		if stat == 1 then stat = "stamina_"
		elseif stat == 2 then stat = "ammo_"
		elseif stat == 3 then stat = "punch_"
		else stat = "health_" end

		if layer == 0 then layer = "fill_"
		else layer = "back_" end

		local prefix = MiniHUD.PrefixColor .. stat .. layer

		local Frame = vgui.Create( "DFrame" )
			Frame:SetSize( 267, 186 )
			Frame:Center( )
			Frame:MakePopup( )

		local Mixer = vgui.Create( "DColorMixer", Frame )
			Mixer:Dock( FILL )
			Mixer:SetPalette( false )
			Mixer:SetAlphaBar( false )
			Mixer:SetWangs( true )
			Mixer:SetConVarR( prefix .. 'r' )
			Mixer:SetConVarG( prefix .. 'g' )
			Mixer:SetConVarB( prefix .. 'b' )
	end
end



--[[    DRAW BLOCK    ]]
do
	local table = table
	local surface = surface
	local draw = draw
	local math = math
	local string = string

	local GetLang = LANG.GetUnsafeLanguageTable

	local fontname = "DermaLarge"

	surface.CreateFont( "RoleState", { font = fontname, size = 28, weight = 1000 } )
	surface.CreateFont( "TimeLeft", { font = fontname, size = 24, weight = 800 } )
	surface.CreateFont( "BarLabel", { font = fontname, size = 24, weight = 750 } )

	MiniHUD.AvatarPanel = MiniHUD.AvatarPanel or nil
	MiniHUD.AvatarImage = MiniHUD.AvatarImage or nil
	local ttt_health_label = CreateClientConVar( "ttt_health_label", "0", true )

	if not delta then delta = { ammo = 0, health = 0, stamina = 0, punch = 0 } end

	function MiniHUD.DrawBaseHUD( client )
		local L = GetLang( ) -- for fast direct table lookups
		if not client then client = LocalPlayer( ) end

		local clientSpec = ( not client:Alive( ) ) or client:Team( ) == TEAM_SPEC

		local var_avatar = MiniHUD.VarsGet( "avatar" )
		local var_value = MiniHUD.VarsGet( "value" )
		local var_percent = MiniHUD.VarsGet( "percent" )
		local var_label = MiniHUD.VarsGet( "label" )
		local var_lerp = MiniHUD.VarsGet( "lerp" )

		-- Various locals we need to know to put stuff in places
		local back_margin_x = 6
		local back_margin_y = 6
		local padding = 6
		local status_width = 350
		local status_height = 35
		local status_y = 0
		local bar_height = 27

		local bars
		if var_avatar then
			bars = 3
		elseif clientSpec then
			if MiniHUD.GetPunch( ) != false then
				bars = 1
			else
				bars = 0
			end
		else
			if MiniHUD.GetStamina( ) != false then
				bars = 3
			else
				bars = 2
			end
		end

		local back_height = 0
		if bars > 0 then
			back_height = ( padding * ( bars + 1 ) ) + ( bar_height * bars )
		end

		local avatar_size = 0
		if var_avatar then avatar_size = ( back_height + status_height ) - padding * 2 end

		local status_x = 0
		if var_avatar then status_x = avatar_size + padding * 2 end
		local back_width = status_width
		if var_avatar then back_width = avatar_size + padding * 2 + back_width end
		local back_x = back_margin_x
		local back_y = ScrH( ) - back_height - back_margin_y - status_height

		local bar_x = back_x + padding
		if var_avatar then bar_x = bar_x + padding * 2 + avatar_size end
		local bar_width = status_width - padding * 2

		---

		local col = MiniHUD.ColorsMisc.innocent
		local text = L[ client:GetRoleStringRaw( ) ]
		if GAMEMODE.round_state != ROUND_ACTIVE or clientSpec then
			col = MiniHUD.ColorsMisc.spectator
			text = L[ MiniHUD.RoundState( GAMEMODE.round_state ) ]
		elseif client:GetTraitor( ) then
			col = MiniHUD.ColorsMisc.traitor
		elseif client:GetDetective( ) then
			col = MiniHUD.ColorsMisc.detective
		end

		status_y = 0

		-- Blurry background
		MiniHUD.DrawBlurredRect( back_x, back_y, back_width, status_height + back_height, 3, 1, 255 )
		surface.SetDrawColor( MiniHUD.ColorsMisc.background )
		surface.DrawRect( back_x, back_y, back_width, status_height + back_height )

		-- You've got some red on you
		surface.SetDrawColor( col )
		if var_avatar then surface.DrawRect( back_x, back_y, 2 * padding + avatar_size, 2 * padding + avatar_size ) end
		surface.DrawRect( back_x, back_y + status_y, back_width, status_height )

		-- Draw round state if spectating or round is inactive, otherwise draw role
		-- All uppercase because swag
		MiniHUD.ShadowedText( string.upper( text ), "RoleState", back_x + status_x + padding, back_y + status_y + status_height / 2 - 1, COLOR_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		local value_suffix = ""
		if var_percent then value_suffix = "%" end
		if not clientSpec then

			-- Health
			delta.health = Lerp( 0.1, delta.health, math.Clamp( client:Health( ) / 100, 0, 1 ) )
			local health = math.max( 0, client:Health( ) / 100 )
			local bar_y = back_y + status_height + padding
			if var_lerp then
				MiniHUD.PaintBar( bar_x, bar_y, bar_width, bar_height, MiniHUD.VarsGet( "health", "back" ), MiniHUD.VarsGet( "health", "fill" ), delta.health )
			else
				MiniHUD.PaintBar( bar_x, bar_y, bar_width, bar_height, MiniHUD.VarsGet( "health", "back" ), MiniHUD.VarsGet( "health", "fill" ), health )
			end
			local text_y = bar_y + bar_height / 2 - 1
			if var_value then MiniHUD.ShadowedText( tostring( health * 100 .. value_suffix ), "BarLabel", bar_x + bar_width - padding, text_y, COLOR_WHITE, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER ) end
			if var_label then
				if ttt_health_label:GetBool( ) then
					MiniHUD.ShadowedText( string.upper( L[ util.HealthToString( health * 100 ) ] ), "BarLabel", bar_x + padding, text_y, COLOR_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				else
					MiniHUD.ShadowedText( string.upper( L[ "health" ] ), "BarLabel", bar_x + padding, text_y, COLOR_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				end
			end

			-- Stamina
			if MiniHUD.GetStamina( ) != false then
				delta.stamina = Lerp( 0.1, delta.stamina, math.Clamp( MiniHUD.GetStamina( ), 0, 1 ) )
				local stamina = math.Clamp( MiniHUD.GetStamina( ), 0, 1 )
				bar_y = bar_y + padding + bar_height
				if var_lerp then
					MiniHUD.PaintBar( bar_x, bar_y, bar_width, bar_height, MiniHUD.VarsGet( "stamina", "back" ), MiniHUD.VarsGet( "stamina", "fill" ), delta.stamina )
				else
					MiniHUD.PaintBar( bar_x, bar_y, bar_width, bar_height, MiniHUD.VarsGet( "stamina", "back" ), MiniHUD.VarsGet( "stamina", "fill" ), stamina )
				end
				local text_y = bar_y + bar_height / 2 - 1
				if var_value then MiniHUD.ShadowedText( tostring( math.floor( stamina * 100 ) .. value_suffix ), "BarLabel", bar_x + bar_width - padding, bar_y + bar_height / 2, COLOR_WHITE, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER ) end
				if var_label then MiniHUD.ShadowedText( string.upper( L[ "stamina" ] ), "BarLabel", bar_x + padding, text_y, COLOR_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER ) end
			end

			-- Ammo (inefficient, needs streamlining)
			local tempweapon = client:GetActiveWeapon( ).Primary
			if tempweapon then
				local ammo_clip, ammo_max, ammo_inv = MiniHUD.GetAmmo( client )
				local tempammo = math.Clamp( ammo_clip / ammo_max, 0, 1 )
				if tempweapon != delta.weapon then
					delta.ammo = tempammo
				else
					delta.ammo = Lerp( 0.1, delta.ammo, tempammo )
				end
				delta.weapon = tempweapon
			else
				delta.weapon = nil
			end
			if client:GetActiveWeapon( ).Primary then
				local ammo_clip, ammo_max, ammo_inv = MiniHUD.GetAmmo( client )
				if ammo_clip > -1 then
					bar_y = bar_y + padding + bar_height
					if var_lerp then
						MiniHUD.PaintBar( bar_x, bar_y, bar_width, bar_height, MiniHUD.VarsGet( "ammo", "back" ), MiniHUD.VarsGet( "ammo", "fill" ), delta.ammo )
					else
						MiniHUD.PaintBar( bar_x, bar_y, bar_width, bar_height, MiniHUD.VarsGet( "ammo", "back" ), MiniHUD.VarsGet( "ammo", "fill" ), ammo_clip / ammo_max )
					end
					local text_y = bar_y + bar_height / 2 - 1
					if var_value then MiniHUD.ShadowedText( string.format( "%i + %02i", ammo_clip, ammo_inv ), "BarLabel", bar_x + bar_width - padding, text_y, COLOR_WHITE, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER ) end
					if var_label then MiniHUD.ShadowedText( string.upper( L[ "ammo" ] ), "BarLabel", bar_x + padding, text_y, COLOR_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER ) end
				end
			end
		else
			if MiniHUD.GetPunch( ) != false then
				delta.punch = Lerp( 0.1, delta.punch, math.Clamp( MiniHUD.GetPunch( ), 0, 1 ) )
				local temppunch = 0
				local punch = 0
				local target = client:GetObserverTarget( )
				if IsValid( target ) and target:GetNWEntity( "spec_owner", nil ) == client then
					punch = math.Clamp( MiniHUD.GetPunch( ), 0, 1 )
					temppunch = delta.punch
				end
				local bar_y = back_y + status_height + padding
				if var_lerp then
					MiniHUD.PaintBar( bar_x, bar_y, bar_width, bar_height, MiniHUD.VarsGet( "punch", "back" ), MiniHUD.VarsGet( "punch", "fill" ), temppunch )
				else
					MiniHUD.PaintBar( bar_x, bar_y, bar_width, bar_height, MiniHUD.VarsGet( "punch", "back" ), MiniHUD.VarsGet( "punch", "fill" ), punch )
				end
				local text_y = bar_y + bar_height / 2 - 1
				if var_value then MiniHUD.ShadowedText( tostring( math.floor( punch * 100 ) .. value_suffix ), "BarLabel", bar_x + bar_width - padding, bar_y + bar_height / 2, COLOR_WHITE, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER ) end
				if var_label then MiniHUD.ShadowedText( string.upper( L.punch_title ), "BarLabel", bar_x + padding, text_y, COLOR_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER ) end
			end
		end

		-- Draw round/prep/post time remaining
		local is_haste = HasteMode( ) and GAMEMODE.round_state == ROUND_ACTIVE
		local is_traitor = client:IsActiveTraitor( )
		local endtime = GetGlobalFloat( "ttt_round_end", 0 ) - CurTime( )

		local text
		local font = "TimeLeft"
		local red = false
		local rx = back_x + back_width - padding
		local ry = back_y + status_y + status_height / 2 - 1

		if is_haste then
			local hastetime = GetGlobalFloat( "ttt_haste_end", 0 ) - CurTime( )
			if clientSpec then
				text = util.SimpleTime( math.max( 0, endtime ), "%02i:%02i" )
			else
				if hastetime < 0 then
					if ( not is_traitor ) or ( math.ceil( CurTime( ) ) % 7 <= 2 ) then
						text = L.overtime
					else
						text = util.SimpleTime( math.max( 0, endtime ), "%02i:%02i" )
						red = true
					end
				else
					local t = hastetime
					if is_traitor and math.ceil( CurTime( ) ) % 6 < 2 and endtime != hastetime then
						t = endtime
						red = true
					end
					text = util.SimpleTime( math.max( 0, t ), "%02i:%02i" )
				end
			end
		else
			text = util.SimpleTime( math.max( 0, endtime ), "%02i:%02i" )
		end

		if red then
			MiniHUD.ShadowedText( text, font, rx, ry, COLOR_RED, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, COLOR_BLACK )
		else
			MiniHUD.ShadowedText( text, font, rx, ry, COLOR_WHITE, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
		end

		if IsValid( client ) && !IsValid( MiniHUD.AvatarImage ) && !IsValid( MiniHUD.AvatarPanel ) && var_avatar then

			local sizes = { 128, 84, 64, 32, 16 } -- reversed because we want the reversed list, ok?
			local size = 184

			for _, v in pairs( sizes ) do
				if avatar_size <= v then size = v end
			end

			MiniHUD.AvatarPanel = vgui.Create( "DPanel" )
			MiniHUD.AvatarPanel:SetPos( back_x + padding, back_y + padding )
			MiniHUD.AvatarPanel:SetSize( avatar_size, avatar_size )
			MiniHUD.AvatarPanel:ParentToHUD( )

			MiniHUD.AvatarImage = vgui.Create( "AvatarImage", MiniHUD.AvatarPanel )
			MiniHUD.AvatarImage:SetSize( avatar_size, avatar_size )
			MiniHUD.AvatarImage:SetPos( 0, 0 )
			MiniHUD.AvatarImage:SetPlayer( client, size )

		end

		if IsValid( MiniHUD.AvatarPanel ) then
			if var_avatar then
				if !MiniHUD.AvatarPanel:IsVisible( ) then
					MiniHUD.AvatarPanel:SetVisible( true )
				end
			else
				if MiniHUD.AvatarPanel:IsVisible( ) then
					MiniHUD.AvatarPanel:SetVisible( false )
				end
			end
		end

	end

	function MiniHUD.DrawSpecHUD( )
		if not client then client = LocalPlayer( ) end
		MiniHUD.DrawBaseHUD( client )
		local tgt = client:GetObserverTarget( )
		if IsValid( tgt ) and tgt:IsPlayer( ) then
			MiniHUD.ShadowedText( tgt:Nick( ), "RoleState", ScrW( ) / 2, ScrH( ) - 20, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end

	function MiniHUD.DrawLiveHUD( client )
		if not client then client = LocalPlayer( ) end
		MiniHUD.DrawBaseHUD( client )
	end
end

function GM:HUDPaint( )
	local client = LocalPlayer( )

	if hook.Call( "HUDShouldDraw", GAMEMODE, "TTTTargetID" ) then
		hook.Call( "HUDDrawTargetID", GAMEMODE )
	end

	if hook.Call( "HUDShouldDraw", GAMEMODE, "TTTMStack" ) then
		MSTACK:Draw( client )
	end

	if ( not client:Alive( ) ) or client:Team( ) == TEAM_SPEC then
		if hook.Call( "HUDShouldDraw", GAMEMODE, "TTTSpecHUD" ) then
			MiniHUD.DrawSpecHUD( client )
		end
		return
	end

	if hook.Call( "HUDShouldDraw", GAMEMODE, "TTTRadar" ) then
		RADAR:Draw( client )
	end

	if hook.Call( "HUDShouldDraw", GAMEMODE, "TTTTButton" ) then
		TBHUD:Draw( client )
	end

	if hook.Call( "HUDShouldDraw", GAMEMODE, "TTTWSwitch" ) then
		WSWITCH:Draw( client )
	end

	if hook.Call( "HUDShouldDraw", GAMEMODE, "TTTVoice" ) then
		VOICE.Draw( client )
	end

	if hook.Call( "HUDShouldDraw", GAMEMODE, "TTTDisguise" ) then
		DISGUISE.Draw( client )
	end

	if hook.Call( "HUDShouldDraw", GAMEMODE, "TTTPickupHistory" ) then
		hook.Call( "HUDDrawPickupHistory", GAMEMODE )
	end

	-- Draw bottom left info panel
	if hook.Call( "HUDShouldDraw", GAMEMODE, "TTTInfoPanel" ) then
		MiniHUD.DrawLiveHUD( client )
	end
end

if not MiniHUD.Initialized then
	MiniHUD.Log( "This server is running MiniHUD v2.1.2" )
	MiniHUD.Inlog( "Written by Zeaga ( STEAM_0:1:11319794 ) for Zeaga's Community and CrimePanda" )
	MiniHUD.Inlog( "Some modifications made to accommodate for the needs of Questionable Ethics" )
	MiniHUD.Inlog( "Based on a design by Infideon ( STEAM_0:0:38309588 ) created for Zeaga's Community" )
else
	MiniHUD.Log( "Reinitialized" )
end

MiniHUD.Initialized = true