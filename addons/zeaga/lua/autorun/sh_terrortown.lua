-- Written by Zeaga for Zeaga's Community, CrimePanda TTT, and Questionable Ethics
-- http://steamcommunity.com/id/zeaga

local plymeta = FindMetaTable( "Player" )
function plymeta:IsDonor( ) return self:IsSuperAdmin( ) end
if true then return end
local Settings = {
	TitleHeader = "Rank",
	TitleWidth = 100,
	TimeHeader = "Playtime",
	TimeWidth = 100,
}

hook.Add( "TTTPrepareRound", "ZeagaPrepareRound", function( )
end )

hook.Add( "TTTBeginRound", "ZeagaBeginRound", function( )
end )

hook.Add( "TTTEndRound", "ZeagaEndRound", function( result )
end )

if CLIENT then

	hook.Add( "TTTScoreboardColorForPlayer", "ZeagaScoreboardColorForPlayer", function( ply )
		if ply:IsUserGroup( "exmember" ) and LocalPlayer( ):IsAdmin( ) then
			return Color( 191, 191, 191 )
		end
		local status = ply:GetFriendStatus( )
		if status == "friend" then
			return Color( 76, 175, 80 )
		elseif status == "requested" then
			return Color( 255, 193, 7 )
		elseif status == "blocked" then
			return Color( 244, 67, 54 )
		end
		--return ZeagaDB.GetColor( ply:GetUserGroup( ) )
	end )

	hook.Add( "TTTScoreboardColumns", "ZeagaScoreboardColumns", function( pnl )
		--[[pnl:AddColumn( Settings.TitleHeader, function( ply, label )
			local groupColor = ZeagaDB.GetColor( ply:GetUserGroup( ) )
			
			if groupColor then
				label:SetTextColor( groupColor )
			end
			
			return ZeagaDB.GetTitle( ply:GetUserGroup( ) )
		end, Settings.TitleWidth )]]
		--[[pnl:AddColumn( Settings.TimeHeader, function( ply, label )
			return timeToHM( ply:GetTotalTime( ) )
		end, Settings.TimeWidth )]]
	end )

	hook.Add( "TTTScoreboardMenu", "ZeagaScoreboardMenu", function( menu )
		print( true )
	end )

	hook.Add( "TTTPlayerColor", "ZeagaPlayerColor", function( )
	end )

	hook.Add( "TTTSettingsTabs", "ZeagaSettingsTabs", function( dtabs )
	end )

	hook.Add( "TTTEquipmentTabs", "ZeagaEquipmentTabs", function( dtabs )
	end )

end