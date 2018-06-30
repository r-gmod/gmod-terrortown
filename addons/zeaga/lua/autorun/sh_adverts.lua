-- Written by Zeaga for Zeaga's Community, CrimePanda TTT, and Questionable Ethics
-- http://steamcommunity.com/id/zeaga

local adverts = { }

local function NewAdvert( advert, color )
	adverts[#adverts+1] = { advert, color }
end

local ColorSupport = Color( 255, 234, 0 )
local ColorWarning = Color( 255, 23, 68 )
local ColorAlert = Color( 41, 121, 255 )

NewAdvert( "Join the Steam group at steamcommunity.com/groups/CrimePanda", ColorSupport )

NewAdvert( "Read the rules with !motd", ColorWarning )

--NewAdvert( "All addons aside from gamemode, mapvote, and administration addons were made by or for CrimePanda TTT", ColorAlert )

NewAdvert( "Hit I to access your inventory and unbox crates!", ColorAlert )

NewAdvert( "Have you collected your daily reward?", ColorAlert )

NewAdvert( "Double tap W to sprint!", ColorAlert )

--[[NewAdvert( {
	"Like the server?  Donate at donate.zeaga.me",
	"Minimum for rank is $10 USD.  Leave your SteamID in the note!"
}, ColorSupport )]]

NewAdvert( "Problem?  Suggestion?  Contact Sm00th or Zeaga on Steam.", ColorWarning )

--NewAdvert( "Member rank is given automatically once you have 12 hours of playtime logged.", ColorAlert )

local bitCount = 32

for i = 1, 31 do
	if #adverts - 1 < 2^i then
		bitCount = i
	end
end

if SERVER then
	util.AddNetworkString( "zeagaAdvertNet" )
	
	local advertCount = #adverts

	function SendAdvert( )
		net.Start( "zeagaAdvertNet" )
			net.WriteUInt( advertCount % #adverts, bitCount )
		net.Broadcast( )
		advertCount = advertCount + 1
	end
	
	hook.Add( "Initialize", "AdvertInitialize", function( )
		timer.Create( "zeagaAdvertTimer", 180, 0, function( )
			SendAdvert( )
		end )
	end )
end

if CLIENT then
	function PrintAdvert( advert )
		if type( advert[1] ) == "table" then
			for i = 1, #advert[1] do
				chat.AddText( advert[2], advert[1][i] )
			end
		else
			chat.AddText( advert[2], advert[1] )
		end
	end
	
	net.Receive( "zeagaAdvertNet", function( )
		PrintAdvert( adverts[ net.ReadUInt( bitCount ) + 1 ] )
	end )
end